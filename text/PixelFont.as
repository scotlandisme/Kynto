package game.text 
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;
	import flash.text.Font;
	import flash.text.GridFitType;
	
	import utils.BitmapTools;
	
	/**
	 * ...
	 * @author William J Robin
	 */
	
	public class PixelFont extends TextField
	{
		private var tf:TextFormat;		
			
		public function PixelFont(color:uint = 0x000000, bold:Boolean = false) 
		{		
            tf = new TextFormat();
            tf.align = TextFormatAlign.LEFT;
            tf.color = color;    
			tf.size = 10;
			//tf.font = "Arial_10pt_st";
            
           /* this.defaultTextFormat = tf;
            this.embedFonts = true;
            this.antiAliasType = AntiAliasType.NORMAL;
			this.gridFitType = GridFitType.PIXEL;*/
            this.autoSize = TextFieldAutoSize.LEFT;
            this.selectable = false;
		}
	}
}