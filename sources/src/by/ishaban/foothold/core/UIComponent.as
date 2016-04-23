package by.ishaban.foothold.core {

	import by.ishaban.foothold.Foothold;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;

	public class UIComponent extends ValidationComponent {


		protected static function addStageListener(type: String, listener: Function, useCapture: Boolean = false, priority: int = 0): void {
			Foothold.stage.addEventListener(type, listener, useCapture, priority, true);
		}


		protected static function removeStageListener(type: String, listener: Function, useCapture: Boolean = false): void {
			Foothold.stage.removeEventListener(type, listener, useCapture);
		}


		/**
		 * Do we need to round coordinates to floor.
		 */
		protected var _useRoundCoordinates: Boolean = true;
		/**
		 * Спорная фича
		 * Do we need to dispatch custom button events, like: rollOver, rollOut, click
		 */
		protected var _isButtonBehaviour: Boolean;
		/**
		 * @private
		 * Internal width. I don't decide what to do with this props, leave it or use view's props and let users introduce them on demand
		 */
		protected var _width: Number = 0;
		/**
		 * @private
		 * Internal width. I don't decide what to do with this props, leave it or use view's props and let users introduce them on demand
		 * */
		protected var _height: Number = 0;
		/**
		 * @private
		 * Debug method, traces view's size.
		 * */
		CONFIG::debug
		protected var _isDebugMode: Boolean;


		public function UIComponent(view: Sprite) {
			preInitialize();
			super(view);
		}


		CONFIG::debug
		public function get isDebugMode(): Boolean {
			return _isDebugMode;
		}


		CONFIG::debug
		public function set isDebugMode(value: Boolean): void {
			if (_isDebugMode == value) {
				return;
			}

			_isDebugMode = value;

			if (value) {
				updateDebugInfo();
				addViewListener(Event.ADDED, childUpdateHandler);
				addViewListener(Event.REMOVED, childUpdateHandler);
			} else {
				_view.graphics.clear();
				removeViewListener(Event.ADDED, childUpdateHandler);
				removeViewListener(Event.REMOVED, childUpdateHandler);
			}
		}


		final public function get actualWidth(): Number {
			return _view.width;
		}


		final public function get actualHeight(): Number {
			return _view.height;
		}


		final public function get actualScaleX(): Number {
			return _view.scaleX;
		}


		final public function get actualScaleY(): Number {
			return _view.scaleY;
		}


		public function get useRoundCoordinates(): Boolean {
			return _useRoundCoordinates;
		}


		public function set useRoundCoordinates(value: Boolean): void {
			_useRoundCoordinates = value;
			if (value) {
				move(x, y);
			}
		}


		public function get isButtonBehaviour(): Boolean {
			return _isButtonBehaviour;
		}


		public function set isButtonBehaviour(value: Boolean): void {
			if (value == _isButtonBehaviour) {
				return;
			}
			_isButtonBehaviour = value;
			buttonMode = value;
			if (_isButtonBehaviour) {
				addViewListener(MouseEvent.ROLL_OVER, dispatchEvent);
				addViewListener(MouseEvent.ROLL_OUT, dispatchEvent);
				addViewListener(MouseEvent.CLICK, dispatchEvent);
				addViewListener(MouseEvent.MOUSE_DOWN, dispatchEvent);
			} else {
				removeViewListener(MouseEvent.ROLL_OVER, dispatchEvent);
				removeViewListener(MouseEvent.ROLL_OUT, dispatchEvent);
				removeViewListener(MouseEvent.CLICK, dispatchEvent);
				removeViewListener(MouseEvent.MOUSE_DOWN, dispatchEvent);
			}
		}


		public function get name(): String {
			return _view.name;
		}


		public function get x(): Number {
			return _view.x;
		}


		/**
		 * todo: возможно стоит убрать и использовать move(x,y)
		 * @param value
		 */
		public function set x(value: Number): void {
			move(value, y);
		}


		public function get y(): Number {
			return _view.y;
		}


		/**
		 * todo: возможно стоит убрать и использовать move(x,y)
		 * @param value
		 */
		public function set y(value: Number): void {
			move(x, value);
		}


		public function get scaleX(): Number {
			return _view.scaleX;
		}


		/**
		 * todo: возможно стоит убрать и использовать setScale(scaleX,scaleY)
		 * @param value
		 */
		public function set scaleX(value: Number): void {
			setScale(value, scaleY);
		}


		public function get scaleY(): Number {
			return _view.scaleY;
		}


		/**
		 * todo: возможно стоит убрать и использовать setScale(scaleX,scaleY)
		 * @param value
		 */
		public function set scaleY(value: Number): void {
			setScale(scaleX, value);
		}


		public function get width(): Number {
			return _view.width;
		}


//todo: implement!
//		override public function get enabled(): Boolean {
//			return super.enabled;
//		}
//
//
//		override public function set enabled(value: Boolean): void {
//			if (value == super.enabled) {
//				return;
//			}
//
//			super.enabled = value;
//			tabEnabled = (!enabled) ? false : _focusable;
//			mouseEnabled = value;
//		}


		/**
		 * todo: возможно стоит убрать и использовать setSize(width,height)
		 * @param value
		 */
		public function set width(value: Number): void {
			setSize(value, height);
		}


		public function get height(): Number {
			return _view.height;
		}


		/**
		 * todo: возможно стоит убрать и использовать setSize(width,height)
		 * @param value
		 */
		public function set height(value: Number): void {
			setSize(width, value);
		}


		public function get alpha(): Number {
			return _view.alpha;
		}


		public function set alpha(value: Number): void {
			_view.alpha = value;
		}


		public function get visible(): Boolean {
			return _view.visible;
		}


		public function set visible(value: Boolean): void {
			if (visible == value) {
				return;
			}
			_view.visible = value;
		}


		public function get mouseEnabled(): Boolean {
			return _view.mouseEnabled;
		}


		public function set mouseEnabled(value: Boolean): void {
			_view.mouseEnabled = value;
		}


		public function get mouseChildren(): Boolean {
			return _view.mouseChildren;
		}


		public function set mouseChildren(value: Boolean): void {
			_view.mouseChildren = value;
		}


		public function get buttonMode(): Boolean {
			return _view.buttonMode;
		}


		public function set buttonMode(value: Boolean): void {
			_view.buttonMode = value;
		}


		public function get rotation(): Number {
			return _view.rotation;
		}


		public function set rotation(value: Number): void {
			_view.rotation = value;
		}


		public function get parent(): DisplayObjectContainer {
			return _view && _view.parent;
		}


		override protected function initialize(): void {
			addViewListener(Event.ADDED_TO_STAGE, onAddedToStage);

			super.initialize();

			if (_view.stage) {
				onAddedToStage();
			}
		}


		override protected function doDispose(): void {
			removeViewListener(Event.ADDED_TO_STAGE, onAddedToStage);
			isButtonBehaviour = false;

			super.doDispose();
		}


		public function contains(value: DisplayObject): Boolean {
			return value && _view.contains(value);
		}


		/**
		 * Checks if value not nested child.
		 * @param value
		 * @return
		 */
		public function containsDirectly(value: DisplayObject): Boolean {
			return value && value.parent == view && view;
		}


		/**
		 * Add child like original method. Generates error if we trying to add null-value.
		 * @param value Any not-null DisplayObject
		 * @return
		 */
		public function addChild(value: DisplayObject): DisplayObject {
			return _view.addChild(value);
		}


		public function addChildAt(view: DisplayObject, index: int): DisplayObject {
			return _view.addChildAt(view, index);
		}


		/**
		 * Safely removeChild method. Checks if value is child of current container and then remove it if its possible.
		 * @param    value
		 * @return
		 */
		public function removeChild(value: DisplayObject): DisplayObject {
			return containsDirectly(value) ? _view.removeChild(value) : value;
		}


		public function getMovieClip(name: String, parentContainer: DisplayObjectContainer = null): MovieClip {
			return getChildByName(name + "_mc", parentContainer) as MovieClip;
		}


		public function getSprite(name: String, parentContainer: DisplayObjectContainer = null): Sprite {
			return getChildByName(name, parentContainer) as Sprite;
		}


		public function getTextField(name: String, parentContainer: DisplayObjectContainer = null): TextField {
			return getChildByName(name + "_tf", parentContainer) as TextField;
		}


		public function getShape(name: String, parentContainer: DisplayObjectContainer = null): Shape {
			return getChildByName(name, parentContainer) as Shape;
		}


		public function getChildByName(name: String, parentContainer: DisplayObjectContainer = null): DisplayObject {
			parentContainer ||= _view;
			return parentContainer.getChildByName(name);
		}


		public function removeAllChildren(): void {
			while (_view && _view.numChildren) {
				_view.removeChildAt(0);
			}
		}


		/**
		 * Sets the width and height of the component at the same time using internal sizing mechanisms.
		 * @param width The new width of the component.
		 * @param height The new height of the component.
		 */
		public function setSize(width: Number, height: Number): void {
			if (_width == width && _height == height) {
				return;
			}
			_width = width;
			_height = height;
			invalidateSize();
		}


		public function move(xValue: Number, yValue: Number): void {
			var newX: Number = _useRoundCoordinates ? int(xValue) : xValue;
			var newY: Number = _useRoundCoordinates ? int(yValue) : yValue;
			if (newX == x && newY == y) {
				return;
			}
			// todo: invalidate?
			_view.x = newX;
			_view.y = newY;
		}


		/**
		 * Set component scale, if only first argument added, second will be the same.
		 * @param scaleOrScaleX
		 * @param scaleY
		 */
		public function setScale(scaleOrScaleX: Number, scaleY: Number = NaN): void {
			// todo: invalidate?
			if (isNaN(scaleY)) {
				_view.scaleX = _view.scaleY = scaleOrScaleX;
			} else {
				_view.scaleX = scaleOrScaleX;
				_view.scaleY = scaleY;
			}
			invalidateSize();
		}


		public function removeFromParent(dispose: Boolean = false): void {
			if (parent) {
				parent.removeChild(_view);
			}
			if (dispose) {
				this.dispose();
			}
		}


		protected function preInitialize(): void {
			// ABSTRACT
		}


		/**
		 * If you wish to validate something at startup, invalidate it here.
		 */
		protected function configUI(): void {
			// ABSTRACT
		}


		CONFIG::debug
		private function updateDebugInfo(): void {
			var bounds: Rectangle = _view.getBounds(_view);
			var g: Graphics = _view.graphics;
			g.clear();
			g.lineStyle(1, 0xFF0000);
			g.beginFill(0x00CCFF, 0.4);
			g.drawRect(bounds.x, bounds.y, bounds.width, bounds.height);
			g.endFill();
		}


		CONFIG::debug
		private function childUpdateHandler(event: Event): void {
			if (event.target == _view) {
				return;
			}

			updateDebugInfo();
		}


		private function onAddedToStage(event: Event = null): void {
			removeViewListener(Event.ADDED_TO_STAGE, onAddedToStage);
			if (!_isInitialized) {
				_isInitialized = true;
				configUI();
			}
		}


	}
}
