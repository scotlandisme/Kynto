package game 
{
	/**
	 * ...
	 * @author William J Robin
	 */
	
	public class UserObject 
	{
		public var id:int;
		public var username:String;
		public var email:String;
		public var rank:int;
		public var money:Number;
		public var badge:int;
		public var badges:Number;
		public var mission:String;
		public var loggedIn:Boolean = false;
		public var lastMessage:String;
		public var sex:String;
		
		public function UserObject() 
		{
			
		}
		
		public function toObject():Object
		{
			var obj:Object = {
				id : this.id,
				user: this.username,
				email : this.email,
				rank : this.rank,
				money : this.money,
				badge : this.badge,
				badges : this.badges,
				mission : this.mission,
				loggedIn : this.loggedIn
			};
			
			return obj;
		}
	}

}