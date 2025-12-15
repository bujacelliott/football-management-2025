package com.utterlySuperb.chumpManager.view.ui.buttons.listButtons
{
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.text.TextHelper;
   import flash.text.TextField;
   
   public class TrainingHeader extends PlayerListButton
   {
      
      private var lightTraining:TextField;
      
      private var mediumTraining:TextField;
      
      private var heavyTraining:TextField;
      
      private var noTraining:TextField;
      
      public function TrainingHeader()
      {
         super();
         bWidth = Globals.GAME_WIDTH - Globals.MARGIN_X * 2 - 55;
         bHeight = 25;
         this.makeTrainingText(CopyManager.getCopy("position"),210);
         this.makeTrainingText(CopyManager.getCopy("stamina"),260);
         this.makeTrainingText(CopyManager.getCopy("rating"),310);
         this.makeTrainingText(CopyManager.getCopy("noTraining"),350);
         this.makeTrainingText(CopyManager.getCopy("lightTraining"),390);
         this.makeTrainingText(CopyManager.getCopy("mediumTraining"),430);
         this.makeTrainingText(CopyManager.getCopy("heavyTraining"),470);
         this.makeTrainingText(CopyManager.getCopy("heavyTraining"),470);
         this.makeTrainingText(CopyManager.getCopy("trainingType"),bWidth - 80);
         setBG(true);
         setBGCol(6710937);
      }
      
      private function makeTrainingText(param1:String, param2:int) : void
      {
         var _loc3_:TextField = new TextField();
         TextHelper.doTextField2(_loc3_,Styles.LIST_FONT,10,16777215);
         addChild(_loc3_);
         _loc3_.htmlText = param1;
         _loc3_.x = param2 - _loc3_.textWidth / 2;
         _loc3_.y = 5;
      }
   }
}

