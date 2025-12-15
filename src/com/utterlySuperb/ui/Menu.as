package com.utterlySuperb.ui
{
   import com.greensock.TweenLite;
   import com.utterlySuperb.events.IntEvent;
   import com.utterlySuperb.ui.buttons.AssetButton;
   import com.utterlySuperb.ui.buttons.GenericButton;
   import com.utterlySuperb.ui.buttons.TextButton;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class Menu extends Sprite
   {
      
      public static const MENU_OUT:String = "menuOut";
      
      public static const MENU_CLICK:String = "menuCLick";
      
      public static const BLUR:String = "blur";
      
      public static const ALPHA:String = "alpha";
      
      public static const LEFT:String = "left";
      
      public static const RIGHT:String = "right";
      
      public static const TOP:String = "top";
      
      public static const BOTTOM:String = "BOTTOM";
      
      protected var buttonClass:Class;
      
      protected var buttonsA:Array;
      
      protected var itemsA:Array;
      
      private var _inTransitions:Array;
      
      private var _outTransitions:Array;
      
      public var tweenDelay:Number = 0.1;
      
      private var inDelay:Number = 0;
      
      private var outDelay:Number = 0;
      
      private var areaWidth:int;
      
      private var areaHeight:int;
      
      protected var ySpacing:int = 10;
      
      public var isShowing:Boolean;
      
      public var centerAlign:Boolean = true;
      
      public var tweenTime:Number = 0.5;
      
      public function Menu(param1:int = 0, param2:int = 0)
      {
         var x:int = param1;
         var y:int = param2;
         this.buttonClass = TextButton;
         this._inTransitions = [ALPHA];
         this._outTransitions = [ALPHA];
         super();
         this.x = x;
         this.y = y;
         this.buttonsA = [];
         this.itemsA = [];
         try
         {
            this.setDimensions(Globals.GAME_WIDTH,Globals.GAME_HEIGHT);
         }
         catch(e:Error)
         {
            setDimensions(0,0);
         }
      }
      
      private function setDimensions(param1:int, param2:int) : void
      {
         this.areaWidth = param1;
         this.areaHeight = param2;
      }
      
      protected function clickButton(param1:Event) : void
      {
         dispatchEvent(new IntEvent(MENU_CLICK,this.buttonsA.indexOf(param1.target)));
      }
      
      protected function makeButton(param1:String, param2:Array = null) : TextButton
      {
         var _loc3_:TextButton = new this.buttonClass();
         _loc3_.setText(param1);
         this.buttonsA.push(_loc3_);
         this.itemsA.push(_loc3_);
         addChild(_loc3_);
         _loc3_.x = this.centerAlign ? -int(_loc3_.width / 2) : 0;
         if(this.buttonsA.length > 1)
         {
            _loc3_.y = GenericButton(this.buttonsA[this.buttonsA.length - 2]).y + GenericButton(this.buttonsA[this.buttonsA.length - 2]).height + this.ySpacing;
         }
         return _loc3_;
      }
      
      protected function addAsset(param1:DisplayObject) : DisplayObject
      {
         var _loc2_:DisplayObject = null;
         this.itemsA.push(param1);
         addChild(param1);
         param1.x = -param1.width / 2;
         if(this.itemsA.length > 1)
         {
            _loc2_ = this.itemsA[this.itemsA.length - 2];
            param1.y = _loc2_.y + _loc2_.height + 10;
         }
         return param1;
      }
      
      protected function addMovieBtn(param1:DisplayObject) : AssetButton
      {
         var _loc3_:DisplayObject = null;
         var _loc2_:AssetButton = new AssetButton(param1);
         this.buttonsA.push(_loc2_);
         this.itemsA.push(_loc2_);
         addChild(_loc2_);
         if(this.itemsA.length > 1)
         {
            _loc3_ = this.itemsA[this.itemsA.length - 2];
            _loc2_.y = _loc3_.y + _loc3_.height + 10;
         }
         return _loc2_;
      }
      
      public function enable() : void
      {
         var _loc2_:GenericButton = null;
         var _loc1_:uint = 0;
         while(_loc1_ < this.buttonsA.length)
         {
            _loc2_ = this.buttonsA[_loc1_] as GenericButton;
            _loc2_.activate();
            _loc2_.addEventListener(GenericButton.BUTTON_CLICK,this.clickButton);
            _loc1_++;
         }
      }
      
      public function disable() : void
      {
         var _loc2_:GenericButton = null;
         var _loc1_:uint = 0;
         while(_loc1_ < this.buttonsA.length)
         {
            _loc2_ = this.buttonsA[_loc1_] as GenericButton;
            _loc2_.deactivate();
            _loc2_.removeEventListener(GenericButton.BUTTON_CLICK,this.clickButton);
            _loc1_++;
         }
      }
      
      public function tweenIn() : void
      {
         var _loc3_:int = 0;
         var _loc1_:Object = {};
         var _loc2_:int = 0;
         while(_loc2_ < this.inTransitions.length)
         {
            switch(this.inTransitions[_loc2_])
            {
               case BLUR:
                  _loc1_.blurFilter = {"blurX":20};
                  break;
               case ALPHA:
                  _loc1_.alpha = 0;
            }
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.itemsA.length)
         {
            _loc3_ = 0;
            while(_loc3_ < this.inTransitions.length)
            {
               switch(this.inTransitions[_loc3_])
               {
                  case LEFT:
                     _loc1_.x = -x - this.itemsA[_loc2_].width;
                     break;
                  case RIGHT:
                     _loc1_.x = this.areaWidth - x;
                     break;
                  case TOP:
                     _loc1_.y = -y - this.itemsA[_loc2_].height;
                     break;
                  case BOTTOM:
                     _loc1_.y = this.areaHeight - y;
               }
               _loc1_.delay = this.inDelay + this.tweenDelay * _loc2_;
               _loc3_++;
            }
            if(_loc2_ == this.itemsA.length - 1)
            {
               _loc1_.onComplete = this.isIn;
            }
            TweenLite.from(this.itemsA[_loc2_],this.tweenTime,_loc1_);
            _loc2_++;
         }
      }
      
      public function remove() : void
      {
         var _loc3_:int = 0;
         this.disable();
         var _loc1_:Object = {};
         var _loc2_:int = 0;
         while(_loc2_ < this.inTransitions.length)
         {
            switch(this.inTransitions[_loc2_])
            {
               case BLUR:
                  _loc1_.blurFilter = {"blurX":20};
                  break;
               case ALPHA:
                  _loc1_.alpha = 0;
            }
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.itemsA.length)
         {
            _loc3_ = 0;
            while(_loc3_ < this.inTransitions.length)
            {
               switch(this.inTransitions[_loc3_])
               {
                  case LEFT:
                     _loc1_.x = -x - this.itemsA[_loc2_].width;
                     break;
                  case RIGHT:
                     _loc1_.x = this.areaWidth - x;
                     break;
                  case TOP:
                     _loc1_.y = -y - this.itemsA[_loc2_].height;
                     break;
                  case BOTTOM:
                     _loc1_.y = this.areaHeight - y;
               }
               _loc1_.delay = this.outDelay + this.tweenDelay * _loc2_;
               _loc3_++;
            }
            if(_loc2_ == this.itemsA.length - 1)
            {
               _loc1_.onComplete = this.isOut;
            }
            TweenLite.to(this.itemsA[_loc2_],this.tweenTime,_loc1_);
            _loc2_++;
         }
      }
      
      protected function isIn() : void
      {
         this.enable();
         this.isShowing = true;
      }
      
      protected function isOut() : void
      {
         this.isShowing = false;
         dispatchEvent(new Event(Menu.MENU_OUT));
      }
      
      public function get inTransitions() : Array
      {
         return this._inTransitions;
      }
      
      public function set inTransitions(param1:Array) : void
      {
         this._inTransitions = param1;
      }
      
      public function get outTransitions() : Array
      {
         return this._outTransitions;
      }
      
      public function set outTransitions(param1:Array) : void
      {
         this._outTransitions = param1;
      }
   }
}

