package util {
	/**
	 * Convert number from Box2d to Flixel.
	**/
	public function b2f( number:Number ):Number {
		return number / Main.RATIO;
	}
}