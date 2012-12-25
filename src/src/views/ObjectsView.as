package views {
	
	import com.junkbyte.console.Cc;
	import com.styleru.display.PointShape;
	import com.styleru.stage3d.core.Stage3DScene;
	import com.styleru.stage3d.helpers.ModelWrapper;
	import com.styleru.stage3d.interfaces.IModelWrapper;
	import com.styleru.utils.MathAdv;
	import com.styleru.vo.Color;
	import com.styleru.vo.Dimensions;
	import com.styleru.vo.State;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import interfaces.IObject;
	import views.objects.BoxWrapper;
	import views.objects.CompoundObject;
	
	/**
	 * ...
	 * @author Frankie Wilde
	 */
	public class ObjectsView extends Stage3DScene {
		
		private var _objects:Vector.<IObject>;
		private var _modelWrapper:IModelWrapper;
		private var _box:BoxWrapper;
		
		
		public function ObjectsView() {
			super(new Dimensions(800, 600), new Color(.8, .8, .8));
		}
		
		override public function setup():void {
			super.setup();
			cameraMatrix.appendTranslation( -dimensions.width >> 1, dimensions.height >> 1, 240);
		}
		
		override protected function render():void {
			Cc.info("render");
			super.render();
			
			for (var i:uint = 0; i < _objects.length; i++) {
				var object:IObject = _objects[i];
				
				var wrapper:Point = new Point(object.wrapper.matrix.position.x, object.wrapper.matrix.position.y);
				var body:Point = new Point(object.body.position.x, object.body.position.y);
				var difference:Point = new Point(body.x - wrapper.x, - body.y - wrapper.y);
				
				//object.wrapper.rotate(MathAdv.r2d(_rotations[i] - object.body.rotation), Vector3D.Z_AXIS);
				object.wrapper.move(difference.x, difference.y, 0);
			}
			
			//graphics.clear();
			//for each (var object:IObject in _objects) {
				//graphics.beginFill(0xff8000);
				//graphics.moveTo(object.vertexes[0].x, object.vertexes[0].y);
				//
				//for (var i:uint = 1; i < object.vertexes.length; i++) {
					//graphics.lineTo(object.vertexes[i].x, object.vertexes[i].y);
				//}
				//
			//}
		}
		
		public function set items(value:Vector.<IObject>):void {
			_objects = value;
		}
	
	}

}
