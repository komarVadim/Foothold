package tests.foothold.core {

	import by.ishaban.foothold.Foothold;
	import by.ishaban.foothold.core.ValidationManager;

	import org.flexunit.asserts.assertNotNull;
	import org.fluint.uiImpersonation.UIImpersonator;

	public class ValidationManagerTest {

		[Before(async, ui)]
		public function setup(): void {
			Foothold.initialize(UIImpersonator.testDisplay.stage);
		}


		[After]
		public function teardown(): void {
			Foothold.dispose();
		}


		[Test(expects="flash.errors.IllegalOperationError")]
		public function class_should_be_signleton(): void {
			new ValidationManager(null);
		}


		[Test]
		public function singleton_initialization_successful(): void {
			assertNotNull(ValidationManager.getInstance());
		}


//		[Test]
//		public function check_validation(): void {
//			var mock: MockValidator = new MockValidator();
//			var manager: ValidationManager = ValidationManager.getInstance();
//			manager.
//		}


	}
}
