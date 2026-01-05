package com.utterlySuperb.ui.dropDown
{
   import com.greensock.TweenLite;
   import com.utterlySuperb.events.StringEvent;
   import com.utterlySuperb.text.TextHelper;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class DropDown extends Sprite
   {
      
      public static const DROP_DOWN_CLICK:String = "dropDownClick";
      
      private var settings:DropDownSettings;
      
      private var openState:int;
      
      private var scrollDist:int;
      
      private var scrollStart:int;
      
      private var viewOffset:int;
      
      private var _selectedNum:int = -1;
      
      private var items:Array;
      
      private var ignores:Array;
      
      private var itemsBtns:Array;
      
      private var mainBtn:Sprite;
      
      private var itemsMc:Sprite;
      
      private var itemsMCMask:Sprite;
      
      private var scroller:Sprite;
      
      private var btnUp:MovieClip;
      
      private var btnDown:MovieClip;
      
      private var tf:TextField;
      
      public function DropDown(param1:Object)
      {
         super();
         this.settings = new DropDownSettings(param1);
         this.openState = 0;
         this.items = [];
         this.ignores = [];
         this.mainBtn = new Sprite();
         addChild(this.mainBtn);
         if(this.settings.btn)
         {
            this.mainBtn.addChild(this.settings.btn);
            this.settings.btn.x = this.settings.width - this.settings.btn.width;
         }
         this.tf = new TextField();
         this.mainBtn.addChild(this.tf);
         this.tf.y = -Math.floor(this.settings.fontSize / 14);
         this.tf.x = 1;
         this.tf.width = this.settings.btn ? this.settings.btn.x - 2 : this.settings.width - 2;
         this.tf.height = this.settings.height;
         TextHelper.doTextField2(this.tf,this.settings.font,this.settings.fontSize,this.settings.defFontColor,{"autoSize":TextFieldAutoSize.NONE});
         this.tf.text = this.settings.prompt;
         this.showDefault(null);
         this.enable();
      }
      
      public function easyMake(param1:int = 20) : void
      {
         this.settings.scrollbarBG = new Sprite();
         this.settings.scrollbarBG.graphics.beginFill(0x14552b);
         this.settings.scrollbarBG.graphics.drawRect(0,0,param1,param1);
         this.settings.scroller = new Sprite();
         this.settings.scroller.graphics.beginFill(0x1c7a3f);
         this.settings.scroller.graphics.drawRect(0,0,param1,param1);
         this.settings.btn = new MovieClip();
         this.settings.btn.graphics.beginFill(0x0d2f1b);
         this.settings.btn.graphics.drawRect(0,0,20,20);
         this.mainBtn.addChild(this.settings.btn);
         this.settings.btn.x = this.settings.width - this.settings.btn.width;
      }
      
      private function open() : void
      {
         this.viewOffset = Math.max(0,this.selectedNum - this.settings.numRows + 1);
         this.itemsBtns = [];
         this.itemsMc = new Sprite();
         addChild(this.itemsMc);
         this.itemsMCMask = new Sprite();
         addChild(this.itemsMCMask);
         this.itemsMCMask.graphics.beginFill(0);
         this.itemsMc.graphics.beginFill(this.settings.defBgColor);
         this.itemsMc.graphics.drawRect(0,0,this.settings.width,this.settings.height * Math.min(this.items.length,this.settings.numRows));
         var _loc1_:int = 0;
         while(_loc1_ < Math.min(this.items.length,this.settings.numRows))
         {
            this.itemsBtns[_loc1_] = new DropDownItem(this.settings);
            this.itemsBtns[_loc1_].y = this.settings.height * _loc1_;
            this.itemsMc.addChild(this.itemsBtns[_loc1_]);
            this.itemsBtns[_loc1_].addEventListener(DropDownItem.CLICK_DROPDOWN_ITEM,this.selectItem);
            _loc1_++;
         }
         if(this.settings.expandDown)
         {
            this.itemsMCMask.graphics.drawRect(0,this.settings.height,this.settings.width,this.settings.height * Math.min(this.items.length,this.settings.numRows));
            this.itemsMc.y = this.settings.height - this.itemsMCMask.height;
            TweenLite.to(this.itemsMc,0.5,{"y":this.settings.height});
         }
         else
         {
            this.itemsMCMask.graphics.drawRect(0,0,this.settings.width,-this.settings.height * Math.min(this.items.length,this.settings.numRows));
            this.itemsMc.y = 0;
            TweenLite.to(this.itemsMc,0.5,{"y":-this.itemsMCMask.height});
         }
         this.itemsMc.mask = this.itemsMCMask;
         this.populateItems();
         this.openState = 1;
         this.enableViewButtons();
         if(parent)
         {
            parent.setChildIndex(this,parent.numChildren - 1);
         }
      }
      
      private function close() : void
      {
         this.disableViewButtons();
         var _loc1_:int = 0;
         while(_loc1_ < this.itemsBtns.length)
         {
            this.itemsBtns[_loc1_].disable();
            this.itemsBtns[_loc1_].removeEventListener(DropDownItem.CLICK_DROPDOWN_ITEM,this.selectItem);
            _loc1_++;
         }
         if(this.settings.expandDown)
         {
            TweenLite.to(this.itemsMc,0.5,{
               "y":this.settings.height - this.itemsMCMask.height,
               "onComplete":this.finishClose
            });
         }
         else
         {
            TweenLite.to(this.itemsMc,0.5,{
               "y":0,
               "onComplete":this.finishClose
            });
         }
         this.openState = 2;
      }
      
      private function finishClose() : void
      {
         this.openState = 0;
         removeChild(this.itemsMc);
         this.itemsMc = null;
         removeChild(this.itemsMCMask);
         this.itemsMCMask = null;
         this.itemsBtns = null;
      }
      
      private function closeCheck(param1:MouseEvent) : void
      {
         var _loc2_:Point = localToGlobal(new Point(mouseX,mouseY));
         if(!hitTestPoint(_loc2_.x,_loc2_.y))
         {
            param1.stopPropagation();
            this.close();
         }
      }
      
      private function populateItems() : void
      {
         var _loc2_:String = null;
         var _loc1_:uint = 0;
         while(_loc1_ < Math.min(this.items.length,this.settings.numRows))
         {
            _loc2_ = this.items[_loc1_ + this.viewOffset];
            this.itemsBtns[_loc1_].setVal(_loc2_,_loc2_ == this.tf.text,!this.isIgnored(_loc2_) && _loc2_ != this.tf.text);
            _loc1_++;
         }
      }
      
      private function selectItem(param1:StringEvent) : void
      {
         this._selectedNum = this.itemsBtns.indexOf(param1.target) + this.viewOffset;
         this.tf.text = param1.str;
         dispatchEvent(new Event(DROP_DOWN_CLICK));
         this.close();
      }
      
      private function enableViewButtons() : void
      {
         var _loc1_:Sprite = null;
         stage.addEventListener(MouseEvent.MOUSE_DOWN,this.closeCheck);
         if(this.items.length > this.settings.numRows)
         {
            _loc1_ = new Sprite();
            this.itemsMc.addChild(_loc1_);
            this.scrollStart = 0;
            if(this.settings.scrollbarBG)
            {
               _loc1_.addChild(this.settings.scrollbarBG);
               this.settings.scrollbarBG.x = this.settings.width - this.settings.scrollbarBG.width;
               this.settings.scrollbarBG.height = this.itemsMCMask.height;
            }
            if(this.settings.scrollBarBtn)
            {
               this.btnUp = new this.settings.scrollBarBtn() as MovieClip;
               _loc1_.addChild(this.btnUp);
               this.btnUp.x = this.settings.width - this.btnUp.width;
               this.btnDown = new this.settings.scrollBarBtn() as MovieClip;
               _loc1_.addChild(this.btnDown);
               this.btnDown.x = this.settings.width - this.btnDown.width;
               this.btnDown.scaleY = -1;
               this.btnDown.y = this.itemsMCMask.height;
               this.scrollStart = this.btnUp.height;
               this.btnUp.buttonMode = this.btnDown.buttonMode = true;
               this.btnUp.addEventListener(MouseEvent.MOUSE_UP,this.scrollUp);
               this.btnDown.addEventListener(MouseEvent.MOUSE_UP,this.scrollDown);
            }
            if(this.settings.scroller)
            {
               this.setScrollerSize();
               _loc1_.addChild(this.settings.scroller);
               this.settings.scroller.x = Math.round(this.settings.width - this.settings.scroller.width);
               this.scrollDist = this.itemsMCMask.height - this.settings.scroller.height;
               if(this.btnUp)
               {
                  this.scrollDist -= this.btnUp.height * 2;
               }
               this.settings.scroller.buttonMode = true;
               this.settings.scroller.addEventListener(MouseEvent.MOUSE_DOWN,this.startScroll);
               this.placeScroller();
            }
         }
      }
      
      public function setScrollerSize() : void
      {
         var _loc1_:Number = this.settings.numRows / this.items.length;
         var _loc2_:int = this.itemsMCMask.height;
         if(this.btnUp)
         {
            _loc2_ -= this.btnUp.height;
         }
         if(this.btnDown)
         {
            _loc2_ -= this.btnDown.height;
         }
         this.settings.scroller.height = _loc2_ * _loc1_;
      }
      
      public function disableViewButtons() : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.closeCheck);
         if(this.settings.scroller)
         {
            this.settings.scroller.removeEventListener(MouseEvent.MOUSE_DOWN,this.startScroll);
            if(this.settings.scroller.hasEventListener(Event.ENTER_FRAME))
            {
               this.settings.scroller.removeEventListener(Event.ENTER_FRAME,this.doScroll);
               stage.removeEventListener(MouseEvent.MOUSE_UP,this.stopScroll);
            }
         }
         if(this.btnUp)
         {
            this.btnUp.removeEventListener(MouseEvent.MOUSE_UP,this.scrollUp);
            this.btnDown.removeEventListener(MouseEvent.MOUSE_UP,this.scrollDown);
         }
      }
      
      private function scrollUp(param1:MouseEvent) : void
      {
         this.viewOffset = Math.max(this.viewOffset - 1,0);
         this.populateItems();
         this.placeScroller();
      }
      
      private function scrollDown(param1:MouseEvent) : void
      {
         this.viewOffset = Math.min(this.viewOffset + 1,this.items.length - this.settings.numRows);
         this.populateItems();
         this.placeScroller();
      }
      
      private function placeScroller() : void
      {
         if(this.settings.scroller)
         {
            this.settings.scroller.y = this.scrollStart + this.scrollDist / (this.items.length - this.settings.numRows) * this.viewOffset;
         }
      }
      
      private function doScroll(param1:Event) : void
      {
         this.viewOffset = Math.floor((this.items.length - this.settings.numRows) / this.scrollDist * (this.settings.scroller.y - this.scrollStart));
         this.populateItems();
      }
      
      private function startScroll(param1:MouseEvent) : void
      {
         var _loc2_:Rectangle = new Rectangle(this.settings.scroller.x,this.scrollStart,0,this.scrollDist);
         this.settings.scroller.startDrag(false,_loc2_);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.stopScroll,true);
         this.settings.scroller.addEventListener(Event.ENTER_FRAME,this.doScroll);
      }
      
      private function stopScroll(param1:MouseEvent) : void
      {
         this.settings.scroller.removeEventListener(Event.ENTER_FRAME,this.doScroll);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.stopScroll,true);
         this.settings.scroller.stopDrag();
         param1.stopPropagation();
      }
      
      public function addItem(param1:String) : void
      {
         this.items.push(param1);
      }
      
      public function depopulate() : void
      {
         this.items = [];
      }
      
      public function addIgnore(param1:String) : void
      {
         this.ignores.push(param1);
      }
      
      public function validate() : Boolean
      {
         return this.tf.text != this.settings.prompt;
      }
      
      public function isIgnored(param1:String) : Boolean
      {
         return this.ignores.indexOf(param1) >= 0;
      }
      
      public function get selectedNum() : int
      {
         return this._selectedNum;
      }
      
      public function set selectedNum(param1:int) : void
      {
         this._selectedNum = param1;
         if(param1 < 0)
         {
            this.tf.text = this.settings.prompt;
         }
         else if(param1 < this.items.length)
         {
            this.tf.text = this.items[param1];
         }
      }
      
      public function get value() : String
      {
         return this.tf.text;
      }
      
      public function set value(param1:String) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:uint = 0;
         while(_loc3_ < this.items.length)
         {
            if(this.items[_loc3_] == param1)
            {
               _loc2_ = true;
            }
            _loc3_++;
         }
         if(_loc2_)
         {
            this.tf.text = param1;
         }
      }
      
      private function showDefault(param1:MouseEvent) : void
      {
         this.gotoBtnState("_up",1);
         this.mainBtn.graphics.clear();
         this.mainBtn.graphics.lineStyle(this.settings.defLineThickness,this.settings.defLineColor,this.settings.defLineAlpha);
         this.mainBtn.graphics.beginFill(this.settings.defBgColor,this.settings.defBgAlpha);
         this.mainBtn.graphics.drawRect(0,0,this.settings.width,this.settings.height);
         this.tf.textColor = this.settings.defFontColor;
      }
      
      private function showOver(param1:MouseEvent) : void
      {
         this.gotoBtnState("_over",1);
         this.mainBtn.graphics.clear();
         this.mainBtn.graphics.lineStyle(this.settings.overLineThickness,this.settings.overLineColor,this.settings.overLineAlpha);
         this.mainBtn.graphics.beginFill(this.settings.overBgColor,this.settings.overBgAlpha);
         this.mainBtn.graphics.drawRect(0,0,this.settings.width,this.settings.height);
         this.tf.textColor = this.settings.overFontColor;
      }

      private function gotoBtnState(param1:String, param2:int) : void
      {
         if(!this.settings.btn)
         {
            return;
         }
         try
         {
            if(this.hasLabel(this.settings.btn,param1))
            {
               this.settings.btn.gotoAndStop(param1);
            }
            else
            {
               this.settings.btn.gotoAndStop(param2);
            }
         }
         catch(e:Error)
         {
         }
      }

      private function hasLabel(param1:MovieClip, param2:String) : Boolean
      {
         var _loc3_:int = 0;
         if(!param1)
         {
            return false;
         }
         _loc3_ = 0;
         while(_loc3_ < param1.currentLabels.length)
         {
            if(param1.currentLabels[_loc3_].name == param2)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      private function click(param1:MouseEvent) : void
      {
         if(this.openState == 1)
         {
            this.close();
         }
         else if(this.openState == 0)
         {
            this.open();
         }
      }
      
      public function disableButton() : void
      {
         if(this.openState == 1)
         {
            this.close();
         }
         this.mainBtn.removeEventListener(MouseEvent.MOUSE_UP,this.click);
         this.mainBtn.removeEventListener(MouseEvent.MOUSE_OVER,this.showOver);
         this.mainBtn.removeEventListener(MouseEvent.MOUSE_OUT,this.showDefault);
      }
      
      public function enable() : void
      {
         this.mainBtn.addEventListener(MouseEvent.MOUSE_UP,this.click);
         this.mainBtn.addEventListener(MouseEvent.MOUSE_OVER,this.showOver);
         this.mainBtn.addEventListener(MouseEvent.MOUSE_OUT,this.showDefault);
      }
   }
}

