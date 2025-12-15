package com.utterlySuperb.chumpManager.view.ui.buttons
{
   import com.utterlySuperb.chumpManager.model.dataObjects.Club;
   import flash.display.Sprite;
   import flash.filters.BevelFilter;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import flash.geom.ColorTransform;
   
   public class TeamButton extends ChumpButton
   {
      
      public var club:Club;
      
      public function TeamButton()
      {
         super();
      }
      
      public function setTeam(param1:Club) : void
      {
         var _loc2_:ClubShirt = null;
         _loc2_ = new ClubShirt();
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
         setText(param1.name);
         _loc2_.x = tf.textWidth / 2;
         tf.y = _loc2_.height + 10;
         this.club = param1;
      }
      
      private function tintMC(param1:Sprite, param2:Number) : void
      {
         var _loc3_:ColorTransform = param1.transform.colorTransform;
         _loc3_.color = param2;
         param1.transform.colorTransform = _loc3_;
      }
   }
}

