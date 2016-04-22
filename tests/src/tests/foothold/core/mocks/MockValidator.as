package tests.foothold.core.mocks {

	import by.ishaban.foothold.core.ValidationComponent;

	import flash.display.Sprite;
	import flash.events.Event;

	[Event(type="flash.events.Event", name="render")]
	public class MockValidator extends ValidationComponent {

		public static const INVALIDATE_FLAG_1: uint = 2;
		public static const INVALIDATE_FLAG_2: uint = 4;
		public static const INVALIDATE_FLAG_3: uint = 8;
		private static var _index: int;
		private var _redrawCount: int;


		public function MockValidator() {
			super(new Sprite());
			_redrawCount++;
		}


		override public function toString(): String {
			return "[MockValidator: " + _index + "]";
		}


		public function get isValidated(): Boolean {
			return _redrawCount > 0;
		}


		public function get isInitialized(): Boolean {
			return _isInitialized;
		}


		public function get isDisposed(): Boolean {
			return _isDisposed;
		}


		public function get redrawCount(): int {
			return _redrawCount;
		}


		CONFIG::debug override protected function checkFlags(...flags): void {
			flags.push(INVALIDATE_FLAG_1, INVALIDATE_FLAG_2);
			super.checkFlags.apply(null, flags);
		}


		override public function invalidate(flags: uint = 1): void {
			super.invalidate(flags);
		}


		override protected function initialize(): void {
			super.initialize();

			_isInitialized = true;
		}


		override protected function draw(): void {
			super.draw();

			_redrawCount++;
			dispatchEvent(new Event(Event.RENDER));
		}


		public function isFlagInvalid(flags: uint = 1): Boolean {
			return isInvalid(flags);
		}


		public function setInvalidationFlagsExternal(flags: uint = 1): void {
			_invalidationMask |= flags;
		}
	}
}
