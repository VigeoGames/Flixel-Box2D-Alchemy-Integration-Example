package {
	import org.flixel.FlxSprite;

	public class NullSprite extends FlxSprite {
		private var name:String;
		
		public function NullSprite( name:String, x:int, y:int, graphics:Class = null ) {
			super( x, y, null );
			this.name = name;
		}
		
		override public function update():void {
			// No update
		}
		
		override public function render():void {
			// No render
		}
	}
}