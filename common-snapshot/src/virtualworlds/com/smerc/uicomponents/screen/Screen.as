package virtualworlds.com.smerc.uicomponents.screen
{
	import caurina.transitions.Tweener;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import virtualworlds.com.smerc.uicomponents.contentHolders.ContentHolder;
	import virtualworlds.com.smerc.utils.events.ObjectEvent;
	import virtualworlds.com.smerc.utils.serializedExecutor.TimedQueue;
	
	/**
	 * The Screen class is a self-contained, self-managed image with internal knowledge of how to transition itself.
	 * It is also used within the ScreenManager class.
	 * 
	 * @author Bo Landsman
	 */
	public class Screen extends ContentHolder
	{
		/**
		 * @eventType Screen.TRANSITION_IN_COMPLETE_EVT
		 * This is dispatched when the this has completed its tween from its call to show().
		 */
		public static const TRANSITION_IN_COMPLETE_EVT:String = "TransitionInCompleteEvent";
		
		/**
		 * @eventType Screen.TRANSITION_OUT_COMPLETE_EVT
		 * This is dispatched when the this has completed its tween from its call to hide().
		 */
		public static const TRANSITION_OUT_COMPLETE_EVT:String = "TransitionOutCompleteEvent";
		
		/**
		 * @eventType Screen.TRANSITION_OUT_COMPLETE_EVT
		 * This is dispatched when the this has completed its tween from its call to hide().
		 */
		public static const TWEEN_COMPLETE_EVT:String = "TweenCompleteEvent";
		
		/**
		 * This is the internally managed queue of transition-parameters.
		 */
		protected var _paramsQueue:TimedQueue;
		
		/**
		 * Construct a new Screen.
		 * 
		 * @param	a_mc:	<Sprite> This screen's image to be manipulated.  a_mc is added to this.
		 */
		public function Screen(a_mc:Sprite)
		{
			super(a_mc, true);
			
			_paramsQueue = new TimedQueue();
			_paramsQueue.addEventListener(TimedQueue.POP_OBJECT_EVT, addNextQueuedTween, false, 0, true);
			
		}//end Screen()
		
		/**
		 * @return <Object> caurina-tweener tween-parameters for showing this.
		 * 					<br/><b>NOTE:</b> if this function is overriden with a different onComplete parameter,
		 * 					transitionInComplete will not be called and therefore one cannot depend on the 
		 * 					Screen.TRANSITION_IN_COMPLETE_EVT to be dispatched from this.
		 */
		protected function get defaultShowParams():Object
		{
			return { x:0, y:0, time:1.0, transition:"linear", onComplete:transitionInComplete };
		}//end get defaultShowParams()
		
		/**
		 * @return <Object> caurina-tweener tween-parameters for hiding this.
		 */
		protected function get defaultHideParams():Object
		{
			return { x:this.stage.stageWidth + 1, y:0, time:1.0, transition:"linear", onComplete:transitionOutComplete };
		}//end get defaultHideParams()
		
		/**
		 * Do a non-default transition (something other than show/hide).
		 * 
		 * @param	a_tweenParams:		<Object> caurina-tweener tween-parameters for hiding this. 
		 * 								<BR/><B>NOTE:</B> if a_doImmediately is false, the onComplete and onCompleteParams
		 * 								are re-written.
		 * @param	a_doImmediately:	<Boolean @default false> Determines whether this tween is to wait for any
		 * 								current tweens to finish, or to be executed immediately.
		 */
		public function doTween(a_tweenParams:Object, a_doImmediately:Boolean = false):void
		{
			if (!a_tweenParams)
			{
				throw new ArgumentError("Screen::doTween(): a_tweenParams=null !");
			}
			
			if (a_doImmediately)
			{
				Tweener.addTween(this, a_tweenParams);
			}
			else
			{
				a_tweenParams.onComplete = onTweenComplete;
				a_tweenParams.onCompleteParams = [a_tweenParams];
				_paramsQueue.add(a_tweenParams);
				_paramsQueue.pause(false);
			}
			
		}//end doTween()
		
		/**
		 * This is a response to our internal QueueTimer popping a transition parameter, which was popped
		 * because the previous tween had finished.
		 * Here, we pause our parameters queue until our next tween finishes (pops).
		 * 
		 * @param	a_objEvt:	<ObjectEvent> An event containing a 
		 * 						caurina tween parameter object to be used in our next transition.
		 */
		protected function addNextQueuedTween(a_objEvt:ObjectEvent):void
		{
			_paramsQueue.pause(true); // so that we wait until this tween is complete.
			this.doTween(a_objEvt.obj, true); // do the tween, adding it immediately.
			
		}//end addNextQueuedTween()
		
		/**
		 * This is the onComplete of the doTween() call.
		 * 
		 * @param	tweenParamsObj:	<Object> Caurina-tweener non-default transition parameters.
		 * @param	...args:		<Array> should future overrides require more parameters.
		 */
		protected function onTweenComplete(tweenParamsObj:Object = null, ...args):void
		{
			// The tween is complete, unpause our queue to get the next tween.
			_paramsQueue.pause(false);
			if(tweenParamsObj)
			{
				delete tweenParamsObj.onCompleteParams;
			}
			this.dispatchEvent(new ObjectEvent(Screen.TWEEN_COMPLETE_EVT, tweenParamsObj));
			
		}//end onTweenComplete()
		
		/**
		 * A function more for showcasing the transitioning abilitie of this class more than anything else.
		 * This shows itself, and, upon completion, hides itself.
		 */
		public function showHide():void
		{
			this.doTween(this.defaultShowParams);
			this.doTween(this.defaultHideParams);
		}//end showHide()
		
		/**
		 * 
		 * @param	a_tweenParams:	<Object> Caurina-tweener non-default transition parameters.
		 * 							<br/><b>NOTE:</b> If this argument is used without using 
		 * 							this.transitionInComplete as the onComplete parameter, 
		 * 							Screen.TRANSITION_IN_COMPLETE_EVT will not be dispatched from
		 * 							this, and therefore one cannot depend on it.
		 */
		public function show(a_tweenParams:Object = null):void
		{
			if (Tweener.isTweening(this))
			{
				Tweener.removeTweens(this);
			}
			Tweener.addTween(this, a_tweenParams ? a_tweenParams : this.defaultShowParams);
			
		}//end show()
		
		/**
		 * This is the default listener for when show() is complete.
		 * Here, we dispatch Screen.TRANSITION_IN_COMPLETE_EVT.
		 * 
		 * @param	...args
		 * 
		 * @see #Screen.TRANSITION_IN_COMPLETE_EVT
		 */
		protected function transitionInComplete(...args):void
		{
			this.dispatchEvent(new Event(Screen.TRANSITION_IN_COMPLETE_EVT));
		}//end transitionInComplete()
		
		/**
		 * 
		 * @param	a_tweenParams:	<Object> Caurina-tweener non-default transition parameters.
		 * 							<br/><b>NOTE:</b> If this argument is used without using 
		 * 							this.transitionOutComplete as the onComplete parameter, 
		 * 							Screen.TRANSITION_OUT_COMPLETE_EVT will not be dispatched from
		 * 							this, and therefore one cannot depend on it.
		 */
		public function hide(a_tweenParams:Object = null):void
		{
			if (Tweener.isTweening(this))
			{
				Tweener.removeTweens(this);
			}
			
			Tweener.addTween(this, a_tweenParams ? a_tweenParams : this.defaultHideParams);
			
		}//end hide()
		
		/**
		 * This is the default listener for when show() is complete.
		 * Here, we dispatch Screen.TRANSITION_OUT_COMPLETE_EVT.
		 * 
		 * @param	...args
		 * 
		 * @see #Screen.TRANSITION_OUT_COMPLETE_EVT
		 */
		protected function transitionOutComplete(...args):void
		{
			this.dispatchEvent(new Event(Screen.TRANSITION_OUT_COMPLETE_EVT));
		}//end transitionOutComplete()
		
		/**
		 * Overrides of this function should call 
		 * super.pause(a_bool);
		 * 
		 * @param	a_bool:	<Boolean> Pause/unpause our tweens.
		 */
		public function pause(a_bool:Boolean):void
		{
			if (Tweener.isTweening(this))
			{
				if (a_bool)
				{
					// pause all our current tweens.
					Tweener.pauseTweens(this);
				}
				else
				{
					// unpause all our current tweens
					Tweener.resumeTweens(this);
				}
			}
			
		}//end pause()
		
		/**
		 * Cleanup of this class.
		 * 
		 * @param	...args
		 */
		override public function destroy(...args):void
		{
			if(_paramsQueue)
			{
				_paramsQueue.destroy();
				_paramsQueue = null;
			}
			
			super.destroy(args);
			
		}//end destroy()
		
	}//end class Screen
	
}//end package com.smerc.uicomponents.screen
