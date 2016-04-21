package by.ishaban.foothold {

	import by.ishaban.foothold.core.ValidationManager;

	import flash.display.Stage;

	public class Foothold {

		public static const VERSION: String = "0.0.0";
		public static const IS_RELEASE_BUILD: Boolean = false;
		private static var _stage: Stage;


		public static function get stage(): Stage {
			return _stage;
		}


		public static function initialize(stage: Stage): void {
			Foothold._stage = stage;
			ValidationManager.initialize(stage);
		}


		public static function dispose(): void {
			Foothold._stage = null;
			ValidationManager.dispose();
		}


		public function Foothold() {
		}
	}
}
