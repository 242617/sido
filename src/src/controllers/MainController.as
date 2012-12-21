/**
 *
 * @author v.pavkin
 */

package controllers {
	
	import com.junkbyte.console.Cc;
	import events.MainModelEvent;
	import interfaces.IMainController;
	import models.MainModel;
	import views.MainView;
	
	public class MainController implements IMainController {
		
		private var _model:MainModel;
		private var _view:MainView;
		private var _objectsController:ObjectsController;
		
		public function MainController(model:MainModel, view:MainView) {
			_model = model;
			_view = view;
		}
		
		public function start():void {
			_model.addEventListener(MainModelEvent.INIT, onModelInit);
			_model.start();
		}
		
		private function onModelInit(event:MainModelEvent):void {
			_objectsController = new ObjectsController(_model, _view.objects);
			_view.start();
		}
	}
}
