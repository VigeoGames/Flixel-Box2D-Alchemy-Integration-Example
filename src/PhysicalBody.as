package {
	import Box2DAS.Collision.Shapes.b2PolygonShape;
	import Box2DAS.Common.V2;
	import Box2DAS.Dynamics.Joints.b2Joint;
	import Box2DAS.Dynamics.Joints.b2RevoluteJointDef;
	import Box2DAS.Dynamics.b2Body;
	import Box2DAS.Dynamics.b2BodyDef;
	import Box2DAS.Dynamics.b2FixtureDef;
	import Box2DAS.Dynamics.b2World;
	
	import util.b2f;
	import util.f2b;
	
	public class PhysicalBody {
		private var limbs:Vector.<Limb>;
		private var joints:Vector.<b2Joint>;
		private var fixture:b2FixtureDef;
		private var world:b2World;
		
		public function PhysicalBody() {
			this.limbs = new Vector.<Limb>();
			this.joints = new Vector.<b2Joint>();
			this.fixture = new b2FixtureDef();
		}
		
		public function withWorld( world:b2World ):PhysicalBody {
			this.world = world;
			return this;
		}
		
		public function withFiltering( categoryBits:int, maskBits:int, groupIndex:int ):PhysicalBody {
			this.fixture.filter.categoryBits = categoryBits;
			this.fixture.filter.maskBits = maskBits;
			this.fixture.filter.groupIndex = groupIndex;
			return this;
		}
		
		public function withMaterial( density:Number, friction:Number, restitution:Number ):PhysicalBody {
			this.fixture.density = density;
			this.fixture.friction = friction;
			this.fixture.restitution = restitution;
			return this;
		}
		
		public function addLimb( name:String, width:Number, height:Number, referenceLimbName:String, x:Number, y:Number,
			graphic:Class = null, originX:Number = 0, originY:Number = 0, fixedRotation:Boolean = false,
			isSensor:Boolean = false ):PhysicalBody {
			return addLimbWithReference( name, width, height, getLimb( referenceLimbName ), x, y, graphic, originX, originY,
				fixedRotation, isSensor );
		}
		
		public function addLimbWithReference( name:String, width:Number, height:Number, referenceLimb:Limb, x:Number, y:Number,
			graphic:Class = null, originX:Number = 0, originY:Number = 0, fixedRotation:Boolean = false,
			isSensor:Boolean = false ):PhysicalBody {
			var world:b2World = this.world;
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.angularDamping = 3.0;
			bodyDef.fixedRotation = fixedRotation;
			bodyDef.type = b2Body.b2_dynamicBody;
			if ( referenceLimb != null ) {
				bodyDef.position.x = referenceLimb.body.GetWorldCenter().x + f2b( x );
				bodyDef.position.y = referenceLimb.body.GetWorldCenter().y + f2b( y );
			}
			else {
				bodyDef.position.x = f2b( x );
				bodyDef.position.y = f2b( y );
			}
			var shape:b2PolygonShape = new b2PolygonShape();
			shape.SetAsBox( f2b( width / 2 ), f2b( height / 2 ) );
			var fixture:b2FixtureDef = this.fixture; // reuse fixture
			var previousSensorValue:Boolean = fixture.isSensor; // store shape's isSensor value
			fixture.isSensor = isSensor;
			fixture.shape = shape;
			var limbBody:b2Body = world.CreateBody( bodyDef );
			limbBody.CreateFixture( fixture );
			var limb:Limb = new Limb( name, x, y, graphic, limbBody );
			//limb.origin = new Point( originX, originY );
			if ( graphic != null ) {
				PlayState.instance.add( limb );
			}
			limbs.push( limb );
			fixture.isSensor = previousSensorValue; // revert shape's isSensor value
			return this;
		}
		
		public function addJoint( name:String, limb1Name:String, limb2Name:String, x:Number, y:Number, lowerAngle:Number = 0.0,
			upperAngle:Number = 0.0, enableLimit:Boolean = true ):PhysicalBody {
			return addJointByBodies( name, getLimb( limb1Name ), getLimb( limb2Name ), x, y, lowerAngle, upperAngle, enableLimit );
		}
		
		public function addJointByBodies( name:String, limb1:Limb, limb2:Limb, x:Number, y:Number, lowerAngle:Number = 0.0,
			upperAngle:Number = 0.0, enableLimit:Boolean = true ):PhysicalBody {
			var world:b2World = this.world;
			var jointDef:b2RevoluteJointDef = new b2RevoluteJointDef();
			jointDef.enableLimit = enableLimit;
			jointDef.lowerAngle = lowerAngle / ( 180 / Math.PI );
			jointDef.upperAngle = upperAngle / ( 180 / Math.PI );
			jointDef.enableMotor = true;
			jointDef.maxMotorTorque = 0.01;
			var body1:b2Body = limb1.body;
			var body2:b2Body = limb2.body;
			jointDef.Initialize( body1, body2, new V2( body2.GetWorldCenter().x + f2b( x ), body2.GetWorldCenter().y +
				f2b( y ) ) );
			joints.push( world.CreateJoint( jointDef ) );
			return this;
		}
		
		public function modifyLimb( name:String, width:Number, height:Number, x:Number, y:Number, fixedRotation:Boolean = false,
			isSensor:Boolean = false ):PhysicalBody {
			if ( this.limbs[name] == null ) {
				return this;
			}
			// TODO: modify limb parameters
			return this;
		}
		
		public function modifyJoint( name:String, type:Class, body1:b2Body, body2:b2Body, x:Number, y:Number,
			enableLimit:Boolean = false, lowerAngle:Number = 0.0, upperAngle:Number = 0.0 ):PhysicalBody {
			if ( this.joints[name] == null ) {
				return this;
			}
			// TODO: modify joint parameters
			return this;
		}
		
		public function removeLimb( name:String ):PhysicalBody {
			if ( this.limbs[name] == null ) {
				return this;
			}
			// TODO: remove limb
			return this;
		}
		
		public function removeJoint( name:String ):PhysicalBody {
			if ( this.joints[name] == null ) {
				return this;
			}
			// TODO: remove joint
			return this;
		}
		
		public function getLimb( name:String ):Limb {
			if ( name == null || name == "" ) {
				return null;
			}
			for each ( var limb:Limb in limbs ) {
				if ( limb.name == name ) {
					return limb;
				}
			}
			return null;
		}
		
		public function getJoint( name:String ):b2Joint {
			if ( name == null || name == "" ) {
				return null;
			}
			return this.joints[name] as b2Joint;
		}
		
		public function getLimbX( name:String ):Number {
			return b2f( this.limbs[name].body.GetWorldCenter().x );
		}
		
		public function getLimbY( name:String ):Number {
			return b2f( this.limbs[name].body.GetWorldCenter().y );
		}
		
		public function getLimbs():Vector.<Limb> {
			return limbs;
		}
		
		public function destroy():void {
			for each ( var joint:b2Joint in joints ) {
				this.world.DestroyJoint( joint );
			}
			joints = new Vector.<b2Joint>();
			for each ( var limb:Limb in limbs ) {
				world.DestroyBody( limb.body );
			}
			limbs = new Vector.<Limb>();
		}
		
		public function clear():void {
			joints = new Vector.<b2Joint>();
			limbs = new Vector.<Limb>();
		}
		
		public function wakeUp():void {
			for each ( var limb:Limb in limbs ) {
				limb.body.SetAwake( true );
				return;
			}
		}
	}
}
