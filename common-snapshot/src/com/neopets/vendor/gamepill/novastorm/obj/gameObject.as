package com.neopets.vendor.gamepill.novastorm.obj
{
  import com.neopets.vendor.gamepill.novastorm.render.sprite;

  import flash.geom.Point;
  import flash.geom.Rectangle;

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

  public class gameObject extends sprite
  {
    public var animTimer:int=0;

    public var x:Number=0;
    public var y:Number=0;

    public var xSpeed:Number=0; // x speed
    public var ySpeed:Number=0; // y speed
    public var sLimit:Number=0; // speed limit

    public var isMissile=false; // is enemy missile
    public var isEnemy=false; // is enemy
    public var collideWithEnemy=false; // collides with enemies
    public var collideWithPlayer=false; // collides with player
    public var playerCollectEffect=0; // effect if player collects it
    public var playerFriend=false; // is player friendly
    public var isEnemyShot=false; // is enemy shot
    public var isStealthEnemy=false; // is stealth enemy
    public var isBoss=false; // is boss enemy

    public var health:int=0; // health - how many hits it takes before dying

    public var pointValue:int=0; // point value for killing

    // set position and speed

    public function setPosSpeed(posX:Number,posY:Number,speedX:Number,speedY:Number)
    {
      this.x=posX;
      this.y=posY;
      this.xSpeed=speedX;
      this.ySpeed=speedY;
    }

    // set xSpeed,ySpeed towards a position

    public function aimTowards(xPos:Number,yPos:Number,speed:Number)
    {
      if(this.x+this.width/2>xPos)
        this.xSpeed-=speed;
      else
        this.xSpeed+=speed;

      if(this.y+this.height/2>yPos)
        this.ySpeed-=speed;
      else
        this.ySpeed+=speed;
    }

    // bounce off sides of screen

    public function bounceWalls()
    {
      if(this.x<0)
      {
        this.x=0;
        this.xSpeed*=-1;
      }
      if(this.x>650-this.width)
      {
        this.x=650-this.width;
        this.xSpeed*=-1;
      }
      if(this.y<0)
      {
        this.y=0;
        this.ySpeed*=-1;
      }
      if(this.y>600-this.height)
      {
        this.y=600-this.height;
        this.ySpeed*=-1;
      }
    }

    // check if out of bounds every 4th game loop

    public function checkOutOfBounds()
    {
      if(this.container.gCountQuad==0)
        if(this.x<-8 || this.y<-8 || this.x>650 || this.y>600)
          this.visible=false;
    }

    // check if speed is over speed limit

    public function checkSpeed()
    {
      if(this.xSpeed>this.sLimit)
        this.xSpeed=this.sLimit;
      if(this.xSpeed<-this.sLimit)
        this.xSpeed=-this.sLimit;

      if(this.ySpeed>this.sLimit)
        this.ySpeed=this.sLimit;
      if(this.ySpeed<-this.sLimit)
        this.ySpeed=-this.sLimit;
    }

    // divide speed by a number

    public function divideSpeed(div:Number)
    {
      this.xSpeed/=div;
      this.ySpeed/=div;
    }

    // move; adds xSpeed,ySpeed to x,y

    public function move()
    {
      this.x+=this.xSpeed;
      this.y+=this.ySpeed;
    }

    // get the xSpeed and ySpeed for aiming towards a position

    public function getPosAim(xSeek:Number,ySeek:Number,speed:Number)
    {
      var tx=xSeek;
      var ty=ySeek;

      var tx2=this.x+this.width/2;
      var ty2=this.y+this.height/2;

      var dx=tx-tx2;
      var dy=ty-ty2;

      var z=Math.abs(dx)+Math.abs(dy);
      z*=(speed/100); if(z==0) z=1;

      dx=dx/z;
      dy=dy/z;

      var point=new Point(dx,dy);

      return point;
    }

    // animate

    public function animate()
    {
      if(this.animTimer>0)
      {
        this.animTimer++;

        if(this.animTimer>=this.totalFrames)
          this.animTimer=0;

        this.gotoAndStop(animTimer);
      }
    }

    public function animateLoop()
    {
      this.animTimer++;

      if(this.animTimer>=this.totalFrames)
        this.animTimer=0;

      this.gotoAndStop(animTimer);
    }

    public function animateOnce()
    {
      if(this.animTimer>0)
      {
        this.animTimer++;

        if(this.animTimer>=this.totalFrames)
          this.animTimer=this.totalFrames-1;

        this.gotoAndStop(animTimer);
      }
    }

    // check if x,y point lies within x1,y1,x2,y2 rectangle area

    public function hitTest(x:Number,y:Number,x1:Number,y1:Number,x2:Number,y2:Number):Boolean
    {
      return(x>=x1 && x<=x2 && y>=y1 && y<=y2);
    }

    // collision between an object

    public function hitTestObject(o2):Boolean
    {
      var left1=this.x;
      var right1=this.x+this.width;
      var top1=this.y;
      var bottom1=this.y+this.height;

      var left2=o2.x;
      var right2=o2.x+o2.width;
      var top2=o2.y;
      var bottom2=o2.y+o2.height;

      if(bottom1<top2) return false;
      if(top1>bottom2) return false;

      if(right1<left2) return false;
      if(left1>right2) return false;

      return true;
    }

    // collision between an object with a rectangle factored in

    public function hitTestObjectRect(o2,r):Boolean
    {
      var left1=this.x;
      var right1=this.x+this.width;
      var top1=this.y;
      var bottom1=this.y+this.height;

      var left2=o2.x+r.x;
      var right2=o2.x+r.x+r.width;
      var top2=o2.y+r.y;
      var bottom2=o2.y+r.y+r.height;

      if(bottom1<top2) return false;
      if(top1>bottom2) return false;

      if(right1<left2) return false;
      if(left1>right2) return false;

      return true;
    }

    // rotate a position using sin/cos math

    public function rotPos(x:Number,y:Number,t:Number):Point
    {
      var t,tCos;

      t/=57.29581;

      tCos=Math.cos(t);
      t=Math.sin(t);

      var point=new Point((x*tCos)-(y*t),(y*tCos)+(x*t));

      return point;
    }
  }
}
