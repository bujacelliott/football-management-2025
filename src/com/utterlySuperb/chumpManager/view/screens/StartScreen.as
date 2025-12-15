package com.utterlySuperb.chumpManager.view.screens
{
   import com.utterlySuperb.chumpManager.engine.SavesManager;
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.view.ui.buttons.ChumpAssetButton;
   import com.utterlySuperb.chumpManager.view.ui.buttons.ChumpButton;
   import com.utterlySuperb.text.TextHelper;
   import com.utterlySuperb.utils.GetURL;
   import flash.events.Event;
   import flash.text.TextField;
   
   public class StartScreen extends Screen
   {
      
      private var newGameButton:ChumpButton;
      
      private var loadGameButton:ChumpButton;
      
      private var clearSavesButton:ChumpButton;
      
      private var optionsButton:ChumpButton;
      
      private var facebookButton:ChumpAssetButton;
      
      private var twitterButton:ChumpAssetButton;
      
      public function StartScreen()
      {
         super();
         var _loc1_:Logo = new Logo();
         _loc1_.scaleX = _loc1_.scaleY = 0.57;
         _loc1_.x = (Globals.GAME_WIDTH - _loc1_.width) / 2 - 40;
         _loc1_.y = 10;
         addChild(_loc1_);
         this.newGameButton = addButton(CopyManager.getCopy("newGame"),ChumpButton.MEDIUM_BUTTON,100,270);
         this.newGameButton.x = 250;
         this.loadGameButton = addButton(CopyManager.getCopy("loadGame"),ChumpButton.MEDIUM_BUTTON,100,this.newGameButton.y + 60);
         this.loadGameButton.x = this.newGameButton.x;
         this.clearSavesButton = addButton(CopyManager.getCopy("clearSaves"),ChumpButton.MEDIUM_BUTTON,100,this.loadGameButton.y + 60);
         this.clearSavesButton.x = this.newGameButton.x;
         this.facebookButton = addButton(CopyManager.getCopy("followMousebreaker"),ChumpButton.ASSET_BUTTON,100,this.clearSavesButton.y + 60) as ChumpAssetButton;
         this.facebookButton.x = this.newGameButton.x - 20;
         this.facebookButton.addAsset(new Twitter_logo());
         this.twitterButton = addButton(CopyManager.getCopy("becomeAFan"),ChumpButton.ASSET_BUTTON,100,this.facebookButton.y + 65) as ChumpAssetButton;
         this.twitterButton.x = this.newGameButton.x - 20;
         this.twitterButton.overrideTextY(2);
         this.twitterButton.addAsset(new Facebook_logoMC());
         var _loc2_:TextField = new TextField();
         TextHelper.doTextField2(_loc2_,Styles.MAIN_FONT,10,16777215);
         _loc2_.text = Globals.VERSION_NUMBER;
         _loc2_.x = 10;
         _loc2_.y = Globals.GAME_HEIGHT - 5 - _loc2_.textHeight;
         addChild(_loc2_);
         enabled = true;
      }
      
      override protected function clickButtonHandler(param1:Event) : void
      {
         switch(param1.target)
         {
            case this.newGameButton:
               Main.instance.showScreen(Screen.CHOOSE_SAVE_SCREEN);
               break;
            case this.loadGameButton:
               Main.instance.showScreen(Screen.LOAD_GAME);
               break;
            case this.clearSavesButton:
               SavesManager.deleteData();
               break;
            case this.twitterButton:
               GetURL.getURL(CopyManager.getCopy("becomeAFanUrl"),true);
               break;
            case this.facebookButton:
               GetURL.getURL(CopyManager.getCopy("followMousebreakerUrl"),true);
         }
      }
   }
}

