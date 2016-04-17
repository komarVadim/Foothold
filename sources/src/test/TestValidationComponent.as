package test {

	import by.ishaban.foothold.core.UIComponent;

	import flash.display.Sprite;

	/**
	 * Temporary class aimed to test framework features.
	 */
	public class TestValidationComponent extends UIComponent {
		public static const INVALIDATE_MY_PROP: uint = 1;


		public function TestValidationComponent(target: Sprite) {
			super(target);
		}


		override protected function draw(): void {
			super.draw();
			trace(">> draw", this);
		}


		override protected function configUI(): void {
			super.configUI();
			trace(">> config ui", this);
		}


		CONFIG::debug override protected function checkFlags(...flags): void {
			flags.push(INVALIDATE_MY_PROP);

			super.checkFlags.apply(null, flags);
		}
	}
}
