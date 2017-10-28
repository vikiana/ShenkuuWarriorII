package virtualworlds.com.smerc.uicomponents.containers.scrollMenus.errors
{
	
	/**
	 * ...
	 * @author Bo Landsman
	 */
	public class MissingPieceError extends ArgumentError
	{
		public var pieceName:String;
		
		public function MissingPieceError(a_pieceName:String = "")
		{
			super("Missing piece '" + (pieceName = a_pieceName) + "'");
		}
		
	}
	
}