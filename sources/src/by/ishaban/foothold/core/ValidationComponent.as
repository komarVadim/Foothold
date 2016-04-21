package by.ishaban.foothold.core {

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class ValidationComponent extends EventDispatcher implements IValidating {

		CONFIG::debug{
			private var _availableFlagsHash: uint;
		}


		/**
		 * Calculates how many levels deep the target object is on the display list,
		 * starting from the Starling stage. If the target object is the stage, the
		 * depth will be <code>0</code>. A direct child of the stage will have a
		 * depth of <code>1</code>, and it increases with each new level. If the
		 * object does not have a reference to the stage, the depth will always be
		 * <code>-1</code>, even if the object has a parent.
		 */
		protected static function getDisplayObjectDepthFromStage(target: DisplayObject): int {
			if (!target.stage) {
				return -1;
			}
			var count: int = 0;
			while (target.parent) {
				target = target.parent;
				count++;
			}
			return count;
		}


		/**
		 * @private
		 * Flag to indicate that the control is currently validating.
		 */
		protected var _isValidating: Boolean = false;
		protected var _validationManager: ValidationManager;
		protected var _isInitialized: Boolean = false;
		/**
		 * @private
		 */
		protected var _isDisposed: Boolean = false;
		protected var _view: Sprite;
		private var _invalidationMask: uint = InvalidationType.INVALIDATE_NONE;
		private var _delayedInvalidationMask: uint = InvalidationType.INVALIDATE_NONE;
		private var _depth: int = -1;


		public function ValidationComponent(view: Sprite) {
			CONFIG::debug{
				if (Object(this).constructor == ValidationComponent) {
					throw new IllegalOperationError("ValidationComponent is abstract class, please extend it.");
				}
			}
			_view = view;
			_validationManager = ValidationManager.getInstance();
			initialize();

			CONFIG::debug{
				checkFlags(InvalidationType.INVALIDATE_ALL, InvalidationType.INVALIDATE_DATA, InvalidationType.INVALIDATE_SIZE, InvalidationType.INVALIDATE_STATE);
			}
		}


		public function get view(): Sprite {
			return _view;
		}


		public function get depth(): int {
			return _depth;
		}


		public function dispose(): void {
			_view = null;
			_validationManager = null;
			_isDisposed = true;
		}


		/**
		 *
		 * @param flags
		 *
		 * TODO: i don't like it, but i didn't fount any easy way to declare compilation order,
		 * TODO: so i inline InvalidationType.INVALIDATE_ALL constant (( Need to find workaround
		 */
		public function invalidate(flags: uint = 1/*InvalidationType.INVALIDATE_ALL*/): void {
			CONFIG::debug{
				if ((flags & ~_availableFlagsHash) != 0) {
					throw new IllegalOperationError("You cannot validate flag that not available for " + this + " component. Please check flags in 'invalidate()' method above the stack.");
				}
			}
			var isAlreadyInvalid: Boolean = isInvalid();
			if (_isValidating) {
				_delayedInvalidationMask |= flags;
			} else {
				_invalidationMask |= flags;
			}
			// спорно, надо продумать, _validationManager нул только если мы уже задиспозились
//			if (!_validationManager || !_isInitialized) {
//				//we'll add this component to the queue later, after it has been
//				//added to the stage.
//				return;
//			}
			// по сути проверка isAlreadyInvalid уже есть в менеджере и один компонент не может добавиться дважды
			if (!isAlreadyInvalid) {
				_validationManager.add(this, false);
			}
		}


		/**
		 * Хочеться закрыть прямой доступ к этому методу, возможно через неймспейсы или как колбэк
		 */
		public function validate(): void {
			if (_isDisposed) {
				//disposed components have no reason to validate, but they may
				//have been left in the queue.
				return;
			}
//			if (!_isInitialized) {
//				if (_isInitializing) {
//					//initializing components cannot validate until they've
//					//finished initializing. we'll have to wait.
//					return;
//				}
//				initializeInternal();
//			}
			if (!isInvalid()) {
				return;
			}
			if (_isValidating) {
				//we were already validating, and something else told us to
				//validate. that's bad...
				//...so we'll just try to do it later
				_validationManager.add(this, true);
				return;
			}
			_isValidating = true;
			draw();
			_invalidationMask = _delayedInvalidationMask;
			_delayedInvalidationMask = InvalidationType.INVALIDATE_NONE;
			_isValidating = false;
//			if (!_hasValidated) {
//				_hasValidated = true;
//				dispatchEvent(new Event(FeathersEventType.CREATION_COMPLETE));
//			}
		}


		public function invalidateSize(): void {
			invalidate(InvalidationType.INVALIDATE_SIZE);
		}


		public function invalidateData(): void {
			invalidate(InvalidationType.INVALIDATE_DATA);
		}


		public function invalidateState(): void {
			invalidate(InvalidationType.INVALIDATE_STATE);
		}


		protected function addViewListener(type: String, listener: Function, useCapture: Boolean = false, priority: int = 0): void {
			_view.addEventListener(type, listener, useCapture, priority, true);
		}


		protected function removeViewListener(type: String, listener: Function, useCapture: Boolean = false): void {
			_view.removeEventListener(type, listener, useCapture);
		}


		/**
		 * Debug function to ensure that all flags values are unique.
		 *
		 * @param flags
		 */
		CONFIG::debug
		protected function checkFlags(...flags): void {
			while (flags.length != 0) {
				var flag: * = flags.shift();
				if (_availableFlagsHash & flag) {
					throw new IllegalOperationError("Validation flags overlap detected, please check flags with value: " + flag + ".");
				}
				_availableFlagsHash |= flag;
			}
		}


		protected function initialize(): void {
			addViewListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addViewListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);

			if (_view.stage) {
				onAddedToStage();
			}
		}


		protected function draw(): void {
			// ABSTRACT
		}


		/**
		 * Indicates whether the control is pending validation or not. By
		 * default, returns <code>true</code> if any invalidation flag has been
		 * set. If you pass in a specific flag, returns <code>true</code> only
		 * if that flag has been set (others may be set too, but it checks the
		 * specific flag only. If all flags have been marked as invalid, always
		 * returns <code>true</code>.
		 *
		 * TODO: i don't like it, but i didn't fount any easy way to declare compilation order,
		 * TODO: so i inline InvalidationType.INVALIDATE_ALL constant (( Need to find workaround
		 */
		protected function isInvalid(flags: uint = 1/*InvalidationType.INVALIDATE_ALL*/): Boolean {
			return _invalidationMask & flags ||
			       _invalidationMask == InvalidationType.INVALIDATE_ALL ||
			       (flags & InvalidationType.INVALIDATE_ALL && _invalidationMask != InvalidationType.INVALIDATE_NONE);
		}


		private function onRemovedFromStage(event: Event): void {
			_depth = -1;
		}


		private function onAddedToStage(event: Event = null): void {
			_depth = getDisplayObjectDepthFromStage(view);
		}
	}
}
