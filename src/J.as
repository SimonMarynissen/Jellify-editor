package {
	
	import flash.geom.Point;

	public class J {
		
		public static const
			WALL_LAYER:int = 0,
			BLOCK_LAYER:int = 1,
			WALL_ATTACHMENT_LAYER:int = 2,
			FORCE_FIELD_LAYER:int = 3,
			WALL_BLOCK_SEPARATION:int = 4,
			LAYER_AMOUNT:int = 5;
		
		public static function getIndexFrom(xDir:int, yDir:int):int {
			if (xDir == 0 && yDir == -1)
				return 0;
			if (xDir == -1 && yDir == 0)
				return 1;
			if (xDir == 1 && yDir == 0)
				return 2;
			if (xDir == 0 && yDir == 1)
				return 3;
			return 4;
		}
		
		public static function getDirectionFromIndex(index:int):Point {
			if (index == 0)
				return new Point(0, -1);
			if (index == 1)
				return new Point(-1, 0);
			if (index == 2)
				return new Point(1, 0);
			if (index == 3)
				return new Point(0, 1);
			return new Point();
		}
	}
}