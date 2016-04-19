package tests.foothold.core.mocks {

	import by.ishaban.foothold.core.ValidationComponent;

	import flash.display.Sprite;

	public class MockValidator extends ValidationComponent {

		public static const INVALIDATE_FLAG_1: uint = 2;
		public static const INVALIDATE_FLAG_2: uint = 4;
		public static const INVALIDATE_FLAG_3: uint = 8;
		private var _isValidated: Boolean;


		public function MockValidator() {
			super(new Sprite());
		}


		CONFIG::debug override protected function checkFlags(...flags): void {
			flags.push(INVALIDATE_FLAG_1, INVALIDATE_FLAG_2);
			super.checkFlags.apply(null, flags);
		}


		public function isFlagInvalid(flags: uint = 1): Boolean {
			return isInvalid(flags);
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

			_isValidated = true;
		}


		public function get isValidated(): Boolean {
			return _isValidated;
		}


		public function get isInitialized(): Boolean {
			return _isInitialized;
		}
	}
}
