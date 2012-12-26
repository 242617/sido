package controllers {
	
	import com.junkbyte.console.Cc;
	import com.styleru.display.Draw;
	import com.styleru.utils.MathAdv;
	import com.styleru.vo.Dimensions;
	import controllers.objects.BitmapDataIso;
	import controllers.objects.IsoBody;
	import events.MainModelEvent;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import interfaces.IMainModel;
	import nape.constraint.PivotJoint;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyList;
	import nape.phys.BodyType;
	import nape.shape.Polygon;
	import nape.space.Space;
	import views.ObjectsView;
	
	/**
	 * ...
	 * @author Frankie Wilde
	 */
	public class ObjectsController {
		
		static public const DELAY:Number = 33;
		static private const BRICKS_DELAY:Number = 4000;
		static private const SILHOUETTES_DELAY:Number = 2000;
		static private const SHAKE_DELAY:Number = 7000;
		
		private var _model:IMainModel;
		private var _view:ObjectsView;
		private var _timer:Timer;
		
		private var _space:Space;
		//private var _debug:ShapeDebug;
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
			
			_model.addEventListener(MainModelEvent.CHANGE, model_changeHandler);
			_mouse = new Vec2();
			
			
			if (_view.stage) {
				_start();
			} else {
				_view.addEventListener(Event.ADDED_TO_STAGE, _start);
			}
		}
		
		private function model_changeHandler(event:MainModelEvent):void {
		}
		
		private function timer_timerHandler(event:Event):void {
			_render();
		}
		
		private function _start(event:Event = null):void {
			_view.removeEventListener(Event.ADDED_TO_STAGE, _start);
			
			_view.stage.addEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
			_view.stage.addEventListener(MouseEvent.MOUSE_DOWN, stage_mouseDownHandler);
			_view.shakeButton.addEventListener(MouseEvent.CLICK, shakeButton_clickHandler);
			_view.moreBricksButton.addEventListener(MouseEvent.CLICK, moreBricksButton_clickHandler);
			_view.exitButton.addEventListener(MouseEvent.CLICK, exitButton_clickHandler);
			
			_prevTime = getTimer();
			_space = new Space(Vec2.get(0, 1500));
			//_debug = new ShapeDebug(1280, 1024, 0xe0e0e0);
			//_debug.drawConstraints = true;
			//_view.addChild(_debug.display);
			
			_hand = new PivotJoint(_space.world, null, Vec2.weak(), Vec2.weak());
			_hand.active = false;
			_hand.stiff = false;
			//_hand.maxForce = 1e5;
			_hand.space = _space;
			
			
			_createBorder();
			
			
			//Россыпь кирпичей после старта
			var bricksTimer:Timer = new Timer(BRICKS_DELAY, 1);
			bricksTimer.addEventListener(TimerEvent.TIMER_COMPLETE, bricksTimer_timerCompleteHandler);
			bricksTimer.start();
			
			
			//Добавление силуэтов
			var silhouettesTimer:Timer = new Timer(SILHOUETTES_DELAY, Resources.SILHOUETTES.length);
			silhouettesTimer.addEventListener(TimerEvent.TIMER, silhouettesTimer_timerHandler);
			silhouettesTimer.start();
			
			
			//Таймер встряски
			var shakeTimer:Timer = new Timer(SHAKE_DELAY);
			shakeTimer.addEventListener(TimerEvent.TIMER, shakeTimer_timerHandler);
			shakeTimer.start();
			
			
			_timer.start();
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
		
		/**
		 * Собственно, рассчёт объектов, коллизий...
		 */
		private function _render():void {
			var curTime:uint = getTimer();
			//_debug.clear();
			
			if (_hand != null && _hand.active) {
				_hand.anchor1.setxy(mouse.x, mouse.y);
				_hand.body2.angularVel *= 0.9;
			}
			
			_space.step((curTime - _prevTime) * 0.001, 10, 10);
			_prevTime = curTime;
			//_debug.draw(_space);
			//_debug.flush();
			
			_view.render();
		}
		
		
		/**
		 * Встряска
		 */
		private function _shake():void {
			_model.objects.forEach(function(body:Body, ...params):void {
				body.applyImpulse(Vec2.weak(MathAdv.random(-1000, 1000), MathAdv.random(-3000, -20000)));
			})
		}
		
		
		/**
		 * Границы клетки
		 */
		private function _createBorder():void {
			var side:Number = 3000;
			
			var border:Body = new Body(BodyType.STATIC);
			
			var left:Polygon = new Polygon(Polygon.rect(0, -side, -2, 1024 + side));
			var top:Polygon = new Polygon(Polygon.rect(0, -side, 1280, -2));
			var right:Polygon = new Polygon(Polygon.rect(1280, -side, 2, 1024 + side));
			var bottom:Polygon = new Polygon(Polygon.rect(0, 1024, 1280, 2));
			
			left.material.elasticity = 10;
			top.material.elasticity = 10;
			right.material.elasticity = 10;
			bottom.material.elasticity = 10;
			
			border.shapes.add(left);
			border.shapes.add(top);
			border.shapes.add(right);
			border.shapes.add(bottom);
			
			//border.debugDraw = false;
			border.space = _space;
		}
		
		
		private function shakeButton_clickHandler(event:MouseEvent):void {
			_shake();
		}
		
		private function moreBricksButton_clickHandler(event:MouseEvent):void {
			_addBricks();
		}
		
		
		/**
		 * Добавление кирпичей
		 */
		private function _addBricks():void {
			for each (var item:Sprite in Resources.BRICKS) {
				var bmd:BitmapData = new BitmapData(item.width, item.height, true, 0x00000000);
				bmd.draw(item);
				var body:Body = _addCompoundBody(bmd);
				body.position.x = MathAdv.random(200, 1280 - 200);
				body.position.y = MathAdv.random( -2500, 0);
				body.rotation = MathAdv.random( -45, 45);
				_model.objects.push(body);
				_view.addChild(body.userData.graphics);
			}
		}
		
		
		private function _addSilhouette(silhouette:Sprite):void {
			var bmd:BitmapData = new BitmapData(silhouette.width, silhouette.height, true, 0x00000000);
			bmd.draw(silhouette);
			var body:Body = _addCompoundBody(bmd);
			body.position.x = MathAdv.random(200, 1280 - 200);
			body.position.y = MathAdv.random( -2500, 0);
			body.rotation = MathAdv.random( -45, 45);
			_model.objects.push(body);
			_view.addChild(body.userData.graphics);
		}
		
		
		/**
		 * Добавление сложного объекта
		 * @param	bmd
		 */
		private function _addCompoundBody(bmd:BitmapData):Body {
			var iso:BitmapDataIso = new BitmapDataIso(bmd, 0x80);
			var body:Body = IsoBody.run(iso, iso.bounds);
			body.userData.graphics = iso.graphics;
			body.space = _space;
			return body;
		}
		
		
		private function bricksTimer_timerCompleteHandler(event:TimerEvent):void {
			_addBricks();
		}
		
		private function shakeTimer_timerHandler(event:TimerEvent):void {
			_shake();
		}
		
		private function silhouettesTimer_timerHandler(event:TimerEvent):void {
			_addSilhouette(Resources.SILHOUETTES[(event.target as Timer).currentCount - 1]);
		}
		
		private function exitButton_clickHandler(event:MouseEvent):void {
			navigateToURL(new URLRequest("index.html"), "_self");
		}
		
		public function get mouse():Vec2 {
			_mouse.x = _view.mouseX;
			_mouse.y = _view.mouseY;
			return _mouse;
		}
	
	}

}
