package com.utterlySuperb.chumpManager.view.ui.buttons
{
   import com.utterlySuperb.chumpManager.model.dataObjects.Player;
   import com.utterlySuperb.ui.buttons.GenericButton;
   import flash.display.MovieClip;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   
   public class PlayerButton extends GenericButton
   {
      
      public var column:int;
      
      public var row:int;
      
      public var num:int;
      
      public var tf:TextField;
      
      public var player:Player;
      
      public var light:MovieClip;
      
      protected var mc:MovieClip;
      
      public function PlayerButton()
      {
         super();
         this.mc = new FormDiagramPlayerButtonMC();
         addChild(this.mc);
         this.stopAllFrames(this.mc);
         if(this.mc["bg"])
         {
            this.gotoSafeFrame(this.mc["bg"],1);
         }
         if(this.mc["light"])
         {
            this.gotoSafeFrame(this.mc["light"],1);
         }
         this.setNormal();
      }
      
      public function setPlayer(param1:Player) : void
      {
         this.player = param1;
         this.mc.tf.text = param1.squadNumber.toString();
      }
      
      public function setTeam(param1:Boolean) : void
      {
         if(!param1)
         {
            this.mc.bg.gotoAndStop(2);
         }
      }
      
      public function setMoving() : void
      {
         parent.setChildIndex(this,parent.numChildren - 1);
         this.mc.light.gotoAndStop(2);
         filters = [new GlowFilter(16776960,1,3,3),new GlowFilter(13369344,0.5,5,5),new DropShadowFilter(5,45)];
      }
      
      public function setOver() : void
      {
         this.mc.light.gotoAndStop(2);
         filters = [new GlowFilter(16776960,1,3,3),new GlowFilter(13369344,0.5,5,5),new DropShadowFilter(2,45)];
      }
      
      public function setNormal() : void
      {
         this.mc.light.gotoAndStop(1);
         filters = [new DropShadowFilter(2,45)];
      }
      
      public function setLight(param1:Boolean) : void
      {
         if(param1)
         {
            this.mc.light.gotoAndStop(2);
         }
         else
         {
            this.mc.light.gotoAndStop(1);
         }
      }

      private function stopAllFrames(param1:MovieClip) : void
      {
         try
         {
            param1.stop();
         }
         catch(e:Error)
         {
         }
      }

      private function gotoSafeFrame(param1:MovieClip, param2:int) : void
      {
         if(!param1)
         {
            return;
         }
         try
         {
            param1.gotoAndStop(param2);
         }
         catch(e:Error)
         {
         }
      }
   }
}

