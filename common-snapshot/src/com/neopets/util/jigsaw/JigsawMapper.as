/* AS3
	Copyright 2010
*/

package com.neopets.util.jigsaw {
	
	/**
	 *	Takes an image, splits it up into jigsaw pieces and return those pieces to the main Jigsaw object for usage. Handles all jigsaw pieces
	 * 
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 * 
	 *	@Koh Peng Chuan
	 *	@since 25 Feb 2010
	*/	
	
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	
		/**
		 * @Note: Method description
		 * @param		var name			var type 		var description
		 * @return		var type				var description
		*/ 		
	 
	 internal class JigsawMapper {
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
				
		//--------------------------------------
		//  PRIVATE VARIABLES
		//--------------------------------------
		
		private var JIGSAW:Jigsaw;		// pointer to the Jigsaw object
		
		private var _image:Sprite;		// the image to be "jigsaw-ed"
		private var _pattern:Sprite;		// the jigsaw pattern to be used. This is simply a Sprite object containing many movieclips forming the jigsaw pieces.
		private var _bmd:BitmapData;	//	bitmapdata of the _image
		
		private var _jrows:int;				// number of rows of the jigsaw 
		private var _jcols:int;				// number of columns of the jigsaw
		
		private var _jwidth:int;				// width of the jigsaw; determined by _image
		private var _jheight:int;			// height of the jigsaw determeined by _image
		private var _oheight:Number;	// original height of the jigsaw pattern
		private var _owidth:Number;		// original width of the jigsaw pattern
		private var _jratiox:Number;		// ratio between _jwidth and _owidth
		private var _jratioy:Number;		// ratio between _jheight and _oheight
		
		private var _masks:Array;		// holds all references to masks (for creating shaped jigsaw pieces)
		private var _jigsaw:Array;			// holds all references to each jigsaw piece
		
		private var _pickedup:JigsawPiece;

		//--------------------------------------
		//  PUBLIC VARIABLES
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		/**
		 *	@Constructor
		 */
		public function JigsawMapper(p_jigsaw:Jigsaw):void {
			JIGSAW = p_jigsaw;
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 * @Note: Sets the parameters of the jigsaw
		 * @param		p_image		Sprite 		The image to be used for the jigsaw (should be a Sprite object with reference point on the top left corner)
		 * @param		p_cols			int		 		Number of cols for the jigsaw
		 * @param		p_rows			int		 		Number of rows for the jigsaw
		*/ 		
		public function setResource(p_image:Sprite, p_cols:int = 5, p_rows:int = 5):void {
			//_pattern = p_pattern;
			_jrows = p_rows;
			_jcols = p_cols;
			_pattern = generatePattern(_jcols, _jrows);
			_image = p_image;
			
			_jwidth = _image.width;
			_jheight = _image.height;
			_owidth = _pattern.width;
			_oheight = _pattern.height;
			_jratiox = _jwidth / _owidth;
			_jratioy = _jheight / _oheight;
			
			_bmd = new BitmapData(_jwidth, _jheight);
			_bmd.draw(_image);

			catalogAllPieces();
		}
		
		/**
		 * @Note: Picks up a piece of jigsaw. Finds all other pieces it is snapped to, and pick them up as well; Called from JigsawPiece.pickMeUp();
		 * @param		p_piece		JigsawPiece 		The piece of jigsaw being picked up
		*/ 		
		public function pickUpJigsaw(p_piece:JigsawPiece):void {
			// find the head
			var head:JigsawPiece = p_piece, node:JigsawPiece;
			while (head.prevlink) head = head.prevlink;
			// swap picked up piece with the head, so it becomes the new head
			if (head != p_piece) {
				// take p_piece out of the list
				if (p_piece.prevlink) p_piece.prevlink.nextlink = p_piece.nextlink;
				if (p_piece.nextlink) p_piece.nextlink.prevlink = p_piece.prevlink;
				
				// put p_piece in front of the head
				head.prevlink = p_piece;
				p_piece.nextlink = head;
				p_piece.prevlink = null;
				head = p_piece;
			}
			// traverse
			node = head;
			while (node) {
				node.floatMe();
				node = node.nextlink;
			}
			_pickedup = head;
		}

		/**
		 * @Note: Informs all jigsaw pieces that the mouse is up, and they should be put down
		 */ 		
		public function putJigsawDown(p_piece:JigsawPiece = null):void {
			var node:JigsawPiece = _pickedup;
			if (!node) return;
			while (node) {
				node.putMeDown();
				node = node.nextlink;
			}
			if (_pickedup) {
				JIGSAW.releaseJigsawPiece();
				//PCGameEngine.instance.playSound("Putdown");
			}
			if (allJigsawLinked()) JIGSAW.jigsawIsComplete();
			
			// check to see if this is a forced drop
			if (p_piece) {
				node = p_piece;
				while (node.prevlink) node = node.prevlink;
				if (node == _pickedup) {
					reposition();
				}
			}
			_pickedup = null;
		}
		
		/**
		 * @Note: Checks if the proper neighbours of dropped jigsaw piece is near, if near, snap them together
		 * @param		p_piece		JigsawPiece 		The piece to check for neighbours
		*/ 		
		public function checkNeighbourIsNear(p_piece:JigsawPiece):void {
			// check valid neighbour ids
			var narray:Array = [true, true, true, true]; // array to determine which side to check [up, down, left, right]
			var mod:int = p_piece.id % _jcols;
			// check horizontal
			if (mod == 0) { // on the left
				narray[2] = false; // don't check left
			} else if ((mod ==  (_jcols - 1))) { // on the right
				narray[3] = false; // don't check right
			}
			// check vertical
			if (p_piece.id < _jcols) { // at top row
				narray[0] = false; // don't check up
			} else if (p_piece.id >= _jigsaw.length - _jcols) { // at bottom row
				narray[1] = false; // don't check down
			}
			// actual checking
			var nid:int, node:JigsawPiece, tail:JigsawPiece, head:JigsawPiece;
			for (var n:int = 0; n < narray.length; n ++) {
				if (narray[n]) { // if marked for check
					switch (n) {
						case 0: // up
									nid = p_piece.id - _jcols;
									break;
						case 1: // down
									nid = p_piece.id + _jcols;
									break;
						case 2: // left
									nid = p_piece.id - 1;
									break;
						case 3: // right
									nid = p_piece.id + 1;
									break;
					}
					if (notLinked(_jigsaw[nid]) && inRange(_jigsaw[nid].x, _jigsaw[nid].y, p_piece.x, p_piece.y)) {
						// add to the tail
						node = _pickedup;
						while (node) {
							node.snapTo(_jigsaw[nid].x, _jigsaw[nid].y);
							if (!node.nextlink) tail = node;
							node = node.nextlink;
						} // tail points to the last item on the pickedup grp
						head = _jigsaw[nid];
						while (head.prevlink) head = head.prevlink; // head is at the start of the grp being snapped to
						// link the two groups now
						tail.nextlink = head;
						head.prevlink = tail;
						JIGSAW.jigsawIsCombined();
						//trace(tail.id + " snaps to " + head.id);
						return;
					}
				}
			}
			
		}
		
		/**
		 * @Note: Runs all jigsaw pieces' enterframe functions
		 */ 		
		public function run():void {
			for (var j:int = 0; j < _jigsaw.length; j ++) {
				_jigsaw[j]._func();
			}
		}
		
		/**
		 * @Note: Signals all pieces to fadeout
		 */ 		
		public function fadeOut():void {
			for (var j:int = 0; j < _jigsaw.length; j ++) {
				_jigsaw[j].disabled(true);
			}
		}
		
		/**
		 * @Note: Signals all pieces to get disabled; Player has failed to complete the puzzle
		 */ 		
		public function fail():void {
			for (var j:int = 0; j < _jigsaw.length; j ++) {
				_jigsaw[j].disabled(false);
			}
		}
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------

		//--------------------------------------
		//  PRIVATE & PROTECTED INSTANCE METHODS
		//--------------------------------------		
		
		/**
		 * @Note: Creates a jigsaw pattern for use.
		 * @Param		p_cols		int			Number of columns to create
		 * @Param		p_rows		int			Number of rows to create
		 * @Return						Sprite	The sprite object containing jigsaw pieces
		 */ 		
		private function generatePattern(p_cols:int, p_rows:int):Sprite {
			var res:Sprite = new Sprite();
			for (var r:int = 0; r < p_rows; r ++) {
				for (var c:int = 0; c < p_cols; c ++) {
					var jig:Jig = new Jig();
					res.addChild(jig);
					for (var j:int = 0; j < 4; j ++) {
						jig.JIGS[j].x = (c * 100) + 50;
						jig.JIGS[j].y = (r * 100) + 50;
					}
					jig.x = 0;
					jig.y = 0;
				}
			}
			return res;
		}
		
		/**
		 * @Note: Detects all jigsaw pieces and arrange them
		 */ 		
		private function catalogAllPieces():void {
			var jigsawpc:Jig, cx:Number, cy:Number, rect:Rectangle, id:int;
			_masks = [];
			_jigsaw = [];
			for (var n:int = 0; n < _pattern.numChildren; n ++) {
				_masks[n] = null;
				_jigsaw[n] = new JigsawPiece();
				_jigsaw[n].mapper = this;
				_jigsaw[n].JIGSAW = JIGSAW;
			}
			for (var i:int = 0; i < _jigsaw.length; i ++) {
				jigsawpc = _pattern.getChildAt(i) as Jig;
				rect = jigsawpc.getRect(_pattern);
				cx = (rect.width / 2) + rect.x;
				cy = (rect.height / 2) + rect.y;
				id = deriveID(cx, cy);
				_jigsaw[id].id = id;
				_masks[id] = jigsawpc;
				_masks[id].scaleX *= _jratiox;
				_masks[id].scaleY *= _jratioy;
			}
			var bmd:BitmapData;
			for (var j:int = 0; j < _jigsaw.length; j ++) {
				setJigSides(_masks[j], j);
				_jigsaw[j].setMaskAs(_masks[j]);
				_jigsaw[j].setBitmapAs(_bmd);
				rect = _masks[j].getRect(_jigsaw[j]);
				bmd = new BitmapData(Math.ceil(rect.width), Math.ceil(rect.height));
				bmd.copyPixels(_bmd, rect, new Point(0, 0));
				_jigsaw[j].setBitmapAs(bmd, rect);
				//_jigsaw[j].setBitmapAs(_bmd);
				JIGSAW._bottomlayer.addChild(_jigsaw[j]);
			}
			_bmd.dispose();
			_bmd = null;
			shuffleAllPieces();
		}
		
		/**
		 * @Note: Calculates an unique ID for each jigsaw piece based on their positions; Each jigsaw piece is assumed to be approx 100 x 100
		 * @param		p_cx			Number 		An approx x coordinate of the piece's center
		 * @param		p_cy			Number 		An approx y coordinate of the piece's center
		 * @return		int				The calculated unique ID
		 */
		private function deriveID(p_cx:Number, p_cy:Number):int {
			return Math.floor(p_cx / 100) + ((Math.floor(p_cy / 100) * _jcols));
		}
		
		/**
		 * @Note: Sets the sides of a particular Jig
		 * @param		p_jig			Jig 		The Jig to set
		 * @param		p_id			int 		The id of this Jig
		 */
		private function setJigSides(p_jig:Jig, p_id:int):void {
			//trace("\nsetting " + p_id);
			var njig:Jig, opp:int;
			for (var s:int = 0; s < 4; s ++) {
				//trace("trying side " + s);
				njig = getNeighbourJig(p_id, s);
				if (njig) {
					switch (s) {
						case Jig.FACE_UP: opp = Jig.FACE_DOWN; break;
						case Jig.FACE_DOWN: opp = Jig.FACE_UP; break;
						case Jig.FACE_LEFT: opp = Jig.FACE_RIGHT; break;
						case Jig.FACE_RIGHT: opp = Jig.FACE_LEFT; break;
					}
					if (njig.getSide(opp) > 1) {
						_masks[p_id].setSide(s, njig.getMate(njig.getSide(opp)));
					} else {
						_masks[p_id].setSideRand(s);
					}
				} else {
					//trace(p_id + " no neighbour at side " + s);
					_masks[p_id].setSide(s, 1);
				}
			}
		}
		
		/**
		 * @Note: Gets the jig at a particular direction of a target jig
		 * @param		p_id			int 		The id of the jig to check
		 * @param		p_side		int 		Find the neighbour on this side
		 * @return						Jig			The found Jig. Null if none (out of edges)
		 */
		private function getNeighbourJig(p_id:int, p_side:int):Jig {
			switch (p_side) {
				case Jig.FACE_UP:
										if ((p_id - _jcols) >= 0) return _masks[p_id - _jcols];
										break;
				case Jig.FACE_DOWN:
										if ((p_id + _jcols) < _masks.length) return _masks[p_id + _jcols];
										break;
				case Jig.FACE_LEFT:
										
										if ((p_id - 1) >= 0) {
											if (((p_id - 1) % _jcols) < (p_id % _jcols)) return _masks[p_id - 1];
										}
										break;
				case Jig.FACE_RIGHT:
										if ((p_id + 1) < _masks.length) {
											if (((p_id + 1) % _jcols) > (p_id % _jcols)) return _masks[p_id + 1];
										}
										break;
			}
			return null;
		}

		/**
		 * @Note: Shuffles the jigsaw pieces
		 */ 		
		private function shuffleAllPieces():void {
			var rect:Rectangle, cx:int, cy:int, sx:int, sy:int;
			for (var i:int = 0; i < _jigsaw.length; i ++) {
				rect = _masks[i].getRect(_pattern);
				cx = int((rect.width / 2) + int(rect.x));
				cy = int((rect.height / 2) + int(rect.y));
				sx = JIGSAW._topleft_x + 50 + int(Math.random() * (JIGSAW._scattered_width - 100));
				sy = JIGSAW._topleft_y + 50 + int(Math.random() * (JIGSAW._scattered_height - 100));
				_jigsaw[i].x = _jigsaw[i].x - cx + sx;
				_jigsaw[i].y = _jigsaw[i].y - cy + sy;
				
				// calculate the approximate offset values to find the centers of each jigsaw piece (use x,y coordinates, and add these cx, cy values to find the theoretical center)
				_jigsaw[i].cx = int((50 + (i % _jcols) * 100) * _masks[i].scaleX);
				_jigsaw[i].cy = int((50 + Math.floor(i / _jcols) * 100) * _masks[i].scaleY);
			}
		}
		
		/**
		 * @Note: Checks if 2 pieces of jigsaw are near enough to each other to snap
		 * @param		p_x1		int 	X coordinate of the first jigsaw piece
		 * @param		p_y1		int 	Y coordinate of the first jigsaw piece
		 * @param		p_x2		int 	X coordinate of the second jigsaw piece
		 * @param		p_y2		int 	Y coordinate of the second jigsaw piece
		 * @return		Boolean			True if both pieces are within range and able to snap.
		*/
		private function inRange(p_x1:int, p_y1:int, p_x2:int, p_y2:int):Boolean {
			if (Math.abs(p_x1 - p_x2) < 10) {
				if (Math.abs(p_y1 - p_y2) < 10) {
					return true;
				}
			}
			return false;
		}
		
		/**
		 * @Note: Checks if a piece is linked to the group of jigsaws picked up right now
		 * @param		p_piece		JigsawPiece 	The piece to check
		 * @return		Boolean							True if both pieces are not linked.
		*/
		private function notLinked(p_piece:JigsawPiece):Boolean {
			var node:JigsawPiece = _pickedup;
			while (node) {
				if (node == p_piece) return false;
				node = node.nextlink;
			}
			return true;
		}
		
		/**
		 * @Note: Checks if all jigsaw is linked thus completing the puzzle
		 * @return		Boolean			True if all pieces are combined
		*/
		private function allJigsawLinked():Boolean {
			var node:JigsawPiece = _pickedup, count:int = 0;
			while (node) {
				count ++;
				node = node.nextlink;
			}
			return Boolean(count == _jigsaw.length);
		}
		
		/**
		 * @Note: Repositions the jigsaw piece  to prevent it being dragged out of stage
		*/
		private function reposition():void {
			var node:JigsawPiece = _pickedup, correctionx:int = 0, correctiony:int = 0;

			if (_pickedup.parent.mouseX <= JIGSAW.left_bound) {
				correctionx = (_pickedup.width / 2) - _pickedup.vx;
			} else if (_pickedup.parent.mouseX >= JIGSAW.right_bound) {
				correctionx = (JIGSAW.right_bound - (_pickedup.width / 2)) - _pickedup.vx;
			}
			if (_pickedup.parent.mouseY <= JIGSAW.up_bound) {
				correctiony = (_pickedup.height / 2) - _pickedup.vy;
			} else if (_pickedup.parent.mouseY >= JIGSAW.down_bound) {
				correctiony = (JIGSAW.down_bound - (_pickedup.height / 2)) - _pickedup.vy;
			}
			// proceed with correction
			while (node) {
				node.vx += correctionx;
				node.vy += correctiony;
				node = node.nextlink;
			}
			_pickedup = null;
		}
		
		/**
		 *	@Destructor
		 */
		public function destructor():void {
			JIGSAW = null;
			if (_bmd) {
				_bmd.dispose();
				_bmd = null;
			}
			for (var i:int = 0; i < _jigsaw.length; i ++) {
				_jigsaw[i].destructor();
			}
			_jigsaw = null;
			_masks.length = 0;
			_masks = null;			
		}
	}
}