package com.neopets.vendor.gamepill.novastorm.render
{
  import flash.display.BitmapData;

  /*
   *  bitmapDataCollection class file
   *  Creates and manages a collection of BitmapData objects
   * 
   *  @langversion ActionScript 3.0
   *  @playerversion Flash 9.0
   * 
   *  @author Christopher Emirzian
   *  @since  11.11.2009
   */

  public final class bitmapDataCollection
  {
    public static var instance:bitmapDataCollection;
    public static var allowInstance:Boolean;

    public var collection:Object={};

    public function bitmapDataCollection()
    {
      
    }

    public function addBitmapData(id:String, bitmapData:BitmapData):BitmapData
    {  
      collection[id]=bitmapData;
      return collection[id];
    }

    public function search(item:String):Boolean
    {
      if(collection[item])
      {
        return true;
      }
      return false;
    }

    public function dispose():void
    {
      for each(var p:BitmapData in collection)
      {
        p.dispose();
        p=null;
      }
      collection={};
    }

    public function removeBitmapData(bitmapData:BitmapData):Boolean
    {
      for each(var p:BitmapData in collection)
      {
        if(p==bitmapData)
        {
          p.dispose();
          p=null;
          return true;
        }
      }

      return false;
    }
  }
}