package {
	import Box2DAS.Dynamics.b2Body;
	
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	
	import util.b2f;

	/**
	 * Limb integrates FlxSprite with Box2D body so that Box2D is responsible for the sprite's physical simulation.
	 */
	public class Limb extends FlxSprite {
		public var name:String;
		
		public var body:b2Body;
		
		public static var radInDeg:Number = 180.0 / Math.PI;
		public static var degInRad:Number = Math.PI / 180.0;
		
		public function Limb( name:String, x:int = 0, y:int = 0, graphic:Class = null, body:b2Body = null ) {
			super( x, y, graphic );
			this.name = name;
			this.body = body;
		}
		
		override public function update():void {
			if ( !body.IsAwake() ) {
				return;
			}
			x = Math.round( b2f( body.GetPosition().x ) );
			y = Math.round( b2f( body.GetPosition().y ) );
			angle = Math.round( body.GetAngle() * radInDeg );
		}
		
		/**
		 * Render method slightly modified compared to FlxSprite.render() in that it omits origin in the final step of matrix
		 * translation. It is so, because we rely on Box2d to calculate the limb's position and rotation and we blindly copy
		 * those parameters to sprite's x, y and angle.
		 */
		override public function render():void {
			if ( !visible ) {
				return;
			}
			
			getScreenXY( _p );
			
			_mtx.identity();
			_mtx.translate( -origin.x, -origin.y );
			if ( ( scale.x != 1 ) || ( scale.y != 1 ) ) {
				_mtx.scale( scale.x, scale.y );
			}
			if ( angle != 0 ) {
				_mtx.rotate( angle * degInRad );
			}
			// This is where it differs from FlxSprite.render()
			_mtx.translate( _p.x, _p.y );
			FlxG.buffer.draw( _framePixels, _mtx, null, blend, null, true );
		}
	}
}
