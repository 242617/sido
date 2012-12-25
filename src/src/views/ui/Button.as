package views.ui {
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Frankie Wilde
	 */
	public class Button extends Sprite {
		private var _container:MovieClip;
		
		public function Button(container:MovieClip) {
			_container = container;
			_container.stop();
			addChild(_container);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		}
		
		public function down():void {
			_container.gotoAndStop(2);
		}
		public function up():void {
			_container.gotoAndStop(1);
		}
		
		
		private function mouseDownHandler(event:MouseEvent):void {
			stage.addEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
			down();
		}
		
		private function stage_mouseUpHandler(event:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
			up();
		}
		
	}

}
