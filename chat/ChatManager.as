package game.chat 
{
	import caurina.transitions.Tweener;
	import com.adobe.utils.ArrayUtil;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import game.avatar.Avatar;
	import game.avatar.AvatarManager;
	import game.avatar.IAvatar;
	
	/**
	 * ...
	 * @author William J Robin
	 */
	
	public class ChatManager extends Sprite
	{
		public var inhover:Boolean;
		public var chats:Array;
		public var avatarManager:AvatarManager;
		
		private var _timer:Timer;
		
		public function ChatManager() 
		{
			
		}
		
		public function init():void
		{
			this.chats = [];
	
			this._timer = new Timer(1000);
			this._timer.addEventListener(TimerEvent.TIMER, timer_timer);
			this._timer.start();
		}
		
		private function timer_timer(e:TimerEvent):void 
		{
			this.hover();
		}
		
		public function release():void
		{
			for each(var chat:ChatBubble in this.chats)
			{
				if (chat == null) continue;
				
				this.removeChild(chat);
				chat = null;
			}
			
			this._timer.removeEventListener(TimerEvent.TIMER, timer_timer);
			this._timer.stop();
			
			this._timer = null;
			this.chats = null;
			this.avatarManager = null;
		}
		
		public function reset():void
		{
			for each(var chat:ChatBubble in this.chats)
			{
				if (chat == null) continue;
				
				this.removeChild(chat);
				chat = null;
			}
			
			this.chats = [];
		}
		
		public function addChat(data:Object):void
		{
			var avatar:Avatar =  this.avatarManager.getByID(data.I) as Avatar;

			if (!avatar) return;
			
			this.hover();
			
			var chatBubble:ChatBubble = new ChatBubble(data.U, data.M);
			var currentY:int = 150;
			var avatarPoint:Point = avatar.localToGlobal(new Point(avatar.x, avatar.y));
			var currentX:int = avatarPoint.x;

			if (currentX + chatBubble.width > 750) {
				currentX = 750 - chatBubble.width;
			} else if (currentX < 0) {
				currentX = 0;
			}
			
			chatBubble.alpha = .5;
			chatBubble.y = currentY;
			chatBubble.x = currentX;

			this.chats.push(chatBubble);
			this.addChild(chatBubble);

			Tweener.addTween(chatBubble, { 
				time : .3,
				transition : "linear",
				alpha : .8
			});
		}
		
		public function removeChat(chat:ChatBubble):void
		{
			if (chat == null) return;
			
			chat.visible = false;
			//this.removeChild(chat);
			//chat = null;
		}
		
		public function hover():void
		{
			if (this.chats.length <= 0 && this.inhover) return;
			this.inhover = true;
			
			for each(var chat:ChatBubble in this.chats) {
				if (chat == null) continue;
				
				if (chat.y <= 0) {
					this.removeChat(chat);
				} else {
					chat.y -= 25;
				}
			}
			
			this.inhover = false;
		}
	}

}