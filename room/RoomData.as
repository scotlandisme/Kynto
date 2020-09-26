package game.room 
{
	import game.item.ItemManager;
	/**
	 * ...
	 * @author William J Robin
	 */
	public class RoomData 
	{
		public var id:int;
		public var name:String;
		public var description:String;
		public var owner:String;
		public var rows:int;
		public var cols:int;
		public var background:int;
		public var itemManager:ItemManager;
		public var items:Array;
		public var floor:int;
		
		public function RoomData() 
		{
			
		}
		
		public function toObject():Object
		{
			var obj:Object = {
				id : this.id,
				name : this.name,
				description : this.description,
				owner : this.owner,
				rows : this.rows,
				cols : this.cols,
				background : this.background,
				floor : this.floor
			}
			
			return obj;
		}
	}

}