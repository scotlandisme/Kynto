package game.network
{
	import com.adobe.utils.ObjectUtil;
	import utils.B64;
	import flash.utils.ByteArray;
	import com.dynamicflash.util.Base64;
	import be.boulevart.utils.RC4ByteArray;
	
	/**
	 * ...
	 * @author William J Robin
	 */
	
	public class Encryption
	{
		private static var _key:String = "10078904dd982fbe5682651f1e313b56"; //haha
		 
		public static function init(key:String):void
		{
			_key = key;
		}
		
		public static function decrypt(data:String):String
		{
			var b64:ByteArray = Base64.decodeToByteArray(data);
			var bytes:ByteArray = RC4ByteArray.decryptToByteArray(_key, b64);
				
			return bytes.readUTFBytes(bytes.bytesAvailable);
		}

		public static function encrypt(data:String):String
		{
			var byteData:ByteArray = null;
			var attempts:int = 0;

			do {
				byteData = RC4ByteArray.encryptString(_key, data as String);
				attempts++;
			} while(!validate(ObjectUtil.copy(byteData) as ByteArray, data) && attempts < 4);

			var string:String = "";
			attempts = 0;
			
			do {
				string = Base64.encodeByteArray(byteData);
				attempts++;
			} while (!B64.validate(string) && attempts < 4);

			return string;
		}

		public static function validate(byteData:ByteArray, str2:String):Boolean
		{
			var str:String = RC4ByteArray.decryptString(_key, byteData);
			return (str === str2);
		}
	}
}