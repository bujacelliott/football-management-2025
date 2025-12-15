package com.utterlySuperb.chumpManager.view.screens
{
   import com.utterlySuperb.chumpManager.engine.GameEngine;
   import com.utterlySuperb.chumpManager.engine.SavesManager;
   import com.utterlySuperb.chumpManager.engine.TeamHelper;
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.view.ui.buttons.LoadGameButton;
   import com.utterlySuperb.text.TextHelper;
   import flash.events.Event;
   import flash.text.TextField;
   
   public class LoadGameScreen extends Screen
   {
      
      public function LoadGameScreen()
      {
         var _loc3_:LoadGameButton = null;
         var _loc4_:int = 0;
         super();
         makeBackButton();
         Main.instance.backOverride = Screen.START_SCREEN;
         SavesManager.getSavedStates();
         var _loc1_:TextField = new TextField();
         TextHelper.doTextField2(_loc1_,Styles.HEADER_FONT,24,16777215);
         _loc1_.htmlText = CopyManager.getCopy("chooseSave");
         _loc1_.y = Globals.HEADER_OFFSET + 40;
         _loc1_.x = (Globals.GAME_WIDTH - _loc1_.textWidth) / 2;
         addChild(_loc1_);
         var _loc2_:int = 0;
         while(_loc2_ < 3)
         {
            _loc3_ = new LoadGameButton();
            _loc4_ = (Globals.GAME_WIDTH - 4 * Globals.MARGIN_X - 3 * _loc3_.width) / 2;
            _loc3_.setGame(SavesManager.games[_loc2_]);
            buttons.push(_loc3_);
            addChild(_loc3_);
            _loc3_.y = Globals.HEADER_OFFSET + (Globals.usableHeight - _loc3_.height) / 2;
            _loc3_.x = _loc2_ == 0 ? Globals.MARGIN_X * 2 : buttons[_loc2_ - 1].x + buttons[_loc2_ - 1].width + _loc4_;
            _loc2_++;
         }
         enabled = true;
      }
      
      override protected function clickButtonHandler(param1:Event) : void
      {
         if(SavesManager.games[buttons.indexOf(param1.target)])
         {
            GameEngine.makeGame();
            Main.currentGame = SavesManager.games[buttons.indexOf(param1.target)];
            SavesManager.loadCurrentGame();
            Main.instance.showScreen(Screen.MAIN_SCREEN);
            TeamHelper.updateTeams();
         }
      }
   }
}

