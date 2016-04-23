package by.ishaban.foothold.events {

	import flash.events.Event;

	public class ComponentEvent extends Event {

		static public const DESELECTED: String = "deselected";
		static public const SELECTED: String = "selected";
		static public const BEFORE_DISPOSE: String = "before_dispose";
		public static const AFTER_DISPOSE: String = "after_dispose";
		static public const INITIALIZE: String = "initialize";

		private var _data: Object;


		public function ComponentEvent(type: String, data: Object = null, bubbles: Boolean = false, cancelable: Boolean = false) {
			super(type, bubbles, cancelable);

			_data = data;
		}


		public function get data(): Object {
			return _data;
		}


		public override function clone(): Event {
			return new ComponentEvent(type, data, bubbles, cancelable);
		}


		public override function toString(): String {
			return formatToString("ComponentEvent", "type", "data", "bubbles", "cancelable", "eventPhase");
		}
	}
}
