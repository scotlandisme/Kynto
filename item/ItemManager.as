package game.item 
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author William J Robin
	 */
	
	public class ItemManager 
	{
		public var items:Dictionary;
		
		public function ItemManager() 
		{
			
		}
		
		public function init():void
		{
			this.items = new Dictionary();
		}
		
		public function release():void
		{
			this.items = null;
		}
		
		public function add(key:int, item:IItem):void
		{
			this.items[key] = item;
		}
		
		public function removeByID(key:int):void
		{
			this.items[key] = null;
		}
		
		public function getById(key:int):IItem
		{
			return this.items[key];
		}
	}

}