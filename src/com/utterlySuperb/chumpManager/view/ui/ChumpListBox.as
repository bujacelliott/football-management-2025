package com.utterlySuperb.chumpManager.view.ui
{
   import com.utterlySuperb.chumpManager.model.dataObjects.Player;
   import com.utterlySuperb.chumpManager.view.ui.buttons.ListButton;
   import com.utterlySuperb.chumpManager.view.ui.buttons.listButtons.PlayerListButton;
   import com.utterlySuperb.text.TextHelper;
   import com.utterlySuperb.ui.IntScrollBar;
   import com.utterlySuperb.ui.ListBox;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.filters.BevelFilter;
   import flash.text.TextField;
   
   public class ChumpListBox extends ListBox
   {
      
      private var tf:TextField;
      
      private var outLines:Sprite;
      
      private var scrollWidth:int = 15;
      
      public function ChumpListBox(param1:int, param2:int)
      {
         super(param1,param2);
         this.outLines = new Sprite();
         addChild(this.outLines);
      }
      
      public function addHeader(param1:String) : void
      {
         graphics.beginFill(0,0);
         graphics.lineStyle(1,16777215);
         graphics.drawRect(0,-31,maxWidth + this.scrollWidth,maxHeight + 41);
         this.tf = new TextField();
         TextHelper.doTextField2(this.tf,Styles.BUTTON_FONT,27,Styles.COPY_FONT_COLOR1);
         this.tf.htmlText = param1;
         TextHelper.fitTextField(this.tf);
         this.tf.x = int((maxWidth + this.scrollWidth - this.tf.textWidth) / 2);
         this.tf.y = -this.tf.textHeight;
         addChild(this.tf);
      }
      
      public function drawFrame() : void
      {
         graphics.beginFill(0x0d2f1b);
         graphics.lineStyle(2,16777215);
         graphics.drawRect(0,0,maxWidth + this.scrollWidth,maxHeight);
         graphics.beginFill(0x0a2415);
         graphics.lineStyle(2,16777215);
         graphics.drawRect(0,maxHeight,maxWidth + this.scrollWidth,10);
         this.outLines.graphics.lineStyle(2,16777215);
         this.outLines.graphics.moveTo(maxWidth,0);
         this.outLines.graphics.lineTo(maxWidth,maxHeight);
         this.outLines.graphics.drawRect(0,0,maxWidth + this.scrollWidth,maxHeight);
         this.outLines.graphics.drawRect(0,maxHeight,maxWidth + this.scrollWidth,10);
      }
      
      override protected function addScroller() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 25;
         scroller = new IntScrollBar();
         scroller.bg = new MovieClip();
         scroller.bg.graphics.lineStyle(1,16777215);
         scroller.bg.graphics.beginFill(0x14552b);
         scroller.bg.graphics.drawRect(0,0,this.scrollWidth,maxHeight + offsetY);
         scroller.addChild(scroller.bg);
         scroller.scroller = new MovieClip();
         scroller.scroller.filters = [new BevelFilter(2,45,16777215,0.5,0,0.5,2,2)];
         scroller.scroller.graphics.beginFill(0x1c7a3f);
         scroller.scroller.graphics.drawRect(0,0,this.scrollWidth,_loc1_);
         scroller.addChild(scroller.scroller);
         scroller.setScrollerRange(maxHeight + offsetY,holder);
         scroller.addEventListener(IntScrollBar.VALUE_CHANGED,scrollerHanlder);
         scroller.enable();
         addChild(scroller);
         scroller.x = maxWidth;
         var _loc2_:Sprite = new Sprite();
         _loc2_.graphics.lineStyle(1,16777215);
         _loc2_.graphics.drawRect(0,0,maxWidth + this.scrollWidth,maxHeight + offsetY);
         addChild(_loc2_);
      }
      
      public function setInTeamPlayers(param1:Array) : void
      {
         var _loc3_:PlayerListButton = null;
         var _loc2_:int = 0;
         while(_loc2_ < items.length)
         {
            _loc3_ = PlayerListButton(items[_loc2_]);
            if(_loc3_.state == ListButton.IN_TEAM && param1.indexOf(_loc3_.player) < 0)
            {
               _loc3_.setDefault();
            }
            else if(param1.indexOf(_loc3_.player) >= 0)
            {
               _loc3_.setInTeam();
            }
            _loc2_++;
         }
      }
      
      public function setInSubs(param1:Array) : void
      {
         var _loc3_:PlayerListButton = null;
         var _loc2_:int = 0;
         while(_loc2_ < items.length)
         {
            _loc3_ = PlayerListButton(items[_loc2_]);
            if(_loc3_.state == ListButton.IN_SUBS && param1.indexOf(_loc3_.player) < 0)
            {
               _loc3_.setDefault();
            }
            else if(param1.indexOf(_loc3_.player) >= 0)
            {
               _loc3_.setInSubs();
            }
            _loc2_++;
         }
      }
      
      public function selectPlayer(param1:Player) : void
      {
         var _loc3_:PlayerListButton = null;
         var _loc2_:int = 0;
         while(_loc2_ < items.length)
         {
            _loc3_ = PlayerListButton(items[_loc2_]);
            if(_loc3_.player == param1)
            {
               _loc3_.setSelected();
            }
            else
            {
               _loc3_.removeSelected();
            }
            _loc2_++;
         }
      }
   }
}

