package game.room.isometric 
{
	import as3isolib.core.IIsoContainer;
	import as3isolib.display.IsoSprite;
	import as3isolib.display.IsoView;
	import as3isolib.display.primitive.IsoBox;
	import as3isolib.display.scene.IsoGrid;
	import as3isolib.display.scene.IsoScene;
	import as3isolib.geom.IsoMath;
	import as3isolib.geom.Pt;
	import as3isolib.graphics.Stroke;
	import caurina.transitions.Tweener;
	import com.deadreckoned.assetmanager.formats.VariablesHandler;
	import com.dynamicflash.util.Base64;
	import com.greensock.TweenLite;
	import eDpLib.events.ProxyEvent;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.sampler.NewObjectSample;
	import flash.utils.Dictionary;
	import game.api.events.APIEvent;
	import game.avatar.Avatar;
	import game.avatar.AvatarManager;
	import game.avatar.IAvatar;
	import game.avatar.Step;
	import game.avatar.Stepper;
	import game.EventManager;
	import game.isometric.GridPoint;
	import game.isometric.Isometric;
	import game.item.IItem;
	import game.item.Item;
	import game.item.ItemManager;
	import game.network.events.ServerEvent;
	import game.network.events.SocketSendEvent;
	import game.network.PacketTypes;
	import game.room.RoomData;
	import game.tile.ITile;
	import game.tile.Tile;
	import game.tile.TileBitmap;
	import game.tile.TileHover;
	import game.tile.TileManager;
	import game.tile.WallBitmap;
	import utils.DisplayUtils;
	/**
	 * ...
	 * @author William J Robin
	 */
	
	public class DynamicMap extends Sprite
	{
		public var eventManager:EventManager;
		public var avatarManager:AvatarManager;
		public var itemManager:ItemManager;
		public var tileManager:TileManager;
		public var roomData:RoomData;
		public var tileHover:Bitmap;
		public var gridScene:IsoScene;
		public var isoScene:IsoScene;
		public var isoGrid:IsoGrid;
		public var isoView:IsoView;
		public var hover:IsoSprite;
		
		public function DynamicMap() 
		{
			
		}
		
		public function init():void
		{
			this.addEventListeners();
			
			this.avatarManager = new AvatarManager();
			this.avatarManager.init();
			
			this.itemManager = new ItemManager();
			this.itemManager.init();
			
			this.tileManager = new TileManager();
			this.tileManager.init();
			
			this.tileHover = new TileHover();

			this.isoGrid = new IsoGrid();
			this.isoGrid.cellSize = 24;
			this.isoGrid.showOrigin = false;

			this.isoScene = new IsoScene();

			this.gridScene = new IsoScene();
			//this.gridScene.addChild(this.isoGrid);
			
			this.isoView = new IsoView();
			this.isoView.clipContent = false;
			this.isoView.showBorder = false;
			this.isoView.addScene(this.gridScene);
			this.isoView.addScene(this.isoScene);
			this.addChild(this.isoView);

			this.hover = new IsoSprite();
			this.hover.setSize(24, 24, 0);
			this.hover.sprites = [this.tileHover];
			this.tileHover.x = -24;

			this.isoScene.addChild(this.hover);
			
			this.gridScene.render();
			this.isoScene.render();
		}
		
		public function reset():void
		{
			
		}
		
		public function release():void
		{
			this.removeEventLiseners();

			for each(var avatar:IAvatar in this.avatarManager.avatars)
			{
				if (avatar == null) continue;
				Tweener.removeTweens(avatar);
				this.removeAvatar(avatar.id);
			}

			for each(var item:Item in this.itemManager.items)
			{
				if (item == null) continue;
				
				this.isoScene.removeChild(item.container);
				item.release();
			}
			
			for each(var tile:Tile in this.tileManager.tiles)
			{
				if (tile == null) continue;
				this.isoView.backgroundContainer.removeChild(tile.bitmap);
				this.tileManager.remove(tile.tile);
				tile.release();
				tile = null;
			}
			
			this.isoScene.removeChild(this.hover);
			
			//this.isoScene.removeAllChildren();
			//this.isoView.removeAllScenes();
		}
				
		private function removeEventLiseners():void
		{
			this.eventManager.removeEventListener(ServerEvent.ADD_AVATAR, eventManager_addAvatar);
			this.eventManager.removeEventListener(ServerEvent.REMOVE_AVATAR, eventManager_removeAvatar);
			this.eventManager.removeEventListener(ServerEvent.MOVE_AVATAR, eventManager_moveAvatar);
			this.eventManager.removeEventListener(ServerEvent.ADD_ITEM, eventManager_addItem);
			this.eventManager.removeEventListener(ServerEvent.USER_STATUS, eventManager_userStatus);
			this.eventManager.removeEventListener(ServerEvent.REMOVE_ITEM, eventManager_removeItem);
			this.removeEventListener(MouseEvent.CLICK, this_click);
			this.removeEventListener(Event.ENTER_FRAME, this_enterFrame);
		}
		
		private function addEventListeners():void
		{
			this.eventManager.addEventListener(ServerEvent.ADD_AVATAR, eventManager_addAvatar);
			this.eventManager.addEventListener(ServerEvent.REMOVE_AVATAR, eventManager_removeAvatar);
			this.eventManager.addEventListener(ServerEvent.MOVE_AVATAR, eventManager_moveAvatar);
			this.eventManager.addEventListener(ServerEvent.ADD_ITEM, eventManager_addItem);
			this.eventManager.addEventListener(ServerEvent.USER_STATUS, eventManager_userStatus);
			this.eventManager.addEventListener(ServerEvent.REMOVE_ITEM, eventManager_removeItem);
			
			this.addEventListener(MouseEvent.CLICK, this_click, false, 0, true);
			this.addEventListener(Event.ENTER_FRAME, this_enterFrame, false, 0, true);
		}
		
		private function eventManager_removeItem(e:ServerEvent):void 
		{
			
		}
		
		private function this_enterFrame(e:Event):void 
		{		
			this.this_mouseMove();
			//this.runAvatars();
			//set flag to check if we have to update
			this.isoScene.render();
			//this.gridScene.render();
		}
		
		private function runAvatars():void
		{
			for each(var avatar:IAvatar in this.avatarManager.avatars)
			{
				if (!avatar) 
				{
					continue;
				}
				
				if (avatar.stepper.count > 0 && !avatar.easing)
				{
					this.stepAvatar(avatar); 
				}
			}
		}
		
		private function this_mouseMove(e:MouseEvent = null):void 
		{
			var localPoint:Point = this.isoView.localToIso(new Point(this.isoView.mouseX, this.isoView.mouseY));
			var screenPoint:Point = IsoMath.isoToScreen(new Pt(localPoint.x, localPoint.y, 0), true);
			var isoPoint:GridPoint = Isometric.toIso(screenPoint.x, screenPoint.y);
			
			if (tileManager.exists(isoPoint.row, isoPoint.col))
			{
				var hoverPoint:Point = Isometric.toScreen(isoPoint.row, isoPoint.col);
				var hoverPlacement:Pt = IsoMath.screenToIso(new Pt(hoverPoint.x, hoverPoint.y));

				if (!this.hover.container.visible) this.hover.container.visible = true;
				this.hover.moveTo(hoverPlacement.x, hoverPlacement.y, 0);
			}
			else this.hover.container.visible = false;
		}
		
		private function walkRequest(e:MouseEvent):void
		{
			var isoPoint:GridPoint = screenToIso(new Pt(e.stageX, e.stageY));

			if(this.tileManager.exists(isoPoint.row, isoPoint.col))
			{
				this.eventManager.dispatchEvent(new SocketSendEvent(PacketTypes.MOVE_AVATAR_REQUEST, {
					x : isoPoint.row,
					y : isoPoint.col
				}));
			}
		}
		
		private function this_click(e:MouseEvent):void 
		{
			if (e.currentTarget is Avatar) 
			{
				this.dispatchEvent(new APIEvent(APIEvent.AVATAR_CLICKED, (e.target as Avatar).toObject()));
			}
			this.walkRequest(e);
		}
		
		private function eventManager_userStatus(e:ServerEvent):void 
		{
			var avatar:IAvatar = this.avatarManager.getByID(e.parameters.I);
			
			if (avatar != null)
			{
				avatar.status = e.parameters.S;
			}
		}
		
		private function eventManager_moveAvatar(e:ServerEvent):void 
		{
			var avatar:IAvatar = this.avatarManager.getByID(e.parameters.I);
			
			if (avatar != null)
			{
				var data:Object = e.parameters;
				var tile:Point = Isometric.toScreen(data.X, data.Y);
				var point:Pt = IsoMath.screenToIso(new Pt(tile.x, tile.y));
				var step:Step = new Step(data.S, data.W, data.X, data.Y, data.H, data.SH, data.SI); //wtf create a custom event for this crap
				
				avatar.stepper.add(step);
				this.eventManager.dispatchEvent(new APIEvent(APIEvent.USER_MOVED, step.toObject()));
				if(avatar.stepper.count > 0 && avatar.easing == false)
					stepAvatar(avatar);
			}
		}
		
		private function stepAvatar(avatar:IAvatar):void
		{
			var step:Step = avatar.stepper.current;
			var screenPoint:Point = Isometric.toScreen(step.row, step.col);
			var tilePoint:Pt = IsoMath.screenToIso(new Pt(screenPoint.x, screenPoint.y));

			if (true)
			{
				avatar.easing = true;
				avatar.header = step.direction;
	
				Tweener.addTween(
					avatar.container, {
						x : tilePoint.x,
						y : tilePoint.y,
						time : 0.45,
						transition : "linear",
						onUpdate : function():void
						{
							if (avatar.stepper.last != null) //create new step on avatar creation with tile pt
							{
								if (avatar.stepper.last.tile != step.tile)
								{
									avatar.run();
								}
							}
							else avatar.run();
						},
						onComplete : function():void
						{
							if (step.type == "walk_end")
							{
								avatar.easing = false;
							}
							
							avatar.easing = false;
							avatar.row = step.row;
							avatar.col = step.col;
							avatar.easing = false;
							avatar.state = step.state;
							avatar.stepper.shift();
							
							if (avatar.stepper.count > 0) {
								stepAvatar(avatar);
							}
						}
					}
				); 
			}
		}
		
		private function eventManager_removeAvatar(e:ServerEvent):void 
		{
			this.removeAvatar(e.parameters.I);
			
			var userObj:Object = {
				id : e.parameters.I
			};
			
			this.eventManager.dispatchEvent(new APIEvent(APIEvent.REMOVE_USER, userObj));
		}
		
		public function removeItem(id:int):void
		{
			var item:Item = this.itemManager.getById(id) as Item;
			if (item == null) return;
			
			this.isoScene.removeChild(item.container);
			this.itemManager.removeByID(id);
			item.release();
		}
		
		public function removeAvatar(id:int):void
		{
			var avatar:IAvatar = this.avatarManager.getByID(id);
			if (avatar == null) return;
			
			this.isoScene.removeChild(avatar.container);
			this.avatarManager.removeByID(id);
			avatar.release();
			avatar = null;
		}
		
		private function eventManager_addAvatar(e:ServerEvent):void 
		{
			var avatarData:Object = e.parameters;
			var tile:Point = Isometric.toScreen(avatarData.X, avatarData.Y);
			var point:Pt = IsoMath.screenToIso(new Pt(tile.x, tile.y));
			var avatar:IAvatar = new Avatar();
			var container:IsoSprite = new IsoSprite();
			container.sprites = [avatar as DisplayObject];
			container.setSize(24, 24, 140);
			container.moveTo(point.x, point.y, 0);

			this.isoScene.addChild(container);

			avatar.id = (e.parameters.I == null) ? "1" : e.parameters.I;
			avatar.username = e.parameters.U;
			avatar.mission = e.parameters.M;
			avatar.status = e.parameters.St;
			avatar.header = e.parameters.H;
			avatar.row = e.parameters.X;
			avatar.col = e.parameters.Y;
			avatar.status = e.parameters.Sta;
			avatar.processClothesData(e.parameters.C);
			avatar.container = container;
			avatar.init();
			
			var offset:Point = avatar.offsetAvatar(avatarData.St, 1);
			avatar.x = offset.x;
			avatar.y = offset.y;
			
			this.avatarManager.add(e.parameters.I, avatar);
			this.eventManager.dispatchEvent(new APIEvent(APIEvent.ADD_USER, avatar.toObject()));
		}
		
		private function processRoomItems():void
		{
			for (var i:int = 0; i < this.roomData.items.length -1; i++)
			{
				var item:Object = this.roomData.items[i];
				if(item.I != null) this.addItem(item);
			}
		}
		
		private function sortTile(tile:Tile):void
		{
			/*
			for each(var items:ItemManager in tile.items)
			{
				
			}*/
		}
		
		private function addItem(itemData:Object):void
		{
			//@todo for some reason the item data is in .X
			//temp hack fix
			var tileSplit:Array = itemData.T.split(/_/);
			itemData.X = tileSplit[0];
			itemData.Y = tileSplit[1];
			//end temp fix
		
			var item:IItem = new Item(); //need a process function for all items
			item.id = itemData.I;
			item.type = itemData.Ty;
			item.stackNumber = itemData.S;
			item.stackable = itemData.Ss;
			item.row = itemData.X;
			item.col = itemData.Y;
			item.heading = itemData.H;
			item.tile = itemData.T;
			item.cols = itemData.C;
			item.rows = itemData.R;

			//var tileObject:Tile = tileManager.
			
			var tile:Point = Isometric.toScreen(itemData.X, itemData.Y);
			var point:Pt = IsoMath.screenToIso(new Pt(tile.x, tile.y));
			
			var primativeBox:IsoBox = new IsoBox();
			primativeBox.setSize(24 * item.cols, 24 * item.rows, 20);
			
			primativeBox.stroke = new Stroke(1, 0xeeeeee, 1);
			/*primativeBox.addEventListener(MouseEvent.CLICK, function(e:ProxyEvent):void {
				(e.proxy as IIsoContainer).container.alpha = .5;
				//(e.proxyTarget as DisplayObjectContainer).visible = false;
			});*/

			var container:IsoSprite = new IsoSprite();
			container.addChild(primativeBox);
			container.moveTo(point.x, point.y, 0);
			container.setSize(24, 24, 20);
			item.container = container;
			
			this.isoScene.addChild(item.container);
			this.itemManager.add(itemData.I, item);
		}
		
		private function eventManager_addItem(e:ServerEvent):void 
		{
			this.addItem(e.parameters);
		}

		public function drawGrid():void
		{
			this.isoGrid.setGridSize(this.roomData.rows, this.roomData.cols);
			
			for (var x:int = 0; x < this.roomData.rows; x++)
			{
				for (var y:int = 0; y < this.roomData.cols; y++)
				{
					//var wall:WallBitmap = new WallBitmap();
					var tileBitmap:TileBitmap = new TileBitmap(this.roomData.floor);
					var tile:Tile = new Tile();
					tile.row = x;
					tile.col = y;
					tile.bitmap = tileBitmap;
					
					//wall.load();
					var gridPoint:GridPoint = new GridPoint(x, y);
					var point:Point = Isometric.toScreen(x, y);
					this.tileManager.add(gridPoint.tile, tile);
					tileBitmap.load();
					//this.addChild(tileBitmap);
					this.isoView.backgroundContainer.addChild(tileBitmap);
					
					
					tileBitmap.x = point.x - 24;
					tileBitmap.y = point.y;
					/*tileBitmap.x = y * (50 - 2); 
					tileBitmap.y = x * ((25 - 1) / 2);
						
					if (x % 2 == 1) 
					{
						tileBitmap.x += ((50 / 2) - 1); 
					}*/
					
					/*var _genData:Array = [ -4, 95, 26, 96, 14, 92, 22, 104, 24, 22, 98, 18, 78];
					
					if(y == 1)
					{
						wall.x = point.x;
						wall.y = point.y;
							
						//if (x == 7) _wall = wall;
					}
					if(x == 1)
					{
						wall.x = 24 * (y - x) + _genData[2] + 20;
						wall.y = 12 * (y + x) - _genData[3] - 10;
					}
					
					this.isoView.backgroundContainer.addChild(wall);*/
				}
			}
			
			this.isoView.x = 200;
			this.isoView.y = - 40;
			this.processRoomItems();
		}
		
		public function isoToScreen(x:int, y:int):Pt
		{
			var tilePoint:Point = Isometric.toScreen(x, y); 
			return IsoMath.screenToIso(new Pt(tilePoint.x, tilePoint.y));
		}
		
		public function screenToIso(pt:Pt):GridPoint
		{
			var point:Point = this.isoScene.container.globalToLocal(pt);
			var localPoint:Pt = new Pt(point.x, point.y);
			var isoPoint:GridPoint = Isometric.toIso(localPoint.x, localPoint.y);
			IsoMath.screenToIso(localPoint);
			return isoPoint;
		}

	}

}