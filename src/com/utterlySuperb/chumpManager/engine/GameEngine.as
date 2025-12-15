package com.utterlySuperb.chumpManager.engine
{
   import com.greensock.TweenLite;
   import com.utterlySuperb.chumpManager.model.CopyManager;
   import com.utterlySuperb.chumpManager.model.dataObjects.Club;
   import com.utterlySuperb.chumpManager.model.dataObjects.FixturesList;
   import com.utterlySuperb.chumpManager.model.dataObjects.Game;
   import com.utterlySuperb.chumpManager.model.dataObjects.Message;
   import com.utterlySuperb.chumpManager.model.dataObjects.Player;
   import com.utterlySuperb.chumpManager.model.dataObjects.SeasonStats;
   import com.utterlySuperb.chumpManager.model.dataObjects.StaticInfo;
   import com.utterlySuperb.chumpManager.model.dataObjects.competitions.League;
   import com.utterlySuperb.chumpManager.model.dataObjects.matches.Match;
   import com.utterlySuperb.chumpManager.model.dataObjects.matches.MatchPlayerDetails;
   import com.utterlySuperb.chumpManager.view.modals.FeedbackPanel;
   import com.utterlySuperb.chumpManager.view.modals.PleaseWaitModal;
   import com.utterlySuperb.chumpManager.view.screens.Screen;
   import com.utterlySuperb.events.BudgetEventProxy;
   import flash.events.Event;
   
   public class GameEngine
   {
      
      private static var pleaseWait:PleaseWaitModal;
      
      private static var finishUpdateState:String;
      
      public static const WINTER_TRANSFER_OPEN:int = 18;
      
      public static const WINTER_TRANSFER_CLOSE:int = 22;
      
      public static const GAME_MADE:String = "gameMade";
      
      public static const ROUND_UPDATE:String = "roundUpdate";
      
      public static const INIT_SEASON:String = "initSeason";
      
      public function GameEngine()
      {
         super();
      }
      
      public static function canTransfer(param1:Game) : Boolean
      {
         return param1.offSeasonNum > 0 || param1.weekNum >= WINTER_TRANSFER_OPEN && param1.weekNum < WINTER_TRANSFER_CLOSE;
      }
      
      public static function makeGame() : Game
      {
         var _loc1_:XML = <data>
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
         StaticInfo.init();
         StaticInfo.startDate = new Date(int(_loc1_.startDate.@year),int(_loc1_.startDate.@month) - 1,int(_loc1_.startDate.@day));
         var _loc2_:Game = new Game();
         Main.currentGame = _loc2_;
         _loc2_.firstWeekend = new Date(StaticInfo.startDate.getTime());
         _loc2_.version = Globals.VERSION_NUMBER;
         _loc2_.getRoundDate();
         _loc2_.leagues[0] = makeMainLeagues();
         _loc2_.leagues[1] = makeLeague2();
         makeEuroclubs();
         makeLegends();
         var _loc3_:XML = <data>
<!-- this is some classic players to add to the pot -->
	<player id="Diego Maradona" name="Diego Maradona" birthday="30-10-1960" positions="am-cf" nationality="ag">
		<stats passing="85" tackling="68" shooting="88" crossing="79" heading="75" dribbling="97" speed="93" stamina="85" aggression="88" strength="84" fitness="78" creativity="94"/>
	</player>	
	<player id="Pelé" name="Pelé" birthday="23-10-1940" positions="cf" nationality="br">
		<stats passing="80" tackling="73" shooting="95" crossing="79" heading="92" dribbling="90" speed="93" stamina="85" aggression="77" strength="91" fitness="90" creativity="84"/>
	</player>	
	<player id="David Seaman" name="David Seaman" birthday="19-09-1963" positions="gk" nationality="en">
		<stats catching="82" shotStopping="83" distribution="71" fitness="75" stamina="85"/>
	</player>
	<player id="Peter Schmeichel" name="Peter Schmeichel" birthday="18-11-1963" positions="gk" nationality="dn">
		<stats catching="88" shotStopping="92" distribution="85" fitness="75" stamina="85"/>
	</player>
	<player id="Matthew Le Tissier" name="Matthew Le Tissier" birthday="14-10-1968" positions="am" nationality="en">
		<stats passing="83" tackling="22" shooting="73" crossing="79" heading="61" dribbling="82" speed="55" stamina="70" aggression="58" strength="62" fitness="75" creativity="93"/>
	</player>	
	<player id="Eric Cantona" name="Eric Cantona" birthday="24-05-1966" positions="cf" nationality="fr">
		<stats passing="79" tackling="34" shooting="88" crossing="69" heading="77" dribbling="85" speed="78" stamina="85" aggression="100" strength="71" fitness="90" creativity="100"/>
	</player>	
	<player id="Dennis Bergkamp" name="Dennis Bergkamp" birthday="10-05-1969" positions="cf" nationality="ne">
		<stats passing="80" tackling="73" shooting="81" crossing="79" heading="72" dribbling="82" speed="79" stamina="85" aggression="61" strength="70" fitness="90" creativity="92"/>
	</player>	
	<player id="Alan Shearer" name="Alan Shearer" birthday="13-08-1970" positions="cf" nationality="en">
		<stats passing="65" tackling="32" shooting="91" crossing="52" heading="88" dribbling="45" speed="71" stamina="85" aggression="85" strength="93" fitness="90" creativity="76"/>
	</player>	
	<player id="Gianfranco Zola" name="Gianfranco Zola" birthday="05-06-1966" positions="cf-am" nationality="it">
		<stats passing="88" tackling="23" shooting="87" crossing="89" heading="66" dribbling="90" speed="95" stamina="85" aggression="10" strength="64" fitness="90" creativity="95"/>
	</player>	
	<player id="Roy Keane" name="Roy Keane" birthday="10-08-1971" positions="dm" nationality="ir">
		<stats passing="72" tackling="88" shooting="57" crossing="52" heading="76" dribbling="61" speed="74" stamina="100" aggression="100" strength="91" fitness="90" creativity="75"/>
	</player>	
	<player id="David Beckham" name="David Beckham" birthday="02-05-1975" positions="sm" nationality="en">
		<stats passing="80" tackling="55" shooting="67" crossing="93" heading="64" dribbling="72" speed="70" stamina="85" aggression="77" strength="91" fitness="90" creativity="84"/>
	</player>	
	<player id="Paul Gascoigne" name="Paul Gascoigne" birthday="27-05-1967" positions="cm-am" nationality="en">
		<stats passing="80" tackling="62" shooting="77" crossing="79" heading="62" dribbling="80" speed="68" stamina="85" aggression="90" strength="91" fitness="65" creativity="91"/>
	</player>	
	<player id="Jurgen Klinsmann" name="Jurgen Klinsmann" birthday="30-07-1964" positions="cf" nationality="ge">
		<stats passing="71" tackling="55" shooting="93" crossing="57" heading="79" dribbling="67" speed="85" stamina="85" aggression="77" strength="91" fitness="90" creativity="75"/>
	</player>	
	<player id="Peter Beardsley" name="Peter Beardsley" birthday="18-01-1961" positions="cf-am" nationality="en">
		<stats passing="80" tackling="55" shooting="81" crossing="65" heading="70" dribbling="93" speed="95" stamina="85" aggression="77" strength="77" fitness="90" creativity="75"/>
	</player>	
	<player id="Stuart Pearce" name="Stuart Pearce" birthday="24-04-1962" positions="fb" nationality="en">
		<stats passing="61" tackling="84" shooting="41" crossing="71" heading="68" dribbling="68" speed="79" stamina="85" aggression="93" strength="91" fitness="90" creativity="50"/>
	</player>	
	<player id="Denis Irwin" name="Denis Irwin" birthday="31-10-1965" positions="fb" nationality="ir">
		<stats passing="68" tackling="82" shooting="66" crossing="85" heading="75" dribbling="86" speed="77" stamina="85" aggression="55" strength="91" fitness="90" creativity="62"/>
	</player>	
	<player id="Paolo Di Canio" name="Paolo Di Canio" birthday="09-07-1968" positions="cf" nationality="it">
		<stats passing="80" tackling="66" shooting="81" crossing="72" heading="71" dribbling="77" speed="68" stamina="85" aggression="98" strength="71" fitness="90" creativity="91"/>
	</player>	
	<player id="Ruud Gullit" name="Ruud Gullit" birthday="01-09-1962" positions="cb-cm-cf" nationality="ne">
		<stats passing="84" tackling="78" shooting="67" crossing="79" heading="71" dribbling="73" speed="75" stamina="85" aggression="23" strength="67" fitness="90" creativity="88"/>
	</player>	
	<player id="Graeme Le Saux" name="Graeme Le Saux" birthday="17-10-1968" positions="fb-sm" nationality="en">
		<stats passing="71" tackling="77" shooting="22" crossing="79" heading="71" dribbling="77" speed="76" stamina="85" aggression="45" strength="66" fitness="90" creativity="82"/>
	</player>	
	<player id="Steve Bould" name="Steve Bould" birthday="16-11-1962" positions="cb" nationality="en">
		<stats passing="63" tackling="86" shooting="17" crossing="14" heading="87" dribbling="10" speed="64" stamina="85" aggression="77" strength="93" fitness="90" creativity="12"/>
	</player>	
	<player id="Tony Adams" name="Tony Adams" birthday="10-10-1966" positions="cb" nationality="en">
		<stats passing="54" tackling="91" shooting="7" crossing="41" heading="92" dribbling="61" speed="72" stamina="85" aggression="65" strength="91" fitness="90" creativity="25"/>
	</player>	
	<player id="Jaap Stam" name="Jaap Stam" birthday="17-07-1972" positions="cb" nationality="ne">
		<stats passing="72" tackling="88" shooting="34" crossing="40" heading="91" dribbling="75" speed="72" stamina="85" aggression="83" strength="82" fitness="70" creativity="79"/>
	</player>	
	<player id="Andrei Kanchelskis" name="Andrei Kanchelskis" birthday="23-01-1969" positions="sm" nationality="ru">
		<stats passing="77" tackling="37" shooting="68" crossing="83" heading="53" dribbling="91" speed="95" stamina="90" aggression="49" strength="61" fitness="90" creativity="84"/>
	</player>	
	<player id="Paul Ince" name="Paul Ince" birthday="21-10-1967" positions="dm-cm" nationality="en">
		<stats passing="81" tackling="90" shooting="67" crossing="79" heading="81" dribbling="67" speed="81" stamina="90" aggression="96" strength="91" fitness="90" creativity="70"/>
	</player>	
	<player id="Emmanuel Petit" name="Emmanuel Petit" birthday="22-09-1970" positions="dm" nationality="fr">
		<stats passing="74" tackling="82" shooting="69" crossing="79" heading="77" dribbling="64" speed="78" stamina="85" aggression="77" strength="91" fitness="90" creativity="84"/>
	</player>	
	<player id="David Ginola" name="David Ginola" birthday="25-01-1967" positions="sm" nationality="fr">
		<stats passing="83" tackling="34" shooting="72" crossing="88" heading="34" dribbling="87" speed="88" stamina="85" aggression="67" strength="71" fitness="90" creativity="90"/>
	</player>	
	<player id="Giorgi Kinkladze" name="Giorgi Kinkladze" birthday="06-07-1973" positions="am-cm" nationality="ge">
		<stats passing="77" tackling="43" shooting="79" crossing="75" heading="60" dribbling="97" speed="88" stamina="85" aggression="20" strength="60" fitness="90" creativity="89"/>
	</player>	
	<player id="Igor Stimac" name="Igor Stimac" birthday="06-09-1967" positions="cb" nationality="cr">
		<stats passing="81" tackling="77" shooting="32" crossing="66" heading="81" dribbling="67" speed="61" stamina="85" aggression="40" strength="91" fitness="90" creativity="84"/>
	</player>	
	<player id="Teddy Sheringham" name="Teddy Sheringham" birthday="02-04-1966" positions="cf" nationality="en">
		<stats passing="77" tackling="33" shooting="81" crossing="82" heading="70" dribbling="61" speed="67" stamina="85" aggression="50" strength="71" fitness="70" creativity="88"/>
	</player>	
	<player id="Jay-Jay Okocha" name="Jay-Jay Okocha" birthday="14-08-1973" positions="am" nationality="ng">
		<stats passing="82" tackling="54" shooting="76" crossing="74" heading="67" dribbling="84" speed="86" stamina="85" aggression="71" strength="75" fitness="70" creativity="88"/>
	</player>	
	<player id="Alan Martin" name="Alan Martin" birthday="18-05-1976" positions="cm" nationality="en" ageImprovement="50">
		<stats passing="93" tackling="77" shooting="82" crossing="51" heading="84" dribbling="82" speed="88" stamina="95" aggression="75" strength="91" fitness="72" creativity="85"/>
	</player>	
	<player id="Jimmy-Floyd Hasselbaink" name="Jimmy-Floyd Hasselbaink" birthday="27-03-1972" positions="cf" nationality="ne">
		<stats passing="57" tackling="33" shooting="87" crossing="61" heading="68" dribbling="70" speed="91" stamina="85" aggression="77" strength="91" fitness="90" creativity="71"/>
	</player>	
<player id="Sam Bellman" name="Sam Bellman" birthday="18-05-1975" positions="cb-dm" nationality="en" ageImprovement="50">
		<stats passing="67" tackling="95" shooting="59" crossing="63" heading="95" dribbling="30" speed="86" stamina="75" aggression="75" strength="87" fitness="75" creativity="25"/>
	</player>
<player id="Alick Stott" name="Alick Stott" birthday="18-05-1984" positions="cf" nationality="en">
		<stats passing="66" tackling="42" shooting="82" crossing="61" heading="76" dribbling="69" speed="75" stamina="75" aggression="45" strength="77" fitness="72" creativity="75"/>
	</player>
<player id="Richard Pendry" name="Richard Pendry" birthday="18-05-1984" positions="fb" nationality="en">
		<stats passing="75" tackling="77" shooting="32" crossing="66" heading="44" dribbling="66" speed="72" stamina="75" aggression="46" strength="65" fitness="72" creativity="87"/>
	</player>
<player id="Keith Martison" name="Keith Martison" birthday="14-02-1988" positions="sm" nationality="en">
		<stats passing="79" tackling="54" shooting="64" crossing="77" heading="66" dribbling="75" speed="89" stamina="82" aggression="74" strength="43" fitness="67" creativity="62"/>
	</player>
<player id="Conor Donovan" name="Conor Donovan" birthday="18-05-1984" positions="cm" nationality="en">
		<stats passing="73" tackling="42" shooting="62" crossing="61" heading="84" dribbling="62" speed="68" stamina="75" aggression="25" strength="91" fitness="72" creativity="85"/>
	</player>
<player id="Meriton Rrustemi" name="Meriton Rrustemi" birthday="18-05-1984" positions="cm" nationality="en">
		<stats passing="73" tackling="42" shooting="62" crossing="61" heading="84" dribbling="62" speed="68" stamina="75" aggression="25" strength="91" fitness="72" creativity="85"/>
	</player>
<player id="Dan Tiller" name="Dan Tiller" birthday="02-07-1987" positions="cm-am" nationality="en">
	<stats passing="80" tackling="31" shooting="54" crossing="62" heading="27" dribbling="79" speed="68" stamina="71" aggression="33" strength="29" fitness="68" creativity="71"/>
	</player>
<player id="Johnny Safi" name="Johnny Safi" birthday="06-05-1983" positions="fb" nationality="en">
	<stats passing="65" tackling="77" shooting="42" crossing="73" heading="69" dribbling="73" speed="88" stamina="89" aggression="74" strength="52" fitness="82" creativity="34"/>
	</player>
<player id="Andrei Rhodes" name="Andrei Rhodes" birthday="22-01-1985" positions="dm" nationality="en">
	<stats passing="79" tackling="47" shooting="58" crossing="84" heading="34" dribbling="80" speed="69" stamina="68" aggression="62" strength="33" fitness="73" creativity="78"/>	
	</player>
<player id="Chris Scotton" name="Chris Scotton" birthday="14-09-1988" positions="cb" nationality="en">
	<stats passing="55" tackling="56" shooting="40" crossing="52" heading="57" dribbling="43" speed="68" stamina="67" aggression="65" strength="57" fitness="68" creativity="45"/>		
	</player>
<player id="Jun Wei" name="Jun Wei" birthday="20-12-1980" positions="cb" nationality="en">
		<stats passing="53" tackling="80" shooting="12" crossing="26" heading="73" dribbling="39" speed="68" stamina="44" aggression="69" strength="84" fitness="30" creativity="44"/>
	</player>
<player id="Albert Popoola" name="Albert Popoola" birthday="22-04-1977" positions="cm-dm" nationality="en">
	<stats passing="63" tackling="64" shooting="55" crossing="60" heading="58" dribbling="59" speed="75" stamina="75" aggression="54" strength="64" fitness="70" creativity="57"/>	
	</player>
</data>;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.player.length)
         {
            PlayerHelper.makePlayer(_loc3_.player[_loc4_]);
            _loc4_++;
         }
         BudgetEventProxy.dispatchEvent(GAME_MADE,null);
         return _loc2_;
      }
      
      public static function makeStaticInfo() : void
      {
      }
      
      private static function makeMainLeagues() : League
      {
         var _loc3_:XML = null;
         var _loc5_:Club = null;
         var _loc1_:XML = <data>
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
         var _loc2_:League = new League();
         _loc2_.name = _loc1_.leagues.mainLeague[0].@nameId;
         _loc3_ = <data>
	<club shirtColor="0xFF0000" sleevesColor="0xFFFFFF" stripesType="none" scoreMultiplier="1" attackScore="A" defendScore="B">
		<name><![CDATA[Arsenal]]></name>
		<profile>90</profile>
		<players>
			<player id="Manuel Almunia" name="Manuel Almunia" birthday="19-05-1977" positions="gk" nationality="es" number="1" progressType="sin1">
				<stats catching="75" shotStopping="80" distribution="50" fitness="70" stamina="60"/>
			</player>
			<player id="Abou Diaby" name="Abou Diaby" birthday="11-05-1986" positions="cm-am" nationality="fr" number="2">
				<stats passing="64" tackling="62" shooting="69" crossing="47" heading="59" dribbling="72" speed="68" stamina="79" aggression="73" strength="72" fitness="58" creativity="72"/>	
			</player>	
			<player id="Bacary Sagna" name="Bacary Sagna" birthday="14-02-1983" positions="fb-cb" nationality="fr" number="3">
				<stats passing="58" tackling="69" shooting="41" crossing="63" heading="66" dribbling="48" speed="71" stamina="78" aggression="58" strength="73" fitness="75" creativity="52"/>
			</player>
			<player id="Cesc Fàbregas" name="Cesc Fàbregas" birthday="04-05-1987" positions="cm-am" nationality="es" number="4">
				<stats passing="93" tackling="55" shooting="77" crossing="72" heading="49" dribbling="79" speed="81" stamina="78" aggression="77" strength="57" fitness="74" creativity="92"/>
			</player>
			<player id="Thomas Vermaelen" name="Thomas Vermaelen" birthday="14-11-1985" positions="fb-cb" nationality="be" number="5">
				<stats passing="71" tackling="83" shooting="76" crossing="46" heading="77" dribbling="56" speed="83" stamina="83" aggression="85" strength="74" fitness="77" creativity="45"/>				
			</player>
			<player id="Laurent Koscielny" name="Laurent Koscielny" birthday="10-09-1985" positions="cb" nationality="fr" number="6">
				<stats passing="59" tackling="78" shooting="45" crossing="52" heading="69" dribbling="43" speed="78" stamina="77" aggression="75" strength="67" fitness="68" creativity="42"/>				
			</player>
			<player id="Tomáš Rosický" name="Tomáš Rosický" birthday="04-10-1980" positions="am-sm" nationality="cz" number="7">
				<stats passing="74" tackling="41" shooting="69" crossing="68" heading="34" dribbling="67" speed="69" stamina="74" aggression="78" strength="56" fitness="37" creativity="78"/>
			</player>
			<player id="Samir Nasri" name="Samir Nasri" birthday="26-06-1987" positions="wf-am-sm" nationality="fr" number="8">
				<stats passing="79" tackling="43" shooting="72" crossing="67" heading="43" dribbling="89" speed="78" stamina="82" aggression="57" strength="67" fitness="77" creativity="84"/>
			</player>
			<player id="Robin van Persie" name="Robin van Persie" birthday="06-08-1983" positions="cf-wf" nationality="ne" number="10">
				<stats passing="83" tackling="56" shooting="86" crossing="74" heading="67" dribbling="84" speed="75" stamina="89" aggression="69" strength="60" fitness="50" creativity="77"/>
			</player>
			<player id="Carlos Vela" name="Carlos Vela" birthday="01-03-1989" positions="cf-wf" nationality="me" number="11">
				<stats passing="53" tackling="34" shooting="69" crossing="67" heading="45" dribbling="72" speed="79" stamina="68" aggression="45" strength="49" fitness="81" creativity="74"/>	
			</player>
			<player id="Theo Walcott" name="Theo Walcott" birthday="16-03-1989" positions="wf-sm" nationality="en" number="14" progressType="sin1">
				<stats passing="68" tackling="32" shooting="81" crossing="74" heading="43" dribbling="72" speed="96" stamina="59" aggression="37" strength="57" fitness="57" creativity="74"/>	
			</player>
			<player id="Denílson" name="Denílson" birthday="16-02-1988" positions="cm-dm" nationality="br" number="15">
				<stats passing="78" tackling="63" shooting="61" crossing="63" heading="45" dribbling="58" speed="68" stamina="68" aggression="64" strength="62" fitness="64" creativity="63"/>
			</player>
			<player id="Aaron Ramsey" name="Aaron Ramsey" birthday="26-12-1990" positions="cm-am" nationality="wa" number="16">
				<stats passing="71" tackling="61" shooting="68" crossing="67" heading="45" dribbling="65" speed="68" stamina="67" aggression="68" strength="69" fitness="60" creativity="57"/>	
			</player>
			<player id="Alex Song" name="Alex Song" birthday="09-09-1987" positions="cb-dm-cm" nationality="ca" number="17">
				<stats passing="63" tackling="77" shooting="56" crossing="56" heading="56" dribbling="66" speed="81" stamina="79" aggression="74" strength="82" fitness="89" creativity="59"/>		
			</player>
			<player id="Sébastien Squillaci" name="Sébastien Squillaci" birthday="11-08-1980" positions="cb" nationality="fr" number="18">
				<stats passing="57" tackling="69" shooting="43" crossing="53" heading="67" dribbling="31" speed="67" stamina="77" aggression="67" strength="72" fitness="74" creativity="46"/>		
			</player>
			<player id="Jack Wilshere" name="Jack Wilshere" birthday="01-01-1992" positions="cm-am-wf" nationality="en" number="19" ageImprovement="30" progressType="sin0">
				<stats passing="78" tackling="64" shooting="61" crossing="67" heading="35" dribbling="78" speed="69" stamina="67" aggression="69" strength="73" fitness="70" creativity="78"/>		
			</player>
			<player id="Johan Djourou" name="Johan Djourou" birthday="01-18-1987" positions="cb-fb" nationality="sw" number="20">
				<stats passing="50" tackling="67" shooting="58" crossing="45" heading="72" dribbling="42" speed="64" stamina="56" aggression="64" strength="63" fitness="34" creativity="41"/>	
			</player>
			<player id="Łukasz Fabiański" name="Łukasz Fabiański" birthday="18-04-1985" positions="gk" nationality="po" number="21">
				<stats catching="61" shotStopping="83" distribution="77" fitness="87" stamina="84"/>		
			</player>
			<player id="Gaël Clichy" name="Gaël Clichy" birthday="26-07-1985" positions="fb" nationality="fr" number="22">
				<stats passing="63" tackling="73" shooting="38" crossing="47" heading="53" dribbling="55" speed="82" stamina="72" aggression="64" strength="56" fitness="78" creativity="67"/>		
			</player>
			<player id="Andrei Arshavin" name="Andrei Arshavin" birthday="29-05-1981" positions="am-wf" nationality="ru" number="23">
				<stats passing="77" tackling="27" shooting="87" crossing="57" heading="23" dribbling="87" speed="73" stamina="53" aggression="48" strength="68" fitness="61" creativity="84"/>		
			</player>
			<player id="Emmanuel Eboué" name="Emmanuel Eboué" birthday="04-06-1983" positions="fb-sm" nationality="iv" number="27">
				<stats passing="69" tackling="67" shooting="45" crossing="56" heading="59" dribbling="71" speed="72" stamina="65" aggression="46" strength="59" fitness="70" creativity="67"/>		
			</player>
			<player id="Kieran Gibbs" name="Kieran Gibbs" birthday="26-09-1989" positions="fb-sm" nationality="en" number="28">
				<stats passing="65" tackling="67" shooting="67" crossing="69" heading="56" dribbling="64" speed="62" stamina="67" aggression="57" strength="67" fitness="67" creativity="73"/>		
			</player>
			<player id="Marouane Chamakh" name="Marouane Chamakh" birthday="10-01-1984" positions="cf" nationality="mo" number="29">
				<stats passing="69" tackling="35" shooting="77" crossing="53" heading="87" dribbling="76" speed="78" stamina="87" aggression="68" strength="78" fitness="77" creativity="67"/>		
			</player>
			<player id="Nicklas Bendtner" name="Nicklas Bendtner" birthday="16-11-1988" positions="cf-wf" nationality="dn" number="52" ageImprovement="30">
				<stats passing="65" tackling="34" shooting="73" crossing="65" heading="79" dribbling="67" speed="69" stamina="81" aggression="69" strength="74" fitness="68" creativity="75"/>		
			</player>
			<player id="Henri Lansbury" name="Henri Lansbury" birthday="12-10-1990" positions="cm-sm" nationality="dn" number="46" ageImprovement="40">
				<stats passing="63" tackling="54" shooting="54" crossing="62" heading="43" dribbling="52" speed="69" stamina="73" aggression="73" strength="63" fitness="71" creativity="64"/>		
			</player>
			<player id="Wojciech Szczęsny" name="Wojciech Szczęsny" birthday="18-04-1990" positions="gk" nationality="po" number="53" ageImprovement="25" progressType="sin1">
				<stats catching="76" shotStopping="84" distribution="75" fitness="67" stamina="74"/>		
			</player>
		</players>
	</club>
<club shirtColor="0xAD1057" sleevesColor="0x799DBD" stripesType="none" stripesColor="0x799DBD" scoreMultiplier="3" attackScore="B" defendScore="D">
		<name><![CDATA[Aston Villa]]></name>
		<profile>70</profile>
		<players>
			<player id="Brad Friedel" name="Brad Friedel" birthday="18-05-1971" positions="gk" nationality="us" number="1" progressType="sin2">
				<stats catching="66" shotStopping="70" distribution="50" fitness="70" stamina="70"/>
			</player>
			<player id="Carlos Cuellar" name="Carlos Cuellar" birthday="23-08-1981" positions="fb-cb" nationality="es" number="24">
				<stats passing="20" tackling="75" shooting="20" crossing="15" heading="75" dribbling="15" speed="60" stamina="70" aggression="60" strength="75" fitness="75" creativity="35"/>	
			</player>	
			<player id="Habib Beye" name="Habib Beye" birthday="19-10-1977" positions="fb" nationality="se" number="23">
				<stats passing="62" tackling="70" shooting="52" crossing="60" heading="72" dribbling="45" speed="75" stamina="72" aggression="54" strength="70" fitness="75" creativity="44"/>
			</player>
			<player id="Luke Young" name="Luke Young" birthday="19-7-1979" positions="fb" nationality="en" number="2">
				<stats passing="60" tackling="69" shooting="37" crossing="58" heading="50" dribbling="41" speed="62" stamina="78" aggression="77" strength="68" fitness="78" creativity="53"/>
			</player>
			<player id="Stephen Warnock" name="Stephen Warnock" birthday="12-12-1981" positions="fb-cm" nationality="en" number="3">
				<stats passing="69" tackling="77" shooting="30" crossing="72" heading="60" dribbling="57" speed="70" stamina="90" aggression="62" strength="66" fitness="75" creativity="60"/>				
			</player>
			<player id="Richard Dunne" name="Richard Dunne" birthday="21-09-1979" positions="cb" nationality="ir" number="5">
				<stats passing="40" tackling="83" shooting="28" crossing="39" heading="80" dribbling="41" speed="74" stamina="64" aggression="60" strength="88" fitness="50" creativity="49"/>				
			</player>
			<player id="James Collins" name="James Collins" birthday="23-8-1983" positions="cb" nationality="we" number="29">
				<stats passing="55" tackling="75" shooting="42" crossing="41" heading="79" dribbling="50" speed="55" stamina="70" aggression="78" strength="80" fitness="54" creativity="45"/>
			</player>
			<player id="Curtis Davies" name="Curtis Davies" birthday="15-3-1985" positions="cb" nationality="en" number="15">
				<stats passing="47" tackling="76" shooting="10" crossing="30" heading="77" dribbling="46" speed="77" stamina="75" aggression="63" strength="16" fitness="60" creativity="30"/>
			</player>
			<player id="Stiliyan Petrov" name="Stiliyan Petrov" birthday="5-7-1979" positions="dm-cm" nationality="bu" number="19">
				<stats passing="75" tackling="75" shooting="55" crossing="56" heading="60" dribbling="60" speed="45" stamina="53" aggression="70" strength="70" fitness="87" creativity="75"/>
			</player>
			<player id="Nigel Reo-Coker" name="Nigel Reo-Coker" birthday="14-5-1984" positions="cm-dm" nationality="en" number="20">
				<stats passing="40" tackling="76" shooting="48" crossing="57" heading="55" dribbling="55" speed="75" stamina="90" aggression="85" strength="75" fitness="85" creativity="57"/>	
			</player>
			<player id="Barry Bannan" name="Barry Bannan" birthday="1-12-1989" positions="wf-cm" nationality="sc" number="46">
				<stats passing="60" tackling="40" shooting="45" crossing="58" heading="25" dribbling="62" speed="60" stamina="55" aggression="50" strength="30" fitness="70" creativity="65"/>	
			</player>
			<player id="Moustapha Salifou" name="Moustapha Salifou" birthday="1-6-1983" positions="cm" nationality="to" number="17">
				<stats passing="73" tackling="49" shooting="48" crossing="50" heading="50" dribbling="50" speed="60" stamina="68" aggression="50" strength="58" fitness="64" creativity="63"/>
			</player>
			<player id="Steve Sidwell" name="Steve Sidwell" birthday="14-12-1982" positions="cm" nationality="en" number="4">
				<stats passing="74" tackling="73" shooting="35" crossing="54" heading="40" dribbling="55" speed="62" stamina="85" aggression="75" strength="71" fitness="95" creativity="70"/>	
			</player>
			<player id="Isaiah Osbourne" name="Isaiah Osbourne" birthday="5-11-1987" positions="cm" nationality="en" number="27">
				<stats passing="53" tackling="59" shooting="38" crossing="40" heading="56" dribbling="60" speed="61" stamina="67" aggression="54" strength="61" fitness="75" creativity="52"/>		
			</player>
			<player id="Ashley Young" name="Ashley Young" birthday="9-7-1985" positions="wf-cm" nationality="en" number="7">
				<stats passing="65" tackling="27" shooting="58" crossing="78" heading="35" dribbling="75" speed="78" stamina="77" aggression="40" strength="40" fitness="80" creativity="65"/>		
			</player>
			<player id="Marc Albrighton" name="Marc Albrighton" birthday="18-11-1989" positions="am-wf" nationality="en" number="12">
				<stats passing="53" tackling="39" shooting="55" crossing="76" heading="37" dribbling="66" speed="60" stamina="72" aggression="50" strength="27" fitness="73" creativity="60"/>		
			</player>
			<player id="Brad Guzan" name="Brad Guzan" birthday="9-9-1984" positions="gk" nationality="us" number="22">
				<stats catching="75" shotStopping="73" distribution="59" fitness="45" stamina="65"/>		
			</player>
			<player id="Stewart Downing" name="Stewart Downing" birthday="22-7-1984" positions="wf-cm" nationality="en" number="6">
				<stats passing="77" tackling="25" shooting="68" crossing="76" heading="44" dribbling="63" speed="74" stamina="74" aggression="20" strength="52" fitness="59" creativity="65"/>		
			</player>
			<player id="stephen Ireland" name="Stephen Ireland" birthday="29-08-1986" positions="am-cm" nationality="ir" number="9">
				<stats passing="74" tackling="60" shooting="68" crossing="53" heading="25" dribbling="66" speed="62" stamina="84" aggression="51" strength="59" fitness="84" creativity="81"/>		
			</player>
			<player id="John Carew" name="John Carew" birthday="5-9-1979" positions="cf" nationality="nw" number="10">
				<stats passing="61" tackling="20" shooting="66" crossing="44" heading="81" dribbling="69" speed="77" stamina="61" aggression="61" strength="98" fitness="50" creativity="50"/>		
			</player>
			<player id="Emile Heskey" name="Emile Heskey" birthday="11-1-1978" positions="cf" nationality="en" number="18">
				<stats passing="65" tackling="65" shooting="58" crossing="59" heading="73" dribbling="70" speed="62" stamina="67" aggression="57" strength="90" fitness="73" creativity="60"/>		
			</player>
			<player id="Gabriel Agbonlahor" name="Gabriel Agbonlahor" birthday="13-10-1986" positions="cf" nationality="en" number="11">
				<stats passing="53" tackling="23" shooting="59" crossing="53" heading="80" dribbling="69" speed="92" stamina="89" aggression="63" strength="83" fitness="85" creativity="65"/>		
			</player>
			<player id="Nathan Delfouneso" name="Nathan Delfouneso" birthday="2-2-1991" positions="cf" nationality="en" number="14">
				<stats passing="37" tackling="24" shooting="60" crossing="47" heading="39" dribbling="70" speed="77" stamina="66" aggression="51" strength="41" fitness="74" creativity="44"/>		
			</player>
		</players>
	</club>
	<club shirtColor="0x0000DD" sleevesColor="0x0000DD" stripesType="none" scoreMultiplier="5" attackScore="D" defendScore="C">
		<name><![CDATA[Birmingham City]]></name>
		<profile>65</profile>
		<players>
			<player id="Ben Foster" name="Ben Foster" birthday="03-04-1983" positions="gk" nationality="en" number="26">
				<stats catching="77" shotStopping="79" distribution="86" fitness="70" stamina="75"/>
			</player>
			<player id="Maik Taylor" name="Maik Taylor" birthday="04-09-1971" positions="gk" nationality="ni" number="1">
				<stats catching="73" shotStopping="75" distribution="46" fitness="64" stamina="60"/>
			</player>
			<player id="Stephen Carr" name="Stephen Carr" birthday="29-08-1976" positions="fb" nationality="ir" number="2">
				<stats passing="73" tackling="77" shooting="48" crossing="76" heading="75" dribbling="67" speed="59" stamina="73" aggression="78" strength="76" fitness="66" creativity="51"/>	
			</player>	
			<player id="Martin Jiranek" name="Martin Jiranek" birthday="25-05-1983" positions="cb-wb" nationality="cz" number="28">
				<stats passing="56" tackling="73" shooting="39" crossing="46" heading="78" dribbling="51" speed="65" stamina="75" aggression="75" strength="78" fitness="68" creativity="49"/>
			</player>
			<player id="David Murphy" name="David Murphy" birthday="1-3-1984" positions="fb" nationality="en" number="3">
				<stats passing="63" tackling="61" shooting="55" crossing="56" heading="55" dribbling="65" speed="63" stamina="75" aggression="50" strength="71" fitness="62" creativity="50"/>
			</player>
			<player id="Liam Ridgewell" name="Liam Ridgewell" birthday="21-07-1984" positions="fb-cb" nationality="en" number="6">
				<stats passing="68" tackling="78" shooting="45" crossing="60" heading="82" dribbling="50" speed="54" stamina="66" aggression="80" strength="63" fitness="75" creativity="60"/>				
			</player>
			<player id="Roger Johnson" name="Roger Johnson" birthday="28-04-1983" positions="cb" nationality="en" number="14">
				<stats passing="41" tackling="81" shooting="15" crossing="11" heading="81" dribbling="26" speed="65" stamina="73" aggression="68" strength="75" fitness="61" creativity="25"/>				
			</player>
			<player id="Scott Dann" name="Scott Dann" birthday="14-02-1987" positions="cb" nationality="en" number="15">
				<stats passing="56" tackling="85" shooting="55" crossing="26" heading="76" dribbling="46" speed="60" stamina="63" aggression="57" strength="58" fitness="63" creativity="56"/>
			</player>
			<player id="Stuart Parnaby" name="Stuart Parnaby" birthday="19-07-1982" positions="fb" nationality="en" number="21">
				<stats passing="53" tackling="63" shooting="44" crossing="66" heading="57" dribbling="53" speed="67" stamina="65" aggression="57" strength="66" fitness="52" creativity="41"/>
			</player>
			<player id="Sebastian Larsson" name="Sebastian Larsson" birthday="06-06-1985" positions="sm-cm-fb" nationality="sw" number="7">
				<stats passing="63" tackling="59" shooting="70" crossing="75" heading="60" dribbling="63" speed="67" stamina="70" aggression="40" strength="55" fitness="74" creativity="50"/>
			</player>
			<player id="Craig Gardner" name="Craig Gardner" birthday="25-11-1986" positions="cm" nationality="en" number="33">
				<stats passing="60" tackling="57" shooting="57" crossing="55" heading="33" dribbling="47" speed="58" stamina="77" aggression="88" strength="47" fitness="73" creativity="57"/>	
			</player>
			<player id="Keith Fahey" name="Keith Fahey" birthday="15-1-1983" positions="wf-cm" nationality="ir" number="18">
				<stats passing="75" tackling="23" shooting="27" crossing="63" heading="67" dribbling="57" speed="63" stamina="57" aggression="35" strength="54" fitness="66" creativity="71"/>	
			</player>
			<player id="James McFadden" name="James McFadden" birthday="14-04-1983" positions="wf-cf-cm" nationality="sc" number="16">
				<stats passing="63" tackling="43" shooting="70" crossing="63" heading="48" dribbling="68" speed="63" stamina="78" aggression="77" strength="58" fitness="75" creativity="64"/>
			</player>
			<player id="Michel" name="Michel" birthday="08-11-1985" positions="cm" nationality="es" number="17">
				<stats passing="58" tackling="61" shooting="63" crossing="5" heading="57" dribbling="53" speed="62" stamina="63" aggression="79" strength="66" fitness="75" creativity="57"/>	
			</player>
			<player id="Barry Ferguson" name="Barry Ferguson" birthday="02-02-1978" positions="cm-dm" nationality="sc" number="12">
				<stats passing="83" tackling="69" shooting="58" crossing="64" heading="47" dribbling="53" speed="48" stamina="67" aggression="63" strength="62" fitness="66" creativity="58"/>		
			</player>
			<player id="Aliaksandr Hleb" name="Aliaksandr Hleb" birthday="01-05-1981" positions="am-wf-cm" nationality="br" number="22">
				<stats passing="77" tackling="33" shooting="23" crossing="56" heading="16" dribbling="78" speed="58" stamina="44" aggression="37" strength="28" fitness="49" creativity="63"/>		
			</player>
			<player id="Lee Bowyer" name="Lee Bowyer" birthday="03-01-1977" positions="cm-am" nationality="en" number="4">
				<stats passing="69" tackling="77" shooting="58" crossing="69" heading="61" dribbling="64" speed="52" stamina="75" aggression="89" strength="74" fitness="69" creativity="62"/>		
			</player>
			<player id="Colin Doyle" name="Colin Doyle" birthday="12-6-1985" positions="gk" nationality="ir" number="13">
				<stats catching="50" shotStopping="76" distribution="60" fitness="67" stamina="84"/>		
			</player>
			<player id="James O' Shea" name="James O' Shea" birthday="10-08-1988" positions="cm" nationality="ir" number="24">
				<stats passing="55" tackling="21" shooting="54" crossing="57" heading="33" dribbling="58" speed="68" stamina="56" aggression="23" strength="32" fitness="85" creativity="58"/>		
			</player>
			<player id="Jean Beausejour" name="Jean Beausejour" birthday="01-06-1984" positions="am-wf-cf" nationality="ch" number="23">
				<stats passing="63" tackling="27" shooting="44" crossing="73" heading="53" dribbling="65" speed="80" stamina="75" aggression="56" strength="60" fitness="75" creativity="44"/>		
			</player>
			<player id="Kevin Phillips" name="Kevin Phillips" birthday="25-07-1973" positions="cf" nationality="en" number="9" progressType="sin3">
				<stats passing="66" tackling="37" shooting="77" crossing="58" heading="68" dribbling="70" speed="40" stamina="39" aggression="35" strength="60" fitness="60" creativity="75"/>		
			</player>
			<player id="Matt Derbyshire" name="Matt Derbyshire" birthday="14-04-1986" positions="cf" nationality="en" number="14">
				<stats passing="55" tackling="25" shooting="63" crossing="54" heading="63" dribbling="47" speed="73" stamina="66" aggression="47" strength="52" fitness="77" creativity="53"/>		
			</player>
			<player id="Cameron Jerome" name="Cameron Jerome" birthday="14-10-1986" positions="cf" nationality="en" number="10">
				<stats passing="54" tackling="34" shooting="64" crossing="47" heading="74" dribbling="60" speed="84" stamina="57" aggression="38" strength="59" fitness="65" creativity="53"/>		
			</player>
			<player id="Nikola Zigic" name="Nikola Zigic" birthday="25-09-1980" positions="cf" nationality="se" number="19">
				<stats passing="60" tackling="33" shooting="69" crossing="30" heading="86" dribbling="58" speed="55" stamina="73" aggression="58" strength="99" fitness="75" creativity="55"/>		
			</player>
		</players>
	</club>
	<club shirtColor="0x0000DD" sleevesColor="0xFFFFFF" stripesType="vertical" stripesColor="0xFFFFFF" scoreMultiplier="4" attackScore="E" defendScore="C">
		<name><![CDATA[Blackburn Rovers]]></name>
		<profile>70</profile>
		<players>
			<player id="Paul Robinson" name="Paul Robinson" birthday="15-10-1979" positions="gk" nationality="en" number="1">
				<stats catching="70" shotStopping="85" distribution="95" fitness="70" stamina="80"/>
			</player>
			<player id="Pascal Chimbonda" name="Pascal Chimbonda" birthday="21-02-1979" positions="fb" nationality="fr" number="39">
				<stats passing="60" tackling="75" shooting="37" crossing="59" heading="69" dribbling="57" speed="69" stamina="83" aggression="72" strength="68" fitness="77" creativity="47"/>	
			</player>	
			<player id="Brett Emerton" name="Brett Emerton" birthday="22-02-1979" positions="cm-fb" nationality="au" number="7">
				<stats passing="60" tackling="70" shooting="45" crossing="63" heading="58" dribbling="50" speed="65" stamina="99" aggression="80" strength="75" fitness="98" creativity="60"/>
			</player>
			<player id="Gael Givet" name="Gael Givet" birthday="09-10-1981" positions="cb-fb" nationality="fr" number="5">
				<stats passing="38" tackling="88" shooting="25" crossing="23" heading="73" dribbling="23" speed="58" stamina="64" aggression="78" strength="79" fitness="75" creativity="43"/>
			</player>
			<player id="Ryan Nelson" name="Ryan Nelson" birthday="18-10-1977" positions="cb" nationality="nz" number="6">
				<stats passing="39" tackling="86" shooting="15" crossing="16" heading="72" dribbling="24" speed="47" stamina="62" aggression="78" strength="88" fitness="84" creativity="42"/>				
			</player>
			<player id="Christopher Samba" name="Christopher Samba" birthday="28-03-1984" positions="cb" nationality="co" number="4">
				<stats passing="42" tackling="74" shooting="38" crossing="17" heading="81" dribbling="43" speed="74" stamina="64" aggression="84" strength="94" fitness="74" creativity="43"/>				
			</player>
			<player id="Phil Jones" name="Phil Jones" birthday="21-02-1992" positions="cb-dm-cm" nationality="en" number="28">
				<stats passing="43" tackling="63" shooting="16" crossing="24" heading="64" dribbling="38" speed="68" stamina="63" aggression="83" strength="67" fitness="80" creativity="33"/>
			</player>
			<player id="Amine Linganzi" name="Amine Linganzi" birthday="16-11-1989" positions="dm" nationality="co" number="14">
				<stats passing="53" tackling="57" shooting="42" crossing="27" heading="67" dribbling="37" speed="49" stamina="75" aggression="57" strength="78" fitness="55" creativity="43"/>
			</player>
			<player id="Michel Salgado" name="Michel Salgado" birthday="22-10-1975" positions="fb" nationality="es" number="27">
				<stats passing="73" tackling="77" shooting="48" crossing="67" heading="24" dribbling="53" speed="52" stamina="63" aggression="88" strength="57" fitness="79" creativity="48"/>
			</player>
			<player id="Martin Olsson" name="Martin Olsson" birthday="22-05-1988" positions="fb" nationality="sw" number="3">
				<stats passing="63" tackling="69" shooting="43" crossing="69" heading="42" dribbling="70" speed="77" stamina="77" aggression="68" strength="59" fitness="78" creativity="64"/>	
			</player>
			<player id="Vincenzo Grella" name="Vincenzo Grella" birthday="05-10-1979" positions="dm-cm" nationality="au" number="11">
				<stats passing="64" tackling="86" shooting="30" crossing="43" heading="62" dribbling="38" speed="50" stamina="78" aggression="82" strength="73" fitness="64" creativity="64"/>	
			</player>
			<player id="Steven N'Zonzi" name="Steven N'Zonzi" birthday="15-12-1988" positions="cm-dm" nationality="fr" number="15">
				<stats passing="60" tackling="63" shooting="49" crossing="33" heading="78" dribbling="48" speed="68" stamina="79" aggression="79" strength="83" fitness="89" creativity="53"/>
			</player>
			<player id="Morten Gamst Pedersen" name="Morten Gamst Pedersen" birthday="08-09-1981" positions="cm" nationality="nw" number="12">
				<stats passing="70" tackling="52" shooting="59" crossing="68" heading="63" dribbling="49" speed="55" stamina="75" aggression="57" strength="46" fitness="84" creativity="72"/>	
			</player>
			<player id="Keith Andrews" name="Keith Andrews" birthday="13-09-1980" positions="cm" nationality="ir" number="17">
				<stats passing="54" tackling="46" shooting="45" crossing="50" heading="58" dribbling="44" speed="54" stamina="93" aggression="70" strength="70" fitness="89" creativity="57"/>		
			</player>
			<player id="El Hadji Diouf" name="El Hadji Diouf" birthday="15-01-1981" positions="am-cf" nationality="se" number="10">
				<stats passing="63" tackling="50" shooting="51" crossing="67" heading="54" dribbling="69" speed="64" stamina="63" aggression="85" strength="57" fitness="67" creativity="70"/>		
			</player>
			<player id="Aaron Doran" name="Aaron Doran" birthday="13-05-1991" positions="cm-am" nationality="ir" number="19">
				<stats passing="39" tackling="12" shooting="21" crossing="43" heading="23" dribbling="54" speed="63" stamina="52" aggression="69" strength="44" fitness="77" creativity="52"/>		
			</player>
			<player id="David Dunn" name="David Dunn" birthday="27-12-1979" positions="am-cm" nationality="en" number="8">
				<stats passing="83" tackling="51" shooting="65" crossing="57" heading="38" dribbling="84" speed="55" stamina="58" aggression="75" strength="70" fitness="50" creativity="70"/>	
			</player>
			<player id="Mark Bunn" name="Mark Bunn" birthday="16-11-1984" positions="gk" nationality="en" number="13">
				<stats catching="65" shotStopping="76" distribution="70" fitness="60" stamina="63"/>		
			</player>
			<player id="Nikola Kalinic" name="Nikola Kalinic" birthday="05-01-1988" positions="cf" nationality="cr" number="9">
				<stats passing="54" tackling="33" shooting="55" crossing="44" heading="64" dribbling="62" speed="63" stamina="64" aggression="88" strength="70" fitness="73" creativity="65"/>		
			</player>
			<player id="Jason Roberts" name="Jason Roberts" birthday="25-01-1978" positions="cf" nationality="gn" number="16">
				<stats passing="51" tackling="33" shooting="45" crossing="44" heading="67" dribbling="53" speed="73" stamina="90" aggression="95" strength="85" fitness="67" creativity="54"/>		
			</player>
			<player id="Benjani" name="Benjani" birthday="13-08-1978" positions="cf" nationality="zi" number="21">
				<stats passing="51" tackling="46" shooting="54" crossing="51" heading="64" dribbling="54" speed="57" stamina="75" aggression="70" strength="90" fitness="75" creativity="60"/>		
			</player>
			<player id="Mame Biram Diouf" name="Mame Biram Diouf" birthday="01-12-1987" positions="cf" nationality="se" number="41">
				<stats passing="45" tackling="33" shooting="45" crossing="37" heading="75" dribbling="42" speed="83" stamina="58" aggression="63" strength="58" fitness="55" creativity="33"/>		
			</player>			
			<player id="Jason Brown" name="Jason Brown" birthday="18-05-1982" positions="gk" nationality="we" number="32">
				<stats catching="63" shotStopping="78" distribution="38" fitness="53" stamina="67"/>		
			</player>
		</players>
	</club>
	<club shirtColor="0xFF9900" sleevesColor="0xFF9900" stripesType="none" scoreMultiplier="5" attackScore="E" defendScore="F">
		<name><![CDATA[Blackpool]]></name>
		<profile>30</profile>
		<players>
			<player id="Richard Kingson" name="Richard Kingson" birthday="13-06-1978" positions="gk" nationality="gh" number="28">
				<stats catching="70" shotStopping="64" distribution="84" fitness="60" stamina="65"/>
			</player>
			<player id="Dekel Keinan" name="Dekel Keinan" birthday="15-09-1984" positions="cb" nationality="is" number="31">
				<stats passing="51" tackling="67" shooting="20" crossing="44" heading="75" dribbling="42" speed="55" stamina="60" aggression="60" strength="65" fitness="43" creativity="52"/>	
			</player>	
			<player id="Alex John-Baptiste" name="Alex John-Baptiste" birthday="31-01-1986" positions="fb" nationality="en" number="15">
				<stats passing="50" tackling="76" shooting="23" crossing="48" heading="67" dribbling="24" speed="72" stamina="45" aggression="55" strength="62" fitness="75" creativity="34"/>
			</player>
			<player id="Neil Eardley" name="Neil Eardley" birthday="06-11-1988" positions="fb" nationality="we" number="5">
				<stats passing="64" tackling="68" shooting="60" crossing="60" heading="60" dribbling="58" speed="67" stamina="54" aggression="52" strength="64" fitness="78" creativity="52"/>
			</player>
			<player id="Stephen Crainey" name="Stephen Crainey" birthday="22-06-1981" positions="fb" nationality="sc" number="3">
				<stats passing="62" tackling="73" shooting="22" crossing="64" heading="67" dribbling="28" speed="57" stamina="80" aggression="65" strength="45" fitness="65" creativity="54"/>				
			</player>
			<player id="Craig Cathcart" name="Craig Cathcart" birthday="05-02-1989" positions="cb" nationality="ni" number="20">
				<stats passing="53" tackling="75" shooting="7" crossing="11" heading="75" dribbling="26" speed="53" stamina="56" aggression="60" strength="64" fitness="64" creativity="27"/>				
			</player>
			<player id="Chris Basham" name="Chris Basham" birthday="20-07-1988" positions="dm-cm" nationality="en" number="17">
				<stats passing="56" tackling="69" shooting="56" crossing="50" heading="64" dribbling="51" speed="64" stamina="69" aggression="60" strength="51" fitness="70" creativity="50"/>
			</player>
			<player id="Danny Cold" name="Danny Cold" birthday="03-10-1981" positions="fb" nationality="en" number="2">
				<stats passing="50" tackling="57" shooting="40" crossing="64" heading="27" dribbling="57" speed="65" stamina="54" aggression="29" strength="29" fitness="55" creativity="51"/>
			</player>
			<player id="David Carney" name="David Carney" birthday="30-11-1983" positions="fb-wf" nationality="au" number="29">
				<stats passing="55" tackling="37" shooting="38" crossing="57" heading="35" dribbling="63" speed="64" stamina="58" aggression="51" strength="54" fitness="55" creativity="55"/>
			</player>
			<player id="Keith Southern" name="Keith Southern" birthday="24-04-1981" positions="dm-cm" nationality="en" number="4">
				<stats passing="69" tackling="75" shooting="45" crossing="38" heading="63" dribbling="44" speed="59" stamina="78" aggression="78" strength="68" fitness="75" creativity="41"/>	
			</player>
			<player id="Gary Taylor-Fletcher" name="Gary Taylor-Fletcher" birthday="04-06-1981" positions="cm-am-wf-cf" nationality="en" number="12">
				<stats passing="63" tackling="17" shooting="62" crossing="64" heading="64" dribbling="67" speed="54" stamina="58" aggression="58" strength="63" fitness="50" creativity="38"/>	
			</player>
			<player id="Brett Ormerod" name="Brett Ormerod" birthday="18-10-1976" positions="cf-am" nationality="en" number="10">
				<stats passing="65" tackling="50" shooting="59" crossing="54" heading="69" dribbling="68" speed="65" stamina="80" aggression="64" strength="59" fitness="70" creativity="50"/>
			</player>
			<player id="Ishmel Demontagnac" name="Ishmel Demontagnac" birthday="15-06-1988" positions="am-wf-cf" nationality="en" number="27">
				<stats passing="45" tackling="25" shooting="55" crossing="54" heading="3" dribbling="50" speed="63" stamina="49" aggression="53" strength="34" fitness="58" creativity="55"/>	
			</player>
			<player id="David Vaughan" name="David Vaughan" birthday="18-02-1983" positions="cm" nationality="we" number="11">
				<stats passing="78" tackling="68" shooting="46" crossing="68" heading="53" dribbling="74" speed="54" stamina="63" aggression="58" strength="54" fitness="68" creativity="64"/>		
			</player>
			<player id="Charlie Adam" name="Charlie Adam" birthday="10-12-1985" positions="cm-am" nationality="sc" number="26">
				<stats passing="80" tackling="70" shooting="75" crossing="70" heading="60" dribbling="70" speed="45" stamina="65" aggression="65" strength="55" fitness="60" creativity="85"/>		
			</player>
			<player id="Ludovic Sylvestre" name="Ludovic Sylvestre" birthday="05-02-1985" positions="cm" nationality="fr" number="19">
				<stats passing="80" tackling="70" shooting="25" crossing="56" heading="33" dribbling="67" speed="54" stamina="75" aggression="27" strength="50" fitness="95" creativity="55"/>		
			</player>
			<player id="Malaury Martin" name="Malaury Martin" birthday="25-08-1988" positions="cm" nationality="fr" number="8">
				<stats passing="58" tackling="36" shooting="28" crossing="53" heading="32" dribbling="55" speed="57" stamina="73" aggression="51" strength="52" fitness="51" creativity="67"/>	
			</player>
			<player id="Matthew Gilks" name="Matthew Gilks" birthday="04-06-1982" positions="gk" nationality="sc" number="21">
				<stats catching="76" shotStopping="69" distribution="64" fitness="49" stamina="58"/>		
			</player>
			<player id="Elliot Grandin" name="Elliot Grandin" birthday="17-10-1987" positions="am-wf" nationality="fr" number="14">
				<stats passing="69" tackling="12" shooting="63" crossing="68" heading="34" dribbling="69" speed="68" stamina="61" aggression="20" strength="42" fitness="66" creativity="60"/>		
			</player>
			<player id="DJ Campbell" name="DJ Campbell" birthday="12-11-1981" positions="cf" nationality="en" number="39">
				<stats passing="58" tackling="16" shooting="59" crossing="34" heading="50" dribbling="73" speed="80" stamina="52" aggression="55" strength="55" fitness="75" creativity="60"/>		
			</player>
			<player id="Marlon Harewood" name="Marlon Harewood" birthday="25-08-1979" positions="cf" nationality="en" number="9">
				<stats passing="50" tackling="55" shooting="56" crossing="60" heading="53" dribbling="56" speed="80" stamina="83" aggression="85" strength="80" fitness="55" creativity="33"/>		
			</player>
			<player id="Luke Varney" name="Luke Varney" birthday="28-09-1982" positions="cf-wf" nationality="en" number="16">
				<stats passing="55" tackling="45" shooting="63" crossing="60" heading="55" dribbling="65" speed="65" stamina="60" aggression="55" strength="55" fitness="60" creativity="55"/>		
			</player>
			<player id="Paul Rachubka" name="Paul Rachubka" birthday="21-05-1981" positions="gk" nationality="en" number="1">
				<stats catching="63" shotStopping="75" distribution="60" fitness="58" stamina="59"/>		
			</player>
		</players>
	</club>
	<club shirtColor="0xFFFFFF" sleevesColor="0xFFFFFF" stripesType="none" scoreMultiplier="3" attackScore="E" defendScore="C">
		<name><![CDATA[Bolton Wanderers]]></name>
		<profile>60</profile>
		<players>
			<player id="Jussi Jaaskelainen" name="Jussi Jaaskelainen" birthday="19-04-1975" positions="gk" nationality="fi" number="22">
				<stats catching="74" shotStopping="79" distribution="38" fitness="58" stamina="54"/>
			</player>
			<player id="Sam Rickets" name="Sam Rickets" birthday="11-10-1981" positions="fb-cb" nationality="we" number="18">
				<stats passing="53" tackling="68" shooting="46" crossing="77" heading="58" dribbling="64" speed="52" stamina="89" aggression="54" strength="50" fitness="78" creativity="54"/>	
			</player>	
			<player id="Paul Robinson Bolton" name="Paul Robinson" birthday="14-12-1978" positions="fb" nationality="en" number="4">
				<stats passing="59" tackling="74" shooting="21" crossing="54" heading="69" dribbling="52" speed="65" stamina="78" aggression="84" strength="80" fitness="76" creativity="49"/>
			</player>
			<player id="Zat Knight" name="Zat Knight" birthday="02-05-1980" positions="cb" nationality="en" number="12">
				<stats passing="38" tackling="68" shooting="42" crossing="28" heading="73" dribbling="34" speed="64" stamina="65" aggression="72" strength="73" fitness="79" creativity="55"/>
			</player>
			<player id="Andy O'Brien" name="Andy O'Brien" birthday="29-06-1979" positions="cb" nationality="ir" number="31">
				<stats passing="61" tackling="74" shooting="27" crossing="29" heading="74" dribbling="12" speed="63" stamina="79" aggression="59" strength="68" fitness="64" creativity="53"/>				
			</player>
			<player id="Gary Cahill" name="Gary Cahill" birthday="19-12-1985" positions="cb" nationality="en" number="5">
				<stats passing="75" tackling="74" shooting="54" crossing="24" heading="79" dribbling="54" speed="69" stamina="69" aggression="58" strength="70" fitness="63" creativity="58"/>				
			</player>
			<player id="Gretar Steinsson" name="Gretar Steinsson" birthday="09-01-1982" positions="fb" nationality="ic" number="2">
				<stats passing="70" tackling="71" shooting="38" crossing="70" heading="64" dribbling="54" speed="58" stamina="73" aggression="94" strength="83" fitness="90" creativity="64"/>
			</player>
			<player id="Matty Taylor" name="Matty Taylor" birthday="27-11-1981" positions="fb-cm" nationality="en" number="7">
				<stats passing="72" tackling="54" shooting="71" crossing="79" heading="54" dribbling="29" speed="64" stamina="94" aggression="53" strength="58" fitness="60" creativity="56"/>
			</player>
			<player id="Sean Davies" name="Sean Davies" birthday="02-09-1979" positions="dm-cm" nationality="en" number="23">
				<stats passing="74" tackling="76" shooting="39" crossing="42" heading="54" dribbling="50" speed="63" stamina="74" aggression="89" strength="73" fitness="77" creativity="54"/>
			</player>
			<player id="Fabrice Muamba" name="Fabrice Muambe" birthday="06-04-1988" positions="dm-cm" nationality="en" number="6">
				<stats passing="53" tackling="68" shooting="31" crossing="44" heading="41" dribbling="44" speed="67" stamina="83" aggression="78" strength="79" fitness="81" creativity="42"/>	
			</player>
			<player id="Joey O'Brien" name="Joey O'Brien" birthday="17-02-1986" positions="cm" nationality="ir" number="28">
				<stats passing="65" tackling="69" shooting="45" crossing="34" heading="41" dribbling="39" speed="59" stamina="90" aggression="59" strength="45" fitness="78" creativity="48"/>	
			</player>
			<player id="Lee Chung-Yong" name="Lee Chung-Yong" birthday="02-07-1988" positions="am" nationality="sk" number="27">
				<stats passing="69" tackling="22" shooting="44" crossing="64" heading="29" dribbling="72" speed="70" stamina="75" aggression="43" strength="47" fitness="63" creativity="73"/>
			</player>
			<player id="Mustapha Riga" name="Mustapha Riga" birthday="10-10-1981" positions="cm" nationality="ne" number="15">
				<stats passing="44" tackling="15" shooting="43" crossing="54" heading="23" dribbling="58" speed="72" stamina="68" aggression="52" strength="53" fitness="89" creativity="54"/>	
			</player>
			<player id="Stuart Holden" name="Stuart Holden" birthday="01-08-1985" positions="am" nationality="us" number="8">
				<stats passing="55" tackling="37" shooting="58" crossing="56" heading="44" dribbling="50" speed="58" stamina="68" aggression="64" strength="58" fitness="75" creativity="58"/>		
			</player>
			<player id="Ricardo Gardner" name="Ricardo Gardner" birthday="25-09-1978" positions="cm-am" nationality="ja" number="11">
				<stats passing="63" tackling="62" shooting="55" crossing="53" heading="39" dribbling="74" speed="78" stamina="71" aggression="44" strength="51" fitness="68" creativity="65"/>		
			</player>
			<player id="Martin Petrov" name="Martin Petrov" birthday="15-01-1979" positions="cm-am-wf" nationality="bu" number="10">
				<stats passing="65" tackling="13" shooting="69" crossing="84" heading="22" dribbling="63" speed="84" stamina="79" aggression="66" strength="54" fitness="39" creativity="58"/>		
			</player>
			<player id="Mark Davies" name="Mark Davies" birthday="18-02-1988" positions="cm-am" nationality="en" number="16">
				<stats passing="77" tackling="54" shooting="54" crossing="58" heading="23" dribbling="69" speed="55" stamina="54" aggression="59" strength="41" fitness="63" creativity="68"/>	
			</player>
			<player id="Rob Lainton" name="Rob Lainton" birthday="12-10-1989" positions="gk" nationality="en" number="13">
				<stats catching="53" shotStopping="64" distribution="62" fitness="59" stamina="22"/>		
			</player>
			<player id="Kevin Davies" name="Kevin Davies" birthday="26-03-1977" positions="cf" nationality="en" number="14">
				<stats passing="75" tackling="77" shooting="69" crossing="64" heading="84" dribbling="44" speed="45" stamina="90" aggression="80" strength="87" fitness="79" creativity="58"/>		
			</player>
			<player id="Robbie Blake" name="Robbie Blake" birthday="04-03-1976" positions="cf" nationality="en" number="20">
				<stats passing="74" tackling="33" shooting="69" crossing="74" heading="24" dribbling="73" speed="41" stamina="58" aggression="43" strength="59" fitness="72" creativity="69"/>		
			</player>
			<player id="Johan Elmander" name="Johan Elmander" birthday="27-05-1981" positions="cf" nationality="sw" number="9">
				<stats passing="59" tackling="25" shooting="76" crossing="27" heading="64" dribbling="53" speed="69" stamina="80" aggression="59" strength="78" fitness="74" creativity="53"/>		
			</player>
			<player id="Ivan Klasnic" name="Ivan Klasnic" birthday="29-01-1980" positions="cf" nationality="cr" number="17">
				<stats passing="68" tackling="27" shooting="65" crossing="47" heading="64" dribbling="58" speed="65" stamina="47" aggression="74" strength="69" fitness="49" creativity="64"/>		
			</player>
			<player id="Rodrigo" name="Rodrigo" birthday="06-03-1991" positions="cf" nationality="es" number="19">
				<stats passing="44" tackling="23" shooting="66" crossing="38" heading="54" dribbling="49" speed="58" stamina="63" aggression="48" strength="49" fitness="79" creativity="38"/>		
			</player>
		</players>
	</club>
	<club shirtColor="0x0055FF" sleevesColor="0x0055FF" stripesType="none" scoreMultiplier="1" attackScore="A" defendScore="A">
		<name><![CDATA[Chelsea]]></name>
		<profile>90</profile>
		<players>
			<player id="Hilario" name="Hilario" birthday="21-10-1975" positions="gk" nationality="pr" number="40">
				<stats catching="64" shotStopping="76" distribution="39" fitness="37" stamina="85"/>
			</player>
			<player id="Jose Bosingwa" name="Jose Bosingwa" birthday="24-08-1982" positions="fb" nationality="pr" number="17">
				<stats passing="59" tackling="65" shooting="40" crossing="69" heading="54" dribbling="70" speed="89" stamina="64" aggression="70" strength="59" fitness="83" creativity="63"/>	
			</player>	
			<player id="Paulo Ferreira" name="Paulo Ferreira" birthday="19-01-1979" positions="fb" nationality="pr" number="19">
				<stats passing="53" tackling="70" shooting="33" crossing="70" heading="55" dribbling="54" speed="60" stamina="77" aggression="69" strength="44" fitness="73" creativity="64"/>
			</player>
			<player id="Branislav Ivanovic" name="Branislav Ivanovic" birthday="22-04-1984" positions="cb-fb" nationality="se" number="2">
				<stats passing="56" tackling="84" shooting="40" crossing="59" heading="77" dribbling="49" speed="65" stamina="79" aggression="59" strength="79" fitness="49" creativity="64"/>
			</player>
			<player id="Ashley Cole" name="Ashley Cole" birthday="20-12-1980" positions="fb" nationality="en" number="3">
				<stats passing="65" tackling="85" shooting="45" crossing="73" heading="50" dribbling="65" speed="85" stamina="90" aggression="80" strength="72" fitness="90" creativity="63"/>				
			</player>
			<player id="John Terry" name="John Terry" birthday="07-12-1980" positions="cb" nationality="en" number="26">
				<stats passing="63" tackling="80" shooting="35" crossing="30" heading="91" dribbling="45" speed="50" stamina="75" aggression="80" strength="80" fitness="81" creativity="53"/>				
			</player>
			<player id="Alex" name="Alex" birthday="17-06-1982" positions="cb" nationality="br" number="33">
				<stats passing="53" tackling="78" shooting="78" crossing="27" heading="83" dribbling="46" speed="67" stamina="72" aggression="66" strength="82" fitness="74" creativity="62"/>
			</player>
			<player id="Yury Zhirkov" name="Yury Zhirkov" birthday="20-08-1983" positions="am-cm-fb" nationality="ru" number="18">
				<stats passing="66" tackling="67" shooting="44" crossing="77" heading="17" dribbling="75" speed="89" stamina="82" aggression="74" strength="43" fitness="67" creativity="62"/>
			</player>
			<player id="Michael Essien" name="Michael Essien" birthday="03-12-1982" positions="dm-cm" nationality="gh" number="5">
				<stats passing="64" tackling="85" shooting="54" crossing="64" heading="57" dribbling="54" speed="79" stamina="100" aggression="89" strength="86" fitness="100" creativity="69"/>
			</player>
			<player id="John Obi Mikel" name="Jon Obi Mikel" birthday="22-04-1987" positions="dm-cm" nationality="ng" number="12">
				<stats passing="74" tackling="71" shooting="23" crossing="57" heading="38" dribbling="52" speed="54" stamina="88" aggression="66" strength="68" fitness="83" creativity="79"/>	
			</player>
			<player id="Ramires" name="Ramires" birthday="24-03-1987" positions="cm" nationality="br" number="7">
				<stats passing="70" tackling="67" shooting="58" crossing="56" heading="58" dribbling="63" speed="79" stamina="78" aggression="63" strength="53" fitness="79" creativity="63"/>	
			</player>
			<player id="Yossi Benayoun" name="Yossi Benayoun" birthday="05-05-1980" positions="am-cm" nationality="is" number="10">
				<stats passing="70" tackling="31" shooting="54" crossing="62" heading="27" dribbling="79" speed="68" stamina="71" aggression="33" strength="29" fitness="68" creativity="71"/>
			</player>
			<player id="Florent Malouda" name="Florent Malouda" birthday="13-06-1980" positions="am-sm" nationality="fr" number="15">
				<stats passing="73" tackling="38" shooting="78" crossing="76" heading="59" dribbling="73" speed="84" stamina="88" aggression="31" strength="77" fitness="70" creativity="75"/>	
			</player>
			<player id="Frank Lampard" name="Frank Lampard" birthday="20-06-1978" positions="cm-am" nationality="en" number="8">
				<stats passing="84" tackling="51" shooting="82" crossing="51" heading="59" dribbling="61" speed="63" stamina="88" aggression="63" strength="63" fitness="96" creativity="81"/>		
			</player>
			<player id="Solomon Kalou" name="Solomon Kalou" birthday="05-08-1985" positions="am-wf-cf" nationality="iv" number="21">
				<stats passing="54" tackling="33" shooting="53" crossing="63" heading="64" dribbling="65" speed="75" stamina="77" aggression="38" strength="55" fitness="80" creativity="65"/>		
			</player>
			<player id="Nicolas Anelka" name="Nicolas Anelka" birthday="14-03-1979" positions="cf" nationality="fr" number="39">
				<stats passing="54" tackling="36" shooting="88" crossing="63" heading="59" dribbling="71" speed="76" stamina="65" aggression="67" strength="64" fitness="84" creativity="67"/>		
			</player>
			<player id="Daniel Sturridge" name="Daniel Sturridge" birthday="01-09-1989" positions="wf-cf" nationality="en" number="23">
				<stats passing="59" tackling="23" shooting="65" crossing="34" heading="42" dribbling="68" speed="80" stamina="69" aggression="54" strength="58" fitness="75" creativity="62"/>	
			</player>
			<player id="Petr Cech" name="Petr Cech" birthday="20-05-1982" positions="gk" nationality="cz" number="1">
				<stats catching="90" shotStopping="85" distribution="63" fitness="85" stamina="71"/>		
			</player>
			<player id="Didier Drogba" name="Didier Drogba" birthday="11-03-1978" positions="cf" nationality="iv" number="11" progressType="sin1">
				<stats passing="55" tackling="34" shooting="89" crossing="75" heading="91" dribbling="65" speed="75" stamina="80" aggression="68" strength="99" fitness="91" creativity="55"/>		
			</player>
			<player id="Ross Turnbull" name="Ross Turnbull" birthday="04-01-1985" positions="gk" nationality="en" number="22">
				<stats catching="70" shotStopping="68" distribution="64" fitness="39" stamina="55"/>		
			</player>
		</players>
	</club>
	<club shirtColor="0x0000FF" sleevesColor="0x0000FF" stripesType="none" scoreMultiplier="3" attackScore="D" defendScore="B">
		<name><![CDATA[Everton]]></name>
		<profile>75</profile>
		<players>
			<player id="Jan Mucha" name="Jan Mucha" birthday="05-12-1982" positions="gk" nationality="sl" number="1">
				<stats catching="64" shotStopping="69" distribution="64" fitness="77" stamina="54"/>
			</player>
			<player id="John Heitinga" name="John Heitinga" birthday="15-11-1983" positions="cb-fb-dm" nationality="nl" number="5">
				<stats passing="68" tackling="78" shooting="54" crossing="64" heading="78" dribbling="53" speed="59" stamina="69" aggression="84" strength="69" fitness="70" creativity="59"/>	
			</player>	
			<player id="Tony Hibbert" name="Tony Hibbert" birthday="20-02-1981" positions="fb" nationality="en" number="2">
				<stats passing="50" tackling="87" shooting="30" crossing="31" heading="67" dribbling="24" speed="64" stamina="79" aggression="84" strength="69" fitness="70" creativity="29"/>
			</player>
			<player id="Phil Neville" name="Phil Neville" birthday="21-01-1977" positions="fb-dm" nationality="en" number="18">
				<stats passing="70" tackling="77" shooting="21" crossing="68" heading="63" dribbling="44" speed="65" stamina="80" aggression="74" strength="56" fitness="77" creativity="36"/>
			</player>
			<player id="Sylvain Distin" name="Sylvain Distin" birthday="16-12-1977" positions="cb" nationality="fr" number="15">
				<stats passing="54" tackling="69" shooting="20" crossing="37" heading="74" dribbling="39" speed="80" stamina="75" aggression="59" strength="79" fitness="74" creativity="35"/>				
			</player>
			<player id="Phil Jagielka" name="Phil Jagielka" birthday="17-08-1982" positions="cb" nationality="en" number="6">
				<stats passing="55" tackling="80" shooting="33" crossing="38" heading="78" dribbling="33" speed="69" stamina="77" aggression="64" strength="65" fitness="75" creativity="54"/>				
			</player>
			<player id="Jack Rodwell" name="Jack Rodwell" birthday="11-03-1991" positions="cm-dm-cb" nationality="en" number="26">
				<stats passing="66" tackling="70" shooting="84" crossing="41" heading="66" dribbling="50" speed="70" stamina="79" aggression="63" strength="62" fitness="73" creativity="59"/>
			</player>
			<player id="Leighton Baines" name="Leighton Baines" birthday="11-12-1984" positions="fb-cm" nationality="en" number="3">
				<stats passing="70" tackling="74" shooting="52" crossing="69" heading="52" dribbling="74" speed="68" stamina="83" aggression="59" strength="44" fitness="74" creativity="63"/>
			</player>
			<player id="Marouane Fellaini" name="Marouane Fellaini" birthday="22-11-1987" positions="dm-cm" nationality="be" number="25">
				<stats passing="73" tackling="64" shooting="54" crossing="42" heading="93" dribbling="58" speed="60" stamina="85" aggression="78" strength="95" fitness="74" creativity="59"/>
			</player>
			<player id="Mikel Arteta" name="Mikel Arteta" birthday="28-03-1982" positions="cm-am" nationality="es" number="10">
				<stats passing="79" tackling="47" shooting="58" crossing="84" heading="34" dribbling="80" speed="69" stamina="68" aggression="62" strength="33" fitness="73" creativity="78"/>	
			</player>
			<player id="Leon Osman" name="Leon Osman" birthday="17-05-1981" positions="am" nationality="en" number="21">
				<stats passing="70" tackling="57" shooting="70" crossing="57" heading="51" dribbling="84" speed="55" stamina="69" aggression="39" strength="34" fitness="75" creativity="74"/>	
			</player>
			<player id="Stephen Pienaar" name="Stephen Pienaar" birthday="17-03-1982" positions="am-cm" nationality="sa" number="20">
				<stats passing="74" tackling="33" shooting="62" crossing="67" heading="39" dribbling="72" speed="69" stamina="75" aggression="68" strength="21" fitness="62" creativity="85"/>
			</player>
			<player id="Diniyar Bilyaletdinov" name="Diniyar Bilyaletdinov" birthday="27-02-1985" positions="cm-am" nationality="ru" number="7">
				<stats passing="76" tackling="44" shooting="66" crossing="64" heading="64" dribbling="58" speed="59" stamina="72" aggression="49" strength="51" fitness="70" creativity="69"/>	
			</player>
			<player id="Tim Cahill" name="Tim Cahill" birthday="06-12-1979" positions="am-cm" nationality="au" number="17">
				<stats passing="70" tackling="64" shooting="68" crossing="58" heading="93" dribbling="58" speed="64" stamina="82" aggression="89" strength="75" fitness="89" creativity="44"/>		
			</player>
			<player id="Magaye Gueye" name="Magaye Gueye" birthday="06-07-1990" positions="am-wf" nationality="fr" number="19">
				<stats passing="54" tackling="11" shooting="59" crossing="44" heading="53" dribbling="68" speed="72" stamina="63" aggression="34" strength="58" fitness="64" creativity="60"/>		
			</player>
			<player id="Louis Saha" name="Louis Saha" birthday="08-08-1978" positions="cf" nationality="fr" number="8">
				<stats passing="58" tackling="28" shooting="68" crossing="53" heading="67" dribbling="58" speed="75" stamina="68" aggression="39" strength="68" fitness="49" creativity="54"/>		
			</player>
			<player id="James Vaughan" name="James Vaughan" birthday="14-07-1988" positions="cf" nationality="en" number="14">
				<stats passing="53" tackling="38" shooting="63" crossing="28" heading="74" dribbling="52" speed="84" stamina="69" aggression="79" strength="59" fitness="58" creativity="25"/>	
			</player>
			<player id="Tim Howard" name="Tim Howard" birthday="06-03-1979" positions="gk" nationality="us" number="24">
				<stats catching="79" shotStopping="82" distribution="58" fitness="68" stamina="64"/>		
			</player>
			<player id="Yakubu" name="Yakubu" birthday="22-11-1982" positions="cf" nationality="ng" number="22">
				<stats passing="64" tackling="33" shooting="76" crossing="47" heading="64" dribbling="54" speed="59" stamina="68" aggression="44" strength="87" fitness="69" creativity="70"/>		
			</player>
			<player id="Jermaine Beckford" name="Jermaine Beckford" birthday="09-12-1984" positions="cf" nationality="en" number="16">
				<stats passing="44" tackling="22" shooting="68" crossing="34" heading="54" dribbling="70" speed="85" stamina="64" aggression="54" strength="64" fitness="65" creativity="64"/>		
			</player>
			<player id="Iain Turner" name="Iain Turner" birthday="26-01-1984" positions="gk" nationality="sc" number="12">
				<stats catching="64" shotStopping="73" distribution="70" fitness="59" stamina="62"/>		
			</player>
		</players>
	</club>
	<club shirtColor="0xFFFFFF" sleevesColor="0xFFFFFF" stripesType="none" scoreMultiplier="4" attackScore="E" defendScore="C">
		<name><![CDATA[Fulham]]></name>
		<profile>60</profile>
		<players>
			<player id="Mark Schwarzer" name="Mark Schwarzer" birthday="06-10-1972" positions="gk" nationality="au" number="1">
				<stats catching="84" shotStopping="88" distribution="59" fitness="53" stamina="68"/>
			</player>
			<player id="Fredrik Stoor" name="Fredrik Stoor" birthday="28-02-1984" positions="fb-cb" nationality="sw" number="22">
				<stats passing="58" tackling="59" shooting="39" crossing="58" heading="55" dribbling="36" speed="83" stamina="72" aggression="49" strength="64" fitness="63" creativity="59"/>	
			</player>	
			<player id="John Pantsil" name="John Pantsil" birthday="15-06-1981" positions="fb" nationality="gh" number="4">
				<stats passing="62" tackling="65" shooting="38" crossing="64" heading="65" dribbling="64" speed="67" stamina="69" aggression="54" strength="63" fitness="78" creativity="58"/>
			</player>
			<player id="Chris Baird" name="Chris Baird" birthday="25-02-1982" positions="fb-dm-cm" nationality="ni" number="6">
				<stats passing="64" tackling="71" shooting="34" crossing="54" heading="68" dribbling="37" speed="59" stamina="75" aggression="54" strength="67" fitness="68" creativity="53"/>
			</player>
			<player id="Carlos Salcido" name="Carlos Salcido" birthday="02-04-1980" positions="fb" nationality="me" number="3">
				<stats passing="58" tackling="72" shooting="44" crossing="38" heading="74" dribbling="53" speed="59" stamina="70" aggression="89" strength="63" fitness="84" creativity="59"/>				
			</player>
			<player id="Brede Hangeland" name="Brede Hangeland" birthday="20-06-1981" positions="cb" nationality="nw" number="5">
				<stats passing="64" tackling="77" shooting="25" crossing="16" heading="87" dribbling="26" speed="65" stamina="70" aggression="70" strength="80" fitness="70" creativity="45"/>				
			</player>
			<player id="Aaron Hughes" name="Aaron Hughes" birthday="08-11-1979" positions="cb" nationality="ni" number="18">
				<stats passing="65" tackling="69" shooting="30" crossing="58" heading="60" dribbling="54" speed="69" stamina="70" aggression="60" strength="65" fitness="70" creativity="55"/>
			</player>
			<player id="Philippe Senderos" name="Philippe Senderos" birthday="14-02-1985" positions="cb" nationality="sz" number="14">
				<stats passing="58" tackling="80" shooting="23" crossing="17" heading="89" dribbling="17" speed="52" stamina="68" aggression="69" strength="73" fitness="40" creativity="44"/>
			</player>
			<player id="Stephen Kelly" name="Stephen Kelly" birthday="06-09-1983" positions="fb" nationality="ir" number="2">
				<stats passing="58" tackling="74" shooting="44" crossing="58" heading="69" dribbling="54" speed="68" stamina="67" aggression="44" strength="53" fitness="85" creativity="54"/>
			</player>
			<player id="Jonathan Greening" name="Jonathan Greening" birthday="02-01-1979" positions="dm-cm" nationality="en" number="27">
				<stats passing="58" tackling="60" shooting="42" crossing="68" heading="35" dribbling="53" speed="54" stamina="68" aggression="39" strength="42" fitness="79" creativity="59"/>	
			</player>
			<player id="Dickson Etuhu" name="Dickson Etuhu" birthday="08-06-1982" positions="cm-dm" nationality="ng" number="20">
				<stats passing="62" tackling="76" shooting="60" crossing="34" heading="67" dribbling="58" speed="58" stamina="74" aggression="83" strength="82" fitness="75" creativity="46"/>
			</player>
			<player id="Kagiso Dikgacoi" name="Kagiso Dikgacoi" birthday="24-11-1984" positions="cm-dm" nationality="sa" number="26">
				<stats passing="59" tackling="74" shooting="60" crossing="39" heading="74" dribbling="49" speed="53" stamina="68" aggression="64" strength="89" fitness="54" creativity="44"/>
			</player>
			<player id="Bjorn Helge Riise" name="Bjorn Helge Riise" birthday="21-06-1983" positions="cm" nationality="nw" number="17">
				<stats passing="58" tackling="39" shooting="58" crossing="68" heading="39" dribbling="56" speed="63" stamina="82" aggression="69" strength="54" fitness="73" creativity="59"/>	
			</player>
			<player id="Simon Davies" name="Simon Davies" birthday="23-10-1979" positions="cm-am" nationality="we" number="29">
				<stats passing="75" tackling="58" shooting="53" crossing="73" heading="39" dribbling="57" speed="58" stamina="78" aggression="34" strength="64" fitness="42" creativity="69"/>		
			</player>
			<player id="Zoltan Gera" name="Zoltan Gera" birthday="22-04-1979" positions="cm" nationality="hu" number="11">
				<stats passing="69" tackling="53" shooting="45" crossing="75" heading="64" dribbling="69" speed="54" stamina="63" aggression="35" strength="54" fitness="64" creativity="75"/>		
			</player>
			<player id="Damien Duff" name="Damien Duff" birthday="02-03-1979" positions="am-wf" nationality="ir" number="16">
				<stats passing="70" tackling="38" shooting="58" crossing="70" heading="15" dribbling="70" speed="63" stamina="68" aggression="44" strength="38" fitness="60" creativity="65"/>		
			</player>
			<player id="Clint Dempsey" name="Clint Dempsey" birthday="09-03-1983" positions="am-cm-cf" nationality="us" number="23">
				<stats passing="65" tackling="47" shooting="64" crossing="70" heading="58" dribbling="68" speed="59" stamina="75" aggression="60" strength="60" fitness="70" creativity="60"/>	
			</player>
			<player id="Pascal Zuberbuhler" name="Pascal Zuberbuhler" birthday="08-01-1971" positions="gk" nationality="sz" number="19">
				<stats catching="70" shotStopping="70" distribution="45" fitness="60" stamina="35"/>		
			</player>
			<player id="Diomansy Kamara" name="Diomansy Kamara" birthday="08-11-1980" positions="am-cf-wf" nationality="se" number="15">
				<stats passing="45" tackling="20" shooting="54" crossing="59" heading="40" dribbling="75" speed="80" stamina="64" aggression="30" strength="60" fitness="75" creativity="49"/>		
			</player>
			<player id="Danny Murphy" name="Danny Murphy" birthday="18-03-1977" positions="cm-am" nationality="en" number="13">
				<stats passing="80" tackling="58" shooting="67" crossing="70" heading="44" dribbling="54" speed="44" stamina="70" aggression="52" strength="75" fitness="75" creativity="86"/>		
			</player>
			<player id="Moussa Dembele" name="Moussa Dembele" birthday="17-07-1987" positions="cf-am" nationality="be" number="30">
				<stats passing="59" tackling="12" shooting="43" crossing="60" heading="63" dribbling="73" speed="70" stamina="67" aggression="58" strength="75" fitness="66" creativity="70"/>		
			</player>
			<player id="Andy Johnson" name="Andy Johnson" birthday="10-02-1981" positions="cf" nationality="en" number="8">
				<stats passing="65" tackling="16" shooting="71" crossing="58" heading="54" dribbling="50" speed="75" stamina="80" aggression="60" strength="29" fitness="73" creativity="48"/>		
			</player>
			<player id="Bobby Zamora" name="Bobby Zamora" birthday="16-01-1981" positions="cf" nationality="en" number="25">
				<stats passing="70" tackling="34" shooting="68" crossing="49" heading="76" dribbling="70" speed="65" stamina="75" aggression="53" strength="75" fitness="67" creativity="68"/>		
			</player>
			<player id="David Elm" name="David Elm" birthday="10-01-1983" positions="cf" nationality="sw" number="35">
				<stats passing="63" tackling="54" shooting="60" crossing="36" heading="77" dribbling="53" speed="55" stamina="70" aggression="44" strength="78" fitness="68" creativity="45"/>		
			</player>
			<player id="David Stockdale" name="David Stockdale" birthday="20-09-1985" positions="gk" nationality="en" number="12">
				<stats catching="56" shotStopping="72" distribution="79" fitness="62" stamina="58"/>		
			</player>
		</players>
	</club>
	<club shirtColor="0xFF0000" sleevesColor="0xFF0000" stripesType="none" scoreMultiplier="1" attackScore="C" defendScore="A">
		<name><![CDATA[Liverpool]]></name>
		<profile>90</profile>
		<players>
			<player id="Brad Jones" name="Brad Jones" birthday="19-03-1982" positions="gk" nationality="au" number="27">
				<stats catching="64" shotStopping="62" distribution="70" fitness="39" stamina="68"/>
			</player>
			<player id="Jamie Carragher" name="Jamie Carragher" birthday="28-01-1978" positions="cb-fb" nationality="en" number="23">
				<stats passing="54" tackling="78" shooting="7" crossing="32" heading="79" dribbling="23" speed="51" stamina="74" aggression="73" strength="88" fitness="95" creativity="34"/>	
			</player>	
			<player id="Glenn Johnson" name="Glenn Johnson" birthday="23-08-1984" positions="fb" nationality="en" number="2">
				<stats passing="64" tackling="68" shooting="54" crossing="75" heading="58" dribbling="65" speed="75" stamina="85" aggression="54" strength="75" fitness="85" creativity="65"/>
			</player>
			<player id="Sotiris Kyrgiakos" name="Sotiris Kyrgiakos" birthday="23-07-1979" positions="cb" nationality="gr" number="16">
				<stats passing="39" tackling="83" shooting="38" crossing="28" heading="78" dribbling="16" speed="58" stamina="64" aggression="85" strength="90" fitness="74" creativity="34"/>
			</player>
			<player id="Daniel Agger" name="Daniel Agger" birthday="12-12-1984" positions="cb" nationality="dn" number="5">
				<stats passing="74" tackling="75" shooting="58" crossing="43" heading="75" dribbling="48" speed="68" stamina="74" aggression="63" strength="61" fitness="47" creativity="58"/>				
			</player>
			<player id="Martin Skrtel" name="Martin Skrtel" birthday="15-12-1984" positions="cb" nationality="sk" number="37">
				<stats passing="58" tackling="89" shooting="23" crossing="42" heading="78" dribbling="33" speed="68" stamina="78" aggression="79" strength="80" fitness="72" creativity="52"/>				
			</player>
			<player id="Paul Konchesky" name="Paul Konchesky" birthday="15-05-1981" positions="fb" nationality="en" number="3">
				<stats passing="64" tackling="69" shooting="52" crossing="69" heading="55" dribbling="63" speed="70" stamina="75" aggression="72" strength="64" fitness="75" creativity="53"/>
			</player>
			<player id="Fabio Aurelio" name="Fabio Aurelio" birthday="24-09-1979" positions="fb" nationality="br" number="6">
				<stats passing="79" tackling="57" shooting="63" crossing="75" heading="51" dribbling="58" speed="63" stamina="68" aggression="40" strength="56" fitness="44" creativity="75"/>
			</player>
			<player id="Christian Poulsen" name="Christian Poulsen" birthday="28-02-1980" positions="dm-cm" nationality="dn" number="28">
				<stats passing="68" tackling="76" shooting="53" crossing="52" heading="65" dribbling="37" speed="52" stamina="80" aggression="82" strength="70" fitness="75" creativity="45"/>
			</player>
			<player id="Lucas" name="Lucas" birthday="09-01-1987" positions="dm-cm" nationality="br" number="21">
				<stats passing="67" tackling="79" shooting="38" crossing="58" heading="39" dribbling="63" speed="69" stamina="82" aggression="54" strength="69" fitness="74" creativity="67"/>	
			</player>
			<player id="Raul Meireles" name="Raul Meireles" birthday="17-03-1983" positions="cm" nationality="pr" number="4">
				<stats passing="73" tackling="67" shooting="66" crossing="67" heading="58" dribbling="48" speed="59" stamina="83" aggression="74" strength="52" fitness="58" creativity="64"/>	
			</player>
			<player id="Joe Cole" name="Joe Cole" birthday="08-11-1981" positions="am-cm" nationality="en" number="10">
				<stats passing="66" tackling="60" shooting="68" crossing="60" heading="25" dribbling="70" speed="70" stamina="55" aggression="70" strength="55" fitness="75" creativity="73"/>
			</player>
			<player id="Steven Gerrard" name="Steven Gerrard" birthday="30-05-1980" positions="am-cm" nationality="en" number="8">
				<stats passing="82" tackling="76" shooting="83" crossing="77" heading="55" dribbling="65" speed="75" stamina="91" aggression="90" strength="80" fitness="79" creativity="68"/>	
			</player>
			<player id="Maxi Rodriguez" name="Maxi Rodriguez" birthday="02-01-1981" positions="am" nationality="ar" number="17">
				<stats passing="70" tackling="45" shooting="67" crossing="66" heading="58" dribbling="64" speed="59" stamina="78" aggression="62" strength="67" fitness="77" creativity="58"/>		
			</player>
			<player id="Dirk Kuyt" name="Dirk Kuyt" birthday="22-07-1980" positions="am-cf" nationality="ne" number="18">
				<stats passing="62" tackling="54" shooting="48" crossing="54" heading="68" dribbling="54" speed="59" stamina="98" aggression="60" strength="74" fitness="97" creativity="60"/>		
			</player>
			<player id="Ryan Babel" name="Ryan Babel" birthday="19-12-1986" positions="cf-am" nationality="ne" number="19">
				<stats passing="63" tackling="25" shooting="73" crossing="64" heading="39" dribbling="64" speed="85" stamina="69" aggression="12" strength="74" fitness="80" creativity="64"/>		
			</player>
			<player id="Fernando Torres" name="Fernando Torres" birthday="20-03-1984" positions="cf" nationality="es" number="9">
				<stats passing="68" tackling="51" shooting="84" crossing="58" heading="75" dribbling="85" speed="85" stamina="68" aggression="68" strength="68" fitness="60" creativity="68"/>	
			</player>
			<player id="Charles Itandje" name="Charles Itandje" birthday="02-11-1982" positions="gk" nationality="fr" number="30">
				<stats catching="50" shotStopping="58" distribution="57" fitness="63" stamina="38"/>		
			</player>
			<player id="David N'Gog" name="David N'Gog" birthday="01-04-1989" positions="cf" nationality="fr" number="24">
				<stats passing="44" tackling="14" shooting="65" crossing="41" heading="68" dribbling="59" speed="84" stamina="64" aggression="36" strength="59" fitness="44" creativity="45"/>		
			</player>
			<player id="Jose Manuel Reina" name="Jose Manuel Reina" birthday="31-08-1982" positions="gk" nationality="es" number="25">
				<stats catching="80" shotStopping="90" distribution="89" fitness="60" stamina="75"/>		
			</player>
		</players>
	</club>
	<club shirtColor="0x8899FF" sleevesColor="0x8899FF" stripesType="none" scoreMultiplier="1" attackScore="C" defendScore="A">
		<name><![CDATA[Manchester City]]></name>
		<profile>75</profile>
		<players>
			<player id="David Gonzalez" name="David Gonzalez" birthday="20-07-1982" positions="gk" nationality="co" number="26">
				<stats catching="66" shotStopping="62" distribution="61" fitness="58" stamina="61"/>
			</player>
			<player id="Micah Richards" name="Micah Richards" birthday="24-06-1988" positions="fb-cb" nationality="en" number="2">
				<stats passing="33" tackling="74" shooting="24" crossing="28" heading="74" dribbling="40" speed="89" stamina="94" aggression="75" strength="88" fitness="84" creativity="29"/>	
			</player>	
			<player id="Kolo Toure" name="Kolo Toure" birthday="19-03-1981" positions="cb-fb" nationality="iv" number="28">
				<stats passing="57" tackling="75" shooting="52" crossing="54" heading="75" dribbling="54" speed="75" stamina="75" aggression="69" strength="75" fitness="62" creativity="59"/>
			</player>
			<player id="Jerome Boateng" name="Jerome Boateng" birthday="03-09-1988" positions="cb-fb" nationality="ge" number="17">
				<stats passing="63" tackling="60" shooting="34" crossing="75" heading="39" dribbling="54" speed="90" stamina="58" aggression="29" strength="84" fitness="53" creativity="75"/>
			</player>
			<player id="Wayne Bridge" name="Wayne Bridge" birthday="05-08-1980" positions="fb" nationality="en" number="3">
				<stats passing="53" tackling="58" shooting="50" crossing="68" heading="53" dribbling="52" speed="69" stamina="79" aggression="57" strength="62" fitness="74" creativity="60"/>				
			</player>
			<player id="Joleon Lescott" name="Joleon Lescott" birthday="16-08-1982" positions="cb" nationality="en" number="19">
				<stats passing="44" tackling="75" shooting="14" crossing="44" heading="85" dribbling="44" speed="70" stamina="75" aggression="64" strength="85" fitness="70" creativity="30"/>				
			</player>
			<player id="Vincent Kompany" name="Vincent Kompany" birthday="10-04-1986" positions="cb-dm-cm" nationality="be" number="4">
				<stats passing="59" tackling="77" shooting="37" crossing="24" heading="73" dribbling="44" speed="64" stamina="75" aggression="68" strength="79" fitness="28" creativity="59"/>
			</player>
			<player id="Pablo Zabaleta" name="Pablo Zabaleta" birthday="16-01-1985" positions="fb-sm-cm" nationality="ar" number="5">
				<stats passing="60" tackling="64" shooting="54" crossing="63" heading="54" dribbling="54" speed="69" stamina="79" aggression="83" strength="59" fitness="75" creativity="59"/>
			</player>
			<player id="Aleksandar Kolarov" name="Aleksandar Kolarov" birthday="10-11-1985" positions="fb" nationality="se" number="13">
				<stats passing="68" tackling="74" shooting="64" crossing="75" heading="53" dribbling="64" speed="75" stamina="70" aggression="68" strength="75" fitness="59" creativity="59"/>
			</player>
			<player id="Gareth Barry" name="Gareth Barry" birthday="23-02-1981" positions="cm-dm-sm" nationality="en" number="18">
				<stats passing="69" tackling="74" shooting="53" crossing="75" heading="64" dribbling="44" speed="55" stamina="75" aggression="59" strength="69" fitness="75" creativity="75"/>	
			</player>
			<player id="Yaya Toure" name="Yaya Toure" birthday="13-05-1983" positions="dm-cm" nationality="iv" number="42">
				<stats passing="80" tackling="70" shooting="64" crossing="54" heading="75" dribbling="63" speed="69" stamina="84" aggression="58" strength="85" fitness="74" creativity="75"/>	
			</player>
			<player id="Nigel de Jong" name="Nigel de Jong" birthday="30-11-1984" positions="dm-cm" nationality="ne" number="34">
				<stats passing="59" tackling="85" shooting="25" crossing="53" heading="74" dribbling="53" speed="64" stamina="90" aggression="98" strength="84" fitness="75" creativity="58"/>
			</player>
			<player id="Patrick Vieira" name="Patrick Vieira" birthday="23-06-1976" positions="dm-cm" nationality="fr" number="24">
				<stats passing="78" tackling="89" shooting="43" crossing="39" heading="88" dribbling="55" speed="39" stamina="82" aggression="86" strength="90" fitness="45" creativity="68"/>	
			</player>
			<player id="James Milner" name="James Milner" birthday="04-01-1986" positions="cm-am-sm" nationality="en" number="7">
				<stats passing="68" tackling="56" shooting="63" crossing="70" heading="43" dribbling="58" speed="59" stamina="88" aggression="59" strength="53" fitness="89" creativity="70"/>		
			</player>
			<player id="Michael Johnson" name="Michael Johnson" birthday="24-02-1988" positions="cm" nationality="en" number="6">
				<stats passing="64" tackling="55" shooting="55" crossing="57" heading="28" dribbling="59" speed="65" stamina="69" aggression="48" strength="55" fitness="25" creativity="68"/>		
			</player>
			<player id="Shaun Wright-Phillips" name="Shaun Wright-Phillips" birthday="25-10-1981" positions="sm" nationality="en" number="8">
				<stats passing="55" tackling="52" shooting="62" crossing="55" heading="39" dribbling="75" speed="84" stamina="78" aggression="54" strength="25" fitness="81" creativity="55"/>		
			</player>
			<player id="Adam Johnson" name="Adam Johnson" birthday="14-07-1987" positions="sm-am" nationality="en" number="11">
				<stats passing="64" tackling="39" shooting="59" crossing="69" heading="28" dribbling="78" speed="75" stamina="68" aggression="29" strength="44" fitness="59" creativity="60"/>	
			</player>
			<player id="Shay Given" name="Shay Given" birthday="20-04-1976" positions="gk" nationality="ir" number="1">
				<stats catching="84" shotStopping="94" distribution="68" fitness="65" stamina="70"/>		
			</player>
			<player id="David Silva" name="David Silva" birthday="08-01-1986" positions="sm-cm-am" nationality="es" number="21">
				<stats passing="90" tackling="42" shooting="62" crossing="79" heading="38" dribbling="90" speed="63" stamina="59" aggression="48" strength="32" fitness="59" creativity="93"/>		
			</player>
			<player id="Mario Balotelli" name="Mario Balotelli" birthday="12-08-1990" positions="cf-wf" nationality="it" number="45">
				<stats passing="66" tackling="31" shooting="76" crossing="78" heading="53" dribbling="78" speed="79" stamina="64" aggression="59" strength="74" fitness="70" creativity="73"/>		
			</player>
			<player id="Kelvin Etuhu" name="Kelvin Etuhu" birthday="30-05-1988" positions="sm-cf-wf" nationality="ng" number="29">
				<stats passing="52" tackling="29" shooting="44" crossing="43" heading="36" dribbling="64" speed="75" stamina="70" aggression="62" strength="70" fitness="61" creativity="38"/>		
			</player>
			<player id="Emmanuel Adebayor" name="Emmanuel Adebayor" birthday="26-02-1984" positions="cf" nationality="to" number="9">
				<stats passing="59" tackling="17" shooting="81" crossing="24" heading="80" dribbling="74" speed="79" stamina="80" aggression="68" strength="89" fitness="75" creativity="49"/>		
			</player>
			<player id="Carlos Tevez" name="Carlos Tevez" birthday="05-02-1984" positions="cf-am" nationality="ar" number="32">
				<stats passing="70" tackling="51" shooting="71" crossing="68" heading="55" dribbling="80" speed="64" stamina="88" aggression="73" strength="79" fitness="78" creativity="75"/>		
			</player>
			<player id="Roque Santa Cruz" name="Roque Santa Cruz" birthday="16-08-1981" positions="cf" nationality="pa" number="14">
				<stats passing="54" tackling="18" shooting="65" crossing="44" heading="78" dribbling="49" speed="58" stamina="60" aggression="52" strength="77" fitness="51" creativity="69"/>		
			</player>
			<player id="Jo" name="Jo" birthday="20-03-1987" positions="cf" nationality="br" number="27">
				<stats passing="63" tackling="28" shooting="68" crossing="43" heading="72" dribbling="66" speed="63" stamina="60" aggression="48" strength="58" fitness="74" creativity="58"/>		
			</player>
			<player id="Joe Hart" name="Joe Hart" birthday="19-04-1987" positions="gk" nationality="en" number="25">
				<stats catching="75" shotStopping="84" distribution="70" fitness="63" stamina="75"/>		
			</player>
		</players>
	</club>
	<club shirtColor="0xEE0000" sleevesColor="0xEE0000" stripesType="none" scoreMultiplier="1" attackScore="A" defendScore="A">
		<name><![CDATA[Manchester United]]></name>
		<profile>95</profile>
		<players>
			<player id="Edwin van der Sar" name="Edwin van der Sar" birthday="29-10-1970" positions="gk" nationality="ne" number="1" progressType="sin3">
				<stats catching="84" shotStopping="74" distribution="85" fitness="52" stamina="59"/>
			</player>
			<player id="John O' Shea" name="John O' Shea" birthday="30-04-1981" positions="fb-cb" nationality="ir" number="22">
				<stats passing="51" tackling="68" shooting="24" crossing="53" heading="78" dribbling="34" speed="59" stamina="71" aggression="41" strength="78" fitness="63" creativity="34"/>	
			</player>	
			<player id="Wes Brown" name="Wes Brown" birthday="13-10-1979" positions="cb-fb" nationality="en" number="6">
				<stats passing="43" tackling="74" shooting="3" crossing="52" heading="83" dribbling="32" speed="68" stamina="79" aggression="78" strength="76" fitness="68" creativity="22"/>
			</player>
			<player id="Rio Ferdinand" name="Rio Ferdinand" birthday="07-11-1978" positions="cb" nationality="en" number="5">
				<stats passing="71" tackling="84" shooting="17" crossing="23" heading="81" dribbling="48" speed="79" stamina="69" aggression="66" strength="77" fitness="49" creativity="44"/>
			</player>
			<player id="Jonny Evans" name="Jonny Evans" birthday="03-01-1988" positions="cb" nationality="ni" number="23">
				<stats passing="62" tackling="74" shooting="32" crossing="24" heading="76" dribbling="32" speed="58" stamina="69" aggression="58" strength="69" fitness="74" creativity="38"/>				
			</player>
			<player id="Nemanja Vidic" name="Nemanja Vidic" birthday="21-10-1981" positions="cb" nationality="se" number="15">
				<stats passing="54" tackling="88" shooting="26" crossing="12" heading="95" dribbling="17" speed="68" stamina="79" aggression="88" strength="89" fitness="77" creativity="31"/>				
			</player>
			<player id="Fabio" name="Fabio" birthday="09-07-1990" positions="fb" nationality="br" number="20">
				<stats passing="52" tackling="54" shooting="54" crossing="62" heading="48" dribbling="64" speed="83" stamina="49" aggression="62" strength="41" fitness="68" creativity="37"/>
			</player>
			<player id="Patrice Evra" name="Patrice Evra" birthday="15-05-1981" positions="fb" nationality="fr" number="3">
				<stats passing="61" tackling="81" shooting="23" crossing="64" heading="69" dribbling="73" speed="88" stamina="89" aggression="74" strength="67" fitness="82" creativity="34"/>
			</player>
			<player id="Michael Carrick" name="Michael Carrick" birthday="28-07-1981" positions="cm-dm" nationality="en" number="16">
				<stats passing="87" tackling="64" shooting="58" crossing="52" heading="51" dribbling="32" speed="59" stamina="72" aggression="29" strength="62" fitness="71" creativity="77"/>
			</player>
			<player id="Owen Hargreaves" name="Owen Hargreaves" birthday="20-01-1981" positions="dm-cm" nationality="en" number="4">
				<stats passing="75" tackling="81" shooting="53" crossing="83" heading="37" dribbling="47" speed="75" stamina="88" aggression="83" strength="74" fitness="64" creativity="57"/>	
			</player>
			<player id="Darren Fletcher" name="Darren Fletcher" birthday="01-02-1984" positions="dm-cm" nationality="sc" number="24">
				<stats passing="73" tackling="85" shooting="42" crossing="74" heading="74" dribbling="42" speed="69" stamina="98" aggression="83" strength="75" fitness="82" creativity="60"/>	
			</player>
			<player id="Anderson" name="Anderson" birthday="13-04-1988" positions="cm" nationality="br" number="8">
				<stats passing="74" tackling="58" shooting="17" crossing="63" heading="34" dribbling="64" speed="79" stamina="84" aggression="69" strength="80" fitness="78" creativity="70"/>
			</player>
			<player id="Paul Scholes" name="Paul Scholes" birthday="16-11-1974" positions="am-cm" nationality="en" number="18" progressType="sin3">
				<stats passing="93" tackling="34" shooting="78" crossing="59" heading="76" dribbling="64" speed="41" stamina="48" aggression="68" strength="39" fitness="49" creativity="92"/>	
			</player>
			<player id="Darron Gibson" name="Darron Gibson" birthday="25-10-1987" positions="cm" nationality="ir" number="28">
				<stats passing="68" tackling="62" shooting="66" crossing="47" heading="39" dribbling="40" speed="59" stamina="75" aggression="64" strength="69" fitness="78" creativity="64"/>		
			</player>
			<player id="Nani" name="Nani" birthday="17-11-1986" positions="sm-am" nationality="pr" number="17">
				<stats passing="73" tackling="32" shooting="74" crossing="84" heading="29" dribbling="84" speed="83" stamina="63" aggression="53" strength="65" fitness="74" creativity="74"/>		
			</player>
			<player id="Antonio Valencia" name="Antonia Valencia" birthday="05-08-1985" positions="sm" nationality="ec" number="25">
				<stats passing="72" tackling="39" shooting="64" crossing="83" heading="33" dribbling="76" speed="89" stamina="84" aggression="49" strength="69" fitness="70" creativity="64"/>		
			</player>
			<player id="Ryan Giggs" name="Ryan Giggs" birthday="29-11-1973" positions="sm-cm-am" nationality="we" number="11" progressType="sin4" ageImprovement="30">
				<stats passing="81" tackling="52" shooting="58" crossing="76" heading="38" dribbling="84" speed="66" stamina="59" aggression="50" strength="57" fitness="56" creativity="84"/>	
			</player>
			<player id="Tomasz Kuszczak" name="Tomasz Kuszczak" birthday="20-03-1982" positions="gk" nationality="po" number="29">
				<stats catching="74" shotStopping="83" distribution="54" fitness="74" stamina="58"/>		
			</player>
			<player id="Dimitar Berbatov" name="Dimitar Berbatov" birthday="30-01-1981" positions="cf" nationality="bu" number="9">
				<stats passing="79" tackling="12" shooting="85" crossing="58" heading="78" dribbling="75" speed="59" stamina="68" aggression="43" strength="68" fitness="69" creativity="85"/>		
			</player>
			<player id="Michael Owen" name="Michael Owen" birthday="14-12-1979" positions="cf" nationality="en" number="7">
				<stats passing="58" tackling="34" shooting="82" crossing="58" heading="76" dribbling="54" speed="65" stamina="70" aggression="48" strength="50" fitness="51" creativity="53"/>		
			</player>
			<player id="Javier Hernandez" name="Javier Hernandez" birthday="01-06-1988" positions="cf" nationality="me" number="14">
				<stats passing="59" tackling="25" shooting="74" crossing="44" heading="78" dribbling="55" speed="77" stamina="68" aggression="50" strength="34" fitness="73" creativity="57"/>		
			</player>
			<player id="Wayne Rooney" name="Wayne Rooney" birthday="24-10-1985" positions="cf" nationality="en" number="10">
				<stats passing="79" tackling="39" shooting="84" crossing="78" heading="75" dribbling="68" speed="78" stamina="91" aggression="85" strength="83" fitness="82" creativity="84"/>		
			</player>
			<player id="Federico Macheda" name="Federico Macheda" birthday="22-08-1991" positions="cf" nationality="it" number="27">
				<stats passing="58" tackling="11" shooting="68" crossing="32" heading="56" dribbling="53" speed="69" stamina="46" aggression="38" strength="63" fitness="66" creativity="52"/>		
			</player>
			<player id="Park Ji-Sung" name="Park Ji-Sung" birthday="25-02-1981" positions="sm" nationality="ko" number="13">
				<stats passing="64" tackling="62" shooting="38" crossing="64" heading="39" dribbling="62" speed="68" stamina="99" aggression="51" strength="45" fitness="88" creativity="59"/>		
			</player>
			<player id="Ben Amos" name="Ben Amos" birthday="10-04-1990" positions="gk" nationality="en" number="40">
				<stats catching="64" shotStopping="66" distribution="42" fitness="71" stamina="39"/>		
			</player>
		</players>
	</club>
	
	<club shirtColor="0xFFFFFF" sleevesColor="0xFFFFFF" stripesType="vertical" stripesColor="0x000000" scoreMultiplier="3" attackScore="E" defendScore="D">
		<name><![CDATA[Newcastle United]]></name>
		<profile>75</profile>
		<players>
			<player id="Tim Krul" name="Tim Krul" birthday="03-04-1988" positions="gk" nationality="ne" number="26">
				<stats catching="59" shotStopping="77" distribution="61" fitness="55" stamina="71"/>
			</player>
			<player id="Steven Taylor" name="Steven Taylor" birthday="23-01-1986" positions="cb-fb" nationality="en" number="27">
				<stats passing="51" tackling="74" shooting="33" crossing="38" heading="78" dribbling="42" speed="74" stamina="75" aggression="82" strength="78" fitness="54" creativity="37"/>	
			</player>	
			<player id="Danny Simpson" name="Danny Simpson" birthday="04-01-1987" positions="fb" nationality="en" number="12">
				<stats passing="51" tackling="68" shooting="23" crossing="54" heading="37" dribbling="54" speed="83" stamina="79" aggression="49" strength="47" fitness="68" creativity="38"/>
			</player>
			<player id="Dan Gosling" name="Dan Gosling" birthday="01-02-1990" positions="dm-cm" nationality="en" number="15">
				<stats passing="63" tackling="49" shooting="44" crossing="43" heading="52" dribbling="64" speed="53" stamina="68" aggression="44" strength="51" fitness="74" creativity="65"/>
			</player>
			<player id="Tamas Kadar" name="Tamas Kadar" birthday="14-03-1990" positions="cb-fb" nationality="hu" number="28">
				<stats passing="37" tackling="68" shooting="34" crossing="39" heading="53" dribbling="51" speed="58" stamina="64" aggression="78" strength="63" fitness="49" creativity="37"/>				
			</player>
			<player id="Sol Campbell" name="Sol Campbell" birthday="18-09-1974" positions="cb" nationality="en" number="5" progressType="sin2">
				<stats passing="47" tackling="79" shooting="33" crossing="17" heading="84" dribbling="34" speed="55" stamina="45" aggression="65" strength="85" fitness="29" creativity="37"/>				
			</player>
			<player id="Fabricio Coloccini" name="Fabricio Coloccini" birthday="22-01-1982" positions="cb" nationality="ar" number="2">
				<stats passing="56" tackling="78" shooting="34" crossing="39" heading="72" dribbling="43" speed="59" stamina="88" aggression="64" strength="75" fitness="69" creativity="50"/>
			</player>
			<player id="Mike Williamson" name="Mike Williamson" birthday="08-11-1983" positions="cb" nationality="en" number="6">
				<stats passing="43" tackling="68" shooting="22" crossing="32" heading="73" dribbling="28" speed="54" stamina="57" aggression="58" strength="75" fitness="68" creativity="38"/>
			</player>
			<player id="Jose Enrique" name="Jose Enrique" birthday="23-01-1986" positions="fb" nationality="es" number="3">
				<stats passing="52" tackling="73" shooting="34" crossing="65" heading="64" dribbling="59" speed="78" stamina="79" aggression="68" strength="79" fitness="75" creativity="53"/>
			</player>
			<player id="Ryan Taylor" name="Ryan Taylor" birthday="19-08-1984" positions="fb" nationality="en" number="16">
				<stats passing="59" tackling="58" shooting="64" crossing="69" heading="29" dribbling="48" speed="63" stamina="75" aggression="48" strength="49" fitness="64" creativity="48"/>	
			</player>
			<player id="Alan Smith" name="Alan Smith" birthday="28-10-1980" positions="am-dm-cf" nationality="en" number="17">
				<stats passing="60" tackling="64" shooting="56" crossing="54" heading="78" dribbling="44" speed="44" stamina="85" aggression="91" strength="75" fitness="75" creativity="52"/>	
			</player>
			<player id="Cheick Tiote" name="Chieck Tiote" birthday="21-06-1986" positions="dm-cm" nationality="iv" number="24">
				<stats passing="58" tackling="53" shooting="37" crossing="54" heading="64" dribbling="65" speed="59" stamina="65" aggression="83" strength="75" fitness="70" creativity="59"/>
			</player>
			<player id="Joey Barton" name="Joey Barton" birthday="02-09-1982" positions="cm" nationality="en" number="7">
				<stats passing="70" tackling="75" shooting="53" crossing="59" heading="52" dribbling="53" speed="54" stamina="75" aggression="93" strength="64" fitness="43" creativity="70"/>	
			</player>
			<player id="Danny Guthrie" name="Danny Guthrie" birthday="18-04-1987" positions="cm" nationality="en" number="8">
				<stats passing="74" tackling="58" shooting="45" crossing="58" heading="42" dribbling="59" speed="54" stamina="67" aggression="54" strength="54" fitness="54" creativity="70"/>		
			</player>
			<player id="Hatem Ben Arfa" name="Hatem Ben Arfa" birthday="07-03-1987" positions="am-sm" nationality="fr" number="37">
				<stats passing="68" tackling="12" shooting="54" crossing="58" heading="34" dribbling="78" speed="71" stamina="64" aggression="39" strength="44" fitness="69" creativity="75"/>		
			</player>
			<player id="Jonas" name="Jonas" birthday="05-07-1993" positions="sm" nationality="ar" number="18">
				<stats passing="52" tackling="44" shooting="46" crossing="37" heading="47" dribbling="77" speed="88" stamina="75" aggression="65" strength="56" fitness="75" creativity="44"/>		
			</player>
			<player id="Wayne Routledge" name="Wayne Routledge" birthday="07-01-1985" positions="sm" nationality="en" number="10">
				<stats passing="33" tackling="19" shooting="54" crossing="58" heading="22" dribbling="59" speed="70" stamina="58" aggression="54" strength="59" fitness="90" creativity="54"/>	
			</player>
			<player id="Steve Harper" name="Steve Harper" birthday="14-03-1975" positions="gk" nationality="en" number="1">
				<stats catching="74" shotStopping="64" distribution="69" fitness="45" stamina="70"/>		
			</player>
			<player id="Kevin Nolan" name="Kevin Nolan" birthday="24-06-1982" positions="cm-am" nationality="en" number="4">
				<stats passing="60" tackling="55" shooting="65" crossing="65" heading="84" dribbling="54" speed="65" stamina="44" aggression="75" strength="85" fitness="38" creativity="55"/>		
			</player>
			<player id="Peter Lovenkrands" name="Peter Lovenkrands" birthday="29-01-1980" positions="sm-cf" nationality="de" number="11">
				<stats passing="54" tackling="8" shooting="59" crossing="37" heading="39" dribbling="54" speed="74" stamina="85" aggression="17" strength="37" fitness="85" creativity="58"/>		
			</player>
			<player id="Xisco" name="Xisco" birthday="26-06-1986" positions="cf" nationality="es" number="19">
				<stats passing="57" tackling="27" shooting="63" crossing="43" heading="74" dribbling="58" speed="59" stamina="68" aggression="60" strength="67" fitness="70" creativity="56"/>		
			</player>
			<player id="Shola Ameobi" name="Shola Ameobi" birthday="12-10-1981" positions="cf" nationality="en" number="23">
				<stats passing="49" tackling="23" shooting="57" crossing="52" heading="68" dribbling="56" speed="64" stamina="66" aggression="34" strength="75" fitness="64" creativity="48"/>		
			</player>
			<player id="Leon Best" name="Leon Best" birthday="19-09-1986" positions="cf" nationality="ir" number="20">
				<stats passing="53" tackling="34" shooting="51" crossing="56" heading="64" dribbling="64" speed="74" stamina="47" aggression="43" strength="74" fitness="72" creativity="43"/>		
			</player>
			<player id="Andy Carroll" name="Andy Carroll" birthday="06-01-1989" positions="cf" nationality="en" number="9">
				<stats passing="58" tackling="38" shooting="63" crossing="54" heading="87" dribbling="44" speed="65" stamina="60" aggression="78" strength="90" fitness="54" creativity="55"/>		
			</player>
			<player id="Ole Soderberg" name="Ole Soderberg" birthday="20-07-1990" positions="gk" nationality="sw" number="33">
				<stats catching="58" shotStopping="66" distribution="56" fitness="63" stamina="53"/>		
			</player>
		</players>
	</club>
	<club shirtColor="0xFFFFFF" sleevesColor="0xFF0000" stripesType="vertical" stripesColor="0xFF0000" scoreMultiplier="3" attackScore="E" defendScore="C">
		<name><![CDATA[Stoke City]]></name>
		<profile>40</profile>
		<players>
			<player id="Thomas Sorensen" name="Thomas Sorensen" birthday="12-06-1976" positions="gk" nationality="de" number="29">
				<stats catching="68" shotStopping="73" distribution="69" fitness="74" stamina="58"/>
			</player>
			<player id="Andy Wilkinson" name="Andy Wilkinson" birthday="06-08-1984" positions="cb-fb" nationality="en" number="28">
				<stats passing="53" tackling="66" shooting="35" crossing="41" heading="67" dribbling="39" speed="62" stamina="75" aggression="84" strength="77" fitness="69" creativity="37"/>	
			</player>	
			<player id="Ryan Shotton" name="Ryan Shotton" birthday="30-09-1988" positions="cb-fb" nationality="en" number="30">
				<stats passing="32" tackling="68" shooting="37" crossing="54" heading="64" dribbling="48" speed="55" stamina="58" aggression="69" strength="70" fitness="60" creativity="37"/>
			</player>
			<player id="Danny Higginbotham" name="Danny Higginbotham" birthday="29-12-1978" positions="cb-fb" nationality="en" number="3">
				<stats passing="44" tackling="73" shooting="29" crossing="52" heading="70" dribbling="43" speed="58" stamina="68" aggression="70" strength="57" fitness="75" creativity="39"/>
			</player>
			<player id="Danny Collins" name="Danny Collins" birthday="06-08-1980" positions="cb-fb" nationality="we" number="5">
				<stats passing="63" tackling="78" shooting="32" crossing="64" heading="84" dribbling="54" speed="36" stamina="74" aggression="59" strength="62" fitness="70" creativity="54"/>				
			</player>
			<player id="Danny Pugh" name="Danny Pugh" birthday="19-10-1982" positions="fb-sm" nationality="en" number="14">
				<stats passing="59" tackling="52" shooting="54" crossing="64" heading="34" dribbling="51" speed="60" stamina="64" aggression="39" strength="38" fitness="68" creativity="60"/>				
			</player>
			<player id="Robert Huth" name="Robert Huth" birthday="18-08-1984" positions="cb" nationality="ge" number="4">
				<stats passing="44" tackling="76" shooting="49" crossing="32" heading="79" dribbling="26" speed="63" stamina="67" aggression="69" strength="94" fitness="74" creativity="27"/>
			</player>
			<player id="Ryan Shawcross" name="Ryan Shawcross" birthday="04-10-1987" positions="cb" nationality="en" number="17">
				<stats passing="64" tackling="73" shooting="15" crossing="34" heading="79" dribbling="33" speed="59" stamina="75" aggression="62" strength="74" fitness="75" creativity="24"/>
			</player>
			<player id="Abdoulaye Faye" name="Abdoulaye Faye" birthday="26-02-1978" positions="cb-dm-cm" nationality="sn" number="25">
				<stats passing="61" tackling="72" shooting="43" crossing="39" heading="74" dribbling="38" speed="59" stamina="68" aggression="65" strength="75" fitness="62" creativity="54"/>
			</player>
			<player id="Marc Wilson" name="Marc Wilson" birthday="17-08-1987" positions="cm-cb-dm" nationality="ir" number="12">
				<stats passing="73" tackling="50" shooting="39" crossing="74" heading="58" dribbling="55" speed="56" stamina="69" aggression="66" strength="64" fitness="70" creativity="64"/>	
			</player>
			<player id="Salif Diao" name="Salif Diao" birthday="10-02-1977" positions="dm-cm" nationality="sn" number="15">
				<stats passing="58" tackling="70" shooting="34" crossing="44" heading="78" dribbling="39" speed="55" stamina="74" aggression="78" strength="79" fitness="60" creativity="54"/>	
			</player>
			<player id="Rory Delap" name="Rory Delap" birthday="06-07-1976" positions="cm-sm-cb-cf" nationality="ir" number="24">
				<stats passing="54" tackling="64" shooting="54" crossing="64" heading="65" dribbling="53" speed="59" stamina="84" aggression="70" strength="70" fitness="84" creativity="59"/>
			</player>
			<player id="Michael Tonge" name="Michael Tonge" birthday="07-04-1983" positions="cm-sm" nationality="en" number="23">
				<stats passing="68" tackling="40" shooting="57" crossing="70" heading="39" dribbling="70" speed="49" stamina="60" aggression="56" strength="59" fitness="59" creativity="70"/>	
			</player>
			<player id="Jonathan Walters" name="Jonathan Walters" birthday="20-09-1983" positions="cf-wf-sm" nationality="ir" number="19">
				<stats passing="59" tackling="56" shooting="58" crossing="65" heading="79" dribbling="64" speed="58" stamina="60" aggression="74" strength="80" fitness="75" creativity="65"/>		
			</player>
			<player id="Dean Whitehead" name="Dean Whitehead" birthday="12-01-1982" positions="cm" nationality="en" number="18">
				<stats passing="70" tackling="70" shooting="42" crossing="59" heading="44" dribbling="51" speed="61" stamina="79" aggression="64" strength="59" fitness="79" creativity="50"/>		
			</player>
			<player id="Glenn Whelan" name="Glenn Whelan" birthday="13-01-1984" positions="cm" nationality="ir" number="6">
				<stats passing="68" tackling="69" shooting="65" crossing="44" heading="52" dribbling="51" speed="55" stamina="68" aggression="70" strength="63" fitness="75" creativity="65"/>		
			</player>
			<player id="Jermaine Pennant" name="Jermaine Pennant" birthday="16-01-1983" positions="sm" nationality="en" number="16">
				<stats passing="64" tackling="29" shooting="44" crossing="82" heading="25" dribbling="75" speed="85" stamina="65" aggression="35" strength="33" fitness="60" creativity="64"/>	
			</player>
			<player id="Carlo Nash" name="Carlo Nash" birthday="13-09-1973" positions="gk" nationality="en" number="27">
				<stats catching="57" shotStopping="65" distribution="62" fitness="60" stamina="59"/>		
			</player>
			<player id="Matthew Etherington" name="Matthew Eterington" birthday="14-08-1981" positions="sm" nationality="en" number="26">
				<stats passing="64" tackling="39" shooting="60" crossing="69" heading="38" dribbling="69" speed="75" stamina="70" aggression="29" strength="33" fitness="70" creativity="68"/>		
			</player>
			<player id="Eidur Gudjohnsen" name="Eidur Gudjohnsen" birthday="15-09-1978" positions="am-cf" nationality="ic" number="7">
				<stats passing="75" tackling="34" shooting="63" crossing="58" heading="69" dribbling="64" speed="65" stamina="53" aggression="55" strength="75" fitness="64" creativity="70"/>		
			</player>
			<player id="Tuncay Sanli" name="Tuncay Sanli" birthday="16-01-1982" positions="am-cf" nationality="tu" number="20">
				<stats passing="62" tackling="30" shooting="59" crossing="60" heading="59" dribbling="64" speed="68" stamina="75" aggression="88" strength="54" fitness="80" creativity="65"/>		
			</player>
			<player id="Kenwyne Jones" name="Kenwyne Jones" birthday="05-10-1984" positions="cf" nationality="tr" number="9">
				<stats passing="53" tackling="29" shooting="56" crossing="51" heading="74" dribbling="64" speed="75" stamina="59" aggression="53" strength="89" fitness="39" creativity="44"/>		
			</player>
			<player id="Mamady Sidibe" name="Mamady Sidibe" birthday="18-12-1979" positions="cf" nationality="ma" number="11">
				<stats passing="59" tackling="47" shooting="54" crossing="39" heading="77" dribbling="54" speed="60" stamina="79" aggression="67" strength="82" fitness="75" creativity="68"/>		
			</player>
			<player id="Ricardo Fuller" name="Ricardo Fuller" birthday="31-10-1979" positions="cf" nationality="ja" number="10">
				<stats passing="59" tackling="29" shooting="64" crossing="44" heading="63" dribbling="78" speed="78" stamina="52" aggression="75" strength="75" fitness="39" creativity="55"/>		
			</player>
			<player id="Asmir Begovic" name="Asmir Begovic" birthday="20-06-1987" positions="gk" nationality="bo" number="1">
				<stats catching="68" shotStopping="78" distribution="69" fitness="74" stamina="59"/>		
			</player>
		</players>
	</club>
	<club shirtColor="0xFFFFFF" sleevesColor="0xFFFFFF" stripesType="vertical" stripesColor="0xFF0000" scoreMultiplier="3" attackScore="D" defendScore="D">
		<name><![CDATA[Sunderland]]></name>
		<profile>60</profile>
		<players>
			<player id="Craig Gordon" name="Craig Gordon" birthday="31-12-1982" positions="gk" nationality="sc" number="1">
				<stats catching="74" shotStopping="79" distribution="64" fitness="89" stamina="29"/>
			</player>
			<player id="Marcos Angeleri" name="Marcos Angeleri" birthday="30-08-1982" positions="fb-cb" nationality="ar" number="12">
				<stats passing="59" tackling="69" shooting="41" crossing="64" heading="54" dribbling="53" speed="82" stamina="64" aggression="64" strength="64" fitness="56" creativity="49"/>	
			</player>	
			<player id="Phil Bardsley" name="Phil Bardsley" birthday="28-06-1985" positions="fb" nationality="en" number="2">
				<stats passing="54" tackling="72" shooting="54" crossing="63" heading="49" dribbling="43" speed="64" stamina="79" aggression="84" strength="57" fitness="77" creativity="32"/>
			</player>
			<player id="Nedam Onuoha" name="Nedam Onuoha" birthday="30-11-1986" positions="cb-fb" nationality="en" number="15">
				<stats passing="34" tackling="74" shooting="21" crossing="19" heading="74" dribbling="33" speed="88" stamina="84" aggression="59" strength="73" fitness="76" creativity="39"/>
			</player>
			<player id="Kieran Richardson" name="Kieran Richardson" birthday="21-10-1984" positions="am-fb-sm" nationality="en" number="3">
				<stats passing="54" tackling="59" shooting="56" crossing="59" heading="29" dribbling="64" speed="84" stamina="70" aggression="57" strength="44" fitness="64" creativity="64"/>				
			</player>
			<player id="Paulo da Silva" name="Paulo da Silva" birthday="01-02-1980" positions="cb" nationality="pa" number="14">
				<stats passing="62" tackling="84" shooting="48" crossing="50" heading="71" dribbling="19" speed="48" stamina="69" aggression="44" strength="75" fitness="75" creativity="59"/>				
			</player>
			<player id="Ahmed Elmohammady" name="Ahmed Elmohammady" birthday="09-09-1987" positions="fb-sm" nationality="eg" number="27">
				<stats passing="54" tackling="59" shooting="55" crossing="68" heading="70" dribbling="64" speed="75" stamina="70" aggression="75" strength="65" fitness="75" creativity="54"/>
			</player>
			<player id="Lee Cattermole" name="Lee Cattermole" birthday="21-03-1988" positions="cm-dm" nationality="fr" number="8">
				<stats passing="64" tackling="74" shooting="59" crossing="52" heading="64" dribbling="59" speed="53" stamina="79" aggression="97" strength="70" fitness="89" creativity="64"/>
			</player>
			<player id="Christian Riveros" name="Christian Riveros" birthday="16-10-1982" positions="dm-cm" nationality="pa" number="16">
				<stats passing="59" tackling="74" shooting="64" crossing="49" heading="64" dribbling="47" speed="64" stamina="70" aggression="56" strength="64" fitness="75" creativity="54"/>
			</player>
			<player id="Jordan Henderson" name="Jordan Henderson" birthday="17-06-1990" positions="cm-sm" nationality="en" number="10" ageImprovement="40">
				<stats passing="73" tackling="49" shooting="65" crossing="73" heading="37" dribbling="68" speed="72" stamina="79" aggression="48" strength="39" fitness="68" creativity="65"/>	
			</player>
			<player id="Andy Reid" name="Andy Reid" birthday="29-07-1982" positions="sm-cm-am" nationality="ir" number="20">
				<stats passing="69" tackling="44" shooting="64" crossing="75" heading="43" dribbling="75" speed="54" stamina="59" aggression="60" strength="59" fitness="26" creativity="78"/>	
			</player>
			<player id="Jack Colback" name="Jack Colback" birthday="24-10-1989" positions="cm" nationality="en" number="25">
				<stats passing="64" tackling="68" shooting="55" crossing="34" heading="43" dribbling="54" speed="53" stamina="59" aggression="82" strength="53" fitness="54" creativity="51"/>
			</player>
			<player id="Steed Malbranque" name="Steed Malbranque" birthday="06-01-1980" positions="cm-am-sm" nationality="fr" number="8">
				<stats passing="74" tackling="70" shooting="43" crossing="64" heading="28" dribbling="88" speed="53" stamina="28" aggression="64" strength="59" fitness="39" creativity="79"/>	
			</player>
			<player id="Boudewijn Zenden" name="Boudewijn Zenden" birthday="15-08-1976" positions="sm" nationality="ne" number="7">
				<stats passing="73" tackling="29" shooting="56" crossing="75" heading="39" dribbling="59" speed="54" stamina="45" aggression="60" strength="51" fitness="34" creativity="67"/>		
			</player>
			<player id="Asamoah Gyan" name="Asamoah Gyan" birthday="22-11-1985" positions="cf" nationality="gh" number="33">
				<stats passing="44" tackling="12" shooting="66" crossing="32" heading="75" dribbling="64" speed="83" stamina="64" aggression="54" strength="75" fitness="70" creativity="35"/>		
			</player>
			<player id="Darren Bent" name="Darren Bent" birthday="06-02-1984" positions="cf" nationality="en" number="11">
				<stats passing="48" tackling="19" shooting="71" crossing="44" heading="58" dribbling="60" speed="89" stamina="69" aggression="53" strength="64" fitness="80" creativity="35"/>		
			</player>
			<player id="Frazier Campbell" name="Frazier Campbell" birthday="13-09-1987" positions="cf" nationality="en" number="9">
				<stats passing="54" tackling="22" shooting="63" crossing="44" heading="45" dribbling="64" speed="83" stamina="64" aggression="58" strength="44" fitness="69" creativity="45"/>	
			</player>
			<player id="Simon Mignolet" name="Simon Mignolet" birthday="06-08-1988" positions="gk" nationality="be" number="22">
				<stats catching="68" shotStopping="74" distribution="73" fitness="68" stamina="59"/>		
			</player>
			<player id="Danny Welbeck" name="Danny Welbeck" birthday="26-11-1990" positions="cf" nationality="en" number="17">
				<stats passing="38" tackling="7" shooting="65" crossing="33" heading="42" dribbling="54" speed="77" stamina="44" aggression="34" strength="49" fitness="72" creativity="32"/>		
			</player>	
		</players>
	</club>
	
	<club shirtColor="0xFFFFFF" sleevesColor="0xFFFFFF" stripesType="none" scoreMultiplier="2" attackScore="B" defendScore="C">
		<name><![CDATA[Tottenham Hotspur]]></name>
		<shortName><![CDATA[Tottenham]]></shortName>
		<profile>75</profile>
		<players>
			<player id="Carlo Cudicini" name="Carlo Cudicini" birthday="06-09-1973" positions="gk" nationality="it" number="23">
				<stats catching="75" shotStopping="71" distribution="65" fitness="70" stamina="80"/>
			</player>
			<player id="Younes Kaboul" name="Younes Kaboul" birthday="04-01-1986" positions="cb-fb" nationality="fr" number="4">
				<stats passing="54" tackling="68" shooting="56" crossing="64" heading="75" dribbling="38" speed="74" stamina="68" aggression="54" strength="94" fitness="55" creativity="64"/>	
			</player>	
			<player id="Kyle Naughton" name="Kyle Naughton" birthday="11-11-1988" positions="fb" nationality="en" number="16">
				<stats passing="52" tackling="64" shooting="24" crossing="58" heading="60" dribbling="43" speed="79" stamina="58" aggression="50" strength="54" fitness="89" creativity="39"/>
			</player>
			<player id="Vedran Corluka" name="Vedran Corluka" birthday="31-03-1986" positions="fb-cb-cm" nationality="cr" number="22">
				<stats passing="54" tackling="74" shooting="38" crossing="54" heading="75" dribbling="54" speed="59" stamina="70" aggression="68" strength="68" fitness="68" creativity="48"/>
			</player>
			<player id="Sebastien Bassong" name="Sebastien Bassong" birthday="09-07-1986" positions="cb-fb" nationality="cm" number="19">
				<stats passing="54" tackling="75" shooting="29" crossing="43" heading="79" dribbling="38" speed="75" stamina="78" aggression="75" strength="75" fitness="78" creativity="43"/>				
			</player>
			<player id="William Gallas" name="William Gallas" birthday="17-08-1977" positions="cb" nationality="fr" number="13">
				<stats passing="58" tackling="84" shooting="49" crossing="23" heading="79" dribbling="54" speed="67" stamina="79" aggression="74" strength="74" fitness="75" creativity="45"/>				
			</player>
			<player id="Michael Dawson" name="Michael Dawson" birthday="18-11-1983" positions="cb" nationality="en" number="20">
				<stats passing="57" tackling="75" shooting="20" crossing="19" heading="84" dribbling="18" speed="58" stamina="79" aggression="68" strength="73" fitness="70" creativity="54"/>
			</player>
			<player id="Ledley King" name="Ledley King" birthday="12-10-1980" positions="cb" nationality="en" number="26">
				<stats passing="53" tackling="80" shooting="12" crossing="26" heading="73" dribbling="39" speed="68" stamina="44" aggression="69" strength="84" fitness="30" creativity="44"/>
			</player>
			<player id="Alan Hutton" name="Alan Hutton" birthday="30-11-1984" positions="fb" nationality="sc" number="2">
				<stats passing="68" tackling="70" shooting="54" crossing="65" heading="77" dribbling="64" speed="74" stamina="64" aggression="85" strength="74" fitness="57" creativity="53"/>
			</player>
			<player id="Benoit Assou-Ekotto" name="Benoit Assou-Ekotto" birthday="24-03-1984" positions="fb" nationality="cm" number="32">
				<stats passing="64" tackling="74" shooting="38" crossing="63" heading="54" dribbling="64" speed="73" stamina="68" aggression="72" strength="59" fitness="74" creativity="49"/>	
			</player>
			<player id="Gareth Bale" name="Gareth Bale" birthday="16-07-1989" positions="fb-sm" nationality="we" number="3">
				<stats passing="65" tackling="64" shooting="63" crossing="75" heading="74" dribbling="70" speed="70" stamina="78" aggression="23" strength="62" fitness="73" creativity="65"/>	
			</player>
			<player id="Tom Huddlestone" name="Tom Huddlestone" birthday="28-12-1986" positions="dm-cm-cb" nationality="en" number="6">
				<stats passing="77" tackling="64" shooting="54" crossing="52" heading="59" dribbling="60" speed="43" stamina="75" aggression="70" strength="90" fitness="78" creativity="79"/>
			</player>
			<player id="Jermaine Jenas" name="Jermaine Jenas" birthday="18-02-1983" positions="cm-dm-am" nationality="en" number="8">
				<stats passing="63" tackling="64" shooting="55" crossing="60" heading="58" dribbling="59" speed="75" stamina="75" aggression="54" strength="64" fitness="70" creativity="57"/>	
			</player>
			<player id="Jamie O'Hara" name="Jamie O'Hara" birthday="25-09-1986" positions="cm-sm" nationality="ir" number="24">
				<stats passing="68" tackling="53" shooting="57" crossing="64" heading="37" dribbling="53" speed="56" stamina="75" aggression="54" strength="52" fitness="67" creativity="70"/>		
			</player>
			<player id="Wilson Palacios" name="Wilson Palacios" birthday="29-07-1984" positions="cm" nationality="ho" number="12">
				<stats passing="53" tackling="79" shooting="45" crossing="34" heading="78" dribbling="74" speed="80" stamina="87" aggression="70" strength="84" fitness="59" creativity="54"/>		
			</player>
			<player id="Luka Modric" name="Luka Modric" birthday="09-09-1985" positions="cm-am-sm" nationality="cr" number="14">
				<stats passing="74" tackling="41" shooting="44" crossing="58" heading="34" dribbling="78" speed="68" stamina="90" aggression="59" strength="46" fitness="78" creativity="84"/>		
			</player>
			<player id="Rafael van der Vaart" name="Rafael van der Vaart" birthday="11-02-1983" positions="am-sm" nationality="ne" number="11">
				<stats passing="84" tackling="38" shooting="79" crossing="75" heading="28" dribbling="69" speed="54" stamina="75" aggression="53" strength="50" fitness="62" creativity="78"/>	
			</player>
			<player id="Stipe Pletikosa" name="Stipe Pletikosa" birthday="08-01-1979" positions="gk" nationality="cr" number="37">
				<stats catching="69" shotStopping="69" distribution="64" fitness="79" stamina="70"/>		
			</player>
			<player id="David Bentley" name="David Bentley" birthday="27-08-1984" positions="cm-sm" nationality="en" number="5">
				<stats passing="79" tackling="44" shooting="64" crossing="80" heading="30" dribbling="52" speed="64" stamina="75" aggression="58" strength="65" fitness="83" creativity="75"/>		
			</player>
			<player id="Aaron Lennon" name="Aaron Lennon" birthday="16-04-1987" positions="cm-sm-am" nationality="en" number="7">
				<stats passing="68" tackling="34" shooting="47" crossing="70" heading="34" dribbling="79" speed="84" stamina="64" aggression="21" strength="38" fitness="75" creativity="70"/>		
			</player>
			<player id="Niko Kranjcar" name="Niko Kranjcar" birthday="13-08-1984" positions="am-sm" nationality="cr" number="21">
				<stats passing="75" tackling="55" shooting="60" crossing="57" heading="39" dribbling="75" speed="59" stamina="70" aggression="58" strength="75" fitness="65" creativity="70"/>		
			</player>
			<player id="Giovani dos Santos" name="Giovani dos Santos" birthday="11-05-1989" positions="am-sm-cf" nationality="me" number="17">
				<stats passing="64" tackling="33" shooting="65" crossing="64" heading="24" dribbling="79" speed="80" stamina="58" aggression="34" strength="35" fitness="65" creativity="60"/>		
			</player>
			<player id="Jermain Defoe" name="Jermain Defoe" birthday="07-10-1982" positions="cf" nationality="en" number="18">
				<stats passing="59" tackling="29" shooting="76" crossing="45" heading="54" dribbling="60" speed="77" stamina="70" aggression="60" strength="50" fitness="90" creativity="53"/>		
			</player>
			<player id="Roman Pavlyuchenko" name="Roman Pavlyuchenko" birthday="15-12-1981" positions="cf" nationality="ru" number="9">
				<stats passing="70" tackling="50" shooting="79" crossing="44" heading="80" dribbling="54" speed="64" stamina="79" aggression="60" strength="65" fitness="94" creativity="64"/>		
			</player>
			<player id="Peter Crouch" name="Peter Crouch" birthday="30-01-1981" positions="cf" nationality="en" number="15">
				<stats passing="59" tackling="41" shooting="64" crossing="45" heading="78" dribbling="64" speed="60" stamina="80" aggression="60" strength="70" fitness="75" creativity="70"/>		
			</player>
			<player id="Robbie Keane" name="Robbie Keane" birthday="08-07-1980" positions="cf" nationality="ir" number="10">
				<stats passing="64" tackling="39" shooting="74" crossing="64" heading="36" dribbling="73" speed="67" stamina="85" aggression="23" strength="54" fitness="75" creativity="75"/>		
			</player>
			<player id="Gomes" name="Gomes" birthday="15-02-1981" positions="gk" nationality="br" number="1">
				<stats catching="74" shotStopping="97" distribution="29" fitness="70" stamina="75"/>		
			</player>
		</players>
	</club>
	
	<club shirtColor="0xFFFFFF" sleevesColor="0xFFFFFF" stripesType="vertical" stripesColor="0x000022" scoreMultiplier="4" attackScore="E" defendScore="C">
		<name><![CDATA[West Bromwich Albion]]></name>
		<shortName><![CDATA[WBA]]></shortName>
		<profile>50</profile>
		<players>
			<player id="Boaz Myhill" name="Boaz Myhill" birthday="09-11-1982" positions="gk" nationality="we" number="13">
				<stats catching="75" shotStopping="87" distribution="58" fitness="60" stamina="59"/>
			</player>
			<player id="Gonzalo Jara" name="Gonzalo Jara" birthday="23-08-1985" positions="cb-fb-cm" nationality="ch" number="36">
				<stats passing="64" tackling="75" shooting="41" crossing="39" heading="68" dribbling="52" speed="54" stamina="70" aggression="73" strength="64" fitness="69" creativity="59"/>	
			</player>	
			<player id="Gabriel Tamas" name="Gabriel Tamas" birthday="09-11-1983" positions="cb-fb" nationality="ro" number="30">
				<stats passing="57" tackling="69" shooting="44" crossing="49" heading="68" dribbling="44" speed="64" stamina="75" aggression="70" strength="75" fitness="80" creativity="54"/>
			</player>
			<player id="Steven Reid" name="Steven Reid" birthday="10-03-1981" positions="cm-dm" nationality="ir" number="12">
				<stats passing="51" tackling="67" shooting="40" crossing="53" heading="69" dribbling="58" speed="64" stamina="79" aggression="74" strength="86" fitness="70" creativity="53"/>
			</player>
			<player id="Jonas Olsson" name="Jonas Olsson" birthday="10-03-1983" positions="cb" nationality="sw" number="3">
				<stats passing="70" tackling="70" shooting="23" crossing="18" heading="70" dribbling="37" speed="50" stamina="75" aggression="75" strength="75" fitness="75" creativity="70"/>				
			</player>
			<player id="Pablo" name="Pablo" birthday="03-08-1981" positions="cb" nationality="es" number="6">
				<stats passing="56" tackling="64" shooting="39" crossing="22" heading="78" dribbling="34" speed="54" stamina="65" aggression="78" strength="69" fitness="68" creativity="53"/>				
			</player>
			<player id="Paul Scharner" name="Paul Scharner" birthday="11-03-1980" positions="cb-cm-dm" nationality="as" number="33">
				<stats passing="62" tackling="64" shooting="59" crossing="35" heading="64" dribbling="59" speed="53" stamina="68" aggression="59" strength="75" fitness="70" creativity="64"/>
			</player>
			<player id="Gianni Zuiverloon" name="Gianni Zuiverloon" birthday="30-12-1986" positions="fb" nationality="ne" number="22">
				<stats passing="58" tackling="68" shooting="26" crossing="64" heading="69" dribbling="68" speed="75" stamina="70" aggression="68" strength="70" fitness="75" creativity="60"/>
			</player>
			<player id="Nicky Shorey" name="Nicky Shorey" birthday="19-02-1981" positions="fb" nationality="en" number="20">
				<stats passing="64" tackling="57" shooting="49" crossing="69" heading="53" dribbling="54" speed="57" stamina="70" aggression="23" strength="44" fitness="75" creativity="59"/>
			</player>
			<player id="Joe Mattock" name="Joe Mattock" birthday="15-05-1990" positions="fb" nationality="en" number="2">
				<stats passing="54" tackling="64" shooting="42" crossing="60" heading="64" dribbling="48" speed="59" stamina="65" aggression="68" strength="75" fitness="70" creativity="55"/>	
			</player>
			<player id="Marek Cech" name="Marek Cech" birthday="26-01-1983" positions="fb" nationality="sl" number="4">
				<stats passing="64" tackling="58" shooting="44" crossing="64" heading="33" dribbling="68" speed="64" stamina="70" aggression="32" strength="54" fitness="70" creativity="58"/>	
			</player>
			<player id="Youssuf Mulumbu" name="Youssuf Mulumbu" birthday="25-01-1987" positions="cm-dm" nationality="dc" number="21">
				<stats passing="64" tackling="72" shooting="38" crossing="34" heading="54" dribbling="59" speed="60" stamina="89" aggression="75" strength="75" fitness="77" creativity="59"/>
			</player>
			<player id="Giles Barnes" name="Giles Barnes" birthday="05-08-1988" positions="am-sm-cm" nationality="en" number="8">
				<stats passing="67" tackling="54" shooting="67" crossing="59" heading="41" dribbling="74" speed="70" stamina="60" aggression="55" strength="55" fitness="34" creativity="80"/>	
			</player>
			<player id="Jerome Thomas" name="Jerome Thomas" birthday="23-03-1983" positions="cm-sm" nationality="en" number="14">
				<stats passing="48" tackling="21" shooting="45" crossing="59" heading="6" dribbling="68" speed="69" stamina="55" aggression="39" strength="54" fitness="55" creativity="64"/>		
			</player>
			<player id="James Morrison" name="James Morrison" birthday="25-05-1986" positions="cm-am" nationality="sc" number="7">
				<stats passing="57" tackling="44" shooting="45" crossing="60" heading="34" dribbling="69" speed="58" stamina="54" aggression="44" strength="43" fitness="75" creativity="70"/>		
			</player>
			<player id="Chris Brunt" name="Chris Brunt" birthday="14-12-1984" positions="cm-sm-am" nationality="ni" number="11">
				<stats passing="70" tackling="43" shooting="68" crossing="82" heading="52" dribbling="63" speed="58" stamina="64" aggression="43" strength="57" fitness="68" creativity="70"/>		
			</player>
			<player id="Graham Dorrans" name="Graham Dorrans" birthday="05-05-1987" positions="cm-sm" nationality="sc" number="17">
				<stats passing="68" tackling="46" shooting="54" crossing="58" heading="36" dribbling="67" speed="65" stamina="64" aggression="53" strength="45" fitness="68" creativity="75"/>	
			</player>
			<player id="Scott Carson" name="Scott Carson" birthday="03-09-1985" positions="gk" nationality="en" number="1">
				<stats catching="60" shotStopping="75" distribution="70" fitness="70" stamina="80"/>		
			</player>
			<player id="Somen Tchoyi" name="Somen Tchoyi" birthday="29-01-1983" positions="cm-am" nationality="cm" number="5">
				<stats passing="58" tackling="51" shooting="57" crossing="73" heading="33" dribbling="84" speed="59" stamina="68" aggression="39" strength="75" fitness="59" creativity="59"/>		
			</player>
			<player id="Peter Odemwingie" name="Peter Odemwingie" birthday="15-07-1981" positions="cf-am" nationality="ng" number="24">
				<stats passing="53" tackling="16" shooting="65" crossing="54" heading="54" dribbling="59" speed="68" stamina="64" aggression="54" strength="64" fitness="69" creativity="52"/>		
			</player>
			<player id="Simon Cox" name="Simon Cox" birthday="28-04-1987" positions="cf-am" nationality="en" number="31">
				<stats passing="54" tackling="37" shooting="64" crossing="51" heading="53" dribbling="59" speed="64" stamina="75" aggression="43" strength="60" fitness="70" creativity="49"/>		
			</player>
			<player id="Marc-Antoine Fortune" name="Marc-Antonine Fortune" birthday="02-07-1981" positions="cf" nationality="fr" number="28">
				<stats passing="58" tackling="25" shooting="61" crossing="44" heading="70" dribbling="64" speed="63" stamina="75" aggression="42" strength="78" fitness="74" creativity="64"/>		
			</player>
			<player id="Ishmael Miller" name="Ishmael Miller" birthday="05-03-1987" positions="cf" nationality="en" number="10">
				<stats passing="50" tackling="35" shooting="59" crossing="54" heading="50" dribbling="64" speed="88" stamina="64" aggression="59" strength="90" fitness="70" creativity="50"/>		
			</player>
			<player id="Roman Bednar" name="Roman Bednar" birthday="26-03-1983" positions="cf" nationality="cz" number="9">
				<stats passing="52" tackling="33" shooting="59" crossing="44" heading="75" dribbling="49" speed="53" stamina="85" aggression="75" strength="75" fitness="70" creativity="50"/>		
			</player>
			
		</players>
	</club>
	
	<club shirtColor="0xAD1057" sleevesColor="0x709DEE" stripesType="none" stripesColor="0x799DBD" scoreMultiplier="4" attackScore="D" defendScore="C">
		<name><![CDATA[West Ham United]]></name>
		<shortName><![CDATA[West Ham]]></shortName>
		<profile>75</profile>
		<players>
			<player id="Robert Green" name="Robert Green" birthday="19-01-1980" positions="gk" nationality="en" number="1">
				<stats catching="70" shotStopping="80" distribution="65" fitness="70" stamina="70"/>
			</player>
			<player id="Tal Ben-Haim" name="Tal Ben-Haim" birthday="31-03-1982" positions="cb" nationality="is" number="3">
				<stats passing="53" tackling="74" shooting="46" crossing="45" heading="78" dribbling="23" speed="62" stamina="70" aggression="59" strength="69" fitness="54" creativity="38"/>	
			</player>	
			<player id="Jonathan Spector" name="Jonathan Spector" birthday="01-03-1986" positions="cb-fb" nationality="us" number="18">
				<stats passing="54" tackling="68" shooting="47" crossing="38" heading="58" dribbling="34" speed="68" stamina="63" aggression="75" strength="59" fitness="65" creativity="37"/>
			</player>
			<player id="Manuel da Costa" name="Manuel da Costa" birthday="06-05-1986" positions="cb-fb" nationality="pr" number="22">
				<stats passing="53" tackling="74" shooting="38" crossing="16" heading="78" dribbling="44" speed="54" stamina="79" aggression="58" strength="84" fitness="64" creativity="75"/>
			</player>
			<player id="Herita Ilunga" name="Herita Ilunga" birthday="25-02-1982" positions="fb" nationality="dc" number="23">
				<stats passing="44" tackling="68" shooting="34" crossing="53" heading="58" dribbling="52" speed="68" stamina="76" aggression="70" strength="69" fitness="70" creativity="40"/>				
			</player>
			<player id="Winston Reid" name="Winston Reid" birthday="03-07-1988" positions="cb" nationality="nz" number="2">
				<stats passing="59" tackling="74" shooting="51" crossing="54" heading="69" dribbling="48" speed="70" stamina="65" aggression="84" strength="75" fitness="64" creativity="54"/>				
			</player>
			<player id="Matthew Upson" name="Matthew Upson" birthday="18-04-1979" positions="cb" nationality="en" number="15">
				<stats passing="64" tackling="79" shooting="14" crossing="26" heading="77" dribbling="25" speed="64" stamina="68" aggression="39" strength="68" fitness="59" creativity="51"/>
			</player>
			<player id="Daniel Gabbidon" name="Daniel Gabbidon" birthday="08-08-1979" positions="cb" nationality="we" number="4">
				<stats passing="54" tackling="63" shooting="23" crossing="18" heading="64" dribbling="44" speed="64" stamina="59" aggression="33" strength="54" fitness="65" creativity="60"/>
			</player>
			<player id="Lars Jacobsen" name="Lars Jacobsen" birthday="20-09-1979" positions="fb" nationality="de" number="37">
				<stats passing="63" tackling="63" shooting="19" crossing="68" heading="41" dribbling="38" speed="59" stamina="74" aggression="43" strength="69" fitness="78" creativity="44"/>
			</player>
			<player id="Valon Behrami" name="Valon Behrami" birthday="19-04-1985" positions="sm-cm" nationality="sz" number="21">
				<stats passing="70" tackling="79" shooting="46" crossing="49" heading="38" dribbling="59" speed="69" stamina="94" aggression="79" strength="74" fitness="75" creativity="52"/>	
			</player>
			<player id="Thomas Hitzlsperger" name="Thomas Hitzlsperger" birthday="05-04-1982" positions="cm-dm" nationality="ge" number="11">
				<stats passing="74" tackling="37" shooting="70" crossing="64" heading="32" dribbling="39" speed="59" stamina="78" aggression="26" strength="79" fitness="75" creativity="78"/>	
			</player>
			<player id="Radoslav Kovac" name="Radoslav Kovac" birthday="27-11-1979" positions="cm-dm" nationality="cz" number="14">
				<stats passing="54" tackling="73" shooting="54" crossing="24" heading="80" dribbling="44" speed="59" stamina="70" aggression="89" strength="75" fitness="80" creativity="49"/>
			</player>
			<player id="Scott Parker" name="Scott Parker" birthday="13-10-1980" positions="cm-dm-am" nationality="en" number="8">
				<stats passing="76" tackling="79" shooting="62" crossing="52" heading="64" dribbling="74" speed="65" stamina="88" aggression="79" strength="75" fitness="80" creativity="52"/>	
			</player>
			<player id="Jack Collision" name="Jack Collision" birthday="02-10-1988" positions="cm-sm" nationality="we" number="10">
				<stats passing="68" tackling="64" shooting="54" crossing="53" heading="29" dribbling="67" speed="64" stamina="75" aggression="75" strength="70" fitness="80" creativity="64"/>		
			</player>
			<player id="Mark Noble" name="Mark Noble" birthday="08-05-1987" positions="cm" nationality="en" number="16">
				<stats passing="74" tackling="64" shooting="46" crossing="68" heading="52" dribbling="69" speed="64" stamina="70" aggression="70" strength="60" fitness="67" creativity="65"/>		
			</player>
			<player id="Kieron Dyer" name="Kieron Dyer" birthday="29-12-1978" positions="cm-am" nationality="en" number="7">
				<stats passing="76" tackling="58" shooting="56" crossing="64" heading="44" dribbling="74" speed="69" stamina="58" aggression="59" strength="44" fitness="64" creativity="70"/>		
			</player>
			<player id="Pablo Barrera" name="Pablo Barrera" birthday="21-06-1987" positions="am-sm" nationality="me" number="12">
				<stats passing="64" tackling="37" shooting="55" crossing="59" heading="26" dribbling="74" speed="75" stamina="70" aggression="34" strength="33" fitness="79" creativity="59"/>	
			</player>
			<player id="Ruud Boffin" name="Ruud Boffin" birthday="05-11-1987" positions="gk" nationality="be" number="31">
				<stats catching="64" shotStopping="69" distribution="54" fitness="35" stamina="39"/>		
			</player>
			<player id="Luis Boa Morte" name="Luis Boa Morte" birthday="04-08-1977" positions="sm-am" nationality="pr" number="13">
				<stats passing="59" tackling="39" shooting="59" crossing="65" heading="25" dribbling="65" speed="69" stamina="65" aggression="84" strength="64" fitness="79" creativity="64"/>		
			</player>
			<player id="Benni McCarthy" name="Benni McCarthy" birthday="12-11-1977" positions="cf" nationality="sa" number="17" progressType="sin2">
				<stats passing="74" tackling="23" shooting="79" crossing="49" heading="55" dribbling="59" speed="55" stamina="53" aggression="51" strength="64" fitness="11" creativity="73"/>		
			</player>
			<player id="Frederic Piquionne" name="Frederic Piquionne" birthday="08-12-1978" positions="cf" nationality="fr" number="30">
				<stats passing="64" tackling="7" shooting="63" crossing="52" heading="73" dribbling="69" speed="74" stamina="68" aggression="61" strength="65" fitness="75" creativity="54"/>		
			</player>
			<player id="Carlton Cole" name="Carlton Cole" birthday="12-10-1983" positions="cf" nationality="en" number="9">
				<stats passing="59" tackling="37" shooting="67" crossing="60" heading="67" dribbling="70" speed="69" stamina="80" aggression="49" strength="80" fitness="83" creativity="54"/>		
			</player>
			<player id="James Tomkins" name="James Tomkins" birthday="29-03-1989" positions="cb" nationality="en" number="5">
				<stats passing="54" tackling="64" shooting="42" crossing="29" heading="67" dribbling="53" speed="65" stamina="65" aggression="54" strength="69" fitness="75" creativity="27"/>		
			</player>
		</players>
	</club>
	
	<club shirtColor="0xFFFFFF" sleevesColor="0x1122FF" stripesType="vertical" stripesColor="0x1122FF" scoreMultiplier="4" attackScore="E" defendScore="D">
		<name><![CDATA[Wigan Athletic]]></name>
		<shortName><![CDATA[Wigan]]></shortName>
		<profile>60</profile>
		<players>
			<player id="Chris Kirkland" name="Chris Kirkland" birthday="02-05-1981" positions="gk" nationality="en" number="1">
				<stats catching="64" shotStopping="70" distribution="54" fitness="29" stamina="70"/>
			</player>
			<player id="Emerson Boyce" name="Emerson Boyce" birthday="24-09-1979" positions="cb-fb" nationality="ba" number="17">
				<stats passing="54" tackling="68" shooting="21" crossing="39" heading="78" dribbling="28" speed="59" stamina="74" aggression="39" strength="69" fitness="80" creativity="48"/>	
			</player>	
			<player id="Ronnie Stam" name="Ronnie Stam" birthday="18-06-1984" positions="fb-dm-cm" nationality="ne" number="23">
				<stats passing="74" tackling="58" shooting="39" crossing="34" heading="40" dribbling="64" speed="54" stamina="69" aggression="89" strength="63" fitness="70" creativity="80"/>
			</player>
			<player id="Maynor Figueroa" name="Maynor Figueroa" birthday="02-05-1983" positions="fb-cb" nationality="ho" number="31">
				<stats passing="59" tackling="60" shooting="54" crossing="54" heading="68" dribbling="60" speed="69" stamina="70" aggression="64" strength="70" fitness="79" creativity="58"/>
			</player>
			<player id="Charles N'Zogbia" name="Charles N'Zogbia" birthday="28-05-1986" positions="sm-am-fb" nationality="fr" number="10">
				<stats passing="59" tackling="52" shooting="60" crossing="59" heading="29" dribbling="70" speed="80" stamina="51" aggression="54" strength="53" fitness="59" creativity="54"/>				
			</player>
			<player id="Steven Caldwell" name="Steven Caldwell" birthday="12-09-1980" positions="cb" nationality="sc" number="13">
				<stats passing="58" tackling="74" shooting="30" crossing="12" heading="79" dribbling="24" speed="33" stamina="79" aggression="84" strength="83" fitness="70" creativity="64"/>				
			</player>
			<player id="Gary Caldwell" name="Gary Caldwell" birthday="12-04-1982" positions="cb" nationality="sc" number="5">
				<stats passing="64" tackling="79" shooting="37" crossing="54" heading="88" dribbling="43" speed="59" stamina="69" aggression="68" strength="70" fitness="68" creativity="54"/>
			</player>
			<player id="Antolin Alcaraz" name="Antolin Alcaraz" birthday="30-07-1982" positions="cb" nationality="pa" number="3">
				<stats passing="54" tackling="72" shooting="42" crossing="39" heading="78" dribbling="53" speed="59" stamina="39" aggression="64" strength="79" fitness="70" creativity="24"/>
			</player>
			<player id="Steve Gohouri" name="Steve Gohouri" birthday="08-02-1981" positions="cb" nationality="iv" number="2">
				<stats passing="37" tackling="62" shooting="39" crossing="23" heading="86" dribbling="32" speed="75" stamina="80" aggression="89" strength="83" fitness="80" creativity="44"/>
			</player>
			<player id="James McCarthy" name="James McCarthy" birthday="12-11-1990" positions="cm-am-dm" nationality="ir" number="4">
				<stats passing="73" tackling="53" shooting="65" crossing="53" heading="52" dribbling="63" speed="64" stamina="74" aggression="49" strength="23" fitness="69" creativity="59"/>	
			</player>
			<player id="Hendry Thomas" name="Hendry Thomas" birthday="23-02-1985" positions="dm-cm" nationality="ho" number="6">
				<stats passing="59" tackling="64" shooting="47" crossing="43" heading="59" dribbling="54" speed="74" stamina="68" aggression="78" strength="74" fitness="74" creativity="62"/>	
			</player>
			<player id="Mohamed Diame" name="Mohamed Diame" birthday="14-06-1987" positions="cm-dm" nationality="fr" number="21">
				<stats passing="78" tackling="83" shooting="44" crossing="54" heading="64" dribbling="74" speed="75" stamina="89" aggression="70" strength="98" fitness="75" creativity="49"/>
			</player>
			<player id="Ben Watson" name="Ben Watson" birthday="09-07-1985" positions="cm" nationality="en" number="8">
				<stats passing="70" tackling="53" shooting="55" crossing="53" heading="52" dribbling="59" speed="60" stamina="64" aggression="64" strength="54" fitness="59" creativity="60"/>	
			</player>
			<player id="James McArthur" name="James McArthur" birthday="07-10-1987" positions="cm" nationality="sc" number="16">
				<stats passing="78" tackling="63" shooting="30" crossing="54" heading="34" dribbling="67" speed="52" stamina="75" aggression="49" strength="39" fitness="70" creativity="74"/>		
			</player>
			<player id="Daniel de Ridder" name="Daniel de Ridder" birthday="06-03-1984" positions="sm-am-cm" nationality="ne" number="28">
				<stats passing="64" tackling="23" shooting="48" crossing="59" heading="39" dribbling="54" speed="59" stamina="55" aggression="39" strength="60" fitness="70" creativity="64"/>		
			</player>
			<player id="Jordi Gomez" name="Jordi Gomez" birthday="24-05-1985" positions="cm-am" nationality="es" number="14">
				<stats passing="79" tackling="52" shooting="64" crossing="52" heading="39" dribbling="64" speed="54" stamina="59" aggression="49" strength="39" fitness="58" creativity="89"/>		
			</player>
			<player id="Victor Moses" name="Victor Moses" birthday="12-12-1990" positions="cf-am" nationality="en" number="11">
				<stats passing="57" tackling="17" shooting="52" crossing="52" heading="39" dribbling="75" speed="70" stamina="44" aggression="32" strength="60" fitness="53" creativity="52"/>	
			</player>
			<player id="Mike Pollitt" name="Mike Pollitt" birthday="29-02-1972" positions="gk" nationality="en" number="12">
				<stats catching="64" shotStopping="75" distribution="58" fitness="64" stamina="63"/>		
			</player>
			<player id="Hugo Rodallega" name="Hugo Rodallega" birthday="25-07-1985" positions="cf-sm" nationality="co" number="20">
				<stats passing="59" tackling="29" shooting="60" crossing="33" heading="70" dribbling="64" speed="79" stamina="70" aggression="60" strength="64" fitness="69" creativity="75"/>		
			</player>
			<player id="Mauro Boselli" name="Mauro Boselli" birthday="22-05-1985" positions="cf" nationality="ar" number="9">
				<stats passing="64" tackling="38" shooting="74" crossing="45" heading="74" dribbling="53" speed="68" stamina="78" aggression="37" strength="74" fitness="75" creativity="44"/>		
			</player>
			<player id="Franco di Santo" name="Franco di Santo" birthday="07-04-1989" positions="cf" nationality="ar" number="7">
				<stats passing="54" tackling="34" shooting="54" crossing="32" heading="74" dribbling="34" speed="59" stamina="78" aggression="39" strength="68" fitness="87" creativity="59"/>		
			</player>
		</players>
	</club>
	
	<club shirtColor="0xFFAA00" sleevesColor="0xFFAA00" stripesType="none" scoreMultiplier="4" attackScore="D" defendScore="D">
		<name><![CDATA[Wolverhampton Wanderers]]></name>
		<shortName><![CDATA[Wolves]]></shortName>
		<profile>60</profile>
		<players>
			<player id="Marcus Hahnemann" name="Marcus Hahnemann" birthday="15-06-1972" positions="gk" nationality="us" number="1">
				<stats catching="64" shotStopping="63" distribution="59" fitness="74" stamina="65"/>
			</player>
			<player id="Ronald Zubar" name="Ronald Zubar" birthday="20-09-1985" positions="cb-fb" nationality="fr" number="23">
				<stats passing="54" tackling="73" shooting="45" crossing="54" heading="74" dribbling="39" speed="68" stamina="78" aggression="57" strength="78" fitness="63" creativity="38"/>	
			</player>	
			<player id="Michael Mancienne" name="Michael Mancienne" birthday="08-01-1988" positions="cb-fb-dm-cm" nationality="en" number="21">
				<stats passing="53" tackling="63" shooting="28" crossing="39" heading="64" dribbling="59" speed="74" stamina="68" aggression="52" strength="48" fitness="74" creativity="59"/>
			</player>
			<player id="Stephen Ward" name="Stephen Ward" birthday="20-08-1985" positions="fb" nationality="ir" number="11">
				<stats passing="59" tackling="68" shooting="47" crossing="64" heading="58" dribbling="59" speed="63" stamina="72" aggression="59" strength="54" fitness="78" creativity="34"/>
			</player>
			<player id="Jelle Van Damme" name="Jelle Van Damme" birthday="10-10-1983" positions="fb-cb" nationality="be" number="2">
				<stats passing="43" tackling="79" shooting="64" crossing="67" heading="84" dribbling="53" speed="62" stamina="70" aggression="75" strength="89" fitness="64" creativity="23"/>				
			</player>
			<player id="Jody Craddock" name="Jody Craddock" birthday="30-06-1975" positions="cb" nationality="en" number="6">
				<stats passing="44" tackling="74" shooting="19" crossing="11" heading="73" dribbling="18" speed="54" stamina="68" aggression="59" strength="66" fitness="68" creativity="21"/>				
			</player>
			<player id="Christophe Berra" name="Christophe Berra" birthday="31-01-1985" positions="cb" nationality="sc" number="16">
				<stats passing="54" tackling="78" shooting="28" crossing="27" heading="68" dribbling="24" speed="63" stamina="72" aggression="49" strength="74" fitness="84" creativity="58"/>
			</player>
			<player id="Steven Mouyokolo" name="Steven Mouyokolo" birthday="24-01-1987" positions="cb" nationality="dc" number="22">
				<stats passing="34" tackling="66" shooting="37" crossing="24" heading="78" dribbling="23" speed="64" stamina="68" aggression="64" strength="69" fitness="70" creativity="33"/>
			</player>
			<player id="Adlene Guedioura" name="Adlene Guedioura" birthday="12-11-1985" positions="dm-cm" nationality="al" number="34">
				<stats passing="52" tackling="54" shooting="63" crossing="33" heading="64" dribbling="53" speed="52" stamina="79" aggression="93" strength="58" fitness="84" creativity="39"/>
			</player>
			<player id="Kevin Foley" name="Kevin Foley" birthday="01-11-1984" positions="fb-sm" nationality="ir" number="32">
				<stats passing="64" tackling="68" shooting="33" crossing="64" heading="63" dribbling="59" speed="59" stamina="68" aggression="28" strength="54" fitness="70" creativity="53"/>	
			</player>
			<player id="Greg Halford" name="Greg Halford" birthday="08-12-1984" positions="fb-sm" nationality="en" number="15">
				<stats passing="63" tackling="52" shooting="63" crossing="58" heading="77" dribbling="53" speed="59" stamina="57" aggression="52" strength="74" fitness="74" creativity="60"/>	
			</player>
			<player id="Karl Henry" name="Karl Henry" birthday="26-11-1982" positions="cm-dm" nationality="en" number="8">
				<stats passing="73" tackling="77" shooting="41" crossing="43" heading="64" dribbling="52" speed="70" stamina="84" aggression="74" strength="79" fitness="78" creativity="64"/>
			</player>
			<player id="Nemad Milijas" name="Nemad Milijas" birthday="30-04-1983" positions="cm-sm" nationality="se" number="20">
				<stats passing="70" tackling="34" shooting="78" crossing="75" heading="52" dribbling="51" speed="57" stamina="64" aggression="64" strength="64" fitness="49" creativity="79"/>	
			</player>
			<player id="David Jones" name="David Jones" birthday="04-11-1984" positions="cm" nationality="en" number="14">
				<stats passing="73" tackling="52" shooting="64" crossing="63" heading="52" dribbling="44" speed="59" stamina="59" aggression="53" strength="52" fitness="69" creativity="69"/>		
			</player>
			<player id="David Edwards" name="David Edwards" birthday="03-02-1986" positions="cm-am" nationality="we" number="4">
				<stats passing="68" tackling="52" shooting="42" crossing="52" heading="55" dribbling="64" speed="60" stamina="79" aggression="52" strength="54" fitness="85" creativity="51"/>		
			</player>
			<player id="Matt Jarvis" name="Matt Jarvis" birthday="22-05-1986" positions="am-sm" nationality="en" number="17">
				<stats passing="57" tackling="34" shooting="30" crossing="48" heading="13" dribbling="69" speed="79" stamina="68" aggression="16" strength="34" fitness="64" creativity="35"/>		
			</player>
			<player id="Michael Kightly" name="Michael Kightly" birthday="24-10-1986" positions="sm" nationality="en" number="7">
				<stats passing="56" tackling="27" shooting="53" crossing="58" heading="17" dribbling="69" speed="75" stamina="75" aggression="51" strength="38" fitness="58" creativity="59"/>	
			</player>
			<player id="Wayne Hennessey" name="Wayne Hennessey" birthday="24-01-1987" positions="gk" nationality="we" number="13">
				<stats catching="74" shotStopping="73" distribution="79" fitness="64" stamina="54"/>		
			</player>
			<player id="Geoffrey Mujangi Bia" name="Geoffrey Mujangi Bia" birthday="12-08-1989" positions="sm-am" nationality="be" number="25">
				<stats passing="53" tackling="18" shooting="59" crossing="67" heading="23" dribbling="70" speed="79" stamina="34" aggression="39" strength="51" fitness="40" creativity="28"/>		
			</player>
			<player id="Stephen Hunt" name="Stephen Hunt" birthday="01-08-1981" positions="sm" nationality="ir" number="12">
				<stats passing="59" tackling="44" shooting="60" crossing="64" heading="59" dribbling="78" speed="64" stamina="90" aggression="79" strength="44" fitness="94" creativity="59"/>		
			</player>
			<player id="Kevin Doyle" name="Kevin Doyle" birthday="18-09-1983" positions="cf" nationality="ir" number="29">
				<stats passing="57" tackling="38" shooting="64" crossing="69" heading="78" dribbling="64" speed="68" stamina="69" aggression="52" strength="74" fitness="70" creativity="51"/>		
			</player>
			<player id="Marcus Bent" name="Marcus Bent" birthday="19-05-1978" positions="cf" nationality="en" number="19">
				<stats passing="54" tackling="45" shooting="64" crossing="53" heading="68" dribbling="53" speed="70" stamina="78" aggression="58" strength="75" fitness="75" creativity="43"/>		
			</player>
			<player id="Sylvan Ebanks-Blake" name="Sylvan Ebanks-Blake" birthday="29-03-1986" positions="cf" nationality="en" number="9">
				<stats passing="56" tackling="17" shooting="64" crossing="48" heading="49" dribbling="59" speed="74" stamina="59" aggression="65" strength="80" fitness="74" creativity="39"/>		
			</player>
			<player id="Steven Fletcher" name="Steven Fletcher" birthday="26-03-1987" positions="cf" nationality="sc" number="10">
				<stats passing="75" tackling="42" shooting="68" crossing="59" heading="73" dribbling="74" speed="69" stamina="70" aggression="59" strength="75" fitness="69" creativity="64"/>		
			</player>
			<player id="Carl Ikeme" name="Carl Ikeme" birthday="24-06-1986" positions="gk" nationality="ng" number="30">
				<stats catching="58" shotStopping="63" distribution="52" fitness="53" stamina="58"/>		
			</player>
		</players>
	</club>
</data>;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.club.length())
         {
            _loc5_ = TeamHelper.makeClub(_loc3_.club[_loc4_]);
            _loc5_.isCore = true;
            _loc2_.addEntrant(_loc5_);
            _loc4_++;
         }
         return _loc2_;
      }
      
      private static function makeLeague2() : League
      {
         var _loc3_:XML = null;
         var _loc1_:XML = <data>
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
         var _loc2_:League = new League();
         _loc2_.name = _loc1_.leagues.secondLeague[0].@nameId;
         _loc3_ = <data>
<club shirtColor="0xFF0000" sleevesColor="0xFFFFFF" stripesType="none">
		<name><![CDATA[QPR]]></name>
		<profile>55</profile>
		<players>
			<player id="Paddy Kenny" name="Paddy Kenny" birthday="17-05-1978" positions="gk" nationality="ir" number="1">
				<stats catching="75" shotStopping="80" distribution="50" fitness="70" stamina="60"/>
			</player>
			<player id="Bradley Orr" name="Bradley Orr" birthday="01-11-1982" positions="fb" nationality="en" number="2">
				<stats passing="55" tackling="55" shooting="54" crossing="45" heading="50" dribbling="70" speed="65" stamina="70" aggression="55" strength="70" fitness="50" creativity="60"/>	
			</player>	
			<player id="Clint Hill" name="Clint Hill" birthday="19-10-1978" positions="cb-fb" nationality="en" number="3">
				<stats passing="53" tackling="60" shooting="40" crossing="60" heading="63" dribbling="45" speed="65" stamina="68" aggression="58" strength="63" fitness="75" creativity="56"/>
			</player>
			<player id="Shaun Derry" name="Shaun Derry" birthday="06-12-1977" positions="cm-dm-fb" nationality="en" number="4">
				<stats passing="75" tackling="45" shooting="53" crossing="58" heading="35" dribbling="63" speed="64" stamina="67" aggression="46" strength="47" fitness="64" creativity="57"/>
			</player>
			<player id="Fitz Hall" name="Fitz Hall" birthday="20-12-1980" positions="cb-dm" nationality="en" number="5">
				<stats passing="65" tackling="68" shooting="56" crossing="46" heading="67" dribbling="56" speed="72" stamina="66" aggression="72" strength="68" fitness="75" creativity="45"/>				
			</player>
			<player id="Adel Taarabt" name="Adel Taarabt" birthday="24-05-1989" positions="am" nationality="mo" number="7">
				<stats passing="55" tackling="56" shooting="40" crossing="52" heading="57" dribbling="63" speed="68" stamina="67" aggression="65" strength="57" fitness="68" creativity="65"/>		
			</player>
			<player id="Leon Clarke" name="Leon Clarke" birthday="10-02-1985" positions="cf" nationality="en" number="8">
				<stats passing="72" tackling="43" shooting="68" crossing="67" heading="43" dribbling="75" speed="64" stamina="64" aggression="57" strength="42" fitness="60" creativity="56"/>
			</player>
			<player id="Heider Helguson" name="Heidar Helguson" birthday="22-08-1977" positions="cf" nationality="ic" number="9">
				<stats passing="65" tackling="56" shooting="69" crossing="67" heading="67" dribbling="73" speed="65" stamina="67" aggression="69" strength="60" fitness="60" creativity="67"/>
			</player>
			<player id="Akos Buzsaky" name="Akos Buzsaky" birthday="07-05-1982" positions="cm-am" nationality="hu" number="10">
				<stats passing="65" tackling="56" shooting="69" crossing="67" heading="67" dribbling="73" speed="65" stamina="67" aggression="69" strength="60" fitness="60" creativity="67"/>
			</player>
			<player id="Alejandro Faurlin" name="Alenjandro Faurlin" birthday="09-08-1986" positions="cm-sm" nationality="ar" number="11">
				<stats passing="53" tackling="34" shooting="62" crossing="67" heading="45" dribbling="69" speed="64" stamina="68" aggression="45" strength="49" fitness="61" creativity="64"/>	
			</player>
			<player id="Jamie Mackie" name="Jamie Mackie" birthday="22-09-1985" positions="cf" nationality="sc" number="12">
				<stats passing="49" tackling="32" shooting="64" crossing="68" heading="43" dribbling="66" speed="84" stamina="45" aggression="37" strength="46" fitness="57" creativity="51"/>	
			</player>
			<player id="Kaspars Gorkss" name="Kaspars Gorkss" birthday="06-11-1981" positions="cb" nationality="la" number="13">
				<stats passing="73" tackling="56" shooting="61" crossing="63" heading="45" dribbling="58" speed="68" stamina="68" aggression="64" strength="62" fitness="64" creativity="63"/>
			</player>
			<player id="Martin Rowlands" name="Martin Rowlands" birthday="08-02-1979" positions="cm" nationality="en" number="14">
				<stats passing="73" tackling="56" shooting="61" crossing="63" heading="45" dribbling="58" speed="68" stamina="68" aggression="64" strength="62" fitness="64" creativity="63"/>
			</player>
			<player id="Matthew Connolly" name="Matthew Connolly" birthday="24-09-1987" positions="cb" nationality="en" number="16">
				<stats passing="71" tackling="61" shooting="68" crossing="67" heading="45" dribbling="65" speed="68" stamina="67" aggression="68" strength="69" fitness="60" creativity="57"/>	
			</player>
			<player id="Lee Cook" name="Lee Cook" birthday="03-08-1982" positions="sm" nationality="en" number="17">
				<stats passing="40" tackling="69" shooting="56" crossing="56" heading="56" dribbling="66" speed="61" stamina="67" aggression="64" strength="66" fitness="69" creativity="55"/>		
			</player>
			<player id="Gavin Mahon" name="Gavin Mahon" birthday="02-01-1977" positions="dm" nationality="en" number="18">
				<stats passing="57" tackling="69" shooting="43" crossing="53" heading="67" dribbling="31" speed="67" stamina="77" aggression="67" strength="72" fitness="74" creativity="46"/>		
			</player>
			<player id="Patrick Agyemang" name="Patrick Agyemang" birthday="29-09-1980" positions="cf" nationality="gh" number="19">
				<stats passing="78" tackling="56" shooting="61" crossing="67" heading="25" dribbling="73" speed="69" stamina="67" aggression="69" strength="68" fitness="70" creativity="73"/>		
			</player>
			<player id="Rob Hulse" name="Rob Hulse" birthday="25-10-1979" positions="cf" nationality="en" number="20">
				<stats passing="50" tackling="67" shooting="58" crossing="45" heading="72" dribbling="42" speed="64" stamina="56" aggression="64" strength="63" fitness="34" creativity="41"/>	
			</player>
			<player id="Peter Ramage" name="Peter Ramage" birthday="22-11-1983" positions="fb" nationality="en" number="22">
				<stats passing="59" tackling="68" shooting="38" crossing="47" heading="53" dribbling="55" speed="69" stamina="72" aggression="64" strength="56" fitness="78" creativity="67"/>		
			</player>
			<player id="Radek Cerny" name="Radek Cerny" birthday="18-02-1974" positions="gk" nationality="cz" number="24">
				<stats passing="67" tackling="27" shooting="74" crossing="57" heading="23" dribbling="72" speed="73" stamina="43" aggression="48" strength="34" fitness="67" creativity="73"/>		
			</player>
			<player id="Hogan Ephraim" name="Hogan Ephraim" birthday="31-03-1988" positions="fb" nationality="en" number="25">
				<stats passing="69" tackling="67" shooting="45" crossing="56" heading="59" dribbling="71" speed="72" stamina="65" aggression="46" strength="59" fitness="70" creativity="67"/>		
			</player>
			<player id="Gary Borrowdale" name="Gary Borrowdale" birthday="16-07-1985" positions="fb" nationality="en" number="26">
				<stats passing="65" tackling="67" shooting="67" crossing="56" heading="56" dribbling="64" speed="62" stamina="67" aggression="57" strength="67" fitness="67" creativity="73"/>	
			</player>
		</players>	
	</club>
<club shirtColor="0xFF0000" sleevesColor="0xFFFFFF" stripesType="none">
		<name><![CDATA[Cardiff City]]></name>
		<profile>50</profile>
		<players>
			<player id="David Marshall" name="David Marshall" birthday="05-03-1985" positions="gk" nationality="sc" number="1">
				<stats catching="75" shotStopping="80" distribution="50" fitness="70" stamina="60"/>
			</player>
			<player id="Kevin McNaughton" name="Kevin McNaughton" birthday="28-08-1982" positions="fb-cb-dm-cm" nationality="en" number="2">
				<stats passing="55" tackling="55" shooting="54" crossing="45" heading="50" dribbling="70" speed="65" stamina="70" aggression="55" strength="70" fitness="50" creativity="60"/>	
			</player>	
			<player id="Lee Naylor" name="Lee Naylor" birthday="19-03-1980" positions="fb" nationality="en" number="3">
				<stats passing="53" tackling="60" shooting="40" crossing="60" heading="63" dribbling="45" speed="65" stamina="68" aggression="58" strength="63" fitness="75" creativity="56"/>
			</player>
			<player id="Gavin Rae" name="Gavin Rae" birthday="28-11-1977" positions="cm" nationality="sc" number="4">
				<stats passing="75" tackling="45" shooting="53" crossing="58" heading="35" dribbling="63" speed="64" stamina="67" aggression="46" strength="47" fitness="64" creativity="57"/>
			</player>
			<player id="Mark Hudson" name="Mark Hudson" birthday="30-03-1982" positions="cb" nationality="en" number="5">
				<stats passing="65" tackling="68" shooting="56" crossing="46" heading="67" dribbling="56" speed="72" stamina="66" aggression="72" strength="68" fitness="75" creativity="45"/>				
			</player>
			<player id="Gabor Gyepes" name="Gabor Gyepes" birthday="26-06-1981" positions="cb" nationality="hu" number="6">
				<stats passing="55" tackling="56" shooting="40" crossing="52" heading="57" dribbling="43" speed="68" stamina="67" aggression="65" strength="57" fitness="68" creativity="45"/>				
			</player>
			<player id="Peter Whittingham" name="Peter Whittingham" birthday="08-09-1984" positions="cm-sm" nationality="en" number="7">
				<stats passing="68" tackling="46" shooting="64" crossing="63" heading="34" dribbling="67" speed="61" stamina="58" aggression="48" strength="56" fitness="37" creativity="74"/>
			</player>
			<player id="Michael Chopra" name="Michael Chopra" birthday="23-12-1983" positions="cf" nationality="en" number="8">
				<stats passing="72" tackling="43" shooting="68" crossing="67" heading="43" dribbling="75" speed="64" stamina="64" aggression="57" strength="42" fitness="60" creativity="56"/>
			</player>
			<player id="Jay Bothroyd" name="Jay Bothroyd" birthday="05-05-1982" positions="cf" nationality="en" number="9">
				<stats passing="65" tackling="56" shooting="69" crossing="67" heading="67" dribbling="73" speed="65" stamina="67" aggression="69" strength="60" fitness="60" creativity="67"/>
			</player>
			<player id="Stephen McPhail" name="Stephen McPhail" birthday="09-12-1979" positions="cm" nationality="ir" number="10">
				<stats passing="65" tackling="56" shooting="69" crossing="67" heading="67" dribbling="73" speed="65" stamina="67" aggression="69" strength="60" fitness="60" creativity="67"/>
			</player>
			<player id="Chris Burke" name="Chris Burke" birthday="02-12-1983" positions="sm" nationality="sc" number="11">
				<stats passing="53" tackling="34" shooting="62" crossing="67" heading="45" dribbling="69" speed="64" stamina="68" aggression="45" strength="49" fitness="61" creativity="64"/>	
			</player>
			<player id="Paul Quinn" name="Paul Quinn" birthday="21-07-1985" positions="fb-sm" nationality="sc" number="14">
				<stats passing="73" tackling="56" shooting="61" crossing="63" heading="45" dribbling="58" speed="68" stamina="68" aggression="64" strength="62" fitness="64" creativity="63"/>
			</player>
			<player id="Andy Keogh" name="Andy Keogh" birthday="16-05-1986" positions="cf" nationality="ir" number="17">
				<stats passing="71" tackling="61" shooting="68" crossing="67" heading="45" dribbling="65" speed="68" stamina="67" aggression="68" strength="69" fitness="60" creativity="57"/>	
			</player>
			<player id="Jason Koumas" name="Jason Koumas" birthday="25-09-1979" positions="sm-cm-am" nationality="en" number="19">
				<stats passing="40" tackling="69" shooting="56" crossing="56" heading="56" dribbling="66" speed="61" stamina="67" aggression="64" strength="66" fitness="69" creativity="55"/>		
			</player>
			<player id="Seyi Olofinjana" name="Seyi Ologinjana" birthday="30-06-1980" positions="cm" nationality="ng" number="20">
				<stats passing="57" tackling="69" shooting="43" crossing="53" heading="67" dribbling="31" speed="67" stamina="77" aggression="67" strength="72" fitness="74" creativity="46"/>		
			</player>
			<player id="Chris Riggott" name="Chris Riggott" birthday="01-09-1980" positions="cb" nationality="cb" number="31">
				<stats passing="50" tackling="67" shooting="58" crossing="45" heading="72" dribbling="42" speed="64" stamina="56" aggression="64" strength="63" fitness="34" creativity="41"/>	
			</player>
			<player id="Tom Heaton" name="Tom Heaton" birthday="15-04-1986" positions="gk" nationality="en" number="22">
				<stats catching="50" shotStopping="76" distribution="60" fitness="67" stamina="84"/>		
			</player>
			<player id="Darcy Blake" name="Darcy Blake" birthday="13-12-1988" positions="fb-cm-sm" nationality="we" number="23">
				<stats passing="59" tackling="68" shooting="38" crossing="47" heading="53" dribbling="55" speed="69" stamina="72" aggression="64" strength="56" fitness="78" creativity="67"/>		
			</player>
			<player id="Adam Matthews" name="Adam Matthews" birthday="13-01-1992" positions="fb" nationality="we" number="27">
				<stats passing="67" tackling="27" shooting="74" crossing="57" heading="23" dribbling="72" speed="73" stamina="43" aggression="48" strength="34" fitness="67" creativity="73"/>		
			</player>
			<player id="Craig Bellamy" name="Craig Bellamy" birthday="13-07-1979" positions="cf-am-sm" nationality="we" number="39">
				<stats passing="65" tackling="67" shooting="67" crossing="56" heading="56" dribbling="64" speed="62" stamina="67" aggression="57" strength="67" fitness="67" creativity="73"/>	
			</player>
		</players>	
	</club>	
	<club shirtColor="0xFF0000" sleevesColor="0xFFFFFF" stripesType="none">
		<name><![CDATA[Leeds United]]></name>
		<profile>80</profile>
		<players>
			<player id="Kasper Schmeichel" name="Kasper Schmeichel" birthday="05-11-1986" positions="gk" nationality="de" number="1">
				<stats catching="75" shotStopping="80" distribution="50" fitness="70" stamina="60"/>
			</player>
			<player id="Paul Connolly" name="Paul Connolly" birthday="29-09-1983" positions="fb" nationality="en" number="2">
				<stats passing="55" tackling="55" shooting="54" crossing="45" heading="50" dribbling="70" speed="65" stamina="70" aggression="55" strength="70" fitness="50" creativity="60"/>	
			</player>	
			<player id="Patrick Kisnorbo" name="Patrick Kisnorbo" birthday="24-03-1981" positions="fb" nationality="au" number="3">
				<stats passing="53" tackling="60" shooting="40" crossing="60" heading="63" dribbling="45" speed="65" stamina="68" aggression="58" strength="63" fitness="75" creativity="56"/>
			</player>
			<player id="Alex Bruce" name="Alex Bruce" birthday="28-09-1984" positions="cb" nationality="ir" number="4">
				<stats passing="75" tackling="45" shooting="53" crossing="58" heading="35" dribbling="63" speed="64" stamina="67" aggression="46" strength="47" fitness="64" creativity="57"/>
			</player>
			<player id="Neill Collins" name="Neill Collins" birthday="02-09-1983" positions="cb" nationality="sc" number="5">
				<stats passing="65" tackling="68" shooting="56" crossing="46" heading="67" dribbling="56" speed="72" stamina="66" aggression="72" strength="68" fitness="75" creativity="45"/>				
			</player>
			<player id="Richard Naylor" name="Richard Naylor" birthday="28-02-1977" positions="cb-cf" nationality="en" number="6">
				<stats passing="55" tackling="56" shooting="40" crossing="52" heading="57" dribbling="43" speed="68" stamina="67" aggression="65" strength="57" fitness="68" creativity="45"/>				
			</player>
			<player id="Max Gradel" name="Max Gradel" birthday="30-11-1987" positions="sm-wf-cf" nationality="iv" number="7">
				<stats passing="68" tackling="46" shooting="64" crossing="63" heading="34" dribbling="67" speed="61" stamina="58" aggression="48" strength="56" fitness="37" creativity="74"/>
			</player>
			<player id="Neil Kilkenny" name="Neil Kilkenny" birthday="19-12-1985" positions="cm" nationality="au" number="8">
				<stats passing="72" tackling="43" shooting="68" crossing="67" heading="43" dribbling="75" speed="64" stamina="64" aggression="57" strength="42" fitness="60" creativity="56"/>
			</player>
<player id="Billy Paynter" name="Billy Paynter" birthday="13-07-1984" positions="cf" nationality="en" number="9">
				<stats passing="65" tackling="56" shooting="69" crossing="67" heading="67" dribbling="73" speed="65" stamina="67" aggression="69" strength="60" fitness="60" creativity="67"/>
			</player>	
			<player id="Luciano Becchio" name="Luciano Becchio" birthday="28-12-1983" positions="cf" nationality="ar" number="10">
				<stats passing="65" tackling="56" shooting="69" crossing="67" heading="67" dribbling="73" speed="65" stamina="67" aggression="69" strength="60" fitness="60" creativity="67"/>
			</player>
			<player id="Lloyd Sam" name="Lloyd Sam" birthday="27-09-1984" positions="cm-am" nationality="sm-wf" number="11">
				<stats passing="53" tackling="34" shooting="62" crossing="67" heading="45" dribbling="69" speed="64" stamina="68" aggression="45" strength="49" fitness="61" creativity="64"/>	
			</player>
			<player id="Shane Higgs" name="Shane Higgs" birthday="13-05-1977" positions="gk" nationality="en" number="12">
				<stats passing="49" tackling="32" shooting="64" crossing="68" heading="43" dribbling="66" speed="84" stamina="45" aggression="37" strength="46" fitness="57" creativity="51"/>	
			</player>
			<player id="Jonny Howson" name="Jonny Howson" birthday="21-05-1988" positions="cm" nationality="en" number="14">
				<stats passing="73" tackling="56" shooting="61" crossing="63" heading="45" dribbling="58" speed="68" stamina="68" aggression="64" strength="62" fitness="64" creativity="63"/>
			</player>
			<player id="Bradley Johnson" name="Bradley Johnson" birthday="28-04-1987" positions="cm-sm" nationality="en" number="16">
				<stats passing="71" tackling="61" shooting="68" crossing="67" heading="45" dribbling="65" speed="68" stamina="67" aggression="68" strength="69" fitness="60" creativity="57"/>	
			</player>
			<player id="Amdy Faye" name="Amdy Faye" birthday="12-03-1977" positions="cm-cb" nationality="se" number="17">
				<stats passing="40" tackling="69" shooting="56" crossing="56" heading="56" dribbling="66" speed="61" stamina="67" aggression="64" strength="66" fitness="69" creativity="55"/>		
			</player>
			<player id="Ben Parker" name="Ben Parker" birthday="08-11-1987" positions="fb" nationality="en" number="19">
				<stats passing="57" tackling="69" shooting="43" crossing="53" heading="67" dribbling="31" speed="67" stamina="77" aggression="67" strength="72" fitness="74" creativity="46"/>		
			</player>
			<player id="Jason Crowe" name="Jason Crowe" birthday="30-09-1978" positions="fb" nationality="en" number="20">
				<stats passing="78" tackling="56" shooting="61" crossing="67" heading="25" dribbling="73" speed="69" stamina="67" aggression="69" strength="68" fitness="70" creativity="73"/>		
			</player>
			<player id="Federico Bessone" name="Federico Bessone" birthday="23-01-1984" positions="fb" nationality="ar" number="21">
				<stats passing="50" tackling="67" shooting="58" crossing="45" heading="72" dribbling="42" speed="64" stamina="56" aggression="64" strength="63" fitness="34" creativity="41"/>	
			</player>
			<player id="Andy Hughes" name="Andy Hughes" birthday="02-01-1978" positions="sm-fb" nationality="en" number="22">
				<stats catching="50" shotStopping="76" distribution="60" fitness="67" stamina="84"/>		
			</player>
			<player id="Robert Snodgrass" name="Robert Snodgrass" birthday="07-09-1987" positions="cf-sm" nationality="sc" number="23">
				<stats passing="59" tackling="68" shooting="38" crossing="47" heading="53" dribbling="55" speed="69" stamina="72" aggression="64" strength="56" fitness="78" creativity="67"/>		
			</player>
			<player id="Leigh Bromby" name="Leigh Bromby" birthday="02-06-1980" positions="cb-fb" nationality="en" number="26">
				<stats passing="67" tackling="27" shooting="74" crossing="57" heading="23" dribbling="72" speed="73" stamina="43" aggression="48" strength="34" fitness="67" creativity="73"/>		
			</player>
			<player id="Davide Somma" name="Davide Somma" birthday="26-03-1985" positions="cf" nationality="sa" number="27">
				<stats passing="69" tackling="67" shooting="45" crossing="56" heading="59" dribbling="71" speed="72" stamina="65" aggression="46" strength="59" fitness="70" creativity="67"/>		
			</player>
			<player id="George McCartney" name="George McCartney" birthday="29-04-1981" positions="cb" nationality="ni" number="29">
				<stats passing="65" tackling="67" shooting="67" crossing="56" heading="56" dribbling="64" speed="62" stamina="67" aggression="57" strength="67" fitness="67" creativity="73"/>	
			</player>
		</players>	
	</club>
	<club shirtColor="0xFF0000" sleevesColor="0xFFFFFF" stripesType="none">
		<name><![CDATA[Nottingham Forest]]></name>
		<profile>70</profile>
		<players>
			<player id="Lee Camp" name="Lee Camp" birthday="22-08-1984" positions="gk" nationality="en" number="1">
				<stats catching="75" shotStopping="80" distribution="50" fitness="70" stamina="60"/>
			</player>
			<player id="Ryan Bertrand" name="Ryan Bertrand" birthday="05-08-1989" positions="fb" nationality="en" number="3">
				<stats passing="55" tackling="55" shooting="54" crossing="45" heading="50" dribbling="70" speed="65" stamina="70" aggression="55" strength="70" fitness="50" creativity="60"/>	
			</player>	
			<player id="Luke Chambers" name="Luke Chambers" birthday="28-09-1985" positions="cb" nationality="ir" number="4">
				<stats passing="75" tackling="45" shooting="53" crossing="58" heading="35" dribbling="63" speed="64" stamina="67" aggression="46" strength="47" fitness="64" creativity="57"/>
			</player>
			<player id="Wes Morgan" name="Wes Morgan" birthday="21-01-1984" positions="cb" nationality="en" number="5">
				<stats passing="65" tackling="68" shooting="56" crossing="46" heading="67" dribbling="56" speed="72" stamina="66" aggression="72" strength="68" fitness="75" creativity="45"/>		
			</player>
			<player id="Kelvin Wilson" name="Kelvin Wilson" birthday="03-09-1985" positions="cb-fb" nationality="en" number="6">
				<stats passing="55" tackling="56" shooting="40" crossing="52" heading="57" dribbling="43" speed="68" stamina="67" aggression="65" strength="57" fitness="68" creativity="45"/>				
			</player>
			<player id="Paul Anderson" name="Paul Anderson" birthday="23-07-1988" positions="sm" nationality="en" number="7">
				<stats passing="68" tackling="46" shooting="64" crossing="63" heading="34" dribbling="67" speed="61" stamina="58" aggression="48" strength="56" fitness="37" creativity="74"/>
			</player>
			<player id="Lewis McGugan" name="Lewis McGugan" birthday="25-10-1988" positions="cm-am" nationality="en" number="8">
				<stats passing="72" tackling="43" shooting="68" crossing="67" heading="43" dribbling="75" speed="64" stamina="64" aggression="57" strength="42" fitness="60" creativity="56"/>
			</player>
			<player id="Dele Adebola" name="Dele Adebola" birthday="23-06-1975" positions="cf" nationality="ng" number="9">
				<stats passing="65" tackling="56" shooting="69" crossing="67" heading="67" dribbling="73" speed="65" stamina="67" aggression="69" strength="60" fitness="60" creativity="67"/>
			</player>
			<player id="Rob Earnshaw" name="Rob Earnshaw" birthday="06-04-1981" positions="cf" nationality="we" number="10">
				<stats passing="65" tackling="56" shooting="69" crossing="67" heading="67" dribbling="73" speed="65" stamina="67" aggression="69" strength="60" fitness="60" creativity="67"/>
			</player>
			<player id="Nathan Tyson" name="Nathan Tyson" birthday="04-05-1982" positions="cf" nationality="en" number="11">
				<stats passing="53" tackling="34" shooting="62" crossing="67" heading="45" dribbling="69" speed="64" stamina="68" aggression="45" strength="49" fitness="61" creativity="64"/>	
			</player>
			<player id="Garath McCleary" name="Garath McCleary" birthday="15-05-1987" positions="sm" nationality="en" number="12">
				<stats passing="49" tackling="32" shooting="64" crossing="68" heading="43" dribbling="66" speed="84" stamina="45" aggression="37" strength="46" fitness="57" creativity="51"/>	
			</player>
			<player id="Chris Cohen" name="Chris Cohen" birthday="05-03-1987" positions="cm-fb-sm" nationality="en" number="15">
				<stats passing="73" tackling="56" shooting="61" crossing="63" heading="45" dribbling="58" speed="68" stamina="68" aggression="64" strength="62" fitness="64" creativity="63"/>
			</player>
			<player id="Chris Gunter" name="Chris Gunter" birthday="21-07-1989" positions="fb" nationality="we" number="16">
				<stats passing="71" tackling="61" shooting="68" crossing="67" heading="45" dribbling="65" speed="68" stamina="67" aggression="68" strength="69" fitness="60" creativity="57"/>	
			</player>
			<player id="David McGoldrick" name="David McGoldrick" birthday="29-11-1987" positions="am-cf" nationality="en" number="17">
				<stats passing="40" tackling="69" shooting="56" crossing="56" heading="56" dribbling="66" speed="61" stamina="67" aggression="64" strength="66" fitness="69" creativity="55"/>		
			</player>
			<player id="Paul McKenna" name="Paul McKenna" birthday="20-10-1977" positions="cm" nationality="en" number="18">
				<stats passing="57" tackling="69" shooting="43" crossing="53" heading="67" dribbling="31" speed="67" stamina="77" aggression="67" strength="72" fitness="74" creativity="46"/>		
			</player>
			<player id="Guy Moussi" name="Guy Moussi" birthday="23-01-1985" positions="cm-sm" nationality="fr" number="19">
				<stats passing="78" tackling="56" shooting="61" crossing="67" heading="25" dribbling="73" speed="69" stamina="67" aggression="69" strength="68" fitness="70" creativity="73"/>		
			</player>
			<player id="Marcus Tudgay" name="Marcus Tudgay" birthday="03-02-1983" positions="cf-sm" nationality="en" number="20">
				<stats passing="50" tackling="67" shooting="58" crossing="45" heading="72" dribbling="42" speed="64" stamina="56" aggression="64" strength="63" fitness="34" creativity="41"/>	
			</player>
			<player id="Paul Smith" name="Paul Smith" birthday="17-12-1979" positions="gk" nationality="en" number="21">
				<stats catching="50" shotStopping="76" distribution="60" fitness="67" stamina="84"/>		
			</player>
			<player id="Dexter Blackstock" name="Dexter Blackstock" birthday="20-05-1986" positions="cf" nationality="en" number="23">
				<stats passing="59" tackling="68" shooting="38" crossing="47" heading="53" dribbling="55" speed="69" stamina="72" aggression="64" strength="56" fitness="78" creativity="67"/>		
			</player>
			<player id="Matt Thornhill" name="Matt Thornhill" birthday="11-09-1988" positions="cm-sm" nationality="en" number="26">
				<stats passing="67" tackling="27" shooting="74" crossing="57" heading="23" dribbling="72" speed="73" stamina="43" aggression="48" strength="34" fitness="67" creativity="73"/>		
			</player>
			<player id="Brendan Moloney" name="Brendan Moloney" birthday="18-01-1989" positions="fb-cb" nationality="ir" number="27">
				<stats passing="69" tackling="67" shooting="45" crossing="56" heading="59" dribbling="71" speed="72" stamina="65" aggression="46" strength="59" fitness="70" creativity="67"/>		
			</player>
			<player id="Radoslaw Majewski" name="Radoslaw Majewski" birthday="15-12-1986" positions="am-cf" nationality="po" number="28">
				<stats passing="65" tackling="67" shooting="67" crossing="56" heading="56" dribbling="64" speed="62" stamina="67" aggression="57" strength="67" fitness="67" creativity="73"/>		
			</player>
		</players>	
	</club>
	<club shirtColor="0xFF0000" sleevesColor="0xFFFFFF" stripesType="none">
		<name><![CDATA[Middlesbrough]]></name>
		<profile>60</profile>
		<players>
			<player id="Jason Steele" name="Jason Steele" birthday="18-08-1990" positions="gk" nationality="en" number="30">
				<stats catching="75" shotStopping="80" distribution="50" fitness="70" stamina="60"/>
			</player>
			<player id="Justin Hoyte" name="Justin Hoyte" birthday="20-11-1984" positions="fb" nationality="en" number="2">
				<stats passing="55" tackling="55" shooting="54" crossing="45" heading="50" dribbling="70" speed="65" stamina="70" aggression="55" strength="70" fitness="50" creativity="60"/>	
			</player>	
			<player id="Marvin Emnes" name="Marvin Emnes" birthday="27-05-1988" positions="sm" nationality="ne" number="32">
				<stats passing="53" tackling="60" shooting="40" crossing="60" heading="63" dribbling="45" speed="65" stamina="68" aggression="58" strength="63" fitness="75" creativity="56"/>
			</player>
			<player id="Matthew Bates" name="Matthew Bates" birthday="10-12-1986" positions="dm-cb" nationality="en" number="4">
				<stats passing="75" tackling="45" shooting="53" crossing="58" heading="35" dribbling="63" speed="64" stamina="67" aggression="46" strength="47" fitness="64" creativity="57"/>
			</player>
			<player id="David Wheater" name="David Wheater" birthday="14-02-1987" positions="cb-fb" nationality="en" number="5">
				<stats passing="65" tackling="68" shooting="56" crossing="46" heading="67" dribbling="56" speed="72" stamina="66" aggression="72" strength="68" fitness="75" creativity="45"/>				
			</player>
			<player id="Stephen McManus" name="Stephen McManus" birthday="10-09-1982" positions="cb" nationality="sc" number="6">
				<stats passing="55" tackling="56" shooting="40" crossing="52" heading="57" dribbling="43" speed="68" stamina="67" aggression="65" strength="57" fitness="68" creativity="45"/>				
			</player>
			<player id="Scott McDonald" name="Scott McDonald" birthday="21-08-1983" positions="cf" nationality="en" number="7">
				<stats passing="68" tackling="46" shooting="64" crossing="63" heading="34" dribbling="67" speed="61" stamina="58" aggression="48" strength="56" fitness="37" creativity="74"/>
			</player>
			<player id="Kevin Thomson" name="Kevin Thomson" birthday="14-10-1984" positions="cm" nationality="sc" number="8">
				<stats passing="72" tackling="43" shooting="68" crossing="67" heading="43" dribbling="75" speed="64" stamina="64" aggression="57" strength="42" fitness="60" creativity="56"/>
			</player>
			<player id="Kris Boyd" name="Kris Boyd" birthday="18-08-1983" positions="cf" nationality="sc" number="9">
				<stats passing="65" tackling="56" shooting="69" crossing="67" heading="67" dribbling="73" speed="65" stamina="67" aggression="69" strength="60" fitness="60" creativity="67"/>
			</player>
			<player id="Nicky Bailey" name="Nicky Bailey" birthday="10-06-1984" positions="cm" nationality="en" number="10">
				<stats passing="65" tackling="56" shooting="69" crossing="67" heading="67" dribbling="73" speed="65" stamina="67" aggression="69" strength="60" fitness="60" creativity="67"/>
			</player>
			<player id="Tarmo Kink" name="Tarmo Kink" birthday="06-10-1985" positions="sm-cf" nationality="es" number="11">
				<stats passing="53" tackling="34" shooting="62" crossing="67" heading="45" dribbling="69" speed="64" stamina="68" aggression="45" strength="49" fitness="61" creativity="64"/>	
			</player>
			<player id="Willo Flood" name="Willo Flood" birthday="10-04-1985" positions="cm-sm" nationality="ir" number="14">
				<stats passing="73" tackling="56" shooting="61" crossing="63" heading="45" dribbling="58" speed="68" stamina="68" aggression="64" strength="62" fitness="64" creativity="63"/>
			</player>
			<player id="Leroy Lita" name="Leroy Lita" birthday="28-12-1984" positions="cf" nationality="co" number="15">
				<stats passing="71" tackling="61" shooting="68" crossing="67" heading="45" dribbling="65" speed="68" stamina="67" aggression="68" strength="69" fitness="60" creativity="57"/>	
			</player>
			<player id="Barry Robson" name="Barry Robson" birthday="07-11-1978" positions="cm-sm-fb" nationality="sc" number="17">
				<stats passing="71" tackling="61" shooting="68" crossing="67" heading="45" dribbling="65" speed="68" stamina="67" aggression="68" strength="69" fitness="60" creativity="57"/>	
			</player>
			<player id="Gary O'Neill" name="Gary O'Neill" birthday="18-05-1983" positions="sm-cm" nationality="en" number="18">
				<stats passing="40" tackling="69" shooting="56" crossing="56" heading="56" dribbling="66" speed="61" stamina="67" aggression="64" strength="66" fitness="69" creativity="55"/>		
			</player>
			<player id="Andrew Halliday" name="Andrew Halliday" birthday="11-10-1991" positions="sm" nationality="sc" number="19">
				<stats passing="57" tackling="69" shooting="43" crossing="53" heading="67" dribbling="31" speed="67" stamina="77" aggression="67" strength="72" fitness="74" creativity="46"/>		
			</player>
			<player id="Julio Arca" name="Julio Arca" birthday="31-01-1981" positions="sm-cm" nationality="ar" number="20">
				<stats passing="50" tackling="67" shooting="58" crossing="45" heading="72" dribbling="42" speed="64" stamina="56" aggression="64" strength="63" fitness="34" creativity="41"/>	
			</player>
			<player id="Danny Coyne" name="Danny Coyne" birthday="27-08-1973" positions="gk" nationality="we" number="21">
				<stats catching="50" shotStopping="76" distribution="60" fitness="67" stamina="84"/>		
			</player>
			<player id="Seb Hines" name="Seb Hines" birthday="29-05-1988" positions="cb-dm" nationality="en" number="24">
				<stats passing="59" tackling="68" shooting="38" crossing="47" heading="53" dribbling="55" speed="69" stamina="72" aggression="64" strength="56" fitness="78" creativity="67"/>		
			</player>
			<player id="Rhys Williams" name="Rhys Williams" birthday="14-07-1988" positions="fb-sm-cm" nationality="au" number="25">
				<stats passing="67" tackling="27" shooting="74" crossing="57" heading="23" dribbling="72" speed="73" stamina="43" aggression="48" strength="34" fitness="67" creativity="73"/>		
			</player>
			<player id="Joe Bennett" name="Joe Bennett" birthday="28-03-1990" positions="fb-sm" nationality="en" number="27">
				<stats passing="69" tackling="67" shooting="45" crossing="56" heading="59" dribbling="71" speed="72" stamina="65" aggression="46" strength="59" fitness="70" creativity="67"/>		
			</player>
			<player id="Tony McMahon" name="Tony McMahon" birthday="24-03-1986" positions="fb" nationality="en" number="29">
				<stats passing="65" tackling="67" shooting="67" crossing="56" heading="56" dribbling="64" speed="62" stamina="67" aggression="57" strength="67" fitness="67" creativity="73"/>
			</player>
		</players>	
	</club>
	<club shirtColor="0xFF0000" sleevesColor="0xFFFFFF" stripesType="none">
		<name><![CDATA[Derby County]]></name>
		<profile>65</profile>
		<players>
			<player id="Stephen Bywater" name="Stephen Bywater" birthday="07-01-1981" positions="gk" nationality="en" number="1">
				<stats catching="75" shotStopping="80" distribution="50" fitness="70" stamina="60"/>
			</player>
			<player id="John Brayford" name="John Brayford" birthday="29-12-1987" positions="fb" nationality="en" number="2">
				<stats passing="55" tackling="55" shooting="54" crossing="45" heading="50" dribbling="70" speed="65" stamina="70" aggression="55" strength="70" fitness="50" creativity="60"/>	
			</player>	
			<player id="Gareth Roberts" name="Gareth Roberts" birthday="06-02-1978" positions="fb" nationality="we" number="3">
				<stats passing="53" tackling="60" shooting="40" crossing="60" heading="63" dribbling="45" speed="65" stamina="68" aggression="58" strength="63" fitness="75" creativity="56"/>
			</player>
			<player id="Paul Green" name="Paul Green" birthday="10-04-1983" positions="cm-am" nationality="ir" number="4">
				<stats passing="75" tackling="45" shooting="53" crossing="58" heading="35" dribbling="63" speed="64" stamina="67" aggression="46" strength="47" fitness="64" creativity="57"/>
			</player>
			<player id="Shaun Barker" name="Shaun Barker" birthday="19-09-1982" positions="cb" nationality="en" number="5">
				<stats passing="65" tackling="68" shooting="56" crossing="46" heading="67" dribbling="56" speed="72" stamina="66" aggression="72" strength="68" fitness="75" creativity="45"/>				
			</player>
			<player id="Dean Leacock" name="Dean Leacock" birthday="10-06-1984" positions="cb-fb" nationality="en" number="6">
				<stats passing="55" tackling="56" shooting="40" crossing="52" heading="57" dribbling="43" speed="68" stamina="67" aggression="65" strength="57" fitness="68" creativity="45"/>				
			</player>
			<player id="Steve Davies" name="Steve Davies" birthday="29-12-1987" positions="am-wf-cf" nationality="en" number="7">
				<stats passing="68" tackling="46" shooting="64" crossing="63" heading="34" dribbling="67" speed="61" stamina="58" aggression="48" strength="56" fitness="37" creativity="74"/>
			</player>
			<player id="Robbie Savage" name="Robbie Savage" birthday="18-10-1974" positions="dm-cm" nationality="we" number="8">
				<stats passing="72" tackling="43" shooting="68" crossing="67" heading="43" dribbling="75" speed="64" stamina="64" aggression="57" strength="42" fitness="60" creativity="56"/>
			</player>
			<player id="Kris Commons" name="Kris Commons" birthday="30-08-1983" positions="am-cf-wf" nationality="sc" number="10">
				<stats passing="65" tackling="56" shooting="69" crossing="67" heading="67" dribbling="73" speed="65" stamina="67" aggression="69" strength="60" fitness="60" creativity="67"/>
			</player>
			<player id="Stephen Pearson" name="Stephen Pearson" birthday="02-10-1982" positions="cm-am" nationality="sc" number="11">
				<stats passing="53" tackling="34" shooting="62" crossing="67" heading="45" dribbling="69" speed="64" stamina="68" aggression="45" strength="49" fitness="61" creativity="64"/>	
			</player>
			<player id="Chris Porter" name="Chris Porter" birthday="12-12-1983" positions="cf" nationality="en" number="12">
				<stats passing="49" tackling="32" shooting="64" crossing="68" heading="43" dribbling="66" speed="84" stamina="45" aggression="37" strength="46" fitness="57" creativity="51"/>	
			</player>
			<player id="Russell Anderson" name="Russell Anderson" birthday="25-10-1978" positions="cm-dm" nationality="sc" number="14">
				<stats passing="73" tackling="56" shooting="61" crossing="63" heading="45" dribbling="58" speed="68" stamina="68" aggression="64" strength="62" fitness="64" creativity="63"/>
			</player>
			<player id="David Martin" name="David Martin" birthday="03-06-1985" positions="am" nationality="en" number="16">
				<stats passing="71" tackling="61" shooting="68" crossing="67" heading="45" dribbling="65" speed="68" stamina="67" aggression="68" strength="69" fitness="60" creativity="57"/>	
			</player>
			<player id="James Bailey" name="James Bailey" birthday="18-09-1988" positions="fb-cm" nationality="en" number="16">
				<stats passing="40" tackling="69" shooting="56" crossing="56" heading="56" dribbling="66" speed="61" stamina="67" aggression="64" strength="66" fitness="69" creativity="55"/>		
			</player>
			<player id="Jake Buxton" name="Jake Buxton" birthday="11-08-1980" positions="cb" nationality="fr" number="18">
				<stats passing="57" tackling="69" shooting="43" crossing="53" heading="67" dribbling="31" speed="67" stamina="77" aggression="67" strength="72" fitness="74" creativity="46"/>		
			</player>
			<player id="Ben Pringle" name="Ben Pringle" birthday="01-01-1992" positions="cm-am-wf" nationality="en" number="19">
				<stats passing="78" tackling="56" shooting="61" crossing="67" heading="25" dribbling="73" speed="69" stamina="67" aggression="69" strength="68" fitness="70" creativity="73"/>		
			</player>
			<player id="Tomasz Cywka" name="Tomasz Cywka" birthday="01-18-1987" positions="cb-fb" nationality="sw" number="20">
				<stats passing="50" tackling="67" shooting="58" crossing="45" heading="72" dribbling="42" speed="64" stamina="56" aggression="64" strength="63" fitness="34" creativity="41"/>	
			</player>
			<player id="Saul Deeney" name="Saul Deeney" birthday="23-03-1983" positions="gk" nationality="ir" number="13">
				<stats catching="50" shotStopping="76" distribution="60" fitness="67" stamina="84"/>		
			</player>
			<player id="Miles Addison" name="Miles Addison" birthday="26-07-1985" positions="fb" nationality="fr" number="22">
				<stats passing="59" tackling="68" shooting="38" crossing="47" heading="53" dribbling="55" speed="69" stamina="72" aggression="64" strength="56" fitness="78" creativity="67"/>		
			</player>
			<player id="Dean Moxey" name="Dean Moxey" birthday="29-05-1981" positions="am-wf" nationality="ru" number="23">
				<stats passing="67" tackling="27" shooting="74" crossing="57" heading="23" dribbling="72" speed="73" stamina="43" aggression="48" strength="34" fitness="67" creativity="73"/>		
			</player>
			<player id="Conor Doyle" name="Conor Doyle" birthday="04-06-1983" positions="fb-sm" nationality="iv" number="27">
				<stats passing="69" tackling="67" shooting="45" crossing="56" heading="59" dribbling="71" speed="72" stamina="65" aggression="46" strength="59" fitness="70" creativity="67"/>		
			</player>
			<player id="Alberto Bueno" name="Alberto Bueno" birthday="26-09-1989" positions="fb-sm" nationality="en" number="28">
				<stats passing="65" tackling="67" shooting="67" crossing="56" heading="56" dribbling="64" speed="62" stamina="67" aggression="57" strength="67" fitness="67" creativity="73"/>		
			</player>
		</players>	
	</club>
</data>;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.club.length())
         {
            _loc2_.addEntrant(TeamHelper.makeClub(_loc3_.club[_loc4_]));
            _loc4_++;
         }
         return _loc2_;
      }
      
      private static function makeEuroclubs() : League
      {
         var _loc4_:Club = null;
         var _loc1_:XML = <data>
<club shirtColor="0xFF0000" sleevesColor="0xFFFFFF" stripesType="none">
		<name><![CDATA[Real Madrid]]></name>
		<profile>100</profile>
		<players>
			<player id="Iker Casillas" name="Iker Casillas" birthday="20-05-1981" positions="gk" nationality="es" number="1">
				<stats catching="84" shotStopping="85" distribution="78" fitness="75" stamina="85"/>
			</player>
			<player id="Ricardo Carvalho" name="Ricardo Carvalho" birthday="18-05-1978" positions="fb" nationality="pr" number="2">
				<stats passing="59" tackling="65" shooting="40" crossing="69" heading="54" dribbling="70" speed="89" stamina="64" aggression="70" strength="59" fitness="83" creativity="63"/>	
			</player>	
			<player id="Pepe" name="Pepe" birthday="26-02-1983" positions="fb" nationality="pr" number="3">
				<stats passing="53" tackling="70" shooting="33" crossing="70" heading="55" dribbling="54" speed="60" stamina="77" aggression="69" strength="44" fitness="73" creativity="64"/>
			</player>
			<player id="Fernando Gago" name="Fernando Gago" birthday="10-04-1986" positions="dm" nationality="ar" number="5">
				<stats passing="77" tackling="84" shooting="40" crossing="59" heading="77" dribbling="49" speed="65" stamina="79" aggression="59" strength="79" fitness="49" creativity="64"/>
			</player>
			<player id="Sergio Ramos" name="Sergio Ramos" birthday="30-03-1986" positions="fb" nationality="es" number="4">
				<stats passing="65" tackling="85" shooting="45" crossing="65" heading="50" dribbling="65" speed="85" stamina="90" aggression="80" strength="60" fitness="90" creativity="55"/>				
			</player>
			<player id="Marcelo" name="Marcelo" birthday="12-05-1988" positions="fb-cb-sm" nationality="br" number="12">
				<stats passing="63" tackling="80" shooting="35" crossing="30" heading="91" dribbling="45" speed="50" stamina="75" aggression="80" strength="80" fitness="81" creativity="53"/>				
			</player>
			<player id="Mahamadou Diarra" name="Mahamadou Diarra" birthday="18-05-1981" positions="dm" nationality="ma" number="6">
				<stats passing="77" tackling="70" shooting="50" crossing="27" heading="83" dribbling="46" speed="57" stamina="72" aggression="58" strength="82" fitness="74" creativity="62"/>
			</player>
			<player id="Angel di Maria" name="Angel di Maria" birthday="14-02-1988" positions="sm" nationality="ar" number="22">
				<stats passing="66" tackling="67" shooting="44" crossing="77" heading="17" dribbling="75" speed="89" stamina="82" aggression="74" strength="43" fitness="67" creativity="62"/>
			</player>
			<player id="Mesut Ozil" name="Mesut Ozil" birthday="15-10-1988" positions="am-sm-cm" nationality="ge" number="23">
				<stats passing="82" tackling="64" shooting="72" crossing="64" heading="57" dribbling="54" speed="79" stamina="100" aggression="89" strength="86" fitness="100" creativity="69"/>
			</player>
			<player id="Cristiano Ronaldo" name="Cristiano Ronaldo" birthday="05-02-1985" positions="sm-wf-cf" nationality="pr" number="7">
				<stats passing="79" tackling="54" shooting="86" crossing="80" heading="76" dribbling="97" speed="94" stamina="88" aggression="66" strength="60" fitness="83" creativity="90"/>	
			</player>
			<player id="Kaka" name="Kaka" birthday="22-04-1982" positions="am-cm" nationality="br" number="8">
				<stats passing="88" tackling="67" shooting="80" crossing="79" heading="65" dribbling="80" speed="79" stamina="78" aggression="63" strength="53" fitness="79" creativity="63"/>	
			</player>
			<player id="Esteban Granero" name="Esteban Granero" birthday="02-07-1987" positions="cm-am" nationality="es" number="11">
				<stats passing="80" tackling="31" shooting="54" crossing="62" heading="27" dribbling="79" speed="68" stamina="71" aggression="33" strength="29" fitness="68" creativity="71"/>
			</player>
			<player id="Sergio Canales" name="Sergio Canales" birthday="16-02-1991" positions="am" nationality="es" number="16">
				<stats passing="64" tackling="38" shooting="73" crossing="76" heading="59" dribbling="58" speed="74" stamina="88" aggression="31" strength="57" fitness="70" creativity="75"/>	
			</player>
			<player id="Xabi Alonso" name="Xavi Alonso" birthday="25-11-1981" positions="cm" nationality="es" number="14">
				<stats passing="84" tackling="51" shooting="82" crossing="51" heading="59" dribbling="61" speed="63" stamina="88" aggression="63" strength="63" fitness="96" creativity="81"/>		
			</player>
			<player id="Pedro Leon" name="Pedro Leon" birthday="24-11-1986" positions="sm" nationality="es" number="21">
				<stats passing="54" tackling="33" shooting="53" crossing="63" heading="64" dribbling="65" speed="75" stamina="77" aggression="38" strength="55" fitness="80" creativity="65"/>		
			</player>
			<player id="Karim Benzema" name="Karim Benzema" birthday="19-12-1987" positions="cf" nationality="fr" number="9">
				<stats passing="54" tackling="36" shooting="88" crossing="63" heading="59" dribbling="71" speed="80" stamina="65" aggression="67" strength="64" fitness="84" creativity="67"/>		
			</player>
			<player id="Lassana Diarra" name="Lassana Diarra" birthday="10-03-1985" positions="dm" nationality="fr" number="10">
				<stats passing="77" tackling="80" shooting="65" crossing="34" heading="42" dribbling="68" speed="80" stamina="69" aggression="54" strength="58" fitness="75" creativity="62"/>	
			</player>
			<player id="Antonio Adan" name="Antonio Adan" birthday="13-05-1987" positions="gk" nationality="es" number="13">
				<stats catching="70" shotStopping="75" distribution="63" fitness="75" stamina="71"/>		
			</player>
			<player id="Gonzalo Higuain" name="Gonzalo Higuain" birthday="10-12-1987" positions="cf" nationality="ar" number="20">
				<stats passing="55" tackling="34" shooting="89" crossing="75" heading="91" dribbling="65" speed="75" stamina="80" aggression="68" strength="100" fitness="91" creativity="55"/>		
			</player>
			<player id="Jerzy Dudek" name="Jerzy Dudek" birthday="23-03-1973" positions="gk" nationality="po" number="26">
				<stats catching="80" shotStopping="88" distribution="64" fitness="39" stamina="55"/>		
			</player>
		</players>
	</club>

<club shirtColor="0xFF0000" sleevesColor="0xFFFFFF" stripesType="none">
		<name><![CDATA[Barcelona]]></name>
		<profile>95</profile>
		<players>
			<player id="Victor Valdes" name="Victor Valdes" birthday="14-01-1982" positions="gk" nationality="es" number="1">
				<stats catching="84" shotStopping="74" distribution="85" fitness="52" stamina="59"/>
			</player>
			<player id="Gabriel Milito" name="Gabriel Milito" birthday="07-09-1980" positions="cb" nationality="ar" number="182">
				<stats passing="51" tackling="68" shooting="24" crossing="53" heading="78" dribbling="34" speed="59" stamina="71" aggression="41" strength="78" fitness="63" creativity="34"/>	
			</player>	
			<player id="Gerald Pique" name="Gerald Pique" birthday="02-02-1987" positions="fb" nationality="es" number="3">
				<stats passing="43" tackling="88" shooting="3" crossing="52" heading="83" dribbling="32" speed="68" stamina="79" aggression="78" strength="76" fitness="68" creativity="22"/>
			</player>
			<player id="Carles Puyol" name="Carles Puyol" birthday="13-04-1978" positions="cb" nationality="es" number="5">
				<stats passing="64" tackling="79" shooting="17" crossing="23" heading="79" dribbling="48" speed="72" stamina="69" aggression="36" strength="72" fitness="49" creativity="44"/>
			</player>
			<player id="Adriano" name="Adriano" birthday="26-10-1984" positions="cb-cm" nationality="br" number="21">
				<stats passing="62" tackling="74" shooting="32" crossing="24" heading="76" dribbling="32" speed="58" stamina="69" aggression="58" strength="69" fitness="74" creativity="38"/>				
			</player>
			<player id="Eric Abidal" name="Eric Abidal" birthday="11-09-1979" positions="cb-fb" nationality="fr" number="22">
				<stats passing="54" tackling="84" shooting="26" crossing="12" heading="95" dribbling="17" speed="58" stamina="79" aggression="88" strength="89" fitness="77" creativity="31"/>				
			</player>
			<player id="Fabio" name="Fabio" birthday="09-070-1990" positions="fb" nationality="br" number="20">
				<stats passing="52" tackling="54" shooting="54" crossing="62" heading="48" dribbling="64" speed="83" stamina="49" aggression="62" strength="41" fitness="68" creativity="37"/>
			</player>
			<player id="Daniel Alves" name="Daniel Alves" birthday="06-05-1983" positions="fb" nationality="br" number="2">
				<stats passing="65" tackling="77" shooting="42" crossing="73" heading="69" dribbling="73" speed="88" stamina="89" aggression="74" strength="52" fitness="82" creativity="34"/>
			</player>
			<player id="Javier Mascherano" name="Javier Mascherano" birthday="08-06-1984" positions="dm-cm" nationality="ar" number="14">
				<stats passing="87" tackling="64" shooting="58" crossing="52" heading="51" dribbling="32" speed="59" stamina="72" aggression="29" strength="62" fitness="71" creativity="77"/>
			</player>
			<player id="Sergio Busquets" name="Sergio Busquets" birthday="16-07-1988" positions="dm-cm" nationality="es" number="16">
				<stats passing="63" tackling="79" shooting="53" crossing="83" heading="37" dribbling="47" speed="75" stamina="88" aggression="83" strength="68" fitness="64" creativity="47"/>	
			</player>
			<player id="Seydou Keita" name="Seydou Keita" birthday="16-01-1980" positions="cm" nationality="ma" number="15">
				<stats passing="73" tackling="74" shooting="42" crossing="74" heading="74" dribbling="32" speed="58" stamina="98" aggression="83" strength="75" fitness="82" creativity="67"/>	
			</player>
						<player id="Xavi" name="Xavi" birthday="25-01-1980" positions="cm" nationality="es" number="6">
				<stats passing="93" tackling="24" shooting="74" crossing="59" heading="72" dribbling="64" speed="41" stamina="38" aggression="68" strength="39" fitness="49" creativity="92"/>	
			</player>
						<player id="Andres Iniesta" name="Andres Iniesta" birthday="11-05-1984" positions="sm-cm-am" nationality="es" number="8">
				<stats passing="78" tackling="52" shooting="68" crossing="69" heading="38" dribbling="84" speed="66" stamina="54" aggression="50" strength="57" fitness="56" creativity="84"/>	
			</player>
			<player id="Jose Pinto" name="Jose Pinto" birthday="08-11-1975" positions="gk" nationality="es" number="13">
				<stats catching="74" shotStopping="83" distribution="54" fitness="74" stamina="58"/>		
			</player>
			<player id="Lionel Messi" name="Lionel Messi" birthday="24-06-1987" positions="cf-sm-am" nationality="ar" number="10">
				<stats passing="91" tackling="68" shooting="95" crossing="86" heading="55" dribbling="94" speed="82" stamina="88" aggression="23" strength="68" fitness="75" creativity="99"/>		
			</player>
			<player id="Bojan Krkic" name="Bojan Krkic" birthday="28-08-1990" positions="cf" nationality="es" number="9">
				<stats passing="58" tackling="34" shooting="82" crossing="58" heading="76" dribbling="54" speed="65" stamina="70" aggression="48" strength="50" fitness="51" creativity="53"/>		
			</player>
			<player id="Pedro Rodriguez" name="Pedro Rodriguez" birthday="28-07-1987" positions="cf-sm" nationality="es" number="17">
				<stats passing="59" tackling="25" shooting="74" crossing="44" heading="78" dribbling="55" speed="77" stamina="68" aggression="50" strength="34" fitness="73" creativity="57"/>		
			</player>
			<player id="David Villa" name="David Villa" birthday="03-12-1981" positions="cf" nationality="es" number="7">
				<stats passing="79" tackling="39" shooting="84" crossing="74" heading="75" dribbling="59" speed="78" stamina="91" aggression="85" strength="78" fitness="82" creativity="79"/>		
			</player>
			<player id="Jeffren Suarez" name="Jeffren Suarez" birthday="20-01-1988" positions="sm" nationality="es" number="11">
				<stats passing="77" tackling="11" shooting="68" crossing="79" heading="56" dribbling="53" speed="69" stamina="46" aggression="38" strength="63" fitness="66" creativity="52"/>		
			</player>
			</players>
	</club>


<club shirtColor="0xFF0000" sleevesColor="0xFFFFFF" stripesType="none">
		<name><![CDATA[Bayern Munich]]></name>
		<profile>90</profile>
		<players>
			<player id="Hans Jorg Butt" name="Hans Jorg Butt" birthday="28-05-1974" positions="gk" nationality="ge" number="1">
				<stats catching="75" shotStopping="71" distribution="65" fitness="70" stamina="80"/>
			</player>
			<player id="Breno Borges" name="Breno Borges" birthday="13-10-1989" positions="cb" nationality="br" number="2">
				<stats passing="54" tackling="68" shooting="56" crossing="64" heading="75" dribbling="38" speed="74" stamina="68" aggression="54" strength="94" fitness="55" creativity="64"/>	
			</player>	
			<player id="Diego Contento" name="Diego Contento" birthday="01-05-1990" positions="fb" nationality="ge" number="26">
				<stats passing="52" tackling="64" shooting="24" crossing="58" heading="60" dribbling="43" speed="79" stamina="58" aggression="50" strength="54" fitness="89" creativity="39"/>
			</player>
			<player id="Danijel Pranjic" name="Danijel Pranjic" birthday="02-12-1981" positions="fb-dm" nationality="cr" number="23">
				<stats passing="54" tackling="74" shooting="38" crossing="54" heading="75" dribbling="54" speed="59" stamina="70" aggression="68" strength="68" fitness="68" creativity="48"/>
			</player>
			<player id="Edson Braafheid" name="Edson Braafheid" birthday="08-04-1983" positions="fb" nationality="ne" number="4">
				<stats passing="54" tackling="75" shooting="29" crossing="43" heading="79" dribbling="38" speed="75" stamina="78" aggression="75" strength="75" fitness="78" creativity="43"/>				
			</player>
			<player id="Holger Badstuber" name="Holger Badstuber" birthday="13-03-1989" positions="cb-fb" nationality="ge" number="28">
				<stats passing="58" tackling="84" shooting="49" crossing="23" heading="79" dribbling="54" speed="67" stamina="79" aggression="74" strength="74" fitness="75" creativity="45"/>				
			</player>
			<player id="Daniel Van Buyten" name="Daniel Van Buyten" birthday="07-02-1978" positions="cb" nationality="ne" number="5">
				<stats passing="57" tackling="75" shooting="20" crossing="19" heading="84" dribbling="18" speed="58" stamina="79" aggression="68" strength="73" fitness="70" creativity="54"/>
			</player>
			<player id="Martin Demichelis" name="Martin Demichelis" birthday="20-12-1980" positions="cb" nationality="ar" number="6">
				<stats passing="53" tackling="80" shooting="12" crossing="26" heading="73" dribbling="39" speed="68" stamina="44" aggression="69" strength="84" fitness="30" creativity="44"/>
			</player>
			<player id="Philipp Lahm" name="Philipp Lahm" birthday="11-11-1983" positions="fb" nationality="ge" number="21">
				<stats passing="65" tackling="64" shooting="63" crossing="75" heading="74" dribbling="70" speed="70" stamina="78" aggression="23" strength="62" fitness="73" creativity="65"/>	
			</player>
			<player id="Andreas Ottl" name="Andreas Ottl" birthday="01-03-1985" positions="dm" nationality="ge" number="16">
				<stats passing="77" tackling="64" shooting="54" crossing="52" heading="59" dribbling="60" speed="43" stamina="75" aggression="70" strength="90" fitness="78" creativity="79"/>
			</player>
			<player id="Mark van Bommel" name="Mark van Bommel" birthday="22-04-1977" positions="cm-dm" nationality="ne" number="17">
				<stats passing="63" tackling="64" shooting="55" crossing="60" heading="58" dribbling="59" speed="75" stamina="75" aggression="54" strength="64" fitness="70" creativity="57"/>	
			</player>
			<player id="Anatoliy Tymoshchuk" name="Anatoliy Tymoshchuk" birthday="30-03-1979" positions="cm-sm" nationality="uk" number="44">
				<stats passing="68" tackling="53" shooting="57" crossing="64" heading="37" dribbling="53" speed="56" stamina="75" aggression="54" strength="52" fitness="67" creativity="70"/>		
			</player>
			<player id="Hamit Altintop" name="Hamit Altintop" birthday="08-12-1982" positions="cm" nationality="tu" number="8">
				<stats passing="53" tackling="79" shooting="45" crossing="34" heading="78" dribbling="74" speed="80" stamina="87" aggression="70" strength="84" fitness="59" creativity="54"/>		
			</player>
			<player id="Bastien Schweinsteiger" name="Bastien Schweinsteiger" birthday="01-08-1984" positions="cm-am-sm" nationality="ge" number="31">
				<stats passing="74" tackling="41" shooting="44" crossing="58" heading="34" dribbling="78" speed="68" stamina="90" aggression="59" strength="46" fitness="78" creativity="84"/>		
			</player>
			<player id="Frank Ribery" name="Frank Ribery" birthday="07-04-1983" positions="sm" nationality="fr" number="7">
				<stats passing="84" tackling="38" shooting="79" crossing="75" heading="28" dribbling="69" speed="54" stamina="75" aggression="53" strength="50" fitness="62" creativity="78"/>	
			</player>
			<player id="Arjen Robben" name="Arjen Robben" birthday="23-01-1984" positions="cm-sm-am-cf" nationality="ne" number="5">
				<stats passing="79" tackling="44" shooting="83" crossing="80" heading="72" dribbling="52" speed="86" stamina="75" aggression="58" strength="65" fitness="83" creativity="75"/>		
			</player>
			<player id="Toni Kroos" name="Toni Kroos" birthday="04-01-1990" positions="sm-am" nationality="ge" number="39">
				<stats passing="68" tackling="34" shooting="47" crossing="70" heading="34" dribbling="79" speed="84" stamina="64" aggression="21" strength="38" fitness="75" creativity="70"/>		
			</player>
						<player id="Mario Gomez" name="Mario Gomez" birthday="10-07-1985" positions="cf" nationality="ge" number="33">
				<stats passing="70" tackling="50" shooting="79" crossing="44" heading="80" dribbling="54" speed="64" stamina="79" aggression="60" strength="65" fitness="94" creativity="64"/>		
			</player>
			<player id="Miroslav Klose" name="Miroslav Klose" birthday="09-06-1978" positions="cf" nationality="ge" number="18">
				<stats passing="59" tackling="41" shooting="79" crossing="45" heading="78" dribbling="64" speed="60" stamina="80" aggression="60" strength="70" fitness="75" creativity="70"/>		
			</player>
			<player id="Ivica Olic" name="Ivica Olic" birthday="14-09-1979" positions="cf" nationality="cr" number="11">
				<stats passing="64" tackling="39" shooting="74" crossing="64" heading="36" dribbling="73" speed="67" stamina="85" aggression="23" strength="54" fitness="75" creativity="75"/>		
			</player>
			<player id="Thomas Muller" name="Thomas Muller" birthday="13-09-1989" positions="cf-sm" nationality="ge" number="25">
				<stats passing="64" tackling="33" shooting="76" crossing="47" heading="64" dribbling="54" speed="59" stamina="68" aggression="44" strength="87" fitness="69" creativity="70"/>		
			</player>

			<player id="Rouven Sattelmaier" name="Rouven Sattelmaier" birthday="07-08-1987" positions="gk" nationality="ge" number="22">
				<stats catching="71" shotStopping="68" distribution="29" fitness="70" stamina="75"/>		
			</player>
		</players>
	</club>


<club shirtColor="0xFF0000" sleevesColor="0xFFFFFF" stripesType="none">
		<name><![CDATA[Schalke 04]]></name>
		<profile>75</profile>
		<players>
			<player id="Manuel Neuer" name="Manuel Neuer" birthday="27-03-1986" positions="gk" nationality="ge" number="1">
				<stats catching="66" shotStopping="70" distribution="50" fitness="70" stamina="70"/>
			</player>
			<player id="Benedikt Howedes" name="Benedikt Howedes" birthday="29-02-1988" positions="cb-dm" nationality="cb-dm" number="4">
				<stats passing="20" tackling="75" shooting="20" crossing="15" heading="75" dribbling="15" speed="60" stamina="70" aggression="60" strength="75" fitness="75" creativity="35"/>	
			</player>	
			<player id="Nicolas Plestan" name="Nicolas Plestan" birthday="02-06-1981" positions="fb-cb" nationality="fr" number="5">
				<stats passing="62" tackling="70" shooting="52" crossing="60" heading="72" dribbling="45" speed="75" stamina="72" aggression="54" strength="70" fitness="75" creativity="44"/>
			</player>
			<player id="Tim Hoogland" name="Tim Hoogland" birthday="11-06-1985" positions="fb-sm" nationality="ge" number="2">
				<stats passing="60" tackling="69" shooting="37" crossing="58" heading="50" dribbling="41" speed="62" stamina="78" aggression="77" strength="68" fitness="78" creativity="53"/>
			</player>
			<player id="Atsuto Uchida" name="Atsuto Uchida" birthday="27-03-1988" positions="fb" nationality="ja" number="22">
				<stats passing="69" tackling="77" shooting="30" crossing="72" heading="60" dribbling="57" speed="70" stamina="90" aggression="62" strength="66" fitness="75" creativity="60"/>				
			</player>
			<player id="Christoph Metzelder" name="Christoph Metzelder" birthday="05-11-1980" positions="cb" nationality="ge" number="21">
				<stats passing="40" tackling="83" shooting="28" crossing="39" heading="80" dribbling="41" speed="74" stamina="64" aggression="60" strength="88" fitness="50" creativity="49"/>				
			</player>
			<player id="Sergio Escudero" name="Sergio Escudero" birthday="02-09-1989" positions="fb" nationality="es" number="3">
				<stats passing="55" tackling="75" shooting="42" crossing="41" heading="79" dribbling="50" speed="55" stamina="70" aggression="78" strength="80" fitness="54" creativity="45"/>
			</player>
						<player id="Ivan Rakitic" name="Ivan Rakitic" birthday="10-03-1988" positions="cm" nationality="cr" number="10">
				<stats passing="75" tackling="75" shooting="55" crossing="56" heading="60" dribbling="60" speed="45" stamina="53" aggression="70" strength="70" fitness="87" creativity="75"/>
			</player>
			<player id="Hao Junmin" name="Hao Junmin" birthday="24-03-1987" positions="cm-sm" nationality="ch" number="8">
				<stats passing="40" tackling="76" shooting="48" crossing="57" heading="55" dribbling="55" speed="75" stamina="90" aggression="85" strength="75" fitness="85" creativity="57"/>	
			</player>
			<player id="Jose Manuel Jurado" name="Jose Manuel Jurado" birthday="29-06-1986" positions="cm" nationality="es" number="18">
				<stats passing="60" tackling="40" shooting="45" crossing="58" heading="25" dribbling="62" speed="60" stamina="55" aggression="50" strength="30" fitness="70" creativity="65"/>	
			</player>
			<player id="Peer Kluge" name="Peer Kluge" birthday="22-11-1980" positions="cm" nationality="ge" number="12">
				<stats passing="73" tackling="49" shooting="48" crossing="50" heading="50" dribbling="50" speed="60" stamina="68" aggression="50" strength="58" fitness="64" creativity="63"/>
			</player>
			<player id="Lukas Schmitz" name="Lukas Schmitz" birthday="13-10-1988" positions="cm-sm" nationality="ge" number="13">
				<stats passing="74" tackling="73" shooting="35" crossing="54" heading="40" dribbling="55" speed="62" stamina="85" aggression="75" strength="71" fitness="95" creativity="70"/>	
			</player>
			<player id="Vasileios Pliatskias" name="Vasileios Pliatsikas" birthday="14-04-1988" positions="dm" nationality="gr" number="20">
				<stats passing="53" tackling="59" shooting="38" crossing="40" heading="56" dribbling="60" speed="61" stamina="67" aggression="54" strength="61" fitness="75" creativity="52"/>		
			</player>
			<player id="Jermaine Jones" name="Jermaine Jones" birthday="03-11-1981" positions="dm" nationality="us" number="23">
				<stats passing="65" tackling="66" shooting="51" crossing="78" heading="35" dribbling="75" speed="78" stamina="77" aggression="40" strength="40" fitness="80" creativity="65"/>		
			</player>
			<player id="Christoph Moritz" name="Christoph Moritz" birthday="27-01-1990" positions="dm" nationality="ge" number="28">
				<stats passing="53" tackling="39" shooting="55" crossing="76" heading="37" dribbling="66" speed="60" stamina="72" aggression="50" strength="27" fitness="73" creativity="60"/>		
			</player>
			<player id="Levan Kenia" name="Levan Kenia" birthday="18-10-1990" positions="am" nationality="ge" number="30">
				<stats passing="50" tackling="67" shooting="58" crossing="45" heading="72" dribbling="42" speed="64" stamina="56" aggression="64" strength="63" fitness="34" creativity="41"/>	
			</player>
			<player id="Matthias Schober" name="Mathias Schober" birthday="08-04-1976" positions="gk" nationality="ge" number="33">
				<stats catching="75" shotStopping="73" distribution="59" fitness="45" stamina="65"/>		
			</player>
			<player id="Joel Matip" name="Joel Matip" birthday="08-08-1991" positions="dm-cm" nationality="ca" number="32">
				<stats passing="68" tackling="56" shooting="43" crossing="76" heading="44" dribbling="63" speed="74" stamina="74" aggression="20" strength="52" fitness="59" creativity="65"/>		
			</player>
			<player id="Klaas-Jan Huntelaar" name="Klaas-Jan Huntelaar" birthday="12-08-1983" positions="cf" nationality="ne" number="25">
				<stats passing="61" tackling="20" shooting="66" crossing="44" heading="81" dribbling="69" speed="77" stamina="61" aggression="61" strength="98" fitness="50" creativity="50"/>		
			</player>
			<player id="Jefferson Farfan" name="Jefferson Farfan" birthday="26-10-1984" positions="cf" nationality="pe" number="17">
				<stats passing="65" tackling="65" shooting="58" crossing="59" heading="73" dribbling="70" speed="62" stamina="67" aggression="57" strength="90" fitness="73" creativity="60"/>		
			</player>
			<player id="Edu" name="Edu" birthday="30-11-1981" positions="cf" nationality="br" number="9">
				<stats passing="53" tackling="23" shooting="59" crossing="53" heading="80" dribbling="69" speed="99" stamina="89" aggression="63" strength="83" fitness="85" creativity="65"/>		
			</player>
			<player id="Mario Gavranovic" name="Mario Gavranovic" birthday="24-11-1989" positions="cf" nationality="sw" number="19">
				<stats passing="37" tackling="24" shooting="60" crossing="47" heading="39" dribbling="70" speed="77" stamina="66" aggression="51" strength="41" fitness="74" creativity="44"/>		
			</player>
		</players>
	</club>

<club shirtColor="0xFF0000" sleevesColor="0xFFFFFF" stripesType="none">
		<name><![CDATA[Lyon]]></name>
		<profile>70</profile>
		<players>
			<player id="Hugo Lloris" name="Hugo Lloris" birthday="26-12-1986" positions="gk" nationality="fr" number="1">
				<stats catching="66" shotStopping="70" distribution="50" fitness="70" stamina="70"/>
			</player>
			<player id="Pape Malickou Diakhate" name="Pape Malickou Diakhate" birthday="21-06-1984" positions="cb" nationality="se" number="4">
				<stats passing="20" tackling="75" shooting="20" crossing="15" heading="75" dribbling="15" speed="60" stamina="70" aggression="60" strength="75" fitness="75" creativity="35"/>	
			</player>	
			<player id="Anthony Reveillere" name="Anthony Reveillere" birthday="10-11-1979" positions="fb" nationality="fr" number="13">
				<stats passing="62" tackling="70" shooting="52" crossing="60" heading="72" dribbling="45" speed="75" stamina="72" aggression="54" strength="70" fitness="75" creativity="44"/>
			</player>
			<player id="Lamine Gassama" name="Lamime Gassama" birthday="20-10-989" positions="fb" nationality="fr" number="2">
				<stats passing="60" tackling="69" shooting="37" crossing="58" heading="50" dribbling="41" speed="62" stamina="78" aggression="77" strength="68" fitness="78" creativity="53"/>
			</player>
			<player id="Timothee Kolodziejczak" name="Timothee Kolodziejczak" birthday="01-10-1991" positions="fb" nationality="fr" number="12">
				<stats passing="69" tackling="77" shooting="30" crossing="72" heading="60" dribbling="57" speed="70" stamina="90" aggression="62" strength="66" fitness="75" creativity="60"/>				
			</player>
			<player id="Cris" name="Cris" birthday="03-06-1977" positions="cb" nationality="br" number="3">
				<stats passing="40" tackling="83" shooting="28" crossing="39" heading="80" dribbling="41" speed="74" stamina="64" aggression="60" strength="88" fitness="50" creativity="49"/>				
			</player>
			<player id="Dejan Lovren" name="Dejan Lovren" birthday="05-07-1989" positions="cb" nationality="cr" number="5">
				<stats passing="55" tackling="75" shooting="42" crossing="41" heading="79" dribbling="50" speed="55" stamina="70" aggression="78" strength="80" fitness="54" creativity="45"/>
			</player>
			<player id="Aly Cissokho" name="Aly Cissokho" birthday="15-09-1987" positions="fb" nationality="fr" number="20">
				<stats passing="47" tackling="68" shooting="10" crossing="68" heading="77" dribbling="46" speed="77" stamina="75" aggression="63" strength="16" fitness="60" creativity="30"/>
			</player>
			<player id="Miralem Pjanic" name="Miralem Pjanic" birthday="02-04-1990" positions="am" nationality="bo" number="8">
				<stats passing="75" tackling="42" shooting="55" crossing="56" heading="60" dribbling="60" speed="45" stamina="53" aggression="70" strength="70" fitness="87" creativity="75"/>
			</player>
			<player id="Ederson" name="Ederson" birthday="13-01-1986" positions="cm" nationality="br" number="10">
				<stats passing="40" tackling="76" shooting="48" crossing="57" heading="55" dribbling="55" speed="75" stamina="90" aggression="85" strength="75" fitness="85" creativity="57"/>	
			</player>
			<player id="Jeremy Pied" name="Jeremy Pied" birthday="23-02-1989" positions="sm" nationality="fr" number="24">
				<stats passing="60" tackling="40" shooting="45" crossing="58" heading="25" dribbling="62" speed="60" stamina="55" aggression="50" strength="30" fitness="70" creativity="65"/>	
			</player>
			<player id="Jean Makoun" name="Jean Makoun" birthday="29-05-1983" positions="dm" nationality="ca" number="17">
				<stats passing="73" tackling="69" shooting="48" crossing="50" heading="50" dribbling="50" speed="60" stamina="68" aggression="50" strength="58" fitness="64" creativity="63"/>
			</player>
			<player id="Kim Kallstrom" name="Kim Kallstrom" birthday="24-08-1982" positions="cm" nationality="sw" number="6">
				<stats passing="74" tackling="73" shooting="35" crossing="54" heading="40" dribbling="55" speed="62" stamina="85" aggression="75" strength="71" fitness="95" creativity="70"/>	
			</player>
			<player id="Maxime Gonalons" name="Maxime Gonalons" birthday="10-03-1989" positions="dm" nationality="fr" number="21">
				<stats passing="53" tackling="59" shooting="38" crossing="40" heading="56" dribbling="60" speed="61" stamina="67" aggression="54" strength="61" fitness="75" creativity="52"/>		
			</player>
			<player id="Jeremy Toulalan" name="Jeremy Toulalan" birthday="10-09-1983" positions="dm" nationality="fr" number="28">
				<stats passing="83" tackling="69" shooting="58" crossing="64" heading="47" dribbling="53" speed="48" stamina="67" aggression="63" strength="62" fitness="66" creativity="58"/>		
			</player>
			<player id="Clement Grenier" name="Clement Grenier" birthday="07-01-1991" positions="cm" nationality="fr" number="22">
				<stats passing="65" tackling="27" shooting="58" crossing="78" heading="35" dribbling="75" speed="78" stamina="77" aggression="40" strength="40" fitness="80" creativity="65"/>		
			</player>
			<player id="Cesar Delgado" name="Cesar Delgado" birthday="18-08-1981" positions="sm" nationality="ar" number="19">
				<stats passing="53" tackling="39" shooting="55" crossing="76" heading="37" dribbling="66" speed="60" stamina="72" aggression="50" strength="27" fitness="73" creativity="60"/>		
			</player>
			<player id="Remy Vercoutre" name="Remy Vercoutre" birthday="26-06-1980" positions="gk" nationality="fr" number="30">
				<stats catching="75" shotStopping="73" distribution="59" fitness="45" stamina="65"/>		
			</player>
			<player id="Michel Bastos" name="Michel Bastos" birthday="02-08-1983" positions="sm-fb" nationality="br" number="11">
				<stats passing="77" tackling="25" shooting="68" crossing="76" heading="44" dribbling="63" speed="74" stamina="74" aggression="20" strength="52" fitness="59" creativity="65"/>		
			</player>
			<player id="Youann Gourcuff" name="Youann Gourcuff" birthday="11-07-1986" positions="am" nationality="fr" number="29">
				<stats passing="74" tackling="60" shooting="68" crossing="53" heading="25" dribbling="66" speed="62" stamina="84" aggression="51" strength="59" fitness="84" creativity="81"/>		
			</player>
			<player id="Jimmy Briand" name="Jimmy Briand" birthday="02-08-1985" positions="cf" nationality="fr" number="7">
				<stats passing="61" tackling="20" shooting="66" crossing="44" heading="81" dribbling="69" speed="77" stamina="61" aggression="61" strength="98" fitness="50" creativity="50"/>		
			</player>
			<player id="Bafetimbi Gomis" name="Bafatimbi Gomis" birthday="06-08-1985" positions="cf" nationality="fr" number="18">
				<stats passing="65" tackling="65" shooting="58" crossing="59" heading="73" dribbling="70" speed="62" stamina="67" aggression="57" strength="90" fitness="73" creativity="60"/>		
			</player>
			<player id="Lisandro Lopez" name="Lisandro Lopez" birthday="02-03-1983" positions="cf" nationality="ar" number="9">
				<stats passing="53" tackling="23" shooting="78" crossing="53" heading="71" dribbling="69" speed="88" stamina="89" aggression="63" strength="83" fitness="85" creativity="65"/>		
			</player>
			<player id="Harry Novillo" name="Harry Novillo" birthday="28-05-1992" positions="cf" nationality="fr" number="15">
				<stats passing="37" tackling="24" shooting="60" crossing="47" heading="39" dribbling="70" speed="77" stamina="66" aggression="51" strength="41" fitness="74" creativity="44"/>		
			</player>
		</players>
	</club>


<club shirtColor="0xFF0000" sleevesColor="0xFFFFFF" stripesType="none">
		<name><![CDATA[Paris Saint Germain]]></name>
		<profile>75</profile>
		<players>
			<player id="Gregory Coupet" name="Gregory Coupet" birthday="31-12-1972" positions="gk" nationality="fr" number="1">
				<stats catching="64" shotStopping="69" distribution="64" fitness="77" stamina="54"/>
			</player>
			<player id="Sylvain Armand" name="Sylvain Armand" birthday="01-08-1980" positions="cb-fb" nationality="fr" number="22">
				<stats passing="68" tackling="78" shooting="54" crossing="64" heading="78" dribbling="53" speed="59" stamina="69" aggression="84" strength="69" fitness="70" creativity="59"/>	
			</player>	
			<player id="Ceara" name="Ceara" birthday="06-06-1980" positions="fb" nationality="br" number="2">
				<stats passing="50" tackling="87" shooting="30" crossing="31" heading="67" dribbling="24" speed="64" stamina="79" aggression="84" strength="69" fitness="70" creativity="29"/>
			</player>
			<player id="Mamadou Sakho" name="Mamadou Sakho" birthday="13-02-1990" positions="fb-cb" nationality="fr" number="3">
				<stats passing="70" tackling="77" shooting="21" crossing="68" heading="63" dribbling="44" speed="65" stamina="80" aggression="74" strength="56" fitness="77" creativity="36"/>
			</player>
			<player id="Zoumana Camara" name="Zoumana Camara" birthday="03-04-1979" positions="cb" nationality="fr" number="6">
				<stats passing="54" tackling="69" shooting="20" crossing="37" heading="74" dribbling="39" speed="80" stamina="75" aggression="59" strength="79" fitness="74" creativity="35"/>				
			</player>
			<player id="Tripy Makonda" name="Tripy Makonda" birthday="24-01-1990" positions="fb" nationality="fr" number="24">
				<stats passing="55" tackling="80" shooting="33" crossing="38" heading="78" dribbling="55" speed="69" stamina="77" aggression="64" strength="65" fitness="75" creativity="54"/>				
			</player>
			<player id="Sammy Traore" name="Sammy Traore" birthday="25-02-1976" positions="cb-fb" nationality="fr" number="13">
				<stats passing="66" tackling="70" shooting="84" crossing="41" heading="66" dribbling="50" speed="70" stamina="79" aggression="63" strength="62" fitness="73" creativity="59"/>
			</player>
			<player id="Siaka Tiene" name="Siaka Tiene" birthday="22-02-1982" positions="fb" nationality="iv" number="5">
				<stats passing="70" tackling="74" shooting="52" crossing="69" heading="52" dribbling="74" speed="68" stamina="83" aggression="59" strength="44" fitness="74" creativity="63"/>
			</player>
			<player id="Claude Makelele" name="Claude Makelele" birthday="18-02-1973" positions="dm-cm" nationality="fr" number="4">
				<stats passing="73" tackling="64" shooting="54" crossing="42" heading="93" dribbling="58" speed="60" stamina="85" aggression="78" strength="95" fitness="74" creativity="59"/>
			</player>
			<player id="Stephane Sessegnon" name="Stephane Sessegnon" birthday="01-06-1984" positions="cm-am-sm" nationality="be" number="10">
				<stats passing="79" tackling="47" shooting="58" crossing="84" heading="34" dribbling="80" speed="69" stamina="68" aggression="62" strength="33" fitness="73" creativity="78"/>	
			</player>
			<player id="Mathieu Bodmer" name="Mathieu Bodmer" birthday="22-11-1982" positions="cm" nationality="fr" number="12">
				<stats passing="70" tackling="57" shooting="70" crossing="57" heading="51" dribbling="84" speed="55" stamina="69" aggression="39" strength="34" fitness="75" creativity="74"/>	
			</player>
			<player id="Nene" name="Nene" birthday="19-07-1981" positions="sm" nationality="br" number="19">
				<stats passing="74" tackling="33" shooting="62" crossing="67" heading="39" dribbling="72" speed="69" stamina="75" aggression="68" strength="21" fitness="62" creativity="85"/>
			</player>
			<player id="Clement Chantome" name="Clement Chantome" birthday="11-09-1987" positions="dm" nationality="fr" number="20">
				<stats passing="76" tackling="44" shooting="66" crossing="64" heading="64" dribbling="58" speed="59" stamina="72" aggression="49" strength="51" fitness="70" creativity="69"/>	
			</player>
			<player id="Jeremy Clement" name="Jeremy Clement" birthday="27-08-1984" positions="cm" nationality="fr" number="23">
				<stats passing="70" tackling="64" shooting="68" crossing="58" heading="93" dribbling="58" speed="64" stamina="82" aggression="89" strength="75" fitness="89" creativity="44"/>		
			</player>
			<player id="Florian Makhedjouf" name="Florian Makhedjouf" birthday="11-01-1991" positions="cm" nationality="fr" number="34">
				<stats passing="54" tackling="11" shooting="59" crossing="44" heading="53" dribbling="68" speed="72" stamina="63" aggression="34" strength="58" fitness="64" creativity="60"/>		
			</player>
			<player id="Ludovic Giuly" name="Ludovic Giuly" birthday="10-07-1976" positions="am-sm-wf-cf" nationality="fr" number="7">
				<stats passing="58" tackling="28" shooting="68" crossing="53" heading="67" dribbling="58" speed="75" stamina="68" aggression="39" strength="68" fitness="49" creativity="54"/>		
			</player>
			<player id="Mevlut Erdinc" name="Mevlut Erdinc" birthday="25-02-1987" positions="cf" nationality="fr" number="11">
				<stats passing="53" tackling="38" shooting="63" crossing="28" heading="74" dribbling="52" speed="84" stamina="69" aggression="79" strength="59" fitness="58" creativity="25"/>	
			</player>
			<player id="Apoula Edel" name="Apoula Edel" birthday="17-06-1986" positions="gk" nationality="ar" number="30">
				<stats catching="79" shotStopping="82" distribution="58" fitness="68" stamina="64"/>		
			</player>
			<player id="Peguy Luyindula" name="Peguy Luyindula" birthday="25-05-1979" positions="cf" nationality="za" number="22">
				<stats passing="64" tackling="33" shooting="76" crossing="47" heading="64" dribbling="54" speed="59" stamina="68" aggression="44" strength="87" fitness="69" creativity="70"/>		
			</player>
			<player id="Guillaume Hoarau" name="Guillaume Hoarau" birthday="05-03-1984" positions="cf" nationality="fr" number="9">
				<stats passing="44" tackling="22" shooting="68" crossing="34" heading="54" dribbling="70" speed="85" stamina="64" aggression="54" strength="64" fitness="65" creativity="64"/>		
			</player>
		</players>
	</club>

<club shirtColor="0xFF0000" sleevesColor="0xFFFFFF" stripesType="none">
		<name><![CDATA[Inter Milan]]></name>
		<profile>90</profile>
		<players>
			<player id="Luca Castellazzi" name="Luca Castellazzi" birthday="19-07-1975" positions="gk" nationality="it" number="12">
				<stats catching="64" shotStopping="62" distribution="70" fitness="39" stamina="68"/>
			</player>
			<player id="Ivan Cordoba" name="Ivan Cordoba" birthday="11-08-1976" positions="cb-fb" nationality="co" number="2">
				<stats passing="54" tackling="78" shooting="7" crossing="32" heading="79" dribbling="23" speed="51" stamina="74" aggression="73" strength="88" fitness="95" creativity="34"/>	
			</player>	
			<player id="Javier Zanetti" name="Javier Zanetti" birthday="10-08-1973" positions="fb" nationality="ar" number="4">
				<stats passing="64" tackling="68" shooting="54" crossing="75" heading="58" dribbling="65" speed="75" stamina="85" aggression="54" strength="75" fitness="85" creativity="65"/>
			</player>
			<player id="Lucio" name="Lucio" birthday="08-05-1978" positions="cb" nationality="br" number="6">
				<stats passing="39" tackling="83" shooting="38" crossing="28" heading="78" dribbling="16" speed="58" stamina="64" aggression="85" strength="90" fitness="74" creativity="34"/>
			</player>
			<player id="Walter Samuel" name="Walter Samuel" birthday="23-03-1978" positions="cb" nationality="ar" number="25">
				<stats passing="39" tackling="83" shooting="38" crossing="28" heading="78" dribbling="16" speed="58" stamina="64" aggression="85" strength="90" fitness="74" creativity="34"/>
</player>
			<player id="Marco Materazzi" name="Marco Materazzi" birthday="19-08-1973" positions="cb" nationality="it" number="23">
				<stats passing="74" tackling="75" shooting="58" crossing="43" heading="75" dribbling="48" speed="68" stamina="74" aggression="63" strength="61" fitness="47" creativity="58"/>				
			</player>
			<player id="Nelson Rivas" name="Nelson Rivas" birthday="25-03-1983" positions="cb-fb" nationality="co" number="24">
				<stats passing="58" tackling="89" shooting="23" crossing="42" heading="78" dribbling="33" speed="68" stamina="78" aggression="79" strength="80" fitness="72" creativity="52"/>				
			</player>
			<player id="Cristian Chivu" name="Cristian Chivu" birthday="26-10-1980" positions="fb-cb" nationality="en" number="3">
				<stats passing="64" tackling="69" shooting="52" crossing="69" heading="55" dribbling="63" speed="70" stamina="75" aggression="72" strength="64" fitness="75" creativity="53"/>
			</player>
			<player id="Maicon" name="Maicon" birthday="26-07-1981" positions="fb" nationality="br" number="13">
				<stats passing="79" tackling="57" shooting="63" crossing="75" heading="51" dribbling="58" speed="63" stamina="68" aggression="40" strength="56" fitness="44" creativity="75"/>
			</player>
			<player id="Sulley Muntari" name="Sulley Muntari" birthday="27-08-1984" positions="dm-cm" nationality="gh" number="11">
				<stats passing="68" tackling="76" shooting="53" crossing="52" heading="65" dribbling="37" speed="52" stamina="80" aggression="82" strength="70" fitness="75" creativity="45"/>
			</player>
			<player id="McDonald Mariga" name="McDonald Mariga" birthday="04-04-1987" positions="cm" nationality="ke" number="23">
				<stats passing="67" tackling="79" shooting="38" crossing="58" heading="39" dribbling="63" speed="69" stamina="82" aggression="54" strength="69" fitness="74" creativity="67"/>	
			</player>
			<player id="Thiagho Motta" name="Thiago Motta" birthday="28-08-1982" positions="cm" nationality="br" number="8">
				<stats passing="73" tackling="67" shooting="66" crossing="75" heading="58" dribbling="48" speed="59" stamina="83" aggression="74" strength="52" fitness="58" creativity="64"/>	
			</player>
			<player id="Dejan Stankovic" name="Dejan Stankovic" birthday="11-09-1978" positions="am" nationality="en" number="5">
				<stats passing="66" tackling="60" shooting="68" crossing="60" heading="25" dribbling="70" speed="70" stamina="55" aggression="70" strength="55" fitness="75" creativity="80"/>
			</player>
			<player id="Esteban Cambiasso" name="Esteban Cambiasso" birthday="18-08-1980" positions="dm" nationality="ar" number="19">
				<stats passing="84" tackling="80" shooting="65" crossing="77" heading="55" dribbling="75" speed="75" stamina="91" aggression="90" strength="80" fitness="79" creativity="75"/>	
			</player>
			<player id="Mancini" name="Mancini" birthday="01-08-1980" positions="sm" nationality="br" number="30">
				<stats passing="70" tackling="45" shooting="67" crossing="66" heading="58" dribbling="64" speed="59" stamina="78" aggression="62" strength="67" fitness="77" creativity="58"/>		
			</player>
			<player id="Wesley Sneijder" name="Wesley Sneijder" birthday="09-06-1984" positions="am" nationality="ne" number="10">
				<stats passing="62" tackling="54" shooting="48" crossing="54" heading="68" dribbling="54" speed="59" stamina="98" aggression="60" strength="74" fitness="97" creativity="60"/>		
			</player>
			<player id="Samuel Eto'o" name="Samuel Eto'o" birthday="10-03-1981" positions="cf" nationality="ca" number="9">
				<stats passing="63" tackling="25" shooting="84" crossing="64" heading="76" dribbling="64" speed="85" stamina="69" aggression="12" strength="74" fitness="80" creativity="64"/>		
			</player>
			<player id="Diego Milito" name="Diego Milito" birthday="12-06-1979" positions="cf" nationality="ar" number="22">
				<stats passing="68" tackling="51" shooting="81" crossing="58" heading="75" dribbling="85" speed="74" stamina="68" aggression="68" strength="68" fitness="60" creativity="75"/>	
			</player>
			<player id="David Suazo" name="David Suazo" birthday="05-11-1979" positions="cf" nationality="ho" number="18">
				<stats passing="44" tackling="14" shooting="78" crossing="41" heading="72" dribbling="59" speed="84" stamina="64" aggression="36" strength="59" fitness="44" creativity="45"/>		
			</player>
			<player id="Julio Cesar" name="Julio Cesar" birthday="03-09-1979" positions="gk" nationality="br" number="1">
				<stats catching="80" shotStopping="90" distribution="89" fitness="60" stamina="75"/>		
			</player>
		</players>
	</club>

<club shirtColor="0xFF0000" sleevesColor="0xFFFFFF" stripesType="none">
		<name><![CDATA[Juventus]]></name>
		<profile>75</profile>
		<players>
			<player id="Gianluigi Buffon" name="Gianluigi Buffon" birthday="28-01-1978" positions="gk" nationality="it" number="1">
				<stats catching="64" shotStopping="69" distribution="64" fitness="77" stamina="54"/>
			</player>
			<player id="Marco Motta" name="Marco Motta" birthday="14-05-1986" positions="fb" nationality="it" number="2">
				<stats passing="68" tackling="78" shooting="54" crossing="64" heading="78" dribbling="53" speed="59" stamina="69" aggression="84" strength="69" fitness="70" creativity="59"/>	
			</player>	
			<player id="Giorgio Chiellini" name="Giorgio Chiellini" birthday="14-08-1984" positions="cb" nationality="it" number="3">
				<stats passing="50" tackling="87" shooting="30" crossing="31" heading="67" dribbling="24" speed="64" stamina="79" aggression="84" strength="69" fitness="70" creativity="29"/>
			</player>
			<player id="Fabio Grosso" name="Fabio Grosso" birthday="28-11-1977" positions="fb" nationality="it" number="6">
				<stats passing="70" tackling="77" shooting="21" crossing="68" heading="63" dribbling="44" speed="65" stamina="80" aggression="74" strength="56" fitness="77" creativity="36"/>
			</player>
			<player id="Armand Traore" name="Armand Traore" birthday="08-10-1989" positions="fb" nationality="fr" number="17">
				<stats passing="54" tackling="69" shooting="20" crossing="37" heading="74" dribbling="39" speed="80" stamina="75" aggression="59" strength="79" fitness="74" creativity="35"/>				
			</player>
			<player id="Leonardo Bonucci" name="Leonardo Bonucci" birthday="01-05-1987" positions="cb" nationality="it" number="19">
				<stats passing="55" tackling="80" shooting="33" crossing="38" heading="78" dribbling="33" speed="69" stamina="77" aggression="64" strength="65" fitness="75" creativity="54"/>				
			</player>
			<player id="Zdenek Grygera" name="Zdenek Grygera" birthday="14-05-1980" positions="fb-cb" nationality="cz" number="21">
				<stats passing="66" tackling="70" shooting="84" crossing="41" heading="66" dribbling="50" speed="70" stamina="79" aggression="63" strength="62" fitness="73" creativity="59"/>
			</player>
			<player id="Leandro Rinaudo" name="Leandro Rinaudo" birthday="09-05-1983" positions="cb" nationality="it" number="26">
				<stats passing="70" tackling="74" shooting="52" crossing="69" heading="52" dribbling="74" speed="68" stamina="83" aggression="59" strength="44" fitness="74" creativity="63"/>
			</player>
			<player id="Felipe Melo" name="Felipe Melo" birthday="26-06-1983" positions="dm" nationality="br" number="4">
				<stats passing="73" tackling="64" shooting="54" crossing="42" heading="93" dribbling="58" speed="60" stamina="85" aggression="78" strength="95" fitness="74" creativity="59"/>
			</player>
			<player id="Mohamed Sissoko" name="Mohamed Sissoko" birthday="22-01-1985" positions="dm" nationality="fr" number="5">
				<stats passing="79" tackling="47" shooting="58" crossing="84" heading="34" dribbling="80" speed="69" stamina="68" aggression="62" strength="33" fitness="73" creativity="78"/>	
			</player>
			<player id="Hasan Salihamidzic" name="Hasan Salihamidzic" birthday="01-01-1977" positions="sm-cm" nationality="bo" number="7">
				<stats passing="70" tackling="57" shooting="70" crossing="57" heading="51" dribbling="84" speed="55" stamina="69" aggression="39" strength="34" fitness="75" creativity="74"/>	
			</player>
			<player id="Claudio Marchisio" name="Claudio Marchisio" birthday="19-01-1986" positions="cm" nationality="it" number="8">
				<stats passing="74" tackling="33" shooting="62" crossing="67" heading="39" dribbling="72" speed="69" stamina="75" aggression="68" strength="21" fitness="62" creativity="85"/>
			</player>
			<player id="Alberto Aquilani" name="Alberto Aquilani" birthday="07-07-1984" positions="cm-am" nationality="it" number="14">
				<stats passing="76" tackling="44" shooting="66" crossing="64" heading="64" dribbling="58" speed="59" stamina="72" aggression="49" strength="51" fitness="70" creativity="69"/>	
			</player>
			<player id="Davide Lanzafame" name="Davide Lanzafame" birthday="09-02-1987" positions="sm-wf-cf" nationality="it" number="36">
				<stats passing="70" tackling="64" shooting="68" crossing="58" heading="93" dribbling="58" speed="64" stamina="82" aggression="89" strength="75" fitness="89" creativity="44"/>		
			</player>
			<player id="Simone Pepe" name="Simone Pepe" birthday="30-08-1983" positions="sm-wf" nationality="it" number="23">
				<stats passing="54" tackling="11" shooting="59" crossing="44" heading="53" dribbling="68" speed="72" stamina="63" aggression="34" strength="58" fitness="64" creativity="60"/>		
			</player>
			<player id="Vincenzo Iaquinta" name="Vincenzo Iaquinta" birthday="21-11-1979" positions="cf" nationality="it" number="9">
				<stats passing="58" tackling="28" shooting="68" crossing="53" heading="67" dribbling="58" speed="75" stamina="68" aggression="39" strength="68" fitness="49" creativity="54"/>		
			</player>
			<player id="Alessandro Del Piero" name="Alessandro Del Piero" birthday="09-11-1974" positions="cf" nationality="it" number="10">
				<stats passing="53" tackling="38" shooting="63" crossing="28" heading="74" dribbling="52" speed="84" stamina="69" aggression="79" strength="59" fitness="58" creativity="25"/>	
			</player>
			<player id="Alex Manninger" name="Alex Manninger" birthday="04-06-1977" positions="gk" nationality="au" number="13">
				<stats catching="79" shotStopping="82" distribution="58" fitness="68" stamina="64"/>		
			</player>
			<player id="Amauri" name="Amauri" birthday="03-06-1980" positions="cf" nationality="br" number="11">
				<stats passing="64" tackling="33" shooting="76" crossing="47" heading="64" dribbling="54" speed="59" stamina="68" aggression="44" strength="87" fitness="69" creativity="70"/>		
			</player>
			<player id="Fabio Quagliarella" name="Fabio Quagliarella" birthday="31-01-1983" positions="cf" nationality="it" number="18">
				<stats passing="44" tackling="22" shooting="68" crossing="34" heading="54" dribbling="70" speed="85" stamina="64" aggression="54" strength="64" fitness="65" creativity="64"/>		
			</player>
			<player id="Marco Storari" name="Marco Storari" birthday="07-01-1977" positions="gk" nationality="it" number="30">
				<stats catching="64" shotStopping="73" distribution="70" fitness="59" stamina="62"/>		
			</player>
		</players>
	</club>

<club shirtColor="0xFF0000" sleevesColor="0xFFFFFF" stripesType="none">
		<name><![CDATA[FC Porto]]></name>
		<profile>60</profile>
		<players>
			<player id="Helton Arruda" name="Helton Arruda" birthday="18-05-1978" positions="gk" nationality="br" number="1">
				<stats catching="75" shotStopping="80" distribution="50" fitness="70" stamina="60"/>
			</player>
			<player id="Alvaro Pereira" name="Alvaro Pereira" birthday="28-11-1985" positions="cm-am" nationality="fr" number="2">
				<stats passing="55" tackling="55" shooting="54" crossing="45" heading="50" dribbling="70" speed="65" stamina="70" aggression="55" strength="70" fitness="50" creativity="60"/>	
			</player>	
			<player id="Jorge Fucile" name="Jorge Fucile" birthday="19-11-1984" positions="fb" nationality="ur" number="3">
				<stats passing="53" tackling="60" shooting="40" crossing="60" heading="63" dribbling="45" speed="65" stamina="68" aggression="58" strength="63" fitness="75" creativity="56"/>
			</player>
			<player id="Freddy Guarin" name="Freddy Guarin" birthday="30-06-1986" positions="cm-am" nationality="co" number="6">
				<stats passing="93" tackling="59" shooting="67" crossing="58" heading="35" dribbling="63" speed="64" stamina="80" aggression="46" strength="47" fitness="64" creativity="94"/>
			</player>
			<player id="Alvaro Pereira" name="Alvaro Pereira" birthday="28-11-1985" positions="fb" nationality="ur" number="5">
				<stats passing="65" tackling="68" shooting="56" crossing="46" heading="67" dribbling="56" speed="72" stamina="66" aggression="72" strength="68" fitness="75" creativity="45"/>				
			</player>
			<player id="Maicon" name="Maicon" birthday="14-09-1988" positions="cb" nationality="br" number="4">
				<stats passing="55" tackling="56" shooting="40" crossing="52" heading="57" dribbling="43" speed="68" stamina="67" aggression="65" strength="57" fitness="68" creativity="45"/>				
			</player>
			<player id="Fernando Belluschi" name="Fernando Belluschi" birthday="10-09-1983" positions="cm-am" nationality="ar" number="7">
				<stats passing="68" tackling="46" shooting="64" crossing="63" heading="34" dribbling="67" speed="61" stamina="58" aggression="48" strength="56" fitness="37" creativity="74"/>
			</player>
			<player id="Joao Moutinho" name="Joao Moutinho" birthday="08-09-1986" positions="cm" nationality="pr" number="8">
				<stats passing="72" tackling="43" shooting="68" crossing="67" heading="43" dribbling="75" speed="64" stamina="64" aggression="57" strength="42" fitness="60" creativity="56"/>
			</player>
			<player id="Falcao" name="Falcao" birthday="10-02-1986" positions="cf" nationality="co" number="9">
				<stats passing="65" tackling="56" shooting="69" crossing="67" heading="67" dribbling="73" speed="65" stamina="67" aggression="69" strength="60" fitness="60" creativity="67"/>
			</player>
			<player id="Hulk" name="Hulk" birthday="25-07-1986" positions="cf" nationality="br" number="12">
				<stats passing="53" tackling="34" shooting="71" crossing="67" heading="45" dribbling="74" speed="64" stamina="68" aggression="45" strength="49" fitness="61" creativity="64"/>	
			</player>
			<player id="Silvestre Varela" name="Silvestre Varela" birthday="02-02-1985" positions="wf-cf" nationality="pr" number="17">
				<stats passing="49" tackling="32" shooting="64" crossing="68" heading="43" dribbling="66" speed="84" stamina="45" aggression="37" strength="46" fitness="57" creativity="51"/>	
			</player>
			<player id="Cristian Rodriguez" name="Cristian Rodriguez" birthday="30-09-1985" positions="sm" nationality="ur" number="10">
				<stats passing="73" tackling="56" shooting="61" crossing="63" heading="45" dribbling="58" speed="68" stamina="68" aggression="64" strength="62" fitness="64" creativity="63"/>
			</player>
			<player id="James Rodriguez" name="James Rodriguez" birthday="12-07-1991" positions="sf-wf-cf" nationality="co" number="19">
				<stats passing="71" tackling="61" shooting="68" crossing="67" heading="45" dribbling="65" speed="68" stamina="67" aggression="68" strength="69" fitness="60" creativity="57"/>	
			</player>
			<player id="Nicolas Otamendi" name="Nicholas Otamendi" birthday="12-02-1988" positions="cb-fb" nationality="ar" number="30">
				<stats passing="40" tackling="69" shooting="56" crossing="56" heading="56" dribbling="66" speed="61" stamina="67" aggression="64" strength="66" fitness="69" creativity="55"/>		
			</player>
			<player id="Rolando" name="Rolando" birthday="31-08-1985" positions="cb" nationality="pr" number="14">
				<stats passing="57" tackling="69" shooting="43" crossing="53" heading="67" dribbling="31" speed="67" stamina="77" aggression="67" strength="72" fitness="74" creativity="46"/>		
			</player>
			<player id="Souza" name="Souza" birthday="11-02-1989" positions="dm" nationality="br" number="23">
				<stats passing="78" tackling="56" shooting="61" crossing="67" heading="25" dribbling="73" speed="69" stamina="67" aggression="69" strength="68" fitness="70" creativity="73"/>		
			</player>
			<player id="Emidio Rafael" name="Emidio Rafael" birthday="24-01-1986" positions="fb" nationality="pr" number="15">
				<stats passing="50" tackling="67" shooting="58" crossing="45" heading="72" dribbling="42" speed="64" stamina="56" aggression="64" strength="63" fitness="34" creativity="41"/>	
			</player>
			<player id="Beto" name="Beto" birthday="01-05-1982" positions="gk" nationality="pr" number="24">
				<stats catching="50" shotStopping="76" distribution="60" fitness="67" stamina="84"/>		
			</player>
			<player id="Cristian Sapunaru" name="Cristian Sapunaru" birthday="05-04-1984" positions="fb-cb" nationality="ro" number="21">
				<stats passing="59" tackling="68" shooting="38" crossing="47" heading="53" dribbling="55" speed="69" stamina="72" aggression="64" strength="56" fitness="78" creativity="67"/>		
			</player>
			<player id="Mariano Gonzalez" name="Mariano Gonzalez" birthday="05-05-1981" positions="cm-sm" nationality="ar" number="11">
				<stats passing="73" tackling="32" shooting="77" crossing="57" heading="23" dribbling="89" speed="73" stamina="43" aggression="48" strength="51" fitness="67" creativity="73"/>		
			</player>
			<player id="Henrique Fonseca" name="Henrique Fonseca" birthday="18-05-1985" positions="cb" nationality="pr" number="16">
				<stats passing="69" tackling="67" shooting="45" crossing="56" heading="59" dribbling="71" speed="72" stamina="65" aggression="46" strength="59" fitness="70" creativity="67"/>		
			</player>
			<player id="Fernando" name="Fernando" birthday="25-07-1987" positions="cm-sm" nationality="br" number="25">
				<stats passing="65" tackling="67" shooting="67" crossing="56" heading="56" dribbling="64" speed="62" stamina="67" aggression="57" strength="67" fitness="67" creativity="73"/>		
			</player>
			<player id="Walter" name="Walter" birthday="22-07-1989" positions="cf" nationality="br" number="18">
				<stats passing="56" tackling="35" shooting="63" crossing="53" heading="70" dribbling="76" speed="67" stamina="70" aggression="68" strength="72" fitness="67" creativity="67"/>		
			</player>
			<player id="Ukra" name="Ukra" birthday="16-03-1988" positions="cf" nationality="pr" number="27">
				<stats passing="65" tackling="34" shooting="57" crossing="65" heading="73" dribbling="67" speed="69" stamina="71" aggression="69" strength="65" fitness="58" creativity="65"/>		
			</player>
			<player id="Pawel Kieszek" name="Pawel Kieszek" birthday="16-04-1984" positions="gk" nationality="po" number="31">
				<stats catching="55" shotStopping="75" distribution="65" fitness="67" stamina="64"/>		
			</player>
		</players>
	</club>

<club shirtColor="0xFF0000" sleevesColor="0xFFFFFF" stripesType="none">
		<name><![CDATA[Glasgow Rangers]]></name>
		<profile>55</profile>
		<players>
			<player id="Allan McGregor" name="Allan McGregor" birthday="31-01-1982" positions="gk" nationality="sc" number="1">
				<stats catching="70" shotStopping="85" distribution="95" fitness="70" stamina="80"/>
			</player>
			<player id="Sasa Papac" name="Sasa Papac" birthday="07-02-1980" positions="fb" nationality="se" number="5">
				<stats passing="60" tackling="75" shooting="37" crossing="59" heading="69" dribbling="57" speed="69" stamina="83" aggression="72" strength="68" fitness="77" creativity="47"/>	
			</player>	
			<player id="Lee McCulloch" name="Lee McCulloch" birthday="14-05-1978" positions="cm-dm-am-cb" nationality="sc" number="6">
				<stats passing="60" tackling="70" shooting="45" crossing="63" heading="58" dribbling="50" speed="65" stamina="99" aggression="80" strength="75" fitness="98" creativity="60"/>
			</player>
			<player id="David Weir" name="David Weir" birthday="10-05-1970" positions="cb" nationality="sc" number="3">
				<stats passing="38" tackling="88" shooting="25" crossing="23" heading="73" dribbling="23" speed="58" stamina="64" aggression="78" strength="79" fitness="75" creativity="43"/>
			</player>
			<player id="Kirk Broadfoot" name="Kirk Broadfoot" birthday="08-08-1984" positions="cb-fb" nationality="sc" number="4">
				<stats passing="39" tackling="86" shooting="15" crossing="16" heading="72" dribbling="24" speed="47" stamina="62" aggression="78" strength="88" fitness="84" creativity="42"/>				
			</player>
			<player id="Andy Webster" name="Andy Webster" birthday="23-04-1982" positions="cb" nationality="sc" number="22">
				<stats passing="42" tackling="74" shooting="38" crossing="17" heading="81" dribbling="43" speed="74" stamina="64" aggression="84" strength="94" fitness="74" creativity="43"/>				
			</player>
			<player id="Madjid Bougherra" name="Madjid Bougherra" birthday="07-10-1982" positions="cb" nationality="al" number="24">
				<stats passing="43" tackling="63" shooting="16" crossing="24" heading="64" dribbling="38" speed="68" stamina="63" aggression="83" strength="67" fitness="80" creativity="33"/>
			</player>
			<player id="Maurice Edu" name="Maurice Edu" birthday="18-04-1986" positions="cm" nationality="us" number="7">
				<stats passing="53" tackling="57" shooting="42" crossing="27" heading="67" dribbling="37" speed="49" stamina="75" aggression="57" strength="78" fitness="55" creativity="43"/>
			</player>
			<player id="Richard Foster" name="Richard Foster" birthday="31-07-1985" positions="fb" nationality="sc" number="12">
				<stats passing="73" tackling="77" shooting="48" crossing="67" heading="24" dribbling="53" speed="52" stamina="63" aggression="88" strength="57" fitness="79" creativity="48"/>
			</player>
			<player id="Steven Whittaker" name="Steven Whittaker" birthday="16-06-1984" positions="fb-sm" nationality="sc" number="16">
				<stats passing="63" tackling="69" shooting="43" crossing="69" heading="42" dribbling="70" speed="77" stamina="77" aggression="68" strength="59" fitness="78" creativity="64"/>	
			</player>
			<player id="Salim Kerkar" name="Salim Kerkar" birthday="04-08-1987" positions="cm" nationality="fr" number="28">
				<stats passing="64" tackling="86" shooting="30" crossing="43" heading="62" dribbling="38" speed="50" stamina="78" aggression="82" strength="73" fitness="64" creativity="64"/>	
			</player>
			<player id="John Fleck" name="John Fleck" birthday="24-08-1991" positions="cm" nationality="sc" number="10">
				<stats passing="70" tackling="52" shooting="59" crossing="68" heading="63" dribbling="49" speed="55" stamina="75" aggression="57" strength="46" fitness="84" creativity="72"/>	
			</player>
			<player id="Steven Davis" name="Steven Davis" birthday="01-01-1985" positions="am" nationality="ni" number="8">
				<stats passing="54" tackling="46" shooting="45" crossing="50" heading="58" dribbling="44" speed="54" stamina="93" aggression="70" strength="70" fitness="89" creativity="57"/>		
			</player>
			<player id="Kenny Miller" name="Kenny Miller" birthday="23-12-1979" positions="cf" nationality="sc" number="9">
				<stats passing="63" tackling="50" shooting="51" crossing="67" heading="54" dribbling="69" speed="64" stamina="63" aggression="85" strength="57" fitness="67" creativity="70"/>		
			</player>
			<player id="Vladimir Weiss" name="Vladimir Weiss" birthday="30-11-1989" positions="sm-am-cm" nationality="sl" number="20">
				<stats passing="39" tackling="12" shooting="21" crossing="43" heading="23" dribbling="54" speed="63" stamina="52" aggression="69" strength="44" fitness="77" creativity="52"/>		
			</player>
			<player id="Neil Alexander" name="Neil Alexander" birthday="10-03-1978" positions="gk" nationality="sc" number="25">
				<stats catching="65" shotStopping="76" distribution="70" fitness="60" stamina="63"/>		
			</player>
			<player id="Kyle Lafferty" name="Kyle Lafferty" birthday="16-09-1987" positions="cf" nationality="ni" number="11">
				<stats passing="54" tackling="33" shooting="55" crossing="44" heading="64" dribbling="62" speed="63" stamina="64" aggression="88" strength="70" fitness="73" creativity="65"/>		
			</player>
			<player id="Steven Naismith" name="Steven Naismith" birthday="14-09-1986" positions="cf" nationality="sc" number="14">
				<stats passing="51" tackling="33" shooting="45" crossing="44" heading="67" dribbling="53" speed="73" stamina="90" aggression="95" strength="85" fitness="67" creativity="54"/>		
			</player>
			<player id="Nikica Jelavic" name="Nikica Jelavic" birthday="27-08-1985" positions="cf" nationality="cr" number="18">
				<stats passing="51" tackling="46" shooting="54" crossing="51" heading="64" dribbling="54" speed="57" stamina="75" aggression="70" strength="90" fitness="75" creativity="60"/>		
			</player>
			<player id="James Beattie" name="James Beattie" birthday="27/02/1978" positions="cf" nationality="en" number="19">
				<stats passing="60" tackling="33" shooting="68" crossing="37" heading="75" dribbling="42" speed="70" stamina="58" aggression="63" strength="58" fitness="55" creativity="33"/>		
			</player>			
		</players>
	</club>

<club shirtColor="0xFF0000" sleevesColor="0xFFFFFF" stripesType="none">
		<name><![CDATA[Glasgow Celtic]]></name>
		<profile>65</profile>
		<players>
			<player id="Lukasz Zaluska" name="Lukasz Zaluska" birthday="16-06-1982" positions="gk" nationality="po" number="24">
				<stats catching="77" shotStopping="79" distribution="86" fitness="70" stamina="75"/>
			</player>
			<player id="Fraser Forster" name="Fraser Forster" birthday="17-03-1988" positions="gk" nationality="en" number="26">
				<stats catching="73" shotStopping="75" distribution="46" fitness="64" stamina="60"/>
			</player>
			<player id="Andreas Hinkel" name="Andreas Hinkel" birthday="26-03-1982" positions="fb" nationality="ge" number="2">
				<stats passing="73" tackling="77" shooting="48" crossing="76" heading="75" dribbling="67" speed="59" stamina="73" aggression="78" strength="76" fitness="66" creativity="51"/>	
			</player>	
			<player id="Emilio Izaguirre" name="Emilio Izaguirre" birthday="10-05-1986" positions="fb-wb" nationality="ho" number="3">
				<stats passing="56" tackling="73" shooting="39" crossing="46" heading="78" dribbling="51" speed="65" stamina="75" aggression="75" strength="78" fitness="68" creativity="49"/>
			</player>
			<player id="Cha Du-Ri" name="Cha Du-Ri" birthday="25-07-1980" positions="fb" nationality="sk" number="11">
				<stats passing="63" tackling="61" shooting="55" crossing="56" heading="55" dribbling="65" speed="63" stamina="75" aggression="50" strength="71" fitness="62" creativity="50"/>
			</player>
			<player id="Daniel Majstorovic" name="Daniel Majstorovic" birthday="05-04-1977" positions="cb" nationality="sw" number="5">
				<stats passing="68" tackling="78" shooting="45" crossing="60" heading="82" dribbling="50" speed="54" stamina="66" aggression="80" strength="63" fitness="75" creativity="60"/>				
			</player>
			<player id="Jos Hooiveld" name="Jos Hooiveld" birthday="22-04-1983" positions="cb" nationality="ne" number="6">
				<stats passing="41" tackling="81" shooting="15" crossing="11" heading="81" dribbling="26" speed="65" stamina="73" aggression="68" strength="75" fitness="61" creativity="25"/>				
			</player>
			<player id="Glenn Loovens" name="Glenn Loovens" birthday="22-10-1983" positions="cb" nationality="ne" number="22">
				<stats passing="56" tackling="85" shooting="55" crossing="26" heading="76" dribbling="46" speed="60" stamina="63" aggression="57" strength="58" fitness="63" creativity="56"/>
			</player>
			<player id="Mark Wilson" name="Mark Wilson" birthday="05-06-1984" positions="fb" nationality="sc" number="12">
				<stats passing="53" tackling="63" shooting="44" crossing="66" heading="57" dribbling="53" speed="67" stamina="65" aggression="57" strength="66" fitness="52" creativity="41"/>
			</player>
			<player id="Fredrik Ljungberg" name="Fredrik Ljungberg" birthday="16-04-1977" positions="cm-sm" nationality="sw" number="7">
				<stats passing="63" tackling="59" shooting="70" crossing="75" heading="60" dribbling="63" speed="67" stamina="70" aggression="40" strength="55" fitness="74" creativity="50"/>
			</player>
			<player id="Scott Brown" name="Scott Brown" birthday="25-06-1985" positions="cm-sm" nationality="sc" number="8">
				<stats passing="60" tackling="57" shooting="57" crossing="55" heading="33" dribbling="47" speed="58" stamina="77" aggression="88" strength="47" fitness="73" creativity="57"/>	
			</player>
			<player id="Niall McGinn" name="Niall McGinn" birthday="20-07-1987" positions="sm-cm" nationality="ni" number="14">
				<stats passing="75" tackling="23" shooting="27" crossing="63" heading="67" dribbling="57" speed="63" stamina="57" aggression="35" strength="54" fitness="66" creativity="71"/>	
			</player>
			<player id="Joe Ledley" name="Joe Ledley" birthday="21-01-1987" positions="cm-sm" nationality="wa" number="16">
				<stats passing="63" tackling="43" shooting="70" crossing="63" heading="48" dribbling="68" speed="63" stamina="78" aggression="77" strength="58" fitness="75" creativity="64"/>
			</player>
			<player id="Marc Crosas" name="Marc Crosas" birthday="09-01-1988" positions="cm" nationality="es" number="17">
				<stats passing="58" tackling="61" shooting="63" crossing="5" heading="57" dribbling="53" speed="62" stamina="63" aggression="79" strength="66" fitness="75" creativity="57"/>	
			</player>
			<player id="Efrain Juarez" name="Efrain Juarez" birthday="22-02-1988" positions="cm-sm" nationality="me" number="4">
				<stats passing="83" tackling="69" shooting="58" crossing="64" heading="47" dribbling="53" speed="48" stamina="67" aggression="63" strength="62" fitness="66" creativity="58"/>		
			</player>
			<player id="Ki Sung-Yueng" name="Ki Sung-Yueng" birthday="24-01-1989" positions="cm" nationality="sk" number="18">
				<stats passing="77" tackling="33" shooting="23" crossing="56" heading="16" dribbling="78" speed="58" stamina="44" aggression="37" strength="28" fitness="49" creativity="63"/>		
			</player>
			<player id="Paddy McCourt" name="Paddy McCourt" birthday="16-12-1983" positions="sm" nationality="ni" number="20">
				<stats passing="69" tackling="77" shooting="58" crossing="69" heading="61" dribbling="64" speed="52" stamina="75" aggression="89" strength="74" fitness="69" creativity="62"/>		
			</player>
			<player id="Colin Doyle" name="Colin Doyle" birthday="12-6-1985" positions="gk" nationality="ir" number="13">
				<stats catching="50" shotStopping="76" distribution="60" fitness="67" stamina="84"/>		
			</player>
			<player id="Biram Kayal" name="Biram Kayal" birthday="02-05-1988" positions="cm-sm" nationality="is" number="33">
				<stats passing="55" tackling="21" shooting="54" crossing="57" heading="33" dribbling="58" speed="68" stamina="56" aggression="23" strength="32" fitness="85" creativity="58"/>		
			</player>
			<player id="Gary Hooper" name="Gary Hooper" birthday="26-01-1988" positions="cf" nationality="en" number="88">
				<stats passing="66" tackling="37" shooting="77" crossing="58" heading="68" dribbling="70" speed="40" stamina="39" aggression="35" strength="60" fitness="60" creativity="75"/>		
			</player>
			<player id="Georgios Samaras" name="Georgios Samaras" birthday="21-02-1985" positions="cf" nationality="gr" number="9">
				<stats passing="55" tackling="25" shooting="63" crossing="54" heading="63" dribbling="47" speed="73" stamina="66" aggression="47" strength="52" fitness="77" creativity="53"/>		
			</player>
			<player id="Anthony Stokes" name="Anthony Stokes" birthday="25-07-1988" positions="cf" nationality="ir" number="10">
				<stats passing="54" tackling="34" shooting="64" crossing="47" heading="74" dribbling="60" speed="84" stamina="57" aggression="38" strength="59" fitness="65" creativity="53"/>		
			</player>
			<player id="Shaun Maloney" name="Shaun Maloney" birthday="24-01-1983" positions="cf" nationality="sc" number="13">
				<stats passing="60" tackling="33" shooting="69" crossing="30" heading="86" dribbling="58" speed="55" stamina="73" aggression="58" strength="99" fitness="75" creativity="55"/>		
			</player>
		</players>
	</club>

<club shirtColor="0xFF0000" sleevesColor="0xFFFFFF" stripesType="none">
		<name><![CDATA[Ajax Amsterdam]]></name>
		<profile>90</profile>
		<players>
			<player id="Maarten Stekelenburg" name="Maarten Stekelenburg" birthday="22-09-1983" positions="gk" nationality="ne" number="1">
				<stats catching="84" shotStopping="88" distribution="59" fitness="53" stamina="68"/>
			</player>
			<player id="Gregory van der wiel" name="Gregory van der Wiel" birthday="03-02-1988" positions="fb" nationality="ne" number="2">
				<stats passing="58" tackling="59" shooting="39" crossing="58" heading="55" dribbling="36" speed="83" stamina="72" aggression="49" strength="64" fitness="63" creativity="59"/>	
			</player>	
			<player id="Vernon Anita" name="Vernon Anita" birthday="04-04-1989" positions="fb" nationality="ne" number="5">
				<stats passing="62" tackling="65" shooting="38" crossing="64" heading="65" dribbling="64" speed="67" stamina="69" aggression="54" strength="63" fitness="78" creativity="58"/>
			</player>
			<player id="Bruno Silva" name="Bruno Silva" birthday="29-03-1989" positions="fb" nationality="ur" number="22">
				<stats passing="64" tackling="71" shooting="34" crossing="54" heading="68" dribbling="37" speed="59" stamina="75" aggression="54" strength="67" fitness="68" creativity="53"/>
			</player>
			<player id="Daley Blind" name="Daley Blind" birthday="09-03-1990" positions="fb-cb" nationality="ne" number="17">
				<stats passing="58" tackling="72" shooting="44" crossing="38" heading="74" dribbling="53" speed="59" stamina="70" aggression="89" strength="63" fitness="84" creativity="59"/>				
			</player>
			<player id="Oleguer Presas" name="Oleguer Presas" birthday="02-02-1980" positions="cb" nationality="es" number="23">
				<stats passing="64" tackling="77" shooting="25" crossing="16" heading="87" dribbling="26" speed="65" stamina="70" aggression="70" strength="80" fitness="70" creativity="45"/>				
			</player>
			<player id="Toby Alderweireld" name="Toby Alderweireld" birthday="02-03-1989" positions="cb" nationality="be" number="3">
				<stats passing="65" tackling="69" shooting="30" crossing="58" heading="60" dribbling="54" speed="69" stamina="70" aggression="60" strength="65" fitness="70" creativity="55"/>
			</player>
			<player id="Jan Vertonghen" name="Jan Vertonghen" birthday="24-04-1987" positions="cb" nationality="be" number="4">
				<stats passing="58" tackling="80" shooting="23" crossing="17" heading="89" dribbling="17" speed="52" stamina="68" aggression="69" strength="73" fitness="40" creativity="44"/>
			</player>
			<player id="Andre Ooijer" name="Andre Ooijer" birthday="11-07-1974" positions="cb" nationality="ne" number="13">
				<stats passing="58" tackling="74" shooting="44" crossing="58" heading="69" dribbling="54" speed="68" stamina="67" aggression="44" strength="53" fitness="85" creativity="54"/>
			</player>
			<player id="Eyong Enoh" name="Eyong Enoh" birthday="23-03-1986" positions="dm" nationality="cm" number="6">
				<stats passing="58" tackling="60" shooting="42" crossing="68" heading="35" dribbling="53" speed="54" stamina="68" aggression="39" strength="42" fitness="79" creativity="59"/>	
			</player>
			<player id="Rasmus Lindgren" name="Rasmus Lindgren" birthday="29-11-1984" positions="cm" nationality="sw" number="18">
				<stats passing="62" tackling="76" shooting="60" crossing="34" heading="67" dribbling="58" speed="58" stamina="74" aggression="83" strength="82" fitness="75" creativity="46"/>
			</player>
			<player id="Teemu Tainio" name="Teemu Tainio" birthday="27-11-1979" positions="cm-dm-sm" nationality="fi" number="19">
				<stats passing="59" tackling="74" shooting="60" crossing="39" heading="74" dribbling="49" speed="53" stamina="68" aggression="64" strength="89" fitness="54" creativity="44"/>
			</player>
			<player id="Demy de Zeeuw" name="Demy de Zeeuw" birthday="26-05-1983" positions="dm" nationality="ne" number="20">
				<stats passing="58" tackling="39" shooting="58" crossing="68" heading="39" dribbling="56" speed="63" stamina="82" aggression="69" strength="54" fitness="73" creativity="59"/>	
			</player>
			<player id="Christian Eriksen" name="Christian Eriksen" birthday="14-02-1992" positions="am-sm" nationality="dn" number="8">
				<stats passing="75" tackling="58" shooting="53" crossing="73" heading="39" dribbling="57" speed="58" stamina="78" aggression="34" strength="64" fitness="42" creativity="69"/>		
			</player>
			<player id="Siem de Jong" name="Siem de Jong" birthday="28-01-1989" positions="am-sm" nationality="ne" number="10">
				<stats passing="69" tackling="53" shooting="45" crossing="75" heading="64" dribbling="69" speed="54" stamina="63" aggression="35" strength="54" fitness="64" creativity="75"/>		
			</player>
			<player id="Urby Emanuelson" name="Urby Emanuelson" birthday="16-06-1986" positions="sm-fb" nationality="ne" number="11">
				<stats passing="70" tackling="38" shooting="58" crossing="70" heading="15" dribbling="70" speed="63" stamina="68" aggression="44" strength="38" fitness="60" creativity="65"/>		
			</player>
			<player id="Nicolas Lodeiro" name="Nicolas Lodeiro" birthday="21-03-1989" positions="am-sm-cm" nationality="ur" number="15">
				<stats passing="65" tackling="47" shooting="64" crossing="70" heading="58" dribbling="68" speed="59" stamina="75" aggression="60" strength="60" fitness="70" creativity="60"/>	
			</player>
			<player id="Kenneth Vermeer" name="Kenneth Vermeer" birthday="10-01-1986" positions="gk" nationality="ne" number="12">
				<stats catching="70" shotStopping="70" distribution="45" fitness="60" stamina="35"/>		
			</player>
			<player id="Miralem Sulejmani" name="Miralem Sulejmani" birthday="05-12-1988" positions="cf-wf" nationality="se" number="7">
				<stats passing="45" tackling="20" shooting="54" crossing="59" heading="40" dribbling="75" speed="80" stamina="64" aggression="30" strength="60" fitness="75" creativity="49"/>		
			</player>
			<player id="Mounir El Hamdaoui" name="Mounir El Hamdaoui" birthday="14-07-1984" positions="cf" nationality="mo" number="9">
				<stats passing="59" tackling="12" shooting="43" crossing="60" heading="63" dribbling="73" speed="70" stamina="67" aggression="58" strength="75" fitness="66" creativity="70"/>		
			</player>
			<player id="Luis Suarez" name="Luis Suarez" birthday="24-01-1987" positions="cf" nationality="ur" number="16">
				<stats passing="65" tackling="16" shooting="71" crossing="58" heading="54" dribbling="50" speed="75" stamina="80" aggression="60" strength="29" fitness="73" creativity="48"/>		
			</player>
			<player id="Dario Cvitanich" name="Dario Cvitanich" birthday="16-05-1984" positions="cf" nationality="ar" number="27">
				<stats passing="70" tackling="34" shooting="68" crossing="49" heading="76" dribbling="70" speed="65" stamina="75" aggression="53" strength="75" fitness="67" creativity="68"/>		
			</player>
			<player id="Aras Ozbiliz" name="Aras Ozbiliz" birthday="09-03-1990" positions="wf" nationality="tu" number="33">
				<stats passing="63" tackling="54" shooting="60" crossing="36" heading="77" dribbling="53" speed="55" stamina="70" aggression="44" strength="78" fitness="68" creativity="45"/>		
			</player>
			<player id="Jeroen Verhoeven" name="Jeroen Verhoeven" birthday="30-04-1980" positions="gk" nationality="ne" number="30">
				<stats catching="56" shotStopping="72" distribution="79" fitness="62" stamina="58"/>		
			</player>
		</players>
	</club>

<club shirtColor="0xFF0000" sleevesColor="0xFFFFFF" stripesType="none">
		<name><![CDATA[Dynamo Kyiv]]></name>
		<profile>60</profile>
		<players>
			<player id="Oleksandr Shovkovskiy" name="Oleksandr Shovkovskiy" birthday="02-01-1975" positions="gk" nationality="uk" number="1">
				<stats catching="59" shotStopping="77" distribution="61" fitness="55" stamina="71"/>
			</player>
			<player id="Taras Mykhalyk" name="Taras Mykhalyk" birthday="28-10-1983" positions="cb-fb" nationality="uk" number="17">
				<stats passing="51" tackling="74" shooting="33" crossing="38" heading="78" dribbling="42" speed="74" stamina="75" aggression="82" strength="78" fitness="54" creativity="37"/>	
			</player>	
			<player id="Goran Popov" name="Goran Popov" birthday="02-10-1984" positions="fb" nationality="yu" number="6">
				<stats passing="51" tackling="68" shooting="23" crossing="54" heading="37" dribbling="54" speed="83" stamina="79" aggression="49" strength="47" fitness="68" creativity="38"/>
			</player>
			<player id="Leandro Almeida" name="Leandro Almeida" birthday="14-03-1987" positions="cb" nationality="br" number="44">
				<stats passing="37" tackling="68" shooting="34" crossing="39" heading="53" dribbling="51" speed="58" stamina="64" aggression="78" strength="63" fitness="49" creativity="37"/>				
			</player>
			<player id="Danilo da Silva" name="Danilo da Silva" birthday="24-11-1986" positions="cb" nationality="br" number="2">
				<stats passing="47" tackling="79" shooting="33" crossing="17" heading="84" dribbling="34" speed="55" stamina="45" aggression="65" strength="85" fitness="29" creativity="37"/>				
			</player>
			<player id="Betao" name="Betao" birthday="11-11-1983" positions="cb" nationality="br" number="3">
				<stats passing="56" tackling="78" shooting="34" crossing="39" heading="72" dribbling="43" speed="59" stamina="88" aggression="64" strength="75" fitness="69" creativity="50"/>
			</player>
			<player id="Yevhen Khacheridi" name="Yevhen Khacheridi" birthday="28-07-1987" positions="cb-fb" nationality="uk" number="34">
				<stats passing="43" tackling="68" shooting="22" crossing="32" heading="73" dribbling="28" speed="54" stamina="57" aggression="58" strength="75" fitness="68" creativity="38"/>
			</player>
			<player id="Andriy Nesmachniy" name="Andriy Nesmachniy" birthday="28-02-1979" positions="fb" nationality="ru" number="26">
				<stats passing="52" tackling="73" shooting="34" crossing="65" heading="64" dribbling="59" speed="78" stamina="79" aggression="68" strength="79" fitness="75" creativity="53"/>
			</player>
			<player id="Badr El Kaddouri" name="Badr El Kaddouri" birthday="31-01-1981" positions="fb" nationality="mo" number="30">
				<stats passing="59" tackling="58" shooting="64" crossing="69" heading="29" dribbling="48" speed="63" stamina="75" aggression="48" strength="49" fitness="64" creativity="48"/>	
			</player>
			<player id="Tiberiu Ghimoane" name="Tiberiu Ghimoane" birthday="18-06-1981" positions="cm" nationality="ro" number="4">
				<stats passing="60" tackling="64" shooting="56" crossing="54" heading="78" dribbling="44" speed="44" stamina="85" aggression="91" strength="75" fitness="75" creativity="52"/>	
			</player>
			<player id="Ognjen Vukojevic" name="Ognjen Vukojevic" birthday="20-12-1983" positions="dm" nationality="cr" number="5">
				<stats passing="58" tackling="53" shooting="37" crossing="54" heading="64" dribbling="65" speed="59" stamina="65" aggression="83" strength="75" fitness="70" creativity="59"/>
			</player>
			<player id="Facundo Bertoglio" name="Facundo Bertoglio" birthday="30-06-1990" positions="cm" nationality="ar" number="18">
				<stats passing="70" tackling="75" shooting="53" crossing="59" heading="52" dribbling="53" speed="54" stamina="75" aggression="93" strength="64" fitness="43" creativity="70"/>	
			</player>
			<player id="Denys Harmash" name="Denys Harmash" birthday="19-04-1990" positions="cm" nationality="uk" number="19">
				<stats passing="74" tackling="58" shooting="45" crossing="58" heading="42" dribbling="59" speed="54" stamina="67" aggression="54" strength="54" fitness="54" creativity="70"/>		
			</player>
			<player id="Oleh Husyev" name="Oleh Husyev" birthday="25-04-1983" positions="am-sm" nationality="uk" number="20">
				<stats passing="68" tackling="12" shooting="54" crossing="58" heading="34" dribbling="78" speed="71" stamina="64" aggression="39" strength="44" fitness="69" creativity="75"/>		
			</player>
			<player id="Gerson Magrao" name="Gerson Magrao" birthday="13-06-1985" positions="sm" nationality="br" number="21">
				<stats passing="52" tackling="44" shooting="46" crossing="37" heading="47" dribbling="77" speed="88" stamina="75" aggression="65" strength="56" fitness="75" creativity="44"/>		
			</player>
			<player id="Roman Eremenko" name="Roman Eremenko" birthday="19-03-1987" positions="sm" nationality="ru" number="23">
				<stats passing="33" tackling="19" shooting="54" crossing="58" heading="22" dribbling="59" speed="70" stamina="58" aggression="54" strength="59" fitness="90" creativity="54"/>	
			</player>
			<player id="Stanislav Bohush" name="Stanislav Bohush" birthday="25-10-1983" positions="gk" nationality="uk" number="31">
				<stats catching="74" shotStopping="64" distribution="69" fitness="45" stamina="70"/>		
			</player>
			<player id="Milos Ninkovic" name="Milos Ninkovic" birthday="25-12-1984" positions="cm-am" nationality="se" number="36">
				<stats passing="60" tackling="55" shooting="65" crossing="65" heading="84" dribbling="54" speed="65" stamina="44" aggression="75" strength="85" fitness="38" creativity="55"/>		
			</player>
			<player id="Frank Temile" name="Frank Temile" birthday="15-07-1990" positions="am-cf" nationality="ng" number="14">
				<stats passing="54" tackling="8" shooting="59" crossing="37" heading="39" dribbling="54" speed="74" stamina="85" aggression="17" strength="37" fitness="85" creativity="58"/>		
			</player>
			<player id="Andriy Shevchenko" name="Andriy Shevchenko" birthday="29-09-1976" positions="cf" nationality="uk" number="7">
				<stats passing="57" tackling="27" shooting="89" crossing="43" heading="74" dribbling="58" speed="75" stamina="68" aggression="60" strength="67" fitness="70" creativity="56"/>		
			</player>
			<player id="Andriy Yarmolenko" name="Andriy Yarmolenko" birthday="23-10-1989" positions="cf" nationality="uk" number="9">
				<stats passing="49" tackling="23" shooting="57" crossing="52" heading="68" dribbling="56" speed="64" stamina="66" aggression="34" strength="75" fitness="64" creativity="48"/>		
			</player>
			<player id="Artem Milevskiy" name="Artem Milevskiy" birthday="12-01-1985" positions="cf" nationality="uk" number="10">
				<stats passing="53" tackling="34" shooting="51" crossing="56" heading="64" dribbling="64" speed="74" stamina="47" aggression="43" strength="74" fitness="72" creativity="43"/>		
			</player>
			<player id="Andre" name="Andre" birthday="27-09-1990" positions="cf" nationality="br" number="11">
				<stats passing="58" tackling="38" shooting="63" crossing="54" heading="87" dribbling="44" speed="65" stamina="60" aggression="78" strength="90" fitness="54" creativity="55"/>		
			</player>
			<player id="Maksym Koval" name="Maksym Koval" birthday="09-12-1992" positions="gk" nationality="uk" number="35">
				<stats catching="58" shotStopping="66" distribution="56" fitness="63" stamina="53"/>		
			</player>
		</players>
	</club>

<club shirtColor="0xFF0000" sleevesColor="0xFFFFFF" stripesType="none">
		<name><![CDATA[CSKA Moskow]]></name>
		<profile>60</profile>
		<players>
			<player id="Sergei Chepchugov" name="Sergei Chepchugov" birthday="15-07-1985" positions="gk" nationality="ru" number="1">
				<stats catching="68" shotStopping="73" distribution="69" fitness="74" stamina="58"/>
			</player>
			<player id="Deividas Semberas" name="Deividas Semberas" birthday="02-08-1978" positions="fb" nationality="li" number="2">
				<stats passing="53" tackling="66" shooting="35" crossing="41" heading="67" dribbling="39" speed="62" stamina="75" aggression="84" strength="77" fitness="69" creativity="37"/>	
			</player>	
			<player id="Viktor Vasin" name="Viktor Vasin" birthday="06-10-1988" positions="cb-fb" nationality="ru" number="3">
				<stats passing="32" tackling="68" shooting="37" crossing="54" heading="64" dribbling="48" speed="55" stamina="58" aggression="69" strength="70" fitness="60" creativity="37"/>
			</player>
			<player id="Sergei Ignashevich" name="Sergei Ignashevich" birthday="14-07-1979" positions="cb=fb" nationality="ru" number="4">
				<stats passing="44" tackling="73" shooting="29" crossing="52" heading="70" dribbling="43" speed="58" stamina="68" aggression="70" strength="57" fitness="75" creativity="39"/>
			</player>
			<player id="Aleksei Berezutski" name="Aleksei Berezutski" birthday="20-06-1982" positions="cb-fb" nationality="ru" number="6">
				<stats passing="63" tackling="78" shooting="32" crossing="64" heading="84" dribbling="54" speed="36" stamina="74" aggression="59" strength="62" fitness="70" creativity="54"/>				
			</player>
			<player id="Kirill Nababkin" name="Kirill Nababkin" birthday="08-09-1987" positions="fb" nationality="ru" number="14">
				<stats passing="59" tackling="52" shooting="54" crossing="64" heading="34" dribbling="51" speed="60" stamina="64" aggression="39" strength="38" fitness="68" creativity="60"/>				
			</player>
			<player id="Georgi Schennikov" name="Georgi Schennikov" birthday="27-04-1991" positions="cb" nationality="ru" number="42">
				<stats passing="44" tackling="76" shooting="49" crossing="32" heading="79" dribbling="26" speed="63" stamina="67" aggression="69" strength="94" fitness="74" creativity="27"/>
			</player>
			<player id="Vasili Berezutski" name="Vasili Berezutski" birthday="20-06-1982" positions="cb" nationality="ru" number="24">
				<stats passing="64" tackling="73" shooting="15" crossing="34" heading="79" dribbling="33" speed="64" stamina="75" aggression="62" strength="74" fitness="75" creativity="44"/>
			</player>
			<player id="Chidi Odiah" name="Chidi Odiah" birthday="17-12-1983" positions="fb" nationality="ng" number="15">
				<stats passing="61" tackling="72" shooting="43" crossing="39" heading="74" dribbling="38" speed="59" stamina="68" aggression="65" strength="75" fitness="62" creativity="54"/>
			</player>
			<player id="Pavel Mamayev" name="Pavel Mamayev" birthday="17-09-1988" positions="cm-dm" nationality="ru" number="11">
				<stats passing="73" tackling="50" shooting="39" crossing="74" heading="58" dribbling="55" speed="56" stamina="69" aggression="66" strength="64" fitness="70" creativity="64"/>	
			</player>
			<player id="Evgeni Aldonin" name="Evgeni Aldonin" birthday="22-01-1980" positions="cm" nationality="uk" number="22">
				<stats passing="58" tackling="70" shooting="34" crossing="44" heading="78" dribbling="39" speed="55" stamina="74" aggression="78" strength="79" fitness="60" creativity="54"/>	
			</player>
			<player id="Keisuke Honda" name="Keisuke Honda" birthday="13-06-1986" positions="cm-sm-am" nationality="ja" number="7">
				<stats passing="54" tackling="64" shooting="54" crossing="64" heading="65" dribbling="53" speed="59" stamina="84" aggression="70" strength="70" fitness="84" creativity="59"/>
			</player>
			<player id="Nika Piliyev" name="Nika Piliyev" birthday="21-03-1991" positions="cm-sm" nationality="ru" number="70">
				<stats passing="68" tackling="40" shooting="57" crossing="70" heading="39" dribbling="70" speed="49" stamina="60" aggression="56" strength="59" fitness="59" creativity="70"/>	
			</player>
			<player id="Mark Gonzalez" name="Mark Gonzalez" birthday="10-07-1984" positions="sm" nationality="ch" number="13">
				<stats passing="59" tackling="56" shooting="58" crossing="65" heading="79" dribbling="64" speed="58" stamina="60" aggression="74" strength="80" fitness="75" creativity="65"/>		
			</player>
			<player id="Alan Dzagoev" name="Alan Dzagoev" birthday="17-06-1990" positions="cm" nationality="ru" number="10">
				<stats passing="70" tackling="70" shooting="42" crossing="59" heading="44" dribbling="51" speed="61" stamina="79" aggression="64" strength="59" fitness="79" creativity="50"/>		
			</player>
			<player id="Elvir Rahimic" name="Elvir Rahimic" birthday="04-04-1976" positions="cm" nationality="ru" number="25">
				<stats passing="68" tackling="69" shooting="65" crossing="44" heading="52" dribbling="51" speed="55" stamina="68" aggression="70" strength="63" fitness="75" creativity="65"/>		
			</player>
			<player id="Zoran Tosic" name="Zoran Tosic" birthday="28-04-1987" positions="sm" nationality="se" number="21">
				<stats passing="64" tackling="29" shooting="44" crossing="78" heading="25" dribbling="75" speed="80" stamina="65" aggression="35" strength="33" fitness="60" creativity="64"/>	
			</player>
			<player id="Igor Akinfeev" name="Igor Akinfeev" birthday="08-04-1986" positions="gk" nationality="ru" number="35">
				<stats catching="57" shotStopping="65" distribution="62" fitness="60" stamina="59"/>		
			</player>
			<player id="Sekou Oliseh" name="Sekou Oliseh" birthday="05-06-1990" positions="sm" nationality="li" number="26">
				<stats passing="64" tackling="39" shooting="60" crossing="69" heading="38" dribbling="69" speed="75" stamina="70" aggression="29" strength="33" fitness="70" creativity="68"/>		
			</player>
			<player id="Seydou Doumbia" name="Seydou Doumbia" birthday="31-12-1987" positions="cf" nationality="iv" number="8">
				<stats passing="75" tackling="34" shooting="63" crossing="58" heading="69" dribbling="64" speed="65" stamina="53" aggression="55" strength="75" fitness="64" creativity="70"/>		
			</player>
			<player id="Vagner Love" name="Vagner Love" birthday="11-06-1984" positions="cf" nationality="br" number="9">
				<stats passing="62" tackling="30" shooting="59" crossing="60" heading="59" dribbling="64" speed="68" stamina="75" aggression="88" strength="54" fitness="80" creativity="65"/>		
			</player>
			<player id="Tomas Necid" name="Tomas Necid" birthday="13-08-1989" positions="cf" nationality="cz" number="89">
				<stats passing="53" tackling="29" shooting="56" crossing="51" heading="74" dribbling="64" speed="75" stamina="59" aggression="53" strength="89" fitness="39" creativity="44"/>		
			</player>
		</players>	
	</club>

<club shirtColor="0xFF0000" sleevesColor="0xFFFFFF" stripesType="none">
		<name><![CDATA[Olympiacos]]></name>
		<profile>60</profile>
		<players>
			<player id="Nikos Papadopoulos" name="Nikos Papadopoulos" birthday="11-04-1990" positions="gk" nationality="gr" number="1">
				<stats catching="74" shotStopping="79" distribution="38" fitness="58" stamina="54"/>
			</player>
			<player id="Ioannis Maniatis" name="Ioannis Maniatis" birthday="12-10-1986" positions="fb" nationality="gr" number="2">
				<stats passing="53" tackling="68" shooting="46" crossing="77" heading="58" dribbling="64" speed="52" stamina="89" aggression="54" strength="50" fitness="78" creativity="54"/>	
			</player>	
			<player id="Francois Modesto" name="Francois Modesto" birthday="19-08-1978" positions="fb" nationality="fr" number="3">
				<stats passing="59" tackling="74" shooting="21" crossing="54" heading="69" dribbling="52" speed="65" stamina="78" aggression="84" strength="80" fitness="76" creativity="49"/>
			</player>
			<player id="Olof Mellberg" name="Olof Mellberg" birthday="03-09-1977" positions="cb" nationality="sw" number="4">
				<stats passing="38" tackling="68" shooting="42" crossing="28" heading="73" dribbling="34" speed="64" stamina="65" aggression="72" strength="73" fitness="79" creativity="55"/>
			</player>
			<player id="Raul Bravo" name="Raul Bravo" birthday="14-04-1981" positions="fb-cb" nationality="es" number="15">
				<stats passing="61" tackling="74" shooting="27" crossing="29" heading="74" dribbling="12" speed="63" stamina="79" aggression="59" strength="68" fitness="64" creativity="53"/>				
			</player>
			<player id="Jose Holebas" name="Jose Holebas" birthday="27-06-1984" positions="cb" nationality="ge" number="20">
				<stats passing="75" tackling="74" shooting="54" crossing="24" heading="79" dribbling="54" speed="69" stamina="69" aggression="58" strength="70" fitness="63" creativity="58"/>				
			</player>
			<player id="Vasilios Torosidis" name="Vasilios Torosidis" birthday="10-06-1985" positions="fb" nationality="gr" number="35">
				<stats passing="70" tackling="71" shooting="38" crossing="70" heading="64" dribbling="54" speed="58" stamina="73" aggression="94" strength="83" fitness="90" creativity="64"/>
			</player>
			<player id="Georgios Galitsios" name="Georgios Galitsios" birthday="06-07-1986" positions="fb" nationality="gr" number="5">
				<stats passing="72" tackling="54" shooting="71" crossing="79" heading="54" dribbling="29" speed="64" stamina="94" aggression="53" strength="58" fitness="60" creativity="56"/>
			</player>
			<player id="Ariel Ibagaza" name="Ariel Ibagaza" birthday="27-10-1976" positions="dm-cm" nationality="ar" number="7">
				<stats passing="74" tackling="76" shooting="39" crossing="42" heading="54" dribbling="50" speed="63" stamina="74" aggression="89" strength="73" fitness="77" creativity="54"/>
			</player>
			<player id="Dudu" name="Dudu" birthday="15-04-1983" positions="dm-cm" nationality="br" number="8">
				<stats passing="53" tackling="68" shooting="31" crossing="44" heading="41" dribbling="44" speed="67" stamina="83" aggression="78" strength="79" fitness="81" creativity="42"/>	
			</player>
			<player id="David Fuster" name="David Fuster" birthday="03-02-1982" positions="cm" nationality="es" number="19">
				<stats passing="65" tackling="69" shooting="45" crossing="34" heading="41" dribbling="39" speed="59" stamina="90" aggression="59" strength="45" fitness="78" creativity="48"/>	
			</player>
			<player id="Ioannis Papadopoulos" name="Ioannis Papadopoulos" birthday="09-03-1989" positions="cm" nationality="gr" number="33">
				<stats passing="69" tackling="22" shooting="44" crossing="64" heading="29" dribbling="72" speed="70" stamina="75" aggression="43" strength="47" fitness="63" creativity="73"/>
			</player>
			<player id="Moises Hurtado" name="Moises Hurtado" birthday="20-02-1981" positions="dm" nationality="es" number="30">
				<stats passing="44" tackling="15" shooting="43" crossing="54" heading="23" dribbling="58" speed="72" stamina="68" aggression="52" strength="53" fitness="89" creativity="54"/>	
			</player>
			<player id="Jaouad Zairi" name="Jaouad Zairi" birthday="17-04-1982" positions="am-sm" nationality="mo" number="11">
				<stats passing="55" tackling="37" shooting="58" crossing="56" heading="44" dribbling="50" speed="58" stamina="68" aggression="64" strength="58" fitness="75" creativity="58"/>		
			</player>
			<player id="Ioannis Fetfatzidis" name="Ioannis Fetfatzidis" birthday="21-12-1990" positions="cm-am-sm" nationality="gr" number="18">
				<stats passing="63" tackling="62" shooting="55" crossing="53" heading="39" dribbling="74" speed="78" stamina="71" aggression="44" strength="51" fitness="68" creativity="65"/>		
			</player>
			<player id="Dennis Rommedahl" name="Dennis Rommedahl" birthday="22-07-1978" positions="sm-am" nationality="dn" number="24">
				<stats passing="65" tackling="13" shooting="69" crossing="84" heading="22" dribbling="63" speed="84" stamina="79" aggression="66" strength="54" fitness="39" creativity="58"/>		
			</player>
			<player id="Albert Riera" name="Albert Riera" birthday="15-04-1982" positions="sm" nationality="es" number="77">
				<stats passing="77" tackling="54" shooting="54" crossing="58" heading="23" dribbling="69" speed="55" stamina="54" aggression="59" strength="41" fitness="63" creativity="68"/>	
			</player>
			<player id="Balazs Megyeri" name="Balazs Megyeri" birthday="31-03-1990" positions="gk" nationality="hu" number="42">
				<stats catching="53" shotStopping="64" distribution="62" fitness="59" stamina="22"/>		
			</player>
			<player id="Marko Pantelic" name="Marko Pantelic" birthday="15-09-1978" positions="cf" nationality="se" number="9">
				<stats passing="75" tackling="77" shooting="69" crossing="64" heading="84" dribbling="44" speed="45" stamina="90" aggression="80" strength="87" fitness="79" creativity="58"/>		
			</player>
			<player id="Kevin Mirallas" name="Kevin Mirallas" birthday="05-10-1987" positions="cf" nationality="be" number="14">
				<stats passing="74" tackling="33" shooting="69" crossing="74" heading="24" dribbling="73" speed="41" stamina="58" aggression="43" strength="59" fitness="72" creativity="69"/>		
			</player>
			<player id="Konstantinos Mitroglou" name="Konstantinos Mitroglou" birthday="12-03-1988" positions="cf" nationality="gr" number="22">
				<stats passing="59" tackling="25" shooting="76" crossing="27" heading="64" dribbling="53" speed="69" stamina="80" aggression="59" strength="78" fitness="74" creativity="53"/>		
			</player>
			<player id="Krisztian Nemeth" name="Krisztian Nemeth" birthday="05-01-1989" positions="cf" nationality="hu" number="29">
				<stats passing="68" tackling="27" shooting="65" crossing="47" heading="64" dribbling="58" speed="65" stamina="47" aggression="74" strength="69" fitness="49" creativity="64"/>		
			</player>
		</players>	
	</club>
</data>;
         var _loc2_:League = new League();
         _loc2_.name = "euroLeagues";
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_.club.length())
         {
            _loc4_ = TeamHelper.makeClub(_loc1_.club[_loc3_]);
            _loc2_.addEntrant(_loc4_);
            _loc3_++;
         }
         Main.currentGame.otherLeagues.push(_loc2_);
         return _loc2_;
      }
      
      private static function makeLegends() : void
      {
         var _loc3_:Player = null;
         var _loc1_:XML = <data>
<!-- this is some classic players to add to the pot -->
	<player id="Diego Maradona" name="Diego Maradona" birthday="30-10-1960" positions="am-cf" nationality="ag">
		<stats passing="85" tackling="68" shooting="88" crossing="79" heading="75" dribbling="97" speed="93" stamina="85" aggression="88" strength="84" fitness="78" creativity="94"/>
	</player>	
	<player id="Pelé" name="Pelé" birthday="23-10-1940" positions="cf" nationality="br">
		<stats passing="80" tackling="73" shooting="95" crossing="79" heading="92" dribbling="90" speed="93" stamina="85" aggression="77" strength="91" fitness="90" creativity="84"/>
	</player>	
	<player id="David Seaman" name="David Seaman" birthday="19-09-1963" positions="gk" nationality="en">
		<stats catching="82" shotStopping="83" distribution="71" fitness="75" stamina="85"/>
	</player>
	<player id="Peter Schmeichel" name="Peter Schmeichel" birthday="18-11-1963" positions="gk" nationality="dn">
		<stats catching="88" shotStopping="92" distribution="85" fitness="75" stamina="85"/>
	</player>
	<player id="Matthew Le Tissier" name="Matthew Le Tissier" birthday="14-10-1968" positions="am" nationality="en">
		<stats passing="83" tackling="22" shooting="73" crossing="79" heading="61" dribbling="82" speed="55" stamina="70" aggression="58" strength="62" fitness="75" creativity="93"/>
	</player>	
	<player id="Eric Cantona" name="Eric Cantona" birthday="24-05-1966" positions="cf" nationality="fr">
		<stats passing="79" tackling="34" shooting="88" crossing="69" heading="77" dribbling="85" speed="78" stamina="85" aggression="100" strength="71" fitness="90" creativity="100"/>
	</player>	
	<player id="Dennis Bergkamp" name="Dennis Bergkamp" birthday="10-05-1969" positions="cf" nationality="ne">
		<stats passing="80" tackling="73" shooting="81" crossing="79" heading="72" dribbling="82" speed="79" stamina="85" aggression="61" strength="70" fitness="90" creativity="92"/>
	</player>	
	<player id="Alan Shearer" name="Alan Shearer" birthday="13-08-1970" positions="cf" nationality="en">
		<stats passing="65" tackling="32" shooting="91" crossing="52" heading="88" dribbling="45" speed="71" stamina="85" aggression="85" strength="93" fitness="90" creativity="76"/>
	</player>	
	<player id="Gianfranco Zola" name="Gianfranco Zola" birthday="05-06-1966" positions="cf-am" nationality="it">
		<stats passing="88" tackling="23" shooting="87" crossing="89" heading="66" dribbling="90" speed="95" stamina="85" aggression="10" strength="64" fitness="90" creativity="95"/>
	</player>	
	<player id="Roy Keane" name="Roy Keane" birthday="10-08-1971" positions="dm" nationality="ir">
		<stats passing="72" tackling="88" shooting="57" crossing="52" heading="76" dribbling="61" speed="74" stamina="100" aggression="100" strength="91" fitness="90" creativity="75"/>
	</player>	
	<player id="David Beckham" name="David Beckham" birthday="02-05-1975" positions="sm" nationality="en">
		<stats passing="80" tackling="55" shooting="67" crossing="93" heading="64" dribbling="72" speed="70" stamina="85" aggression="77" strength="91" fitness="90" creativity="84"/>
	</player>	
	<player id="Paul Gascoigne" name="Paul Gascoigne" birthday="27-05-1967" positions="cm-am" nationality="en">
		<stats passing="80" tackling="62" shooting="77" crossing="79" heading="62" dribbling="80" speed="68" stamina="85" aggression="90" strength="91" fitness="65" creativity="91"/>
	</player>	
	<player id="Jurgen Klinsmann" name="Jurgen Klinsmann" birthday="30-07-1964" positions="cf" nationality="ge">
		<stats passing="71" tackling="55" shooting="93" crossing="57" heading="79" dribbling="67" speed="85" stamina="85" aggression="77" strength="91" fitness="90" creativity="75"/>
	</player>	
	<player id="Peter Beardsley" name="Peter Beardsley" birthday="18-01-1961" positions="cf-am" nationality="en">
		<stats passing="80" tackling="55" shooting="81" crossing="65" heading="70" dribbling="93" speed="95" stamina="85" aggression="77" strength="77" fitness="90" creativity="75"/>
	</player>	
	<player id="Stuart Pearce" name="Stuart Pearce" birthday="24-04-1962" positions="fb" nationality="en">
		<stats passing="61" tackling="84" shooting="41" crossing="71" heading="68" dribbling="68" speed="79" stamina="85" aggression="93" strength="91" fitness="90" creativity="50"/>
	</player>	
	<player id="Denis Irwin" name="Denis Irwin" birthday="31-10-1965" positions="fb" nationality="ir">
		<stats passing="68" tackling="82" shooting="66" crossing="85" heading="75" dribbling="86" speed="77" stamina="85" aggression="55" strength="91" fitness="90" creativity="62"/>
	</player>	
	<player id="Paolo Di Canio" name="Paolo Di Canio" birthday="09-07-1968" positions="cf" nationality="it">
		<stats passing="80" tackling="66" shooting="81" crossing="72" heading="71" dribbling="77" speed="68" stamina="85" aggression="98" strength="71" fitness="90" creativity="91"/>
	</player>	
	<player id="Ruud Gullit" name="Ruud Gullit" birthday="01-09-1962" positions="cb-cm-cf" nationality="ne">
		<stats passing="84" tackling="78" shooting="67" crossing="79" heading="71" dribbling="73" speed="75" stamina="85" aggression="23" strength="67" fitness="90" creativity="88"/>
	</player>	
	<player id="Graeme Le Saux" name="Graeme Le Saux" birthday="17-10-1968" positions="fb-sm" nationality="en">
		<stats passing="71" tackling="77" shooting="22" crossing="79" heading="71" dribbling="77" speed="76" stamina="85" aggression="45" strength="66" fitness="90" creativity="82"/>
	</player>	
	<player id="Steve Bould" name="Steve Bould" birthday="16-11-1962" positions="cb" nationality="en">
		<stats passing="63" tackling="86" shooting="17" crossing="14" heading="87" dribbling="10" speed="64" stamina="85" aggression="77" strength="93" fitness="90" creativity="12"/>
	</player>	
	<player id="Tony Adams" name="Tony Adams" birthday="10-10-1966" positions="cb" nationality="en">
		<stats passing="54" tackling="91" shooting="7" crossing="41" heading="92" dribbling="61" speed="72" stamina="85" aggression="65" strength="91" fitness="90" creativity="25"/>
	</player>	
	<player id="Jaap Stam" name="Jaap Stam" birthday="17-07-1972" positions="cb" nationality="ne">
		<stats passing="72" tackling="88" shooting="34" crossing="40" heading="91" dribbling="75" speed="72" stamina="85" aggression="83" strength="82" fitness="70" creativity="79"/>
	</player>	
	<player id="Andrei Kanchelskis" name="Andrei Kanchelskis" birthday="23-01-1969" positions="sm" nationality="ru">
		<stats passing="77" tackling="37" shooting="68" crossing="83" heading="53" dribbling="91" speed="95" stamina="90" aggression="49" strength="61" fitness="90" creativity="84"/>
	</player>	
	<player id="Paul Ince" name="Paul Ince" birthday="21-10-1967" positions="dm-cm" nationality="en">
		<stats passing="81" tackling="90" shooting="67" crossing="79" heading="81" dribbling="67" speed="81" stamina="90" aggression="96" strength="91" fitness="90" creativity="70"/>
	</player>	
	<player id="Emmanuel Petit" name="Emmanuel Petit" birthday="22-09-1970" positions="dm" nationality="fr">
		<stats passing="74" tackling="82" shooting="69" crossing="79" heading="77" dribbling="64" speed="78" stamina="85" aggression="77" strength="91" fitness="90" creativity="84"/>
	</player>	
	<player id="David Ginola" name="David Ginola" birthday="25-01-1967" positions="sm" nationality="fr">
		<stats passing="83" tackling="34" shooting="72" crossing="88" heading="34" dribbling="87" speed="88" stamina="85" aggression="67" strength="71" fitness="90" creativity="90"/>
	</player>	
	<player id="Giorgi Kinkladze" name="Giorgi Kinkladze" birthday="06-07-1973" positions="am-cm" nationality="ge">
		<stats passing="77" tackling="43" shooting="79" crossing="75" heading="60" dribbling="97" speed="88" stamina="85" aggression="20" strength="60" fitness="90" creativity="89"/>
	</player>	
	<player id="Igor Stimac" name="Igor Stimac" birthday="06-09-1967" positions="cb" nationality="cr">
		<stats passing="81" tackling="77" shooting="32" crossing="66" heading="81" dribbling="67" speed="61" stamina="85" aggression="40" strength="91" fitness="90" creativity="84"/>
	</player>	
	<player id="Teddy Sheringham" name="Teddy Sheringham" birthday="02-04-1966" positions="cf" nationality="en">
		<stats passing="77" tackling="33" shooting="81" crossing="82" heading="70" dribbling="61" speed="67" stamina="85" aggression="50" strength="71" fitness="70" creativity="88"/>
	</player>	
	<player id="Jay-Jay Okocha" name="Jay-Jay Okocha" birthday="14-08-1973" positions="am" nationality="ng">
		<stats passing="82" tackling="54" shooting="76" crossing="74" heading="67" dribbling="84" speed="86" stamina="85" aggression="71" strength="75" fitness="70" creativity="88"/>
	</player>	
	<player id="Alan Martin" name="Alan Martin" birthday="18-05-1976" positions="cm" nationality="en" ageImprovement="50">
		<stats passing="93" tackling="77" shooting="82" crossing="51" heading="84" dribbling="82" speed="88" stamina="95" aggression="75" strength="91" fitness="72" creativity="85"/>
	</player>	
	<player id="Jimmy-Floyd Hasselbaink" name="Jimmy-Floyd Hasselbaink" birthday="27-03-1972" positions="cf" nationality="ne">
		<stats passing="57" tackling="33" shooting="87" crossing="61" heading="68" dribbling="70" speed="91" stamina="85" aggression="77" strength="91" fitness="90" creativity="71"/>
	</player>	
<player id="Sam Bellman" name="Sam Bellman" birthday="18-05-1975" positions="cb-dm" nationality="en" ageImprovement="50">
		<stats passing="67" tackling="95" shooting="59" crossing="63" heading="95" dribbling="30" speed="86" stamina="75" aggression="75" strength="87" fitness="75" creativity="25"/>
	</player>
<player id="Alick Stott" name="Alick Stott" birthday="18-05-1984" positions="cf" nationality="en">
		<stats passing="66" tackling="42" shooting="82" crossing="61" heading="76" dribbling="69" speed="75" stamina="75" aggression="45" strength="77" fitness="72" creativity="75"/>
	</player>
<player id="Richard Pendry" name="Richard Pendry" birthday="18-05-1984" positions="fb" nationality="en">
		<stats passing="75" tackling="77" shooting="32" crossing="66" heading="44" dribbling="66" speed="72" stamina="75" aggression="46" strength="65" fitness="72" creativity="87"/>
	</player>
<player id="Keith Martison" name="Keith Martison" birthday="14-02-1988" positions="sm" nationality="en">
		<stats passing="79" tackling="54" shooting="64" crossing="77" heading="66" dribbling="75" speed="89" stamina="82" aggression="74" strength="43" fitness="67" creativity="62"/>
	</player>
<player id="Conor Donovan" name="Conor Donovan" birthday="18-05-1984" positions="cm" nationality="en">
		<stats passing="73" tackling="42" shooting="62" crossing="61" heading="84" dribbling="62" speed="68" stamina="75" aggression="25" strength="91" fitness="72" creativity="85"/>
	</player>
<player id="Meriton Rrustemi" name="Meriton Rrustemi" birthday="18-05-1984" positions="cm" nationality="en">
		<stats passing="73" tackling="42" shooting="62" crossing="61" heading="84" dribbling="62" speed="68" stamina="75" aggression="25" strength="91" fitness="72" creativity="85"/>
	</player>
<player id="Dan Tiller" name="Dan Tiller" birthday="02-07-1987" positions="cm-am" nationality="en">
	<stats passing="80" tackling="31" shooting="54" crossing="62" heading="27" dribbling="79" speed="68" stamina="71" aggression="33" strength="29" fitness="68" creativity="71"/>
	</player>
<player id="Johnny Safi" name="Johnny Safi" birthday="06-05-1983" positions="fb" nationality="en">
	<stats passing="65" tackling="77" shooting="42" crossing="73" heading="69" dribbling="73" speed="88" stamina="89" aggression="74" strength="52" fitness="82" creativity="34"/>
	</player>
<player id="Andrei Rhodes" name="Andrei Rhodes" birthday="22-01-1985" positions="dm" nationality="en">
	<stats passing="79" tackling="47" shooting="58" crossing="84" heading="34" dribbling="80" speed="69" stamina="68" aggression="62" strength="33" fitness="73" creativity="78"/>	
	</player>
<player id="Chris Scotton" name="Chris Scotton" birthday="14-09-1988" positions="cb" nationality="en">
	<stats passing="55" tackling="56" shooting="40" crossing="52" heading="57" dribbling="43" speed="68" stamina="67" aggression="65" strength="57" fitness="68" creativity="45"/>		
	</player>
<player id="Jun Wei" name="Jun Wei" birthday="20-12-1980" positions="cb" nationality="en">
		<stats passing="53" tackling="80" shooting="12" crossing="26" heading="73" dribbling="39" speed="68" stamina="44" aggression="69" strength="84" fitness="30" creativity="44"/>
	</player>
<player id="Albert Popoola" name="Albert Popoola" birthday="22-04-1977" positions="cm-dm" nationality="en">
	<stats passing="63" tackling="64" shooting="55" crossing="60" heading="58" dribbling="59" speed="75" stamina="75" aggression="54" strength="64" fitness="70" creativity="57"/>	
	</player>
</data>;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.player.length())
         {
            _loc3_ = PlayerHelper.makeLegend(_loc1_.player[_loc2_]);
            _loc3_.active = false;
            _loc2_++;
         }
      }
      
      public static function initSeason(param1:Game) : void
      {
         param1.offSeasonNum = 4;
         TeamHelper.newSeason(param1);
         param1.promotedTeams = null;
         var _loc2_:FixturesList = new FixturesList();
         _loc2_.addEventListener(FixturesList.MADE_FIXTURES,fixturesMade);
         _loc2_.generateFixtures(param1);
      }
      
      private static function fixturesMade(param1:Event) : void
      {
         var _loc2_:Game = Main.currentGame;
         _loc2_.fixtureList = param1.target as FixturesList;
         _loc2_.fixtureList.removeEventListener(FixturesList.MADE_FIXTURES,fixturesMade);
         _loc2_.weekNum = 0;
         _loc2_.weekend = true;
         var _loc3_:Date = new Date(StaticInfo.startDate.getTime());
         _loc3_.setFullYear(_loc3_.getFullYear() + _loc2_.seasonNum);
         while(_loc3_.getDay() != 6)
         {
            _loc3_.setDate(_loc3_.getDate() + 1);
         }
         _loc2_.firstWeekend = _loc3_;
         _loc2_.fixtureList.setNextFixtures(_loc2_.weekNum);
         if(_loc2_.fixtureList.weekendMatches.length == 0 && _loc2_.fixtureList.midweekMatches.length == 0)
         {
            ++_loc2_.weekNum;
            _loc2_.fixtureList.setNextFixtures(_loc2_.weekNum);
         }
         _loc2_.goalsList = {};
         doRoundUpdates(INIT_SEASON);
         Main.instance.showScreen(Screen.MAIN_SCREEN);
      }
      
      public static function doRoundUpdates(param1:String = "roundUpdate") : void
      {
         finishUpdateState = param1;
         pleaseWait = new PleaseWaitModal(CopyManager.getCopy("pleaseWait"),CopyManager.getCopy("updatingPlayers"),[]);
         Main.instance.addModal(pleaseWait);
         BudgetEventProxy.addEventListener(TeamHelper.FINISH_TEAM_UPDATE,finishPlayerUpdate);
         TeamHelper.updateTeams();
      }
      
      private static function finishPlayerUpdate(param1:Object = null) : void
      {
         var _loc3_:int = 0;
         BudgetEventProxy.removeEventListener(TeamHelper.FINISH_TEAM_UPDATE,finishPlayerUpdate);
         var _loc2_:Game = Main.currentGame;
         switch(finishUpdateState)
         {
            case INIT_SEASON:
               TeamHelper.checkRetirePlayers(_loc2_);
               _loc3_ = 0;
               while(_loc3_ < _loc2_.playerClub.players.length)
               {
                  StaticInfo.getPlayer(_loc2_.playerClub.players[_loc3_]).newSeason();
                  _loc3_++;
               }
         }
         TweenLite.delayedCall(0.5,waitSave);
      }
      
      private static function waitSave() : void
      {
         if(pleaseWait)
         {
            Main.instance.removeModal(pleaseWait);
         }
         pleaseWait = null;
         SavesManager.saveGame();
      }
      
      public static function nextRound(param1:Game) : void
      {
         var _loc2_:Match = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         param1 = Main.currentGame;
         TransfersEngine.processPlayerTransfers();
         if(canTransfer(param1))
         {
            processOffSeason();
         }
         if(param1.offSeasonNum > 0)
         {
            param1.nextWeek();
            Main.instance.showScreen(Screen.MAIN_SCREEN);
            doRoundUpdates();
         }
         else if(param1.fixtureList.seasonFinished(param1.weekNum))
         {
            Main.instance.showScreen(Screen.END_SEASON);
         }
         else
         {
            _loc3_ = param1.weekend ? param1.fixtureList.weekendMatches : param1.fixtureList.midweekMatches;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               if(_loc3_[_loc4_].club0.club == param1.playerClub || _loc3_[_loc4_].club1.club == param1.playerClub)
               {
                  _loc2_ = _loc3_[_loc4_];
               }
               _loc4_++;
            }
            if(_loc2_)
            {
               param1.nextPlayerMatch = _loc2_;
               Main.instance.showScreen(Screen.PRE_MATCH_SCREEN);
            }
            else
            {
               Main.instance.showScreen(Screen.ROUND_RESULTS_SCREEN);
            }
         }
      }
      
      private static function finishTransfers() : void
      {
      }
      
      public static function addTransferWindow(param1:Boolean) : void
      {
         var _loc2_:Message = new Message();
         _loc2_.title = param1 ? CopyManager.getCopy("transferOpen") : CopyManager.getCopy("transferClosed");
         _loc2_.body = param1 ? CopyManager.getCopy("transferOpenCopy") : CopyManager.getCopy("transferClosedCopy");
         Main.currentGame.userMessages.push(_loc2_);
      }
      
      private static function processOffSeason() : void
      {
         TransfersEngine.doAITeamTransfers(Main.currentGame);
         BudgetEventProxy.dispatchEvent(Game.DATA_CHANGED,null);
      }
      
      public static function storePlayerMatch(param1:Game) : void
      {
         var _loc2_:Array = null;
         var _loc5_:SeasonStats = null;
         var _loc6_:MatchPlayerDetails = null;
         if(param1.matchDetails.match.club0.club == param1.playerClub)
         {
            _loc2_ = param1.matchDetails.team0.players;
         }
         else
         {
            _loc2_ = param1.matchDetails.team1.players;
         }
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc5_ = _loc2_[_loc3_].player.seasonStats[_loc2_[_loc3_].player.seasonStats.length - 1];
            _loc6_ = _loc2_[_loc3_];
            if(_loc6_.timeCameOut == "0")
            {
               ++_loc5_.appearances;
            }
            else if(_loc6_.timeCameOut.length > 0)
            {
               ++_loc5_.subsAppearances;
            }
            _loc5_.goals += _loc6_.goals;
            _loc5_.assists += _loc6_.assists;
            _loc5_.redCards += _loc6_.redCards;
            _loc5_.yellowCards += _loc6_.yellowCards;
            _loc3_++;
         }
         var _loc4_:Match = param1.matchDetails.match;
         _loc4_.workOut();
         if(_loc4_.needsWinner && !_loc4_.loser)
         {
            _loc4_.workOutET();
         }
         if(_loc4_.needsWinner && !_loc4_.loser)
         {
            _loc4_.workOutPenalties();
         }
         param1.matchDetails.match.club0Scorers = param1.matchDetails.team0.getScorers();
         param1.matchDetails.match.club1Scorers = param1.matchDetails.team1.getScorers();
         param1.clubCash += param1.matchDetails.getMatchIncome();
      }
      
      public static function playAMatch(param1:Game) : Boolean
      {
         var _loc2_:Array = param1.getNextMatches();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(!_loc2_[_loc3_].beenPlayed)
            {
               MatchEngine.playAIMatch(_loc2_[_loc3_]);
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      public static function playRoundMatches(param1:Game) : void
      {
         var _loc2_:Array = param1.getNextMatches();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            if(!_loc2_[_loc3_].beenPlayed)
            {
               MatchEngine.playAIMatch(_loc2_[_loc3_]);
            }
            TeamHelper.checkSuspensions(_loc2_[_loc3_].club0.club);
            TeamHelper.checkSuspensions(_loc2_[_loc3_].club1.club);
            _loc3_++;
         }
      }
      
      public static function advanceRound(param1:Game) : void
      {
         TeamHelper.regrowStamina(param1);
         if(param1.weekend)
         {
            param1.weekend = false;
            if(param1.fixtureList.midweekMatches.length == 0)
            {
               TeamHelper.regrowStamina(param1);
               param1.nextWeek();
               param1.fixtureList.setNextFixtures(param1.weekNum);
            }
         }
         else
         {
            param1.nextWeek();
            param1.fixtureList.setNextFixtures(param1.weekNum);
         }
      }
      
      public static function checkMessages() : void
      {
         var _loc1_:FeedbackPanel = null;
         if(Main.currentGame.userMessages.length > 0)
         {
            _loc1_ = new FeedbackPanel();
            Main.instance.addModal(_loc1_);
         }
      }
      
      public static function processSeasonFinish(param1:Game) : void
      {
         var _loc2_:Array = param1.leagues[0].getStandings();
         param1.leagueWinners = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < 10)
         {
            param1.leagueWinners.push(_loc2_[_loc3_].club);
            _loc3_++;
         }
         param1.cupWinners = new Array();
         _loc3_ = 0;
         while(_loc3_ < param1.fixtureList.cups.length)
         {
            param1.cupWinners.push(param1.fixtureList.cups[_loc3_].entrants[0].club);
            _loc3_++;
         }
         var _loc4_:int = GameHelper.getMeritPayment();
         param1.clubCash += _loc4_;
         _loc3_ = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc2_[_loc3_].club.profile -= (_loc2_[_loc3_].club.profile - 50) / 10;
            _loc2_[_loc3_].club.profile += (10 - _loc3_) * 2;
            if(Boolean(param1.fixtureList.europeanCup) && _loc2_[_loc3_].club == param1.fixtureList.europeanCup.entrants[0].club)
            {
               _loc2_[_loc3_].club.profile += 15;
            }
            if(Boolean(param1.fixtureList.uefaCup) && _loc2_[_loc3_].club == param1.fixtureList.uefaCup.entrants[0].club)
            {
               _loc2_[_loc3_].club.profile += 10;
            }
            if(_loc2_[_loc3_].club == param1.fixtureList.faCup.entrants[0].club)
            {
               _loc2_[_loc3_].club.profile += 8;
            }
            if(_loc2_[_loc3_].club == param1.fixtureList.leagueCup.entrants[0].club)
            {
               _loc2_[_loc3_].club.profile += 5;
            }
            _loc2_[_loc3_].club.profile = Math.min(100,_loc2_[_loc3_].club.profile);
            _loc2_[_loc3_].club.profile = Math.max(1,_loc2_[_loc3_].club.profile);
            _loc3_++;
         }
         param1.faCupWinner = param1.fixtureList.faCup.entrants[0].club;
         param1.leagueCupWinner = param1.fixtureList.leagueCup.entrants[0].club;
         ++param1.seasonNum;
         var _loc5_:Array = getPromotedTeams();
         _loc3_ = int(_loc2_.length - 1);
         while(_loc3_ > _loc2_.length - 4)
         {
            Main.currentGame.leagues[1].addEntrant(_loc2_[_loc3_].club);
            _loc3_--;
         }
         var _loc6_:League = new League();
         _loc6_.name = param1.leagues[0].name;
         _loc3_ = 0;
         while(_loc3_ < _loc2_.length - 3)
         {
            _loc6_.addEntrant(_loc2_[_loc3_].club);
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < _loc5_.length)
         {
            _loc6_.addEntrant(_loc5_[_loc3_]);
            _loc3_++;
         }
         param1.leagues[0] = _loc6_;
      }
      
      public static function getPromotedTeams() : Array
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(!Main.currentGame.promotedTeams)
         {
            Main.currentGame.promotedTeams = new Array();
            _loc1_ = 0;
            while(_loc1_ < 3)
            {
               _loc2_ = int(Main.currentGame.leagues[1].entrants.length * Math.random());
               Main.currentGame.promotedTeams.push(Main.currentGame.leagues[1].entrants[_loc2_].club);
               Main.currentGame.leagues[1].removeEntrant(Main.currentGame.leagues[1].entrants[_loc2_].club);
               _loc1_++;
            }
         }
         return Main.currentGame.promotedTeams;
      }
   }
}

