package com.utterlySuperb.chumpManager.engine
{
   import com.utterlySuperb.chumpManager.model.dataObjects.Club;
   import com.utterlySuperb.chumpManager.model.dataObjects.FixturesList;
   import com.utterlySuperb.chumpManager.model.dataObjects.Formation;
   import com.utterlySuperb.chumpManager.model.dataObjects.Game;
   import com.utterlySuperb.chumpManager.model.dataObjects.Message;
   import com.utterlySuperb.chumpManager.model.dataObjects.Player;
   import com.utterlySuperb.chumpManager.model.dataObjects.PlayerOffers;
   import com.utterlySuperb.chumpManager.model.dataObjects.SeasonStats;
   import com.utterlySuperb.chumpManager.model.dataObjects.competitions.Competition;
   import com.utterlySuperb.chumpManager.model.dataObjects.competitions.CompetitionInfo;
   import com.utterlySuperb.chumpManager.model.dataObjects.competitions.Cup;
   import com.utterlySuperb.chumpManager.model.dataObjects.competitions.League;
   import com.utterlySuperb.chumpManager.model.dataObjects.matches.Match;
   
   public class GameSaveConverter
   {
      
      public function GameSaveConverter()
      {
         super();
      }
      
      public static function turnGameToPrimitives(param1:Game) : Object
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc2_:Object = {};
         _loc2_.clubsOb = {};
         _loc2_.version = param1.version;
         _loc2_.slotNumber = param1.slotNumber;
         _loc2_.firstWeekend = param1.firstWeekend;
         _loc2_.currentDate = param1.currentDate;
         _loc2_.savedPlayers = {"playersList":[]};
         _loc3_ = 0;
         while(_loc3_ < param1.savedPlayers.playersList.length)
         {
            _loc2_.savedPlayers.playersList.push(getPlayerOb(param1.savedPlayers.playersList[_loc3_]));
            _loc3_++;
         }
         _loc2_.playerClub = param1.playerClub.name;
         _loc2_.playerFormation = getFormationOb(param1.playerFormation);
         _loc2_.playerOffers = [];
         _loc3_ = 0;
         while(_loc3_ < param1.playerOffers.length)
         {
            _loc4_ = {
               "cashOff":param1.playerOffers[_loc3_].cashOff,
               "player":param1.playerOffers[_loc3_].player,
               "club":param1.playerOffers[_loc3_].club.name
            };
            _loc2_.playerOffers.push(_loc4_);
            _loc3_++;
         }
         _loc2_.leagues = [];
         _loc3_ = 0;
         while(_loc3_ < param1.leagues.length)
         {
            _loc2_.leagues.push(makeObFromLeague(param1.leagues[_loc3_],_loc2_.clubsOb));
            _loc3_++;
         }
         _loc2_.otherLeagues = [];
         _loc3_ = 0;
         while(_loc3_ < param1.otherLeagues.length)
         {
            _loc2_.otherLeagues.push(makeObFromLeague(param1.otherLeagues[_loc3_],_loc2_.clubsOb));
            _loc3_++;
         }
         _loc2_.goalsList = param1.goalsList;
         _loc2_.offSeasonNum = param1.offSeasonNum;
         _loc2_.clubCash = param1.clubCash;
         _loc2_.seasonNum = param1.seasonNum;
         _loc2_.weekNum = param1.weekNum;
         _loc2_.weekend = param1.weekend;
         _loc2_.fixtureList = {};
         _loc2_.fixtureList.cups = [];
         _loc3_ = 0;
         while(_loc3_ < param1.fixtureList.cups.length)
         {
            _loc2_.fixtureList.cups.push(makeObFromCup(param1.fixtureList.cups[_loc3_],_loc2_.clubsOb));
            _loc3_++;
         }
         _loc2_.fixtureList.weeks = [];
         _loc3_ = 0;
         while(_loc3_ < param1.fixtureList.weeks.length)
         {
            _loc2_.fixtureList.weeks[_loc3_] = [];
            _loc5_ = 0;
            while(_loc5_ < param1.fixtureList.weeks[_loc3_].length)
            {
               _loc2_.fixtureList.weeks[_loc3_].push(makeObFromMatch(param1.fixtureList.weeks[_loc3_][_loc5_],_loc2_.clubsOb));
               _loc5_++;
            }
            _loc3_++;
         }
         _loc2_.fixtureList.weekendMatches = [];
         _loc3_ = 0;
         while(_loc3_ < param1.fixtureList.weekendMatches.length)
         {
            _loc2_.fixtureList.weekendMatches.push(makeObFromMatch(param1.fixtureList.weekendMatches[_loc3_],_loc2_.clubsOb));
            _loc3_++;
         }
         _loc2_.fixtureList.midweekMatches = [];
         _loc3_ = 0;
         while(_loc3_ < param1.fixtureList.midweekMatches.length)
         {
            _loc2_.fixtureList.midweekMatches.push(makeObFromMatch(param1.fixtureList.midweekMatches[_loc3_],_loc2_.clubsOb));
            _loc3_++;
         }
         _loc2_.fixtureList.unallocatedLeagueMatches = [];
         _loc3_ = 0;
         while(_loc3_ < param1.fixtureList.unallocatedLeagueMatches.length)
         {
            _loc2_.fixtureList.unallocatedLeagueMatches.push(makeObFromMatch(param1.fixtureList.unallocatedLeagueMatches[_loc3_],_loc2_.clubsOb));
            _loc3_++;
         }
         _loc2_.fixtureList.unallocatedCupMatches = [];
         _loc3_ = 0;
         while(_loc3_ < param1.fixtureList.unallocatedCupMatches.length)
         {
            _loc2_.fixtureList.unallocatedCupMatches.push(makeObFromMatch(param1.fixtureList.unallocatedCupMatches[_loc3_],_loc2_.clubsOb));
            _loc3_++;
         }
         if(param1.nextPlayerMatch)
         {
            _loc2_.nextPlayerMatch = makeObFromMatch(param1.nextPlayerMatch,_loc2_.clubsOb);
         }
         _loc2_.userMessages = [];
         _loc3_ = 0;
         while(_loc3_ < param1.userMessages.length)
         {
            _loc4_ = {
               "title":param1.userMessages[_loc3_].title,
               "body":param1.userMessages[_loc3_].body,
               "type":param1.userMessages[_loc3_].type
            };
            if(param1.userMessages[_loc3_].offer)
            {
               _loc4_.offer = {
                  "cashOff":param1.userMessages[_loc3_].offer.cashOff,
                  "toClub":param1.userMessages[_loc3_].offer.toClub.name,
                  "player":param1.userMessages[_loc3_].offer.player
               };
            }
            _loc2_.userMessages.push(_loc4_);
            _loc3_++;
         }
         return _loc2_;
      }
      
      private static function makeObFromLeague(param1:League, param2:Object) : Object
      {
         var _loc3_:Object = makeObFromCompetition(param1,param2);
         _loc3_.numInEuropeanCup = param1.numInEuropeanCup;
         _loc3_.numInUefaCup = param1.numInUefaCup;
         return _loc3_;
      }
      
      private static function makeObFromCup(param1:Cup, param2:Object) : Object
      {
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         var _loc3_:Object = makeObFromCompetition(param1,param2);
         _loc3_.type = param1.type;
         _loc3_.numRounds = param1.numRounds;
         _loc3_.finalRound = param1.finalRound;
         _loc3_.playsMatchesMidweek = param1.playsMatchesMidweek;
         _loc3_.legNum = param1.legNum;
         _loc3_.matches = [];
         var _loc4_:int = 0;
         while(_loc4_ < param1.matches.length)
         {
            _loc3_.matches[_loc4_] = [];
            _loc5_ = 0;
            while(_loc5_ < param1.matches[_loc4_].length)
            {
               _loc6_ = makeObFromMatch(param1.matches[_loc4_][_loc5_],param2);
               _loc3_.matches[_loc4_].push(_loc6_);
               _loc5_++;
            }
            _loc4_++;
         }
         _loc3_.knockedOut = [];
         _loc4_ = 0;
         while(_loc4_ < param1.knockedOut.length)
         {
            _loc3_.knockedOut.push(param1.knockedOut[_loc4_].name);
            _loc4_++;
         }
         return _loc3_;
      }
      
      private static function makeObFromMatch(param1:Match, param2:Object) : Object
      {
         var _loc3_:Object = {};
         _loc3_.club0 = makeObFromCompetitionInfo(param1.club0,param2,param1.competition);
         _loc3_.club1 = makeObFromCompetitionInfo(param1.club1,param2,param1.competition);
         if(param1.loser)
         {
            _loc3_.loser = param1.loser.club.name;
         }
         _loc3_.beenPlayed = param1.beenPlayed;
         _loc3_.needsWinner = param1.needsWinner;
         _loc3_.competition = param1.competition.name;
         _loc3_.club0Scorers = param1.club0Scorers;
         _loc3_.club1Scorers = param1.club1Scorers;
         _loc3_.club0Score = param1.club0Score;
         _loc3_.club1Score = param1.club1Score;
         _loc3_.club0ETScore = param1.club0ETScore;
         _loc3_.club1ETScore = param1.club1ETScore;
         _loc3_.extraTimePlayed = param1.extraTimePlayed;
         _loc3_.penaltiesScore0 = param1.penaltiesScore0;
         _loc3_.penaltiesScore1 = param1.penaltiesScore1;
         if(param1.firstLeg)
         {
            _loc3_.firstLeg = makeObFromMatch(param1.firstLeg,param2);
         }
         return _loc3_;
      }
      
      private static function makeObFromCompetition(param1:Competition, param2:Object) : Object
      {
         var _loc5_:CompetitionInfo = null;
         var _loc3_:Object = {"name":param1.name};
         _loc3_.entrants = [];
         var _loc4_:int = 0;
         while(_loc4_ < param1.entrants.length)
         {
            _loc5_ = param1.entrants[_loc4_];
            _loc3_.entrants.push(makeObFromCompetitionInfo(_loc5_,param2,param1));
            _loc4_++;
         }
         return _loc3_;
      }
      
      private static function makeObFromCompetitionInfo(param1:CompetitionInfo, param2:Object, param3:Competition) : Object
      {
         var _loc4_:Object = {
            "club":param1.club.name,
            "wins":param1.wins,
            "loses":param1.loses,
            "draws":param1.draws,
            "goalsScored":param1.goalsScored,
            "goalsConceeded":param1.goalsConceeded,
            "eliminated":param1.eliminated,
            "currentPosition":param1.currentPosition,
            "competition":param3.name
         };
         addToClubs(param2,param1.club);
         return _loc4_;
      }
      
      private static function getPlayerOb(param1:Player) : Object
      {
         var _loc3_:int = 0;
         var _loc4_:SeasonStats = null;
         var _loc2_:Object = {
            "id":param1.id,
            "name":param1.name,
            "nationality":param1.nationality,
            "birthDay":param1.birthDay
         };
         _loc2_.squadNumber = param1.squadNumber;
         _loc2_.trainingIntensity = param1.trainingIntensity;
         _loc2_.trainingType = param1.trainingType;
         _loc2_.statAdditions = param1.statAdditions;
         _loc2_.transferValue = param1.transferValue;
         _loc2_.age = param1.age;
         if(param1.club)
         {
            _loc2_.club = param1.club.name;
         }
         _loc2_.form = param1.form;
         _loc2_.stamina = param1.stamina;
         _loc2_.retireFlag = param1.retireFlag;
         _loc2_.minStats = param1.minStats;
         _loc2_.statClimb = param1.statClimb;
         _loc2_.statAdditions = param1.statAdditions;
         _loc2_.currentStats = param1.currentStats;
         _loc2_.progressType = param1.progressType;
         _loc2_.positions = param1.positions;
         _loc2_.basePostition = param1.basePostition;
         if(param1.seasonStats)
         {
            _loc2_.seasonStats = [];
            _loc3_ = 0;
            while(_loc3_ < param1.seasonStats.length)
            {
               _loc4_ = param1.seasonStats[_loc3_];
               _loc2_.seasonStats.push({
                  "goals":_loc4_.goals,
                  "assists":_loc4_.assists,
                  "appearances":_loc4_.appearances,
                  "subsAppearances":_loc4_.subsAppearances,
                  "yellowCards":_loc4_.yellowCards,
                  "redCards":_loc4_.redCards,
                  "scoreTotal":_loc4_.scoreTotal
               });
               _loc3_++;
            }
         }
         return _loc2_;
      }
      
      private static function getClubOb(param1:Club) : Object
      {
         var _loc2_:Object = {"name":param1.name};
         _loc2_.players = param1.players;
         _loc2_.isCore = param1.isCore;
         _loc2_.shortName = param1.shortName;
         _loc2_.profile = param1.profile;
         _loc2_.scoreMultiplier = param1.scoreMultiplier;
         return _loc2_;
      }
      
      private static function getFormationOb(param1:Formation) : Object
      {
         return {
            "positionsCol":param1.positionsCol,
            "positionsRow":param1.positionsRow,
            "prefferedPlayersID":param1.prefferedPlayersID,
            "positionTypes":param1.positionTypes,
            "attackingScore":param1.attackingScore
         };
      }
      
      private static function addToClubs(param1:Object, param2:Club) : void
      {
         if(param1[param2.name])
         {
            return;
         }
         var _loc3_:Object = getClubOb(param2);
         param1[param2.name] = _loc3_;
      }
      
      public static function turnPrimitivesToGame(param1:Object) : Game
      {
         var _loc3_:String = null;
         var _loc4_:Object = null;
         var _loc5_:Game = null;
         var _loc6_:int = 0;
         var _loc7_:Club = null;
         var _loc8_:PlayerOffers = null;
         var _loc9_:League = null;
         var _loc10_:Cup = null;
         var _loc11_:int = 0;
         var _loc12_:Match = null;
         var _loc13_:Message = null;
         var _loc2_:Object = {};
         for(_loc3_ in param1.clubsOb)
         {
            _loc7_ = getClubFromOb(param1.clubsOb[_loc3_]);
            _loc2_[_loc3_] = _loc7_;
         }
         _loc4_ = {};
         _loc5_ = new Game();
         _loc5_.version = param1.version;
         _loc5_.slotNumber = param1.slotNumber;
         _loc5_.firstWeekend = param1.firstWeekend;
         _loc5_.currentDate = param1.currentDate;
         _loc6_ = 0;
         while(_loc6_ < param1.savedPlayers.playersList.length)
         {
            _loc5_.savedPlayers.addPlayer(getPlayerFromOb(param1.savedPlayers.playersList[_loc6_],_loc2_));
            _loc6_++;
         }
         _loc5_.playerClub = _loc2_[param1.playerClub];
         _loc5_.playerFormation = new Formation();
         _loc5_.playerFormation.attackingScore = param1.playerFormation.attackingScore;
         _loc5_.playerFormation.positionsCol = param1.playerFormation.positionsCol;
         _loc5_.playerFormation.positionsRow = param1.playerFormation.positionsRow;
         _loc5_.playerFormation.positionTypes = param1.playerFormation.positionTypes;
         _loc5_.playerFormation.prefferedPlayersID = param1.playerFormation.prefferedPlayersID;
         _loc5_.playerOffers = [];
         _loc6_ = 0;
         while(_loc6_ < param1.playerOffers.length)
         {
            _loc8_ = new PlayerOffers();
            _loc8_.cashOff = param1.playerOffers[_loc6_].cashOff;
            _loc8_.toClub = _loc2_[param1.playerOffers[_loc6_].club];
            _loc8_.player = param1.playerOffers[_loc6_].player;
            _loc5_.playerOffers.push(param1);
            _loc6_++;
         }
         _loc5_.leagues = [];
         _loc6_ = 0;
         while(_loc6_ < param1.leagues.length)
         {
            _loc9_ = makeLeagueFromOb(param1.leagues[_loc6_],_loc2_);
            _loc5_.leagues.push(_loc9_);
            _loc4_[_loc9_.name] = _loc9_;
            _loc6_++;
         }
         _loc5_.otherLeagues = [];
         _loc6_ = 0;
         while(_loc6_ < param1.otherLeagues.length)
         {
            _loc9_ = makeLeagueFromOb(param1.otherLeagues[_loc6_],_loc2_);
            _loc5_.otherLeagues.push(_loc9_);
            _loc4_[_loc9_.name] = _loc9_;
            _loc6_++;
         }
         _loc5_.goalsList = param1.goalsList;
         _loc5_.offSeasonNum = param1.offSeasonNum;
         _loc5_.clubCash = param1.clubCash;
         _loc5_.seasonNum = param1.seasonNum;
         _loc5_.weekNum = param1.weekNum;
         _loc5_.weekend = param1.weekend;
         _loc5_.fixtureList = new FixturesList();
         _loc5_.fixtureList.cups = [];
         _loc6_ = 0;
         while(_loc6_ < param1.fixtureList.cups.length)
         {
            _loc10_ = makeCupFromOb(param1.fixtureList.cups[_loc6_],_loc2_);
            _loc5_.fixtureList.cups.push(_loc10_);
            _loc4_[_loc10_.name] = _loc10_;
            _loc10_.remakeCompInfRelationships();
            _loc6_++;
         }
         _loc5_.fixtureList.weeks = [];
         _loc6_ = 0;
         while(_loc6_ < param1.fixtureList.weeks.length)
         {
            _loc5_.fixtureList.weeks[_loc6_] = [];
            _loc11_ = 0;
            while(_loc11_ < param1.fixtureList.weeks[_loc6_].length)
            {
               _loc12_ = makeMatchFromOb(param1.fixtureList.weeks[_loc6_][_loc11_],_loc2_);
               _loc12_.competition = _loc4_[param1.fixtureList.weeks[_loc6_][_loc11_].competition];
               _loc5_.fixtureList.weeks[_loc6_].push(_loc12_);
               _loc11_++;
            }
            _loc6_++;
         }
         _loc5_.fixtureList.weekendMatches = [];
         _loc6_ = 0;
         while(_loc6_ < param1.fixtureList.weekendMatches.length)
         {
            _loc12_ = makeMatchFromOb(param1.fixtureList.weekendMatches[_loc6_],_loc2_);
            _loc12_.competition = _loc4_[param1.fixtureList.weekendMatches[_loc6_].competition];
            _loc5_.fixtureList.weekendMatches.push(_loc12_);
            _loc6_++;
         }
         _loc5_.fixtureList.midweekMatches = [];
         _loc6_ = 0;
         while(_loc6_ < param1.fixtureList.midweekMatches.length)
         {
            _loc12_ = makeMatchFromOb(param1.fixtureList.midweekMatches[_loc6_],_loc2_);
            _loc12_.competition = _loc4_[param1.fixtureList.midweekMatches[_loc6_].competition];
            _loc5_.fixtureList.midweekMatches.push(_loc12_);
            _loc6_++;
         }
         _loc5_.fixtureList.unallocatedLeagueMatches = [];
         _loc6_ = 0;
         while(_loc6_ < param1.fixtureList.unallocatedLeagueMatches.length)
         {
            _loc12_ = makeMatchFromOb(param1.fixtureList.unallocatedLeagueMatches[_loc6_],_loc2_);
            _loc12_.competition = _loc4_[param1.fixtureList.unallocatedLeagueMatches[_loc6_].competition];
            _loc5_.fixtureList.unallocatedLeagueMatches.push(_loc12_);
            _loc6_++;
         }
         _loc5_.fixtureList.unallocatedCupMatches = [];
         _loc6_ = 0;
         while(_loc6_ < param1.fixtureList.unallocatedCupMatches.length)
         {
            _loc12_ = makeMatchFromOb(param1.fixtureList.unallocatedCupMatches[_loc6_],_loc2_);
            _loc12_.competition = _loc4_[param1.fixtureList.unallocatedCupMatches[_loc6_].competition];
            _loc5_.fixtureList.unallocatedCupMatches.push(_loc12_);
            _loc6_++;
         }
         if(param1.nextPlayerMatch)
         {
            _loc12_ = makeMatchFromOb(param1.nextPlayerMatch,_loc2_);
            _loc12_.competition = _loc4_[param1.nextPlayerMatch.competition];
            _loc5_.nextPlayerMatch = _loc12_;
         }
         _loc5_.userMessages = [];
         _loc6_ = 0;
         while(_loc6_ < param1.userMessages.length)
         {
            _loc13_ = new Message();
            _loc13_.title = param1.userMessages[_loc6_].title;
            _loc13_.type = param1.userMessages[_loc6_].type;
            _loc13_.body = param1.userMessages[_loc6_].body;
            if(param1.userMessages[_loc6_].offer)
            {
               _loc13_.offer = new PlayerOffers();
               _loc13_.offer.cashOff = param1.userMessages[_loc6_].offer.cashOff;
               _loc13_.offer.toClub = _loc2_[param1.userMessages[_loc6_].offer.toClub];
               _loc13_.offer.player = param1.userMessages[_loc6_].offer.player;
            }
            _loc5_.userMessages.push(_loc13_);
            _loc6_++;
         }
         return _loc5_;
      }
      
      private static function getPlayerFromOb(param1:Object, param2:Object) : Player
      {
         var _loc4_:int = 0;
         var _loc5_:SeasonStats = null;
         var _loc3_:Player = new Player();
         _loc3_.id = param1.id;
         _loc3_.name = param1.name;
         _loc3_.age = param1.age;
         _loc3_.nationality = param1.nationality;
         _loc3_.birthDay = param1.birthDay;
         _loc3_.positions = param1.positions;
         _loc3_.basePostition = param1.basePostition;
         _loc3_.squadNumber = param1.squadNumber;
         _loc3_.trainingIntensity = param1.trainingIntensity;
         _loc3_.trainingType = param1.trainingType;
         _loc3_.statAdditions = param1.statAdditions;
         if(param1.club)
         {
            _loc3_.club = param2[param1.club];
         }
         _loc3_.form = param1.form;
         _loc3_.stamina = param1.stamina;
         _loc3_.retireFlag = param1.retireFlag;
         _loc3_.minStats = param1.minStats;
         _loc3_.statClimb = param1.statClimb;
         _loc3_.statAdditions = param1.statAdditions;
         _loc3_.currentStats = param1.currentStats;
         _loc3_.progressType = param1.progressType;
         _loc3_.transferValue = param1.transferValue;
         if(param1.seasonStats)
         {
            _loc3_.seasonStats = [];
            _loc4_ = 0;
            while(_loc4_ < param1.seasonStats.length)
            {
               _loc5_ = new SeasonStats();
               _loc5_.goals = param1.seasonStats[_loc4_].goals;
               _loc5_.assists = param1.seasonStats[_loc4_].assists;
               _loc5_.appearances = param1.seasonStats[_loc4_].appearances;
               _loc5_.subsAppearances = param1.seasonStats[_loc4_].subsAppearances;
               _loc5_.yellowCards = param1.seasonStats[_loc4_].yellowCards;
               _loc5_.redCards = param1.seasonStats[_loc4_].redCards;
               _loc5_.scoreTotal = param1.seasonStats[_loc4_].scoreTotal;
               _loc3_.seasonStats.push(_loc5_);
               _loc4_++;
            }
         }
         return _loc3_;
      }
      
      private static function getClubFromOb(param1:Object) : Club
      {
         var _loc2_:Club = new Club();
         _loc2_.name = param1.name;
         _loc2_.players = param1.players;
         _loc2_.isCore = param1.isCore;
         _loc2_.shortName = param1.shortName;
         _loc2_.profile = param1.profile;
         _loc2_.scoreMultiplier = param1.scoreMultiplier;
         return _loc2_;
      }
      
      private static function makeLeagueFromOb(param1:Object, param2:Object) : League
      {
         var _loc3_:League = new League();
         _loc3_.numInEuropeanCup = param1.numInEuropeanCup;
         _loc3_.numInUefaCup = param1.numInUefaCup;
         makeCompetitionFromOb(_loc3_,param1,param2);
         return _loc3_;
      }
      
      private static function makeCupFromOb(param1:Object, param2:Object) : Cup
      {
         var _loc5_:int = 0;
         var _loc6_:Match = null;
         var _loc7_:int = 0;
         var _loc3_:Cup = new Cup();
         makeCompetitionFromOb(_loc3_,param1,param2);
         _loc3_.type = param1.type;
         _loc3_.numRounds = param1.numRounds;
         _loc3_.finalRound = param1.finalRound;
         _loc3_.playsMatchesMidweek = param1.playsMatchesMidweek;
         _loc3_.legNum = param1.legNum;
         _loc3_.matches = [];
         var _loc4_:int = 0;
         while(_loc4_ < param1.matches.length)
         {
            _loc3_.matches[_loc4_] = [];
            _loc5_ = 0;
            while(_loc5_ < param1.matches[_loc4_].length)
            {
               _loc6_ = makeMatchFromOb(param1.matches[_loc4_][_loc5_],param2);
               _loc6_.competition = _loc3_;
               _loc3_.matches[_loc4_].push(_loc6_);
               if(param1.matches[_loc4_][_loc5_].loser)
               {
                  _loc7_ = 0;
                  while(_loc7_ < _loc3_.entrants.length)
                  {
                     if(_loc3_.entrants[_loc7_].club.name == param1.matches[_loc4_][_loc5_])
                     {
                        _loc6_.loser = _loc3_.entrants[_loc7_];
                     }
                     _loc7_++;
                  }
               }
               _loc5_++;
            }
            _loc4_++;
         }
         _loc3_.knockedOut = [];
         _loc4_ = 0;
         while(_loc4_ < param1.knockedOut.length)
         {
            _loc3_.knockedOut.push(param2[param1.knockedOut[_loc4_]]);
            _loc4_++;
         }
         return _loc3_;
      }
      
      private static function makeCompetitionFromOb(param1:Competition, param2:Object, param3:Object) : void
      {
         var _loc5_:CompetitionInfo = null;
         param1.name = param2.name;
         param1.entrants = [];
         var _loc4_:int = 0;
         while(_loc4_ < param2.entrants.length)
         {
            _loc5_ = new CompetitionInfo();
            _loc5_.club = param3[param2.entrants[_loc4_].club];
            _loc5_.wins = param2.entrants[_loc4_].wins;
            _loc5_.loses = param2.entrants[_loc4_].loses;
            _loc5_.draws = param2.entrants[_loc4_].draws;
            _loc5_.goalsScored = param2.entrants[_loc4_].goalsScored;
            _loc5_.goalsConceeded = param2.entrants[_loc4_].goalsConceeded;
            _loc5_.eliminated = param2.entrants[_loc4_].eliminated;
            _loc5_.currentPosition = param2.entrants[_loc4_].currentPosition;
            param1.entrants.push(_loc5_);
            _loc4_++;
         }
      }
      
      private static function makeMatchFromOb(param1:Object, param2:Object) : Match
      {
         var _loc3_:Match = new Match();
         _loc3_.club0 = makeCompetitionInfo(param1.club0,param2);
         _loc3_.club1 = makeCompetitionInfo(param1.club1,param2);
         _loc3_.beenPlayed = param1.beenPlayed;
         _loc3_.needsWinner = param1.needsWinner;
         _loc3_.club0Scorers = param1.club0Scorers;
         _loc3_.club1Scorers = param1.club1Scorers;
         _loc3_.club0Score = param1.club0Score;
         _loc3_.club1Score = param1.club1Score;
         _loc3_.club0ETScore = param1.club0ETScore;
         _loc3_.club1ETScore = param1.club1ETScore;
         _loc3_.extraTimePlayed = param1.extraTimePlayed;
         _loc3_.penaltiesScore0 = param1.penaltiesScore0;
         _loc3_.penaltiesScore1 = param1.penaltiesScore1;
         if(param1.firstLeg)
         {
            _loc3_.firstLeg = makeMatchFromOb(param1.firstLeg,param2);
         }
         if(_loc3_.beenPlayed)
         {
            _loc3_.loser = _loc3_.getLoser();
         }
         return _loc3_;
      }
      
      private static function makeCompetitionInfo(param1:Object, param2:Object) : CompetitionInfo
      {
         var _loc3_:CompetitionInfo = new CompetitionInfo();
         _loc3_.wins = param1.wins;
         _loc3_.loses = param1.loses;
         _loc3_.draws = param1.draws;
         _loc3_.goalsScored = param1.goalsScored;
         _loc3_.goalsConceeded = _loc3_.goalsConceeded;
         _loc3_.eliminated = param1.eliminated;
         _loc3_.currentPosition = param1.currentPosition;
         _loc3_.club = param2[param1.club];
         return _loc3_;
      }
   }
}

