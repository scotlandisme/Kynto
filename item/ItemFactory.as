package game.item 
{
	import game.item.IItem;
	import game.item.items.BitmapItem;
	
	/**
	 * ...
	 * @author William J Robin
	 */
	
	public class ItemFactory 
	{
		
		public function ItemFactory() 
		{
			
		}
		
		public static function create():IItem
		{
			return new BitmapItem();
		}
	}

}