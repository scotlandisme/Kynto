package game.tile 
{
	import flash.utils.Dictionary;
	import game.item.IItem;
	/**
	 * ...
	 * @author William J Robin
	 */
	
	public class TileManager 
	{
		public var tiles:Dictionary;
		
		public function TileManager() 
		{
			
		}
		
		public function init():void
		{
			this.tiles = new Dictionary();
		}
		
		public function release():void
		{
			this.tiles = null;
		}
		
		public function add(key:String, tile:ITile):void
		{
			this.tiles[key] = tile;
		}
		
		public function addItem(tile:ITile, item:IItem):void
		{
			
		}
		
		public function exists(row:int, col:int):Boolean
		{
			if (this.tiles[Tile.fuseTile(row, col)] != null)
			{
				return true;
			}
			return false;
		}
		
		public function remove(key:String):void
		{
			this.tiles[key] = null;
		}
		
		public function getByID(key:int):ITile
		{
			if (this.tiles[key])
			{
				return this.tiles[key];
			}
			
			return null;
		}
		
		public function getTile(row:int, col:int):Tile 
		{
			return this.tiles[Tile.fuseTile(row, col)];
		}
	}

}