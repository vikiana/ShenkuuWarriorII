﻿package com.neopets.projects.np9.system
{
	/**
	 * Score encryption class for the NP9_GamingSystem
	 * @author Ollie B.
	 * @since 03/28/08
	 */
	public class NP9_Score_Encryption {

		private var aDecimals:Array;
		private var aHex:Array;
		private var iHexLen:Number;
		private var sBin:String;
		private var iBinLen:Number;
		
		/**
		 * @Constructor
		 */
		public function NP9_Score_Encryption() 
		{

			/* Original Encryption
			var aEncChars:Array;
			aEncChars = [ "*KS5fJ(+,=FO$V^elCjpLbE_@Q;~-9G}8ziBUg1c)mHkyPWd0AxnX72IMqY4owN?v!t.6uD{sh%a&TR:Zr3",
						  "N;zqeE2Ps70lV8jD-!5ZgxB6Kfv@Wc=y)XdQbLM*CIwko?t&Rr.%_TJFO^i4{UAn+a~1,ShGH$}3(u9:pYm",
						  "2IMHqbD=GX+i&5*Q4oVy.JYs;pT:f)uxL{gkU9vCnmcr7BZ@FWNd_}wK,3ShAeEOzaP!%6l80j-R(~?1t^$",
						  "ma63v+Qh9qJ5dS*fgt0RuH$sGw);W_z4l-bIVBoN~PE{(Fx&y@:8%pnTk2Ze}!Y17cCKrUijO=^AM?,.XDL",
						  "CwB%_Pi@,?(1mkgx7nqa*cpUDjs2;GlLZKe^z+4=Itdv}XH6bNSVr0Q5WM$:ho{FOfJYu)ETR~y938!.-A&",
						  "wg0a%ZPSJ;U_$e1-mvp:qcxRln~KTXE4(?usOH@k={jW*5YBo3N26CQt&97IGbD.AfzMydr^,VhL)Fi+8!}",
						  "%jOuNck,em(QVzH-nDr8!bG?ofhKYd}As25BR$J&wTp~iF0U*9^;Lv+.PW:_IlXg{Za)q@CE6S=t4137Mxy",
						  "5grI;v:Z0@Jnfo.?l{~zHS$d%pYqF2)&Ue7s!(jT}Lu*1MQ+A,V8CymDP^9a_wxhiGWKRXcOtE46Bk=bN3-",
						  "E!H@.wLp;XNWaOY(~z=6_B^P}ju0$J{3Gg8yk,&nAoVTI5c+UMDdx)SQ:2*CRe4tK1r%?s7hb9fZqi-lmFv",
						  "Dg+qPTL,?-GH;{jK8Vi)~x%o6af2:^uCIBJNwscAUZ(YkreM@9vER1nX$zb_yOmQ3&4lWFdS50!=h*p.7t}",
						  ".eHl6:mkpx=QKV+~UM3C)ZoEYi&5F}^;I_1LRnAgJ?0h8q{D9,$WPzjO%fBXu(cv!aG7wdb@yt42S-rNT*s",
						  "9{n%A&*3aELb,cqRBwZS1pUJ(~ojzIH$T.d=084K_YDg^it:Nu!sxmQhr-CWl6}+OkMfy;VG72e?5v)P@XF",
						  "(+{}am~80qkyIfv^!jY2.XC?pK@3r_hD:dJHFouW%N7Gi6Q;V),91EtPbnwRLez*UO-Mg=SlAxZs5B4T$&c",
						  "CFH@KIY_0M%sW5JxnSTye!tPhb-Zw;}*&:~D^kV{lv.X3$umaAp6UR+fiOQc2q=(dL9?8B74EG,oz1)jNrg",
						  "3(SWi^OE.re?yg%AksLX5wm94GT})q62=b;7v-8*{Uj&dN$t,RBaKVz~!0CcZ1H@lMfPp_uxJYQ:FnhI+Do",
						  "cWr@MNsSo0HKIyp8i^L$*AU-tJ=6gTYC9+PVquxw_Q7E}!km):FZj4vaf3O%e5h(Rz~XnGBbld1?,.D2;{&",
						  "wgOerQ45273j%oDu0I*:MATVGXhSi^sJ1pCLv_$&B.8d~!(mR{EUz,;c=-?kP)fYtqn9WbyFa6l@x+HN}KZ",
						  "vQEGgAZ+@^o4=BtS6;f.d($Dr0OmTPNUzVeY_)pj~JMcH%2!&kIl3,n8W9:7*X1s}Kah{5-Fqu?bLxRCwiy",
						  ",W%94xR$}sFi;V^o.uc*TD&fmy07zN)pke-:BJMt3wI~8@EQLj=nU!5v_r{ZA(6qla2hHbgXO+C?Yd1KSPG",
						  "1jI8F;w-s&@QVarBfybCNJh6Pn4R%^DuTx?9iH=2U3G7.YO)e,$EWLZ{}tp(lSck50A:v+oz~g!_dXMqK*m"];
			
			for ( var i=0; i<aEncChars.length; i++ ) { var s = "["; for ( var j=0; j<aEncChars[i].length; j++ ) { s += aEncChars[i].charCodeAt(j); if ( j < (aEncChars[i].length-1) ) s += ","; } s += "]"; trace(s); }
			
		
			// use ascii codes to make it a bit more confusing
			aDecimals = [];
			aDecimals.push( [42,75,83,53,102,74,40,43,44,61,70,79,36,86,94,101,108,67,106,112,76,98,69,95,64,81,59,126,45,57,71,125,56,122,105,66,85,103,49,99,41,109,72,107,121,80,87,100,48,65,120,110,88,55,50,73,77,113,89,52,111,119,78,63,118,33,116,46,54,117,68,123,115,104,37,97,38,84,82,58,90,114,51] );
			aDecimals.push( [78,59,122,113,101,69,50,80,115,55,48,108,86,56,106,68,45,33,53,90,103,120,66,54,75,102,118,64,87,99,61,121,41,88,100,81,98,76,77,42,67,73,119,107,111,63,116,38,82,114,46,37,95,84,74,70,79,94,105,52,123,85,65,110,43,97,126,49,44,83,104,71,72,36,125,51,40,117,57,58,112,89,109] );
			aDecimals.push( [50,73,77,72,113,98,68,61,71,88,43,105,38,53,42,81,52,111,86,121,46,74,89,115,59,112,84,58,102,41,117,120,76,123,103,107,85,57,118,67,110,109,99,114,55,66,90,64,70,87,78,100,95,125,119,75,44,51,83,104,65,101,69,79,122,97,80,33,37,54,108,56,48,106,45,82,40,126,63,49,116,94,36] );
			aDecimals.push( [109,97,54,51,118,43,81,104,57,113,74,53,100,83,42,102,103,116,48,82,117,72,36,115,71,119,41,59,87,95,122,52,108,45,98,73,86,66,111,78,126,80,69,123,40,70,120,38,121,64,58,56,37,112,110,84,107,50,90,101,125,33,89,49,55,99,67,75,114,85,105,106,79,61,94,65,77,63,44,46,88,68,76] );
			aDecimals.push( [67,119,66,37,95,80,105,64,44,63,40,49,109,107,103,120,55,110,113,97,42,99,112,85,68,106,115,50,59,71,108,76,90,75,101,94,122,43,52,61,73,116,100,118,125,88,72,54,98,78,83,86,114,48,81,53,87,77,36,58,104,111,123,70,79,102,74,89,117,41,69,84,82,126,121,57,51,56,33,46,45,65,38] );
			aDecimals.push( [119,103,48,97,37,90,80,83,74,59,85,95,36,101,49,45,109,118,112,58,113,99,120,82,108,110,126,75,84,88,69,52,40,63,117,115,79,72,64,107,61,123,106,87,42,53,89,66,111,51,78,50,54,67,81,116,38,57,55,73,71,98,68,46,65,102,122,77,121,100,114,94,44,86,104,76,41,70,105,43,56,33,125] );
			aDecimals.push( [37,106,79,117,78,99,107,44,101,109,40,81,86,122,72,45,110,68,114,56,33,98,71,63,111,102,104,75,89,100,125,65,115,50,53,66,82,36,74,38,119,84,112,126,105,70,48,85,42,57,94,59,76,118,43,46,80,87,58,95,73,108,88,103,123,90,97,41,113,64,67,69,54,83,61,116,52,49,51,55,77,120,121] );
			aDecimals.push( [53,103,114,73,59,118,58,90,48,64,74,110,102,111,46,63,108,123,126,122,72,83,36,100,37,112,89,113,70,50,41,38,85,101,55,115,33,40,106,84,125,76,117,42,49,77,81,43,65,44,86,56,67,121,109,68,80,94,57,97,95,119,120,104,105,71,87,75,82,88,99,79,116,69,52,54,66,107,61,98,78,51,45] );
			aDecimals.push( [69,33,72,64,46,119,76,112,59,88,78,87,97,79,89,40,126,122,61,54,95,66,94,80,125,106,117,48,36,74,123,51,71,103,56,121,107,44,38,110,65,111,86,84,73,53,99,43,85,77,68,100,120,41,83,81,58,50,42,67,82,101,52,116,75,49,114,37,63,115,55,104,98,57,102,90,113,105,45,108,109,70,118] );
			aDecimals.push( [68,103,43,113,80,84,76,44,63,45,71,72,59,123,106,75,56,86,105,41,126,120,37,111,54,97,102,50,58,94,117,67,73,66,74,78,119,115,99,65,85,90,40,89,107,114,101,77,64,57,118,69,82,49,110,88,36,122,98,95,121,79,109,81,51,38,52,108,87,70,100,83,53,48,33,61,104,42,112,46,55,116,125] );
			aDecimals.push( [46,101,72,108,54,58,109,107,112,120,61,81,75,86,43,126,85,77,51,67,41,90,111,69,89,105,38,53,70,125,94,59,73,95,49,76,82,110,65,103,74,63,48,104,56,113,123,68,57,44,36,87,80,122,106,79,37,102,66,88,117,40,99,118,33,97,71,55,119,100,98,64,121,116,52,50,83,45,114,78,84,42,115] );
			aDecimals.push( [57,123,110,37,65,38,42,51,97,69,76,98,44,99,113,82,66,119,90,83,49,112,85,74,40,126,111,106,122,73,72,36,84,46,100,61,48,56,52,75,95,89,68,103,94,105,116,58,78,117,33,115,120,109,81,104,114,45,67,87,108,54,125,43,79,107,77,102,121,59,86,71,55,50,101,63,53,118,41,80,64,88,70] );
			aDecimals.push( [40,43,123,125,97,109,126,56,48,113,107,121,73,102,118,94,33,106,89,50,46,88,67,63,112,75,64,51,114,95,104,68,58,100,74,72,70,111,117,87,37,78,55,71,105,54,81,59,86,41,44,57,49,69,116,80,98,110,119,82,76,101,122,42,85,79,45,77,103,61,83,108,65,120,90,115,53,66,52,84,36,38,99] );
			aDecimals.push( [67,70,72,64,75,73,89,95,48,77,37,115,87,53,74,120,110,83,84,121,101,33,116,80,104,98,45,90,119,59,125,42,38,58,126,68,94,107,86,123,108,118,46,88,51,36,117,109,97,65,112,54,85,82,43,102,105,79,81,99,50,113,61,40,100,76,57,63,56,66,55,52,69,71,44,111,122,49,41,106,78,114,103] );
			aDecimals.push( [51,40,83,87,105,94,79,69,46,114,101,63,121,103,37,65,107,115,76,88,53,119,109,57,52,71,84,125,41,113,54,50,61,98,59,55,118,45,56,42,123,85,106,38,100,78,36,116,44,82,66,97,75,86,122,126,33,48,67,99,90,49,72,64,108,77,102,80,112,95,117,120,74,89,81,58,70,110,104,73,43,68,111] );
			aDecimals.push( [99,87,114,64,77,78,115,83,111,48,72,75,73,121,112,56,105,94,76,36,42,65,85,45,116,74,61,54,103,84,89,67,57,43,80,86,113,117,120,119,95,81,55,69,125,33,107,109,41,58,70,90,106,52,118,97,102,51,79,37,101,53,104,40,82,122,126,88,110,71,66,98,108,100,49,63,44,46,68,50,59,123,38] );
			aDecimals.push( [119,103,79,101,114,81,52,53,50,55,51,106,37,111,68,117,48,73,42,58,77,65,84,86,71,88,104,83,105,94,115,74,49,112,67,76,118,95,36,38,66,46,56,100,126,33,40,109,82,123,69,85,122,44,59,99,61,45,63,107,80,41,102,89,116,113,110,57,87,98,121,70,97,54,108,64,120,43,72,78,125,75,90] );
			aDecimals.push( [118,81,69,71,103,65,90,43,64,94,111,52,61,66,116,83,54,59,102,46,100,40,36,68,114,48,79,109,84,80,78,85,122,86,101,89,95,41,112,106,126,74,77,99,72,37,50,33,38,107,73,108,51,44,110,56,87,57,58,55,42,88,49,115,125,75,97,104,123,53,45,70,113,117,63,98,76,120,82,67,119,105,121] );
			aDecimals.push( [44,87,37,57,52,120,82,36,125,115,70,105,59,86,94,111,46,117,99,42,84,68,38,102,109,121,48,55,122,78,41,112,107,101,45,58,66,74,77,116,51,119,73,126,56,64,69,81,76,106,61,110,85,33,53,118,95,114,123,90,65,40,54,113,108,97,50,104,72,98,103,88,79,43,67,63,89,100,49,75,83,80,71] );
			aDecimals.push( [49,106,73,56,70,59,119,45,115,38,64,81,86,97,114,66,102,121,98,67,78,74,104,54,80,110,52,82,37,94,68,117,84,120,63,57,105,72,61,50,85,51,71,55,46,89,79,41,101,44,36,69,87,76,90,123,125,116,112,40,108,83,99,107,53,48,65,58,118,43,111,122,126,103,33,95,100,88,77,113,75,42,109] );
			*/	
			
			// new encryption values, using ascii key codes
			aDecimals = [];
			aDecimals.push( [36,69,116,45,42,66,109,121,41,59,77,72,58,118,113,119,100,102,38,88,85,126,61,55,50,80,104,98,87,112,46,125,51,114,78,95,76,90,79,44,115,111,110,89,40,99,70,84,57,123,97,49,54,64,33,107,101,75,73,108,81,120,106,86,74,103,53,43,105,83,37,68,94,71,65,48,63,67,117,52,122,82,56] );
			aDecimals.push( [37,120,121,49,76,82,75,115,106,110,59,54,108,103,70,65,44,56,64,123,43,102,79,77,45,125,33,68,99,85,111,97,118,42,101,61,40,105,90,87,81,116,52,100,36,69,58,89,98,95,57,107,86,51,48,113,66,55,122,109,80,126,104,63,41,78,72,53,67,84,74,112,73,94,119,83,114,50,38,88,71,46,117] );
			aDecimals.push( [70,56,84,61,115,108,51,46,118,102,77,83,63,110,74,117,94,114,41,104,37,36,103,99,123,64,73,57,107,113,66,125,95,43,50,44,111,49,85,58,81,106,33,72,97,90,87,75,101,105,98,122,116,69,119,79,112,42,121,45,68,80,48,82,78,40,53,38,59,52,76,54,86,126,109,67,100,89,120,65,88,55,71] );
			aDecimals.push( [123,56,80,106,87,85,70,95,98,115,71,43,69,116,72,118,46,79,64,48,63,105,36,126,76,44,97,50,121,78,111,122,81,68,104,37,61,94,101,89,120,42,100,119,86,51,66,38,55,90,108,59,83,77,49,110,84,73,57,40,58,54,113,67,52,112,74,125,102,65,103,107,41,75,99,33,114,45,82,117,88,109,53] );
			aDecimals.push( [33,51,103,64,98,95,71,110,49,69,78,101,83,48,120,113,122,74,68,99,42,112,85,125,88,37,41,111,115,77,100,45,81,107,117,123,126,58,55,82,73,59,63,102,84,36,87,104,65,105,38,109,53,43,116,54,57,121,86,66,97,61,46,56,70,75,106,90,89,108,44,52,119,79,40,80,76,67,72,50,114,118,94] );
			aDecimals.push( [111,76,69,85,98,81,77,78,112,80,65,94,74,125,61,44,117,50,53,56,114,75,90,72,109,66,40,89,51,113,123,101,116,71,36,49,33,119,68,73,82,121,59,100,63,58,106,43,70,83,46,126,52,57,95,102,88,54,42,107,84,55,48,108,120,87,79,115,103,41,64,37,45,38,97,67,105,104,118,99,86,110,122] );
			aDecimals.push( [126,108,111,97,103,88,41,56,61,114,52,123,58,45,122,87,66,49,79,40,43,63,75,69,76,57,73,83,36,94,46,67,104,106,48,84,113,100,71,50,119,37,70,101,85,125,117,121,112,65,42,86,38,53,33,64,81,55,99,44,78,90,74,54,68,98,59,120,116,95,80,115,107,82,102,109,105,89,51,72,77,110,118] );
			aDecimals.push( [122,53,38,61,85,104,65,41,114,100,46,59,73,109,48,98,118,83,54,63,120,64,117,90,57,71,106,40,108,105,82,55,113,36,78,88,58,87,97,72,84,101,123,44,79,107,33,94,74,121,81,70,86,115,99,75,103,56,110,69,67,111,77,43,68,37,80,89,51,126,52,76,95,116,50,119,125,102,49,45,66,112,42] );
			aDecimals.push( [36,38,44,108,125,71,99,46,82,68,69,58,40,66,107,104,112,73,119,59,122,72,67,115,123,53,54,120,103,89,33,41,55,76,106,65,100,49,37,80,88,50,52,86,121,77,85,98,81,51,114,111,109,95,45,57,118,126,102,56,116,78,42,94,83,87,84,63,113,90,110,105,101,79,75,43,117,97,61,70,74,48,64] );
			aDecimals.push( [108,118,69,98,73,52,121,43,79,49,68,56,83,72,95,102,105,76,81,89,53,84,107,45,50,88,87,33,94,75,46,113,117,74,99,110,100,55,106,97,36,120,126,111,109,61,71,112,42,114,48,58,123,65,44,67,82,125,80,64,40,77,86,116,78,119,38,104,70,51,90,59,63,115,37,122,66,54,41,101,85,103,57] );
			aDecimals.push( [89,36,42,71,74,119,113,116,94,90,78,123,58,112,117,46,118,40,59,99,50,79,51,48,126,97,68,33,86,115,109,100,49,37,55,83,105,72,106,73,101,64,65,53,103,108,80,125,69,77,110,98,85,87,102,43,95,38,66,81,111,67,75,104,41,82,84,120,52,45,54,57,56,88,122,107,121,44,63,76,114,61,70] );
			aDecimals.push( [102,116,50,100,77,87,126,110,99,115,90,89,58,51,45,74,37,121,104,105,123,56,106,41,42,97,81,120,65,94,33,63,122,57,98,88,112,83,43,82,117,79,70,76,119,113,107,40,66,38,80,95,72,67,114,85,108,49,125,44,78,64,69,109,46,84,103,111,73,53,52,55,118,68,86,71,101,48,59,36,75,61,54] );
			aDecimals.push( [85,59,41,61,105,119,58,54,40,117,111,82,55,33,48,53,86,72,67,45,66,115,121,102,65,99,83,80,71,126,51,64,90,109,87,70,95,116,68,88,56,125,120,79,107,49,118,112,78,69,84,36,89,63,106,98,38,42,37,52,57,50,101,46,76,74,44,122,103,108,97,77,114,123,100,43,75,81,110,104,94,73,113] );
			aDecimals.push( [63,109,70,45,80,48,77,98,56,44,126,53,74,40,107,81,121,115,36,75,122,79,76,54,94,64,50,41,86,37,119,43,57,100,125,67,78,58,110,59,108,87,106,69,46,113,72,51,120,55,82,83,99,89,111,33,103,61,123,52,116,101,84,95,42,105,85,38,49,71,102,88,68,66,117,114,104,65,73,97,112,118,90] );
			aDecimals.push( [38,104,108,83,57,71,40,81,101,63,94,33,59,37,115,99,66,126,52,114,43,89,70,68,80,116,36,117,106,51,78,109,123,58,53,118,125,56,54,49,122,61,119,65,111,48,76,121,64,75,82,79,112,46,113,77,45,72,88,90,42,87,44,50,95,107,85,73,74,105,69,67,100,86,103,120,98,41,110,102,84,97,55] );
			aDecimals.push( [90,85,117,43,78,102,99,108,114,75,105,82,89,65,73,59,118,77,33,79,63,76,42,101,116,61,126,125,44,41,55,64,70,81,58,115,80,112,36,87,53,121,69,88,98,84,56,86,40,45,113,104,109,122,119,123,74,94,110,68,50,83,46,37,106,48,100,97,38,120,67,49,71,95,103,66,111,54,72,57,52,51,107] );
			aDecimals.push( [98,87,84,63,95,102,77,101,118,44,72,86,109,88,121,78,83,73,50,71,82,64,38,36,90,116,61,79,46,117,81,40,103,76,69,114,89,51,65,99,33,42,106,108,68,57,107,85,113,97,100,126,45,80,49,52,37,110,56,120,115,105,54,112,55,70,104,123,125,74,122,58,75,67,59,94,43,48,111,53,41,66,119] );
			aDecimals.push( [115,121,44,88,52,79,41,40,75,83,33,48,126,123,61,43,76,98,90,68,56,101,100,97,112,65,103,37,95,118,64,58,122,45,69,117,84,104,59,120,99,77,107,86,82,114,105,63,70,51,54,36,38,116,81,72,102,108,53,110,113,73,89,78,71,106,94,80,109,85,66,67,111,46,125,74,119,42,50,87,55,49,57] );
			aDecimals.push( [41,105,122,75,87,104,84,99,37,52,69,45,73,114,109,74,44,46,77,90,56,43,98,106,112,59,50,70,119,117,55,88,123,115,116,108,53,54,83,57,95,42,68,61,67,63,48,111,125,80,81,113,65,86,66,72,82,85,78,97,101,121,94,33,38,102,36,107,89,79,118,51,76,49,58,100,110,126,40,103,64,120,71] );
			aDecimals.push( [74,61,119,37,81,77,64,52,73,120,116,50,33,82,38,113,48,111,66,104,42,89,97,107,99,88,84,54,123,103,59,75,51,67,121,90,83,70,117,106,102,115,69,80,85,86,44,49,118,122,46,79,45,57,40,76,105,125,95,63,65,109,43,114,78,58,98,72,53,68,36,87,55,71,100,112,94,126,41,108,56,110,101] );

			aHex = [];
			for ( var i:int=0; i<aDecimals.length; i++ ) {
				var sHex:String = "";
				for ( var j:int=0; j<aDecimals[i].length; j++ ) sHex+=String.fromCharCode(aDecimals[i][j]);
				aHex.push( sHex );
			}
			iHexLen = aHex[0].length;
		}
		
		/**
		 * @return returns a hardcoded version identifier
		 */
		public function get iVID():Number
		{ 
			return 89198;
		}
		
		/**
		 * Calls the translation xml script
		 * @param	sh
		 * @param	sk
		 */
		public function init( sh:String, sk:String ):void {
			
			sBin = sh + sk;
			iBinLen = sBin.length;
		}
	
		/**
		 * Converts a string using Ceasar Cipher encryption with random hash, then returns a new string whereby each character is converted into a 3byte ascii character
		 * @param	s	String to encrypt
		 * @return		Final string
		 */
		public function encrypt( s:String ):String
		{
			// ceasar cipher encryption using a random hash
			var s1:String = encStep1( s );
			// convert each char into 3 byte ascii char
			var s2:String = encStep2( s1 );
			
			return ( s2	);
		}
	
		/**
		 * Encrypts a string using Ceasar Cipher
		 * @param	s	String to encrypt
		 * @return		Final string
		 */
		private function encStep1( s:String ):String
		{
			var sHex:String = "";
			var sReplace:String = "";
			var ii:Number = int(Math.random()*10); //aDecimals.length);
			var ti:Number = 0;
			var ki:Number = 0;
			sHex = aHex[ii];
			for ( ti=0; ti<s.length; ti++ ) {
				if ( ki >= iBinLen ) ki = 0;
				var c:int = sHex.indexOf(s.charAt(ti));
				if (c >= 0) {
					c = (c + sHex.indexOf(sBin.charAt(ki))) % iHexLen;
					sReplace += sHex.charAt(c);
				} else {
					sReplace += s.charAt(ti);
				}
				ki++;
			}
			
			// add hash index to string
			if ( ii >= 10 ) sReplace += String(ii);
			else sReplace += String(0) + String(ii);
			
			return ( sReplace );
		}
	
		/**
		 * Converts each character in a string into 3 byte ascii characters
		 * @param	s	String to convert
		 * @return		Final string after conversion
		 */
		private function encStep2( s:String ):String
		{
			var sReplace:String = "";
			var sChar:String = "";
			var ti:Number = 0;
			var ki:Number = 0;
			for ( ti=0; ti<s.length; ti++ ) {
				sChar = String(s.charCodeAt(ti));
				for ( ki=(3-sChar.length); ki>0; ki-- ) {
					sChar = "0" + sChar;
				}
				sReplace += sChar;
			}
			
			return ( sReplace );
		}
		
		// -------------------------------------------------------------------------------
		//
		// -------------------------------------------------------------------------------
	}
}
