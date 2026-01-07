package com.utterlySuperb.chumpManager.view.panels
{
import com.utterlySuperb.chumpManager.model.CopyManager;
import com.utterlySuperb.chumpManager.view.ui.ChumpListBox;
import com.utterlySuperb.chumpManager.view.ui.buttons.ListButton;
import com.utterlySuperb.chumpManager.view.ui.buttons.listButtons.TransferSummaryListButton;
import com.utterlySuperb.text.TextHelper;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.text.TextField;
   
   public class TransfersSummaryPanel extends Panel
   {
      
      private var title:TextField;
      
      private var list:ChumpListBox;
      
      private var mode:int = 0;
      
      private var leftArrow:Sprite;
      
      private var rightArrow:Sprite;

      private var sliderTrack:Sprite;

      private var sliderThumb:Sprite;

      private var isDragging:Boolean = false;

      private var maxRowScroll:int = 0;
      
      public function TransfersSummaryPanel(param1:int = 260, param2:int = 220)
      {
         super();
         this.boxWidth = param1;
         this.boxHeight = param2;
      }
      
      override protected function init() : void
      {
         makeBox(this.boxWidth,this.boxHeight,0,0);
         this.title = new TextField();
         TextHelper.doTextField2(this.title,Styles.HEADER_FONT,18,16777215);
         this.title.y = 5;
         addChild(this.title);
         this.list = new ChumpListBox(this.boxWidth - 30,this.boxHeight - 65);
         this.list.x = 15;
         this.list.y = 35;
         this.list.drawFrame();
         addChild(this.list);
         this.leftArrow = this.makeArrow(true);
         this.rightArrow = this.makeArrow(false);
         this.leftArrow.x = 10;
         this.leftArrow.y = this.boxHeight - 25;
         this.rightArrow.x = this.boxWidth - 20;
         this.rightArrow.y = this.boxHeight - 25;
         this.leftArrow.addEventListener(MouseEvent.CLICK,this.toggleMode);
         this.rightArrow.addEventListener(MouseEvent.CLICK,this.toggleMode);
         addChild(this.leftArrow);
         addChild(this.rightArrow);
         this.buildSlider();
         this.update();
      }

      private function buildSlider() : void
      {
         var _loc1_:int = this.boxWidth - 70;
         this.sliderTrack = new Sprite();
         this.sliderTrack.graphics.lineStyle(1,16777215);
         this.sliderTrack.graphics.beginFill(4210752);
         this.sliderTrack.graphics.drawRect(0,0,_loc1_,6);
         this.sliderTrack.graphics.endFill();
         this.sliderTrack.x = 35;
         this.sliderTrack.y = this.boxHeight - 12;
         addChild(this.sliderTrack);
         this.sliderThumb = new Sprite();
         this.sliderThumb.graphics.lineStyle(1,16777215);
         this.sliderThumb.graphics.beginFill(16776960);
         this.sliderThumb.graphics.drawRect(0,0,28,10);
         this.sliderThumb.graphics.endFill();
         this.sliderThumb.x = this.sliderTrack.x;
         this.sliderThumb.y = this.sliderTrack.y - 2;
         this.sliderThumb.buttonMode = true;
        this.sliderThumb.mouseChildren = false;
        this.sliderThumb.addEventListener(MouseEvent.MOUSE_DOWN,this.startSliderDrag);
        addChild(this.sliderThumb);
      }
      
      private function makeArrow(param1:Boolean) : Sprite
      {
         var _loc2_:Sprite = new Sprite();
         _loc2_.graphics.beginFill(16777215);
         if(param1)
         {
            _loc2_.graphics.moveTo(12,0);
            _loc2_.graphics.lineTo(0,10);
            _loc2_.graphics.lineTo(12,20);
         }
         else
         {
            _loc2_.graphics.moveTo(0,0);
            _loc2_.graphics.lineTo(12,10);
            _loc2_.graphics.lineTo(0,20);
         }
         _loc2_.graphics.endFill();
         _loc2_.buttonMode = true;
         _loc2_.mouseChildren = false;
         return _loc2_;
      }
      
      private function toggleMode(param1:Event) : void
      {
         this.mode = this.mode == 0 ? 1 : 0;
         this.update();
      }
      
      override protected function update(param1:Object = null) : void
      {
         var _loc2_:ListButton = null;
         this.list.depopulate();
         this.title.htmlText = this.mode == 0 ? "Top Transfers (World)" : "Latest Transfers (World)";
         this.title.x = (this.boxWidth - this.title.textWidth) / 2;
         var _loc3_:Array = Main.currentGame.transferHistory ? Main.currentGame.transferHistory.concat() : [];
         if(_loc3_.length == 0)
         {
            _loc2_ = new ListButton();
            _loc2_.bWidth = this.boxWidth - 30;
            _loc2_.bHeight = 28;
            _loc2_.setBG(false);
            _loc2_.setText("No transfer data yet");
            _loc2_.mouseEnabled = false;
            this.list.addItem(_loc2_);
            this.list.enable();
            return;
         }
         if(this.mode == 0)
         {
            _loc3_.sort(function(a:Object, b:Object) : Number
            {
               return b.fee - a.fee;
            });
         }
         else
         {
            _loc3_.sort(function(a:Object, b:Object) : Number
            {
               if(a.season != b.season)
               {
                  return b.season - a.season;
               }
               return b.week - a.week;
            });
         }
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc2_ = new TransferSummaryListButton();
            _loc2_.bWidth = this.boxWidth - 30;
            _loc2_.bHeight = 28;
            _loc2_.setBG(_loc4_ % 2 == 0);
            _loc2_.setText(formatTransfer(_loc3_[_loc4_]));
            _loc2_.mouseEnabled = false;
            this.list.addItem(_loc2_);
            _loc4_++;
         }
         this.list.enable();
         this.updateMaxRowScroll();
         this.updateSliderState();
      }

      private function updateMaxRowScroll() : void
      {
         var _loc1_:Array = this.list.getItems();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_.length)
         {
            if(_loc1_[_loc3_] is TransferSummaryListButton)
            {
               _loc2_ = Math.max(_loc2_,TransferSummaryListButton(_loc1_[_loc3_]).maxScroll);
            }
            _loc3_++;
         }
         this.maxRowScroll = _loc2_;
         _loc3_ = 0;
         while(_loc3_ < _loc1_.length)
         {
            if(_loc1_[_loc3_] is TransferSummaryListButton)
            {
               TransferSummaryListButton(_loc1_[_loc3_]).setMaxScrollH(this.maxRowScroll);
            }
            _loc3_++;
         }
      }

      private function updateSliderState() : void
      {
         this.sliderTrack.visible = true;
         this.sliderThumb.visible = true;
         this.sliderThumb.mouseEnabled = true;
         this.sliderThumb.x = this.sliderTrack.x;
         this.applyHorizontalScroll(0);
         if(this.sliderTrack.parent)
         {
            setChildIndex(this.sliderTrack,numChildren - 1);
         }
         if(this.sliderThumb.parent)
         {
            setChildIndex(this.sliderThumb,numChildren - 1);
         }
      }

      private function formatTransfer(param1:Object) : String
      {
         var _loc2_:String = param1.player + " — " + param1.fromClub + " → " + param1.toClub;
         var _loc3_:String = CopyManager.getCurrency() + TextHelper.prettifyNumber(param1.fee);
         return _loc2_ + " (" + _loc3_ + ")";
      }
      
      override protected function cleanUp() : void
      {
         if(this.list)
         {
            this.list.disable();
         }
         if(this.leftArrow)
         {
            this.leftArrow.removeEventListener(MouseEvent.CLICK,this.toggleMode);
         }
         if(this.rightArrow)
         {
            this.rightArrow.removeEventListener(MouseEvent.CLICK,this.toggleMode);
         }
         if(this.sliderThumb)
         {
            this.sliderThumb.removeEventListener(MouseEvent.MOUSE_DOWN,this.startSliderDrag);
         }
         this.stopSliderDrag();
      }

      private function startSliderDrag(param1:MouseEvent) : void
      {
         if(!stage)
         {
            return;
         }
         this.isDragging = true;
         this.sliderThumb.startDrag(false,new Rectangle(this.sliderTrack.x,this.sliderThumb.y,this.sliderTrack.width - this.sliderThumb.width,0));
         stage.addEventListener(MouseEvent.MOUSE_UP,this.stopSliderDrag,true);
         addEventListener(Event.ENTER_FRAME,this.updateSliderScroll);
      }

      private function stopSliderDrag(param1:MouseEvent = null) : void
      {
         if(!this.isDragging)
         {
            return;
         }
         this.isDragging = false;
         if(stage)
         {
            stage.removeEventListener(MouseEvent.MOUSE_UP,this.stopSliderDrag,true);
         }
         this.sliderThumb.stopDrag();
         removeEventListener(Event.ENTER_FRAME,this.updateSliderScroll);
         this.updateSliderScroll();
      }

      private function updateSliderScroll(param1:Event = null) : void
      {
         var _loc2_:Number = this.sliderTrack.width - this.sliderThumb.width;
         if(_loc2_ <= 0)
         {
            return;
         }
         var _loc3_:Number = (this.sliderThumb.x - this.sliderTrack.x) / _loc2_;
         this.applyHorizontalScroll(_loc3_);
      }

      private function applyHorizontalScroll(param1:Number) : void
      {
         var _loc2_:Array = this.list.getItems();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(_loc2_[_loc3_] is TransferSummaryListButton)
            {
               TransferSummaryListButton(_loc2_[_loc3_]).setScrollPercent(param1);
            }
            _loc3_++;
         }
      }
   }
}
