package gui {
	
	import flash.display.Sprite;
	import flash.geom.Point;

	public class Connection extends Sprite {
		
		private var
			firstBlock:Point,
			secondBlock:Point,
			firstDir:Point,
			secondDir:Point;
		
		public static function hasBlockInConnectionArray(X:int, Y:int, arr:Array):Boolean {
			return (X == arr[0] && Y == arr[1]) || (X == arr[2] && Y == arr[3]);
		}
		
		public static function isConnectionArray(b1:Point, b2:Point, arr:Array):Boolean {
			return (b1.x == arr[0] && b1.y == arr[1] && b2.x == arr[2] && b2.y == arr[3]) ||
					(b2.x == arr[0] && b2.y == arr[1] && b1.x == arr[2] && b1.y == arr[3]);
		}
		
		public function Connection(firstBlock:Point, secondBlock:Point, firstDir:Point, secondDir:Point) {
			super();
			this.firstBlock = firstBlock.clone();
			this.secondBlock = secondBlock.clone();
			this.firstDir = firstDir.clone();
			this.secondDir = secondDir.clone();
			this.x = 184;
			this.y = 8;
			draw();
		}
		
		public function hasBlock(X:int, Y:int):Boolean {
			var p:Point = new Point(X, Y);
			return firstBlock.equals(p) || secondBlock.equals(p);
		}
		
		public function isConnectionBetween(b1:Point, b2:Point):Boolean {
			return (b1.equals(firstBlock) && b2.equals(secondBlock)) || (b1.equals(secondBlock) && b2.equals(firstBlock));
		}
		
		public function transfer(transferX:int, transferY:int, sminX:int, smaxX:int, sminY:int, smaxY:int):void {
			var changed:Boolean = false;
			if (sminX <= firstBlock.x && firstBlock.x <= smaxX && sminY <= firstBlock.y && firstBlock.y <= smaxY) {
				firstBlock.x += transferX;
				firstBlock.y += transferY;
				changed = true;
			}
			if (sminX <= secondBlock.x && secondBlock.x <= smaxX && sminY <= secondBlock.y && secondBlock.y <= smaxY) {
				secondBlock.x += transferX;
				secondBlock.y += transferY;
				changed = true;
			}
			if (changed) {
				graphics.clear();
				draw();
			}
		}
		
		private function draw():void {
			graphics.lineStyle(2, 0x800080, 1);
			graphics.moveTo(firstBlock.x * 32 + 16 + 10 * firstDir.x, firstBlock.y * 32 + 16 + 10 * firstDir.y);
			graphics.lineTo(secondBlock.x * 32 + 16 + 10 * secondDir.x, secondBlock.y * 32 + 16 + 10 * secondDir.y);
		}
		
		public function interDraw(transferX:int, transferY:int, sminX:int, smaxX:int, sminY:int, smaxY:int):void {
			graphics.clear();
			var firstIn:Boolean = (sminX <= firstBlock.x && firstBlock.x <= smaxX && sminY <= firstBlock.y && firstBlock.y <= smaxY);
			var secondIn:Boolean = (sminX <= secondBlock.x && secondBlock.x <= smaxX && sminY <= secondBlock.y && secondBlock.y <= smaxY);
			graphics.lineStyle(2, 0x800080, 1);
			graphics.moveTo(firstBlock.x * 32 + int(firstIn) * transferX * 32 + 16 + 10 * firstDir.x, firstBlock.y * 32 + int(firstIn) * transferY * 32 + 16 + 10 * firstDir.y);
			graphics.lineTo(secondBlock.x * 32 + int(secondIn) * transferX * 32 + 16 + 10 * secondDir.x, secondBlock.y * 32 + int(secondIn) * transferY * 32 + 16 + 10 * secondDir.y);
		}
	}
}