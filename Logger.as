package game 
{
	/**
	 * ...
	 * @author William J Robin
	 */
	public class Logger 
	{
		public static const LEVEL_WARN:String = "warn";
		public static const LEVEL_ERROR:String = "error";
		public static const LEVEL_INFO:String = "info";
		
		public function Logger() 
		{
			
		}
		
		public static function log(data:String, level:String = null):void
		{
			trace(data);
		}
	}

}