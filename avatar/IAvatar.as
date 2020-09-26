package game.avatar 
{
	import as3isolib.display.IsoSprite;
	import as3isolib.display.primitive.IIsoPrimitive;
	import flash.geom.Point;
	import game.room.ISortable;
	
	/**
	 * ...
	 * @author William J Robin
	 */
	
	public interface IAvatar extends ISortable
	{
		function init():void
		function run():void
		function build():void
		
		function get row():int 
		function set row(value:int):void 
		
		function get col():int 
		function set col(value:int):void 
		
		function get clothesData():Clothing
		function processClothesData(value:Object):void 
		
		function get status():String 
		function set status(value:String):void 

		function get mission():String 
		function set mission(value:String):void 
		
		function set id(value:int):void 
		function get id():int
		
		function get username():String 
		function set username(value:String):void 
		
		function get container():IsoSprite
		function set container(value:IsoSprite):void
		
		function get stepper():Stepper
		function set stepper(value:Stepper):void
		
		function get easing():Boolean
		function set easing(value:Boolean):void
		
		function get offset():Point
		function set offset(value:Point):void 
		
		function set x(value:Number):void 
		function get x():Number
		
		function set y(value:Number):void 
		function get y():Number
		
		
		function set state(value:String):void
		function set header(value:int):void
		function release():void
		function toObject():Object
		function offsetAvatar(state:String, direction:int):Point;
	}
	
}