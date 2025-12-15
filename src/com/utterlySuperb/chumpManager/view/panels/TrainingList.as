package com.utterlySuperb.chumpManager.view.panels
{
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.model.dataObjects.Player;
   import com.utterlySuperb.chumpManager.model.dataObjects.StaticInfo;
   import com.utterlySuperb.chumpManager.view.ui.ChumpListBox;
   import com.utterlySuperb.chumpManager.view.ui.buttons.listButtons.PlayerTrainingButton;
   import com.utterlySuperb.chumpManager.view.ui.buttons.listButtons.TrainingHeader;
   import com.utterlySuperb.text.TextHelper;
   import flash.text.TextField;
   
   public class TrainingList extends Panel
   {
      
      private var playerList:ChumpListBox;
      
      public function TrainingList()
      {
         super();
      }
      
      override protected function init() : void
      {
         makeBox(Globals.GAME_WIDTH - Globals.MARGIN_X * 2,Globals.usableHeight,0,0);
         var _loc1_:TextField = new TextField();
         TextHelper.doTextField2(_loc1_,Styles.HEADER_FONT,24,16777215);
         _loc1_.htmlText = CopyManager.getCopy("setTraining");
         TextHelper.fitTextField(_loc1_);
         _loc1_.y = 0;
         _loc1_.x = (Globals.GAME_WIDTH - Globals.MARGIN_X * 2 - _loc1_.textWidth) / 2;
         addChild(_loc1_);
         this.playerList = new ChumpListBox(Globals.GAME_WIDTH - Globals.MARGIN_X * 2 - 55,Globals.usableHeight - 60);
         addChild(this.playerList);
         this.playerList.drawFrame();
         this.playerList.x = 20;
         this.playerList.y = 40;
         this.update();
      }
      
      override protected function update(param1:Object = null) : void
      {
         var _loc5_:Player = null;
         var _loc6_:PlayerTrainingButton = null;
         var _loc2_:Array = Main.currentGame.playerClub.players;
         var _loc3_:TrainingHeader = new TrainingHeader();
         this.playerList.addHeaderItem(_loc3_);
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc5_ = StaticInfo.getPlayer(_loc2_[_loc4_]);
            _loc6_ = new PlayerTrainingButton();
            _loc6_.setPlayer(_loc5_);
            _loc6_.setBG(_loc4_ % 2 == 0);
            this.playerList.addItem(_loc6_);
            _loc4_++;
         }
         this.playerList.enable();
      }
      
      override protected function cleanUp() : void
      {
         this.playerList.disable();
      }
   }
}

