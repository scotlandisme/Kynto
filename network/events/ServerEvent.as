package game.network.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author William J Robin
	 */
	
	public class ServerEvent extends Event
	{
		public static const PING:String = "ping";
		public static const PING_REPLY:String = "pingReply";
		public static const CONNECTED:String = "connected";
		public static const DISCONNECTED:String = "disconnected";
		public static const LOGGED_IN:String = "loggedIn";
		public static const LOGIN_FAILED:String = "loginFailed";
		public static const USERS_ONLINE:String = "usersOnline";
		public static const GENERATE_ROOM:String = "generateRoom";
		public static const MOVE_AVATAR:String = "moveAvatar";
		public static const ADD_AVATAR:String = "addAvatar";
		public static const USER_ADD_CHAT:String = "addChat";
		public static const ALERT:String = "alert";
		public static const CHAT_SPAM:String = "chatSpam";
		public static const REMOVE_AVATAR:String = "removeAvatar";
		public static const SERVER_VERSION:String = "serverVersion";
		public static const ROOM_KICK:String = "roomKick";
		public static const ROOM_LOAD_FAILED:String = "roomLoadFailed";
		public static const AVATAR_GHOST:String = "avatarGhost";
		public static const USER_DATA:String = "userData";
		public static const USER_STATUS:String = "userStatus";
		public static const ROOM_LOAD_COMPLETE:String = "roomLoadComplete";
		public static const NAVIGATOR_LIST:String = "navigatorList";
		public static const AVATAR_CHANGER_DETAILS:String = "avatarChangerDetails";
		public static const MOVE_ITEM:String = "moveItem";
		public static const PDA_FRIENDLIST:String = "pdaFriendList";
		public static const FURNITURE_ACTION:String = "furnitureAction";
		public static const ADD_ITEM:String = "addItem";
		
		/*
		 * Client events
		 */
		
		public static const SEND_MESSAGE:String = "sendMessage";
		public static const MOVE_REQUEST:String = "moveRequest";
		public static const LOGIN_REQUEST:String = "loginRequest";
		public static const CREATE_ALERT:String = "createAlert";
		public static const SOCKET_ERROR:String = "socketError";
		public static const REQUEST_ROOM:String = "requestRoom";
		public static const AVATAR_CLICK:String = "avatarClick";
		public static const OPEN_NAVIGATOR:String = "openNavigator";
		public static const CLIENT_RESTART:String = "clientRestart";
		public static const CLIENT_DESTROY:String = "clientDestroy";
		public static const MATTIE_BSOD:String = "mattieBsod";
		public static const OPEN_HELP:String = "helpRequest";
		public static const OPEN_CONSOLE:String = "openConsole";
		public static const OPEN_CLOTHES:String = "openClothes";
		public static const ADD_CHAT_BUBBLE:String = "addChatBubble";
		public static const SOUND_EVENT:String = "soundEvent";
		public static const STATUS_TEXT:String = "statusText";
		public static const TOGGLE_WINDOW:String = "toggleWindow";
		public static const FURNITURE_CLICK:String = "furnitureClick";
		public static const FURNITURE_DRAG:String = "furnitureDrag";
		public static const WIREFRAME_TOGGLE:String = "wireFrameToggle";
		public static const WIREFRAME_ENABLED:String = "wireFrameEnabled";
		public static const FURNITURE_LOADED:String = "furnitureLoaded";
		public static const EDIT_ROOM:String = "editRoom";
		public static const EDIT_ROOM_RESPONSE:String = "editRoomResponse";
		public static const DROP_ITEM:String = "dropFurni";
		
		public static const PICKUP_ITEM:String = "pickupItem";
		public static const ROTATE_ITEM:String = "rotateItem";
		public static const REMOVE_ITEM:String = "removeItem";
		
		public static const INVENTORY_ADD:String = "inventoryAdd";
		public static const INVENTORY_REMOVE:String = "inventoryRemove";
		public static const INVENTORY_UPDATE:String = "invetoryUpdate";
		
		private var ourParams:Object;
		private var delay:int;
		
		public function ServerEvent(type:String, params:Object = null) 
		{
			ourParams = (params != null) ? params : new Object();
			super(type, true, false);
		}

		public function get parameters():Object 
		{ 
			return ourParams; 
		}
		override public function clone():Event
		{
			return new ServerEvent(type, ourParams);
		}
		
	}

}