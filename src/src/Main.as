package {
	
	import events.MainModelEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import interfaces.IMainModel;
	import model.MainModel;
	
	/**
	 * ...
	 * @author Frankie Wilde
	 */
	
	public class Main extends Sprite {
		
		private var _model:IMainModel;
		
		
		public function Main():void {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_model = new MainModel();
			
			_model.addEventListener(MainModelEvent.INIT, model_initHandler)
		}
		
		private function model_initHandler(event:MainModelEvent):void {
			trace("start!");
		}
		
	}
	
}