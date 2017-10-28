package virtualworlds.helper
{
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	import org.spicefactory.lib.logging.LogContext;
	import org.spicefactory.lib.logging.Logger;
	
	import ppp.PPPFacade;
	import ppp.core.model.ResourceManagerProxy;
	
	import virtualworlds.com.kylebrekke.amfphp.amfphp;
	
	public class AmfPhpDispatch
	{
		public function AmfPhpDispatch()
		{
		}
		
		public static function callFunction(callFunction:String, amfArgs:Array = null, extraArgs:Object = null):void
		{
			var resourceManagerProxy:ResourceManagerProxy = PPPFacade.getInstance().retrieveProxy(ResourceManagerProxy.NAME) as ResourceManagerProxy;
			var amfphpVar:amfphp = new amfphp(resourceManagerProxy.gatewayURL, callFunction, amfArgs, extraArgs);
			amfphpVar.addEventListener(amfphp.NETWORK_ERROR, onNetworkError);
		}
		
		private static function onNetworkError(event:Event):void
		{
			var className:String = getQualifiedClassName(AmfPhpDispatch);
			var classType:Class = LogContext.getLogger(className) as Class;
			var log:Logger = LogContext.getLogger(classType);		
			log.error(event.toString());	
		}

	}
}