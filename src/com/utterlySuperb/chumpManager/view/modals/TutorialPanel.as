package com.utterlySuperb.chumpManager.view.modals
{
   import com.utterlySuperb.text.TextHelper;
   import com.utterlySuperb.ui.Checkbox;
   import com.utterlySuperb.ui.ModalDialogue;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.SharedObject;
   import flash.text.TextField;
   
   public class TutorialPanel extends ModalDialogue
   {
      
      private static var exlcudes:Array = [];
      
      private var showAgainCheck:Checkbox;
      
      private var closureFunction:Function;
      
      private var checkBox:Checkbox;
      
      public function TutorialPanel(param1:String, param2:String, param3:Array)
      {
         var _loc4_:XMLList = new XMLList();
         buttonOffset = 20;
         super(_loc4_.title.text() + "<br><br> ",_loc4_.description.text(),["OK"]);
         var _loc5_:TextField = new TextField();
         TextHelper.doTextField2(_loc5_,Styles.MAIN_FONT,12,16777215);
         _loc5_.htmlText = "Show tutorials";
         _loc5_.x = box.width - 20 - _loc5_.width;
         _loc5_.y = buttons[0].y - 20;
         box.addChild(_loc5_);
         this.checkBox = new Checkbox();
         this.checkBox.ticked = true;
         box.addChild(this.checkBox);
         this.checkBox.addEventListener(MouseEvent.CLICK,this.clickTick);
         this.checkBox.activate();
         this.checkBox.x = _loc5_.x + 5;
         this.checkBox.y = _loc5_.y + 22;
         seenTutorial(param1,true);
      }
      
      public static function shouldShow(param1:String) : Boolean
      {
         var _loc2_:SharedObject = SharedObject.getLocal("chumpOptions");
         if(Boolean(_loc2_.data.disableTutorials) || modalShowing)
         {
            return false;
         }
         if(!_loc2_.data.tutorialSeen)
         {
            _loc2_.data.tutorialSeen = [];
         }
         else if(_loc2_.data.tutorialSeen[param1])
         {
            return false;
         }
         return true;
      }
      
      public static function get disableTutorial() : Boolean
      {
         var _loc1_:SharedObject = SharedObject.getLocal("chumpOptions");
         if(_loc1_.data.disableTutorials)
         {
            return true;
         }
         return false;
      }
      
      public static function set disableTutorial(param1:Boolean) : void
      {
         var _loc2_:SharedObject = SharedObject.getLocal("chumpOptions");
         _loc2_.data.disableTutorials = param1;
         _loc2_.flush(Globals.SAVE_VOLUME_OPTIONS);
      }
      
      public static function seenTutorial(param1:String, param2:Boolean = true) : void
      {
         var _loc3_:SharedObject = SharedObject.getLocal("chumpOptions");
         if(!_loc3_.data.tutorialSeen)
         {
            _loc3_.data.tutorialSeen = [];
         }
         _loc3_.data.tutorialSeen[param1] = param2;
         _loc3_.flush(Globals.SAVE_VOLUME_OPTIONS);
      }
      
      public static function resetTutorials() : void
      {
         var _loc1_:SharedObject = SharedObject.getLocal("chumpOptions");
         _loc1_.data.tutorialSeen = [];
         _loc1_.flush(Globals.SAVE_VOLUME_OPTIONS);
      }
      
      private function clickTick(param1:MouseEvent) : void
      {
         disableTutorial = !this.checkBox.ticked;
      }
      
      override protected function makeChoiceHandler(param1:Event) : void
      {
         this.checkBox.removeEventListener(MouseEvent.CLICK,this.clickTick);
         this.checkBox.deactivate();
         super.makeChoiceHandler(param1);
         Main.instance.removeModal(this);
      }
   }
}

