package game.animation {
	import com.deadreckoned.assetmanager.Asset;
	import com.deadreckoned.assetmanager.AssetManager;
	import com.deadreckoned.assetmanager.AssetQueue;
	import com.deadreckoned.assetmanager.events.AssetEvent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.events.HTTPStatusEvent
	import flash.utils.Dictionary;

	/**
	 * ...
	 * @author William J Robin
	 */
	
	public class AnimationLoader extends EventDispatcher{
		
		public static const DONE:String = "done";
		
		private var _spriteAnimation:SpriteAnimation;
		private var _loaders:Array;
		private var _numComplete:int;
		private var _loaded:Boolean = false;
		private var _assetManager:AssetManager = AssetManager.getInstance();
		
		public function AnimationLoader() {
			//_assetManager.addEventListener(
		}
		
		public function loadFiles(files:Array):void 
		{
			this._loaders = [];
			this._numComplete = 0;
			this._assetManager.addEventListener(AssetEvent.ASSET_COMPLETE, assetManager_assetComplete);
			this._assetManager.addEventListener(AssetEvent.ASSET_FAIL, avatarQueue_assetFail);

			for (var i:int = 0; i < files.length;++i) 
			{
				this._assetManager.add(files[i], { overwrite : true } );
				var loaderObj:LoaderObject = new LoaderObject();
				loaderObj.uri = files[i];
				this._loaders.push(loaderObj);
			}
			
			this._assetManager.load();
		}
		
		private function assetManager_assetComplete(e:AssetEvent):void 
		{
			var asset:Asset = e.asset;
			
			for (var i:int = 0; i < this._loaders.length; i++)
			{
				var loaderObj:LoaderObject = this._loaders[i];
				if (loaderObj.uri == asset.uri && !loaderObj.loaded)
				{
					loaderObj.loaded = true;
					this._numComplete++;
				}
			}
			
			if (this._numComplete == this._loaders.length) 
			{
				this.proccessComplete();
			}
		}
		
		private function proccessComplete():void
		{
				this._assetManager.removeEventListener(AssetEvent.ASSET_COMPLETE, assetManager_assetComplete);
				this._assetManager.removeEventListener(AssetEvent.ASSET_FAIL, avatarQueue_assetFail);
				this._spriteAnimation = new SpriteAnimation(32, 66);
				for (var i:int = 0; i < this._loaders.length; i++)
				{
					var loaderObj:LoaderObject = this._loaders[i];
					var data:BitmapData = this._assetManager.get(loaderObj.uri).asset as BitmapData;
					
					if (data != null)
					{
						this._spriteAnimation.layerBitmapData(data); 
					}
				}
				//if(this._loaders.ke
				this._spriteAnimation.process();
				this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function avatarQueue_assetFail(e:AssetEvent):void 
		{
			trace(e.asset.asset.data as BitmapData);
		}

		private function loadFail(e:IOErrorEvent):void
		{
			trace("Animation load error " + e.currentTarget.url);
		}

		public function get spriteAnimation():SpriteAnimation { return _spriteAnimation; }
		
		public function set spriteAnimation(value:SpriteAnimation):void {
			_spriteAnimation = value;
		}
		
		public function get loaded():Boolean { return _loaded; }
		
	}
	
}