package com.neopets.vendor.gamepill.novastorm.render
{
  import flash.display.BitmapData;
  import flash.display.MovieClip;
  import flash.events.EventDispatcher;
  import flash.geom.Point;
  import flash.geom.Rectangle;
  import flash.geom.Matrix;
  import flash.utils.getQualifiedClassName;

  /*
   *  NovaStorm Game Object class
   *  Generic game object class
   * 
   *  @langversion ActionScript 3.0
   *  @playerversion Flash 9.0
   * 
   *  @author Christopher Emirzian
   *  @since  11.11.2009
   */

  public class sprite extends Object
  {
    public var zPos:int=0; // draw depth

    public var scaleX=1;
    public var scaleY=1;

    public var alpha=1;

    public var visible:Boolean=true;

    public var width:Number=0;
    public var height:Number=0;

    public var container:MovieClip; // the container of this object

    public var bitmapData:BitmapData;
    public var rect:Rectangle;
    public var movieClip;
    public var currentFrame:int=0;
    public var totalFrames:int;
    public var animation:Array=[];
    public var renderList:Array=[];

    public var removeable=true;

    // set container

    public function setContainer(cont)
    {
      this.container=cont;
    }

    // parse movie clip

    public function parseMovieClip(mc:MovieClip)
    {
      if(mc==undefined || mc==null)
        mc=new movieClip();

      animation=new Array();

      for(var i:int=1; i<=mc.totalFrames; i++)
      {
        var id:String=getQualifiedClassName(mc)+"_"+i;

        if(container.bmdCollection.search(id))
        {
          animation.push(container.bmdCollection.collection[id]);
        }
        else
        {
          mc.gotoAndStop(i);

          if(mc.width==0 || mc.height==0)
            var bmd:BitmapData=new BitmapData(1, 1, true, 0x0);
          else
            var bmd:BitmapData=new BitmapData(mc.width, mc.height, true, 0x0);

          bmd.draw(mc);
 
          animation.push(container.bmdCollection.addBitmapData(id,bmd));
        }
      }

      currentFrame=0;
      totalFrames=animation.length;

      updateBitmap();
    }

    // goto and stop

    public function gotoAndStop(gotoFrame:int)
    {
      if(gotoFrame<0) 
      {
        currentFrame=0;
      }
      else if(gotoFrame>=totalFrames)
      {
        currentFrame=totalFrames-1;
      }
      else
      {
        currentFrame=gotoFrame;
      }

      updateBitmap();
    }

    // set scale

    public function setScale(sx:Number, sy:Number):void
    {
      if(sx<=0 || sy<=0)
        return;

      this.scaleX=sx;
      this.scaleY=sy;
    }

    // update bitmap
    
    public function updateBitmap() 
    {
      if(animation.length==0)
        return;

      bitmapData=animation[currentFrame];

      rect=bitmapData.rect;
      width=bitmapData.width;
      height=bitmapData.height;
    }

    // dispose

    public function dispose()
    {
      bitmapData=null;
    }
  }
}
