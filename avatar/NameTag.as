package game.avatar
{
	import flash.events.Event;
	import flash.geom.Matrix;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import game.text.PixelFont;
	import utils.BitmapTools;
	
	public class NameTag extends Bitmap
	{
		[Embed(source='../../../bin/files/nametags/start.png')]
		public static var NAMETAG_START:Class;
		
		[Embed(source='../../../bin/files/nametags/middle.png')]
		public static var NAMETAG_MIDDLE:Class;
		
		[Embed(source='../../../bin/files/nametags/end.png')]
		public static var NAMETAG_END:Class;
		
		private var _username:String;
		private var _canvas:BitmapData;

		private var _nameStart:Bitmap;
		private var _nameMiddle:Bitmap;
		private var _nameEnd:Bitmap;
		
		private var _nameMatrix:Matrix;
		private var _nameText:PixelFont

		public function NameTag(username:String):void
		{
			_username = username;
			
			_nameText = new PixelFont(0x686868, true);
			_nameMatrix = new Matrix();
			
			_nameStart = new NAMETAG_START();
			_nameMiddle = new NAMETAG_MIDDLE();
			_nameEnd = new NAMETAG_END();
			
			_nameText.text = _username;
			
			//visible = false;
			
			draw();
		}
		
		public function draw():void
		{
			var nameData:BitmapData = BitmapTools.textToImage(_nameText);
			var nameLength:int = _nameStart.width + nameData.width + _nameEnd.width + 4;
			
			_canvas = new BitmapData(nameLength, 15, true, 0x000000);
			_canvas.copyPixels(_nameStart.bitmapData, new Rectangle(0, 0, _nameStart.width, _nameStart.height), new Point(0, 0));
			_canvas.copyPixels(BitmapTools.repeatBitmapVertial(_nameMiddle, new Rectangle(0, 0, nameData.width + 4, nameData.height)), new Rectangle(0, 0, nameData.width +4, nameData.width), new Point(_nameStart.width, 0));
			_canvas.copyPixels(_nameEnd.bitmapData, new Rectangle(0, 0, _nameEnd.width, _nameEnd.height), new Point(_nameStart.width + nameData.width + 4, 0));
			
			_nameMatrix.tx = 7;
			_nameMatrix.ty = -1;
			
			_canvas.draw(nameData, _nameMatrix);
			
			bitmapData = _canvas;
		}

		
		public function set username(value:String):void
		{
			_username = value;
			
			draw();
		}
	}
}