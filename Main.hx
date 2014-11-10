
import flash.display.BitmapData;
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.Event;
import flash.Lib;
import openfl.Assets;

class Main extends Sprite {

	private var COLORS = [
		0xFFFFFF,
		0x555555,
		0xAAAAAA,
		0x000000
	];

	private var SIZE = (haxe.Json.parse (Assets.getText ("config.json"))).size;
	private var cells : Array <Array <Int>>;
	private var bitmapData : BitmapData;

	public function new () {
		super ();

		bitmapData = new BitmapData (SIZE, SIZE);
		var background = new Bitmap (bitmapData);
		addChild (background);

		generate ();

		addEventListener (Event.ENTER_FRAME, update);
	}

	private function update (e) {
		show ();
		next ();
	}

	// Generate random cells
	private function generate () {
		cells = new Array <Array <Int>> ();

		for (i in 0...SIZE) {
			cells [i] = new Array <Int> ();

			// Attribute random value to the cell
			for (j in 0...SIZE) {
				cells [i][j] = Std.random(4);
			}
		}
	}

	// Next wave
	private function next () {
		var temp = new Array <Array <Int>> ();

		for (i in 0...SIZE) {
			temp [i] = new Array <Int> ();

			for (j in 0...SIZE) {
				temp [i][j] = getNextValue (j, i);
			}
		}

		// Assign new wave
		cells = temp;
	}

	// Return correct next value
	private function getNextValue (x, y) : Int {
		var current = cells [y][x];
		var next = (current + 1) % 4;
		var number = getHowManyNeighbour (x, y, next);

		if (number >= 3) {
			return next;
		}
		return current;
	}

	private function getHowManyNeighbour (x, y, next) : Int {
		var minx = (x == 0) ? 0 : x - 1;
		var miny = (y == 0) ? 0 : y - 1;

		var maxx = ((x + 1) == SIZE) ? x : x + 1;
		var maxy = ((y + 1) == SIZE) ? y : y + 1;
		++maxx;
		++maxy;

		var number = 0;

		for (i in miny...maxy) {
			for (j in minx...maxx) {
				if (cells [i][j] == next) {
					++number;
				}
			}
		}

		return number;
	}

	// Draw wave
	private function show () {
		for (i in 0...SIZE) {
			for (j in 0...SIZE) {
				draw (j, i, cells [i][j]);
			}
		}
	}

	// Draw a pixel
	private function draw (x, y, value) {
		bitmapData.setPixel (x, y, COLORS [value]);
	}

}
