package by.ishaban.foothold {

	import flash.display.Sprite;

	public class UIComponent extends ValidationComponent {
		public function UIComponent(target: Sprite) {
			preInitialize();
			super(target);
		}


		override public function validate(): void {
			super.validate();

			if (!_isInitialized) {
				_isInitialized = true;
				configUI();
			}
		}


		protected function preInitialize(): void {
			// ABSTRACT 
		}


		protected function configUI(): void {
			// ABSTRACT 
		}


	}
}
