package game.avatar 
{
	import flash.display.IDrawCommand;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author William J Robin
	 */
	
	public class AvatarManager 
	{
		public var avatars:Dictionary;
		
		public function AvatarManager() 
		{
			this.init();
		}
		
		public function init():void
		{
			this.avatars = new Dictionary();
		}
		
		public function release():void
		{
			this.avatars = null;
		}
		
		public function add(key:int, avatar:IAvatar):void
		{
			this.avatars[key] = avatar;
		}
		
		public function getByID(key:int):IAvatar
		{
			if (!this.avatars)
			{
				trace("error fetching " + key);
				return null;
			}
			
			if (this.avatars[key])
			{
				return this.avatars[key] as IAvatar;
			}
			
			return null;
		}
		
		public function removeByID(key:int):void
		{
			this.avatars[key] = null;
		}
	}

}