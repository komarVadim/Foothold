package by.ishaban.foothold.core {

	import flash.display.MovieClip;

	public class LabelsController extends ValidationComponent {
		protected static function generateLabelHash(target: MovieClip): Object {
			var hash: Object = {};
			if (!target) {
				return hash;
			}
			var labels: Array = target.currentLabels;
			var l: uint = labels.length;
			for (var i: uint = 0; i < l; i++) {
				hash[labels[i].name] = true;
			}
			return hash;
		}


		/** @private */
		protected var _labelHash: Object;
		/** @private */
		protected var _state: String;
		/** A list of frames that apply to a given state. The frames will be called in order, and the last existing frame will be displayed. @private */
		protected var _stateMap: Object = {
			up: ["up"],
			over: ["over"],
			down: ["down"],
			release: ["release", "over"],
			out: ["out", "up"],
			disabled: ["disabled"],
			selecting: ["selecting", "over"],
			toggle: ["toggle", "up"],
			kb_selecting: ["kb_selecting", "up"],
			kb_release: ["kb_release", "out", "up"],
			kb_down: ["kb_down", "down"]
		};
		/** @private */
		protected var _newFrame: String;

		// Optimization to states look-up
		//LM: Make static.
		/** @private */
		protected var statesDefault: Vector.<String> = Vector.<String>([""]);
		/** @private */
		protected var statesSelected: Vector.<String> = Vector.<String>(["selected_", ""]);
		/** @private */
		protected var _selected: Boolean = false;


		public function LabelsController(view: MovieClip) {
			super(view);
		}


		protected function get typedView(): MovieClip {
			return _view as MovieClip;
		}


		override protected function initialize(): void {
			super.initialize();

			_labelHash = generateLabelHash(view as MovieClip);
		}


		override protected function draw(): void {
			// State is invalid, and has been set (is not the default)
			if (isInvalid(InvalidationType.STATE)) {
				if (_newFrame) {
					typedView.gotoAndPlay(_newFrame);
					_newFrame = null;
				}

				updateAfterStateChange();
				// TODO: probably it is good to notify others
//				dispatchEventAndSound(new ComponentEvent(ComponentEvent.STATE_CHANGE));
			}
			super.draw();
		}


		/** @private */
		protected function getStatePrefixes(): Vector.<String> {
			return _selected ? statesSelected : statesDefault;
		}


		/** This happens any time the state changes. @private */
		protected function updateAfterStateChange(): void {
		}


		/** @private */
		protected function setState(state: String): void {
			_state = state;
			var prefixes: Vector.<String> = getStatePrefixes();
			var states: Array = _stateMap[state];
			if (states == null || states.length == 0) {
				return;
			}
			var l: uint = prefixes.length;
			for (var i: uint = 0; i < l; i++) {
				var prefix: String = prefixes[i];
				var sl: uint = states.length;
				for (var j: uint = 0; j < sl; j++) {
					var thisLabel: String = prefix + states[j];
					if (_labelHash[thisLabel]) {
						_newFrame = thisLabel;
						invalidateState();
						return;
					}
				}
			}
		}
	}
}
