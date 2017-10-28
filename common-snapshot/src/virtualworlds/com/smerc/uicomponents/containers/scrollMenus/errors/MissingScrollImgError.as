package virtualworlds.com.smerc.uicomponents.containers.scrollMenus.errors
{
	/**
	 * ...
	 * @author Bo Landsman
	 */
	public class MissingScrollImgError extends MissingPieceError
	{
		
		public function MissingScrollImgError(a_pieceName:String = "")
		{
			super((a_pieceName == "" ? "scrollButtonImg" : a_pieceName));
		}
		
	}
	
}