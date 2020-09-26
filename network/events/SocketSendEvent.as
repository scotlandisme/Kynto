package game.network.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author William J Robin
	 */
	
	public class SocketSendEvent extends Event 
	{
		public static const SOCKET_SEND_DATA:String = "socketSendData";
		
		private var _packet:String;
		private var _jsonObj:Object;
		
		public function SocketSendEvent(packet:String, json:Object = null) 
		{ 
			_packet = packet;
			_jsonObj = json;
			
			super(SOCKET_SEND_DATA, false, false);
		} 
		
		public function get packet():String
		{
			return _packet;
		}
		
		public function get jsonObj():Object
		{
			return _jsonObj;
		}
		
		public override function clone():Event 
		{ 
			return new SocketSendEvent(_packet, _jsonObj);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("SendDataEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
	}
}