/**
 *
 * @author v.pavkin
 */
package controller {
import events.MainModelEvent;

import interfaces.IMainController;

import model.MainModel;

import view.MainView;

public class MainController implements IMainController {

	private var _model:MainModel;
	private var _view:MainView;

	public function MainController(model:MainModel, view:MainView) {
		_model = model;
		_view = view;
	}

	public function start():void {
		_model.addEventListener(MainModelEvent.INIT, onModelInit);
		_model.start();
	}

	private function onModelInit(event:MainModelEvent):void {

	}
}
}
