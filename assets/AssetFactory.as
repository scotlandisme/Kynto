package game.assets 
{
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author William J Robin
	 */
	
	public class AssetFactory 
	{
		[Embed(source = '../../../../../lib/game/backgrounds/background_2.png')]
		public static var BackGroundTwo:Class;
		[Embed(source = '../../../../../lib/game/backgrounds/background_3.png')]
		public static var BackGroundThree:Class;
		[Embed(source = '../../../../../lib/game/backgrounds/background_4.png')]
		public static var BackGroundFour:Class;
		
		public static function emeddedBitmap(name:String):Bitmap
		{
			switch(name)
			{
				
			}
		}
		
		public function AssetFactory() 
		{
			
		}
		
	}

}