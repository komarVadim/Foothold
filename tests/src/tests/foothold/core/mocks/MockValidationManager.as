package tests.foothold.core.mocks {

	import by.ishaban.foothold.core.ValidationManager;

	import flash.display.Stage;

	public class MockValidationManager extends ValidationManager {
		public function MockValidationManager(stage: Stage) {
			_creationAvailable = true;
			super();
			_stage = stage;
			_creationAvailable = false;
		}


	}
}