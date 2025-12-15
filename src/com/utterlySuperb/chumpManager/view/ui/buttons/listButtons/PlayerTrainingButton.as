package com.utterlySuperb.chumpManager.view.ui.buttons.listButtons
{
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.model.dataObjects.Player;
   import com.utterlySuperb.chumpManager.view.modals.TrainingChoices;
   import com.utterlySuperb.chumpManager.view.ui.FormShow;
   import com.utterlySuperb.chumpManager.view.ui.RatingStar;
   import com.utterlySuperb.chumpManager.view.ui.StaminaBar;
   import com.utterlySuperb.chumpManager.view.ui.buttons.PlayerTrainingButtonTypeButton;
   import com.utterlySuperb.events.IntEvent;
   import com.utterlySuperb.ui.Checkbox;
   import com.utterlySuperb.ui.CheckboxGroup;
   import com.utterlySuperb.ui.ModalDialogue;
   import com.utterlySuperb.ui.buttons.GenericButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class PlayerTrainingButton extends PlayerListButton
   {
      
      private var trainingIntensityGroup:CheckboxGroup;
      
      private var trainingTypeButton:PlayerTrainingButtonTypeButton;
      
      private var isEnabled:Boolean;
      
      private var staminaBar:StaminaBar;
      
      private var formShow:FormShow;
      
      private var ratingShow:RatingStar;
      
      public function PlayerTrainingButton()
      {
         var _loc2_:Checkbox = null;
         super();
         hit = new Sprite();
         addChild(hit);
         hit.graphics.beginFill(0,0);
         hit.graphics.drawRect(0,0,340,bHeight);
         bWidth = Globals.GAME_WIDTH - Globals.MARGIN_X * 2 - 55;
         bHeight = 25;
         this.trainingIntensityGroup = new CheckboxGroup();
         var _loc1_:int = 0;
         while(_loc1_ < 4)
         {
            _loc2_ = new TrainingCheckbox();
            _loc2_.x = 350 + _loc1_ * 40;
            _loc2_.y = bHeight / 2;
            this.trainingIntensityGroup.addCheckbox(_loc2_);
            addChild(_loc2_);
            _loc1_++;
         }
         this.trainingTypeButton = new PlayerTrainingButtonTypeButton();
         this.trainingTypeButton.x = bWidth - 150;
         this.trainingTypeButton.y = 0;
         addChild(this.trainingTypeButton);
         this.staminaBar = new StaminaBar();
         this.staminaBar.y = 5;
         addChild(this.staminaBar);
         this.ratingShow = new RatingStar();
         this.ratingShow.y = 5;
         addChild(this.ratingShow);
      }
      
      override public function setPlayer(param1:Player) : void
      {
         super.setPlayer(param1);
         if(isNaN(param1.trainingIntensity))
         {
            param1.trainingIntensity = Player.MEDIUM_TRAINING;
         }
         this.trainingIntensityGroup.currentBox = param1.trainingIntensity;
         this.setTraining();
         basePostions.x = 210 - basePostions.textWidth / 2;
         this.staminaBar.x = 250;
         this.staminaBar.setPlayer(param1);
         this.ratingShow.x = 305;
         this.ratingShow.setPlayer(param1);
      }
      
      public function setTraining() : void
      {
         if(player.isKeeper())
         {
            this.trainingTypeButton.setText(CopyManager.getCopy("keeperTraining"));
         }
         else
         {
            this.trainingTypeButton.setText(CopyManager.getCopy(Player.TRAINING_TYPES[player.trainingType]));
         }
         this.trainingTypeButton.x = bWidth - this.trainingTypeButton.width - 10;
      }
      
      override public function activate() : void
      {
         if(!this.isEnabled)
         {
            this.isEnabled = true;
            this.trainingIntensityGroup.activate();
            this.trainingIntensityGroup.addEventListener(Checkbox.CHECK_CLICKED,this.changeTrainingIntensity);
            hit.buttonMode = true;
            hit.addEventListener(MouseEvent.ROLL_OVER,rollOver);
            hit.addEventListener(MouseEvent.ROLL_OUT,rollOut);
            hit.addEventListener(MouseEvent.MOUSE_UP,click);
            rollOut(null);
            this.trainingTypeButton.activate();
            this.trainingTypeButton.addEventListener(GenericButton.BUTTON_CLICK,this.clickChangeTrainingButton);
         }
      }
      
      private function changeTrainingIntensity(param1:Event) : void
      {
         player.trainingIntensity = this.trainingIntensityGroup.currentBox;
      }
      
      override public function deactivate(param1:Boolean = false) : void
      {
         if(this.isEnabled)
         {
            this.isEnabled = false;
            this.trainingIntensityGroup.deactivate();
            this.trainingIntensityGroup.removeEventListener(Checkbox.CHECK_CLICKED,this.changeTrainingIntensity);
            hit.buttonMode = false;
            hit.removeEventListener(MouseEvent.ROLL_OVER,rollOver);
            hit.removeEventListener(MouseEvent.ROLL_OUT,rollOut);
            hit.removeEventListener(MouseEvent.MOUSE_UP,click);
            this.trainingTypeButton.deactivate();
            this.trainingTypeButton.removeEventListener(GenericButton.BUTTON_CLICK,this.clickChangeTrainingButton);
         }
      }
      
      private function clickChangeTrainingButton(param1:Event) : void
      {
         var _loc6_:int = 0;
         var _loc2_:Array = [];
         var _loc3_:String = CopyManager.getCopy("changeTraining");
         var _loc4_:String = CopyManager.getCopy("changeTrainingCopy");
         if(player.isKeeper())
         {
            _loc4_ = CopyManager.getCopy("changeKeeperTraining");
            _loc2_.push(CopyManager.getCopy("ok"));
         }
         else
         {
            _loc6_ = 0;
            while(_loc6_ < Player.TRAINING_TYPES.length)
            {
               _loc2_.push(CopyManager.getCopy(Player.TRAINING_TYPES[_loc6_]));
               _loc6_++;
            }
            _loc2_.push(CopyManager.getCopy("cancel"));
         }
         var _loc5_:TrainingChoices = new TrainingChoices(_loc3_,_loc4_,_loc2_);
         Main.instance.addModal(_loc5_);
         _loc5_.addEventListener(ModalDialogue.MAKE_CHOICE,this.madeTrainingChoiceHandler);
      }
      
      private function madeTrainingChoiceHandler(param1:IntEvent) : void
      {
         var _loc2_:ModalDialogue = ModalDialogue(param1.target);
         if(param1.num < Player.TRAINING_TYPES.length && !player.isKeeper())
         {
            player.trainingType = param1.num;
            this.setTraining();
         }
         _loc2_.removeEventListener(ModalDialogue.MAKE_CHOICE,this.madeTrainingChoiceHandler);
         Main.instance.removeModal(_loc2_);
      }
   }
}

