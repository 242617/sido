package views.objects {
	
	import com.styleru.stage3d.helpers.ModelWrapper;
	import com.styleru.stage3d.primitives.Vertex;
	import com.styleru.stage3d.shaders.ShaderBase;
	
	/**
	 * ...
	 * @author Frankie Wilde
	 */
	
	public class BoxWrapper extends ModelWrapper {
		
		public function BoxWrapper() {
			
			var v1:Vertex = new Vertex( -10, -10, -0, 1, 	0, 0, 	Math.random(), Math.random(), Math.random(), 1);
			var v2:Vertex = new Vertex(10, -10, -0, 1, 		0, 0, 	Math.random(), Math.random(), Math.random(), 1);
			var v3:Vertex = new Vertex(10, 10, -0, 1, 		0, 0, 	Math.random(), Math.random(), Math.random(), 1);
			var v4:Vertex = new Vertex( -10, 10, -0, 1, 	0, 0, 	Math.random(), Math.random(), Math.random(), 1);
			var v5:Vertex = new Vertex( -10, -10, 10, 1, 	0, 0, 	Math.random(), Math.random(), Math.random(), 1);
			var v6:Vertex = new Vertex(10, -10, 10, 1, 		0, 0, 	Math.random(), Math.random(), Math.random(), 1);
			var v7:Vertex = new Vertex(10, 10, 10, 1, 		0, 0, 	Math.random(), Math.random(), Math.random(), 1);
			var v8:Vertex = new Vertex( -10, 10, 10, 1, 	0, 0, 	Math.random(), Math.random(), Math.random(), 1);
			
			var shader:ShaderBase = new ShaderBase(
				"m44 op, va0, vc0\n" +
				"mov v0, va0\n"+
				"mov v1, va1\n"+
				"mov v2, va2\n",
				
				"mov oc, v2\n"
			)
			super(new com.styleru.stage3d.primitives.Box(v1, v2, v3, v4, v5, v6, v7, v8), shader);
			
			move(30 + Math.random(), 100 * Math.random(), 100 * Math.random());
			scale(Math.random(), Math.random(), Math.random());
			rotationSpeed.x = Math.random();
			rotationSpeed.y = Math.random();
			rotationSpeed.z = Math.random();
			
		}
		
	}

}
