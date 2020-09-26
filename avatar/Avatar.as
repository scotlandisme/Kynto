package game.avatar 
{
	import as3isolib.display.*;
	import eDpLib.events.*;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import game.*;
	import game.animation.*;
	import game.api.events.*;
	/**
	 * ...
	 * @author William J Robin
	 */
	
	public class Avatar extends Sprite implements IAvatar
	{
		public static const IDLE:String = "idle";
		public static const WALK:String = "walk";
		public static const SIT:String = "sit";
		public static const WARP:String = "warp";
		
		private var _username:String;
		private var _id:int;
		private var _mission:String;
		private var _status:String;
		private var _state:String;
		private var _clothesData:Clothing
		private var _header:int = 0;
		private var _col:int;
		private var _row:int;
		private var _heading:int;
		private var _offset:Point;
		private var _container:IsoSprite;
		private var _stepper:Stepper;
		private var _easing:Boolean = false;
		private var _spriteAnimation:SpriteAnimation;
		private var _animationLoader:AnimationLoader;
		private var _avatarBitmap:Bitmap;
		//avatar shouldn't extend sprite... so make this bitch an instance
		private var _sprite:Sprite;
		
		public function toObject():Object
		{
			var obj:Object = {
				id : this._id,
				username : this._username,
				mission : this._mission,
				status : this._status,
				header : this._header,
				row : this._row,
				col : this._col
			};
			
			return obj;
		}
		
		public function Avatar() 
		{
			
		}
		
		private function this_mouseOut(e:MouseEvent):void 
		{
			this.alpha = 1;
		}
		
		private function this_mouseOver(e:MouseEvent):void 
		{
			this.alpha = .6;
		}
		
		private function animationLoader_complete(e:Event):void 
		{
			this._spriteAnimation = this._animationLoader.spriteAnimation;
			this._spriteAnimation.gotoAndStop(0, _header);
			this._spriteAnimation.framesToHold = 4;
			this._avatarBitmap = new Bitmap(this._spriteAnimation.bitmapData);
			this.addChild(this._avatarBitmap);
			this.status = this.status;
		}
		
		public function set header(value:int):void
		{
			this._header = value;
			
			if (this._spriteAnimation != null)
			{
				this._spriteAnimation.gotoAndStop(0, _header);
				if (this._spriteAnimation.bitmapData is BitmapData) {
					this._avatarBitmap.bitmapData = this._spriteAnimation.bitmapData;
				}
				else 
				{
					trace("Bad avatar sprite");
				}
			}
		}
		
		public function init():void
		{
			this._stepper = new Stepper();
			this._animationLoader = new AnimationLoader();
			
			var base:String = Assets.HOST + "avatars/m/";
			var urls:Array = [];
			urls.push(base + "walk/base/" + this._clothesData.base + ".png");
			urls.push(base + "walk/pants/" + this._clothesData.pants + ".png");
			urls.push(base + "walk/tops/" + this._clothesData.top + ".png");
			urls.push(base + "walk/faces/" + this._clothesData.face + ".png");
			urls.push(base + "walk/hair/" + this._clothesData.hair + ".png");
			
			this._animationLoader.loadFiles(urls);
			this._animationLoader.addEventListener(Event.COMPLETE, animationLoader_complete);
			this._spriteAnimation = this._animationLoader.spriteAnimation;
			
			this.addEventListener(MouseEvent.MOUSE_OVER, this_mouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, this_mouseOut);
		}
		
		public function this_containerClick(e:ProxyEvent):void 
		{
			this.dispatchEvent(new APIEvent(APIEvent.AVATAR_CLICKED, this.toObject()));
		}
		
		public function release():void
		{
			if (this._avatarBitmap is Bitmap)
			{
				if (this._avatarBitmap.bitmapData)
				{
					this._avatarBitmap.bitmapData.dispose();
				}
			}
			
			this._spriteAnimation = null;
			this._stepper.release();
		}
		
		public function run():void
		{
			if (!this._spriteAnimation) return;
			
			if (!this._easing) return;
			
			this._spriteAnimation.row = this._header;
			this._spriteAnimation.nextFrame();
			this._avatarBitmap.bitmapData = this._spriteAnimation.bitmapData;
		}
		
		public function build():void
		{
			
		}
		
		public function offsetAvatar(state:String, direction:int):Point
		{
			if (state == Avatar.SIT)
			{
				switch(direction)
				{
					case 0:
						_offset = new Point(-20, -40);
					break;
					case 1:
						_offset = new Point(-21, -37);
					break;
					case 2:
						_offset = new Point(-14, -40);
					break;
					case 3:
						_offset = new Point(-14, -36);
					break;
				}
			}
			else 
			{
				switch(direction)
				{
					case 2:
						_offset = new Point(-15, -47);
					break;
					default:
						_offset = new Point(-18, -48);
				}
			}
			
			return _offset;
		}
		
		public function set state(state:String):void 
		{
			switch (state) 
			{
				case Avatar.WALK:
					//_spriteAnimation = _walkAnimation;
				break;
				case Avatar.IDLE:
					this._spriteAnimation.gotoAndStop(0, this._header);
				break;
			}
			
			this._avatarBitmap.bitmapData = this._spriteAnimation.bitmapData;
			
			this._state = state;
		}
		
		public function get username():String 
		{
			return _username;
		}
		
		public function set username(value:String):void 
		{
			_username = value;
		}
		
		public function get status():String 
		{
			return _status;
		}
		
		public function set status(value:String):void 
		{
			_status = value;
			
			if (this._avatarBitmap == null) return;
			
			switch(value)
			{
				case "brb":
					this._avatarBitmap.alpha = .7;
				break;
				default: 
					this._avatarBitmap.alpha = 1;
			}
		}
		
		public function get id():int 
		{
			return _id;
		}
		
		public function set id(value:int):void 
		{
			_id = value;
		}
		
		public function get mission():String 
		{
			return _mission;
		}
		
		public function set mission(value:String):void 
		{
			_mission = value;
		}

		public function get col():int 
		{
			return _col;
		}
		
		public function set col(value:int):void 
		{
			_col = value;
		}
		
		public function get row():int 
		{
			return _row;
		}
		
		public function set row(value:int):void 
		{
			_row = value;
		}
		
		public function get clothesData():Clothing
		{
			return _clothesData;
		}
		
		public function processClothesData(value:Object):void 
		{
			this._clothesData = new Clothing(value.top, value.pants, value.body, value.hair, value.face);
		}
		
		public function get container():IsoSprite
		{
			return _container;
		}
		
		public function set container(value:IsoSprite):void 
		{
			_container = value;
			_container.addEventListener(MouseEvent.CLICK, this_containerClick);
		}
		
		public function get stepper():Stepper 
		{
			return _stepper;
		}
		
		public function set stepper(value:Stepper):void 
		{
			_stepper = value;
		}
		
		public function get easing():Boolean 
		{
			return _easing;
		}
		
		public function set easing(value:Boolean):void 
		{
			_easing = value;
		}
		
		public function get offset():Point 
		{
			return _offset;
		}
		
		public function set offset(value:Point):void 
		{
			_offset = value;
		}
	}

}