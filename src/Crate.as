package {
	
	import Box2DAS.Collision.Shapes.b2PolygonShape;
	import Box2DAS.Dynamics.b2Body;
	import Box2DAS.Dynamics.b2BodyDef;
	import Box2DAS.Dynamics.b2FixtureDef;
	import Box2DAS.Dynamics.b2World;
	
	import org.flixel.FlxSprite;
	
	import util.b2f;
	import util.f2b;

	public class Crate extends FlxSprite {
		[Embed(source="../resources/gfx/crate.png")]
		private var ImgBox:Class;

		private var boxBodyDef:b2BodyDef;
		private var body:b2Body;

		private var initialRotation:Number = Math.random() * 720.0 - 360.0;
		
		public static var radInDeg:Number = 180.0 / Math.PI;

		public function Crate( x:int, y:int, world:b2World ) {
			super( x, y, ImgBox );
			offset.x = offset.y = 8;
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.position.x = f2b( x );
			bodyDef.position.y = f2b( y );
			bodyDef.type = b2Body.b2_dynamicBody;
			var boxShape:b2PolygonShape = new b2PolygonShape();
			boxShape.SetAsBox( f2b( 8 ), f2b( 8 ) );
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.shape = boxShape;
			fixtureDef.restitution = 0.01;
			fixtureDef.friction = 0.8;
			fixtureDef.density = 1.0;
			body = world.CreateBody( bodyDef );
			body.CreateFixture( fixtureDef );
		}

		override public function update():void {
 			if ( !body.IsAwake() ) {
				return;
			}
			x = Math.round( b2f( body.GetPosition().x ) );
			y = Math.round( b2f( body.GetPosition().y ) );
			angle = ( body.GetAngle() ) * radInDeg;
			super.update();
		}
	}
}
