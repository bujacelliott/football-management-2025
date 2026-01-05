package com.utterlySuperb.chumpManager.model.dataObjects
{
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.model.dataObjects.competitions.CompetitionInfo;
   import com.utterlySuperb.chumpManager.model.dataObjects.competitions.Cup;
   import com.utterlySuperb.chumpManager.model.dataObjects.competitions.League;
   import com.utterlySuperb.chumpManager.model.dataObjects.matches.Match;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class FixturesList extends EventDispatcher
   {
      
      public static const MADE_FIXTURES:String = "fixtureMade";
      
      public var cups:Array;
      
      public var weeks:Array;
      
      public var weekendMatches:Array;
      
      public var midweekMatches:Array;
      
      public var unallocatedLeagueMatches:Array;
      
      public var unallocatedCupMatches:Array;
      
      public var makeItI:int;
      
      public var its:int;
      
      public var numbers:Array;
      
      public var matches:Array;
      
      public var timer:Timer;
      
      public function FixturesList()
      {
         super();
         this.unallocatedCupMatches = new Array();
         this.unallocatedLeagueMatches = new Array();
      }
      
      public function generateFixtures(param1:Game) : void
      {
         var _loc5_:XML = null;
         var _loc6_:Cup = null;
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc9_:Array = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:Number = NaN;
         var _loc14_:Match = null;
         var _loc2_:XML = <data>
	<startDate year="2010" month="8" day="10"/>
	<leagues>
		<mainLeague nameId="premierLeague" numTeams="20" numWeeks="39"/>
		<secondLeague nameId="championship" numTeams="22"/>
		<foreignLeague nameId="serieA" numTeams="10" teamsInEuropeanCup="4"/>
		<foreignLeague nameId="laLigue" numTeams="10" teamsInEuropeanCup="4"/>
		<foreignLeague nameId="bundesleague" numTeams="8" teamsInEuropeanCup="3"/>
		<foreignLeague nameId="ligue1" numTeams="8" teamsInEuropeanCup="3"/>
		<miscForeignTeams numTeams="12"/>
	</leagues>
	<cups>
		<cup nameID="communityShield" type="knockOut" numTeams="topTwoDomestic" finalWeek="0" playsOn="weekend"/>
		<cup nameID="faCup" type="knockOut" numTeams="domesticAll" finalWeek="40" playsOn="weekend"/>
		<cup nameID="leagueCup" type="knockOut" numTeams="domesticAll" finalWeek="29" playsOn="weekend"/>
		<cup nameID="europeanCup" type="knockOut" numTeams="europeBest" finalWeek="41" playsOn="midweek"/>
		<!--cup nameID="uefaCup" type = "knockOut2Leg" numTeams="europeRest"  finalWeek="37" playsOn="midweek"/-->
	</cups>
</data>;
         this.cups = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.cups.cup.length())
         {
            _loc5_ = _loc2_.cups.cup[_loc3_];
            _loc6_ = new Cup();
            _loc6_.name = String(_loc5_.@nameID);
            _loc6_.type = String(_loc5_.@type);
            _loc6_.finalRound = int(_loc5_.@finalWeek);
            _loc7_ = _loc5_.@numTeams;
            switch(_loc7_)
            {
               case "topTwoDomestic":
                  if(param1.leagueWinners)
                  {
                     _loc6_.addEntrant(param1.leagueWinners[0]);
                     if(param1.leagueWinners[0] == param1.faCupWinner)
                     {
                        param1.leagueWinners[1];
                        break;
                     }
                     _loc6_.addEntrant(param1.faCupWinner);
                  }
                  break;
               case "domesticAll":
                  _loc10_ = 0;
                  _loc9_ = param1.getDomesticLeagues();
                  while(_loc10_ < _loc9_.length)
                  {
                     _loc11_ = 0;
                     while(_loc11_ < _loc9_[_loc10_].entrants.length)
                     {
                        _loc6_.addEntrant(_loc9_[_loc10_].entrants[_loc11_].club);
                        _loc11_++;
                     }
                     _loc10_++;
                  }
                  break;
               case "europeBest":
                  if(param1.leagueWinners)
                  {
                     _loc11_ = 0;
                     while(_loc11_ < 2)
                     {
                        _loc6_.addEntrant(param1.leagueWinners.shift());
                        _loc11_++;
                     }
                     if(_loc6_.hasClub(param1.faCupWinner))
                     {
                        _loc6_.addEntrant(param1.leagueWinners.shift());
                     }
                     else
                     {
                        _loc6_.addEntrant(param1.faCupWinner);
                     }
                     if(_loc6_.hasClub(param1.leagueCupWinner))
                     {
                        _loc6_.addEntrant(param1.leagueWinners.shift());
                     }
                     else
                     {
                        _loc6_.addEntrant(param1.leagueCupWinner);
                     }
                  }
                  if(param1.otherLeagues && param1.otherLeagues.length > 0)
                  {
                     _loc8_ = int(_loc6_.entrants.length);
                     _loc9_ = param1.otherLeagues[0].entrants.slice();
                     while(_loc6_.entrants.length < Math.min(16,_loc8_ + param1.otherLeagues[0].entrants.length))
                     {
                        _loc12_ = int(Math.random() * _loc9_.length);
                        _loc6_.addEntrant(_loc9_[_loc12_].club);
                        _loc9_.splice(_loc12_,1);
                     }
                  }
                  break;
               case "europeRest":
                  if(param1.leagueWinners)
                  {
                     _loc11_ = 4;
                     while(_loc11_ < 8)
                     {
                        _loc6_.addEntrant(param1.leagueWinners[_loc11_]);
                        _loc11_++;
                     }
                     if(param1.otherLeagues && param1.otherLeagues.length > 0)
                     {
                        _loc11_ = 0;
                        while(_loc11_ < param1.otherLeagues.length)
                        {
                           _loc10_ = 0;
                           while(_loc10_ < param1.otherLeagues[_loc11_].numInEuropeanCup)
                           {
                              _loc13_ = Math.floor(Math.random() * param1.otherLeagues[_loc11_].entrants.length);
                              while(_loc6_.hasClub(param1.otherLeagues[_loc11_].entrants[_loc13_].club))
                              {
                                 _loc13_ = Math.floor(Math.random() * param1.otherLeagues[_loc11_].entrants.length);
                              }
                              _loc6_.addEntrant(param1.otherLeagues[_loc11_].entrants[_loc13_].club);
                              _loc10_++;
                           }
                           _loc11_++;
                        }
                     }
                  }
            }
            if(_loc6_.entrants.length > 0)
            {
               _loc6_.numRounds = this.numRounds(_loc6_.entrants.length);
               if(_loc5_.@type == "knockOut2Leg")
               {
                  _loc6_.numRounds = (_loc6_.numRounds - 1) * 2 + 1;
               }
               this.cups.push(_loc6_);
               _loc6_.makeNextMatches();
            }
            _loc3_++;
         }
         var _loc4_:League = param1.getMainLeague();
         if(!_loc4_)
         {
            return;
         }
         this.matches = new Array();
         _loc3_ = 0;
         while(_loc3_ < _loc4_.entrants.length)
         {
            this.matches[_loc3_] = new Array();
            _loc11_ = 0;
            while(_loc11_ < _loc4_.entrants.length)
            {
               if(_loc3_ != _loc11_)
               {
                  _loc14_ = new Match();
                  _loc14_.competition = _loc4_;
                  _loc14_.club0 = _loc4_.entrants[_loc3_];
                  _loc14_.club1 = _loc4_.entrants[_loc11_];
                  this.matches[_loc3_].push(_loc14_);
                  _loc14_ = new Match();
                  _loc14_.competition = _loc4_;
                  _loc14_.club0 = _loc4_.entrants[_loc11_];
                  _loc14_.club1 = _loc4_.entrants[_loc3_];
                  this.matches[_loc3_].push(_loc14_);
               }
               _loc11_++;
            }
            _loc3_++;
         }
         this.weeks = [];
         this.weeks[0] = new Array();
         this.its = 0;
         this.numbers = [];
         _loc3_ = 0;
         while(_loc3_ < _loc4_.entrants.length)
         {
            this.numbers.push(_loc3_);
            _loc3_++;
         }
         this.makeItI = 0;
         this.timer = new Timer(10);
         this.timer.addEventListener(TimerEvent.TIMER,this.tryMakeWeek);
         this.timer.start();
         Main.instance.addPleaseWait(CopyManager.getCopy("buildingFixtures"));
      }
      
      public function tryMakeWeek(param1:Event) : void
      {
         var _loc3_:League = null;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Array = null;
         var _loc9_:Boolean = false;
         var _loc10_:int = 0;
         var _loc11_:Match = null;
         var _loc2_:int = 0;
         while(_loc2_ < 2)
         {
            _loc3_ = Main.currentGame.getMainLeague();
            _loc4_ = this.numbers.slice();
            _loc5_ = [];
            while(_loc4_.length > 0)
            {
               _loc5_.push(_loc4_.splice(Math.floor(Math.random() * _loc4_.length),1)[0]);
            }
            this.weeks[this.makeItI + 1] = new Array();
            _loc6_ = 0;
            while(_loc6_ < this.matches.length)
            {
               _loc7_ = int(_loc5_[_loc6_]);
               if(!this.alreadyHasClub(_loc3_.entrants[_loc7_],this.weeks[this.makeItI]))
               {
                  _loc8_ = this.matches[_loc7_].slice();
                  _loc9_ = false;
                  while(!_loc9_ && _loc8_.length > 0)
                  {
                     _loc10_ = Math.floor(Math.random() * _loc8_.length);
                     _loc11_ = _loc8_.splice(_loc10_,1)[0];
                     if(!this.alreadyhasClub(_loc11_,this.weeks[this.makeItI]) && !this.matchBeenPlayed(_loc11_,this.weeks))
                     {
                        _loc9_ = true;
                        this.weeks[this.makeItI].push(_loc11_);
                     }
                  }
               }
               _loc6_++;
            }
            if(this.weeks[this.makeItI].length < _loc3_.entrants.length / 2 && this.its++ < 20)
            {
               this.weeks.pop();
            }
            else
            {
               ++this.makeItI;
               this.its = 0;
               if(this.makeItI > (_loc3_.entrants.length - 1) * 2)
               {
                  if(this.weeks[this.makeItI].length == 0)
                  {
                     this.weeks.pop();
                  }
                  this.finishMakeFixtures();
                  return;
               }
            }
            _loc2_++;
         }
      }
      
      public function finishMakeFixtures() : void
      {
         var _loc2_:int = 0;
         var _loc3_:Match = null;
         var _loc4_:Boolean = false;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Array = null;
         this.timer.removeEventListener(TimerEvent.TIMER,this.tryMakeWeek);
         this.timer.stop();
         this.timer = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.matches.length)
         {
            _loc2_ = 0;
            while(_loc2_ < this.matches[_loc1_].length)
            {
               _loc3_ = this.matches[_loc1_][_loc2_];
               _loc4_ = false;
               _loc5_ = 0;
               while(_loc5_ < this.weeks.length)
               {
                  _loc6_ = 0;
                  while(_loc6_ < this.weeks[_loc5_].length)
                  {
                     if(this.weeks[_loc5_][_loc6_].club0 == _loc3_.club0 && this.weeks[_loc5_][_loc6_].club1 == _loc3_.club1)
                     {
                        _loc4_ = true;
                     }
                     _loc6_++;
                  }
                  _loc5_++;
               }
               if(!_loc4_ && !this.alreadyhasMatch(this.matches[_loc1_][_loc2_],this.unallocatedLeagueMatches))
               {
                  this.unallocatedLeagueMatches.push(this.matches[_loc1_][_loc2_]);
               }
               _loc2_++;
            }
            _loc1_++;
         }
         if(this.weeks[this.weeks.length - 1].length < Main.currentGame.getMainLeague().entrants.length / 2)
         {
            _loc7_ = this.weeks[2];
            this.weeks[2] = this.weeks[this.weeks.length - 1];
            this.weeks[this.weeks.length - 1] = _loc7_;
         }
         Main.instance.removePleaseWait();
         this.numbers = null;
         this.matches = null;
         dispatchEvent(new Event(MADE_FIXTURES));
      }
      
      public function setNextFixtures(param1:int) : void
      {
         var _loc7_:Array = null;
         var _loc8_:int = 0;
         this.weekendMatches = new Array();
         this.midweekMatches = new Array();
         var _loc2_:Array = new Array();
         var _loc3_:Array = new Array();
         var _loc4_:Array = new Array();
         var _loc5_:int = 0;
         while(_loc5_ < this.unallocatedCupMatches.length)
         {
            if(this.matchIsOk(this.unallocatedCupMatches[_loc5_],_loc3_))
            {
               _loc3_.push(this.unallocatedCupMatches[_loc5_].club0);
               _loc3_.push(this.unallocatedCupMatches[_loc5_].club1);
               this.weekendMatches.push(this.unallocatedCupMatches.splice(_loc5_,1)[0]);
               _loc5_--;
            }
            _loc5_++;
         }
         _loc5_ = 0;
         while(_loc5_ < this.cups.length)
         {
            if(this.cups[_loc5_].isPlayedThisWeek(param1))
            {
               if(!this.cups[_loc5_].playsMatchesMidweek || Boolean(this.cups[_loc5_].isFinal()))
               {
                  _loc7_ = this.cups[_loc5_].getNextMatches();
                  _loc8_ = 0;
                  while(_loc8_ < _loc7_.length)
                  {
                     if(this.matchIsOk(_loc7_[_loc8_],_loc3_))
                     {
                        this.weekendMatches.push(_loc7_[_loc8_]);
                        _loc3_.push(_loc7_[_loc8_].club0);
                        _loc3_.push(_loc7_[_loc8_].club1);
                     }
                     else if(this.matchIsOk(_loc7_[_loc8_],_loc4_))
                     {
                        this.midweekMatches.push(_loc7_[_loc8_]);
                        _loc4_.push(_loc7_[_loc8_].club0);
                        _loc4_.push(_loc7_[_loc8_].club1);
                     }
                     else
                     {
                        this.unallocatedCupMatches.push(_loc7_[_loc8_]);
                     }
                     _loc8_++;
                  }
               }
            }
            _loc5_++;
         }
         var _loc6_:Array = new Array();
         if(param1 < this.weeks.length)
         {
            _loc5_ = 0;
            while(_loc5_ < this.weeks[param1].length)
            {
               if(this.matchIsOk(this.weeks[param1][_loc5_],_loc3_))
               {
                  this.weekendMatches.push(this.weeks[param1][_loc5_]);
                  _loc3_.push(this.weeks[param1][_loc5_].club0);
                  _loc3_.push(this.weeks[param1][_loc5_].club1);
               }
               else if(this.matchIsOk(this.weeks[param1][_loc5_],_loc4_))
               {
                  this.midweekMatches.push(this.weeks[param1][_loc5_]);
                  _loc4_.push(this.weeks[param1][_loc5_].club0);
                  _loc4_.push(this.weeks[param1][_loc5_].club1);
               }
               else
               {
                  _loc6_.push(this.weeks[param1][_loc5_]);
               }
               _loc5_++;
            }
         }
         if(param1 > 15)
         {
            _loc5_ = 0;
            while(_loc5_ < this.unallocatedLeagueMatches.length)
            {
               if(this.matchIsOk(this.unallocatedLeagueMatches[_loc5_],_loc3_))
               {
                  this.weekendMatches.push(this.unallocatedLeagueMatches[_loc5_]);
                  _loc3_.push(this.unallocatedLeagueMatches[_loc5_].club0);
                  _loc3_.push(this.unallocatedLeagueMatches[_loc5_].club1);
                  this.unallocatedLeagueMatches.splice(_loc5_,1);
                  _loc5_--;
               }
               else if(this.matchIsOk(this.unallocatedLeagueMatches[_loc5_],_loc4_))
               {
                  this.midweekMatches.push(this.unallocatedLeagueMatches[_loc5_]);
                  _loc4_.push(this.unallocatedLeagueMatches[_loc5_].club0);
                  _loc4_.push(this.unallocatedLeagueMatches[_loc5_].club1);
                  this.unallocatedLeagueMatches.splice(_loc5_,1);
                  _loc5_--;
               }
               _loc5_++;
            }
         }
         this.unallocatedLeagueMatches = this.unallocatedLeagueMatches.concat(_loc6_);
      }
      
      public function remakeCompInfRelationships() : void
      {
         var _loc3_:int = 0;
         var _loc4_:Match = null;
         var _loc5_:int = 0;
         var _loc6_:Match = null;
         var _loc7_:Match = null;
         var _loc8_:int = 0;
         var _loc9_:Match = null;
         var _loc1_:League = Main.currentGame.getMainLeague();
         var _loc2_:int = 0;
         while(_loc2_ < this.weeks.length)
         {
            _loc3_ = 0;
            while(_loc3_ < this.weeks[_loc2_].length)
            {
               _loc4_ = this.weeks[_loc2_][_loc3_];
               _loc5_ = 0;
               while(_loc5_ < _loc1_.entrants.length)
               {
                  if(_loc1_.entrants[_loc5_].club == _loc4_.club0.club)
                  {
                     _loc4_.club0 = _loc1_.entrants[_loc5_];
                  }
                  else if(_loc1_.entrants[_loc5_].club == _loc4_.club1.club)
                  {
                     _loc4_.club1 = _loc1_.entrants[_loc5_];
                  }
                  _loc5_++;
               }
               _loc5_ = 0;
               while(_loc5_ < this.weekendMatches.length)
               {
                  _loc6_ = this.weekendMatches[_loc5_];
                  if(_loc4_.competition.name == _loc6_.competition.name && _loc4_.club0.club == _loc6_.club0.club && _loc4_.club1.club == _loc6_.club1.club)
                  {
                     this.weekendMatches[_loc5_] = _loc4_;
                  }
                  _loc5_++;
               }
               _loc5_ = 0;
               while(_loc5_ < this.midweekMatches.length)
               {
                  _loc7_ = this.midweekMatches[_loc5_];
                  if(_loc4_.competition.name == _loc7_.competition.name && _loc4_.club0.club == _loc7_.club0.club && _loc4_.club1.club == _loc7_.club1.club)
                  {
                     this.midweekMatches[_loc5_] = _loc4_;
                  }
                  _loc5_++;
               }
               _loc5_ = 0;
               while(_loc5_ < this.faCup.matches.length)
               {
                  _loc8_ = 0;
                  while(_loc8_ < this.faCup.matches[_loc5_].length)
                  {
                     _loc9_ = this.faCup.matches[_loc5_][_loc8_];
                     if(_loc4_.competition.name == _loc9_.competition.name && _loc4_.club0.club == _loc9_.club0.club && _loc4_.club1.club == _loc9_.club1.club)
                     {
                        this.faCup[_loc5_][_loc8_] = _loc4_;
                     }
                     _loc8_++;
                  }
                  _loc5_++;
               }
               _loc5_ = 0;
               while(_loc5_ < this.leagueCup.matches.length)
               {
                  _loc8_ = 0;
                  while(_loc8_ < this.leagueCup.matches[_loc5_].length)
                  {
                     _loc9_ = this.leagueCup.matches[_loc5_][_loc8_];
                     if(_loc4_.competition.name == _loc9_.competition.name && _loc4_.club0.club == _loc9_.club0.club && _loc4_.club1.club == _loc9_.club1.club)
                     {
                        this.leagueCup[_loc5_][_loc8_] = _loc4_;
                     }
                     _loc8_++;
                  }
                  _loc5_++;
               }
               if(this.europeanCup)
               {
                  _loc5_ = 0;
                  while(_loc5_ < this.europeanCup.matches.length)
                  {
                     _loc8_ = 0;
                     while(_loc8_ < this.europeanCup.matches[_loc5_].length)
                     {
                        _loc9_ = this.europeanCup.matches[_loc5_][_loc8_];
                        if(_loc4_.competition.name == _loc9_.competition.name && _loc4_.club0.club == _loc9_.club0.club && _loc4_.club1.club == _loc9_.club1.club)
                        {
                           this.europeanCup[_loc5_][_loc8_] = _loc4_;
                        }
                        _loc8_++;
                     }
                     _loc5_++;
                  }
               }
               _loc3_++;
            }
            _loc2_++;
         }
         _loc5_ = 0;
         while(_loc5_ < this.faCup.matches.length)
         {
            _loc8_ = 0;
            while(_loc8_ < this.faCup.matches[_loc5_].length)
            {
               _loc9_ = this.faCup.matches[_loc5_][_loc8_];
               _loc2_ = 0;
               while(_loc2_ < this.weekendMatches.length)
               {
                  _loc6_ = this.weekendMatches[_loc2_];
                  if(_loc6_.competition.name == _loc9_.competition.name && _loc6_.club0.club == _loc9_.club0.club && _loc6_.club1.club == _loc9_.club1.club)
                  {
                     this.weekendMatches[_loc2_] = _loc9_;
                  }
                  _loc2_++;
               }
               _loc2_ = 0;
               while(_loc2_ < this.midweekMatches.length)
               {
                  _loc6_ = this.midweekMatches[_loc2_];
                  if(_loc6_.competition.name == _loc9_.competition.name && _loc6_.club0.club == _loc9_.club0.club && _loc6_.club1.club == _loc9_.club1.club)
                  {
                     this.midweekMatches[_loc2_] = _loc9_;
                  }
                  _loc2_++;
               }
               _loc8_++;
            }
            _loc5_++;
         }
         _loc5_ = 0;
         while(_loc5_ < this.leagueCup.matches.length)
         {
            _loc8_ = 0;
            while(_loc8_ < this.leagueCup.matches[_loc5_].length)
            {
               _loc9_ = this.leagueCup.matches[_loc5_][_loc8_];
               _loc2_ = 0;
               while(_loc2_ < this.weekendMatches.length)
               {
                  _loc6_ = this.weekendMatches[_loc2_];
                  if(_loc6_.competition.name == _loc9_.competition.name && _loc6_.club0.club == _loc9_.club0.club && _loc6_.club1.club == _loc9_.club1.club)
                  {
                     this.weekendMatches[_loc2_] = _loc9_;
                  }
                  _loc2_++;
               }
               _loc2_ = 0;
               while(_loc2_ < this.midweekMatches.length)
               {
                  _loc6_ = this.midweekMatches[_loc2_];
                  if(_loc6_.competition.name == _loc9_.competition.name && _loc6_.club0.club == _loc9_.club0.club && _loc6_.club1.club == _loc9_.club1.club)
                  {
                     this.midweekMatches[_loc2_] = _loc9_;
                  }
                  _loc2_++;
               }
               _loc8_++;
            }
            _loc5_++;
         }
         _loc5_ = 0;
         while(_loc5_ < this.europeanCup.matches.length)
         {
            _loc8_ = 0;
            while(_loc8_ < this.europeanCup.matches[_loc5_].length)
            {
               _loc9_ = this.europeanCup.matches[_loc5_][_loc8_];
               _loc2_ = 0;
               while(_loc2_ < this.weekendMatches.length)
               {
                  _loc6_ = this.weekendMatches[_loc2_];
                  if(_loc6_.competition.name == _loc9_.competition.name && _loc6_.club0.club == _loc9_.club0.club && _loc6_.club1.club == _loc9_.club1.club)
                  {
                     this.weekendMatches[_loc2_] = _loc9_;
                  }
                  _loc2_++;
               }
               _loc2_ = 0;
               while(_loc2_ < this.midweekMatches.length)
               {
                  _loc6_ = this.midweekMatches[_loc2_];
                  if(_loc6_.competition.name == _loc9_.competition.name && _loc6_.club0.club == _loc9_.club0.club && _loc6_.club1.club == _loc9_.club1.club)
                  {
                     this.midweekMatches[_loc2_] = _loc9_;
                  }
                  _loc2_++;
               }
               _loc8_++;
            }
            _loc5_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.unallocatedLeagueMatches.length)
         {
            _loc5_ = 0;
            while(_loc5_ < _loc1_.entrants.length)
            {
               _loc4_ = this.unallocatedLeagueMatches[_loc2_];
               if(_loc1_.entrants[_loc5_].club == _loc4_.club0.club)
               {
                  _loc4_.club0 = _loc1_.entrants[_loc5_];
               }
               else if(_loc1_.entrants[_loc5_].club == _loc4_.club1.club)
               {
                  _loc4_.club1 = _loc1_.entrants[_loc5_];
               }
               _loc5_++;
            }
            _loc2_++;
         }
      }
      
      public function matchIsOk(param1:Match, param2:Array) : Boolean
      {
         var _loc3_:int = 0;
         while(_loc3_ < param2.length)
         {
            if(param2[_loc3_].club == param1.club0.club || param2[_loc3_].club == param1.club1.club)
            {
               return false;
            }
            _loc3_++;
         }
         return true;
      }
      
      public function alreadyHasClub(param1:CompetitionInfo, param2:Array) : Boolean
      {
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         while(_loc4_ < param2.length)
         {
            if(param2[_loc4_].club0 == param1 || param2[_loc4_].club1 == param1)
            {
               _loc3_ = true;
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function alreadyhasMatch(param1:Match, param2:Array) : Boolean
      {
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         while(_loc4_ < param2.length)
         {
            if(param2[_loc4_].club0 == param1.club0 && param2[_loc4_].club1 == param1.club1 || param2[_loc4_].club1 == param1.club0 && param2[_loc4_].club0 == param1.club1)
            {
               _loc3_ = true;
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function alreadyhasClub(param1:Match, param2:Array) : Boolean
      {
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         while(_loc4_ < param2.length)
         {
            if(param2[_loc4_].club0 == param1.club0 || param2[_loc4_].club1 == param1.club1 || param2[_loc4_].club1 == param1.club0 || param2[_loc4_].club0 == param1.club1)
            {
               _loc3_ = true;
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function matchBeenPlayed(param1:Match, param2:Array) : Boolean
      {
         var _loc5_:int = 0;
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         while(_loc4_ < param2.length)
         {
            _loc5_ = 0;
            while(_loc5_ < param2[_loc4_].length)
            {
               if(param2[_loc4_][_loc5_].club0 == param1.club0 && param2[_loc4_][_loc5_].club1 == param1.club1)
               {
                  _loc3_ = true;
               }
               _loc5_++;
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function seasonFinished(param1:int) : Boolean
      {
         var _loc2_:Boolean = true;
         var _loc3_:int = 0;
         while(_loc3_ < this.cups.length)
         {
            if(!this.cups[_loc3_].isFinished() && this.cups[_loc3_].name != "communityShield")
            {
               _loc2_ = false;
            }
            _loc3_++;
         }
         if(param1 < this.weeks.length)
         {
            _loc2_ = false;
         }
         if(this.unallocatedLeagueMatches.length > 0)
         {
            _loc2_ = false;
         }
         if(this.unallocatedCupMatches.length > 0)
         {
            _loc2_ = false;
         }
         return _loc2_;
      }
      
      public function numRounds(param1:Number) : int
      {
         var _loc2_:int = 0;
         while(param1 > 1)
         {
            param1 /= 2;
            _loc2_++;
         }
         return _loc2_;
      }
      
      public function get europeanCup() : Cup
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.cups.length)
         {
            if(this.cups[_loc1_].name == "europeanCup")
            {
               return this.cups[_loc1_];
            }
            _loc1_++;
         }
         return null;
      }
      
      public function get uefaCup() : Cup
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.cups.length)
         {
            if(this.cups[_loc1_].name == "uefaCup")
            {
               return this.cups[_loc1_];
            }
            _loc1_++;
         }
         return null;
      }
      
      public function get faCup() : Cup
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.cups.length)
         {
            if(this.cups[_loc1_].name == "faCup")
            {
               return this.cups[_loc1_];
            }
            _loc1_++;
         }
         return null;
      }
      
      public function get leagueCup() : Cup
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.cups.length)
         {
            if(this.cups[_loc1_].name == "leagueCup")
            {
               return this.cups[_loc1_];
            }
            _loc1_++;
         }
         return null;
      }
   }
}

