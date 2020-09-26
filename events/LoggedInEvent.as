package game.events 
{
	import flash.events.Event;
	import game.UserObject;
	
	/**
	 * ...
	 * @author William J Robin
	 */
	
	public class LoggedInEvent extends Event
	{
		public var userProperties:UserObject = null;
		public static const LOGGED_IN:String = "clientLoggedIn";
		
		public function LoggedInEvent(userProperties:UserObject) 
		{
			this.userProperties = userProperties;
			super(type, true, false);
		}
		
		override public function clone():Event
		{
			return new LoggedInEvent(this.userProperties);
		}
	}

}