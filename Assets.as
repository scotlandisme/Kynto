package game 
{
	import com.deadreckoned.assetmanager.Asset;
	import com.deadreckoned.assetmanager.AssetManager;
	import com.deadreckoned.assetmanager.AssetQueue;
	import com.deadreckoned.assetmanager.events.AssetEvent;
	import game.animation.LoaderObject;
	/**
	 * ...
	 * @author William J Robin
	 */
	public class Assets //maybe load required assets from an external xml file
	{
		public static const HOST:String = "http://kynto.local/bin/files/";
		public static const ROOM_CHATBAR_BACKGROUND:String = HOST + "room/chatbar-layer.gif";
		public static const ROOM_TILE_HOVER:String = HOST + "mouse/hover_sprite.png";
		public static var assets:Array = [ROOM_CHATBAR_BACKGROUND];
		
		public static var callback:Function;
		public static var toLoad:Array = [];
		public static var numComplete:int = 0;
		
		public function Assets() 
		{

		}
		
		public static function load(callback:Function):void
		{
			trace(assets.length);
			Assets.callback = callback;
			AssetManager.getInstance().addEventListener(AssetEvent.ASSET_COMPLETE, assetComplete);
			AssetManager.getInstance().addEventListener(AssetEvent.ASSET_FAIL, assetFailed);
		
			for (var i:int = 0; i < assets.length; i++)
			{
				var loader:LoaderObject = new LoaderObject();
				loader.loaded = false;
				loader.uri = assets[i];
				trace(loader.uri);
				toLoad.push(loader);
				AssetManager.getInstance().add(assets[i]);
			}

			AssetManager.getInstance().load();
		}
		
		static private function assetFailed(e:AssetEvent):void
		{
			trace("Failed to load required assets");
		}
		
		static private function assetComplete(e:AssetEvent):void 
		{
			var asset:Asset = e.asset;

			for (var i:int = 0; i < toLoad.length; i++)
			{
				var loaderObj:LoaderObject = toLoad[i] as LoaderObject;
				if (asset.uri == null) continue;
				if (loaderObj.uri == asset.uri && !loaderObj.loaded)
				{
					loaderObj.loaded = true;
					numComplete++;
				}
			}
			
			if (numComplete == toLoad.length)
			{
				AssetManager.getInstance().removeEventListener(AssetEvent.ASSET_COMPLETE, assetComplete);
				callback();
			}
			
			callback();

			//trace(AssetManager.getInstance().get(ROOM_TILE_HOVER).asset);
		}
	}

}