package by.ishaban.foothold.core {

	import flash.display.Stage;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;

	public class ValidationManager {

		protected static var _instance: ValidationManager;
		protected static var _creationAvailable: Boolean;


		public static function getInstance(): ValidationManager {
			return _instance;
		}


		public static function initialize(stage: Stage): void {
			if (_instance) {
				// TODO: throw Error
			} else {
				_creationAvailable = true;
				_instance = new ValidationManager();
				_instance._stage = stage;
				_creationAvailable = false;
			}
		}


		public static function dispose(): void {
			_instance.dispose();
			_instance = null;
		}


		/**
		 * @private
		 */
		protected static function queueSortFunction(first: IValidating, second: IValidating): int {
			var difference: int = second.depth - first.depth;
			if (difference > 0) {
				return -1;
			}
			else if (difference < 0) {
				return 1;
			}
			return 0;
		}


		protected var _delayedQueue: Vector.<IValidating> = new <IValidating>[];
		protected var _queue: Vector.<IValidating> = new <IValidating>[];
		protected var _isValidating: Boolean;
		protected var _isListening: Boolean;
		protected var _stage: Stage;


		public function ValidationManager() {
			if (!_creationAvailable) {
				throw new IllegalOperationError("It is singleton class, do not try to initialize it out of existing API");
			}
		}


		public function dispose(): void {
			_stage.removeEventListener(Event.ENTER_FRAME, handleValidation);
			_stage.removeEventListener(Event.RENDER, handleValidation);
			_stage = null;

			_instance = null;
		}


		public function add(control: IValidating, delayIfValidating: Boolean): void {
			var currentQueue: Vector.<IValidating> = _isValidating && delayIfValidating ? _delayedQueue : _queue;
			if (currentQueue.indexOf(control) >= 0) {
				//already queued
				return;
			}
			var queueLength: int = currentQueue.length;
			if (_isValidating && currentQueue == _queue) {
				//special case: we need to keep it sorted
				var depth: int = control.depth;

				//we're traversing the queue backwards because it's
				//significantly more likely that we're going to push than that
				//we're going to splice, so there's no point to iterating over
				//the whole queue
				for (var i: int = queueLength - 1; i >= 0; i--) {
					var otherControl: IValidating = IValidating(currentQueue[i]);
					var otherDepth: int = otherControl.depth;
					//we can skip the overhead of calling queueSortFunction and
					//of looking up the value we've already stored in the depth
					//local variable.
					if (depth >= otherDepth) {
						break;
					}
				}
				//add one because we're going after the last item we checked
				//if we made it through all of them, i will be -1, and we want 0
				i++;
				currentQueue.splice(i, 0, control);
			}
			else {
				//faster than push() because push() creates a temporary rest
				//Array that needs to be garbage collected
				currentQueue[queueLength] = control;
			}
			listenToValidationPhase();
		}


		private function listenToValidationPhase(): void {
			if (!_isListening) {
				_isListening = true;
				_stage.addEventListener(Event.ENTER_FRAME, handleValidation);
				_stage.addEventListener(Event.RENDER, handleValidation);
				_stage.invalidate();
			}
		}


		private function handleValidation(event: Event): void {
			if (_isValidating || _queue.length == 0) {
				return;
			}
			_isListening = false;
			_stage.removeEventListener(Event.ENTER_FRAME, handleValidation);
			_stage.removeEventListener(Event.RENDER, handleValidation);

			_isValidating = true;
			_queue = _queue.sort(queueSortFunction);
			while (_queue.length > 0) //rechecking length after the shift
			{
				var item: IValidating = _queue.shift();
				if (item.depth < 0) {
					//skip items that are no longer on the display list
					continue;
				}
				item.validate();
			}
			var temp: Vector.<IValidating> = _queue;
			_queue = _delayedQueue;
			_delayedQueue = temp;
			_isValidating = false;

			if (_queue.length > 0) {
				listenToValidationPhase();
			}
		}


	}
}