package views {
	
	import com.styleru.display.PushButton;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import views.ui.Button;
	
	/**
	 * ...
	 * @author Frankie Wilde
	 */
	public class ObjectsView extends Sprite {
		
		private var _objects:Vector.<Body>;
		private var _shakeButton:Button;
		private var _moreBricksButton:Button;
		
		
		public function ObjectsView() {
			_shakeButton = new Button(Resources.SHAKE_BUTTON);
			_shakeButton.x = 50;
			_shakeButton.y = 70;
			
			_moreBricksButton = new Button(Resources.MORE_BRICKS_BUTTON);
			_moreBricksButton.x = 550;
			_moreBricksButton.y = 70;
			
			addChild(_shakeButton);
			addChild(_moreBricksButton);
		}
		
		public function render():void {
			//Двигаем отображения объектов
			for (var i:int = 0; i < _objects.length; i++) {
				var body:Body = _objects[i];
				var graphics:DisplayObject = body.userData.graphics;
				if (graphics == null) {
					continue;
				}
				var graphicOffset:Vec2 = body.userData.graphicOffset;
				var position:Vec2 = body.localPointToWorld(graphicOffset);
				graphics.x = position.x;
				graphics.y = position.y;
				graphics.rotation = (body.rotation * 180 / Math.PI) % 360;
				position.dispose();
			}
		}
		
		public function set objects(value:Vector.<Body>):void {
			_objects = value;
		}
		
		public function get shakeButton():Button {
			return _shakeButton;
		}
		
		public function get moreBricksButton():Button {
			return _moreBricksButton;
		}
	
	}

}
