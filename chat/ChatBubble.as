package game.chat
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextFormat;
	import game.IDisposable;
	import game.text.PixelFont;
	import utils.BitmapTools;
	
	/**
	 * ...
	 * @author William J Robin
	 */
	
	public class ChatBubble extends Bitmap implements IDisposable
	{
		[Embed(source='../../../lib/game/chatbubble/1.gif')]
		public var NameLeft:Class;
		
		[Embed(source='../../../lib/game/chatbubble/2.gif')]
		public var NameMiddle:Class;
		
		[Embed(source='../../../lib/game/chatbubble/3.gif')]
		public var NameSeperator:Class;
		
		[Embed(source='../../../lib/game/chatbubble/4.gif')]
		public var MessageMiddle:Class;
		
		[Embed(source='../../../lib/game/chatbubble/5.gif')]
		public var MessageEnd:Class;
		
		//[Embed(systemFont='Verdana', fontName="Default", mimeType="application/x-font-truetype")]
		//public var Verdana_Font:String;
		
		private var _nameLeft:Bitmap;
		private var _nameMiddle:Bitmap;
		private var _nameSeperator:Bitmap;
		private var _messageMiddle:Bitmap;
		private var _messageEnd:Bitmap;
		
		private var _name:TextField
		private var _message:TextField;
		
		private var _chatLengh:int;
		private var _lastX:int;
		
		private var _nameData:BitmapData;
		private var _messageData:BitmapData;
		
		private var _cacheBitmap:BitmapData;
		private var _floodPixels:BitmapData;
		
		private var _nameMatrix:Matrix;
		private var _messageMatrix:Matrix;
		
		public var isFading:Boolean = false;
		public var userId:int;

		
		public function ChatBubble(name:String, message:String, id:int = 0) 
		{
			_name = new PixelFont(0xFFFFFF, true);
			_message = new PixelFont();
			
			_name.text = name;
			_message.htmlText = message;
			
			userId = id;
			
			_nameMatrix = new Matrix();
			_messageMatrix = new Matrix();
			
			_nameLeft = new NameLeft();
			_nameMiddle = new NameMiddle();
			_nameSeperator = new NameSeperator();
			_messageMiddle = new MessageMiddle();
			_messageEnd = new MessageEnd();
			
			build();
		}
		
		public function init():void
		{
			
		}
		
		public function release():void
		{
			
		}
		
		private function build():void
		{
			var emoticons:Array = ["^^", ":)", ":(", "<<", "xD", "tt", "D(", "x3", "<3", ":o", ":]"];
			var index:int, emos:Array = [];
			var str:String = _message.text;
			
			for (var i:String in emoticons)
			{
				index = 0;
				
				while (index != -1)
				{
					index = str.indexOf(emoticons[i], index);
					if (index != -1)
					{
						emos.push({id:i, index:index, token:emoticons[i]});
						index += emoticons[i].length;
					}
				}
			}
			
			str = _message.htmlText;	
			
			for (i in emoticons)
			{
				str = str.split(emoticons[i]).join('<font color="' + emoticons[i] + '">00</font>');
			}
				
			_message.htmlText = str;
			
			_nameMatrix.tx = 5;
			_nameMatrix.ty = 3;
			
			_nameData = BitmapTools.textToImage(_name);
			_messageData = BitmapTools.textToImage(_message);
			
			_chatLengh = _nameData.width + _nameLeft.width + _nameSeperator.width + _messageData.width + _messageEnd.width;
			
			_cacheBitmap = new BitmapData(_chatLengh, 23, true, 0x000000);
			
			_cacheBitmap.copyPixels(_nameLeft.bitmapData, new Rectangle(0, 0, _nameLeft.width, _nameLeft.height), new Point(0, 0));
			_cacheBitmap.copyPixels(BitmapTools.repeatBitmapVertial(_nameMiddle, new Rectangle(0, 0,_nameData.width, _nameMiddle.height)), new Rectangle(0, 0, _nameData.width, _nameMiddle.height), new Point(_nameLeft.width)); 
			_cacheBitmap.copyPixels(_nameSeperator.bitmapData, new Rectangle(0, 0, _nameSeperator.width, _nameSeperator.height), new Point(_nameData.width + _nameLeft.width, 0));
			_cacheBitmap.copyPixels(BitmapTools.repeatBitmapVertial(_messageMiddle, new Rectangle(0, 0, _messageData.width, _messageMiddle.height)), new Rectangle(0, 0, _messageData.width, _messageMiddle.height), new Point(_nameData.width + _nameLeft.width + _nameSeperator.width, 0));
			_cacheBitmap.copyPixels(_messageEnd.bitmapData, new Rectangle(0, 0, _messageEnd.width, _messageEnd.height), new Point(_nameData.width + _nameLeft.width + _nameSeperator.width + _messageData.width, 0));

			_messageMatrix.tx = _nameData.width + _nameLeft.width + _nameSeperator.width;
			_messageMatrix.ty = 3;
			
			_cacheBitmap.draw(_nameData, _nameMatrix);
			_cacheBitmap.draw(_messageData, _messageMatrix);
			
			var charBounds:Rectangle, emo:Bitmap, emoM:Matrix;
			/*for (i in emos)
			{
				charBounds = _message.getCharBoundaries(emos[i].index);
				
				emo = new (getSmiley(emos[i].token) as Class) as Bitmap;
				emoM = new Matrix();
				
				emoM.tx = _nameData.width + _nameLeft.width + _nameSeperator.width + charBounds.x;
				emoM.ty = charBounds.y + (charBounds.height / 2 - emo.height / 2) + 5;
				
				_cacheBitmap.draw(emo.bitmapData, emoM);
				index += emos[i].token.length;
			}*/
			
			bitmapData = _cacheBitmap;
		}
		
		private function getSmiley(str:String):Class
		{
			/*switch(str)
			{
				case ":)":
					return AssetManager.SMILEY_3;
				break;
				case ":(":
					return AssetManager.SMILEY_2;
				break;
				case "^^":
					return AssetManager.SMILEY_1;
				break;
				case "<<":
					return AssetManager.SMILEY_4;
				break;
				case "xD":
					return AssetManager.SMILEY_5;
				break;
				
				case "x3":
					return AssetManager.SMILEY_6;
				break;
				case "D(":
					return AssetManager.SMILEY_7;
				break;
				case "tt":
					return AssetManager.SMILEY_8;
				break;
				case "<3":
					return AssetManager.SMILEY_9;
				break;
				case ":o":
					return AssetManager.SMILEY_10;
				break;
				case ":]":
					return AssetManager.SMILEY_11;
				break;
				default:
					return AssetManager.SMILEY_1;
			}*/
			
			return Class;
		}
		
		public function dispose():void
		{
			_nameLeft.bitmapData.dispose();
			_nameMiddle.bitmapData.dispose();
			_nameSeperator.bitmapData.dispose();
			_messageMiddle.bitmapData.dispose();
			_messageEnd.bitmapData.dispose();
			
			_cacheBitmap.dispose();
			bitmapData.dispose();
		}
	}
}