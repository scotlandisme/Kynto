package game.network 
{
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.XMLSocket;
	import flash.system.Security;
	import flash.system.System;
	import flash.utils.Dictionary;
	import game.api.events.APIEvent;
	
	import game.Logger;
	import game.EventManager;
	import game.IDisposable;
	import game.network.events.ServerEvent;
	import game.network.events.SocketSendEvent;
	
	/**
	 * ...
	 * @author William J Robin
	 */
	
	public class SocketManager implements IDisposable
	{
		public var eventManager:EventManager;
		public var possiblePackets:Dictionary;
		
		private var _ip:String = "localhost";
		private var _port:int = 3500;
		private var _socket:XMLSocket;
		
		public function SocketManager() 
		{
			this.possiblePackets = new Dictionary();
			this.possiblePackets[PacketTypes.ADD_AVATAR] = ServerEvent.ADD_AVATAR;
			this.possiblePackets[PacketTypes.REMOVE_AVATAR] = ServerEvent.REMOVE_AVATAR;
			this.possiblePackets[PacketTypes.AVATAR_CHANGER_DETAILS] = ServerEvent.AVATAR_CHANGER_DETAILS;
			this.possiblePackets[PacketTypes.PING] = ServerEvent.PING;
			this.possiblePackets[PacketTypes.PING_REPLY] = ServerEvent.PING_REPLY;
			this.possiblePackets[PacketTypes.MOVE_AVATAR] = ServerEvent.MOVE_AVATAR;
			this.possiblePackets[PacketTypes.CONNECTED] = ServerEvent.CONNECTED;
			this.possiblePackets[PacketTypes.UPDATE_AVATAR_STATUS] = ServerEvent.USER_STATUS; // i think
			this.possiblePackets[PacketTypes.SERVER_VERSION] = ServerEvent.SERVER_VERSION;
			this.possiblePackets[PacketTypes.LOGIN_FAILED] = ServerEvent.LOGIN_FAILED;
			this.possiblePackets[PacketTypes.LOGIN_ACCEPTED] = ServerEvent.LOGGED_IN;
			this.possiblePackets[PacketTypes.DISCONNECTED] = ServerEvent.DISCONNECTED;
			this.possiblePackets[PacketTypes.ROOM_DATA] = ServerEvent.GENERATE_ROOM;
			this.possiblePackets[PacketTypes.PDA_FRIENDLIST] = ServerEvent.PDA_FRIENDLIST;
			this.possiblePackets[PacketTypes.USER_DATA] = ServerEvent.USER_DATA;
			this.possiblePackets[PacketTypes.ROOM_KICK] = ServerEvent.ROOM_KICK;
			this.possiblePackets[PacketTypes.CHAT_SPAM] = ServerEvent.CHAT_SPAM;
			this.possiblePackets[PacketTypes.USER_ADD_CHAT] = ServerEvent.USER_ADD_CHAT;
			this.possiblePackets[PacketTypes.NAVIGATOR_DATA] = ServerEvent.NAVIGATOR_LIST;
			this.possiblePackets[PacketTypes.SERVER_ALERT] = ServerEvent.ALERT;
			this.possiblePackets[PacketTypes.ROOM_CHANGE_FAILED] = ServerEvent.ROOM_LOAD_FAILED;
		}
		
		public function init():void
		{
			this._socket = new XMLSocket(this._ip, this._port);
			this.addEventListners();
			
			for (var packet:String in this.possiblePackets) {
				//this.eventManager.dispatchEvent(new APIEvent(APIEvent.TRACE, { message : "Loaded packet handle -> " + this.possiblePackets[packet] } ));
				Logger.log("Loaded event -> " + this.possiblePackets[packet] + " for packet [" + packet + "]");
			}
		}
		
		public function release():void
		{

		}

		public function addEventListners():void
		{
            this._socket.addEventListener(Event.CLOSE, closeHandler);
            this._socket.addEventListener(Event.CONNECT, connectHandler);
            this._socket.addEventListener(DataEvent.DATA, dataHandler);
            this._socket.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			this._socket.addEventListener(IOErrorEvent.NETWORK_ERROR, networkErrorHandler);
            this._socket.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            this._socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			
			this.eventManager.addEventListener(SocketSendEvent.SOCKET_SEND_DATA, sendData); //our road out
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void
		{
			this.eventManager.dispatchEvent(new ServerEvent(ServerEvent.DISCONNECTED));
		}
		
		private function networkErrorHandler(event:IOErrorEvent):void
		{
			this.eventManager.dispatchEvent(new ServerEvent(ServerEvent.DISCONNECTED));
		}
		
		private function closeHandler(event:Event):void
		{
			this.eventManager.dispatchEvent(new ServerEvent(ServerEvent.DISCONNECTED));
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void
		{
			this.eventManager.dispatchEvent(new ServerEvent(ServerEvent.DISCONNECTED));
		}
		
		private function connectHandler(event:Event):void 
		{
			this.eventManager.dispatchEvent(new ServerEvent(ServerEvent.CONNECTED));
		}
		
		private function progressHandler(event:ProgressEvent):void
		{
			
		}
		
		private function sendData(e:SocketSendEvent):void
		{
			if (this._socket.connected)
			{
				var timeStamp:int = Math.round((new Date()).getTime() / 1000);
				var packet:String = (e.jsonObj != null) ? e.packet + JSON.stringify(e.jsonObj) : e.packet;
				packet = Encryption.encrypt(timeStamp.toFixed() + packet);
			
				if(packet != "")
				{
					this._socket.send(packet);
				}
			}
		}

		private function dataHandler(event:DataEvent):void 
		{
			var data:String = Encryption.decrypt(event.data);
			var packets:Array = data.split("#");

			for(var i:int = 0; i < packets.length-1; i++) {
				this.processPacket(packets[i]);
			}
        }
		
		public function processPacket(packet:String):void
		{
			var packetHeader:String = packet.substr(0, 2);
			var packetContent:String = packet.substr(2);
			var selectedPacket:String = this.possiblePackets[packetHeader];
			
			if (selectedPacket != null) {
				var packetData:Object = (packetContent != "") ? JSON.parse(packetContent) : { };
				this.eventManager.dispatchEvent(new ServerEvent(selectedPacket, packetData));
			}
		}
	}
}