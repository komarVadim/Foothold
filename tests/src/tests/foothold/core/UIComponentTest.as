package tests.foothold.core {

	import by.ishaban.foothold.Foothold;

	import flash.display.DisplayObject;
	import flash.display.Sprite;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertTrue;
	import org.fluint.uiImpersonation.UIImpersonator;

	import tests.foothold.core.mocks.MockUIComponent;

	public class UIComponentTest {

		[Before(async, ui)]
		public function setup(): void {
			Foothold.initialize(UIImpersonator.testDisplay.stage);
		}


		[After]
		public function teardown(): void {
			try {
				Foothold.dispose();
			}
			catch (e: Error) {
			}
		}


		[Test]
		public function component_initialized_well(): void {
			var mock: MockUIComponent = new MockUIComponent();
			assertTrue(mock.useRoundCoordinates);
		}


		[Test]
		public function component_removes_from_parent(): void {
			var mock: MockUIComponent = new MockUIComponent();
			assertNull(mock.view.stage);
			assertFalse(mock.isDisposed);

			mock.removeFromParent();
			assertNull(mock.view.stage);

			UIImpersonator.testDisplay.addChild(mock.view);
			assertNotNull(mock.view.stage);

			mock.removeFromParent();
			assertNull(mock.view.stage);

			mock.removeFromParent(true);
			assertTrue(mock.isDisposed);
		}


		[Test]
		public function children_management_methods_works_well(): void {
			var mock: MockUIComponent = new MockUIComponent();

			assertTrue(mock.view.numChildren > 0);
			assertNotNull(mock.getChildByName("test_mc"));
			assertNotNull(mock.getMovieClip("test"));
			var test: Sprite = mock.getSprite("test_sprite");
			var inner_child: DisplayObject = test.getChildAt(0);
			assertNotNull(test);
			assertNotNull(mock.getTextField("test"));
			// i cannot test shape, strange
//			assertNotNull(mock.getShape("test_shape"));

			assertTrue(mock.contains(test));
			assertTrue(mock.contains(inner_child));
			assertTrue(mock.containsDirectly(test));
			assertFalse(mock.containsDirectly(inner_child));
			// safety remove foreign child
			assertEquals(mock.removeChild(inner_child), inner_child);
			assertEquals(mock.removeChild(test), test);

			assertEquals(mock.addChild(test), test);
			assertEquals(mock.addChildAt(test, 1), test);

			mock.removeAllChildren();
			assertTrue(mock.view.numChildren == 0);
			UIImpersonator.testDisplay.addChild(mock.view);
		}

	}
}
