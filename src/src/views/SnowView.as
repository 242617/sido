/**
 *
 * @author v.pavkin
 */
package views {
import flash.display.Sprite;
import flash.events.Event;

import view.BGView;

import view.snow.Snowflake;

public class SnowView extends Sprite {

	public static const DEFAULT_FLAKES_COUNT:uint = 200;

	private var _flakes:Vector.<Snowflake>;

	public function SnowView() {
		if (stage) start();
		else addEventListener(Event.ADDED_TO_STAGE, start);
	}

	public function start(e:Event = null):void {
		removeEventListener(Event.ADDED_TO_STAGE, start);

		_flakes = new Vector.<Snowflake>(DEFAULT_FLAKES_COUNT);
		for (var i:int = 0; i < DEFAULT_FLAKES_COUNT; i++) {
			var s:Snowflake = new Snowflake();
			_flakes[i] = s;
			addChild(s);
			s.start();
		}
	}
}
}
