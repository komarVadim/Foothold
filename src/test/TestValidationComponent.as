package test {

	import by.ishaban.foothold.ValidationComponent;

	import flash.display.MovieClip;

	/**
	 * Temporary class aimed to test framework features.
	 */
	public class TestValidationComponent extends ValidationComponent {
		public static const INVALIDATE_MY_PROP: uint = 1;


		public function TestValidationComponent(target: MovieClip) {
			super(target);
		}


		override protected function draw(): void {
			super.draw();
		}


		CONFIG::debug override protected function checkFlags(...flags): void {
			flags.push(INVALIDATE_MY_PROP);

			super.checkFlags.apply(null, flags);
		}
	}
}
