package com.neopets.vendor.gamepill.novastorm.render
{
  import flash.display.Bitmap;
  import flash.display.BitmapData;
  import flash.geom.Point;
  import flash.geom.Rectangle;
  
  /*
   *  screenRender class file
   *  Renders a screen
   * 
   *  @langversion ActionScript 3.0
   *  @playerversion Flash 9.0
   * 
   *  @author Christopher Emirzian
   *  @since  11.11.2009
   */

  public class screenRender extends Bitmap
  {
    public var itemList:Array;
    public var rect:Rectangle;
    public var sortList=new Array();
    public var renderCount:int=0;

    private const zeroPoint:Point=new Point();

    public function screenRender(width:int, height:int)
    {    
      bitmapData=new BitmapData(width, height);
      rect=bitmapData.rect;
    }

    public function render()
    {
      var pos:Point=new Point();

      bitmapData.lock();

      //bitmapData.fillRect(rect, 0x000000FF);

      renderCount++;

      sortList=new Array();

      for(var i:int=0; i<itemList.length; i++)
      {
        if(itemList[i]==null)
          continue;

        if(itemList[i].visible==false || itemList[i].alpha==0)
          continue;

        sortList.push(new sortObj(itemList[i],itemList[i].zPos));
      }

      sortList.sortOn("zPos",Array.NUMERIC);

      for(var i:int=0; i<sortList.length; i++)
      {
        var item=sortList[i].spr;

        pos.x=item.x;
        pos.y=item.y;

        item.updateBitmap();
        bitmapData.copyPixels(item.bitmapData, item.rect, pos, null, null, true);

        for(var x:int=0; x<item.renderList.length; x++)
        {
          if(item.renderList[x].visible==false || item.renderList[x].alpha==0)
            continue;

          pos.x=item.renderList[x].x+item.x;
          pos.y=item.renderList[x].y+item.y;

          item.renderList[x].updateBitmap();
          bitmapData.copyPixels(item.renderList[x].bitmapData, item.renderList[x].rect, pos, null, null, true);
        }
      }

      bitmapData.unlock();
    }
  }
}