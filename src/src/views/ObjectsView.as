package views {
	
	import flash.display.Sprite;
	import interfaces.IObject;
	
	/**
	 * ...
	 * @author Frankie Wilde
	 */
	public class ObjectsView extends Sprite {
		
		private var _objects:Vector.<IObject>;
		
		public function ObjectsView() {
			
		}
		
		
		public function render():void {
			graphics.clear();
			
			for each (var object:IObject in _objects) {
				graphics.beginFill(0xff8000);
				graphics.moveTo(object.vertexes[0].x, object.vertexes[0].y);
				
				for (var i:uint = 1; i < object.vertexes.length; i++) {
					graphics.lineTo(object.vertexes[i].x, object.vertexes[i].y);
				}
				
			}
		}
		
		public function set objects(value:Vector.<IObject>):void {
			_objects = value;
		}
		
	
	}

}
