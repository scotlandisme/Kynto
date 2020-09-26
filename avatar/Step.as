package game.avatar 
{
	/**
	 * ...
	 * @author William J Robin
	 */
	
	public class Step 
	{
		
		public var col:int;
		public var row:int;
		public var direction:int;
		public var sitDirection:int;
		public var furniID:int;
		public var state:String;
		public var type:String;
	
		public function Step(state:String, type:String, row:int, col:int, direction:int, sitDirection:int, furniID:int) 
		{
			this.state = state;
			this.type = type;
			this.row = row;
			this.col = col;
			this.direction = direction;
			this.sitDirection = sitDirection;
			this.furniID = furniID;
		}
		
		public function get tile():String
		{
			return row.toString() + "_" + col.toString();
		}
		
		public function toObject():Object
		{
			var obj:Object = {
				state : this.state,
				type : this.type,
				row: this.row,
				col: this.col,
				direction : this.direction,
				sitDirection : this.sitDirection,
				furniID : this.furniID
			}
			
			return obj;
		}
		
		public function dispose():void
		{
			this.state = null;
			this.row = NaN;
			this.col = NaN;
			this.direction = NaN;
			this.sitDirection = NaN;
			this.furniID = NaN;
		}
	}

}