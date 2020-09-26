package game
{
	import com.adobe.crypto.MD5;
	import flash.display.Sprite;
	import game.api.API;
	import game.api.events.APIEvent;
	import game.events.LoggedInEvent;
	import game.network.events.SocketSendEvent;
	import game.network.PacketTypes;
	import game.network.events.ServerEvent;
	import game.network.SocketManager;
	import game.room.RoomManager;
	import game.scene.SceneManager;
	import game.scene.scenes.MainView;
	import game.scene.scenes.room.Room;
	import game.scene.scenes.RoomLoad;
	import game.user.UserManager;
	
	/**
	 * ...
	 * @author William J Robin
	 */
	
	public class GameFlow extends Sprite implements IDisposable
	{
		public var eventManager:EventManager;
		public var socketManager:SocketManager;
		public var userManager:UserManager;
		public var roomManager:RoomManager;
		public var sceneManager:SceneManager;
		public var apiManager:API;
		
		public function GameFlow() 
		{
			this.init();
		}
		
		public function init():void
		{
			this.eventManager = new EventManager();
			this.socketManager = new SocketManager();
			this.userManager = new UserManager();
			this.sceneManager = new SceneManager();
			this.apiManager = new API();
			
			this.socketManager.eventManager = this.eventManager;
			this.apiManager.eventManager = this.eventManager;
			
			this.eventManager.init();
			this.apiManager.init();
			this.socketManager.init();
			this.userManager.init();
			this.sceneManager.init();
			
			this.addEventListeners();
			
			var room:Room = new Room();
			room.eventManager = this.eventManager;
			room.init();
			
			this.sceneManager.addScene(SceneManager.ROOM, room);
			this.sceneManager.addScene(SceneManager.MAIN, new MainView());
			this.sceneManager.addScene(SceneManager.ROOM_LOAD, new RoomLoad());
			this.sceneManager.showScene(SceneManager.MAIN);
			
			this.addChild(this.sceneManager);
		}
		
		public function addEventListeners():void
		{
			this.eventManager.addEventListener(ServerEvent.CONNECTED, eventManager_connected);
			this.eventManager.addEventListener(ServerEvent.LOGGED_IN, eventManager_loggedIn);
			this.eventManager.addEventListener(ServerEvent.ROOM_KICK, eventManager_roomKick);
			this.eventManager.addEventListener(ServerEvent.LOGIN_FAILED, eventManager_loginFailed);
			this.eventManager.addEventListener(ServerEvent.PING, eventManager_ping);
			this.eventManager.addEventListener(ServerEvent.USER_DATA, eventManager_userData);
			this.eventManager.addEventListener(ServerEvent.GENERATE_ROOM, eventManager_generateRoom);
			this.eventManager.addEventListener(ServerEvent.NAVIGATOR_LIST, eventManager_navigatorList);
			this.eventManager.addEventListener(ServerEvent.DISCONNECTED, eventManager_disconnected);
			this.eventManager.addEventListener(ServerEvent.ROOM_LOAD_FAILED, eventManager_roomLoadFailed);
			this.eventManager.addEventListener(ServerEvent.ALERT, eventManager_alert);
		}
		
		private function eventManager_loggedIn(e:ServerEvent):void 
		{
			this.eventManager.dispatchEvent(new SocketSendEvent(PacketTypes.UPDATE_NAVIGATOR_REQUEST, { T : 0 } ));
			this.dispatchEvent(new APIEvent(APIEvent.LOGGED_IN));
			this.eventManager.dispatchEvent(new SocketSendEvent(PacketTypes.ROOM_CHANGE_REQUEST, { RID : 1, S : 1 } ));
		}
		
		private function eventManager_connected(e:ServerEvent):void 
		{
			this.eventManager.dispatchEvent(new APIEvent(APIEvent.CONNECTED));
			this.eventManager.dispatchEvent(new SocketSendEvent(PacketTypes.PING));
			
			//this.eventManager.dispatchEvent(new SocketSendEvent("Li", { U : "Test", P : "db2d303c20b9468bbe90114d3d1874b3" } ));
			//this.eventManager.dispatchEvent(new SocketSendEvent("Li", { U : "guest", P : "guest" } ));
		}
		
		private function eventManager_roomKick(e:ServerEvent):void 
		{
			var room:Room = this.sceneManager.getScene(SceneManager.ROOM) as Room;
			room.release();
			
			this.sceneManager.showScene(SceneManager.MAIN);
		}
		
		private function eventManager_userData(event:ServerEvent):void 
		{
			this.userManager.userProperties.id = event.parameters.I;
			this.userManager.userProperties.username = event.parameters.I;
			this.userManager.userProperties.sex = event.parameters.S;
			this.userManager.userProperties.rank = event.parameters.R;
			this.userManager.userProperties.money = event.parameters.M;
			this.userManager.userProperties.email = event.parameters.E;
			this.userManager.userProperties.mission = event.parameters.M;
			
			this.eventManager.dispatchEvent(new LoggedInEvent(this.userManager.userProperties));
			this.eventManager.dispatchEvent(new APIEvent(APIEvent.USER_DATA, this.userManager.userProperties.toObject()));
		}
		
		private function eventManager_ping(e:ServerEvent):void 
		{
			this.eventManager.dispatchEvent(new SocketSendEvent(PacketTypes.PING_REPLY));
		}
		
		private function eventManager_loginFailed(e:ServerEvent):void 
		{
			var alertObj:Object = {
				title : "Login Failure",
				message : "The username/ password combination was invalid"
			};
			
			this.eventManager.dispatchEvent(new APIEvent(APIEvent.ALERT, alertObj));
		}
		
		private function eventManager_roomLoadFailed(e:ServerEvent):void 
		{
			this.eventManager.dispatchEvent(new APIEvent(APIEvent.ROOM_LOAD_FAILED));
		}
		
		private function eventManager_disconnected(e:ServerEvent):void 
		{
			var room:Room = this.sceneManager.getScene(SceneManager.ROOM) as Room;
			room.unload();

			this.sceneManager.showScene(SceneManager.MAIN);
			this.eventManager.dispatchEvent(new APIEvent(APIEvent.DISCONNECTED));
		}
		
		private function eventManager_alert(e:ServerEvent):void 
		{
			var alertObj:Object = {
				title : e.parameters.T,
				message : e.parameters.M
			};
			
			this.eventManager.dispatchEvent(new APIEvent(APIEvent.ALERT, alertObj));
		}
		
		private function eventManager_navigatorList(e:ServerEvent):void 
		{
			var rooms:Array = [];

			for each(var obj:Object in e.parameters.Pr)
			{
				var room:Object = {
					id : obj.I,
					name : obj.N,
					description : obj.D,
					owner : obj.O,
					ocupants : obj.U
				};
				
				rooms.push(room);
			}
			
			this.eventManager.dispatchEvent(new APIEvent(APIEvent.NAVIGATOR_LIST, rooms));
		}
		
		private function eventManager_generateRoom(e:ServerEvent):void 
		{
			var room:Room = this.sceneManager.getScene(SceneManager.ROOM) as Room;
			room.generate(e.parameters);
			
			this.sceneManager.showScene(SceneManager.ROOM);
			this.eventManager.dispatchEvent(new SocketSendEvent(PacketTypes.UPDATE_NAVIGATOR_REQUEST, { T : 0 } ));
		}
		
		public function removeEventListeners():void
		{
			//will populate eventually
		}
		
		public function restart():void
		{
			this.release();
			this.init();
		}
		
		public function release():void
		{
			this.removeEventListeners();
		}
	}

}