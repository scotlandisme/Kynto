package game.scene.scenes.backgrounds 
{
	import com.deadreckoned.assetmanager.AssetManager;
	import com.deadreckoned.assetmanager.events.AssetEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import game.Assets;
	
	/**
	 * ...
	 * @author William J Robin
	 */
	
	public class ImageRepeat extends Sprite implements IBackGround
	{
		private var _assetManager:AssetManager = AssetManager.getInstance();
		private var _uri:String;

		public function ImageRepeat() 
		{
			
		}
		
		public function init():void
		{
			this.loadAssets();
		}
		
		public function release():void
		{
			
		}
		
		public function loadAssets():void
		{
			this._assetManager.addEventListener(AssetEvent.ASSET_COMPLETE, assetManager_assetComplete);
			this._assetManager.add(Assets.HOST + "backgrounds/background_3.png");
		}
		
		private function assetManager_assetComplete(e:AssetEvent):void 
		{
			if (e.asset.uri == Assets.HOST + "backgrounds/background_3.png")
			{
				if (e.asset.asset is BitmapData)
				{
					this.repeatBackground(e.asset.asset as BitmapData);
				}
			}
		}
		
		public function repeatBackground(data:BitmapData):void
		{
			this.graphics.beginBitmapFill(data);
			this.graphics.drawRect(0, 0, stage.width + 500, stage.height);
			this.graphics.endFill();	
		}
	}

}