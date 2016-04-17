package by.ishaban.foothold.core {

	/**
	 * Для базовых флагов защиваем значения подальше, дабы кастомные флаги можно было начинать с 1
	 * @example public static const INVALIDATE_...: uint = 8192;
	 */
	public class InvalidationType {
		/**
		 * This flag should be used only internally.
		 */
		public static const INVALIDATE_NONE: uint = 0;


		public static const INVALIDATE_ALL: uint = 1024;


		public static const INVALIDATE_DATA: uint = 2048;


		public static const INVALIDATE_SIZE: uint = 4096;


		public static const INVALIDATE_STATE: uint = 16384;


		public function InvalidationType() {
		}
	}
}
