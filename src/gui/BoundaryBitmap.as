package gui {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	public class BoundaryBitmap extends Bitmap {
		
		public var
			X:int,
			Y:int;
		
		public function BoundaryBitmap(X:int, Y:int, bitmapData:BitmapData = null) {
			super(bitmapData);
			this.X = X;
			this.Y = Y;
		}	
	}
}