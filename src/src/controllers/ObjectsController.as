package controllers {
	
	import com.junkbyte.console.Cc;
	import com.styleru.stage3d.interfaces.IModelWrapper;
	import com.styleru.vo.State;
	import controllers.objects.BitmapDataIso;
	import controllers.objects.IsoBody;
	import events.MainModelEvent;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import interfaces.IMainModel;
	import interfaces.IObject;
	import nape.constraint.PivotJoint;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyList;
	import nape.phys.BodyType;
	import nape.shape.Polygon;
	import nape.shape.ShapeList;
	import nape.space.Space;
	import nape.util.ShapeDebug;
	import silhouttes.Silhoutte01;
	import views.objects.BoxWrapper;
	import views.objects.CompoundObject;
	import views.ObjectsView;
	import zpp_nape.util.ZPP_MixVec2List;
	
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
		private var _prevTime:uint;
		private var _list:BodyList;
		private var _mouse:Vec2;
		
		public function ObjectsController(model:IMainModel, view:ObjectsView) {
			_view = view;
			_model = model;
			
			_view.items = _model.objects;
			
			_timer = new Timer(DELAY, 0);
			_timer.addEventListener(TimerEvent.TIMER, timer_timerHandler);
			
			_model.addEventListener(MainModelEvent.CHANGE, onModelChange);
			_mouse = new Vec2();
			
			//_manager = new ObjectsManager(_model.objects);
			
			if (_view.inited) {
				_start();
			} else {
				_view.addEventListener(Event.CONTEXT3D_CREATE, _start);
			}
			
			_timer.start();
		}
		
		private function onModelChange(event:MainModelEvent):void {
		}
		
		private function timer_timerHandler(event:Event):void {
			_pre();
			_render();
			_post();
		}
		
		private function _start(event:Event = null):void {
			_view.removeEventListener(Event.CONTEXT3D_CREATE, _start);
			
			_view.stage.addEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
			_view.stage.addEventListener(MouseEvent.MOUSE_DOWN, stage_mouseDownHandler);
			
			_prevTime = getTimer();
			_space = new Space(Vec2.get(0, 2500));
			//_debug = new ShapeDebug(_view.stage.stageWidth, _view.stage.stageHeight, 0xe0e0e0);
			//_debug.drawConstraints = true;
			//_view.addChild(_debug.display);
			
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
			
			
			
			//_addBox(new State(450, 0, 140, 40));
			//_addBox(new State(500, 0, 200, 20));
			
			for (var i:uint = 0; i < 10; i++) {
				//Добавление силуэта
				var sido:Sprite = new Silhoutte01();
				var bmd:BitmapData = new BitmapData(sido.width, sido.height, true, 0x00000000);
				bmd.draw(sido, new Matrix(.4, 0, 0, .4));
				var body:Body = _addCompoundBody(bmd);
				body.position.x = 400 + Math.random() * 200;
				body.position.y = 100 + Math.random() * 400;
				_model.objects.push(new CompoundObject(body));
			}
			
			for each (var object:IObject in _model.objects) {
				_view.addWrapper(object.wrapper);
			}
			
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
		 * Перед отрисовкой
		 */
		private function _pre():void {
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
		
			//for each (var wrapper:IModelWrapper in _model.wrappers) {
			//wrapper.
			//}
		
			//_model.objects[0].x += 1;
			//_model.objects[0].y += .3;
			//_model.refresh();
		}
		
		/**
		 * После отрисовки
		 */
		private function _post():void {
			
			//Двигаем отображения объектов
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
		
		/**
		 * Добавление простого блока
		 * @param	state
		 */
		private function _addBox(state:State):Body {
			var body:Body = new Body();
			body.position.setxy(state.x, state.y);
			body.shapes.add(new Polygon(Polygon.box(state.width, state.height)));
			body.rotation = state.rotation;
			body.space = _space;
			
			_model.objects.push(new CompoundObject(body));
			
			return body;
		}
		
		/**
		 * Добавление сложного объекта
		 * @param	bmd
		 */
		private function _addCompoundBody(bmd:BitmapData):Body {
			var iso:BitmapDataIso = new BitmapDataIso(bmd, 0x80);
			var body:Body = IsoBody.run(iso, iso.bounds);
			body.position.x = 500;
			body.position.y = 100;
			//body.userData.graphic = iso.graphic;
			body.space = _space;
			//_view.addChild(iso.graphic);
			return body;
		}
		
		public function get mouse():Vec2 {
			_mouse.x = _view.mouseX;
			_mouse.y = _view.mouseY;
			return _mouse;
		}
	
	}

}
