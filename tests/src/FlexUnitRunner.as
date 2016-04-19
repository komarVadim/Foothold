package {

	import flash.display.Sprite;

	import org.flexunit.internals.TraceListener;
	import org.flexunit.listeners.CIListener;
	import org.flexunit.runner.FlexUnitCore;

	import tests.foothold.core.FootholdTest;
	import tests.foothold.core.ValidationComponentTest;
	import tests.foothold.core.ValidationManagerTest;

	public class FlexUnitRunner extends Sprite {
		public function FlexUnitRunner() {
			onCreationComplete();
		}


		private function onCreationComplete(): void {
			var core: FlexUnitCore = new FlexUnitCore();
			core.addListener(new TraceListener());
			core.addListener(new CIListener());
			core.visualDisplayRoot = stage;
			core.run(currentRunTestSuite());
		}


		public function currentRunTestSuite(): Array {
			var testsToRun: Array = [
				ValidationComponentTest,
				ValidationManagerTest,
				FootholdTest,
			];
			return testsToRun;
		}
	}
}