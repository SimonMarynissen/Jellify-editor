package gui {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class GridCell extends Sprite {
		
		[Embed(source = "../img/gridCell.png")] private static const GRID_CELL:Class;
		private static const CELL_BITMAPDATA:Array = new Array();
		
		private var
			X:int = 0,
			Y:int = 0,
			bitmap:Bitmap;
		
		public static function initBitmapData():void {
			for (var i:int = 0; i < 2; i++) {
				(CELL_BITMAPDATA[i] = new BitmapData(32, 32, true, 0)).copyPixels(
						new GRID_CELL().bitmapData,
						new Rectangle(32 * i, 0, 32, 32),
						new Point(0, 0), null, null, true);
			}
		}
		
		public function GridCell(X:int, Y:int) {
			this.X = X;
			this.Y = Y;
			this.x = 184 + 32 * X;
			this.y = 8 + 32 * Y;
			bitmap = new Bitmap(CELL_BITMAPDATA[0]);
			addChild(bitmap);
			addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
		}
		
		public function getX():int { return this.X; }
		public function getY():int { return this.Y; }
		
		private function mouseOver(e:MouseEvent):void {
			bitmap = new Bitmap(CELL_BITMAPDATA[1]);
			addChild(bitmap);
		}
		
		private function mouseOut(e:MouseEvent):void {
			bitmap = new Bitmap(CELL_BITMAPDATA[0]);
			addChild(bitmap);
		}
	}
}