package game.tile 
{
	import com.deadreckoned.assetmanager.AssetManager;
	import com.deadreckoned.assetmanager.events.AssetEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	/**
	 * ...
	 * @author William J Robin
	 */
	
	public class WallBitmap extends Bitmap
	{
		private var _assetManager:AssetManager = AssetManager.getInstance();
		
		public function WallBitmap() 
		{
			
		}
		
		public function load():void
		{
			this._assetManager.add("http://kynto.com/public/files/walls/2.png");
			this._assetManager.addEventListener(AssetEvent.ASSET_COMPLETE, assetManager_assetComplete);
		}
		
		private function assetManager_assetComplete(e:AssetEvent):void 
		{
			if(e.asset.uri == "http://kynto.com/public/files/walls/2.png")
			this.bitmapData = e.asset.asset as BitmapData;
		}
	}

}