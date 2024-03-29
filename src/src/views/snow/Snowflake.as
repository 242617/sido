﻿package views.snow {
import clock.SecondsTimer;

import flash.display.*;
import flash.events.*;

public class Snowflake extends Sprite {

	private var xPos:Number = 0;
	private var yPos:Number = 0;

	private var xSpeed:Number = 0;
	private var ySpeed:Number = 0;

	private var radius:Number = 0;

	private var scale:Number = 0;
	private var alphaValue:Number = 0;

	private var maxHeight:Number = 0;
	private var maxWidth:Number = 0;

	private var _timer:SecondsTimer;

	public function Snowflake(timer:SecondsTimer) {
		_timer = timer;
	}

	public function start():void {

		this.graphics.beginFill(0xffffff);
		this.graphics.drawCircle(9.5, 9.5, 9.5);
		this.graphics.endFill();

		//Setting the various parameters that need tweaking
		xSpeed = .05 + Math.random() * .1;
		ySpeed = .1 + Math.random() * 3;
		radius = .1 + Math.random() * 2;
		scale = .01 + Math.random();
		alphaValue = .1 + Math.random();

		maxWidth = 1280;
		maxHeight = 1024;

		this.x = Math.random() * maxWidth;
		this.y = Math.random() * maxHeight;

		xPos = this.x;
		yPos = this.y;

		this.scaleX = this.scaleY = scale;
		this.alpha = alphaValue;

		_timer.addEventListener(TimerEvent.TIMER, MoveSnowFlake);
		this.cacheAsBitmap = true;
	}

	private function MoveSnowFlake(e:Event):void {
		xPos += xSpeed;
		yPos += ySpeed;

		this.x += radius * Math.cos(xPos);
		this.y += ySpeed;

		if (this.y - this.height > maxHeight) {
			this.y = -10 - this.height;
			this.x = Math.random() * maxWidth;
		}
	}
}
}
