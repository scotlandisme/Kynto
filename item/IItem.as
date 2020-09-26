package game.item 
{
	import as3isolib.display.IsoSprite;
	import as3isolib.display.primitive.IsoBox;
	import flash.display.Sprite;
	import game.room.ISortable;
	import game.tile.TileManager;
	
	/**
	 * ...
	 * @author William J Robin
	 */
	
	public interface IItem extends ISortable
	{
		function get row():int 
		function set row(value:int):void 
		
		function get col():int 
		function set col(value:int):void 
		
		function get id():int 
		function set id(value:int):void 
		
		function get rows():int 
		function set rows(value:int):void 
		
		function get cols():int 
		function set cols(value:int):void 
		
		function get type():int 
		function set type(value:int):void 
		
		function get tile():String 
		function set tile(value:String):void 
		
		function get stackable():Boolean 
		function set stackable(value:Boolean):void 
		
		function get stackNumber():int 
		function set stackNumber(value:int):void 
		
		function get heading():int 
		function set heading(value:int):void 
		
		function get xml():String 
		function set xml(value:String):void 
		
		function get tileManager():TileManager 
		function set tileManager(value:TileManager):void 
	
		function get container():IsoSprite
		function set container(value:IsoSprite):void
		
		function get sprite():Sprite 
		function set sprite(value:Sprite):void
	}
	
}