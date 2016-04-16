package by.ishaban.foothold {

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import test.Root;

	public class UIComponent extends ValidationComponent {
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
		 * Do we need to round coordinates to floor.
		 */
		protected var _useRoundCoordinates: Boolean = true;
		/**
		 * Спорная фича
		 * Do we need to dispatch custom button events, like: rollOver, rollOut, click
		 */
		protected var _isButtonBehaviour: Boolean;
		/**
		 * @private
		 * Internal width.
		 */
		protected var _width: Number = 0;
		/**
		 * @private
		 * Internal height.
		 * */
		protected var _height: Number = 0;
		/** @private */
		protected var _originalWidth: Number = 0;
		/** @private */
		protected var _originalHeight: Number = 0;
		private var _depth: int;


		public function UIComponent(view: Sprite) {
			preInitialize();
			super(view);
		}


		override public function get depth(): int {
			return _depth;
		}


		final public function get actualWidth(): Number {
			return _view.width;
		}


		final public function get actualHeight(): Number {
			return _view.height;
		}


		final public function get actualScaleX(): Number {
			return _view.scaleX;
		}


		final public function get actualScaleY(): Number {
			return _view.scaleY;
		}


		public function get useRoundCoordinates(): Boolean {
			return _useRoundCoordinates;
		}


		public function set useRoundCoordinates(value: Boolean): void {
			_useRoundCoordinates = value;
			if (value) {
				move(x, y);
			}
		}


//todo: implement!
//		override public function get enabled(): Boolean {
//			return super.enabled;
//		}
//
//
//		override public function set enabled(value: Boolean): void {
//			if (value == super.enabled) {
//				return;
//			}
//
//			super.enabled = value;
//			tabEnabled = (!enabled) ? false : _focusable;
//			mouseEnabled = value;
//		}


		public function get isButtonBehaviour(): Boolean {
			return _isButtonBehaviour;
		}


		public function set isButtonBehaviour(value: Boolean): void {
			_isButtonBehaviour = value;
			buttonMode = value;
			if (_isButtonBehaviour) {
				addViewListener(MouseEvent.ROLL_OVER, dispatchEvent);
				addViewListener(MouseEvent.ROLL_OUT, dispatchEvent);
				addViewListener(MouseEvent.CLICK, dispatchEvent);
				addViewListener(MouseEvent.MOUSE_DOWN, dispatchEvent);
			} else {
				removeViewListener(MouseEvent.ROLL_OVER, dispatchEvent);
				removeViewListener(MouseEvent.ROLL_OUT, dispatchEvent);
				removeViewListener(MouseEvent.CLICK, dispatchEvent);
				removeViewListener(MouseEvent.MOUSE_DOWN, dispatchEvent);
			}
		}


		public function get name(): String {
			return _view.name;
		}


		public function get x(): Number {
			return _view.x;
		}


		/**
		 * todo: возможно стоит убрать и использовать move(x,y)
		 * @param value
		 */
		public function set x(value: Number): void {
			move(value, y);
		}


		public function get y(): Number {
			return _view.y;
		}


		/**
		 * todo: возможно стоит убрать и использовать move(x,y)
		 * @param value
		 */
		public function set y(value: Number): void {
			move(x, value);
		}


		public function get scaleX(): Number {
			return _view.scaleX;
		}


		/**
		 * todo: возможно стоит убрать и использовать setScale(scaleX,scaleY)
		 * @param value
		 */
		public function set scaleX(value: Number): void {
			setScale(value, scaleY);
		}


		public function get scaleY(): Number {
			return _view.scaleY;
		}


		/**
		 * todo: возможно стоит убрать и использовать setScale(scaleX,scaleY)
		 * @param value
		 */
		public function set scaleY(value: Number): void {
			setScale(scaleX, value);
		}


		public function get width(): Number {
			return _view.width;
		}


		/**
		 * todo: возможно стоит убрать и использовать setSize(width,height)
		 * @param value
		 */
		public function set width(value: Number): void {
			setSize(value, height);
		}


		public function get height(): Number {
			return _view.height;
		}


		/**
		 * todo: возможно стоит убрать и использовать setSize(width,height)
		 * @param value
		 */
		public function set height(value: Number): void {
			setSize(width, value);
		}


		public function get alpha(): Number {
			return _view.alpha;
		}


		public function set alpha(value: Number): void {
			_view.alpha = value;
		}


		public function get visible(): Boolean {
			return _view.visible;
		}


		public function set visible(value: Boolean): void {
			if (visible == value) {
				return;
			}
			_view.visible = value;
		}


		public function get mouseEnabled(): Boolean {
			return _view.mouseEnabled;
		}


		public function set mouseEnabled(value: Boolean): void {
			_view.mouseEnabled = value;
		}


		public function get mouseChildren(): Boolean {
			return _view.mouseChildren;
		}


		public function set mouseChildren(value: Boolean): void {
			_view.mouseChildren = value;
		}


		public function get buttonMode(): Boolean {
			return _view.buttonMode;
		}


		public function set buttonMode(value: Boolean): void {
			_view.buttonMode = value;
		}


		public function get rotation(): Number {
			return _view.rotation;
		}


		public function set rotation(value: Number): void {
			_view.rotation = value;
		}


		public function get parent(): DisplayObjectContainer {
			return _view && _view.parent;
		}


		override protected function initialize(): void {
			addViewListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addViewListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);

			super.initialize();
		}


		override public function dispose(): void {
			removeViewListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			removeViewListener(Event.ADDED_TO_STAGE, onAddedToStage);

			super.dispose();
		}


		/**
		 * Sets the width and height of the component at the same time using internal sizing mechanisms.
		 * @param width The new width of the component.
		 * @param height The new height of the component.
		 */
		public function setSize(width: Number, height: Number): void {
			if (_width == width && _height == height) {
				return;
			}
			_width = width;
			_height = height;
			invalidateSize();
		}


		public function move(xValue: Number, yValue: Number): void {
			var newX: Number = _useRoundCoordinates ? int(xValue) : xValue;
			var newY: Number = _useRoundCoordinates ? int(yValue) : yValue;
			if (newX == x && newY == y) {
				return;
			}
			// todo: invalidate?
			_view.x = newX;
			_view.y = newY;
		}


		/**
		 * Set component scale, if only first argument added, second will be the same.
		 * @param scaleOrScaleX
		 * @param scaleY
		 */
		public function setScale(scaleOrScaleX: Number, scaleY: Number = NaN): void {
			// todo: invalidate?
			if (isNaN(scaleY)) {
				_view.scaleX = _view.scaleY = scaleOrScaleX;
			} else {
				_view.scaleX = scaleOrScaleX;
				_view.scaleY = scaleY;
			}
			invalidateSize();
		}


		public function removeFromParent(dispose: Boolean = false): void {
			if (parent) {
				parent.removeChild(_view);
			}
			if (dispose) {
				this.dispose();
			}
		}


		protected function addStageListener(type: String, listener: Function, useCapture: Boolean = false, priority: int = 0): void {
			Root.stage.addEventListener(type, listener, useCapture, priority, true);
		}


		protected function removeStageListener(type: String, listener: Function, useCapture: Boolean = false): void {
			Root.stage.removeEventListener(type, listener, useCapture);
		}


		protected function addViewListener(type: String, listener: Function, useCapture: Boolean = false, priority: int = 0): void {
			_view.addEventListener(type, listener, useCapture, priority, true);
		}


		protected function removeViewListener(type: String, listener: Function, useCapture: Boolean = false): void {
			_view.removeEventListener(type, listener, useCapture);
		}


		protected function preInitialize(): void {
			// ABSTRACT
		}


		/**
		 * If you wish to validate something at startup, invalidate it here.
		 */
		protected function configUI(): void {
			// ABSTRACT
		}


		private function onRemovedFromStage(event: Event): void {
			_depth = -1;
		}


		private function onAddedToStage(event: Event): void {
			_depth = getDisplayObjectDepthFromStage(view);

			if (!_isInitialized) {
				_isInitialized = true;
				configUI();
			}
		}


	}
}
