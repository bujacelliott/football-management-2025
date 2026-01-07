package com.utterlySuperb.chumpManager.view.screens
{
   import com.utterlySuperb.chumpManager.engine.SavesManager;
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.view.panels.BGPanel;
   import com.utterlySuperb.chumpManager.view.ui.buttons.BigButton;
   import com.utterlySuperb.chumpManager.view.ui.buttons.ChumpButton;
   import com.utterlySuperb.text.TextHelper;
   import flash.events.Event;
   import flash.text.TextField;
   
   public class StartScreen extends Screen
   {
      
      private var newGameButton:ChumpButton;
      
      private var loadGameButton:ChumpButton;
      
      private var clearSavesButton:ChumpButton;
      
      public function StartScreen()
      {
         super();
         var _loc1_:Logo = new Logo();
         var _loc2_:int = 360;
         var _loc3_:int = 120;
         var _loc4_:BGPanel = new BGPanel(_loc2_,_loc3_,16777215,0x0F3B2E,0.9,12);
         _loc4_.x = (Globals.GAME_WIDTH - _loc2_) / 2;
         _loc4_.y = 40;
         addChild(_loc4_);
         _loc1_.scaleX = _loc1_.scaleY = 0.57;
         _loc1_.x = (Globals.GAME_WIDTH - _loc1_.width) / 2;
         _loc1_.y = _loc4_.y + (_loc3_ - _loc1_.height) / 2;
         addChild(_loc1_);
         var _loc5_:int = 220;
         var _loc6_:int = 70;
         var _loc7_:int = 20;
         var _loc8_:int = _loc5_ * 3 + _loc7_ * 2;
         var _loc9_:int = (Globals.GAME_WIDTH - _loc8_) / 2;
         var _loc10_:int = 250;
         this.newGameButton = new BigButton(CopyManager.getCopy("newGame"),"",_loc5_,_loc6_);
         this.newGameButton.x = _loc9_;
         this.newGameButton.y = _loc10_;
         addMadeButton(this.newGameButton);
         this.loadGameButton = new BigButton(CopyManager.getCopy("loadGame"),"",_loc5_,_loc6_);
         this.loadGameButton.x = _loc9_ + _loc5_ + _loc7_;
         this.loadGameButton.y = _loc10_;
         addMadeButton(this.loadGameButton);
         this.clearSavesButton = new BigButton(CopyManager.getCopy("clearSaves"),"",_loc5_,_loc6_);
         this.clearSavesButton.x = _loc9_ + (_loc5_ + _loc7_) * 2;
         this.clearSavesButton.y = _loc10_;
         addMadeButton(this.clearSavesButton);
         var _loc11_:TextField = new TextField();
         TextHelper.doTextField2(_loc11_,Styles.MAIN_FONT,10,16777215);
         _loc11_.text = Globals.VERSION_NUMBER;
         _loc11_.x = 10;
         _loc11_.y = Globals.GAME_HEIGHT - 5 - _loc11_.textHeight;
         addChild(_loc11_);
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
         }
      }
   }
}

