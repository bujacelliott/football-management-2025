package com.utterlySuperb.chumpManager.view.panels.matchPanels
{
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.model.dataObjects.matches.MatchDetails;
   import com.utterlySuperb.chumpManager.view.panels.Panel;
   import com.utterlySuperb.text.TextHelper;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import flash.text.TextFormatAlign;
   
   public class MatchStatsPanel extends Panel
   {
      
      private var info:TextField;
      
      public function MatchStatsPanel()
      {
         super();
         filters = [new GlowFilter(0,1,2,2,3,2)];
      }
      
      override protected function init() : void
      {
         this.info = new TextField();
         this.info.width = 200;
         TextHelper.doTextField2(this.info,Styles.HEADER_FONT,12,16777215,{
            "multiline":true,
            "align":TextFormatAlign.CENTER,
            "leading":-2
         });
         addChild(this.info);
      }
      
      override protected function update(param1:Object = null) : void
      {
         var _loc2_:MatchDetails = Main.currentGame.matchDetails;
         var _loc3_:* = this.makeTextBig(CopyManager.getCopy("shots")) + "<br>" + _loc2_.team0.getShots() + " - " + _loc2_.team1.getShots() + "<br>";
         _loc3_ += this.makeTextBig(CopyManager.getCopy("shotsOnTarget")) + "<br>" + _loc2_.team0.getShotsOnTarget() + " - " + _loc2_.team1.getShotsOnTarget() + "<br>";
         _loc3_ += this.makeTextBig(CopyManager.getCopy("possession")) + "<br>" + _loc2_.getTeamPossession(0) + "% - " + _loc2_.getTeamPossession(1) + "%<br>";
         _loc3_ += "<br>";
         this.info.htmlText = _loc3_;
      }
      
      private function makeTextBig(param1:String, param2:int = 12) : String
      {
         return "<font face=\'Arial Black\' size=\'" + param2 + "\'>" + param1 + "</font>";
      }
   }
}

