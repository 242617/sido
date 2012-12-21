package views.objects {
	
	import flash.geom.Point;
	import interfaces.IObject;
	
	/**
	 * ...
	 * @author Frankie Wilde
	 */
	
	public class BasicObject implements IObject {
		
		private var _x:Number;
		private var _y:Number;
		private var _width:Number;
		private var _height:Number;
		private var _vertexes:Vector.<Point>;
		
		public function BasicObject() {
			_x = 0;
			_y = 0;
			_width = 0;
			_height = 0;
			_vertexes = new Vector.<Point>();
		}
		
		protected function refresh():void {
		}
		
		
		public function get x():Number {
			return _x;
		}
		public function set x(value:Number):void {
			if (_x == value) return;
			_x = value;
			refresh();
		}
		
		public function get y():Number {
			return _y;
		}
		public function set y(value:Number):void {
			if (_y == value) return;
			_y = value;
			refresh();
		}
		
		public function get width():Number {
			return _width;
		}
		public function set width(value:Number):void {
			if (_width == value) return;
			_width = value;
			refresh();
		}
		
		public function get height():Number {
			return _height;
		}
		public function set height(value:Number):void {
			if (_height == value) return;
			_height = value;
			refresh();
		}
		
		public function get vertexes():Vector.<Point> {
			return _vertexes;
		}
		
	}

}
