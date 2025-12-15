package com.utterlySuperb.chumpManager.view.ui.widgets
{
   import com.utterlySuperb.chumpManager.engine.MatchHelper;
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.model.dataObjects.Player;
   import com.utterlySuperb.text.TextHelper;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class PlayerStatsDisplay extends Sprite
   {
      
      public static const PRE_MATCH:String = "preMatch";
      
      public static const FOR_MATCH:String = "forMatch";
      
      public static const SHOW_ALL:String = "showAll";
      
      public static const GENERAL:String = "genral";
      
      protected var bars:Vector.<PlayerStatBar>;
      
      protected var tf:TextField;
      
      protected var barsSprite:Sprite;
      
      private var state:String;
      
      public var forMatch:Boolean;
      
      public function PlayerStatsDisplay()
      {
         var _loc2_:PlayerStatBar = null;
         super();
         this.tf = new TextField();
         TextHelper.doTextField2(this.tf,Styles.HEADER_FONT,12,Styles.COPY_FONT_COLOR0,{"multiline":true});
         addChild(this.tf);
         this.tf.width = 190;
         this.bars = new Vector.<PlayerStatBar>();
         this.barsSprite = new Sprite();
         addChild(this.barsSprite);
         this.barsSprite.scaleX = this.barsSprite.scaleY = 0.8;
         this.barsSprite.y = 55;
         var _loc1_:int = 0;
         while(_loc1_ < Player.PLAYER_STATS.length)
         {
            _loc2_ = new PlayerStatBarMC();
            this.barsSprite.addChild(_loc2_);
            _loc2_.y = _loc1_ * 20;
            this.bars[_loc1_] = _loc2_;
            _loc2_.setStat(CopyManager.getCopy(Player.PLAYER_STATS[_loc1_]));
            _loc1_++;
         }
         visible = false;
      }
      
      public function makeForMatch() : void
      {
         this.state = FOR_MATCH;
         this.forMatch = true;
         var _loc1_:PlayerStatBar = new PlayerStatBarMC();
         this.barsSprite.addChild(_loc1_);
         _loc1_.y = this.bars.length * 20;
         this.bars.push(_loc1_);
         _loc1_.setStat(CopyManager.getCopy("stamina"));
         _loc1_.visible = false;
         _loc1_ = new PlayerStatBarMC();
         this.barsSprite.addChild(_loc1_);
         _loc1_.y = this.bars.length * 20;
         this.bars.push(_loc1_);
         _loc1_.setStat(CopyManager.getCopy("form"));
         _loc1_.visible = false;
      }
      
      public function makePreMatch() : void
      {
         this.state = PRE_MATCH;
         this.forMatch = true;
         var _loc1_:PlayerStatBar = new PlayerStatBarMC();
         this.barsSprite.addChild(_loc1_);
         _loc1_.y = this.bars.length * 20;
         this.bars.push(_loc1_);
         _loc1_.setStat(CopyManager.getCopy("stamina"));
         _loc1_.visible = false;
      }
      
      public function showAll() : void
      {
         this.state = SHOW_ALL;
         this.forMatch = true;
         var _loc1_:PlayerStatBar = new PlayerStatBarMC();
         this.barsSprite.addChild(_loc1_);
         _loc1_.y = this.bars.length * 20;
         this.bars.push(_loc1_);
         _loc1_.setStat(CopyManager.getCopy("stamina"));
         _loc1_.visible = false;
         _loc1_ = new PlayerStatBarMC();
         this.barsSprite.addChild(_loc1_);
         _loc1_.y = this.bars.length * 20;
         this.bars.push(_loc1_);
         _loc1_.setStat(CopyManager.getCopy("form"));
         _loc1_.visible = false;
      }
      
      public function general() : void
      {
         this.state = GENERAL;
      }
      
      public function setPlayer(param1:Player) : void
      {
         if(param1)
         {
            visible = true;
            this.tf.htmlText = param1.squadNumber + "<br>" + param1.name + "<br>" + CopyManager.getPlayerPostionString(param1.positions).toUpperCase();
            this.makeBars(param1);
         }
         else
         {
            visible = false;
         }
      }
      
      protected function makeBars(param1:Player) : void
      {
         var _loc2_:int = 0;
         if(param1.positions == "gk")
         {
            _loc2_ = 0;
            while(_loc2_ < this.bars.length)
            {
               if(_loc2_ < Player.KEEPER_STATS.length)
               {
                  if(this.state == FOR_MATCH && Player.KEEPER_STATS[_loc2_] == "maxStamina")
                  {
                     this.bars[_loc2_].setStat(CopyManager.getCopy("stamina"));
                     this.bars[_loc2_].setAmount(param1.stamina);
                  }
                  else
                  {
                     this.bars[_loc2_].setStat(CopyManager.getCopy(Player.KEEPER_STATS[_loc2_]));
                     this.bars[_loc2_].setAmount(param1.currentStats[_loc2_]);
                  }
               }
               else if(_loc2_ < Player.KEEPER_STATS.length + 2)
               {
                  if(this.state == FOR_MATCH)
                  {
                     this.makeBar(param1,_loc2_ - Player.KEEPER_STATS.length,this.bars[_loc2_]);
                  }
                  else
                  {
                     this.bars[_loc2_].visible = false;
                  }
               }
               else
               {
                  this.bars[_loc2_].visible = false;
               }
               _loc2_++;
            }
         }
         else
         {
            _loc2_ = 0;
            while(_loc2_ < this.bars.length)
            {
               this.bars[_loc2_].visible = true;
               this.bars[_loc2_].setVals(100,0);
               if(_loc2_ < Player.PLAYER_STATS.length)
               {
                  this.bars[_loc2_].setStat(CopyManager.getCopy(Player.PLAYER_STATS[_loc2_]));
                  this.bars[_loc2_].setAmount(param1.currentStats[_loc2_]);
               }
               else if(_loc2_ == Player.PLAYER_STATS.length)
               {
                  this.showStamina(param1,this.bars[_loc2_]);
               }
               else if(_loc2_ == Player.PLAYER_STATS.length + 1)
               {
                  if(this.state == FOR_MATCH)
                  {
                     this.showRating(param1,this.bars[_loc2_]);
                  }
                  else
                  {
                     this.bars[_loc2_].visible = false;
                  }
               }
               _loc2_++;
            }
         }
      }
      
      protected function makeBar(param1:Player, param2:int, param3:PlayerStatBar) : void
      {
         if(param2 == 1)
         {
            param3.setStat(CopyManager.getCopy("rating"));
            param3.setVals(10,1);
            param3.setAmount(MatchHelper.getPlayerRating(param1));
         }
         else
         {
            param3.setVals(100,0);
            param3.setStat(CopyManager.getCopy("stamina"));
            param3.setAmount(param1.stamina);
         }
      }
      
      protected function showRating(param1:Player, param2:PlayerStatBar) : void
      {
         param2.setStat(CopyManager.getCopy("rating"));
         param2.setVals(10,1);
         param2.setAmount(MatchHelper.getPlayerRating(param1));
      }
      
      protected function showStamina(param1:Player, param2:PlayerStatBar) : void
      {
         param2.setVals(100,0);
         param2.setStat(CopyManager.getCopy("stamina"));
         param2.setAmount(param1.stamina);
      }
   }
}

