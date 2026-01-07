package com.utterlySuperb.chumpManager.engine
{
   import com.utterlySuperb.chumpManager.model.dataObjects.*;
   import com.utterlySuperb.chumpManager.model.dataObjects.competitions.*;
   import com.utterlySuperb.chumpManager.model.dataObjects.matches.*;
   import com.utterlySuperb.events.BudgetEventProxy;
   import flash.events.NetStatusEvent;
   import flash.net.SharedObject;
   import flash.net.SharedObjectFlushStatus;
   import flash.net.registerClassAlias;
   
   public class SavesManager
   {
      
      public static var games:Array;
      
      public static const ON_FLUSH:String = "onFlush";
      
      private static var doingSave:Boolean = false;
      
      public function SavesManager()
      {
         super();
      }
      
      public static function getSavedStates() : void
      {
         var _loc2_:SharedObject = null;
         games = new Array();
         var _loc1_:int = 0;
         while(_loc1_ < 6)
         {
            _loc2_ = SharedObject.getLocal("chumpManager" + _loc1_);
            if(_loc2_.data.game)
            {
               games[_loc1_] = GameSaveConverter.turnPrimitivesToGame(_loc2_.data.game);
            }
            _loc1_++;
         }
      }
      
      public static function deleteData() : void
      {
         var _loc2_:SharedObject = null;
         var _loc1_:int = 0;
         while(_loc1_ < 6)
         {
            _loc2_ = SharedObject.getLocal("chumpManager" + _loc1_);
            _loc2_.clear();
            _loc1_++;
         }
         _loc2_ = SharedObject.getLocal("chumpManagerSettings");
         _loc2_.clear();
      }
      
      public static function saveGame() : void
      {
         var gameOb:Object;
         var flushStatus:String;
         var game:Game = null;
         var so:SharedObject = null;
         if(doingSave)
         {
            return;
         }
         doingSave = true;
         game = Main.currentGame;
         gameOb = GameSaveConverter.turnGameToPrimitives(game);
         try
         {
            so = SharedObject.getLocal("chumpManager" + game.slotNumber);
         }
         catch(e:Error)
         {
            so = SharedObject.getLocal("chumpManager" + game.slotNumber);
            so.clear();
         }
         so.data.game = gameOb;
         flushStatus = null;
         try
         {
            flushStatus = so.flush();
         }
         catch(error:Error)
         {
            BudgetEventProxy.dispatchEvent(ON_FLUSH,{"success":false});
            doingSave = false;
         }
         if(flushStatus != null)
         {
            switch(flushStatus)
            {
               case SharedObjectFlushStatus.PENDING:
                  so.addEventListener(NetStatusEvent.NET_STATUS,onFlushStatus);
                  break;
               case SharedObjectFlushStatus.FLUSHED:
                  BudgetEventProxy.dispatchEvent(ON_FLUSH,{"success":true});
                  doingSave = false;
            }
         }
         else
         {
            doingSave = false;
            BudgetEventProxy.dispatchEvent(ON_FLUSH,{"success":false});
         }
      }
      
      public static function saveSettings() : void
      {
         var flushStatus:String;
         var so:SharedObject = SharedObject.getLocal("chumpManagerSettings");
         so.data.settings = Main.instance.settings;
         flushStatus = null;
         try
         {
            flushStatus = so.flush(Globals.SAVE_VOLUME_OPTIONS);
         }
         catch(error:Error)
         {
            BudgetEventProxy.dispatchEvent(ON_FLUSH,{"success":false});
         }
      }
      
      public static function getSettings() : void
      {
         var _loc1_:SharedObject = SharedObject.getLocal("chumpManagerSettings");
         if(_loc1_.data.settings)
         {
            Main.instance.settings = _loc1_.data.settings;
         }
         else
         {
            Main.instance.settings = new Settings();
         }
      }
      
      private static function onFlushStatus(param1:NetStatusEvent) : void
      {
         var _loc2_:Boolean = false;
         switch(param1.info.code)
         {
            case "SharedObject.Flush.Success":
               _loc2_ = true;
               break;
            case "SharedObject.Flush.Failed":
               _loc2_ = false;
         }
         doingSave = false;
         BudgetEventProxy.dispatchEvent(ON_FLUSH,{"success":true});
         param1.target.removeEventListener(NetStatusEvent.NET_STATUS,onFlushStatus);
      }
      
      public static function registerClasses() : void
      {
         registerClassAlias("com.utterlySuperb.chumpManager.model.dataObjects.Game",Game);
         registerClassAlias("com.utterlySuperb.chumpManager.model.dataObjects.Club",Club);
         registerClassAlias("com.utterlySuperb.chumpManager.model.dataObjects.FixturesList",FixturesList);
         registerClassAlias("com.utterlySuperb.chumpManager.model.dataObjects.Formation",Formation);
         registerClassAlias("com.utterlySuperb.chumpManager.model.dataObjects.Message",Message);
         registerClassAlias("com.utterlySuperb.chumpManager.model.dataObjects.Player",Player);
         registerClassAlias("com.utterlySuperb.chumpManager.model.dataObjects.PlayerBank",PlayerBank);
         registerClassAlias("com.utterlySuperb.chumpManager.model.dataObjects.PlayerOffers",PlayerOffers);
         registerClassAlias("com.utterlySuperb.chumpManager.model.dataObjects.SeasonStats",SeasonStats);
         registerClassAlias("com.utterlySuperb.chumpManager.model.dataObjects.StatusEffect",StatusEffect);
         registerClassAlias("com.utterlySuperb.chumpManager.model.dataObjects.Settings",Settings);
         registerClassAlias("com.utterlySuperb.chumpManager.model.dataObjects.Club",Club);
         registerClassAlias("com.utterlySuperb.chumpManager.model.dataObjects.matches.Match",Match);
         registerClassAlias("com.utterlySuperb.chumpManager.model.dataObjects.matches.MatchDetails",MatchDetails);
         registerClassAlias("com.utterlySuperb.chumpManager.model.dataObjects.matches.MatchTeamDetails",MatchTeamDetails);
         registerClassAlias("com.utterlySuperb.chumpManager.model.dataObjects.matches.MatchPlayerDetails",MatchPlayerDetails);
         registerClassAlias("com.utterlySuperb.chumpManager.model.dataObjects.competitions.Competition",Competition);
         registerClassAlias("com.utterlySuperb.chumpManager.model.dataObjects.competitions.CompetitionInfo",CompetitionInfo);
         registerClassAlias("com.utterlySuperb.chumpManager.model.dataObjects.competitions.Cup",Cup);
         registerClassAlias("com.utterlySuperb.chumpManager.model.dataObjects.competitions.League",League);
         registerClassAlias("String",String);
         registerClassAlias("Vector",Vector);
      }
      
      public static function loadCurrentGame() : void
      {
         var _loc4_:int = 0;
         var _loc5_:Club = null;
         var _loc6_:int = 0;
         var _loc7_:Date = null;
         var _loc8_:Player = null;
         var _loc1_:Game = Main.currentGame;
         _loc1_.fixtureList.remakeCompInfRelationships();
         var _loc2_:Array = _loc1_.savedPlayers.playersList;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            StaticInfo.replacePlayer(_loc2_[_loc3_]);
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < _loc1_.leagues.length)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc1_.leagues[_loc3_].entrants.length)
            {
               _loc5_ = _loc1_.leagues[_loc3_].entrants[_loc4_].club;
               _loc6_ = 0;
               while(_loc6_ < _loc5_.players.length)
               {
                  _loc8_ = StaticInfo.getPlayer(_loc5_.players[_loc6_]);
                  if(_loc8_.club != _loc5_)
                  {
                     _loc8_.squadNumber = _loc5_.getNextSquadNumber(_loc8_);
                  }
                  StaticInfo.getPlayer(_loc5_.players[_loc6_]).club = _loc5_;
                  _loc6_++;
               }
               _loc4_++;
            }
            _loc3_++;
         }
         _loc2_ = StaticInfo.getPlayerList();
         _loc3_ = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc8_ = _loc2_[_loc3_];
            if(Boolean(_loc8_.club) && _loc8_.club.isCore)
            {
               _loc5_ = getCoreClub(_loc8_.club.name);
               if(_loc5_.players.indexOf(_loc8_.id) < 0)
               {
                  _loc8_.club = null;
               }
            }
            _loc3_++;
         }
         if(_loc1_.seasonNum > 0)
         {
            _loc7_ = _loc1_.currentDate;
            _loc1_.currentDate = _loc1_.firstWeekend;
            _loc2_ = StaticInfo.getPlayerList();
            for each(_loc8_ in _loc2_)
            {
               if(!_loc8_.club || _loc8_.club && _loc8_.club.isCore)
               {
                  _loc8_.retireFlag = false;
                  _loc8_.setAgeOffset();
                  TeamHelper.updatePlayer(_loc8_,true);
                  if(!_loc8_.active)
                  {
                     if(_loc8_.age >= 16 && _loc8_.age <= 16 + _loc1_.seasonNum || Boolean(_loc8_.club))
                     {
                        _loc8_.reset();
                        _loc8_.active = true;
                     }
                  }
               }
            }
            _loc1_.currentDate = _loc7_;
            for each(_loc8_ in _loc2_)
            {
               if(_loc8_.active && (!_loc8_.club || _loc8_.club && _loc8_.club.isCore))
               {
                  TeamHelper.updatePlayer(_loc8_,true);
               }
            }
         }
      }
      
      private static function getCoreClub(param1:String) : Club
      {
         var _loc2_:Array = GameHelper.getCoreClubs();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(_loc2_[_loc3_].club.name == param1)
            {
               return _loc2_[_loc3_].club;
            }
            _loc3_++;
         }
         return null;
      }
   }
}

