package tests.foothold.core.mocks {

	import by.ishaban.foothold.core.UIComponent;

	public class MockUIComponent extends UIComponent {
		private static var __index: int;
		private var _redrawCount: int;
		private var _index: int;


		public function MockUIComponent() {
			super(new Mock_View());
			_index = __index++;
		}


		override public function toString(): String {
			return "[MockUIComponent: " + _index + ", depth: " + depth + "]";
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


	}
}
