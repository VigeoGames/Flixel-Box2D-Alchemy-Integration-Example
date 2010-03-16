package util {
	/**
	 * Convert number from Flixel to Box2d.
	**/
	public function f2b( number:Number ):Number {
		return number * Main.RATIO;
	}
}