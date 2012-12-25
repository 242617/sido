package controllers {
	
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
		
		private var _model:IMainModel;
		private var _view:ObjectsView;
		private var _timer:Timer;
		
		private var _space:Space;
		//private var _debug:ShapeDebug;
		private var _hand:PivotJoint;
		private var _border:Body;
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
			
			_timer.start();
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
			
			_prevTime = getTimer();
			_space = new Space(Vec2.get(0, 1500));
			//_debug = new ShapeDebug(_view.stage.stageWidth, _view.stage.stageHeight, 0xe0e0e0);
			//_debug.drawConstraints = true;
			//_view.addChild(_debug.display);
			
			_hand = new PivotJoint(_space.world, null, Vec2.weak(), Vec2.weak());
			_hand.active = false;
			_hand.stiff = false;
			//_hand.maxForce = 1e8;
			_hand.space = _space;
			
			_border = new Body(BodyType.STATIC);
			_border.shapes.add(new Polygon(Polygon.rect(0, 0, -2, _view.stage.stageHeight)));
			_border.shapes.add(new Polygon(Polygon.rect(0, 0, _view.stage.stageWidth, -2)));
			_border.shapes.add(new Polygon(Polygon.rect(_view.stage.stageWidth, 0, 2, _view.stage.stageHeight)));
			_border.shapes.add(new Polygon(Polygon.rect(0, _view.stage.stageHeight, _view.stage.stageWidth, 2)));
			_border.debugDraw = false;
			_border.space = _space;
			
			
			for (var i:uint = 0; i < 5; i++) {
				var body:Body = _addBrick(new Dimensions(MathAdv.random(20, 100), MathAdv.random(20, 50)));
				body.position.x = MathAdv.random(200, _view.stage.stageWidth - 200);
				body.position.y = MathAdv.random(200, _view.stage.stageHeight - 200);
				_model.objects.push(body);
				_view.addChild(body.userData.graphics);
			}
			
			var shapes:Vector.<Sprite> = new <Sprite>[
				Resources.SILHOUETTE_01,
				Resources.SILHOUETTE_02,
				Resources.SILHOUETTE_03,
				Resources.BRICK_01,
			]
			
			//Добавление силуэта
			shapes.forEach(function(silhouette:Sprite, ...params):void {
				var bmd:BitmapData = new BitmapData(silhouette.width, silhouette.height, true, 0x00000000);
				bmd.draw(silhouette);
				var body:Body = _addCompoundBody(bmd);
				body.position.x = MathAdv.random(200, _view.stage.stageWidth - 200);
				body.position.y = MathAdv.random(200, _view.stage.stageHeight - 200);
				_model.objects.push(body);
				_view.addChild(body.userData.graphics);
			})
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
		 * Добавление кирпича
		 * @param	state
		 */
		private function _addBrick(dimensions:Dimensions):Body {
			var body:Body = new Body();
			body.shapes.add(new Polygon(Polygon.box(dimensions.width, dimensions.height)));
			var shape:Shape = new Shape();
			Draw.rectangle(shape.graphics, dimensions.width, dimensions.height, [0x660000, 0x330000], 1, -dimensions.width >> 1, -dimensions.height >> 1);
			body.userData.graphics = shape;
			var pivot:Vec2 = body.localCOM.mul(-1);
			body.translateShapes(pivot);
			body.userData.graphicOffset = pivot;
			body.space = _space;
			return body;
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
		
		
		/**
		 * Встряска
		 */
		private function _shake():void {
			_model.objects.forEach(function(body:Body, ...params):void {
				body.applyImpulse(Vec2.weak(MathAdv.random(-1000, 1000), MathAdv.random(-3000, -20000)));
			})
		}
		
		private function shakeButton_clickHandler(event:MouseEvent):void {
			_shake();
		}
		
		public function get mouse():Vec2 {
			_mouse.x = _view.mouseX;
			_mouse.y = _view.mouseY;
			return _mouse;
		}
	
	}

}
