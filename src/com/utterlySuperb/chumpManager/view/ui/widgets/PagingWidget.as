package com.utterlySuperb.chumpManager.view.ui.widgets
{
   import com.utterlySuperb.chumpManager.view.ui.buttons.ChumpButton;
   import com.utterlySuperb.chumpManager.view.ui.buttons.PagingButton;
   import com.utterlySuperb.events.IntEvent;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class PagingWidget extends Sprite
   {
      
      public static const GOTO_PAGE:String = "gotoPage";
      
      private var tf:TextField;
      
      private var pagingButtons:Vector.<ChumpButton>;
      
      private var buttonsHolder:Sprite;
      
      private var leftBtn:ChumpButton;
      
      private var rightBtn:ChumpButton;
      
      private var currentPage:int;
      
      private var numPages:int;
      
      private var offset:int;
      
      private var maxBtns:int;
      
      public function PagingWidget(param1:int = 6)
      {
         super();
         this.maxBtns = param1;
      }
      
      public function setValues(param1:int, param2:int, param3:int = 0) : void
      {
         var _loc6_:ChumpButton = null;
         this.currentPage = param1;
         this.numPages = param2;
         this.offset = param3;
         if(this.pagingButtons)
         {
            this.cleanUp();
         }
         this.pagingButtons = new Vector.<ChumpButton>();
         this.buttonsHolder = new Sprite();
         addChild(this.buttonsHolder);
         var _loc4_:int = param3 > 0 ? int(Math.min(this.maxBtns - 1,param2)) : int(Math.min(this.maxBtns,param2));
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = new PagingButton();
            _loc6_.setText((param3 + _loc5_ + 1).toString());
            this.buttonsHolder.addChild(_loc6_);
            this.pagingButtons.push(_loc6_);
            if(param3 + _loc5_ == param1)
            {
               _loc6_.deactivate(true);
            }
            else
            {
               _loc6_.activate();
               _loc6_.addEventListener(MouseEvent.CLICK,this.clickPaginButton);
            }
            if(_loc5_ > 0)
            {
               _loc6_.x = this.pagingButtons[_loc5_ - 1].x + this.pagingButtons[_loc5_ - 1].width + 5;
            }
            _loc5_++;
         }
         if(this.maxBtns < param2)
         {
            if(param3 > 0)
            {
               this.leftBtn = new PagingButton();
               this.leftBtn.setText("<");
               addChild(this.leftBtn);
               this.leftBtn.addEventListener(MouseEvent.CLICK,this.clickOffsetButton);
               this.leftBtn.activate();
               this.buttonsHolder.x = this.leftBtn.width + 5;
            }
            if(param3 + this.maxBtns < param2)
            {
               this.rightBtn = new PagingButton();
               this.rightBtn.setText(">");
               addChild(this.rightBtn);
               this.rightBtn.addEventListener(MouseEvent.CLICK,this.clickOffsetButton);
               this.rightBtn.activate();
               this.rightBtn.x = this.buttonsHolder.x + this.buttonsHolder.width + 5;
            }
         }
      }
      
      public function cleanUp() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.pagingButtons.length)
         {
            this.pagingButtons[_loc1_].deactivate();
            this.pagingButtons[_loc1_].removeEventListener(MouseEvent.CLICK,this.clickPaginButton);
            _loc1_++;
         }
         removeChild(this.buttonsHolder);
         if(this.leftBtn)
         {
            removeChild(this.leftBtn);
            this.leftBtn.removeEventListener(MouseEvent.CLICK,this.clickOffsetButton);
            this.leftBtn = null;
         }
         if(this.rightBtn)
         {
            removeChild(this.rightBtn);
            this.rightBtn.removeEventListener(MouseEvent.CLICK,this.clickOffsetButton);
            this.rightBtn = null;
         }
      }
      
      private function clickOffsetButton(param1:MouseEvent) : void
      {
         if(param1.target == this.leftBtn)
         {
            this.setValues(this.currentPage,this.numPages,this.offset - 1);
         }
         else
         {
            this.setValues(this.currentPage,this.numPages,this.offset + 1);
         }
      }
      
      private function clickPaginButton(param1:MouseEvent) : void
      {
         var _loc2_:int = int(this.pagingButtons.indexOf(param1.currentTarget as ChumpButton));
         dispatchEvent(new IntEvent(GOTO_PAGE,_loc2_ + this.offset));
      }
   }
}

