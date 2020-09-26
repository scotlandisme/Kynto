package game.tile 
{
	import com.deadreckoned.assetmanager.AssetManager;
	import com.deadreckoned.assetmanager.events.AssetEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import game.animation.AnimationLoader;
	import game.animation.SpriteAnimation;
	import game.Assets;
	
	/**
	 * ...
	 * @author William J Robin
	 */
	
	public class TileHover extends Bitmap
	{
		public var animate:Boolean = false;
		public var row:int = 0;
		public var col:int = 0;
		
		private var _sprite:SpriteAnimation;
		private var _spriteLoader:AnimationLoader;
		
		private var _assetManager:AssetManager = AssetManager.getInstance();
		
		public static const TILE_HOVER:String = Assets.HOST + "mouse/hover_sprite.png";
		
		public function TileHover() 
		{
			this.init();
		}
		
		public function loadAssets():void
		{
			this._assetManager.add(TileHover.TILE_HOVER, { overwrite : true } );
			this._assetManager.addEventListener(AssetEvent.ASSET_COMPLETE, assetManager_assetComplete);
			this._assetManager.load();
		}
		
		private function assetManager_assetComplete(e:AssetEvent):void 
		{
			if (e.asset.uri == TileHover.TILE_HOVER)
			{
				if (!e.asset.asset is Bitmap) return;
				
				var bp:BitmapData = e.asset.asset as BitmapData;
				trace(bp);
				if (!bp) return;
				_sprite = new SpriteAnimation(50, 25);
				_sprite.framesToHold = 7;
			
				_sprite.layerBitmapData(bp);
				_sprite.process();
				
				_sprite.gotoAndStop(0, 0);
				bitmapData = _sprite.bitmapData;
				
				this._assetManager.removeEventListener(AssetEvent.ASSET_COMPLETE, assetManager_assetComplete);
			}
		}
		
		public function init():void
		{
			this.loadAssets();
		}
	}

}