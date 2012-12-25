package controllers.objects {
	
	/**
	 * ...
	 * @author Frankie Wilde
	 */
	public class DisplayObjectIso {
		
		
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

}
