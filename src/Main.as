package
{
   import com.greensock.TweenLite;
   import com.greensock.plugins.AutoAlphaPlugin;
   import com.greensock.plugins.BlurFilterPlugin;
   import com.greensock.plugins.ColorTransformPlugin;
   import com.greensock.plugins.TintPlugin;
   import com.greensock.plugins.TweenPlugin;
   import com.utterlySuperb.chumpManager.engine.TransfersEngine;
   import com.utterlySuperb.chumpManager.engine.SavesManager;
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.model.dataObjects.Game;
   import com.utterlySuperb.chumpManager.model.dataObjects.PlayerBank;
   import com.utterlySuperb.chumpManager.model.dataObjects.Settings;
   import com.utterlySuperb.chumpManager.model.dataObjects.StaticInfo;
   import com.utterlySuperb.chumpManager.view.modals.PleaseWaitModal;
   import com.utterlySuperb.chumpManager.view.screens.Screen;
   import com.utterlySuperb.text.TextHelper;
   import com.utterlySuperb.ui.ModalDialogue;
   import com.utterlySuperb.ui.Tooltip;
   import com.utterlySuperb.utils.GetURL;
   import flash.display.Sprite;
   import flash.display.StageAlign;
   import flash.display.StageDisplayState;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   import flash.text.TextField;
   
   public class Main extends Sprite
   {
      
      private static var _instance:Main;
      
      private static var _forceTransfersEngine:Class = TransfersEngine;
      
      public static var currentGame:Game;
      
      public var playerBank:PlayerBank;
      
      public var currentScreen:Screen;
      
      private var gameHolder:Sprite;
      
      private var tooltip:Tooltip;
      
      public var backOverride:String;
      
      public var settings:Settings;
      
      private var bg:Background;
      
      private var pleaseWait:PleaseWaitModal;
      
      private var appContainer:Sprite;
      
      public function Main()
      {
         super();
         if(stage)
         {
            this.init();
         }
         else
         {
            addEventListener(Event.ADDED_TO_STAGE,this.init);
         }
      }
      
      public static function get instance() : Main
      {
         return _instance;
      }
      
      public static function set instance(param1:Main) : void
      {
         _instance = param1;
      }
      
      private function init(param1:Event = null) : void
      {
         if(stage)
         {
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            try
            {
               stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
            }
            catch(err:Error)
            {
            }
         }
         this.bg = new Background();
         addChild(this.bg);
         this.appContainer = new Sprite();
         addChild(this.appContainer);
         _instance = this;
         removeEventListener(Event.ADDED_TO_STAGE,this.init);
         var _loc2_:MouseBreakerSplash = new MouseBreakerSplash();
         _loc2_.addEventListener(MouseBreakerSplash.FINISH_SPLASH,this.finishSplashHandler);
         addChild(_loc2_);
         if(stage)
         {
            stage.addEventListener(Event.RESIZE,this.onStageResize);
            this.layoutStage();
         }
      }
      
      private function finishSplashHandler(param1:Event) : void
      {
         var _loc2_:MouseBreakerSplash = param1.target as MouseBreakerSplash;
         removeChild(_loc2_);
         _loc2_.removeEventListener(MouseBreakerSplash.FINISH_SPLASH,this.finishSplashHandler);
         var _loc3_:Array = [];
         _loc3_.push("mousebreaker");
         _loc3_.push("utterlySuperb");
         var _loc4_:* = !(_loc3_.length > 0 && loaderInfo.url.indexOf("http") >= 0);
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_.length)
         {
            if(loaderInfo.url.toLowerCase().indexOf(_loc3_[_loc5_]) >= 0)
            {
               _loc4_ = true;
            }
            _loc5_++;
         }
         if(_loc4_)
         {
            this.showStart();
         }
         else
         {
            GetURL.getURL("http://www.mousebreaker.co.uk");
         }
      }
      
      private function showStart() : void
      {
         StaticInfo.init();
         SavesManager.registerClasses();
         SavesManager.getSettings();
         CopyManager.init(CopyManager.ENGLISH);
         TweenPlugin.activate([ColorTransformPlugin,TintPlugin,AutoAlphaPlugin,BlurFilterPlugin]);
         this.gameHolder = new Sprite();
         this.appContainer.addChild(this.gameHolder);
         this.tooltip = new Tooltip();
         this.appContainer.addChild(this.tooltip);
         var _loc1_:TextField = new TextField();
         TextHelper.doTextField2(_loc1_,Styles.MAIN_FONT,14,0,{"multiline":true});
         this.tooltip.addTextField(_loc1_);
         this.showScreen(Screen.START_SCREEN);
         this.layoutStage();
      }
      
      public function showScreen(param1:String) : void
      {
         if(this.currentScreen)
         {
            this.currentScreen.cleanUp();
            this.gameHolder.removeChild(this.currentScreen);
         }
         this.currentScreen = Screen.getScreen(param1);
         this.gameHolder.addChild(this.currentScreen);
      }
      
      public function addModal(param1:ModalDialogue) : void
      {
         ModalDialogue.modalShowing = true;
         addChild(param1);
      }
      
      public function removeModal(param1:ModalDialogue) : void
      {
         ModalDialogue.modalShowing = false;
         removeChild(param1);
      }
      
      public function addPleaseWait(param1:String) : void
      {
         this.pleaseWait = new PleaseWaitModal("",param1,[]);
         this.addModal(this.pleaseWait);
      }
      
      public function removePleaseWait() : void
      {
         if(this.pleaseWait)
         {
            this.removeModal(this.pleaseWait);
            this.pleaseWait = null;
         }
      }
      
      public function setBlurBG(param1:Boolean) : void
      {
         if(param1)
         {
            TweenLite.to(this.bg.manager,1,{"alpha":0});
         }
         else
         {
            TweenLite.to(this.bg.manager,1,{"alpha":1});
         }
      }

      private function onStageResize(param1:Event) : void
      {
         this.layoutStage();
      }

      private function layoutStage() : void
      {
         if(!stage || !this.appContainer)
         {
            return;
         }
         var _loc1_:Number = Math.min(stage.stageWidth / Globals.GAME_WIDTH,stage.stageHeight / Globals.GAME_HEIGHT);
         this.appContainer.scaleX = this.appContainer.scaleY = _loc1_;
         this.appContainer.x = (stage.stageWidth - Globals.GAME_WIDTH * _loc1_) / 2;
         this.appContainer.y = (stage.stageHeight - Globals.GAME_HEIGHT * _loc1_) / 2;
         if(this.bg)
         {
            this.bg.width = stage.stageWidth;
            this.bg.height = stage.stageHeight;
            this.bg.x = 0;
            this.bg.y = 0;
         }
      }
   }
}

