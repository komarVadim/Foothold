package test {

	import flash.display.MovieClip;
	import flash.display.Stage;

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
			Root.stage = stage;

			_testComponent = new TestValidationComponent(this);
			_testComponent.invalidate();
		}
	}
}
