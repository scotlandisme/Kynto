package game.api.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author William J Robin
	 */
	public class APIEvent extends Event 
	{
		
		public static const NEW_MESSAGE:String = "newMessage";
		public static const USER_COMMAND:String = "userCommand";
		public static const ADD_USER:String = "addUser";
		public static const USER_STATUS:String = "userStatus";
		public static const REMOVE_USER:String = "removeUser";
		public static const LOGGED_IN:String = "loggedIn";
		public static const JOINED_ROOM:String = "joinedRoom";
		public static const USER_MOVED:String = "userMoved";
		public static const USER_DATA:String = "userData";
		public static const NAVIGATOR_LIST:String = "navigatorList"
		public static const CONNECTED:String = "connected";
		public static const DISCONNECTED:String = "disconnected";
		public static const ALERT:String = "alert";
		public static const ADD_CHAT:String = "addChat";
		public static const TRACE:String = "trace";
		public static const ROOM_LOAD_FAILED:String = "roomLoadFailed";
		public static const AVATAR_CLICKED:String = "avatarClicked";
		
		private var ourParams:Object;
		private var _eventType:String;
		
		public function APIEvent(type:String, params:Object = null) 
		{ 
			_eventType = type;
			ourParams = (params != null) ? params : new Object();
			super("apiEvent", false, false);
		} 
		
		public override function clone():Event 
		{ 
			return new APIEvent(type, ourParams);
		} 
		
		public function get parameters():Object 
		{ 
			return ourParams; 
		}
		
		public function get eventType():String
		{
			return _eventType;
		}
		
		public override function toString():String 
		{ 
			return formatToString("APIEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function toObject():Object
		{
			var obj:Object = {
				type : _eventType,
				data : ourParams
			}
			
			return obj;
		}
	}
	
}