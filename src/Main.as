package {
	import org.flixel.FlxGame;
	
	[SWF( width=800, height=400, backgroundColor="#FFFFFF" )]
	[Frame( factoryClass = "Preloader" )]
	public class Main extends FlxGame {
		public static var instance:Main;
		
		public static var WIDTH:int = 800;
		public static var HEIGHT:int = 400;
		public static var ZOOM:int = 1;
		public static var TILESIZE:Number = WIDTH / 40.0; // 20x10 tiles
		public static var RATIO:Number = TILESIZE / WIDTH; // Flixel to Box2D ratio
		
		public static var MAN_CATEGORY_BITS:int = 0x0002;
		public static var CRATE_CATEGORY_BITS:int = 0x0004;
		public static var FLOOR_CATEGORY_BITS:int = 0x0008;
		
		public function Main() {
			super( WIDTH, HEIGHT, PlayState, ZOOM );
			instance = this;
			showLogo = false;
		}
	}
}
