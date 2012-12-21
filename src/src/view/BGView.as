/**
 *
 * @author v.pavkin
 */
package view {
import flash.display.GradientType;
import flash.display.InterpolationMethod;
import flash.display.SpreadMethod;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Matrix;

public class BGView extends Sprite {

	private var _c1:uint = 0xcc3300;
	private var _c2:uint = 0x99ff00;
	private var _c3:uint = 0x3300;
	private var _r1:uint = 0x25;
	private var _r2:uint = 0x77;
	private var _r3:uint = 0xd9;
	private var _focalRatio:Number = 0;

	public function BGView() {

		if (stage) start();
		else addEventListener(Event.ADDED_TO_STAGE, start);
	}

	private function start(event:Event = null):void {
		removeEventListener(Event.ADDED_TO_STAGE, start);
		this.addEventListener(Event.ENTER_FRAME, onEnterFrame)
	}

	private function onEnterFrame(event:Event):void {

		var m:Matrix = new Matrix();
		m.createGradientBox(this.stage.stageWidth, this.stage.stageHeight, 3.14, 0, 0);

		this.graphics.clear();
		this.graphics.beginGradientFill(GradientType.RADIAL, [ (_c1 = p(_c1, 20)), (_c2 = p(_c2, 20)), (_c3 = p(_c3, 20))], [1, 1, 1], [_r1 = p(_r1, 5, 0xaa), _r2 = p(_r2, 5, 0xaa), _r3 = p(_r3, 5, 0xaa)], m, SpreadMethod.REFLECT, InterpolationMethod.RGB, (_focalRatio = p(_focalRatio, 0.01, 0.5)));
		this.graphics.drawRect(0, 0, this.stage.stageWidth, this.stage.stageHeight);
		this.graphics.endFill();
	}

	private function p(v:uint, i:uint, max:uint = 0xffffff):uint {
		var r:int = i * (Math.random() - 0.5);
		if (v + r < 0)
			return 0;
		if (v + r > max)
			return max;
		return v + r;
	}
}
}
