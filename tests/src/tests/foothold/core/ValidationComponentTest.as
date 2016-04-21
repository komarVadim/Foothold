package tests.foothold.core {

	import by.ishaban.foothold.Foothold;
	import by.ishaban.foothold.core.InvalidationType;

	import flash.events.Event;

	import org.flexunit.asserts.assertFalse;
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
			assertTrue(mock.isFlagInvalid(InvalidationType.INVALIDATE_SIZE));
		}


		[Test]
		public function invalidate_state(): void {
			var mock: MockValidator = new MockValidator();
			mock.invalidateState();
			assertTrue(mock.isFlagInvalid(InvalidationType.INVALIDATE_STATE));
		}


		[Test]
		public function invalidate_data(): void {
			var mock: MockValidator = new MockValidator();
			mock.invalidateData();
			assertTrue(mock.isFlagInvalid(InvalidationType.INVALIDATE_DATA));
		}


		[Test]
		public function invalidate_all(): void {
			var mock: MockValidator = new MockValidator();
			mock.invalidate(InvalidationType.INVALIDATE_ALL);
			assertTrue(mock.isFlagInvalid(InvalidationType.INVALIDATE_SIZE));
			assertTrue(mock.isFlagInvalid(InvalidationType.INVALIDATE_ALL));
		}


		[Test]
		public function invalidate_all_is_default_invalidation_flag(): void {
			var mock: MockValidator = new MockValidator();
			mock.invalidate();
			assertTrue(mock.isFlagInvalid(InvalidationType.INVALIDATE_SIZE));
			assertTrue(mock.isFlagInvalid(InvalidationType.INVALIDATE_ALL));
		}


		[Test]
		public function invalidate_wrong_flag(): void {
			var mock: MockValidator = new MockValidator();
			mock.invalidate(InvalidationType.INVALIDATE_SIZE);
			assertFalse(mock.isFlagInvalid(InvalidationType.INVALIDATE_DATA));
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
		public function validation_works_when_component_in_display_list(): void {
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
		public function validation_not_works_when_component_not_in_display_list(): void {
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

	}
}
