package tests.foothold.core {

	import by.ishaban.foothold.Foothold;
	import by.ishaban.foothold.core.ValidationManager;

	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertNull;
	import org.fluint.uiImpersonation.UIImpersonator;

	public class ValidationManagerTest {

		[Before(async, ui)]
		public function setup(): void {
//			Foothold.initialize(UIImpersonator.testDisplay.stage);
		}


		[After]
		public function teardown(): void {
			try {
				Foothold.dispose();
			}
			catch (e: Error) {
			}
		}


		[Test(expects="flash.errors.IllegalOperationError")]
		public function class_should_be_signleton(): void {
			new ValidationManager();
		}


		[Test(order=1)]
		public function no_access_without_initialization(): void {
			assertNull(ValidationManager.getInstance());
		}


		[Test]
		public function initialization_successful(): void {
			ValidationManager.initialize(UIImpersonator.testDisplay.stage);
			assertNotNull(ValidationManager.getInstance());
		}


		[Test]
		public function dispose_successful(): void {
			ValidationManager.initialize(UIImpersonator.testDisplay.stage);
			ValidationManager.dispose();

			assertNull(ValidationManager.getInstance());
		}


//		[Test(async)]
//		public function mock_validation(): void {
//			var handler: Function = Async.asyncHandler(this, onRender, 300, null, onFail);
//			var v: MockValidator = new MockValidator();
//			v.addEventListener(Event.RENDER, handler);
//			UIImpersonator.addChild(v.view);
//
//			var manager: MockValidationManager = new MockValidationManager(UIImpersonator.testDisplay.stage);
//			manager.add(v, false);
//		}
//
//
//		private function onRender(event: Event): void {
//			assert();
//		}
//
//
//		private function onFail(event: Event): void {
//			fail("Rendering not happened.");
//		}


//		[Test]
//		public function check_validation(): void {
//			var mock: MockValidator = new MockValidator();
//			var manager: ValidationManager = ValidationManager.getInstance();
//			manager.
//		}


	}
}
