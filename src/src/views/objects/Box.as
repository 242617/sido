package views.objects {
	
	import com.styleru.display.PointShape;
	import flash.geom.Point;
	import interfaces.IObject;
	
	/**
	 * ...
	 * @author Frankie Wilde
	 */
	
	public class Box extends BasicObject {
		
		protected var lt:Point;
		protected var rt:Point;
		protected var rb:Point;
		protected var lb:Point;
		
		
		public function Box(width:Number = 100, height:Number = 100) {
			vertexes.push(lt = new Point());
			vertexes.push(rt = new Point());
			vertexes.push(rb = new Point());
			vertexes.push(lb = new Point());
			
			this.width = width;
			this.height = height;
		}
		
		override protected function refresh():void {
			super.refresh();
			
			lt.x = x;
			lt.y = y;
			
			rt.x = x + width;
			rt.y = y;
			
			rb.x = x + width;
			rb.y = y + height;
			
			lb.x = x;
			lb.y = y + height;
		}
		
		
	
	}

}
