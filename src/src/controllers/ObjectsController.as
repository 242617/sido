package controllers {
	
	import events.MainModelEvent;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import interfaces.IMainModel;
	import views.ObjectsView;
	
	/**
	 * ...
	 * @author Frankie Wilde
	 */
	public class ObjectsController {
		
		static public const DELAY:Number = 33;
		
		
		private var _model:IMainModel;
		private var _view:ObjectsView;
		private var _timer:Timer;
		
		public function ObjectsController(model:IMainModel, view:ObjectsView) {
			_view = view;
			_model = model;
			
			_view.objects = _model.objects;
			
			_timer = new Timer(DELAY, 0);
			_timer.addEventListener(TimerEvent.TIMER, timer_timerHandler);
			
			_model.addEventListener(MainModelEvent.CHANGE, onModelChange);
			
			_timer.start();
		}
		
		private function onModelChange(event:MainModelEvent):void {
			_view.render();
		}
		
		private function timer_timerHandler(event:Event):void {
			_model.objects[0].x += 1;
			_model.objects[0].y += .3;
			_model.refresh();
		}
	
	}

}
