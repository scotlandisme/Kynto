package game.scene.scenes.room 
{
	import caurina.transitions.Tweener;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import game.api.events.APIEvent;
	import game.chat.ChatManager;
	import game.EventManager;
	import game.events.LoggedInEvent;
	import game.network.events.ServerEvent;
	import game.network.events.SocketSendEvent;
	import game.room.isometric.DynamicMap;
	import game.room.RoomData;
	import game.scene.IScene;
	import game.scene.scenes.backgrounds.IBackGround;
	import game.scene.scenes.backgrounds.ImageRepeat;
	import game.scene.scenes.room.components.ChatBar;
	import game.user.UserManager;
	import utils.DisplayUtils;
	
	/**
	 * ...
	 * @author William J Robin
	 */
	
	public class Room extends Sprite implements IScene
	{
		public var map:DynamicMap;
		public var eventManager:EventManager;
		public var roomData:RoomData;
		public var chatManager:ChatManager;
		public var chatBar:ChatBar;
		public var background:IBackGround;
		public var userManager:UserManager;
		public var roomSprite:Sprite;
		public var oldDragPoint:Point;
		public var dragMap:Boolean = false;
		
		public function Room() 
		{
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
		}
		
		private function mouseDown(e:MouseEvent):void 
		{
			this.oldDragPoint = new Point(this.map.x, this.map.y);
			this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onMouseUp(e:MouseEvent):void {
			this.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			
			Tweener.addTween(this.map, { time : .4, x : oldDragPoint.x, y : oldDragPoint.y, transition : "easeInElastic" } );
		}
		public function init():void
		{
			this.roomData = new RoomData();
			
			this.chatBar = new ChatBar();
			this.chatBar.eventManager = this.eventManager;
			this.chatBar.init();
			
			this.chatManager = new ChatManager();
			this.chatManager.init();
			
			this.background = new ImageRepeat();
			this.roomSprite = new Sprite();
			
			this.addChild(this.background as DisplayObject);
			this.addChild(this.roomSprite);
			this.addChild(this.chatBar);
			this.addChild(this.chatManager);
			
			this.addEventListeners();
		}
		
		public function release():void
		{
			this.map.release();
		}
		
		private function addEventListeners():void
		{
			this.eventManager.addEventListener(ServerEvent.USER_ADD_CHAT, eventManager_userAddChat);
			this.eventManager.addEventListener(LoggedInEvent.LOGGED_IN, eventManager_loggedIn);
			this.addEventListener(Event.ENTER_FRAME, this_enterFrame);
		}
		
		private function eventManager_loggedIn(e:LoggedInEvent):void 
		{
			this.chatBar.disable();
		}
		
		private function this_enterFrame(e:Event):void 
		{
			if (this.stage)
			{
				this.stage.focus = this.chatBar.chatInput;
			}
		}
		
		private function eventManager_userAddChat(e:ServerEvent):void 
		{
			this.chatManager.addChat(e.parameters);
			
			var chatObj:Object = {
				id : e.parameters.I,
				username : e.parameters.U,
				message : e.parameters.M
			};
		
			this.eventManager.dispatchEvent(new APIEvent(APIEvent.ADD_CHAT, chatObj));
			//this.eventManager.dispatchEvent(new SocketSendEvent("RC", { RID : 1, S : 1 } ));
		}
		
		private function removeEventListeners():void
		{
			
		}
		
		public function buildScene():void
		{
			
		}
		
		public function load():void
		{
			
		}
		
		public function loadAssets():void //add to interface and track loading
		{
			
		}
		
		public function unload():void
		{
			//init();
		}

		public function generate(data:Object):void
		{
			if (data.T == 1)
			{
				this.roomData.id = data.I;
				this.roomData.name = data.N;
				this.roomData.rows = data.X;
				this.roomData.cols = data.Y;
				this.roomData.description = data.D;
				this.roomData.items = data.F;
				this.roomData.background = data.Bg;
				this.roomData.floor = data.Fl;
			}
			
			if (this.map != null)
			{
				this.release();
				this.map = null;
			}
			
			this.map = new DynamicMap();

			this.map.eventManager = this.eventManager;
			this.map.init();
			this.map.x = -22;
			this.map.y = -25;
			this.map.roomData = this.roomData;
			this.map.drawGrid();

			this.chatManager.reset();
			this.chatManager.avatarManager = this.map.avatarManager;
			
			this.background.init();
			this.roomSprite.addChild(this.map as DisplayObject);
			
			this.eventManager.dispatchEvent(new APIEvent(APIEvent.JOINED_ROOM, this.roomData.toObject()));
		}
		
		public function onMouseMove(e:MouseEvent):void {
			return;
			this.map.x = e.stageX - this.map.roomData.rows * 6;
			this.map.y = e.stageY - this.map.roomData.cols * 12;
		}
	}
}