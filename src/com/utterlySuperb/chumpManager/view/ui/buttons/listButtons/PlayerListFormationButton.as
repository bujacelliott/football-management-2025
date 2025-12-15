package com.utterlySuperb.chumpManager.view.ui.buttons.listButtons
{
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.model.dataObjects.Player;
   import com.utterlySuperb.chumpManager.model.dataObjects.matches.MatchPlayerDetails;
   import com.utterlySuperb.chumpManager.view.panels.SetFormationPanel;
   import com.utterlySuperb.chumpManager.view.ui.FormShow;
   import com.utterlySuperb.chumpManager.view.ui.RatingStar;
   import com.utterlySuperb.chumpManager.view.ui.StaminaBar;
   import com.utterlySuperb.text.TextHelper;
   
   public class PlayerListFormationButton extends PlayerListButton
   {
      
      public var panelState:String;
      
      private var form:FormShow;
      
      private var star:RatingStar;
      
      private var stamina:StaminaBar;
      
      private var injuryIcon:InjuredIcon;
      
      private var suspensionIcon:SuspendedIcon;
      
      public function PlayerListFormationButton()
      {
         super();
         bHeight = 20;
         this.star = new RatingStar();
         addChild(this.star);
         this.stamina = new StaminaBar();
         addChild(this.stamina);
         this.injuryIcon = new InjuredIcon();
         addChild(this.injuryIcon);
         this.suspensionIcon = new SuspendedIcon();
         addChild(this.suspensionIcon);
         this.injuryIcon.y = this.suspensionIcon.y = 2;
      }
      
      override public function setPlayer(param1:Player) : void
      {
         var _loc3_:MatchPlayerDetails = null;
         this.player = param1;
         playerNumber.htmlText = param1.squadNumber.toString();
         playerNumber.x = 5;
         TextHelper.fitTextField(playerNumber);
         setText(param1.name);
         tf.x = 25;
         basePostions.htmlText = CopyManager.getCopy(param1.basePostition).toUpperCase();
         TextHelper.fitTextField(basePostions);
         tf.y = playerNumber.y = basePostions.y = 2;
         var _loc2_:Boolean = true;
         this.suspensionIcon.visible = this.injuryIcon.visible = false;
         if(this.panelState == SetFormationPanel.IN_MATCH)
         {
            _loc3_ = Main.currentGame.matchDetails.getPlayerDetails(param1);
            if(_loc3_.injured)
            {
               _loc2_ = false;
               this.star.visible = this.stamina.visible = false;
               this.injuryIcon.visible = true;
               this.injuryIcon.x = bWidth - this.injuryIcon.width - 5;
               this.placeBasePosToIcons();
               setUnavailable();
            }
            else if(_loc3_.redCards > 0)
            {
               _loc2_ = false;
               this.star.visible = this.stamina.visible = false;
               this.suspensionIcon.visible = true;
               this.suspensionIcon.x = bWidth - this.suspensionIcon.width - 5;
               try
               {
                  this.suspensionIcon.gotoAndStop("redCard");
               }
               catch(err:Error)
               {
               }
               this.placeBasePosToIcons();
               setUnavailable();
            }
            else if(_loc3_.yellowCards > 0)
            {
               _loc2_ = false;
               this.injuryIcon.visible = false;
               this.star.y = 2;
               this.star.setPlayer(param1);
               this.star.x = bWidth - this.star.width - 5;
               this.stamina.setPlayer(param1);
               this.stamina.y = 5;
               this.stamina.x = this.star.x - this.stamina.width - 5;
               this.star.visible = this.stamina.visible = true;
               this.suspensionIcon.visible = true;
               try
               {
                  this.suspensionIcon.gotoAndStop("yellowCard");
               }
               catch(err:Error)
               {
               }
               basePostions.x = this.suspensionIcon.x = this.stamina.x - 10 - basePostions.textWidth;
               basePostions.visible = false;
            }
         }
         else if(this.panelState == SetFormationPanel.PRE_MATCH)
         {
            if(param1.hasInjury() || param1.hasSuspension())
            {
               _loc2_ = false;
               this.star.visible = this.stamina.visible = false;
               if(param1.hasInjury())
               {
                  this.injuryIcon.visible = true;
                  this.injuryIcon.x = bWidth - this.injuryIcon.width - 5;
               }
               else
               {
                  this.injuryIcon.visible = false;
               }
               if(param1.hasSuspension())
               {
                  this.suspensionIcon.visible = true;
                  this.suspensionIcon.x = this.injuryIcon.visible ? this.injuryIcon.x - this.suspensionIcon.width - 5 : bWidth - this.suspensionIcon.width - 5;
               }
               else
               {
                  this.suspensionIcon.visible = false;
               }
               setUnavailable();
               this.placeBasePosToIcons();
            }
         }
         if(_loc2_)
         {
            this.star.y = 2;
            this.star.setPlayer(param1);
            this.star.x = bWidth - this.star.width - 5;
            this.stamina.setPlayer(param1);
            this.stamina.y = 5;
            this.stamina.x = this.star.x - this.stamina.width - 5;
            this.star.visible = this.stamina.visible = true;
            basePostions.x = this.stamina.x - 10 - basePostions.textWidth;
         }
         TextHelper.contrainTextWidth(tf,basePostions.x - tf.x - 10,true);
      }
      
      private function placeBasePosToIcons() : void
      {
         basePostions.x = this.suspensionIcon.visible ? this.suspensionIcon.x - 10 - basePostions.textWidth : this.injuryIcon.x - 10 - basePostions.textWidth;
      }
   }
}

