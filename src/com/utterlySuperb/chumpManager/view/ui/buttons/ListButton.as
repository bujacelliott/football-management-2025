package com.utterlySuperb.chumpManager.view.ui.buttons
{
   import com.greensock.TweenLite;
   import com.utterlySuperb.text.TextHelper;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.BevelFilter;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import flash.text.TextFormatAlign;
   
   public class ListButton extends ChumpButton
   {
      
      public static const DEFAULT:int = 0;
      
      public static const IN_TEAM:int = 1;
      
      public static const IN_SUBS:int = 2;
      
      public static const UNAVAILABLE:int = 3;
      
      protected var bg:Sprite = new Sprite();
      
      protected var onNum:int = 0;
      
      protected var colors:Array;
      
      protected var defColors:Array = [8673099,10120795];
      
      protected var unavailableColors:Array = [7829367,10066329];
      
      protected var inTeamColors:Array = [13373730,13572399];
      
      protected var inSubsColors:Array = [2232780,3089103];
      
      protected var team0colors:Array = [39372,1092060];
      
      protected var team1colors:Array = [16737894,16742263];
      
      public var selected:Boolean;
      
      public var state:int;
      
      public function ListButton()
      {
         this.colors = this.defColors;
         bWidth = 222;
         addChild(this.bg);
         filters = [new BevelFilter(2,45,16777215,0.5,0,0.5,2,2)];
         super();
      }
      
      override protected function makeTextField() : void
      {
         tf = new TextField();
         addChild(tf);
         TextHelper.doTextField2(tf,Styles.LIST_FONT,Styles.LIST_FONT_SIZE,Styles.BUTTON_FONT_COLOR,{"align":TextFormatAlign.LEFT});
      }
      
      override public function setText(param1:String) : void
      {
         tf.width = bWidth;
         tf.htmlText = param1;
         TextHelper.fitTextField(tf);
         tf.x = int((bWidth - tf.textWidth) / 2);
         tf.y = (bHeight - tf.textHeight) / 2;
      }
      
      public function setBG(param1:Boolean) : void
      {
         this.onNum = param1 ? 0 : 1;
         var _loc2_:Number = Number(this.colors[this.onNum % 2]);
         this.setBGCol(_loc2_);
      }
      
      public function setSelected() : void
      {
         this.selected = true;
         filters = [new GlowFilter(16777215,1,10,10,2,1,true),new GlowFilter(16776960,0.5,15,15,2,1,true),new BevelFilter(2,45,16777215,0.5,0,0.5,2,2)];
         if(parent)
         {
            parent.setChildIndex(this,parent.numChildren - 1);
         }
      }
      
      public function removeSelected() : void
      {
         this.selected = false;
         filters = [new BevelFilter(2,45,16777215,0.5,0,0.5,2,2)];
      }
      
      public function setPromotedPos(param1:int) : void
      {
         var _loc2_:Array = [13408563,16750848,13408563];
         this.setBGCol(_loc2_[param1]);
      }
      
      public function setRelegatedPos(param1:int) : void
      {
         var _loc2_:Array = [10027059,10040166,10027059];
         this.setBGCol(_loc2_[param1]);
      }
      
      public function setBGCol(param1:Number) : void
      {
         this.bg.graphics.clear();
         this.bg.graphics.beginFill(param1);
         this.bg.graphics.drawRect(0,0,bWidth,bHeight);
      }
      
      override protected function rollOver(param1:MouseEvent) : void
      {
         super.rollOver(param1);
         tf.textColor = 0;
         TweenLite.to(this.bg,0.3,{"colorTransform":{"brightness":1.5}});
      }
      
      override protected function rollOut(param1:MouseEvent) : void
      {
         super.rollOut(param1);
         tf.textColor = 16777215;
         TweenLite.to(this.bg,0.3,{"colorTransform":{"brightness":1}});
      }
      
      override public function getHeight() : int
      {
         return bHeight;
      }
      
      public function setDefault() : void
      {
         this.state = DEFAULT;
         this.setBGCol(this.defColors[this.onNum % 2]);
      }
      
      public function setUnavailable() : void
      {
         this.state = UNAVAILABLE;
         this.setBGCol(this.unavailableColors[this.onNum % 2]);
      }
      
      public function setInTeam() : void
      {
         this.state = IN_TEAM;
         this.setBGCol(this.inTeamColors[this.onNum % 2]);
      }
      
      public function setInSubs() : void
      {
         this.state = IN_SUBS;
         this.setBGCol(this.inSubsColors[this.onNum % 2]);
      }
      
      public function setTeam(param1:int) : void
      {
         this.setBGCol(param1 == 0 ? Number(this.team0colors[this.onNum % 2]) : Number(this.team1colors[this.onNum % 2]));
      }
   }
}

