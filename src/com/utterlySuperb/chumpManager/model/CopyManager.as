package com.utterlySuperb.chumpManager.model
{
   public class CopyManager
   {
      
      private static var copy:Object;
      
      private static var previousTips:Array;
      
      public static var matchCopyNumber:Array;
      
      public static const ENGLISH:String = "english";
      
      public static const KICK_OFF_MADE:String = "kickOffPassMade";
      
      public static const MATCH_STARTED:String = "matchStarted";
      
      public static const SHORT_PASS:String = "passtofeet";
      
      public static const LONG_PASS:String = "loftedpass";
      
      public static const PASS_FAIL:String = "passFail";
      
      public static const TAKE_POSSESSION:String = "takesPossession";
      
      public static const GOES_THROW_IN:String = "goesOutThrowIn";
      
      public static const PASS_TO_CORNER:String = "passToCorner";
      
      public static const PASS_TO_OPP_CORNER:String = "passToOppCorner";
      
      public static const PASS_TO_GOALKICK:String = "passToGoalKick";
      
      public static const PASS_TO_OPP_GOALKICK:String = "passToOppGoalKick";
      
      public static const TACKLE_FAIL:String = "tackleMissed";
      
      public static const TACKLE_MADE:String = "tackleMade";
      
      public static const FOUL_PLAYER:String = "fouledplayer";
      
      public static const INJURY:String = "injury";
      
      public static const YELLOW_CARD:String = "yellowcard";
      
      public static const SECOND_YELLOW_CARD:String = "secondbooking";
      
      public static const RED_CARD:String = "straightredcard";
      
      public static const PENALTY_GIVEN:String = "penaltygiven";
      
      public static const CROSS_MADE:String = "crossball";
      
      public static const SHOT_WIDE:String = "shotwide";
      
      public static const SHOT_OVER:String = "shotover";
      
      public static const AIR_SHOT:String = "airshot";
      
      public static const PLAYER_SHOT:String = "playershot";
      
      public static const CORNER:String = "cornertaken";
      
      public static const FREE_KICK_PASS:String = "freekickpass";
      
      public static const HEADED_AWAY:String = "headedaway";
      
      public static const GOAL:String = "goal";
      
      public static const PENALTY_RUN_UP:String = "penaltyrunup";
      
      public static const PENALTY_SCORE:String = "penaltyscore";
      
      public static const PENALTY_SAVE:String = "penaltysaved";
      
      public static const GAME_OVER:String = "gameOver";
      
      public static const SECOND_HALF_START:String = "secondHalfStarted";
      
      public static const KEEPER_CLAIM_CROSS:String = "keeperClaimsCross";
      
      public static const FIRST_HALF_END:String = "firstHalfEnds";
      
      public static const SUBSTITUTION:String = "substitution";
      
      public static const NOW_EXTRA_TIME:String = "nowExtraTime";
      
      public static const FIRST_EXTRA_TIME_START:String = "firstExtraTimeStarted";
      
      public static const FIRST_EXTRA_TIME_END:String = "extraHalfTime";
      
      public static const SECOND_EXTRA_TIME_START:String = "secondExtraTimeStarted";
      
      public static const SECOND_EXTRA_TIME_END:String = "extraFullTime";
      
      public static const NOW_PENALTIES:String = "nowPenalties";
      
      public static const PENALTIES_RESULT:String = "penaltiesResults";
      
      public static const SAVE_TO_CORNER:String = "saveToCorner";
      
      public static const SAVE_TO_COLLECT:String = "saveToCollect";
      
      public static const KEEPER_SAVE:String = "keepersaved";
      
      public static const numTackleMadeMessages:int = 1;
      
      public static const numTackleMissedMessages:int = 1;
      
      public static const numGotPossessionMessages:int = 1;
      
      public static const numPassMadeMessages:int = 1;
      
      public static const numKickOffPassMadeMessages:int = 1;
      
      public static const PLAYER_NAME_REPLACE:String = "{playerName}";
      
      public static const OTHER_PLAYER_NAME_REPLACE:String = "{otherplayerName}";
      
      public static const CLUB_NAME_REPLACE:String = "{clubName}";
      
      public static const OTHER_CLUB_NAME_REPLACE:String = "{otherClubName}";
      
      public static const WEEKNUM_REPLACE:String = "{weekNum}";
      
      public static const GAME_TIPS:String = "gameTip";
      
      public static const NUM_TIPS:int = 9;
      
      public function CopyManager()
      {
         super();
      }
      
      public static function init(param1:String = "english") : void
      {
         var _loc2_:XML = null;
         var _loc4_:XML = null;
         switch(param1)
         {
            case ENGLISH:
               _loc2_ = <data>
	<!-- league names -->
	<phrase id="premierLeague"><![CDATA[Premier league]]></phrase>
	<phrase id="championship"><![CDATA[Championship]]></phrase>
	<phrase id="leagueOne"><![CDATA[League One]]></phrase>
	<phrase id="leagueTwo"><![CDATA[League Two]]></phrase>
	<phrase id="serieA"><![CDATA[Serie A]]></phrase>
	<phrase id="laLigue"><![CDATA[La Liga]]></phrase>
	<phrase id="bundesleague"><![CDATA[Bundesliga]]></phrase>
	<phrase id="ligue1"><![CDATA[Ligue 1]]></phrase>
	<!-- league names -->
	<phrase id="faCup"><![CDATA[The FA Cup]]></phrase>
	<phrase id="leagueCup"><![CDATA[The League Cup]]></phrase>
	<phrase id="uefaCup"><![CDATA[The Uefa Cup]]></phrase>
	<phrase id="europeanCup"><![CDATA[The Europe Cup]]></phrase>
	<phrase id="communityShield"><![CDATA[The Community Shield]]></phrase>
	<!-- ui copy -->
	<phrase id="back"><![CDATA[Back]]></phrase>
	<phrase id="home"><![CDATA[Home]]></phrase>
	<phrase id="start"><![CDATA[Start]]></phrase>
	<phrase id="team page"><![CDATA[Team]]></phrase>
	<phrase id="transfers page"><![CDATA[Transfers]]></phrase>
	<phrase id="training page"><![CDATA[Trainging]]></phrase>
	<phrase id="statistics page"><![CDATA[Stats]]></phrase>
	<phrase id="next round"><![CDATA[Next round]]></phrase>
	<phrase id="options"><![CDATA[Options]]></phrase>
	<phrase id="cancel"><![CDATA[Cancel]]></phrase>
	<phrase id="ok"><![CDATA[Ok]]></phrase>
	<phrase id="close"><![CDATA[Close]]></phrase>
	<phrase id="accept"><![CDATA[Accept]]></phrase>
	<phrase id="decline"><![CDATA[Decline]]></phrase>
	<phrase id="currency"><![CDATA[£]]></phrase>
	<phrase id="areYouSure"><![CDATA[Are you sure?]]></phrase>
	<phrase id="setFormation"><![CDATA[Set formation]]></phrase>
	<phrase id="tactics"><![CDATA[Tactics]]></phrase>
	<phrase id="clubButtonInfo"><![CDATA[(Click here for Squad, Tactics and Training)]]></phrase>
	<phrase id="managersOffice"><![CDATA[Manager's Office]]></phrase>
	<phrase id="managersOfficeInfo"><![CDATA[(Click here for League tables, statistics, finances and to make transfers)]]></phrase>
	<phrase id="continueInfo"><![CDATA[(Click here to move time forward)]]></phrase>
	<phrase id="squad"><![CDATA[Squad]]></phrase>
	<phrase id="squadInfo"><![CDATA[(Click here to look at the players you have available)]]></phrase>
	<phrase id="tacticsInfo"><![CDATA[(Click here to set your default team and formation)]]></phrase>
	<phrase id="training"><![CDATA[Training]]></phrase>
	<phrase id="trainingInfo"><![CDATA[(Click here to set training routines for your players to improve their skills)]]></phrase>
	<phrase id="backInfo"><![CDATA[(Click here to go back to the Matchday screen)]]></phrase>
	<phrase id="backToManagerInfo"><![CDATA[(Click here to go back to the Manager's screen)]]></phrase>
	<phrase id="clubCash"><![CDATA[Club cash: ]]></phrase>
	<phrase id="competitions"><![CDATA[Competitions]]></phrase>
	<phrase id="competitionsInfo"><![CDATA[(Click here to view your current standings and top scorers)]]></phrase>
	<phrase id="transfers"><![CDATA[Transfers]]></phrase>
	<phrase id="transfersInfo"><![CDATA[(Click here to bid on players from other teams and put your players up for sale)]]></phrase>
	<phrase id="financesInfo"><![CDATA[(Click here to view the club's finances)]]></phrase>
	<phrase id="backInfo"><![CDATA[(Click here to go back to the Matchday Menu)]]></phrase>
	<phrase id="playerSearch"><![CDATA[Search for a Player]]></phrase>
	<phrase id="playerSearchInfo"><![CDATA[(Click here to search players by attributes)]]></phrase>
	<phrase id="league"><![CDATA[League]]></phrase>
	<phrase id="prevLeague"><![CDATA[Prev League]]></phrase>
	<phrase id="nextLeague"><![CDATA[Next League]]></phrase>
	<phrase id="browseClubs"><![CDATA[Browse a Club's players]]></phrase>
	<phrase id="browseClubsInfo"><![CDATA[(Click here to sort by clubs)]]></phrase>
	<phrase id="sellPlayer"><![CDATA[Sell a player]]></phrase>
	<phrase id="sellPlayerInfo"><![CDATA[(Click here to sell a player quickly to raise some cash)]]></phrase>
	<!-- Formation page -->
	<phrase id="saveFormation"><![CDATA[Save formation]]></phrase>
	<phrase id="autofill"><![CDATA[Auto-fill]]></phrase>
	<phrase id="undoChanges"><![CDATA[Undo changes]]></phrase>
	<phrase id="done"><![CDATA[Done]]></phrase>
	<!-- Load/save -->
	<phrase id="empty"><![CDATA[Empty]]></phrase>
	<phrase id="chooseSave"><![CDATA[Choose save]]></phrase>
	<!-- Options -->
	<phrase id="resumeGame"><![CDATA[Resume game]]></phrase>
	<phrase id="quitGame"><![CDATA[Quit game]]></phrase>
	<phrase id="changeLanguage"><![CDATA[Switch language]]></phrase>
	<!-- natioalities -->
	<phrase id="en"><![CDATA[England]]></phrase>
	<phrase id="nw"><![CDATA[Norway]]></phrase>
	<phrase id="to"><![CDATA[Togo]]></phrase>
	<phrase id="ir"><![CDATA[Ireland]]></phrase>
	<phrase id="bu"><![CDATA[Bulgaria]]></phrase>
	<phrase id="us"><![CDATA[USA]]></phrase>
	<phrase id="es"><![CDATA[Spain]]></phrase>
	<phrase id="we"><![CDATA[Wales]]></phrase>
	<phrase id="ag"><![CDATA[Argentina]]></phrase>
	<phrase id="it"><![CDATA[Italy]]></phrase>
	<phrase id="ni"><![CDATA[Northern Ireland]]></phrase>
	<phrase id="cz"><![CDATA[Czech Republic]]></phrase>
	<phrase id="sw"><![CDATA[Sweden]]></phrase>
	<phrase id="br"><![CDATA[Belarus]]></phrase>
	<phrase id="ch"><![CDATA[Chile]]></phrase>
	<phrase id="au"><![CDATA[Australia]]></phrase>
	<phrase id="nz"><![CDATA[New Zealand]]></phrase>
	<phrase id="co"><![CDATA[Congo]]></phrase>
	<phrase id="gn"><![CDATA[Grenada]]></phrase>
	<phrase id="gh"><![CDATA[Ghana]]></phrase>
	<phrase id="fi"><![CDATA[Finland]]></phrase>
	<phrase id="ic"><![CDATA[Iceland]]></phrase>
	<phrase id="sk"><![CDATA[South Korea]]></phrase>
	<phrase id="ja"><![CDATA[Jamaica]]></phrase>
	<phrase id="po"><![CDATA[Poland]]></phrase>
	<phrase id="pr"><![CDATA[Portugal]]></phrase>
	<phrase id="se"><![CDATA[Serbia]]></phrase>
	<phrase id="ru"><![CDATA[Russia]]></phrase>
	<phrase id="ng"><![CDATA[Nigeria]]></phrase>
	<phrase id="sl"><![CDATA[Slovakia]]></phrase>
	<phrase id="be"><![CDATA[Belgium]]></phrase>
	<phrase id="sa"><![CDATA[South Africa]]></phrase>
	<phrase id="sz"><![CDATA[Switzerland]]></phrase>
	<phrase id="hu"><![CDATA[Hungary]]></phrase>
	<phrase id="gr"><![CDATA[Greece]]></phrase>
	<phrase id="ar"><![CDATA[Argentina]]></phrase>
	<phrase id="co"><![CDATA[Columbia]]></phrase>
	<phrase id="ge"><![CDATA[Germany]]></phrase>
	<phrase id="pa"><![CDATA[Paraguay]]></phrase>
	<phrase id="ec"><![CDATA[Ecuador]]></phrase>
	<phrase id="sn"><![CDATA[Senegal]]></phrase>
	<phrase id="tu"><![CDATA[Turkey]]></phrase>
	<phrase id="tr"><![CDATA[Trinidad and Tobago]]></phrase>
	<phrase id="ma"><![CDATA[Mali]]></phrase>
	<phrase id="cam"><![CDATA[Cameroon]]></phrase>
	<phrase id="ho"><![CDATA[Honduras]]></phrase>
	<phrase id="ro"><![CDATA[Romania]]></phrase>
	<phrase id="as"><![CDATA[Austria]]></phrase>
	<phrase id="dc"><![CDATA[Democratic Republic of Congo]]></phrase>
	<phrase id="ba"><![CDATA[Barbados]]></phrase>
	<phrase id="al"><![CDATA[Algeria]]></phrase>
	<!-- stats copy -->
	<phrase id="passing"><![CDATA[Passing]]></phrase>
	<phrase id="tackling"><![CDATA[Tackling]]></phrase>
	<phrase id="heading"><![CDATA[Heading]]></phrase>
	<phrase id="shooting"><![CDATA[Shooting]]></phrase>
	<phrase id="crossing"><![CDATA[Crossing]]></phrase>
	<phrase id="dribbling"><![CDATA[Dribbling]]></phrase>
	<phrase id="speed"><![CDATA[Speed]]></phrase>
	<phrase id="stamina"><![CDATA[Stamina]]></phrase>
	<phrase id="maxStamina"><![CDATA[Max stamina]]></phrase>
	<phrase id="creativity"><![CDATA[Creativity]]></phrase>
	<phrase id="aggression"><![CDATA[Aggression]]></phrase>
	<phrase id="fitness"><![CDATA[Fitness]]></phrase>
	<phrase id="strength"><![CDATA[Strength]]></phrase>
	<phrase id="catching"><![CDATA[Catching]]></phrase>
	<phrase id="shotStopping"><![CDATA[Shot Stopping]]></phrase>
	<phrase id="distribution"><![CDATA[Distribution]]></phrase>
	<phrase id="age"><![CDATA[Age]]></phrase>
	<phrase id="form"><![CDATA[Form]]></phrase>
	<phrase id="creativity"><![CDATA[Creativity]]></phrase>
	<phrase id="rating"><![CDATA[Rating]]></phrase>
	<phrase id="matchRating"><![CDATA[Match rating]]></phrase>
	<phrase id="playerRating"><![CDATA[Player rating]]></phrase>
	<!-- start screen -->
	<phrase id="newGame"><![CDATA[New Game]]></phrase>
	<phrase id="loadGame"><![CDATA[Load Game]]></phrase>
	<phrase id="clearSaves"><![CDATA[Clear saves]]></phrase>
	<phrase id="followMousebreaker"><![CDATA[Follow Mousebreaker]]></phrase>
	<phrase id="followMousebreakerUrl"><![CDATA[http://www.twitter.com/mousebreaker]]></phrase>
	<phrase id="becomeAFan"><![CDATA[<font size="12">Become a fan of Ultimate Football Management</font>]]></phrase>
	<phrase id="becomeAFanUrl"><![CDATA[http://www.facebook.com/pages/Mousebreakers-Ultimate-Football-Manager/146930885365072]]></phrase>
	<!-- setup screen -->
	<phrase id="enterName"><![CDATA[Enter name]]></phrase>
	<phrase id="clubProfile"><![CDATA[Club status: ]]></phrase>
	<phrase id="attack:"><![CDATA[Attack: ]]></phrase>
	<phrase id="defense:"><![CDATA[Defense: ]]></phrase>
	<phrase id="scoreMult:"><![CDATA[Score Multiplier: ]]></phrase>
	<phrase id="chooseSaveSlot"><![CDATA[Choose save slot]]></phrase>
	<phrase id="areYouSure"><![CDATA[Are you sure?]]></phrase>
	<phrase id="overwriteSave"><![CDATA[Saving in this slot will overwrite the game currently there, deleting it.]]></phrase>
	<!-- main screen -->
	<phrase id="upcomingMatches"><![CDATA[Upcoming matches]]></phrase>
	<phrase id="leagueTable"><![CDATA[League table]]></phrase>	
	<phrase id="matchMidWeeknum"><![CDATA[Match week {weekNum} (midweek)]]></phrase>	
	<phrase id="matchWeeknum"><![CDATA[Match week {weekNum}]]></phrase>	
	<phrase id="offSeasonNum"><![CDATA[Off-Season week {weekNum}]]></phrase>	
	<phrase id="cupsInfo"><![CDATA[Cups info]]></phrase>	
	<phrase id="transferOpen"><![CDATA[Transfer window open]]></phrase>	
	<phrase id="transferOpenCopy"><![CDATA[You can now make bids for players and sell or release your own players.]]></phrase>	
	<phrase id="transferClosed"><![CDATA[Transfer window closed]]></phrase>	
	<phrase id="transferClosedCopy"><![CDATA[You must now wait til the next transfer window.]]></phrase>	
	<phrase id="leaguePosition"><![CDATA[League position:]]></phrase>	
	<!-- stat screen -->
	<phrase id="entrants"><![CDATA[Entrants]]></phrase>
	<phrase id="competition"><![CDATA[Competition]]></phrase>
	<phrase id="information"><![CDATA[Information]]></phrase>
	<!-- Formations screen -->
	<phrase id="tacticsOptions"><![CDATA[Tactics options]]></phrase>
	<phrase id="tacticsOptionsBody"><![CDATA[Set formation or attacking intention]]></phrase>
	<phrase id="howAttacking"><![CDATA[Set attacking intention]]></phrase>
	<phrase id="veryDefensive"><![CDATA[Very defensive]]></phrase>
	<phrase id="defensive"><![CDATA[Defensive]]></phrase>
	<phrase id="balanced"><![CDATA[Balances]]></phrase>
	<phrase id="attacking"><![CDATA[Attacking]]></phrase>
	<phrase id="veryAttacking"><![CDATA[Very attacking]]></phrase>
	<phrase id="formation"><![CDATA[Set formation]]></phrase>
	
	<!-- cup copy -->
	<phrase id="youWinCup"><![CDATA[You've won {cupName}]]></phrase>
	<phrase id="youWinCupCopy"><![CDATA[What a fantastic win! What this means to the player and fans is amazing. You've raised the clubs profile.]]></phrase>
	<phrase id="cupWonCopy"><![CDATA[{clubName} has won {cupName}! Better luck next year!]]></phrase>
	<phrase id="cupFinished"><![CDATA[{cupName} is finished]]></phrase>
	<phrase id="youHaveWonCup"><![CDATA[You have won this cup]]></phrase>
	<phrase id="youHaveBeenKnockedOutCup"><![CDATA[You have been knocked out of this cup.]]></phrase>
	<phrase id="youAreNotInCup"><![CDATA[You are not in this cup.]]></phrase>
	<phrase id="yourNextMatch"><![CDATA[You are still in this cup. Your next match is on match week {weekNum}]]></phrase>
	<!-- positions copy -->
	<phrase id="cf"><![CDATA[cf]]></phrase>
	<phrase id="wf"><![CDATA[wf]]></phrase>
	<phrase id="am"><![CDATA[am]]></phrase>
	<phrase id="cm"><![CDATA[cm]]></phrase>
	<phrase id="dm"><![CDATA[dm]]></phrase>
	<phrase id="sm"><![CDATA[sm]]></phrase>
	<phrase id="fb"><![CDATA[fb]]></phrase>
	<phrase id="cb"><![CDATA[cb]]></phrase>
	<phrase id="wb"><![CDATA[wb]]></phrase>
	<phrase id="gk"><![CDATA[gk]]></phrase>
	<phrase id="cf_copy"><![CDATA[Center Forward]]></phrase>
	<phrase id="wf_copy"><![CDATA[Wing Forward]]></phrase>
	<phrase id="am_copy"><![CDATA[Attacking midfielder]]></phrase>
	<phrase id="cm_copy"><![CDATA[Center midfielder]]></phrase>
	<phrase id="dm_copy"><![CDATA[Defensive midfielder]]></phrase>
	<phrase id="sm_copy"><![CDATA[Side midfielder]]></phrase>
	<phrase id="fb_copy"><![CDATA[Full back]]></phrase>
	<phrase id="cb_copy"><![CDATA[Center back]]></phrase>
	<phrase id="wb_copy"><![CDATA[Wing back]]></phrase>
	<phrase id="gk_copy"><![CDATA[Goal keeper]]></phrase>
	<phrase id="fwd_copy"><![CDATA[Forward]]></phrase>
	<phrase id="mid_copy"><![CDATA[Midfielder]]></phrase>
	<phrase id="def_copy"><![CDATA[Defender]]></phrase>
	<phrase id="fwd"><![CDATA[fwd]]></phrase>
	<phrase id="mid"><![CDATA[mid]]></phrase>
	<phrase id="def"><![CDATA[def]]></phrase>
	<!-- Team info copy -->
	<phrase id="seasonStats"><![CDATA[Season stats:]]></phrase>
	<phrase id="appearances"><![CDATA[Appearances:]]></phrase>
	<phrase id="subAppearances"><![CDATA[As sub:]]></phrase>
	<phrase id="goals"><![CDATA[Goals:]]></phrase>
	<phrase id="yellowCards"><![CDATA[Yellow cards:]]></phrase>
	<phrase id="redCards"><![CDATA[Red cards:]]></phrase>
	<phrase id="isInjured"><![CDATA[Currently injured. Expected back in {numWeeks}]]></phrase>
	<phrase id="isSuspended"><![CDATA[Currently suspended. Suspension ends in {numWeeks}]]></phrase>
	<phrase id="playerReturns"><![CDATA[Player returns]]></phrase>
	<phrase id="finishStatusEffect_injury"><![CDATA[{playerName} has recovered from his injury.]]></phrase>
	<phrase id="finishStatusEffect_suspension"><![CDATA[{playerName} has returned from suspension.]]></phrase>
	<phrase id="playerInjured"><![CDATA[A player has been injured]]></phrase>
	<phrase id="playerInjuredCopy"><![CDATA[{playerName} has picked up an injury in training. He is expected back in {numWeeks}.<br><br>The heavier the training the greater the improvement, but the greater the chance of injury.]]></phrase>
	<phrase id="chooseAction"><![CDATA[Choose action]]></phrase>
	<phrase id="choosePlayerActionCopy"><![CDATA[What do you want to do to {playerName}]]></phrase>
	<phrase id="reallyReleasePlayer"><![CDATA[Do you really want to release {playerName}? This removes him from your team with no recompense.]]></phrase>
	<phrase id="onlySellWhen"><![CDATA[You can only sell players when the transfer window is open.]]></phrase>
	<phrase id="sellPlayer"><![CDATA[Sell Player]]></phrase>
	<phrase id="releasePlayer"><![CDATA[Release Player]]></phrase>
	<phrase id="trySellPlayer"><![CDATA[You are trying to sell {playerName}.]]></phrase>
	<phrase id="clubOfferForPlayer"><![CDATA[{clubName} will give you £{amount}]]></phrase>
	<!-- training copy -->
	<phrase id="keeperTraining"><![CDATA[Keeper training]]></phrase>
	<phrase id="generalTraining"><![CDATA[General training]]></phrase>
	<phrase id="physicalTraining"><![CDATA[Physical training]]></phrase>
	<phrase id="techniqueTraining"><![CDATA[Technique training]]></phrase>
	<phrase id="forwardTraining"><![CDATA[Forward training]]></phrase>
	<phrase id="midfieldTraining"><![CDATA[Midfield training]]></phrase>
	<phrase id="defenceTraining"><![CDATA[Defence training]]></phrase>
	<phrase id="wingerTraining"><![CDATA[Winger training]]></phrase>
	<phrase id="fullbackTraining"><![CDATA[Fullback training]]></phrase>
	<phrase id="changeTraining"><![CDATA[Change training regime]]></phrase>
	<phrase id="changeTrainingCopy"><![CDATA[Change training regime tailored to your player]]></phrase>
	<phrase id="changeKeeperTraining"><![CDATA[Keepers have only one type of training]]></phrase>
	<phrase id="noTraining"><![CDATA[None]]></phrase>
	<phrase id="lightTraining"><![CDATA[Light]]></phrase>
	<phrase id="mediumTraining"><![CDATA[Medium]]></phrase>
	<phrase id="heavyTraining"><![CDATA[Heavy]]></phrase>
	<phrase id="position"><![CDATA[Position]]></phrase>
	<phrase id="trainingType"><![CDATA[Training type]]></phrase>
	<phrase id="setTraining"><![CDATA[Set Training Regime]]></phrase>
	<!--Transfers copy-->
	<phrase id="transferScreen"><![CDATA[Transfers]]></phrase>
	<phrase id="currentTransfer"><![CDATA[Current transfers]]></phrase>
	<phrase id="noCurrentTransfers"><![CDATA[You have no current transfers pending.]]></phrase>
	<phrase id="currentTransfersCopy"><![CDATA[Transfers pending:]]></phrase>
	<phrase id="show"><![CDATA[Show]]></phrase>
	<phrase id="allPlayers"><![CDATA[All players]]></phrase>
	<phrase id="withAttributes"><![CDATA[with the following attributes]]></phrase>
	<phrase id="useFilters"><![CDATA[Use Filters]]></phrase>
	<phrase id="applyFilters"><![CDATA[Apply Filters]]></phrase>
	<phrase id="showFilters"><![CDATA[Show Filters]]></phrase>
	<phrase id="hideFilters"><![CDATA[Hide Filters]]></phrase>
	<phrase id="showCurrentTransfers"><![CDATA[Show current transfers]]></phrase>
	<phrase id="changeContract"><![CDATA[Change contract]]></phrase>
	<phrase id="makeOffer"><![CDATA[Make an offer]]></phrase>
	<phrase id="makeOffer?"><![CDATA[Make an offer?]]></phrase>
	<phrase id="makeOfferCopy"><![CDATA[Make an offer for [playerName], the [clubname] [position].<br><br>Your availble funds are {currentCash}.]]></phrase>
	<phrase id="makeOfferCopyNoClub"><![CDATA[Make an offer for [playerName], a [position] free agent.<br><br>Your availble funds are {currentCash}.]]></phrase>
	<phrase id="playerFreeAgent"><![CDATA[Is a free agent]]></phrase>
	<phrase id="changeOffer"><![CDATA[Change the offer]]></phrase>
	<phrase id="cancelOffer"><![CDATA[Cancel the offer for the player]]></phrase>
	<phrase id="changeOffer?"><![CDATA[Change the offer?]]></phrase>
	<phrase id="changeOfferCopy"><![CDATA[Change your offer for [playerName]?]]></phrase>
	<phrase id="feeOffered"><![CDATA[Transfer fee offered]]></phrase>
	<phrase id="salaryOffered"><![CDATA[Annual salary offered]]></phrase>
	<phrase id="availableFunds"><![CDATA[Available funds:]]></phrase>
	<phrase id="club"><![CDATA[Club]]></phrase>
	<phrase id="price"><![CDATA[Price]]></phrase>
	<phrase id="contractLength"><![CDATA[Contract length]]></phrase>
	<phrase id="1year"><![CDATA[1 year]]></phrase>
	<phrase id="Xyear"><![CDATA[XX year]]></phrase>
	<phrase id="Xyears"><![CDATA[XX years]]></phrase>
	<phrase id="1week"><![CDATA[1 week]]></phrase>
	<phrase id="Xweek"><![CDATA[XX week]]></phrase>
	<phrase id="Xweeks"><![CDATA[XX weeks]]></phrase>
	<phrase id="changeContract"><![CDATA[Change contract?]]></phrase>
	<phrase id="makeContractOffer"><![CDATA[Make offer]]></phrase>
	<phrase id="release"><![CDATA[Release]]></phrase>
	<phrase id="changeContractCopy"><![CDATA[Offer [playerName] a new contract, or release him? Releasing him will result in a [amount] penalty.]]></phrase>
	<phrase id="sureReleasePlayer"><![CDATA[Do you really want to release [playerName]? This will cost [amount].]]></phrase>
	<phrase id="estimatedValue"><![CDATA[Est. value]]></phrase>
	<phrase id="currentSalary"><![CDATA[Current salary]]></phrase>
	<phrase id="youHaveOffer"><![CDATA[Your offer:]]></phrase>
	<phrase id="transferClosed"><![CDATA[The transfer window is currently closed]]></phrase>
	<phrase id="transferUnsuccessful"><![CDATA[This transfer was unsuccessful]]></phrase>
	<phrase id="transferFeeBad"><![CDATA[{clubName} has rejected your offer for {playerName}]]></phrase>
	<phrase id="salaryFeeBad"><![CDATA[{clubName} has accepted your offer, but {playerName} has rejected the move.]]></phrase>
	<phrase id="salaryFeeBadNoClub"><![CDATA[{playerName} has rejected the move.]]></phrase>
	<phrase id="transferSuccess"><![CDATA[Transfer succeeded!]]></phrase>
	<phrase id="transferSuccessCopy"><![CDATA[{playerName} has joined your club!]]></phrase>
	<phrase id="transferNotification"><![CDATA[Transfer Notification]]></phrase>
	<phrase id="transferNotificationCopyFree"><![CDATA[{playerName} has joined {clubName} on a free transfer.]]></phrase>
	<phrase id="transferNotificationCopy"><![CDATA[{playerName} has joined {clubName} from {clubName2} for an undisclosed fee]]></phrase>
	<phrase id="transferOffer"><![CDATA[Transfer request]]></phrase>
	<phrase id="transferOfferCopy"><![CDATA[{clubName} wants to buy {playerName} from you. They have offered {transferFee}]]></phrase>
	<phrase id="all"><![CDATA[All]]></phrase>
	<phrase id="noClub"><![CDATA[No club]]></phrase>
	<phrase id="squadLimitHeader"><![CDATA[Squad limit reached]]></phrase>
	<phrase id="squadLimitCopy"><![CDATA[You have reached the squad limit of 52 players. If you want to sign this player you will need to release or sell and existing player.]]></phrase>
	<phrase id="showClubPlayers"><![CDATA[Show players from:]]></phrase>
	<phrase id="releaseInfo"><![CDATA[(Removes a player from your squad to free up squad spaces)]]></phrase>
	<phrase id="sellInfo"><![CDATA[(Cashing in will sell for less than a bid out of nowhere)]]></phrase>
	<!-- Match copy -->
	<phrase id="startMatch"><![CDATA[Start match]]></phrase>	
	<phrase id="changeFormation"><![CDATA[Change formation]]></phrase>	
	<phrase id="makeChange"><![CDATA[Make changes]]></phrase>	
	<phrase id="matchOptions"><![CDATA[Match Options]]></phrase>	
	<phrase id="beginNextHalf"><![CDATA[Begin second half]]></phrase>	
	<phrase id="continue"><![CDATA[Continue]]></phrase>	
	<phrase id="roundResultsX"><![CDATA[Match results, week {weekNum}]]></phrase>	
	<phrase id="restartMatch"><![CDATA[Restart the match]]></phrase>	
	<phrase id="gotoMatch"><![CDATA[Go to the match]]></phrase>	
	<phrase id="matchSpeed"><![CDATA[Set match speed]]></phrase>
	<phrase id="verySlow"><![CDATA[Very slow]]></phrase>
	<phrase id="slow"><![CDATA[Slow]]></phrase>
	<phrase id="medium"><![CDATA[Medium]]></phrase>
	<phrase id="fast"><![CDATA[Fast]]></phrase>
	<phrase id="veryFast"><![CDATA[Very fast]]></phrase>
	<!-- Match results screen -->
	<phrase id="successfulPasses"><![CDATA[Successful passes: ]]></phrase>
	<phrase id="totalPasses"><![CDATA[Total passes: ]]></phrase>
	<phrase id="goals"><![CDATA[Goals: ]]></phrase>
	<phrase id="assists"><![CDATA[Assists: ]]></phrase>
	<phrase id="saves"><![CDATA[Saves: ]]></phrase>
	<phrase id="goalsConceeded"><![CDATA[Goals conceeded: ]]></phrase>
	<phrase id="foulsConceeded"><![CDATA[Fouls conceeded: ]]></phrase>
	<phrase id="foulsWon"><![CDATA[Fouls won: ]]></phrase>
	<phrase id="shots"><![CDATA[Shots: ]]></phrase>
	<phrase id="shotsOnTarget"><![CDATA[Shots on target: ]]></phrase>
	<phrase id="possession"><![CDATA[Possession: ]]></phrase>
	<phrase id="matchIncome"><![CDATA[Match income:]]></phrase>
	<phrase id="doPenalties"><![CDATA[Go to penalties]]></phrase>
	<phrase id="penalties"><![CDATA[Penalties:]]></phrase>
	<!-- round results copy -->
	<phrase id="afterExtraTime"><![CDATA[aet]]></phrase>	
	<phrase id="XwinPenalties"><![CDATA[{clubName} win on penalties {penaltiesScore}]]></phrase>	
	<phrase id="pleaseWait"><![CDATA[Please wait]]></phrase>	
	<phrase id="playingRoundMatches"><![CDATA[Round matches are being played now.]]></phrase>	
	<!-- Feedback copy -->
	<phrase id="outOfFAHeader"><![CDATA[You've been knock out of the FA cup!]]></phrase>	
	<phrase id="outOfFACopy"><![CDATA[Your team just wasn't up to scratch. Shame because a good cup run is a nice little earner.]]></phrase>	
	<phrase id="outOfLeagueCupHeader"><![CDATA[You've been knock out of the League cup!]]></phrase>	
	<phrase id="outOfLeagueCupCopy"><![CDATA[I know what you're thinking, ' so what? It's only the league cup', but it's still silverware and fans like silverware.]]></phrase>	
	<!-- Stats screen copy -->
	<phrase id="finances"><![CDATA[Finances]]></phrase>
	<phrase id="currentBalance"><![CDATA[Current cash balance: ]]></phrase>
	<phrase id="annualSalary"><![CDATA[Annual wage bill: ]]></phrase>
	<phrase id="salaryPayable"><![CDATA[(Payable at the end of season)]]></phrase>
	<phrase id="matchesLeft"><![CDATA[League matches left: ]]></phrase>
	<phrase id="incomeAt50"><![CDATA[Match income if 50% win, 30% draw rate: ]]></phrase>
	<phrase id="meritPayment"><![CDATA[Merit payment for current league place: ]]></phrase>
	<phrase id="topScorer"><![CDATA[Top Scorers]]></phrase>
	<!-- Season end Screen -->
	<phrase id="seasonEnd"><![CDATA[Season over<font face="Arial" size="16"><br><br>You finished in position {finishPosition}.<br><br>This gets you a merit payment of {meritPayment}]]></phrase>
	<phrase id="eligleForEuro"><![CDATA[You've gained entry to the {cupName} next season!]]></phrase>
	<phrase id="postionScore"><![CDATA[Score for final position: ]]></phrase>
	<phrase id="goalScore"><![CDATA[Score for goals: ]]></phrase>
	<phrase id="goalDifScore"><![CDATA[Score for goal difference: ]]></phrase>
	<phrase id="seasonBonus"><![CDATA[Season Bonus: x]]></phrase>
	<phrase id="seasonClubBonus"><![CDATA[Club Bonus: x]]></phrase>
	<phrase id="clubBonus"><![CDATA[Club bonus: x]]></phrase>
	<phrase id="totalScore"><![CDATA[Total score: ]]></phrase>
	<phrase id="submitScore"><![CDATA[Submit score]]></phrase>
	<!-- Misc copy -->
	<phrase id="youthPlayer"><![CDATA[Youth player]]></phrase>
	<phrase id="updatingPlayers"><![CDATA[Updating players]]></phrase>
	<phrase id="pleaseSelect"><![CDATA[Please select]]></phrase>
	<phrase id="playerRetires"><![CDATA[A player has retired]]></phrase>
	<phrase id="playerRetiresCopy"><![CDATA[{playerName} has retired. Hopefully he's be as good a manager/pundit as he was a player!]]></phrase>
	<phrase id="buildingFixtures"><![CDATA[Building fixtures]]></phrase>
	<phrase id="buildingGame"><![CDATA[Building game]]></phrase>
</data>;
               _loc4_ = <data>
	<phrase id="goal0"><![CDATA[It's a fabulous goal by {playerName}!]]></phrase>
	<phrase id="goal1"><![CDATA[Goal! Cool finish from {playerName}.]]></phrase>
	<phrase id="goal2"><![CDATA[{playerName} tucks it away! Great play from {clubName}]]></phrase>
	<phrase id="goal3"><![CDATA[It's in! A belter from {playerName} - the keeper stood no chance!]]></phrase>
	<phrase id="goal4"><![CDATA[That's cannoned in off the post! Spectacular strike from {playerName}!]]></phrase>
	<phrase id="goal5"><![CDATA[What a goal! The keeper didn't even move!]]></phrase>
	<phrase id="goal6"><![CDATA[He puts those away for fun! No chance for the keeper]]></phrase>
	<phrase id="goal7"><![CDATA[Goal! {playerName} is mobbed by his team-mates as the goalie picks the ball out of his net...]]></phrase>
	<phrase id="goal8"><![CDATA[And {playerName} puts it beyond the goal keeper's reach! Goal!]]></phrase>
	<phrase id="goal9"><![CDATA[{playerName} gets his name on the score-sheet!]]></phrase>
	<phrase id="goal10"><![CDATA[{playerName} wheels away to celebrate! A fine finish!]]></phrase>
	<phrase id="goal11"><![CDATA[The keeper won't get there! Pick that one out!]]></phrase>
	<phrase id="goal12"><![CDATA[It's in! The fans chant {playerName}'s name!]]></phrase>

	<phrase id="matchStarted0"><![CDATA[And the match is underway]]></phrase>
	<phrase id="matchStarted1"><![CDATA[And the referee blows for kick-off...]]></phrase>
	<phrase id="matchStarted2"><![CDATA[And we're underway here, at last...]]></phrase>
	<phrase id="matchStarted3"><![CDATA[{playerName} kicks off...]]></phrase>
	<phrase id="matchStarted4"><![CDATA[The match begins!]]></phrase>
	<phrase id="matchStarted5"><![CDATA[And we've kicked off here...]]></phrase>
	
	<phrase id="firstHalfEnds0"><![CDATA[That's the end of an intruiguing first half. We can only hope the second half lives up to it]]></phrase>
	<phrase id="firstHalfEnds1"><![CDATA[The referee blows for half time a certainly one team will be happier tha the other]]></phrase>
	<phrase id="firstHalfEnds2"><![CDATA[An end to the first period. the managers will have a lot to say to their players now]]></phrase>
	<phrase id="firstHalfEnds3"><![CDATA[It's a game of two halves, and the first one just ended]]></phrase>
	
	<phrase id="secondHalfStarted0"><![CDATA[45 minutes to go then, as {playerName} kicks off the second half]]></phrase>	
	<phrase id="secondHalfStarted1"><![CDATA[And the managers are back in their dugouts, as the second half begins...]]></phrase>	
	<phrase id="secondHalfStarted2"><![CDATA[We're about ready to kick off the second half]]></phrase>	
	<phrase id="secondHalfStarted3"><![CDATA[And the second half is underway]]></phrase>	
	<phrase id="secondHalfStarted4"><![CDATA[Let's see what the managers' team-talks will have done...]]></phrase>	
	<phrase id="secondHalfStarted5"><![CDATA[And the players are back on the pitch for the second half]]></phrase>	
	<phrase id="secondHalfStarted6"><![CDATA[The referee blows for the start of the second half]]></phrase>	

	<phrase id="gameOver0"><![CDATA[It's full time. What a cracking game!]]></phrase>
	<phrase id="gameOver1"><![CDATA[The final whistle goes!]]></phrase>
	<phrase id="gameOver2"><![CDATA[The referee blows time on this one...]]></phrase>
	<phrase id="gameOver3"><![CDATA[And the referee calls time on the match!]]></phrase>
	<phrase id="gameOver4"><![CDATA[And that'll be the last kick of the game. Full time here...]]></phrase>
	<phrase id="gameOver5"><![CDATA[The referee looks at his watch... and blows for full time!]]></phrase>
	<phrase id="gameOver6"><![CDATA[And the referee blows the whistle on a memorable match...]]></phrase>
	<phrase id="gameOver7"><![CDATA[It's all over! The managers shake hands and head down the dugout...]]></phrase>
	<phrase id="gameOver8"><![CDATA[That's it! Full time, and both managers will reflect on what we've seen today...]]></phrase>
	<phrase id="gameOver9"><![CDATA[The final whistle blows! An entertaining match.]]></phrase>
	<phrase id="gameOver10"><![CDATA[There's the final whistle, and much to reflect on here for both managers...]]></phrase>
	<phrase id="gameOver11"><![CDATA[The referee glances at his watch and blows for full time!]]></phrase>
	
	<phrase id="nowExtraTime0"><![CDATA[It ends all even. Now we move on to extra time!]]></phrase>
	
	<phrase id="firstExtraTimeStarted0"><![CDATA[The first period of extra time has started!]]></phrase>
	
	<phrase id="extraHalfTime0"><![CDATA[The first spell of extra time ends. There are some very tired legs out there]]></phrase>
	
	<phrase id="secondExtraTimeStarted0"><![CDATA[The players are back on the field and it's the fitter team that will finish stronger]]></phrase>
	
	<phrase id="extraFullTime0"><![CDATA[And it's all over!]]></phrase>
	
	<phrase id="nowPenalties0"><![CDATA[It's ended all square so we now go on to penalties.]]></phrase>
	
	<phrase id="penaltiesResults0"><![CDATA[{winClub} beats {loseClub} {score0}-{score1}. That was cruel!]]></phrase>
	
	<phrase id="tackleMade0"><![CDATA[{otherplayerName} wins the ball from {playerName} with a wonderfully timed tackle.]]></phrase>
	<phrase id="tackleMade1"><![CDATA[{otherplayerName} wins the ball back from {playerName}.]]></phrase>
	<phrase id="tackleMade2"><![CDATA[{playerName} is shoved off the ball by {otherplayerName}. Play on, says the ref!]]></phrase>
	<phrase id="tackleMade3"><![CDATA[{otherplayerName} slides in on {playerName} and wins the ball. Great tackle!]]></phrase>
	<phrase id="tackleMade4"><![CDATA[{otherplayerName} puts a boot in and wins the ball back. Superb defending!]]></phrase>
	<phrase id="tackleMade5"><![CDATA[{otherplayerName} sends {playerName} flying! Play on says the referee, as the fans jeer!]]></phrase>
	<phrase id="tackleMade6"><![CDATA[{playerName} loses the ball far too cheaply to {otherplayerName}]]></phrase>
	<phrase id="tackleMade7"><![CDATA[{otherplayerName} disposesses {playerName} - he made that look easy!]]></phrase>
	<phrase id="tackleMade8"><![CDATA[{otherplayerName} wins the ball back with ease.]]></phrase>
	<phrase id="tackleMade9"><![CDATA[Great tackle from {otherplayerName} - there was no way {playerName} was getting through, there!]]></phrase>
	<phrase id="tackleMade10"><![CDATA[Super tackle from {otherplayerName} on {playerName}, winning the ball cleanly.]]></phrase>
	<phrase id="tackleMade11"><![CDATA[The danger is averted as {otherplayerName} comfortably wins the ball back from {playerName}]]></phrase>
	
	<phrase id="tackleMissed0"><![CDATA[{otherplayerName} tries to nick the ball but {playerName} just skips past him]]></phrase>	
	<phrase id="tackleMissed1"><![CDATA[{playerName} pushes past the challenge of {otherplayerName}]]></phrase>	
	<phrase id="tackleMissed2"><![CDATA[{otherplayerName} tries to nick the ball but {playerName} just skips past him]]></phrase>	
	<phrase id="tackleMissed3"><![CDATA[{playerName} sidesteps the challenge from {otherplayerName}]]></phrase>	
	<phrase id="tackleMissed4"><![CDATA[{playerName} leaves {otherplayerName} for dead!]]></phrase>	
	<phrase id="tackleMissed5"><![CDATA[{playerName} evades the challenge of {otherplayerName}]]></phrase>	
	<phrase id="tackleMissed6"><![CDATA[{playerName} dodges past {otherplayerName}, the ball stuck to his feet!]]></phrase>	
	<phrase id="tackleMissed7"><![CDATA[{otherplayerName} slides in on {playerName}, but {playerName} keeps going]]></phrase>	
	<phrase id="tackleMissed8"><![CDATA[{playerName} pushes the ball past {otherplayerName}]]></phrase>	
	<phrase id="tackleMissed9"><![CDATA[{otherplayerName} tries to nick the ball but {playerName} just skips past him]]></phrase>	
	<phrase id="tackleMissed10"><![CDATA[{playerName} skillfully slips past {otherplayerName}]]></phrase>	
	<phrase id="tackleMissed11"><![CDATA[{otherplayerName} sticks a foot in, but {playerName} still has the ball]]></phrase>	
	<phrase id="tackleMissed12"><![CDATA[{playerName} stumbles over the challenge of {otherplayerName}, but somehow keeps going]]></phrase>	

	<phrase id="takesPossession0"><![CDATA[{playerName} picks up the ball for {clubName}]]></phrase>
	<phrase id="takesPossession1"><![CDATA[{playerName} has the ball for {clubName}]]></phrase>
	<phrase id="takesPossession2"><![CDATA[{playerName} takes possession for {clubName}]]></phrase>
	<phrase id="takesPossession3"><![CDATA[{playerName} is on the ball for {clubName}]]></phrase>
	<phrase id="takesPossession4"><![CDATA[{playerName} collects the ball]]></phrase>
	<phrase id="takesPossession5"><![CDATA[The ball is with {playerName} now]]></phrase>
	<phrase id="takesPossession6"><![CDATA[{playerName} in possession now]]></phrase>
	<phrase id="takesPossession7"><![CDATA[{clubName} have the ball now, with {playerName}]]></phrase>
	<phrase id="takesPossession8"><![CDATA[{clubName} pushing forwards now with {playerName}]]></phrase>
	<phrase id="takesPossession9"><![CDATA[{clubName} coming forward now with {playerName}]]></phrase>
	<phrase id="takesPossession10"><![CDATA[{playerName} is pushing forwards now for {clubName}]]></phrase>
	<phrase id="takesPossession11"><![CDATA[{clubName} slowing the play down now, with {playerName}]]></phrase>
	<phrase id="takesPossession12"><![CDATA[{playerName} has the ball at his feet now]]></phrase>

	<phrase id="airshot0"><![CDATA[{playerName} meets the ball with his head]]></phrase>
	<phrase id="airshot1"><![CDATA[{playerName} beats {otherplayerName} in the air]]></phrase>
	<phrase id="airshot2"><![CDATA[{playerName} with a looping header]]></phrase>
	<phrase id="airshot3"><![CDATA[{playerName} is unmarked with a free header]]></phrase>
	<phrase id="airshot4"><![CDATA[{playerName} with the diving header!]]></phrase>
	<phrase id="airshot5"><![CDATA[{playerName} heads it goalwards]]></phrase>
	<phrase id="airshot6"><![CDATA[{playerName} with a powerful header!]]></phrase>
	<phrase id="airshot7"><![CDATA[{playerName} on the volley]]></phrase>
	<phrase id="airshot8"><![CDATA[{playerName} with a spectacular bicycle kick ]]></phrase>
	<phrase id="airshot9"><![CDATA[{playerName} meets the ball with his head]]></phrase>
	<phrase id="airshot10"><![CDATA[{playerName} connects with it]]></phrase>
	<phrase id="airshot11"><![CDATA[{playerName} gets his head to it]]></phrase>
	<phrase id="airshot12"><![CDATA[{playerName} volleys it towards goal]]></phrase>
	<phrase id="airshot13"><![CDATA[{playerName} with a free header!]]></phrase>
	<phrase id="airshot14"><![CDATA[The ball meets the head of {playerName}]]></phrase>
	<phrase id="airshot15"><![CDATA[The ball loops to the unmarked {playerName}]]></phrase>
	<phrase id="airshot16"><![CDATA[{playerName} with a glancing header]]></phrase>

	<phrase id="playershot0"><![CDATA[{playerName} with a stinging drive!]]></phrase>
	<phrase id="playershot1"><![CDATA[{playerName} takes a shot]]></phrase>
	<phrase id="playershot2"><![CDATA[{playerName} tries to lob the keeper]]></phrase>
	<phrase id="playershot3"><![CDATA[{playerName} sends it goalwards]]></phrase>
	<phrase id="playershot4"><![CDATA[{playerName} with a curling shot!]]></phrase>
	<phrase id="playershot5"><![CDATA[{playerName} aims for the bottom corner]]></phrase>
	<phrase id="playershot6"><![CDATA[{playerName} with a speculative effort]]></phrase>
	<phrase id="playershot7"><![CDATA[{playerName} chips it goalwards]]></phrase>
	<phrase id="playershot8"><![CDATA[{playerName}'s shot is deflected off {otherplayerName}]]></phrase>
	<phrase id="playershot9"><![CDATA[{playerName} races clear and takes a shot]]></phrase>
	<phrase id="playershot10"><![CDATA[{playerName} hits it first time!]]></phrase>
	<phrase id="playershot11"><![CDATA[{playerName} slides it towards goal]]></phrase>
	<phrase id="playershot12"><![CDATA[{playerName} tries to beat the keeper]]></phrase>
	<phrase id="playershot13"><![CDATA[{playerName} pushes it towards goal]]></phrase>
	<phrase id="playershot14"><![CDATA[{playerName} flicks it towards goal]]></phrase>
	<phrase id="playershot15"><![CDATA[{playerName} has his sights on the goal]]></phrase>

	<phrase id="straightredcard0"><![CDATA[The referee reaches into his pocket and pulls out the red card! {playerName} is sent off for {clubName}!]]></phrase>
	<phrase id="straightredcard1"><![CDATA[The referee has stopped play. He's calling {playerName} over... It's a straight red card!]]></phrase>
	<phrase id="straightredcard2"><![CDATA[No surprises there, a straight red for {playerName}. He simply had to go.]]></phrase>
	<phrase id="straightredcard3"><![CDATA[{playerName} has been dismissed! That seemed harsh.]]></phrase>
	<phrase id="straightredcard4"><![CDATA[The fans are calling for blood here - and there it is: red card for {playerName}!]]></phrase>
	<phrase id="straightredcard5"><![CDATA[That was nasty from {playerName}. The referee is taking a card out - and yes, it's red!]]></phrase>
	<phrase id="straightredcard6"><![CDATA[{otherClubName} are swarming round the referee - and yes, it's a red card for {playerName}]]></phrase>
	<phrase id="straightredcard7"><![CDATA[The fans cheer as {playerName} is shown the red card]]></phrase>
	<phrase id="straightredcard8"><![CDATA[The referee is trying to calm things down... but that won't help! Straight red card for {playerName}!]]></phrase>

	<phrase id="yellowcard0"><![CDATA[The referee shows {playerName} a yellow card.]]></phrase>
	<phrase id="yellowcard1"><![CDATA[No surprises there - {playerName} is shown the yellow card.]]></phrase>
	<phrase id="yellowcard2"><![CDATA[{playerName} is cautioned. Yellow card.]]></phrase>
	<phrase id="yellowcard3"><![CDATA[{playerName}'s name goes in the book for that challenge.]]></phrase>
	<phrase id="yellowcard4"><![CDATA[The referee calls {playerName} over, and produces a yellow card.]]></phrase>
	<phrase id="yellowcard5"><![CDATA[No surprises there - {playerName} goes in the book.]]></phrase>
	<phrase id="yellowcard6"><![CDATA[{playerName} is shown the yellow card. That seemed harsh.]]></phrase>
	<phrase id="yellowcard7"><![CDATA[Yellow card for {playerName}. He'll need to be careful from now on.]]></phrase>
	<phrase id="yellowcard8"><![CDATA[{playerName} is lucky to get away with just a yellow card for that challenge!]]></phrase>
	<phrase id="yellowcard9"><![CDATA[The fans are calling blood here - but, no, just a yellow card for {playerName} this time. Lucky escape.]]></phrase>
	<phrase id="yellowcard10"><![CDATA[The referee is reaching for a card - just yellow. {playerName} goes in the book.]]></phrase>	

	<phrase id="secondbooking0"><![CDATA[The referee is calling {playerName} over - he's already been booked! He's off.]]></phrase>
	<phrase id="secondbooking1"><![CDATA[{playerName} knows what's coming - he's already heading down the tunnel. Sure enough, there's the second booking - he's off!]]></phrase>
	<phrase id="secondbooking2"><![CDATA[{playerName} is pleading with the referee, but it won't make a difference - there is his second yellow card!]]></phrase>
	<phrase id="secondbooking3"><![CDATA[That's {playerName}'s second yellow - he's off.]]></phrase>
	<phrase id="secondbooking4"><![CDATA[The players are swarming around the referee. He's reaching for a second yellow card... and that's it! {playerName} is getting an early bath!]]></phrase>
	<phrase id="secondbooking5"><![CDATA[{playerName} is shaking his head in astonishment as the referee produces a second yellow card!]]></phrase>
	<phrase id="secondbooking6"><![CDATA[{clubName} will lose a man now - that's a second yellow card for {playerName}]]></phrase>

	<phrase id="goesOutThrowIn0"><![CDATA[The pass goes out for a throw in]]></phrase>
	<phrase id="goesOutThrowIn1"><![CDATA[A poor pass which goes straight out of play]]></phrase>
	<phrase id="goesOutThrowIn1"><![CDATA[{playerName} plays a pass to {otherplayerName} but it's just ahead and goes out for a throw in]]></phrase>

	<phrase id="saveToCorner0"><![CDATA[{playerName} tips it over the bar for a corner!]]></phrase>
	<phrase id="saveToCorner1"><![CDATA[{playerName} tips it round the post for a corner!]]></phrase>
	
	<phrase id="saveToCollect0"><![CDATA[That's straight at {playerName}. He'll take them all day!]]></phrase>
	<phrase id="saveToCollect1"><![CDATA[{playerName} collects if comfortably. Solid goalkeeping.]]></phrase>
	<phrase id="saveToCollect2"><![CDATA[{playerName} dives down to make the save!]]></phrase>
	
	<phrase id="keepersaved0"><![CDATA[{playerName} somehow manages to block the shot.]]></phrase>
	<phrase id="keepersaved1"><![CDATA[{playerName} collects if comfortably. Solid goalkeeping.]]></phrase>
	<phrase id="keepersaved2"><![CDATA[Terrific save from {playerName}!]]></phrase>
	<phrase id="keepersaved3"><![CDATA[That's straight at {playerName}. He'll take them all day!]]></phrase>
	<phrase id="keepersaved4"><![CDATA[That's no trouble for {playerName}. A wasted opportunity.]]></phrase>
	<phrase id="keepersaved5"><![CDATA[{playerName} dives down to make the save!]]></phrase>
	<phrase id="keepersaved6"><![CDATA[{playerName} is at full stretch, but gets a finger to it. Great save!]]></phrase>
	<phrase id="keepersaved7"><![CDATA[{playerName} gets a hand to it, and blocks the shot.]]></phrase>
	<phrase id="keepersaved8"><![CDATA[{playerName} stops it with his legs!]]></phrase>
	<phrase id="keepersaved9"><![CDATA[{playerName} makes a good stop. Good goalkeeping.]]></phrase>
	
	

	<phrase id="shotwide0"><![CDATA[That whistles past the post! Unlucky!]]></phrase>
	<phrase id="shotwide1"><![CDATA[That's not troubling the goalkeeper - well wide. Goal kick.]]></phrase>
	<phrase id="shotwide2"><![CDATA[I thought that was in, but it's just wide!]]></phrase>
	<phrase id="shotwide3"><![CDATA[Just wide! Goal kick.]]></phrase>
	<phrase id="shotwide4"><![CDATA[That was closer to the corner flag than the goal!]]></phrase>
	<phrase id="shotwide5"><![CDATA[Oh dear. That's well wide.]]></phrase>
	<phrase id="shotwide6"><![CDATA[A wasted opportunity - that's out for a goalkick.]]></phrase>
	<phrase id="shotwide7"><![CDATA[The goalkeeper breathes a sigh of relief - goal kick.]]></phrase>
	<phrase id="shotwide8"><![CDATA[Good effort! Just wide of the post.]]></phrase>
	<phrase id="shotwide9"><![CDATA[Oh, unlucky! That's just wide.]]></phrase>

	<phrase id="shotover0"><![CDATA[That grazed the crossbar! Unlucky!]]></phrase>
	<phrase id="shotover1"><![CDATA[That's well over the bar. Goal kick.]]></phrase>
	<phrase id="shotover2"><![CDATA[That's heading to Row Z! Terrible effort.]]></phrase>
	<phrase id="shotover3"><![CDATA[The ball is in the stands! That was a poor shot.]]></phrase>
	<phrase id="shotover4"><![CDATA[The ball clips the crossbar and drops out of play. So close!]]></phrase>
	<phrase id="shotover5"><![CDATA[Just over the bar!]]></phrase>
	<phrase id="shotover6"><![CDATA[That's in the stands. Goal kick.]]></phrase>
	<phrase id="shotover7"><![CDATA[That's high and wide. Goal kick.]]></phrase>
	<phrase id="shotover8"><![CDATA[Over the bar. A wasted chance.]]></phrase>
	<phrase id="shotover9"><![CDATA[Poor effort - that's comfortably over the bar.]]></phrase>

	<phrase id="woodwork0"><![CDATA[That's off the woodwork!]]></phrase>
	<phrase id="woodwork1"><![CDATA[It smacks back off the post!]]></phrase>
	<phrase id="woodwork2"><![CDATA[That's off the bar!]]></phrase>
	<phrase id="woodwork3"><![CDATA[It hits the post! So unlucky from {playerName}]]></phrase>
	<phrase id="woodwork4"><![CDATA[Back off the woodwork - the bar's still shaking!]]></phrase>

	<phrase id="cornertaken0"><![CDATA[Corner to {clubName}. {playerName} floats it into the box]]></phrase>
	<phrase id="cornertaken1"><![CDATA[{playerName} lines up the corner. He drills it into the box]]></phrase>
	<phrase id="cornertaken2"><![CDATA[The corner is played short to {playerName}, who crosses it into the box]]></phrase>
	<phrase id="cornertaken3"><![CDATA[{playerName} lifts the ball into the box from the corner]]></phrase>
	<phrase id="cornertaken4"><![CDATA[{playerName} takes the corner quickly, sending it straight into the box]]></phrase>
	<phrase id="cornertaken5"><![CDATA[{playerName} with the corner for {clubName}. He lifts it into the box]]></phrase>
	<phrase id="cornertaken6"><![CDATA[{playerName} is taking his time with the corner. He finally lifts it into the penalty area]]></phrase>

	<phrase id="freekickpass0"><![CDATA[{playerName} takes the freekick quickly, passing it onto {otherplayerName}]]></phrase>
	<phrase id="freekickpass1"><![CDATA[{playerName} plays the freekick onto {otherplayerName}]]></phrase>
	<phrase id="freekickpass2"><![CDATA[{playerName} plays the ball onto {otherplayerName} from the freekick]]></phrase>
	<phrase id="freekickpass3"><![CDATA[{playerName} lofts the freekick onto {otherplayerName}]]></phrase>
	<phrase id="freekickpass4"><![CDATA[Freekick to {clubName}.{playerName} knocks the ball onto {otherplayerName}]]></phrase>
	<phrase id="freekickpass5"><![CDATA[{playerName} is lining up the freekick. He plays it onto {otherplayerName}]]></phrase>

	<phrase id="freekickshot0"><![CDATA[{playerName} lines up the freekick. He's curled it around the wall]]></phrase>
	<phrase id="freekickshot1"><![CDATA[{playerName} takes the freekick - he fires it at goal]]></phrase>
	<phrase id="freekickshot2"><![CDATA[{otherplayerName} lines up the freekick. He steps over the ball, leaving {playerName} to take a shot]]></phrase>
	<phrase id="freekickshot3"><![CDATA[{playerName} fires the freekick at goal!]]></phrase>
	<phrase id="freekickshot4"><![CDATA[{playerName} curls the freekick around the wall]]></phrase>
	
	<phrase id="kickOffPassMade0"><![CDATA[{playerName} kicks off, playing the ball to {otherplayerName}]]></phrase>
	
	<phrase id="kickOffPassLost0"><![CDATA[{playerName} kicks off, but immediately loses the ball]]></phrase>

	<phrase id="passtofeet0"><![CDATA[{playerName} plays it onto {otherplayerName}]]></phrase>
	<phrase id="passtofeet1"><![CDATA[{playerName} passes the ball to {otherplayerName}]]></phrase>
	<phrase id="passtofeet2"><![CDATA[{playerName} passes onto {otherplayerName}]]></phrase>
	<phrase id="passtofeet3"><![CDATA[{playerName} knocks it to {otherplayerName}]]></phrase>
	<phrase id="passtofeet4"><![CDATA[{playerName} plays it in front of {otherplayerName}]]></phrase>
	<phrase id="passtofeet5"><![CDATA[{playerName} passes it forward to {otherplayerName}]]></phrase>
	<phrase id="passtofeet6"><![CDATA[{playerName} pushes the ball up to {otherplayerName}]]></phrase>
	<phrase id="passtofeet7"><![CDATA[{playerName} plays it to {otherplayerName}'s feet]]></phrase>
	<phrase id="passtofeet8"><![CDATA[{playerName} plays a great pass onto {otherplayerName}]]></phrase>
	<phrase id="passtofeet9"><![CDATA[{playerName} picks out {otherplayerName} with a great pass]]></phrase>

	<phrase id="loftedpass0"><![CDATA[{playerName} lofts a pass over to {otherplayerName}]]></phrase>
	<phrase id="loftedpass1"><![CDATA[{playerName} sends a long ball across to {otherplayerName}]]></phrase>
	<phrase id="loftedpass2"><![CDATA[{playerName} floats the ball over to {otherplayerName}]]></phrase>
	<phrase id="loftedpass3"><![CDATA[{playerName} picks out {otherplayerName} with a long pass]]></phrase>
	<phrase id="loftedpass4"><![CDATA[{playerName} loops the ball in front of {otherplayerName}]]></phrase>
	<phrase id="loftedpass5"><![CDATA[{playerName} chips the ball onto {otherplayerName}]]></phrase>
	<phrase id="loftedpass6"><![CDATA[{playerName} lobs the ball onto {otherplayerName}]]></phrase>
	
	<phrase id="passToCorner0"><![CDATA[The pass is deflected and goes out for a corner]]></phrase>
	<phrase id="passToCorner1"><![CDATA[{playerName} tries to play a through ball but the defender gets a nick on it and it goes out for a corner]]></phrase>
	
	<phrase id="passToOppGoalKick0"><![CDATA[{playerName} tries a reverse pass to {otherplayerName} but it goes straight out for a goal kick]]></phrase>
	
	<phrase id="passToOppCorner0"><![CDATA[A terrible back pass that goes out for an opposition corner. What was he thinking?]]></phrase>
	
	<phrase id="passToGoalKick0"><![CDATA[{playerName} tries to play it out of the back but it's cut out and lluckily goes out for a goal kick. He will be relieved]]></phrase>
	
	
	<phrase id="passFail0"><![CDATA[{playerName} plays a terrible pass which is easily cut out]]></phrase>
	<phrase id="passFail1"><![CDATA[{playerName} tries to pick out {otherplayerName} but the pass is woeful]]></phrase>
	<phrase id="passFail2"><![CDATA[{playerName} chips the ball forward but it's easily picked off]]></phrase>

	<phrase id="headedaway0"><![CDATA[{playerName} heads it clear]]></phrase>
	<phrase id="headedaway1"><![CDATA[{playerName} heads it away to safety]]></phrase>
	<phrase id="headedaway2"><![CDATA[{playerName} wins the ball in the air, and clears it]]></phrase>
	<phrase id="headedaway3"><![CDATA[{playerName} with a towering header clear]]></phrase>
	<phrase id="headedaway4"><![CDATA[{playerName} heads it out of play]]></phrase>
	<phrase id="headedaway5"><![CDATA[{playerName} with a strong header away]]></phrase>
	<phrase id="headedaway6"><![CDATA[{playerName} clears it with his head]]></phrase>

	<phrase id="headedpass0"><![CDATA[{playerName} nods it onto {otherplayerName}]]></phrase>
	<phrase id="headedpass1"><![CDATA[{playerName} heads it onto {otherplayerName}]]></phrase>
	<phrase id="headedpass2"><![CDATA[{playerName} heads it down to {otherplayerName}]]></phrase>


	<phrase id="crossball0"><![CDATA[{playerName} plays a cross deep into the box]]></phrase>
	<phrase id="crossball1"><![CDATA[{playerName} plays a cross to the near post]]></phrase>
	<phrase id="crossball2"><![CDATA[{playerName} lifts the ball into the box]]></phrase>
	<phrase id="crossball3"><![CDATA[{playerName} floats the ball accross goal]]></phrase>
	<phrase id="crossball4"><![CDATA[{playerName} drills the ball into the box]]></phrase>
	<phrase id="crossball5"><![CDATA[{playerName} with an inviting cross]]></phrase>
	<phrase id="crossball6"><![CDATA[{playerName} sends the ball into the penalty area]]></phrase>
	<phrase id="crossball7"><![CDATA[{playerName} with the cross]]></phrase>
	
	
	<phrase id="keeperClaimsCross0"><![CDATA[{playerName} easily catches the ball]]></phrase>
	<phrase id="keeperClaimsCross1"><![CDATA[{playerName} reaches up above the crowd and plucks the ball off]]></phrase>

	<phrase id="injury0"><![CDATA[{playerName} is clutching his leg. It looks like he's going to be substituted.]]></phrase>
	<phrase id="injury1"><![CDATA[{playerName} is staying down. The referee is calling for the physio. He's going to have to come off.]]></phrase>
	<phrase id="injury2"><![CDATA[That's the last we'll see of {playerName} today - he's limping quite hard now.]]></phrase>
	<phrase id="injury3"><![CDATA[{playerName} is down. Looks like he's injured and will need to be withdrawn.]]></phrase>
	<phrase id="injury4"><![CDATA[{playerName} is rolling on the floor in pain. He's going to have to come off.]]></phrase>
	<phrase id="injury5"><![CDATA[{playerName} is struggling with a knock, he'll have to come off.]]></phrase>
	<phrase id="injury6"><![CDATA[{playerName} is going to need to come off, after that challenge. He's injured.]]></phrase>

	<phrase id="fouledplayer0"><![CDATA[{playerName} is sent flying by {otherplayerName}! Freekick given.]]></phrase>
	<phrase id="fouledplayer1"><![CDATA[{playerName} is brought down by {otherplayerName} Freekick!]]></phrase>
	<phrase id="fouledplayer2"><![CDATA[{otherplayerName} clatters into {playerName}! Freekick given.]]></phrase>
	<phrase id="fouledplayer3"><![CDATA[{playerName} is brought down unfairly by {otherplayerName}! Freekick given.]]></phrase>
	<phrase id="fouledplayer4"><![CDATA[The referee calls a freekick for shirt-pulling from {otherplayerName} on {playerName}]]></phrase>
	<phrase id="fouledplayer5"><![CDATA[{otherplayerName} jumps unfairly with {playerName}! Freekick given.]]></phrase>


	<phrase id="disallowedgoal0"><![CDATA[The linesman's flag is up! The goal has been ruled out!]]></phrase>
	<phrase id="disallowedgoal1"><![CDATA[The linesman is flagging for something. The goal has been disallowed!]]></phrase>
	<phrase id="disallowedgoal2"><![CDATA[What's this? The referee is talking to the linesman... it's been disallowed!]]></phrase>
	<phrase id="disallowedgoal3"><![CDATA[The defenders are swarming the linesman... and yes, it's been disallowed! The fans are furious!]]></phrase>
	<phrase id="disallowedgoal4"><![CDATA[It's not going to stand, the referee had already blown his whistle.]]></phrase>
	<phrase id="disallowedgoal5"><![CDATA[The linesman's flag is up! That one's not going to count]]></phrase>

	<phrase id="penaltyrunup0"><![CDATA[{playerName} steps up confidently]]></phrase>
	<phrase id="penaltyrunup1"><![CDATA[{playerName} is going to take it]]></phrase>
	<phrase id="penaltyrunup2"><![CDATA[{playerName} places the ball down on the penalty spot]]></phrase>
	<phrase id="penaltyrunup3"><![CDATA[{playerName} puts the ball on the spot to a chorus of boos. He steps up...]]></phrase>
	<phrase id="penaltyrunup4"><![CDATA[{playerName} begins his run-up...]]></phrase>

	<phrase id="penaltyscore0"><![CDATA[It's in! Cool as a cucumber!]]></phrase>
	<phrase id="penaltyscore1"><![CDATA[And he scores! Cool as you like]]></phrase>
	<phrase id="penaltyscore2"><![CDATA[Goal! He made that look easy.]]></phrase>
	<phrase id="penaltyscore3"><![CDATA[It's in! No chance for {otherplayerName}!]]></phrase>
	<phrase id="penaltyscore4"><![CDATA[Pick that one out! {otherplayerName} stood no chance.]]></phrase>
	<phrase id="penaltyscore5"><![CDATA[Goal! {otherplayerName} got a hand on it, but couldn't keep it out!]]></phrase>
	<phrase id="penaltyscore6"><![CDATA[There it is! There was no way he was missing that!]]></phrase>

	<phrase id="penaltysaved0"><![CDATA[Saved! {otherplayerName} is mobbed by his teammates!]]></phrase>
	<phrase id="penaltysaved1"><![CDATA[{otherplayerName} saves it! Brilliant stop from the keeper]]></phrase>
	<phrase id="penaltysaved2"><![CDATA[Wide! Terrible miss from {playerName}!]]></phrase>
	<phrase id="penaltysaved3"><![CDATA[He's fluffed it! No trouble for {otherplayerName}, but a terrible miss from {playerName}!]]></phrase>
	<phrase id="penaltysaved4"><![CDATA[Great stop from {otherplayerName}! He made that look easy.]]></phrase>
	<phrase id="penaltysaved5"><![CDATA[{otherplayerName} gets a hand to it! {playerName} has his head in his hands...]]></phrase>
	<phrase id="penaltysaved6"><![CDATA[He's stopped it! A fine save from {otherplayerName}!]]></phrase>

	<phrase id="penaltygiven0"><![CDATA[{otherplayerName} clatters {playerName} in the box! Penalty given!]]></phrase>
	<phrase id="penaltygiven1"><![CDATA[{otherplayerName} trips {playerName} in the box! It's a penalty!]]></phrase>
	<phrase id="penaltygiven2"><![CDATA[{otherplayerName} handballs in the box! Penalty!]]></phrase>
	<phrase id="penaltygiven3"><![CDATA[{playerName} is brought down by {otherplayerName} in the box! The referee has no doubt! Penalty given!]]></phrase>
	<phrase id="penaltygiven4"><![CDATA[{playerName} collapses in the box, from a challenge by {otherplayerName}! The referee points to the spot!]]></phrase>


	<phrase id="penaltynotgiven0"><![CDATA[{playerName} collapses in the box, from a challenge by {otherplayerName}! Play on, says the ref!]]></phrase>
	<phrase id="penaltynotgiven1"><![CDATA[{otherplayerName} clatters {playerName} in the box! No penalty, says the ref!]]></phrase>
	<phrase id="penaltynotgiven2"><![CDATA[{otherplayerName} trips {playerName} in the box! Play on, says the referee!]]></phrase>
	<phrase id="penaltynotgiven3"><![CDATA[{playerName} falls down in the box - the referee waves play on! A lucky escape for {otherplayerName}]]></phrase>
	<phrase id="penaltynotgiven4"><![CDATA[{playerName} goes down in the box! {otherplayerName} gets away with it - no foul given!]]></phrase>
	
	
	<phrase id="substitution0"><![CDATA[{clubName} brings on {playerName} for {otherplayerName}]]></phrase>
	<phrase id="substitution1"><![CDATA[{clubName} are making a change. {playerName} is coming on for {otherplayerName}]]></phrase>
	
	<phrase id="gameTip"><![CDATA[Game tip:]]></phrase>
	<phrase id="gameTip0"><![CDATA[Keep an eye on player stamina and make substitutions - tired teams will struggle to score, and concede sloppy goals!]]></phrase>
	<phrase id="gameTip1"><![CDATA[Struggling to score enough goals? It might not be your forwards fault. Are your midfielders creating enough chances?]]></phrase>
	<phrase id="gameTip2"><![CDATA[Hard training your players can turn them into world beaters, but can also result in loads of injuries...]]></phrase>
	<phrase id="gameTip3"><![CDATA[Think twice before selling a youngster - many can blossom into legends if trained the right way...]]></phrase>
	<phrase id="gameTip4"><![CDATA[Is the match commentary too fast or slow for you? Change the speed in the game options!]]></phrase>
	<phrase id="gameTip5"><![CDATA[If you're relegated, it's game over!]]></phrase>
	<phrase id="gameTip6"><![CDATA[Look out for unattached players, by doing skill searches- a few familiar faces may reappear as time progresses...]]></phrase>
	<phrase id="gameTip7"><![CDATA[Check on you player's rating during matches. If their rating is much lower than their player rating they may be out of form and need subbing.]]></phrase>
	<phrase id="gameTip8"><![CDATA[Once the fixtures start to stack up you're players will need rest between matches. You need a squad, not just an all star first eleven.]]></phrase>


	<!-- match options -->
	<phrase id="matchOptions"><![CDATA[Match options]]></phrase>	
	<phrase id="matchOptionsCopy"><![CDATA[Select the match speed.]]></phrase>	
	<phrase id="matchOptionsAlertsCopy"><![CDATA[Select what events you are alerted to. The game will pause when any of these happen.]]></phrase>	
	<phrase id="matchSpeed"><![CDATA[Match speed]]></phrase>	
	<phrase id="goal"><![CDATA[Goal]]></phrase>	
	<phrase id="redCard"><![CDATA[Red Card]]></phrase>	
	<phrase id="yellowCard"><![CDATA[Yellow Card]]></phrase>	
	<phrase id="injury"><![CDATA[Injury]]></phrase>	
	<phrase id="halfTime"><![CDATA[Half time]]></phrase>	
	<phrase id="fullInfo"><![CDATA[Full info]]></phrase>	
	<phrase id="halfInfo"><![CDATA[Half info]]></phrase>	
	<phrase id="minInfo"><![CDATA[Min info]]></phrase>	
	<phrase id="matchInfoShown"><![CDATA[Messages shown]]></phrase>	
</data>;
         }
         copy = {};
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.phrase.length())
         {
            copy[_loc2_.phrase[_loc3_].@id] = _loc2_.phrase[_loc3_].text();
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < _loc4_.phrase.length())
         {
            copy[_loc4_.phrase[_loc3_].@id] = _loc4_.phrase[_loc3_].text();
            _loc3_++;
         }
         matchCopyNumber = [];
         matchCopyNumber[KICK_OFF_MADE] = 1;
         matchCopyNumber[MATCH_STARTED] = 6;
         matchCopyNumber[SHORT_PASS] = 10;
         matchCopyNumber[LONG_PASS] = 7;
         matchCopyNumber[PASS_FAIL] = 3;
         matchCopyNumber[TAKE_POSSESSION] = 13;
         matchCopyNumber[GOES_THROW_IN] = 2;
         matchCopyNumber[PASS_TO_CORNER] = 2;
         matchCopyNumber[PASS_TO_OPP_CORNER] = 1;
         matchCopyNumber[PASS_TO_GOALKICK] = 1;
         matchCopyNumber[PASS_TO_OPP_GOALKICK] = 1;
         matchCopyNumber[FOUL_PLAYER] = 6;
         matchCopyNumber[INJURY] = 6;
         matchCopyNumber[YELLOW_CARD] = 11;
         matchCopyNumber[SECOND_YELLOW_CARD] = 7;
         matchCopyNumber[RED_CARD] = 9;
         matchCopyNumber[TACKLE_FAIL] = 13;
         matchCopyNumber[TACKLE_MADE] = 12;
         matchCopyNumber[PENALTY_GIVEN] = 5;
         matchCopyNumber[CROSS_MADE] = 8;
         matchCopyNumber[SHOT_WIDE] = 10;
         matchCopyNumber[SHOT_OVER] = 10;
         matchCopyNumber[SAVE_TO_CORNER] = 2;
         matchCopyNumber[SAVE_TO_COLLECT] = 2;
         matchCopyNumber[KEEPER_SAVE] = 10;
         matchCopyNumber[AIR_SHOT] = 17;
         matchCopyNumber[PLAYER_SHOT] = 16;
         matchCopyNumber[FREE_KICK_PASS] = 6;
         matchCopyNumber[CORNER] = 7;
         matchCopyNumber[HEADED_AWAY] = 7;
         matchCopyNumber[GOAL] = 13;
         matchCopyNumber[PENALTY_RUN_UP] = 5;
         matchCopyNumber[PENALTY_SCORE] = 7;
         matchCopyNumber[PENALTY_SAVE] = 7;
         matchCopyNumber[GAME_OVER] = 12;
         matchCopyNumber[SECOND_HALF_START] = 7;
         matchCopyNumber[KEEPER_CLAIM_CROSS] = 2;
         matchCopyNumber[FIRST_HALF_END] = 4;
         matchCopyNumber[SUBSTITUTION] = 2;
         matchCopyNumber[NOW_EXTRA_TIME] = 1;
         matchCopyNumber[FIRST_EXTRA_TIME_START] = 1;
         matchCopyNumber[FIRST_EXTRA_TIME_END] = 1;
         matchCopyNumber[SECOND_EXTRA_TIME_START] = 1;
         matchCopyNumber[SECOND_EXTRA_TIME_END] = 1;
         matchCopyNumber[NOW_PENALTIES] = 1;
         matchCopyNumber[PENALTIES_RESULT] = 1;
         previousTips = [];
      }
      
      public static function getCopy(param1:String) : String
      {
         if(copy[param1])
         {
            return copy[param1];
         }
         return "missing copy:" + param1;
      }
      
      public static function getCurrency() : String
      {
         return copy["currency"];
      }
      
      public static function getClubStars(param1:Object) : String
      {
         if(!param1 || !("profile" in param1))
         {
            return "";
         }
         var _loc2_:int = int(Math.max(1,Math.min(10,Math.round(param1.profile / 10))));
         return " (" + _loc2_ + "★)";
      }
      
      public static function getNumCopy(param1:int, param2:String) : String
      {
         var _loc3_:String = "";
         if(param1 == 1)
         {
            _loc3_ = getCopy("X" + param2).replace("XX",param1.toString());
         }
         else
         {
            _loc3_ = getCopy("X" + param2 + "s").replace("XX",param1.toString());
         }
         return _loc3_;
      }
      
      public static function getMatchTip() : String
      {
         var _loc1_:int = Math.floor(Math.random() * NUM_TIPS);
         while(previousTips.indexOf(_loc1_) >= 0)
         {
            _loc1_ = Math.floor(Math.random() * NUM_TIPS);
         }
         var _loc2_:String = CopyManager.getCopy(GAME_TIPS + _loc1_);
         previousTips.push(_loc1_);
         if(NUM_TIPS - previousTips.length < 3)
         {
            previousTips.shift();
         }
         return _loc2_;
      }
      
      public static function getPlayerPostionString(param1:String) : String
      {
         var _loc2_:String = "";
         var _loc3_:Array = param1.split("-");
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc2_ += _loc4_ == 0 ? getCopy(_loc3_[_loc4_]) : "-" + getCopy(_loc3_[_loc4_]);
            _loc4_++;
         }
         return _loc2_.toUpperCase();
      }
   }
}

