/**
 *
 * @author v.pavkin
 */
package views {

import flash.display.Sprite;
import flash.events.Event;
import flash.media.Sound;

import interfaces.IMainModel;
import interfaces.IMainView;

public class MainView extends Sprite implements IMainView {

	private var _model:IMainModel;

	private var _bg:BGView;
	private var _objects:ObjectsView;
	private var _snow:SnowView;
	private var _sound:Sound;

	public function MainView(model:IMainModel) {
		super();
		_model = model;

		_bg = new BGView();
		_objects = new ObjectsView();
		_snow = new SnowView();

		_sound = new Resources.GOBLINS_MP3();
		_sound.play(0, 99999);
	}

	public function start():void {
		addChild(_bg);
		addChild(_objects);
		addChild(_snow);
	}

	public function get objects():ObjectsView {
		return _objects;
	}

	public function get snow():SnowView {
		return _snow;
	}
}
}

