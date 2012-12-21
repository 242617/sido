/**
 *
 * @author v.pavkin
 */
package view {
import flash.display.Sprite;

import interfaces.IMainModel;
import interfaces.IMainView;

public class MainView extends Sprite implements IMainView {

	private var _model:IMainModel;

	private var _bg:BGView;
	private var _snow:SnowView;

	public function MainView(model:IMainModel) {
		super();
		_model = model;
	}

	public function start():void {
		_addBG();
		//other;
		_addSnow();
	}

	private function _addBG():void {
		_bg = new BGView();
		addChild(_bg);
	}

	private function _addSnow():void {
		_snow = new SnowView();
		addChild(_snow);
	}
}
}
