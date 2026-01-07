package com.utterlySuperb.chumpManager.view.ui.buttons.listButtons
{
   import com.utterlySuperb.chumpManager.model.dataObjects.competitions.CompetitionInfo;
   import com.utterlySuperb.chumpManager.view.ui.buttons.ListButton;
   import com.utterlySuperb.text.TextHelper;
   import flash.text.TextField;
   import flash.text.TextFormatAlign;
   
   public class LeagueCompactRowListButton extends ListButton
   {
      
      private var gamesTF:TextField;
      
      private var winsTF:TextField;
      
      private var drawsTF:TextField;
      
      private var losesTF:TextField;
      
      private var pointsTF:TextField;
      
      public function LeagueCompactRowListButton()
      {
         super();
         mouseEnabled = false;
      }
      
      private function addTextField(param1:int, param2:int = 22) : TextField
      {
         var _loc3_:TextField = new TextField();
         TextHelper.doTextField2(_loc3_,Styles.MAIN_FONT,13,16777215,{"align":TextFormatAlign.CENTER});
         _loc3_.x = param1;
         _loc3_.y = 3;
         _loc3_.width = param2;
         addChild(_loc3_);
         return _loc3_;
      }
      
      override protected function makeTextField() : void
      {
         tf = this.addTextField(3,130);
         this.gamesTF = this.addTextField(140);
         this.winsTF = this.addTextField(165);
         this.drawsTF = this.addTextField(190);
         this.losesTF = this.addTextField(215);
         this.pointsTF = this.addTextField(245);
         this.applyLayout();
      }
      
      public function applyLayout() : void
      {
         var _loc1_:int = 3;
         var _loc2_:int = 22;
         var _loc3_:int = Math.max(90,bWidth - (_loc2_ * 5) - 15);
         tf.x = _loc1_;
         tf.width = _loc3_;
         _loc1_ += _loc3_ + 5;
         this.gamesTF.x = _loc1_;
         _loc1_ += _loc2_;
         this.winsTF.x = _loc1_;
         _loc1_ += _loc2_;
         this.drawsTF.x = _loc1_;
         _loc1_ += _loc2_;
         this.losesTF.x = _loc1_;
         _loc1_ += _loc2_;
         this.pointsTF.x = _loc1_;
      }
      
      public function applySimpleLayout() : void
      {
         var _loc1_:int = 3;
         var _loc2_:int = 28;
         var _loc3_:int = Math.max(140,bWidth - (_loc2_ * 2) - 15);
         tf.x = _loc1_;
         tf.width = _loc3_;
         _loc1_ += _loc3_ + 5;
         this.gamesTF.x = _loc1_;
         _loc1_ += _loc2_;
         this.pointsTF.x = _loc1_;
         this.winsTF.alpha = 0;
         this.drawsTF.alpha = 0;
         this.losesTF.alpha = 0;
      }
      
      public function setInfo(param1:CompetitionInfo) : void
      {
         tf.htmlText = param1.club.shortName;
         this.gamesTF.htmlText = param1.gamesPlayed.toString();
         this.winsTF.htmlText = param1.wins.toString();
         this.drawsTF.htmlText = param1.draws.toString();
         this.losesTF.htmlText = param1.loses.toString();
         this.pointsTF.htmlText = param1.points.toString();
      }
      
      public function makeLabels() : void
      {
         this.gamesTF.htmlText = "P";
         this.winsTF.htmlText = "";
         this.drawsTF.htmlText = "";
         this.losesTF.htmlText = "";
         this.pointsTF.htmlText = "Pts";
         this.gamesTF.textColor = this.pointsTF.textColor = 0;
      }
   }
}
