package game.avatar 
{
	/**
	 * ...
	 * @author William J Robin
	 */
	
	public class Stepper 
	{
		
		private var _queue:Vector.<Step>;
		private var _current:Step;
		private var _last:Step;
		
		public function Stepper() 
		{
			_queue = new Vector.<Step>();
		}
		
		public function init():void
		{
			
		}
		
		public function release():void
		{
			this._queue = null;
		}
		
		public function add(obj:Step):void
		{
			_queue.push(obj);
		}
		
		public function get current():Step
		{
			_current = _queue[0];
			return _current;
		}
		
		public function get count():int
		{
			return _queue.length;
		}
		
		public function get last():Step
		{
			return _last;
		}
		
		public function set last(value:Step):void
		{
			_last = value;
		}
		
		public function shift():void
		{
			_last = _queue.shift();
		}
		
	}

}