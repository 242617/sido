package controllers {
	
	import com.junkbyte.console.Cc;
	import events.MainModelEvent;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import interfaces.IMainModel;
	import interfaces.IObject;
	import nape.constraint.PivotJoint;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyList;
	import nape.phys.BodyType;
	import nape.shape.Circle;
	import nape.shape.Polygon;
	import nape.space.Space;
	import nape.util.ShapeDebug;
	import silhouttes.Silhoutte01;
	import views.objects.Box;
	import views.ObjectsView;
	
	/**
	 * ...
	 * @author Frankie Wilde
	 */
	public class ObjectsController {
		
		static public const DELAY:Number = 33;
		
		
		private var _model:IMainModel;
		private var _view:ObjectsView;
		private var _timer:Timer;
		
		private var _space:Space;
		private var _debug:ShapeDebug;
		private var _hand:PivotJoint;
		private var _prevTime:uint;
		private var _list:BodyList;
		private var _mouse:Vec2;
		
		
		public function ObjectsController(model:IMainModel, view:ObjectsView) {
			_view = view;
			_model = model;
			
			_view.objects = _model.objects;
			
			_timer = new Timer(DELAY, 0);
			_timer.addEventListener(TimerEvent.TIMER, timer_timerHandler);
			
			_model.addEventListener(MainModelEvent.CHANGE, onModelChange);
			_mouse = new Vec2();
			
			if (_view.stage) {
				_start();
			} else {
				_view.addEventListener(Event.ADDED_TO_STAGE, _start);
			}
			
			_timer.start();
		}
		
		private function onModelChange(event:MainModelEvent):void {
			_view.render();
		}
		
		private function timer_timerHandler(event:Event):void {
			_render();
			_post();
		}
		
		private function _start(event:Event = null):void {
			_view.removeEventListener(Event.ADDED_TO_STAGE, _start);
			
			_view.stage.addEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
			_view.stage.addEventListener(MouseEvent.MOUSE_DOWN, stage_mouseDownHandler);
			
			
			_prevTime = getTimer();
			_space = new Space(Vec2.get(0, 600));
			_debug = new ShapeDebug(_view.stage.stageWidth, _view.stage.stageHeight, 0xe0e0e0);
			//_view.stage.quality = StageQuality.LOW;
			_debug.drawConstraints = true;
			_view.addChild(_debug.display);
			
			
			_hand = new PivotJoint(_space.world, null, Vec2.weak(), Vec2.weak());
			_hand.active = false;
			_hand.stiff = false;
			_hand.maxForce = 1e5;
			_hand.space = _space;
			
			
			var border:Body = new Body(BodyType.STATIC);
			border.shapes.add(new Polygon(Polygon.rect(0, 0, -2, _view.stage.stageHeight)));
			border.shapes.add(new Polygon(Polygon.rect(0, 0, _view.stage.stageWidth, -2)));
			border.shapes.add(new Polygon(Polygon.rect(_view.stage.stageWidth, 0, 2, _view.stage.stageHeight)));
			border.shapes.add(new Polygon(Polygon.rect(0, _view.stage.stageHeight, _view.stage.stageWidth, 2)));
			border.debugDraw = false;
			border.space = _space;
			
			
			var body:Body = new Body();
			body.position.setxy(350, 500);
			body.shapes.add(new Polygon(Polygon.box(100, 50)));
			//body.shapes.add(new Circle(100));
			body.space = _space;
			
			
			
			
			var sido:Sprite = new Silhoutte01();
			//var bmd:BitmapData = new Silhoutte02();
			var bmd:BitmapData = new BitmapData(sido.width, sido.height, true, 0x00000000);
			bmd.draw(sido);
			var silIso:BitmapDataIso = new BitmapDataIso(bmd, 0x80);
			var silBody:Body = IsoBody.run(silIso, silIso.bounds);
			silBody.position.x = 500;
			silBody.position.y = 100;
			
			var graphic:DisplayObject = silIso.graphic();
			//graphic.alpha = 0.6;
			silBody.userData.graphic = graphic;
			silBody.space = _space;
			_view.addChild(graphic);
			
			
			
			
			
			
		
			//var box:IObject = new Box();
			//box.x = 350;
			//box.y = 50;
			//_model.objects.push(box);
		}
		
		
		private function _render():void {
			var curTime:uint = getTimer();
			_debug.clear();
			
			
			if (_hand != null && _hand.active) {
				_hand.anchor1.setxy(mouse.x, mouse.y);
				_hand.body2.angularVel *= 0.9;
			}
			
			_space.step((curTime - _prevTime) * 0.001, 10, 10);
			_prevTime = curTime;
			_debug.draw(_space);
			_debug.flush();
		
			//_model.objects[0].x += 1;
			//_model.objects[0].y += .3;
			//_model.refresh();
		}
		
		private function stage_mouseUpHandler(event:MouseEvent):void {
			_hand.active = false;
		}
		
		private function stage_mouseDownHandler(event:MouseEvent):void {
			_list = _space.bodiesUnderPoint(mouse, null, _list);
			
			for (var i:uint = 0; i < _list.length; i++) {
				var body:Body = _list.at(i);
				if (body.isDynamic()) {
					_hand.body2 = body;
					_hand.anchor2 = body.worldPointToLocal(mouse, true);
					_hand.active = true;
					break;
				}
			}
			
			_list.clear();
		}
		
		private function _post():void {
			for (var i:int = 0; i < _space.liveBodies.length; i++) {
				var body:Body = _space.liveBodies.at(i);
				var graphic:DisplayObject = body.userData.graphic;
				if (graphic == null) {
					continue;
				}
				var graphicOffset:Vec2 = body.userData.graphicOffset;
				var position:Vec2 = body.localPointToWorld(graphicOffset);
				graphic.x = position.x;
				graphic.y = position.y;
				graphic.rotation = (body.rotation * 180 / Math.PI) % 360;
				position.dispose();
			}
		}
		
		public function get mouse():Vec2 {
			_mouse.x = _view.mouseX;
			_mouse.y = _view.mouseY;
			return _mouse;
		}
	
	
	}

}


import flash.display.PixelSnapping;
import nape.geom.AABB;
import nape.geom.GeomPoly;
import nape.geom.GeomPolyList;
import nape.geom.IsoFunction;
import nape.geom.MarchingSquares;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.shape.Polygon;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;

class IsoBody {
	public static function run(iso:IsoFunction, bounds:AABB, granularity:Vec2 = null, quality:int = 2, simplification:Number = 1.5):Body {
		var body:Body = new Body();
		
		if (granularity == null)
			granularity = Vec2.weak(8, 8);
		var polys:GeomPolyList = MarchingSquares.run(iso, bounds, granularity, quality);
		for (var i:int = 0; i < polys.length; i++) {
			var p:GeomPoly = polys.at(i);
			
			var qolys:GeomPolyList = p.simplify(simplification).convexDecomposition(true);
			for (var j:int = 0; j < qolys.length; j++) {
				var q:GeomPoly = qolys.at(j);
				
				body.shapes.add(new Polygon(q));
				
				// Recycle GeomPoly and its vertices
				q.dispose();
			}
			// Recycle list nodes
			qolys.clear();
			
			// Recycle GeomPoly and its vertices
			p.dispose();
		}
		// Recycle list nodes
		polys.clear();
		
		// Align body with its centre of mass.
		// Keeping track of our required graphic offset.
		var pivot:Vec2 = body.localCOM.mul(-1);
		body.translateShapes(pivot);
		
		body.userData.graphicOffset = pivot;
		return body;
	}
}

class DisplayObjectIso implements IsoFunction {
	public var displayObject:DisplayObject;
	public var bounds:AABB;
	
	public function DisplayObjectIso(displayObject:DisplayObject):void {
		this.displayObject = displayObject;
		this.bounds = AABB.fromRect(displayObject.getBounds(displayObject));
	}
	
	public function iso(x:Number, y:Number):Number {
		// Best we can really do with a generic DisplayObject
		// is to return a binary value {-1, 1} depending on
		// if the sample point is in or out side.
		
		return (displayObject.hitTestPoint(x, y, true) ? -1.0 : 1.0);
	}
}

class BitmapDataIso implements IsoFunction {
	public var bitmap:BitmapData;
	public var alphaThreshold:Number;
	public var bounds:AABB;
	
	public function BitmapDataIso(bitmap:BitmapData, alphaThreshold:Number = 0x80):void {
		this.bitmap = bitmap;
		this.alphaThreshold = alphaThreshold;
		bounds = new AABB(0, 0, bitmap.width, bitmap.height);
	}
	
	public function graphic():DisplayObject {
		return new Bitmap(bitmap, PixelSnapping.NEVER, true);
	}
	
	public function iso(x:Number, y:Number):Number {
		// Take 4 nearest pixels to interpolate linearly.
		// This gives us a smooth iso-function for which
		// we can use a lower quality in MarchingSquares for
		// the root finding.
		
		var ix:int = int(x);
		var iy:int = int(y);
		//clamp in-case of numerical inaccuracies
		if (ix < 0)
			ix = 0;
		if (iy < 0)
			iy = 0;
		if (ix >= bitmap.width)
			ix = bitmap.width - 1;
		if (iy >= bitmap.height)
			iy = bitmap.height - 1;
		
		// iso-function values at each pixel centre.
		var a11:Number = alphaThreshold - (bitmap.getPixel32(ix, iy) >>> 24);
		var a12:Number = alphaThreshold - (bitmap.getPixel32(ix + 1, iy) >>> 24);
		var a21:Number = alphaThreshold - (bitmap.getPixel32(ix, iy + 1) >>> 24);
		var a22:Number = alphaThreshold - (bitmap.getPixel32(ix + 1, iy + 1) >>> 24);
		
		// Bilinear interpolation for sample point (x,y)
		var fx:Number = x - ix;
		var fy:Number = y - iy;
		return a11 * (1 - fx) * (1 - fy) + a12 * fx * (1 - fy) + a21 * (1 - fx) * fy + a22 * fx * fy;
	}
}
