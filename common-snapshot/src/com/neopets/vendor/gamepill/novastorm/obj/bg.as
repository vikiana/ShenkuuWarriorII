package com.neopets.vendor.gamepill.novastorm.obj
{
  import flash.display.MovieClip;
  import flash.display.DisplayObject;
  import flash.geom.Point;

  /*
   *  Background class
   * 
   *  @langversion ActionScript 3.0
   *  @playerversion Flash 9.0
   * 
   *  @author Christopher Emirzian
   *  @since  11.11.2009
   */

  public class bg extends gameObject
  {
    public var cloud1:gameObject; // cloud 1
    public var cloud2:gameObject; // cloud 2

    public var ast1:gameObject; // asteroid 1
    public var ast2:gameObject; // asteroid 2
    public var ast3:gameObject; // asteroid 3
    public var ast4:gameObject; // asteroid 4

    public function bg()
    {
      this.visible=true;

      this.zPos=-100;
      this.removeable=false;

      this.cloud1=new gameObject();
      this.cloud2=new gameObject();

      this.ast1=new gameObject();
      this.ast2=new gameObject();
      this.ast3=new gameObject();
      this.ast4=new gameObject();

      this.renderList=new Array(cloud1,cloud2,ast1,ast2,ast3,ast4);
    }

    public function setupAnimations()
    {
      cloud1.setContainer(container);
      cloud1.parseMovieClip(new cloudSmallMC());
      cloud1.x=150;
      cloud1.y=200;
      cloud1.xSpeed=0.25;

      cloud2.setContainer(container);
      cloud2.parseMovieClip(new cloudLargeMC());
      cloud2.x=300;
      cloud2.y=400;
      cloud2.xSpeed=0.5;

      ast1.setContainer(container);
      ast1.parseMovieClip(new asteroid1());
      ast1.x=(Math.random()*650)-ast1.width;
      ast1.y=Math.random()*600;
      ast1.ySpeed=0.25;

      ast2.setContainer(container);
      ast2.parseMovieClip(new asteroid2());
      ast2.x=(Math.random()*650)-ast2.width;
      ast2.y=Math.random()*600;
      ast2.ySpeed=0.5;

      ast3.setContainer(container);
      ast3.parseMovieClip(new asteroid3());
      ast3.x=(Math.random()*650)-ast3.width;
      ast3.y=Math.random()*600;
      ast3.ySpeed=0.75;

      ast4.setContainer(container);
      ast4.parseMovieClip(new asteroid4());
      ast4.x=(Math.random()*650)-(ast4.width/2);
      ast4.y=Math.random()*600;
      ast4.ySpeed=1;
    }

    public function doLoop()
    {
      var a:int=0;

      for(a=1; a<=2; a++)
      {
        this["cloud"+a].x+=this["cloud"+a].xSpeed;
        if(this["cloud"+a].x>650)
          this["cloud"+a].x=-this["cloud"+a].width;

        this["cloud"+a].y+=0.4;
        if(this["cloud"+a].y>700)
          this["cloud"+a].y=-this["cloud"+a].height;
      }

      for(a=1; a<=4; a++)
      {
        this["ast"+a].y+=this["ast"+a].ySpeed;
        if(this["ast"+a].y>700 && Math.floor(Math.random()*8)==0)
        {
          this["ast"+a].x=(Math.random()*650)-(this["ast"+a].width/2);
          this["ast"+a].y=-this["ast"+a].height;
        }
      }
    }
  }
}
