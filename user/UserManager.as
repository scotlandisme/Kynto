package game.user 
{
	import game.IDisposable;
	import game.UserObject;
	/**
	 * ...
	 * @author William J Robin
	 */
	
	public class UserManager implements IDisposable
	{
		public var userProperties:UserObject;
		
		public function UserManager() 
		{
			
		}
		
		public function init():void
		{
			this.userProperties = new UserObject();
		}
		
		public function release():void
		{
			this.userProperties = null;
		}
		
		public function processInventory():void
		{
			
		}
	}

}