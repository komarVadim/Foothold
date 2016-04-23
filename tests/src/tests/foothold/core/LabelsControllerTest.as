package tests.foothold.core {

	import by.ishaban.foothold.Foothold;

	import org.fluint.uiImpersonation.UIImpersonator;

	public class LabelsControllerTest {

		[Before(async, ui)]
		public function setup(): void {
			Foothold.initialize(UIImpersonator.testDisplay.stage);
		}


		[After]
		public function teardown(): void {
			Foothold.dispose();
		}

	}
}
