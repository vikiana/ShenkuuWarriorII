/**
 *	This is the bubble or the ball in the game
 *
 *	@langversion ActionScript 3.0
 *	@playerversion Flash 9.0 
 *	@author Abraham Lee
 *	@since  nov.2009
 */

package com.neopets.games.inhouse.FaerieBubblesAS3.game
{
	//----------------------------------------
	//	IMPORTS 
	//----------------------------------------
	import flash.display.MovieClip;
	
	//----------------------------------------
	//	CUSTOM IMPORTS 
	//----------------------------------------

	
	
	public class Ball
	{
		//----------------------------------------
		//	CONSTANTS
		//----------------------------------------
		
		//----------------------------------------
		//	VARIABLES
		//----------------------------------------
		public  var xPos:Number 		= 0;
		public var yPos:Number 		= 0;
		public var xVelocity:Number 	= 0;
		public var yVelocity:Number 	= 0
		public var ballWidth:Number  	= 32;
		public var ballRadius:Number 	= ballWidth/2;
		public var ballType:Number		= 0;
		public var ballMC:MovieClip	= undefined;
		public var moving:Boolean		= false;
		//----------------------------------------
		//	CONSTRUCTOR 
		//----------------------------------------
		public function Ball():void
		{
			
		}
		
		//----------------------------------------
		//	GETTERS AND SETTORS
		//----------------------------------------
		
		//----------------------------------------
		//	PUBLIC METHODS
		//----------------------------------------
		/**
		*	initial set up for the ball
		**/	
		public function init(ballclip:MovieClip, type:Number):void
		{
			ballMC    = ballclip;
			ballType  = type;
			yPos      = ballMC.y;
			xPos      = ballMC.x;
			moving    = false;
			yVelocity = 0.0;
			xVelocity = 0.0;
		}
		
		/**
		*	show the correct visual movieclip for the ball
		**/	
		public function goto(f:Number):void
		{
			ballMC.gotoAndStop(f)
		}
		
		
		/**
		*	start the bubble's movieclip animation
		**/	
		public function startAnimation():void
		{
			try 
			{
				ballMC.bubble.ani.gotoAndPlay(2);
				if (ballMC.bubble.hasOwnProperty("ani2"))
				{
					ballMC.bubble.ani2.gotoAndPlay(2);
				}
			}
			catch(e:TypeError) 
			{
				trace (e)
			}

		}
		
		/**
		*	stop the bubble's movieclip animation
		**/	
		public function stopAnimations():void
		{
			
			try 
			{
				ballMC.bubble.ani.gotoAndStop(1);
				if (ballMC.bubble.hasOwnProperty("ani2"))
				{
					ballMC.bubble.ani2.gotoAndStop(1);
				}
			}
			catch(e:TypeError)
			{
				trace (e);
			}
		}
		
		/**
		*	drop the ball
		*	@PARAM		dropYStart		Number		base speed the ball should drop at
		*	@PARAM		dropMultiplier	Number		factor that'll be multiplied to make it fall faster
		*	@PARAM		nweDepth		Number		visual deapth but not used in AS3
		**/	
		public function prepareDrop(dropYStart:Number, dropMultiplier:Number, newDepth):void
		{
			moving    = true;		
			if ( dropYStart == 0 )
			{
				yVelocity = (5+Math.random() * 15) / 10;
			}
			else yVelocity = dropYStart;
			
			yVelocity *= dropMultiplier;
			setPos(); // drops faster
		}
		
		/**
		*	launch tha ball with set x and y velocity
		**/	
		public function shoot():void
		{
			setPos();
			yPos += (yVelocity*1);
			xPos += (xVelocity*1);
			updatePos();
			
			moving = true;
			ballMC.visible = true;
		}
		

		/**
		*	update the ball's movie clip position according to ball's x, y position
		**/	
		public function updatePos():void
		{
			// sop anis when dropping - make it faster
			if (yVelocity > 0 ) 
			{

				stopAnimations();
			}
			ballMC.y = yPos;
			ballMC.x = xPos;
		}
		
		/**
		*	whild on the move, it moves the the ball to a set position
		**/	
		public function setPos():void
		{
			yPos = ballMC.y + yVelocity;
			xPos = ballMC.x + xVelocity;
		}
		
		/**
		*	this drops the ball
		**/	
		public function setDropPos():void
		{
			yVelocity *= 1.4;
			yPos = ballMC.y + yVelocity;
		}
		
		/**
		*	once ball comes in contact with bubbles, set it's final positoin
		*	@PARAM		aEndPos		Array		contains final x,y poistion of the ball
		**/	
		public function setEndPos(aEndPos:Array):void
		{
			yPos      = aEndPos[1];
			xPos      = aEndPos[0];
			ballMC.y  = yPos;
			ballMC.x  = xPos;
			
			moving    = false;
			yVelocity = 0.0;
			xVelocity = 0.0;
		}
		
		/**
		*	move the ball to the designated position
		*	@PARAM		px		Number		x position
		*	@PARAM		py 		Number		y position
		**/	
		public function dropRow (px:Number, py:Number):void
		{
			yPos = ballMC.y = py;
			xPos = ballMC.x = px;
		}
		
		
		public function hide():void
		{
			ballMC.y = -1000;
			ballMC.x + -1000;
		}
		
		
		/**
		*	return true if the ball is touching the bottom of the play area (thus game over)
		**/	
		public function bottomDetection (border:Number):Boolean
		{
			var collision:Boolean = false;
			if ( (yPos + ballRadius) >= border ) 
			{
				collision = true;
				yPos = border - ballRadius;
			}
			return ( collision );
		}
		
		//----------------------------------------
		//	PROTECTED METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	PRIVATE METHODS
		//----------------------------------------
		
		//----------------------------------------
		//	EVENT LISTENERS
		//----------------------------------------
	}
	
}

