package tests.foothold.core {

	import by.ishaban.foothold.Foothold;

	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertNull;
	import org.fluint.uiImpersonation.UIImpersonator;

	public class FootholdTest {

		[Before(async, ui)]
		public function setup(): void {
		}


		[After]
		public function teardown(): void {

		}


		[Test]
		public function test_initialization(): void {
			Foothold.initialize(UIImpersonator.testDisplay.stage);
			assertNotNull(Foothold.stage);
		}


		[Test]
		public function test_dispose(): void {
			Foothold.dispose();
			assertNull(Foothold.stage);
		}
	}
}
