package {
	import org.flixel.data.FlxFactory;
	
	public class Preloader extends FlxFactory {
		public function Preloader():void {
			className = "Main";
			super();
		}
	}
}