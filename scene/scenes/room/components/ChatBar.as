package game.scene.scenes.room.components 
{
	import com.deadreckoned.assetmanager.AssetManager;
	import com.deadreckoned.assetmanager.events.AssetEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
	import game.api.events.APIEvent;
	import game.Assets;
	import game.EventManager;
	import game.network.events.SocketSendEvent;
	import game.network.PacketTypes;
	/**
	 * ...
	 * @author William J Robin
	 */
	
	/* chatbar view */ 
	
	public class ChatBar extends Sprite
	{
		private var _assetManager:AssetManager = AssetManager.getInstance();
		public var chatInput:TextField;
		public var eventManager:EventManager;
		
		public function ChatBar() 
		{
			
		}
		
		public function init():void
		{
			this.buildUI();
			this.addEventListeners();
			this.loadAssets();
		}
		
		public function addEventListeners():void
		{
			this._assetManager.addEventListener(AssetEvent.ASSET_COMPLETE, assetManager_assetComplete);
		}
		
		private function chatInput_keyUp(e:KeyboardEvent):void 
		{
			if(this.chatInput.text.length >= 1 && e.keyCode == Keyboard.ENTER)
			{
				if (this.chatInput.text.substring(0, 1) == "!") //client commmand
				{
					var words:Array = this.chatInput.text.substring(1).split(" ");
					trace(words);
					switch(words[0]) {
						case "sit":
							this.eventManager.dispatchEvent(new SocketSendEvent(PacketTypes.AVATAR_SIT_REQUEST));
							break;
						case "goto":
							var roomID:int = (words[1] != null) ? words[1] : 0;
						
							if (roomID > 0) 
							{
								this.eventManager.dispatchEvent(new SocketSendEvent(PacketTypes.ROOM_CHANGE_REQUEST, { RID : roomID, S :1 } ));
							}
							break;
					}
					
					this.chatInput.text = "";
					return void;
				}
				
				var data:Object =
				{
					T : "R",
					M : this.chatInput.text
				};
				
				this.eventManager.dispatchEvent(new SocketSendEvent("SM", data));
				this.chatInput.text = "";
			}
		}

		private function assetManager_assetComplete(e:AssetEvent):void 
		{
			if (e.asset.uri == Assets.ROOM_CHATBAR_BACKGROUND)
			{
				this.addChild(new Bitmap(e.asset.asset as BitmapData));
			}
			
			this.dispatchEvent(new APIEvent(APIEvent.TRACE, { data : e.asset.uri } ));
			this.addChild(this.chatInput);
		}
		
		public function removeEventListners():void
		{
			
		}
		
		public function release():void
		{
			
		}
		
		public function buildUI():void
		{
			this.chatInput = new TextField();
			this.chatInput.width = 350;
			this.chatInput.type = TextFieldType.INPUT;
			this.chatInput.selectable = true;
			this.chatInput.x = 195;
			this.chatInput.y = 25;
			this.chatInput.maxChars = 80;
			this.addChild(this.chatInput);
			this.y = 481;
			
			this.chatInput.addEventListener(KeyboardEvent.KEY_UP, chatInput_keyUp, false, 0, true);
		}
		
		public function loadAssets():void
		{
			this._assetManager.add(Assets.ROOM_CHATBAR_BACKGROUND);
			this._assetManager.load();
		}
		
		public function disable():void
		{
			this.chatInput.text = "You must login to be able to chat!";
			this.chatInput.selectable = false;
			this.chatInput.type = TextFieldType.DYNAMIC;
		}
	}

}