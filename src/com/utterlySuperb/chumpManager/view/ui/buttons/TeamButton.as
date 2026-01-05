package com.utterlySuperb.chumpManager.view.ui.buttons
{
   import com.utterlySuperb.chumpManager.model.dataObjects.Club;
import flash.display.Bitmap;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.filters.BevelFilter;
import flash.filters.DropShadowFilter;
import flash.filters.GlowFilter;
import flash.geom.ColorTransform;
   
public class TeamButton extends ChumpButton
{
   
   public var club:Club;
   
   private var shirt:ClubShirt;
   
   private var kitBmp:Bitmap;

   private static var placeholderHeight:Number = 0;
      
      public function TeamButton()
      {
         super();
      }
      
   public function setTeam(param1:Club, param2:Boolean = true) : void
   {
      var _loc2_:ClubShirt = null;
      this.cleanupKit();
      if(this.shirt && contains(this.shirt))
      {
         removeChild(this.shirt);
      }
      this.kitBmp = Kits2D.getKit(param1.name);
      if(this.kitBmp)
      {
         if(placeholderHeight <= 0)
         {
            _loc2_ = new ClubShirt();
            placeholderHeight = _loc2_.height;
         }
         this.kitBmp.smoothing = true;
         if(placeholderHeight > 0)
         {
            this.kitBmp.scaleX = this.kitBmp.scaleY = (placeholderHeight / this.kitBmp.height) * 1.5;
         }
         else
         {
            this.kitBmp.scaleX = this.kitBmp.scaleY = 0.18;
         }
         this.kitBmp.x = -this.kitBmp.width / 2;
         this.kitBmp.y = 0;
         addChild(this.kitBmp);
         filters = [new GlowFilter(0,1,2,2,3,2),new DropShadowFilter()];
      }
      else
      {
         _loc2_ = new ClubShirt();
         this.shirt = _loc2_;
         this.tintMC(_loc2_.main,param1.shirtColor);
         this.tintMC(_loc2_.sleeves,param1.sleevesColor);
         if(param1.stripesType == Club.NONE)
         {
            _loc2_.horizontalStripes.visible = _loc2_.verticalStripes.visible = false;
         }
         else if(param1.stripesType == Club.HORIZONTAL)
         {
            _loc2_.verticalStripes.visible = false;
            this.tintMC(_loc2_.horizontalStripes,param1.stripesColor);
         }
         else
         {
            _loc2_.horizontalStripes.visible = false;
            this.tintMC(_loc2_.verticalStripes,param1.stripesColor);
         }
         addChild(_loc2_);
         _loc2_.filters = [new BevelFilter(3,45,16777215,0.6,0,0.6)];
         filters = [new GlowFilter(0,1,2,2,3,2),new DropShadowFilter()];
      }
      setText(param1.name);
      if(_loc2_)
      {
         _loc2_.x = 0;
         tf.y = _loc2_.height + 10;
      }
      if(this.kitBmp)
      {
         tf.y = this.kitBmp.height + 10;
      }
      tf.x = -tf.textWidth / 2;
      this.club = param1;
   }

   private function cleanupKit() : void
   {
      if(this.kitBmp && contains(this.kitBmp))
      {
         removeChild(this.kitBmp);
      }
      this.kitBmp = null;
   }
      
      private function tintMC(param1:Sprite, param2:Number) : void
      {
         var _loc3_:ColorTransform = param1.transform.colorTransform;
         _loc3_.color = param2;
         param1.transform.colorTransform = _loc3_;
      }
   }
}

