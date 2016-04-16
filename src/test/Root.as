package test {

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;

	/**
	 * Temporary class aimed to test framework features.
	 */
	public class Root extends MovieClip {
		/**
		 * TODO: move to framework root component.
		 */
		public static var stage: Stage;


		private var _testComponent: TestValidationComponent;


		public function Root() {
			Root.stage = this.stage;

			if (stage) {
				addEventListener(Event.ENTER_FRAME, onEnterFrame);
			} else {
				addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			}
		}


		private function initialize(): void {
			trace(">> initialize");
			var view: Sprite = new Sprite();
			addChild(view);
			_testComponent = new TestValidationComponent(view);
			_testComponent.invalidate();
		}


		private function onAddedToStage(event: Event): void {
			trace(">> added");
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}


		private function onEnterFrame(event: Event): void {
			trace(">> enterframe");
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			initialize();
		}
	}
}
