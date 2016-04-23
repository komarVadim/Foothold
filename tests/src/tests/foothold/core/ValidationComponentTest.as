package tests.foothold.core {

	import by.ishaban.foothold.Foothold;
	import by.ishaban.foothold.core.InvalidationType;

	import flash.display.Sprite;
	import flash.events.Event;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.asserts.fail;
	import org.flexunit.async.Async;
	import org.fluint.uiImpersonation.UIImpersonator;

	import tests.foothold.core.mocks.MockValidator;

	/**
	 * ДОбавить тесты на прямой вызов validate:
	 * - с флагами, убедиться что перерисовка в том же фрейме
	 * - без флагов, убедиться что перерисовка не сработала
	 */
	public class ValidationComponentTest {

		[Before(async, ui)]
		public function setup(): void {
			Foothold.initialize(UIImpersonator.testDisplay.stage);
		}


		[After]
		public function teardown(): void {
			Foothold.dispose();
		}


		[Test]
		public function component_initialized_well(): void {
			var mock: MockValidator = new MockValidator();
			assertFalse(mock.isDisposed);
			assertFalse(mock.isValidated);
			assertEquals(mock.depth, -1);
		}


		[Test]
		public function component_depth_increased_with_depth_level(): void {
			var mock: MockValidator = new MockValidator();
			UIImpersonator.testDisplay.addChild(mock.view);
			assertEquals(mock.depth, 2);

			var temp: Sprite = new Sprite();
			UIImpersonator.testDisplay.addChild(temp);
			temp.addChild(mock.view);
			assertEquals(mock.depth, 3);

			mock.view.parent.removeChild(mock.view);
			assertEquals(mock.depth, -1);
		}


		[Test]
		public function after_dispose_component_marked_as_disposed(): void {
			var mock: MockValidator = new MockValidator();
			mock.dispose();
			assertNull(mock.view);
			assertTrue(mock.isDisposed);
		}


		[Test]
		public function invalidate_common_flag(): void {
			var mock: MockValidator = new MockValidator();
			mock.invalidate(MockValidator.INVALIDATE_FLAG_1);
			assertTrue(mock.isFlagInvalid(MockValidator.INVALIDATE_FLAG_1));
			assertTrue(mock.isFlagInvalid());
		}


		[Test]
		public function invalidate_size(): void {
			var mock: MockValidator = new MockValidator();
			mock.invalidateSize();
			assertTrue(mock.isFlagInvalid(InvalidationType.SIZE));
		}


		[Test]
		public function invalidate_state(): void {
			var mock: MockValidator = new MockValidator();
			mock.invalidateState();
			assertTrue(mock.isFlagInvalid(InvalidationType.STATE));
		}


		[Test]
		public function invalidate_data(): void {
			var mock: MockValidator = new MockValidator();
			mock.invalidateData();
			assertTrue(mock.isFlagInvalid(InvalidationType.DATA));
		}


		[Test]
		public function invalidate_all(): void {
			var mock: MockValidator = new MockValidator();
			mock.invalidate(InvalidationType.ALL);
			assertTrue(mock.isFlagInvalid(InvalidationType.SIZE));
			assertTrue(mock.isFlagInvalid(InvalidationType.ALL));
		}


		[Test]
		public function invalidate_all_is_default_invalidation_flag(): void {
			var mock: MockValidator = new MockValidator();
			mock.invalidate();
			assertTrue(mock.isFlagInvalid(InvalidationType.SIZE));
			assertTrue(mock.isFlagInvalid(InvalidationType.ALL));
		}


		[Test]
		public function invalidate_wrong_flag(): void {
			var mock: MockValidator = new MockValidator();
			mock.invalidate(InvalidationType.SIZE);
			assertFalse(mock.isFlagInvalid(InvalidationType.DATA));
		}


		[Test(expects="flash.errors.IllegalOperationError")]
		public function invalidate_unavailable_flag(): void {
			var mock: MockValidator = new MockValidator();
			mock.invalidate(MockValidator.INVALIDATE_FLAG_3);
		}


		[Test(async, timeout=300)]
		public function no_validation_after_initialization(): void {
			var mock: MockValidator = new MockValidator();
			assertTrue(mock.isInitialized);
			assertFalse(mock.isValidated);
			var validate: Function = Async.asyncHandler(this, function (): void {
				assertFalse(mock.isValidated);
			}, 100);
			validate();
		}


		[Test(async, timeout=300)]
		public function invalidation_works_when_component_in_display_list(): void {
			var handler: Function = Async.asyncHandler(this,
			                                           function (event: Event, passThroughObject: Object): void {
				                                           assertTrue(true);
			                                           }, 300, null,
			                                           function (event: Event, passThroughObject: Object): void {
				                                           fail("Rendering not happened.");
			                                           });
			var mock: MockValidator = new MockValidator();
			mock.addEventListener(Event.RENDER, handler);
			UIImpersonator.addChild(mock.view);
			mock.invalidate();
		}


		[Test(async, timeout=300)]
		public function invalidation_not_works_when_component_not_in_display_list(): void {
			var handler: Function = Async.asyncHandler(this,
			                                           function (event: Event, passThroughObject: Object): void {
				                                           fail("Rendering shouldn't happens.");
			                                           }, 100, null,
			                                           function (event: Event): void {
				                                           assertTrue(true);
			                                           });
			var mock: MockValidator = new MockValidator();
			mock.addEventListener(Event.RENDER, handler);
			mock.invalidate();
		}


		/**
		 * We can force redraw event if component not in display list.
		 */
		[Test(async, timeout=300)]
		public function validation_works_when_component_not_in_display_list(): void {
			var handler: Function = Async.asyncHandler(this,
			                                           function (event: Event, passThroughObject: Object): void {
				                                           assertTrue(true);
			                                           }, 100, null,
			                                           function (event: Event): void {
				                                           fail("Rendering not happened.");
			                                           });
			var mock: MockValidator = new MockValidator();
			mock.addEventListener(Event.RENDER, handler);
			mock.setInvalidationFlagsExternal(InvalidationType.DATA);
			mock.validate();
			assertTrue(mock.isValidated);
		}


		[Test(async, timeout=300)]
		public function validation_works_when_component_in_display_list(): void {
			var handler: Function = Async.asyncHandler(this,
			                                           function (event: Event, passThroughObject: Object): void {
				                                           assertTrue(true);
			                                           }, 100, null,
			                                           function (event: Event): void {
				                                           fail("Rendering not happened.");
			                                           });
			var mock: MockValidator = new MockValidator();
			UIImpersonator.addChild(mock.view);
			mock.addEventListener(Event.RENDER, handler);
			mock.setInvalidationFlagsExternal(InvalidationType.DATA);
			mock.validate();
			assertTrue(mock.isValidated);
		}


		[Test(async, timeout=300)]
		public function validation_not_works_if_nothing_to_validate(): void {
			var handler: Function = Async.asyncHandler(this,
			                                           function (event: Event, passThroughObject: Object): void {
				                                           fail("Rendering shouldn't happens.");
			                                           }, 100, null,
			                                           function (event: Event): void {
				                                           assertTrue(true);
			                                           });
			var mock: MockValidator = new MockValidator();
			UIImpersonator.addChild(mock.view);
			mock.addEventListener(Event.RENDER, handler);
			mock.validate();
			assertFalse(mock.isValidated);
		}


		[Test(async, timeout=300)]
		public function validation_not_works_if_component_disposed(): void {
			var handler: Function = Async.asyncHandler(this,
			                                           function (event: Event, passThroughObject: Object): void {
				                                           fail("Rendering shouldn't happens.");
			                                           }, 100, null,
			                                           function (event: Event): void {
				                                           assertTrue(true);
			                                           });
			var mock: MockValidator = new MockValidator();
			mock.addEventListener(Event.RENDER, handler);
			mock.dispose();
			mock.validate();
			assertFalse(mock.isValidated);
		}


		[Test(async, timeout=300)]
		public function validation_loop_works_well(): void {
			var counter: int;
			var handler: Function = Async.asyncHandler(this,
			                                           function (event: Event, passThroughObject: Object): void {
				                                           if (++counter == 2) {
					                                           assertEquals(mock.redrawCount, 2);
				                                           }
				                                           mock.invalidate(MockValidator.INVALIDATE_FLAG_2);

			                                           }, 100, null,
			                                           function (event: Event): void {
				                                           fail("Rendering not happened.");
			                                           });
			var mock: MockValidator = new MockValidator();
			mock.invalidate(MockValidator.INVALIDATE_FLAG_1);
			mock.addEventListener(Event.RENDER, handler);
			mock.validate();
			assertTrue(mock.isValidated);
		}


		[Test(async, timeout=300)]
		public function validation_order_goes_from_bottom_to_top(): void {
			var tempContainer: Sprite = new Sprite();
			var handler0: Function = Async.asyncHandler(this,
			                                            function (event: Event, passThroughObject: Object): void {
				                                            assertTrue(mock0.isValidated);
				                                            assertFalse(mock1.isValidated);
			                                            }, 100, null,
			                                            function (event: Event): void {
				                                            fail("Rendering not happened.");
			                                            });
			var handler1: Function = Async.asyncHandler(this,
			                                            function (event: Event, passThroughObject: Object): void {
				                                            assertTrue(mock0.isValidated);
				                                            assertTrue(mock1.isValidated);
			                                            }, 100, null,
			                                            function (event: Event): void {
				                                            fail("Rendering not happened.");
			                                            });
			var mock1: MockValidator = new MockValidator();
			mock1.addEventListener(Event.RENDER, handler1);
			mock1.invalidate();

			var mock0: MockValidator = new MockValidator();
			mock0.addEventListener(Event.RENDER, handler0);
			mock0.invalidate();

			tempContainer.addChild(mock1.view);
			UIImpersonator.addChild(tempContainer);
			UIImpersonator.addChild(mock0.view);
		}

	}
}
