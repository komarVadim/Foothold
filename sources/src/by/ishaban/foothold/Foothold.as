package by.ishaban.foothold {

	import flash.display.Stage;

	public class Foothold {

		private static var _stage: Stage;

		public static const VERSION: String = "0.0.0";
		public static const IS_RELEASE_BUILD: Boolean = false;


		public static function get stage(): Stage {
			return _stage;
		}


		public static function initialize(stage: Stage): void {
			Foothold._stage = stage;
		}


		public function Foothold() {
		}
	}
}
