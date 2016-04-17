package by.ishaban.foothold.core {

	public interface IValidating {
		/**
		 * The component's depth in the display list, relative to the stage. If
		 * the component isn't on the stage, its depth will be <code>-1</code>.
		 *
		 * <p>Used by the validation system to validate components from the
		 * top down</p>.
		 */
		function get depth(): int;


		/**
		 * Immediately validates the display object, if it is invalid. The
		 * validation system exists to postpone updating a display object after
		 * properties are changed until until the last possible moment the
		 * display object is rendered. This allows multiple properties to be
		 * changed at a time without requiring a full update every time.
		 */
		function validate(): void;
	}
}
