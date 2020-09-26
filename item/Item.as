package game.item 
{
	import as3isolib.display.primitive.IsoBox;
	import flash.display.Sprite;
	import game.tile.TileManager;
	import as3isolib.display.IsoSprite;
	
	/**
	 * ...
	 * @author William J Robin
	 */
	
	public class Item implements IItem
	{
		private var _row:int;
		private var _col:int;
		private var _id:int;
		private var _rows:int;
		private var _cols:int;
		private var _type:int;
		private var _tile:String;
		private var _stackable:Boolean;
		private var _stackNumber:int;
		private var _heading:int;
		private var _xml:String;
		private var _tileManager:TileManager;
		private var _container:IsoSprite;
		private var _sprite:Sprite;
		
		//private var _container:IsoBox;
		
		public function Item() 
		{
			
		}
		
		public function init():void
		{
			this._tileManager = new TileManager();
		}
		
		public function release():void
		{
			
		}
		
		public function get row():int 
		{
			return _row;
		}
		
		public function set row(value:int):void 
		{
			_row = value;
		}
		
		public function get col():int 
		{
			return _col;
		}
		
		public function set col(value:int):void 
		{
			_col = value;
		}
		
		public function get id():int 
		{
			return _id;
		}
		
		public function set id(value:int):void 
		{
			_id = value;
		}
		
		public function get rows():int 
		{
			return _rows;
		}
		
		public function set rows(value:int):void 
		{
			_rows = value;
		}
		
		public function get cols():int 
		{
			return _cols;
		}
		
		public function set cols(value:int):void 
		{
			_cols = value;
		}
		
		public function get type():int 
		{
			return _type;
		}
		
		public function set type(value:int):void 
		{
			_type = value;
		}
		
		public function get tile():String 
		{
			return _tile;
		}
		
		public function set tile(value:String):void 
		{
			_tile = value;
		}
		
		public function get stackable():Boolean 
		{
			return _stackable;
		}
		
		public function set stackable(value:Boolean):void 
		{
			_stackable = value;
		}
		
		public function get stackNumber():int 
		{
			return _stackNumber;
		}
		
		public function set stackNumber(value:int):void 
		{
			_stackNumber = value;
		}
		
		public function get heading():int 
		{
			return _heading;
		}
		
		public function set heading(value:int):void 
		{
			_heading = value;
		}
		
		public function get xml():String 
		{
			return _xml;
		}
		
		public function set xml(value:String):void 
		{
			_xml = value;
		}
		
		public function get tileManager():TileManager 
		{
			return _tileManager;
		}
		
		public function set tileManager(value:TileManager):void 
		{
			_tileManager = value;
		}
		
		public function get container():IsoSprite
		{
			return _container;
		}
		
		public function set container(value:IsoSprite):void 
		{
			_container = value;
		}
		
		public function get sprite():Sprite 
		{
			return _sprite;
		}
		
		public function set sprite(value:Sprite):void 
		{
			_sprite = value;
		}
	}

}