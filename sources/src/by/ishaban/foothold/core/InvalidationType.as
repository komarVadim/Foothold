package by.ishaban.foothold.core {

	/**
	 * Values: 0, 1, 2048, 4096, 8192 are reserved, please use any other values for custom flags.
	 *
	 * @example
	 *  <code>public static const INVALIDATE_...: uint = 16384;</code>
	 */
	public class InvalidationType {
		/**
		 * This flag should be used only internally.
		 */
		public static const NONE: uint = 0;


		public static const ALL: uint = 1;


		public static const DATA: uint = 2048;


		public static const SIZE: uint = 4096;


		public static const STATE: uint = 8192;


		public function InvalidationType() {
		}
	}
}
