package game.isometric
{
	import flash.geom.Point;
	
	public class Isometric
	{
		public static const TILE_WIDTH:int = 24;
		public static const TILE_HEIGHT:int = 12;
		
		public static function toIso(x:int, y:int):GridPoint
		{
			var toReturn:GridPoint = new GridPoint();
			var mouseY:int = (2 * y - x) / 2;
			var mouseX:int = x + mouseY;
			
			toReturn.row = Math.floor(mouseY / TILE_WIDTH);
			toReturn.col = Math.floor(mouseX / TILE_WIDTH);
			
			return toReturn;
		}
		
		public static function toScreen(x:int, y:int, level:int = 0):Point
		{
			var toReturn:Point = new Point(0, 0);
			
			toReturn.x = (y - x) * TILE_WIDTH;
			toReturn.y = (y + x) * TILE_HEIGHT;
			
			return toReturn;
		}
	}
}