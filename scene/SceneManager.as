package game.scene 
{
	import flash.display.DisplayObject;
	import flash.display.Scene;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author William J Robin
	 */
	
	public class SceneManager extends Sprite
	{
		public static const ROOM:String = "room";
		public static const ROOM_LOAD:String = "roomLoad";
		public static const MAIN:String = "main";
		
		public var scenes:Dictionary;
		public var scene:String;
		
		public var currentScene:IScene;
		
		public function SceneManager() 
		{
			
		}
		
		public function init():void
		{
			this.scenes = new Dictionary();
		}
		
		public function release():void
		{
			this.scenes = null;
		}
		
		public function addScene(key:String, scene:IScene):void
		{
			this.scenes[key] = scene;
		}
		
		public function getScene(key:String):IScene
		{
			return this.scenes[key] as IScene;
		}
		
		public function showScene(key:String):IScene
		{
			var scene:IScene = this.getScene(key);
			
			if (this.scene) {
				this.hideScene(this.scene);
			}
			
			if (scene) {
				this.addChild(scene as DisplayObject);
				this.scene = key;
				this.currentScene = scene;
	
				return scene;
			}
			
			return null;
		}
		
		public function hideScene(key:String):void
		{
			var scene:IScene = this.getScene(key);
			
			if (scene)
			{
				this.removeChild(scene as DisplayObject);
			}
		}
	}

}