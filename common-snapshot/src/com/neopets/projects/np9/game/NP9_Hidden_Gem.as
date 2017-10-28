// ---------------------------------------------------------------------------------------
// Hidden Gem Class
//
// Author: Ollie B.
// Last Update: 03/28/08
//
// ---------------------------------------------------------------------------------------
package com.neopets.projects.np9.game
{
	// SYSTEM IMPORTS

	// CUSTOM IMPORTS
	import com.neopets.projects.np9.system.NP9_Tracer;
	
	// -----------------------------------------------------------------------------------
	public class NP9_Hidden_Gem {

		private var _objTracer:NP9_Tracer;
		
		private var _aGems:Array;
		private var _aInvalidKeys:Array;
		private var	_sInput:String;

		// -------------------------------------------------------------------------------
		// CONSTRUCTOR
		// -------------------------------------------------------------------------------
		public function NP9_Hidden_Gem( p_bTrace:Boolean ) {
			
			// tracer object
			_objTracer = new NP9_Tracer( this, p_bTrace );
			_objTracer.out( "Instance created!\n", true );
			
			_aGems = new Array();
			
			_aInvalidKeys = new Array(37,39,38,32,40,16,17,19,20,45,91,144,145);
			
			_sInput = "";
		}
		
		// -------------------------------------------------------------------------------
		// RESET ALL GEMS
		// -------------------------------------------------------------------------------
		public function resetAll():void {
			
			for ( var i:int=0; i<_aGems.length; i++) {
				_aGems[i].bActive = true;
				_aGems[i].iUsed   = _aGems[i].iCount;
			}
			
			_sInput = "";
			
			_objTracer.out( "All hidden gems have been reset!", false );
		}
		
		// -------------------------------------------------------------------------------
		// ADD A NEW GEM TO THE GEM-LIST
		// -------------------------------------------------------------------------------
		public function addGem( p_asGem:Array, p_iUsageCount ):void {
			
			var sDec:String = "";
			
			for ( var j:int=0; j<p_asGem.length; j++) {
				if (j==0) {
					sDec += String.fromCharCode(int(Number(p_asGem[p_asGem.length-1]-(p_asGem.length-1-j))));
				} else {
					sDec += String.fromCharCode(int(Number(p_asGem[j-1]-(j-1))));
				}
			}
			
			// create the gem object
			var objG:Object = new Object();
			objG.sGem    = new String(sDec);
			objG.bActive = new Boolean(true);
			objG.iCount  = new int(p_iUsageCount);
			objG.iUsed   = new int(p_iUsageCount);
			
			// finally add gem object to gem list
			_aGems.push( objG );
			
			_objTracer.out( "'"+objG.sGem+"' has been added to Hidden Gems list!", false );
		}
		
		// -------------------------------------------------------------------------------
		// CHECK KEYBOARD INPUT
		// -------------------------------------------------------------------------------
		public function logKey( p_keyCode:Number, p_keyAscii:Number ):int {
			
			var iResult:int = -1;
			
			// check for invalid keys first
			for ( var i:int=0; i<_aInvalidKeys.length; i++ ) {
				if ( p_keyCode == _aInvalidKeys[i] ) return ( -1 );
			}

			// add key to input string
			_sInput += String.fromCharCode( p_keyAscii );
			var iLen:int = _sInput.length;
			
			// do we have a winner?
			for ( i=0; i<_aGems.length; i++ ) {
				
				if ( _sInput == _aGems[i].sGem ) {
					
					if ( _aGems[i].bActive ) {
						_aGems[i].iUsed--;
						if ( _aGems[i].iUsed <= 0 ) _aGems[i].bActive = false;
						iResult = i;
						break;
					}
				}
			}
			
			// no match yet - does input string partly match a gem?
			if ( iResult == -1 ) {
				
				var bMatch:Boolean = false;
				for ( i=0; i<_aGems.length; i++ ) {
					if ( _sInput.substr(0,iLen) == _aGems[i].sGem.substr(0,iLen) ) {
						bMatch = true;
					}
				}
				
				// no partly match either
				if ( !bMatch ) {
					_sInput = String.fromCharCode( p_keyAscii );
				}
			}
			
			return ( iResult );
		}
		
		// -------------------------------------------------------------------------------
		// ENCRYPT GEM
		// -------------------------------------------------------------------------------
		public function encrypt( p_sGem:String ):String {
			
			var sEncGem:String = "";
			
			var aA:Array   = new Array();
			var aS:Array   = new Array();
			var val:int    = 0;
			var len:int    = p_sGem.length - 1;
			var str:String = "";
			
			for ( var j:int=0; j<=len; j++ ) {
				
				val = j;
				if ( (j==len) ) val += p_sGem.charCodeAt(0);
				else val += p_sGem.charCodeAt(j+1);
				aS.push( "\""+String(val)+"."+String(getRandom(1,255))+"\"" );
				aA.push( String(val)+"."+String(getRandom(1,255)) );
			}
			
			// encrypted
			_objTracer.out( "Encrypted word: ["+aS+"]", false );
			
			// decrypted
			len = aA.length-1;
			for ( j=0; j<=len; j++ ) {
				
				if ( (j==0) ) str += String.fromCharCode( int(Number(aA[len]-(len-j))) );
				else str += String.fromCharCode( int(Number(aA[j-1]-(j-1))) );
			}
			
			_objTracer.out( "Decrypted word: "+str, false );
			
			return ( sEncGem );
		}
		
		// -------------------------------------------------------------------------------
		// GET RANDOM NUMBER
		// -------------------------------------------------------------------------------
		private function getRandom( minVal:int, maxVal:int):int {
			
			return ( Math.round(minVal + Math.random() * (maxVal - minVal) ) );
		}
		
		// -------------------------------------------------------------------------------
		//
		// -------------------------------------------------------------------------------
	}
}
