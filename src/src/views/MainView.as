/**
 *
 * @author v.pavkin
 */
package views {

import clock.EnterFrameClock;
import clock.SecondsTimer;

import flash.display.Sprite;
import flash.media.Sound;

import interfaces.IMainModel;
import interfaces.IMainView;

public class MainView extends Sprite implements IMainView {

	private var _model:IMainModel;

	private var _bg:BGView;
	private var _objects:ObjectsView;
	private var _snow:SnowView;
	private var _sound:Sound;

	private var _clock:EnterFrameClock;
	private var _timer:SecondsTimer;

	public function MainView(model:IMainModel) {
		super();
		_model = model;
		_objects = new ObjectsView();

		_sound = new Resources.GOBLINS_MP3();
		_sound.play(0, 99999);
	}

	public function start():void {
		_clock = new EnterFrameClock(this);
		_timer = new SecondsTimer(_clock);

		_bg = new BGView(_timer);
		_snow = new SnowView(_timer);

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


