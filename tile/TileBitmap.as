package game.tile 
{
	import com.deadreckoned.assetmanager.AssetManager;
	import com.deadreckoned.assetmanager.events.AssetEvent;
	import com.deadreckoned.assetmanager.events.AssetProgressEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import game.Assets;
	import game.IDisposable;
	/**
	 * ...
	 * @author William J Robin
	 */
	
	public class TileBitmap extends Bitmap implements IDisposable
	{
		private var _assetManager:AssetManager = AssetManager.getInstance();
		public var tileID:int = 0;
		
		public function TileBitmap(tileID:int) 
		{
			this.tileID = tileID;
		}
		
		public function init():void
		{
			
		}
		
		public function release():void
		{
			
		}
		
		public function load():void
		{
			if (this._assetManager.get(Assets.HOST + "tiles/" + this.tileID + ".png") is BitmapData)
			{
				this._assetManager.get(Assets.HOST + "tiles/" + this.tileID + ".png").asset;
				(this._assetManager.get(Assets.HOST + "tiles/" + this.tileID + ".png").asset as BitmapData).copyPixels(this.bitmapData, new Rectangle(0, 0, 24, 24), new Point());
				return;
			}
			this._assetManager.add(Assets.HOST + "tiles/" + this.tileID + ".png");
			//this._assetManager.addEventListener(AssetProgressEvent.PROGRESS, assetManager_progress);
			this._assetManager.addEventListener(AssetEvent.ASSET_COMPLETE, assetManager_assetComplete);
		}
		
		private function assetManager_assetComplete(e:AssetEvent):void 
		{
			if(e.asset.uri == Assets.HOST + "tiles/" + this.tileID + ".png")
			this.bitmapData = e.asset.asset as BitmapData;
		}
		
		private function assetManager_progress(e:AssetProgressEvent):void 
		{
			//trace(e.asset);
		}
	}

}