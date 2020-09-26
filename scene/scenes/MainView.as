package game.scene.scenes 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.sampler.NewObjectSample;
	import game.assets.backgrounds.Background1;
	import game.assets.backgrounds.Background2;
	import game.scene.IScene;
	
	/**
	 * ...
	 * @author William J Robin
	 */
	
	public class MainView extends Sprite implements IScene
	{
		public function MainView() 
		{
			this.repeatBackground();
		}
		
		public function repeatBackground():void
		{
			var backView:Bitmap = new Background2();
			this.graphics.beginBitmapFill(backView.bitmapData);
			this.graphics.drawRect(0, 0, 750, 550);
			this.graphics.endFill();	
		}
		
		public function load():void
		{
			
		}
		
		public function unload():void
		{
			
		}
	}

}