package com.utterlySuperb.ui
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class CheckboxGroup extends EventDispatcher
   {
      
      public var checkBoxes:Vector.<Checkbox>;
      
      private var lastBox:int;
      
      private var _currentBox:int;
      
      public var defaultBox:int;
      
      public function CheckboxGroup()
      {
         super();
         this.checkBoxes = new Vector.<Checkbox>();
         this._currentBox = this.lastBox = this.defaultBox = -1;
      }
      
      public function addCheckbox(param1:Checkbox) : void
      {
         if(this.checkBoxes.indexOf(param1) < 0)
         {
            this.checkBoxes.push(param1);
            param1.addEventListener(Checkbox.CHECK_CLICKED,this.checkBoxClickedHandler);
         }
      }
      
      public function removeCheckbox(param1:Checkbox) : void
      {
         if(this.checkBoxes.indexOf(param1) >= 0)
         {
            if(this.lastBox == this.checkBoxes.indexOf(param1))
            {
               this.lastBox = this.defaultBox;
            }
            if(this._currentBox == this.checkBoxes.indexOf(param1))
            {
               this._currentBox = this.lastBox;
               if(this._currentBox >= 0)
               {
                  this.checkBoxes[this._currentBox].ticked = true;
               }
            }
         }
      }
      
      public function activate() : void
      {
         var _loc1_:Checkbox = null;
         for each(_loc1_ in this.checkBoxes)
         {
            _loc1_.activate();
         }
      }
      
      public function deactivate() : void
      {
         var _loc1_:Checkbox = null;
         for each(_loc1_ in this.checkBoxes)
         {
            _loc1_.deactivate();
         }
      }
      
      private function checkBoxClickedHandler(param1:Event) : void
      {
         var _loc2_:int = 0;
         this.lastBox = this._currentBox;
         if(Checkbox(param1.target).ticked)
         {
            _loc2_ = 0;
            while(_loc2_ < this.checkBoxes.length)
            {
               if(this.checkBoxes[_loc2_] != param1.target)
               {
                  this.checkBoxes[_loc2_].ticked = false;
               }
               else
               {
                  this._currentBox = _loc2_;
               }
               _loc2_++;
            }
         }
         else if(this.defaultBox >= 0)
         {
            this.checkBoxes[this.defaultBox].ticked = true;
            this._currentBox = this.defaultBox;
         }
         else if(this.lastBox >= 0)
         {
            this.checkBoxes[this.lastBox].ticked = true;
            this._currentBox = this.lastBox;
         }
         dispatchEvent(new Event(Checkbox.CHECK_CLICKED));
      }
      
      public function get currentBox() : int
      {
         return this._currentBox;
      }
      
      public function set currentBox(param1:int) : void
      {
         var _loc2_:int = 0;
         if(this._currentBox != param1)
         {
            this.lastBox = this._currentBox;
            _loc2_ = 0;
            while(_loc2_ < this.checkBoxes.length)
            {
               this.checkBoxes[_loc2_].ticked = _loc2_ == param1;
               _loc2_++;
            }
         }
         this._currentBox = param1;
      }
   }
}

