package interfaces {
	
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Frankie Wilde
	 */
	
	public interface IObject {
		
		function get vertexes():Vector.<Point>;
		
		function get x():Number;
		function set x(value:Number):void;
		function get y():Number;
		function set y(value:Number):void;
		function get width():Number;
		function set width(value:Number):void;
		function get height():Number;
		function set height(value:Number):void;
		
	}

}
