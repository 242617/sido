package {
	
	import com.junkbyte.console.Cc;
	import com.styleru.config.My;
	import controllers.MainController;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import interfaces.IMainController;
	import interfaces.IMainModel;
	import interfaces.IMainView;
	import models.MainModel;
	import profiler.SWFProfiler;
	import views.MainView;
	
	/**
	 * ...
	 * @author Frankie Wilde
	 */
	
	public class Main extends Sprite {
		
		private var _model:IMainModel;
		private var _controller:IMainController;
		private var _view:IMainView;
		
		public function Main():void {
			if (stage) {
				init();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			if (CONFIG::debug) {
				My.consoleRoot = stage;
				Cc.width = 300;
				SWFProfiler.init(stage, this);
			}
			
			_model = new MainModel();
			_view = new MainView(_model);
			addChild(DisplayObjectContainer(_view));
			_controller = new MainController(MainModel(_model), MainView(_view));
			
			_controller.start();
		}
	
	}
}

