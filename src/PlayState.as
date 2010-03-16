package {
	import Box2DAS.Collision.AABB;
	import Box2DAS.Collision.Shapes.b2PolygonShape;
	import Box2DAS.Collision.Shapes.b2Shape;
	import Box2DAS.Common.V2;
	import Box2DAS.Common.b2Base;
	import Box2DAS.Common.b2Def;
	import Box2DAS.Dynamics.Joints.b2MouseJoint;
	import Box2DAS.Dynamics.b2Body;
	import Box2DAS.Dynamics.b2BodyDef;
	import Box2DAS.Dynamics.b2DebugDraw;
	import Box2DAS.Dynamics.b2Fixture;
	import Box2DAS.Dynamics.b2FixtureDef;
	import Box2DAS.Dynamics.b2World;
	
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	
	import util.f2b;
	
	public class PlayState extends FlxState {
		public static var instance:PlayState;
		private var world:b2World;
		
		private var db:b2DebugDraw;
		
		private var mousePVec:V2 = new V2();
		private var doMouseDrag:Boolean = false;
		private var bodyToDrag:b2Body;
		private var mouseJoint:b2MouseJoint = null;
		
		private var mouseXWorldPhys:Number;
		private var mouseYWorldPhys:Number;
		
		public var groundBody:b2Body;
		
		public var mp:V2;
		private static var p:Point = new Point( 0, 0 );
		
		private var filterMode:int = 0;
		public static var filter:BitmapFilter = new DropShadowFilter( 0, 0, 0x000000, 1, 2, 2, 20, BitmapFilterQuality.MEDIUM, false );
		
		public function PlayState() {
			super();
			bgColor = 0x00000000;
			instance = this;
			b2Base.initialize( true );
			b2Def.initialize();
			world = initializeWorld();
			mp = new V2( f2b( FlxG.mouse.x ), f2b( FlxG.mouse.y ) );
			createGround();
			groundBody = world.m_groundBody;
			//add( new FlxText( 0, 0, 300, "Flixel/Box2d with Flex 4 SDK" ).setFormat( "system", 8, 0xFFFFFF ) );
			FlxG.showCursor();
		}
		
		override public function update():void {
			if ( FlxG.keys.justPressed( "M" ) ) {
				add( new Player( FlxG.mouse.x, FlxG.mouse.y, world ) );
			}
			if ( FlxG.keys.justPressed( "B" ) ) {
				add( new BigPlayer( FlxG.mouse.x, FlxG.mouse.y, world ) );
			}
			if ( FlxG.keys.justPressed( "L" ) ) {
				add( new BigPlayerLeft( FlxG.mouse.x, FlxG.mouse.y, world ) );
			}
			if ( FlxG.keys.justPressed( "F" ) ) {
				filterMode = ( filterMode == 1 ) ? 0 : 1;
			}
			mp = new V2( f2b( FlxG.mouse.x ), f2b( FlxG.mouse.y ) );
			MouseDrag();
			world.Step( FlxG.elapsed, 10, 10 );
			super.update();
		}
		
		override public function render():void {
			super.render();
			if ( filterMode == 1 ) {
				FlxG.buffer.applyFilter( FlxG.buffer, FlxG.buffer.rect, p, filter );
			}
			//db.Draw();
		}
		
		private function initializeWorld():b2World {
			var world:b2World = null;
			var gravity:V2 = new V2( 0, 9.81 * 2 );
			var doSleep:Boolean = true;
			world = new b2World( gravity, doSleep );
			
			db = new b2DebugDraw( world, 1 / Main.RATIO );
			db.shapes = false;
			addChild( db );

			// Use Box2D's internal rendering engine to display the simulation for now.
			//debugDraw.SetSprite( this ); // = an empty container on the display list
			//debugDraw.SetDrawScale( 1 / Main.RATIO ); // 16 pixels per meter
			//debugDraw.SetFlags( b2DebugDraw.e_shapeBit /* | b2DebugDraw.e_jointBit |
			//	b2DebugDraw.e_sensorBit | b2DebugDraw.e_aabbBit*/ ); // draw shapes
			//debugDraw.SetLineThickness( 1.0 );
			//world.SetDebugDraw( debugDraw );

			return world;
		}
		
		private function createGround():void {
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.position.v2 = new V2( f2b( Main.WIDTH / 2 ), f2b( Main.HEIGHT - ( Main.TILESIZE / 2.0 ) ) );
			var boxShape:b2PolygonShape = new b2PolygonShape();
			boxShape.SetAsBox( f2b( Main.WIDTH / 2.0 ), f2b( Main.TILESIZE / 2.0 ) );
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.shape = boxShape;
			fixtureDef.friction = 0.3;
			fixtureDef.density = 0; // static bodies require zero density
			fixtureDef.filter.categoryBits = Main.FLOOR_CATEGORY_BITS;
			var body:b2Body = world.CreateBody( bodyDef );
			body.CreateFixture( fixtureDef );
		}
		
		public function MouseDrag():void {
			if ( FlxG.mouse.pressed() && !mouseJoint ) {
				var body:b2Body = GetBodyAtMouse( false );
				if (body) {
					with ( b2Def.mouseJoint ) {
						bodyA = groundBody;
						bodyB = body;
						target.v2 = mp;
						collideConnected = true;
						maxForce = 500.0;
					}
					mouseJoint = world.CreateJoint( b2Def.mouseJoint ) as b2MouseJoint;
					body.SetAwake( true );
				}
			}
			if ( !FlxG.mouse.pressed() && mouseJoint ) {
				world.DestroyJoint( mouseJoint );
				mouseJoint = null;
			}
			if ( mouseJoint ) {
				mouseJoint.SetTarget(mp);
			}
		}

		private function GetBodyAtMouse( includeStatic:Boolean = false ):b2Body {
			var body:b2Body = null;
			world.QueryAABB( function( fixture:b2Fixture ):Boolean {
				var b:b2Body = fixture.GetBody();
				var s:b2Shape = fixture.GetShape();
				if ( b.IsDynamic() || includeStatic ) {
					if ( s.TestPoint( b.GetTransform(), mp ) ) {
						body = b;
						return false;
					}
				}
				return true;
			}, AABB.FromV2( mp ) );
			return body;
		}
		
		override public function postProcess():void {
		}
	}
}
