package game.isometric 
{
	/**
	 * ...
	 * @author William J Robin
	 */
	
	public class GridPoint
	{
		public var row:int;
		public var col:int;
		
		public function GridPoint(row:int = 0, col:int = 0) 
		{
			this.row = row;
			this.col = col;
		}
		
		public function get tile():String
		{
			return row.toString() + "_" + col.toString();
		}
		
		public function toString():String
		{
			return "row: " + row + " col: " + col;
		}
	}
}