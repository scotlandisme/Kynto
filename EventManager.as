package game
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import game.network.events.ServerEvent;
	import JSON;
	/**
	 * ...
	 * @author William J Robin
	 */
	
	public class EventManager implements IDisposable
	{
		private var _eventDispatcher:EventDispatcher;
		private var _eventListeners:Array;
		
		public function EventManager() 
		{

		}
		
		public function init():void
		{
			_eventDispatcher = new EventDispatcher();
			_eventListeners = new Array();
		}
		
		public function release():void
		{
			
		}
		
		public function addEventListener(type:String, handler:Function, gc:Boolean = true):void
		{
			_eventDispatcher.addEventListener(type, handler, false, 0, gc);
			
			var eventObject:EventListenerObject = new EventListenerObject(_eventListeners.length);
			eventObject.func = handler;
			eventObject.type = type;

			_eventListeners.push(eventObject);
		}
		
		public function removeEventListener(type:String, func:Function, useCapture:Boolean = false):void
		{
			for (var i:int = 0; i < _eventListeners.length; i++)
			{
				var event:EventListenerObject = _eventListeners[i];
				
				if (event.func == func && event.type == type)
				{
					_eventDispatcher.removeEventListener(type, func, useCapture);
					_eventListeners.splice(i, 1);
				}
				else 
				{
					continue;
				}
			}
		}
		
		public function dispatchEvent(e:Event, rank:int = 0):Boolean
		{
			var date:Date = new Date();
			
			if (this._eventDispatcher) 
			{
				if (e is ServerEvent)
				{
					Logger.log("[SERVER] " + e.type + " -> " + JSON.stringify((e as ServerEvent).parameters));
				}
				else
				{
					Logger.log("[CLIENT] " + e.type);
				}
				return this._eventDispatcher.dispatchEvent(e);
			}

			return false;
		}
		
		public function checkClones():void
		{
			for (var i:int = 0; i < _eventListeners.length; i++)
			{
				var firstEvent:EventListenerObject = _eventListeners[i];
				
				for (var x:int = 0; x < _eventListeners.length; x++)
				{
					var secondEvent:EventListenerObject = _eventListeners[x];
					
					if (firstEvent.func == secondEvent.func && firstEvent.type == secondEvent.type)
					{
						trace("Clone Event " + secondEvent.type);
					}
				}
			}
		}
		
	}

}