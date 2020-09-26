package game.api 
{
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import game.api.events.APIEvent;
	import game.EventManager;
	import game.GameFlow;
	import game.network.events.SocketSendEvent;
	import game.network.PacketTypes;
	/**
	 * ...
	 * @author William J Robin
	 */
	
	public class API 
	{
		public static const TUNNEL_LOGIN:String = "loginRequest";
		
		private var _gameFlow:GameFlow
		public var eventManager:EventManager;
		
		public function API() 
		{
			
		}
		
		public function init():void
		{
			if (ExternalInterface.available)
			{
				ExternalInterface.addCallback("tunnel", tunnel);
			}
			
			this.addEventListeners();
		}
		
		public function addEventListeners():void
		{
			this.eventManager.addEventListener("apiEvent", eventManager_apiEvent);
		}
		
		private function eventManager_apiEvent(e:APIEvent):void 
		{
			var event:Object = { 
				type : e.eventType, 
				data : e.parameters
			};
			
			if(ExternalInterface.available) ExternalInterface.call("Kynto.dispatchEvent", event);
		}
		
		private function userData(e:APIEvent):void
		{

		}
		
		private function tunnelEvent(event:APIEvent):void
		{
			ExternalInterface.call("tunnelEvent", event.toObject());
		}
		
		private function requestRoom(id:*):void
		{
			this.eventManager.dispatchEvent(new SocketSendEvent("RC", { RID : id, S : 1 } ));
		}
		
		private function loginRequest(user:String, pass:String):void
		{
			this.eventManager.dispatchEvent(new SocketSendEvent("Li", { U : (user as String), P : "db2d303c20b9468bbe90114d3d1874b3" } ));
		}
		
		private function messageRequest(message:String):void
		{
			//this.eventManager_apiEvent()
		}
		
		private function tunnel(func:String, ...args):*
		{
			switch(func)
			{
				case "message":
				
				break;
				case "roomRequest":
					this.requestRoom(args[0]);
				break;
				case "login":
					this.loginRequest(args[0], args[1]);
				break;
				case "getUser":
					return _gameFlow.userManager.userProperties.toObject();
				break;
				case "dispatchEvent":
					//for real
				break;
				case TUNNEL_LOGIN:
					//return this.onLoginRequest( ...args);
				break;
				default: return null;
			}
		}
	}

}