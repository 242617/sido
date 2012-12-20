package {

import controller.MainController;

import flash.display.Sprite;
import flash.events.Event;

import interfaces.IMainController;
import interfaces.IMainModel;
import interfaces.IMainView;

import model.MainModel;

import view.MainView;

/**
 * ...
 * @author Frankie Wilde
 */

public class Main extends Sprite {

	private var _model:IMainModel;
	private var _controller:IMainController;
	private var _view:IMainView;

	public function Main():void {
		if (stage) init();
		else addEventListener(Event.ADDED_TO_STAGE, init);
	}

	private function init(e:Event = null):void {
		removeEventListener(Event.ADDED_TO_STAGE, init);

		_model = new MainModel();
		_view = new MainView(_model);
		_controller = new MainController(MainModel(_model), MainView(_view));

		_controller.start();
	}

}

}