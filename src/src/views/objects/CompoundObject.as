package views.objects {
	
	import com.junkbyte.console.Cc;
	import com.styleru.stage3d.helpers.ModelWrapper;
	import com.styleru.stage3d.interfaces.IModelWrapper;
	import com.styleru.stage3d.primitives.Box;
	import com.styleru.stage3d.primitives.Model3D;
	import com.styleru.stage3d.primitives.Vertex;
	import com.styleru.stage3d.shaders.ShaderBase;
	import interfaces.IObject;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.shape.Polygon;
	
	/**
	 * ...
	 * @author Frankie Wilde
	 */
	
	public class CompoundObject implements IObject {
		
		private var _body:Body;
		private var _wrapper:IModelWrapper;
		
		
		public function CompoundObject(body:Body) {
			_body = body;
			
			
			
			var model:Model3D = new Model3D();
			
			var i:uint;
			_body.shapes.foreach(function(polygon:Polygon):void {
				//Cc.log("polygon.localVerts.length:", polygon.localVerts.length);
				
				polygon.localVerts.foreach(function(point:Vec2):void {
					//Cc.log("point:", point);
					model.addVertex(new Vertex(point.x, point.y, 0, 1, 0, 0, .2, .2, .2, 1));
					model.indexes.push(i);
					i++;
				})
			})
			//model.vertexes
			//var v1:Vertex = new Vertex( -10, -10, -0, 1, 	0, 0, 	Math.random(), Math.random(), Math.random(), 1);
			//var v2:Vertex = new Vertex(10, -10, -0, 1, 		0, 0, 	Math.random(), Math.random(), Math.random(), 1);
			//var v3:Vertex = new Vertex(10, 10, -0, 1, 		0, 0, 	Math.random(), Math.random(), Math.random(), 1);
			//var v4:Vertex = new Vertex( -10, 10, -0, 1, 	0, 0, 	Math.random(), Math.random(), Math.random(), 1);
			//var v5:Vertex = new Vertex( -10, -10, 10, 1, 	0, 0, 	Math.random(), Math.random(), Math.random(), 1);
			//var v6:Vertex = new Vertex(10, -10, 10, 1, 		0, 0, 	Math.random(), Math.random(), Math.random(), 1);
			//var v7:Vertex = new Vertex(10, 10, 10, 1, 		0, 0, 	Math.random(), Math.random(), Math.random(), 1);
			//var v8:Vertex = new Vertex( -10, 10, 10, 1, 	0, 0, 	Math.random(), Math.random(), Math.random(), 1);
			//var model:Model3D = new Box(v1, v2, v3, v4, v5, v6, v7, v8);
			
			
			var shader:ShaderBase = new ShaderBase(
				"m44 op, va0, vc0\n" +
				"mov v0, va0\n"+
				"mov v1, va1\n"+
				"mov v2, va2\n",
				
				"mov oc, v2\n"
			)
			_wrapper = new ModelWrapper(model, shader);
			//_wrapper.scale(.4, .4, .4);
		}
		
		public function get body():Body {
			return _body;
		}
		
		public function get wrapper():IModelWrapper {
			return _wrapper;
		}
		
	}

}
