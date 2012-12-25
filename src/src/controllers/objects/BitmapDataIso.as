package controllers.objects {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.PixelSnapping;
	import nape.geom.AABB;
	import nape.geom.IsoFunction;
	
	/**
	 * ...
	 * @author Frankie Wilde
	 */
	
	public class BitmapDataIso implements IsoFunction {
	
		public var bmd:BitmapData;
		public var alphaThreshold:Number;
		public var bounds:AABB;
		
		private var _bm:Bitmap;
		
		public function BitmapDataIso(bmd:BitmapData, alphaThreshold:Number = 0x80):void {
			this.bmd = bmd;
			this.alphaThreshold = alphaThreshold;
			bounds = new AABB(0, 0, bmd.width, bmd.height);
			_bm = new Bitmap(bmd, PixelSnapping.NEVER, true);
		}
		
		public function get graphics():DisplayObject {
			return _bm;
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
			if (ix >= bmd.width)
				ix = bmd.width - 1;
			if (iy >= bmd.height)
				iy = bmd.height - 1;
			
			// iso-function values at each pixel centre.
			var a11:Number = alphaThreshold - (bmd.getPixel32(ix, iy) >>> 24);
			var a12:Number = alphaThreshold - (bmd.getPixel32(ix + 1, iy) >>> 24);
			var a21:Number = alphaThreshold - (bmd.getPixel32(ix, iy + 1) >>> 24);
			var a22:Number = alphaThreshold - (bmd.getPixel32(ix + 1, iy + 1) >>> 24);
			
			// Bilinear interpolation for sample point (x,y)
			var fx:Number = x - ix;
			var fy:Number = y - iy;
			return a11 * (1 - fx) * (1 - fy) + a12 * fx * (1 - fy) + a21 * (1 - fx) * fy + a22 * fx * fy;
		}
	
	}

}
