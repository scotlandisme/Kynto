package game.tile 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import game.isometric.GridPoint;
	import game.item.ItemManager;
	/**
	 * ...
	 * @author William J Robin
	 */
	
	public class Tile implements ITile
	{
		public var bitmap:Bitmap;
		public var row:int;
		public var col:int;
		private var _items:ItemManager;
		
		
		public function Tile() 
		{
			items = new ItemManager();
		}
		
		public function release():void
		{
			if (this.bitmap.bitmapData is BitmapData)
			{
				this.bitmap = null;
			}
			
			this.row = undefined;
			this.col = undefined;
		}
		
		public function get tile():String
		{
			return Tile.fuseTile(this.row, this.col);
		}
		
		public function get items():ItemManager 
		{
			return _items;
		}
		
		public function set items(itemManager:ItemManager):void 
		{
			_items = itemManager;
		}
		
		public static function parseTile(tile:String):GridPoint
		{
			var parts:Array = tile.split(/_/);
			var gp:GridPoint = new GridPoint();
			
			gp.row = parts[0];
			gp.col = parts[1];
			
			return gp;
		}
		
		public static function fuseTile(row:int, col:int):String
		{
			return row.toString() + "_" + col.toString();
		}
	}

}