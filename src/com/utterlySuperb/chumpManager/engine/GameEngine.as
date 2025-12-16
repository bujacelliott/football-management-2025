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
	<startDate year="2025" month="8" day="10"/>
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
         _loc2_.leagues[2] = makeLeague3();
         _loc2_.leagues[3] = makeLeague4();
         makeEuroclubs();
         makeLegends();
         var _loc3_:XML = <data>
<!-- this is some classic players to add to the pot -->
	<player id="Diego Maradona" name="Diego Maradona" birthday="30-10-1975" positions="am-cf" nationality="ag">
		<stats passing="85" tackling="68" shooting="88" crossing="79" heading="75" dribbling="97" speed="93" stamina="85" aggression="88" strength="84" fitness="78" creativity="94"/>
	</player>	
	<player id="Pelé" name="Pelé" birthday="23-10-1955" positions="cf" nationality="br">
		<stats passing="80" tackling="73" shooting="95" crossing="79" heading="92" dribbling="90" speed="93" stamina="85" aggression="77" strength="91" fitness="90" creativity="84"/>
	</player>	
	<player id="David Seaman" name="David Seaman" birthday="19-09-1978" positions="gk" nationality="en">
		<stats catching="82" shotStopping="83" distribution="71" fitness="75" stamina="85"/>
	</player>
	<player id="Peter Schmeichel" name="Peter Schmeichel" birthday="18-11-1978" positions="gk" nationality="dn">
		<stats catching="88" shotStopping="92" distribution="85" fitness="75" stamina="85"/>
	</player>
	<player id="Matthew Le Tissier" name="Matthew Le Tissier" birthday="14-10-1983" positions="am" nationality="en">
		<stats passing="83" tackling="22" shooting="73" crossing="79" heading="61" dribbling="82" speed="55" stamina="70" aggression="58" strength="62" fitness="75" creativity="93"/>
	</player>	
	<player id="Eric Cantona" name="Eric Cantona" birthday="24-05-1981" positions="cf" nationality="fr">
		<stats passing="79" tackling="34" shooting="88" crossing="69" heading="77" dribbling="85" speed="78" stamina="85" aggression="100" strength="71" fitness="90" creativity="100"/>
	</player>	
	<player id="Dennis Bergkamp" name="Dennis Bergkamp" birthday="10-05-1984" positions="cf" nationality="ne">
		<stats passing="80" tackling="73" shooting="81" crossing="79" heading="72" dribbling="82" speed="79" stamina="85" aggression="61" strength="70" fitness="90" creativity="92"/>
	</player>	
	<player id="Alan Shearer" name="Alan Shearer" birthday="13-08-1985" positions="cf" nationality="en">
		<stats passing="65" tackling="32" shooting="91" crossing="52" heading="88" dribbling="45" speed="71" stamina="85" aggression="85" strength="93" fitness="90" creativity="76"/>
	</player>	
	<player id="Gianfranco Zola" name="Gianfranco Zola" birthday="05-06-1981" positions="cf-am" nationality="it">
		<stats passing="88" tackling="23" shooting="87" crossing="89" heading="66" dribbling="90" speed="95" stamina="85" aggression="10" strength="64" fitness="90" creativity="95"/>
	</player>	
	<player id="Roy Keane" name="Roy Keane" birthday="10-08-1986" positions="dm" nationality="ir">
		<stats passing="72" tackling="88" shooting="57" crossing="52" heading="76" dribbling="61" speed="74" stamina="100" aggression="100" strength="91" fitness="90" creativity="75"/>
	</player>	
	<player id="David Beckham" name="David Beckham" birthday="02-05-1990" positions="sm" nationality="en">
		<stats passing="80" tackling="55" shooting="67" crossing="93" heading="64" dribbling="72" speed="70" stamina="85" aggression="77" strength="91" fitness="90" creativity="84"/>
	</player>	
	<player id="Paul Gascoigne" name="Paul Gascoigne" birthday="27-05-1982" positions="cm-am" nationality="en">
		<stats passing="80" tackling="62" shooting="77" crossing="79" heading="62" dribbling="80" speed="68" stamina="85" aggression="90" strength="91" fitness="65" creativity="91"/>
	</player>	
	<player id="Jurgen Klinsmann" name="Jurgen Klinsmann" birthday="30-07-1979" positions="cf" nationality="ge">
		<stats passing="71" tackling="55" shooting="93" crossing="57" heading="79" dribbling="67" speed="85" stamina="85" aggression="77" strength="91" fitness="90" creativity="75"/>
	</player>	
	<player id="Peter Beardsley" name="Peter Beardsley" birthday="18-01-1976" positions="cf-am" nationality="en">
		<stats passing="80" tackling="55" shooting="81" crossing="65" heading="70" dribbling="93" speed="95" stamina="85" aggression="77" strength="77" fitness="90" creativity="75"/>
	</player>	
	<player id="Stuart Pearce" name="Stuart Pearce" birthday="24-04-1977" positions="fb" nationality="en">
		<stats passing="61" tackling="84" shooting="41" crossing="71" heading="68" dribbling="68" speed="79" stamina="85" aggression="93" strength="91" fitness="90" creativity="50"/>
	</player>	
	<player id="Denis Irwin" name="Denis Irwin" birthday="31-10-1980" positions="fb" nationality="ir">
		<stats passing="68" tackling="82" shooting="66" crossing="85" heading="75" dribbling="86" speed="77" stamina="85" aggression="55" strength="91" fitness="90" creativity="62"/>
	</player>	
	<player id="Paolo Di Canio" name="Paolo Di Canio" birthday="09-07-1983" positions="cf" nationality="it">
		<stats passing="80" tackling="66" shooting="81" crossing="72" heading="71" dribbling="77" speed="68" stamina="85" aggression="98" strength="71" fitness="90" creativity="91"/>
	</player>	
	<player id="Ruud Gullit" name="Ruud Gullit" birthday="01-09-1977" positions="cb-cm-cf" nationality="ne">
		<stats passing="84" tackling="78" shooting="67" crossing="79" heading="71" dribbling="73" speed="75" stamina="85" aggression="23" strength="67" fitness="90" creativity="88"/>
	</player>	
	<player id="Graeme Le Saux" name="Graeme Le Saux" birthday="17-10-1983" positions="fb-sm" nationality="en">
		<stats passing="71" tackling="77" shooting="22" crossing="79" heading="71" dribbling="77" speed="76" stamina="85" aggression="45" strength="66" fitness="90" creativity="82"/>
	</player>	
	<player id="Steve Bould" name="Steve Bould" birthday="16-11-1977" positions="cb" nationality="en">
		<stats passing="63" tackling="86" shooting="17" crossing="14" heading="87" dribbling="10" speed="64" stamina="85" aggression="77" strength="93" fitness="90" creativity="12"/>
	</player>	
	<player id="Tony Adams" name="Tony Adams" birthday="10-10-1981" positions="cb" nationality="en">
		<stats passing="54" tackling="91" shooting="7" crossing="41" heading="92" dribbling="61" speed="72" stamina="85" aggression="65" strength="91" fitness="90" creativity="25"/>
	</player>	
	<player id="Jaap Stam" name="Jaap Stam" birthday="17-07-1987" positions="cb" nationality="ne">
		<stats passing="72" tackling="88" shooting="34" crossing="40" heading="91" dribbling="75" speed="72" stamina="85" aggression="83" strength="82" fitness="70" creativity="79"/>
	</player>	
	<player id="Andrei Kanchelskis" name="Andrei Kanchelskis" birthday="23-01-1984" positions="sm" nationality="ru">
		<stats passing="77" tackling="37" shooting="68" crossing="83" heading="53" dribbling="91" speed="95" stamina="90" aggression="49" strength="61" fitness="90" creativity="84"/>
	</player>	
	<player id="Paul Ince" name="Paul Ince" birthday="21-10-1982" positions="dm-cm" nationality="en">
		<stats passing="81" tackling="90" shooting="67" crossing="79" heading="81" dribbling="67" speed="81" stamina="90" aggression="96" strength="91" fitness="90" creativity="70"/>
	</player>	
	<player id="Emmanuel Petit" name="Emmanuel Petit" birthday="22-09-1985" positions="dm" nationality="fr">
		<stats passing="74" tackling="82" shooting="69" crossing="79" heading="77" dribbling="64" speed="78" stamina="85" aggression="77" strength="91" fitness="90" creativity="84"/>
	</player>	
	<player id="David Ginola" name="David Ginola" birthday="25-01-1982" positions="sm" nationality="fr">
		<stats passing="83" tackling="34" shooting="72" crossing="88" heading="34" dribbling="87" speed="88" stamina="85" aggression="67" strength="71" fitness="90" creativity="90"/>
	</player>	
	<player id="Giorgi Kinkladze" name="Giorgi Kinkladze" birthday="06-07-1988" positions="am-cm" nationality="ge">
		<stats passing="77" tackling="43" shooting="79" crossing="75" heading="60" dribbling="97" speed="88" stamina="85" aggression="20" strength="60" fitness="90" creativity="89"/>
	</player>	
	<player id="Igor Stimac" name="Igor Stimac" birthday="06-09-1982" positions="cb" nationality="cr">
		<stats passing="81" tackling="77" shooting="32" crossing="66" heading="81" dribbling="67" speed="61" stamina="85" aggression="40" strength="91" fitness="90" creativity="84"/>
	</player>	
	<player id="Teddy Sheringham" name="Teddy Sheringham" birthday="02-04-1981" positions="cf" nationality="en">
		<stats passing="77" tackling="33" shooting="81" crossing="82" heading="70" dribbling="61" speed="67" stamina="85" aggression="50" strength="71" fitness="70" creativity="88"/>
	</player>	
	<player id="Jay-Jay Okocha" name="Jay-Jay Okocha" birthday="14-08-1988" positions="am" nationality="ng">
		<stats passing="82" tackling="54" shooting="76" crossing="74" heading="67" dribbling="84" speed="86" stamina="85" aggression="71" strength="75" fitness="70" creativity="88"/>
	</player>	
	<player id="Alan Martin" name="Alan Martin" birthday="18-05-1991" positions="cm" nationality="en" ageImprovement="50">
		<stats passing="93" tackling="77" shooting="82" crossing="51" heading="84" dribbling="82" speed="88" stamina="95" aggression="75" strength="91" fitness="72" creativity="85"/>
	</player>	
	<player id="Jimmy-Floyd Hasselbaink" name="Jimmy-Floyd Hasselbaink" birthday="27-03-1987" positions="cf" nationality="ne">
		<stats passing="57" tackling="33" shooting="87" crossing="61" heading="68" dribbling="70" speed="91" stamina="85" aggression="77" strength="91" fitness="90" creativity="71"/>
	</player>	
<player id="Sam Bellman" name="Sam Bellman" birthday="18-05-1990" positions="cb-dm" nationality="en" ageImprovement="50">
		<stats passing="67" tackling="95" shooting="59" crossing="63" heading="95" dribbling="30" speed="86" stamina="75" aggression="75" strength="87" fitness="75" creativity="25"/>
	</player>
<player id="Alick Stott" name="Alick Stott" birthday="18-05-1999" positions="cf" nationality="en">
		<stats passing="66" tackling="42" shooting="82" crossing="61" heading="76" dribbling="69" speed="75" stamina="75" aggression="45" strength="77" fitness="72" creativity="75"/>
	</player>
<player id="Richard Pendry" name="Richard Pendry" birthday="18-05-1999" positions="fb" nationality="en">
		<stats passing="75" tackling="77" shooting="32" crossing="66" heading="44" dribbling="66" speed="72" stamina="75" aggression="46" strength="65" fitness="72" creativity="87"/>
	</player>
<player id="Keith Martison" name="Keith Martison" birthday="14-02-2003" positions="sm" nationality="en">
		<stats passing="79" tackling="54" shooting="64" crossing="77" heading="66" dribbling="75" speed="89" stamina="82" aggression="74" strength="43" fitness="67" creativity="62"/>
	</player>
<player id="Conor Donovan" name="Conor Donovan" birthday="18-05-1999" positions="cm" nationality="en">
		<stats passing="73" tackling="42" shooting="62" crossing="61" heading="84" dribbling="62" speed="68" stamina="75" aggression="25" strength="91" fitness="72" creativity="85"/>
	</player>
<player id="Meriton Rrustemi" name="Meriton Rrustemi" birthday="18-05-1999" positions="cm" nationality="en">
		<stats passing="73" tackling="42" shooting="62" crossing="61" heading="84" dribbling="62" speed="68" stamina="75" aggression="25" strength="91" fitness="72" creativity="85"/>
	</player>
<player id="Dan Tiller" name="Dan Tiller" birthday="02-07-2002" positions="cm-am" nationality="en">
	<stats passing="80" tackling="31" shooting="54" crossing="62" heading="27" dribbling="79" speed="68" stamina="71" aggression="33" strength="29" fitness="68" creativity="71"/>
	</player>
<player id="Johnny Safi" name="Johnny Safi" birthday="06-05-1998" positions="fb" nationality="en">
	<stats passing="65" tackling="77" shooting="42" crossing="73" heading="69" dribbling="73" speed="88" stamina="89" aggression="74" strength="52" fitness="82" creativity="34"/>
	</player>
<player id="Andrei Rhodes" name="Andrei Rhodes" birthday="22-01-2000" positions="dm" nationality="en">
	<stats passing="79" tackling="47" shooting="58" crossing="84" heading="34" dribbling="80" speed="69" stamina="68" aggression="62" strength="33" fitness="73" creativity="78"/>	
	</player>
<player id="Chris Scotton" name="Chris Scotton" birthday="14-09-2003" positions="cb" nationality="en">
	<stats passing="55" tackling="56" shooting="40" crossing="52" heading="57" dribbling="43" speed="68" stamina="67" aggression="65" strength="57" fitness="68" creativity="45"/>		
	</player>
<player id="Jun Wei" name="Jun Wei" birthday="20-12-1995" positions="cb" nationality="en">
		<stats passing="53" tackling="80" shooting="12" crossing="26" heading="73" dribbling="39" speed="68" stamina="44" aggression="69" strength="84" fitness="30" creativity="44"/>
	</player>
<player id="Albert Popoola" name="Albert Popoola" birthday="22-04-1992" positions="cm-dm" nationality="en">
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
	<startDate year="2025" month="8" day="10"/>
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
			<player id="Declan Rice" name="Declan Rice" birthday="14-01-1999" positions="dm-cm" nationality="en" number="41">
				<stats passing="79" tackling="78" shooting="70" crossing="80" heading="71" dribbling="73" speed="67" stamina="82" aggression="78" strength="71" fitness="74" creativity="77"/>
			</player>
			<player id="Bukayo Saka" name="Bukayo Saka" birthday="05-09-2001" positions="wf-sm" nationality="en" number="7">
				<stats passing="80" tackling="60" shooting="79" crossing="84" heading="59" dribbling="84" speed="81" stamina="81" aggression="66" strength="68" fitness="77" creativity="82"/>
			</player>
			<player id="Mikel Merino" name="Mikel Merino" birthday="22-06-1996" positions="cm-cf" nationality="sp" number="23">
				<stats passing="75" tackling="73" shooting="73" crossing="72" heading="77" dribbling="71" speed="58" stamina="73" aggression="75" strength="70" fitness="67" creativity="74"/>
			</player>
			<player id="Martin Ødegaard" name="Martin Ødegaard" birthday="17-12-1998" positions="cm-am" nationality="no" number="8">
				<stats passing="86" tackling="66" shooting="78" crossing="84" heading="56" dribbling="84" speed="66" stamina="82" aggression="62" strength="59" fitness="71" creativity="86"/>
			</player>
			<player id="Viktor Gyökeres" name="Viktor Gyökeres" birthday="04-06-1998" positions="cf" nationality="sw" number="14">
				<stats passing="69" tackling="33" shooting="78" crossing="66" heading="80" dribbling="74" speed="82" stamina="82" aggression="74" strength="80" fitness="82" creativity="69"/>
			</player>
			<player id="Zubimendi" name="Zubimendi" birthday="02-02-1999" positions="dm-cm" nationality="sp" number="36">
				<stats passing="78" tackling="76" shooting="68" crossing="71" heading="64" dribbling="75" speed="63" stamina="78" aggression="70" strength="65" fitness="70" creativity="77"/>
			</player>
			<player id="Eberechi Eze" name="Eberechi Eze" birthday="29-06-1998" positions="am-wf-cf" nationality="en" number="10">
				<stats passing="78" tackling="50" shooting="77" crossing="75" heading="60" dribbling="82" speed="70" stamina="73" aggression="57" strength="67" fitness="71" creativity="79"/>
			</player>
			<player id="Gabriel Martinelli" name="Gabriel Martinelli" birthday="18-06-2001" positions="wf-sm" nationality="br" number="11">
				<stats passing="68" tackling="41" shooting="70" crossing="68" heading="67" dribbling="75" speed="82" stamina="72" aggression="66" strength="62" fitness="73" creativity="69"/>
			</player>
			<player id="Myles Lewis-Skelly" name="Myles Lewis-Skelly" birthday="26-09-2006" positions="fb-cm" nationality="en" number="49">
				<stats passing="67" tackling="67" shooting="56" crossing="65" heading="67" dribbling="67" speed="67" stamina="67" aggression="69" strength="70" fitness="66" creativity="67"/>
			</player>
			<player id="Riccardo Calafiori" name="Riccardo Calafiori" birthday="19-05-2002" positions="fb-cb" nationality="it" number="33">
				<stats passing="65" tackling="70" shooting="61" crossing="65" heading="70" dribbling="67" speed="65" stamina="66" aggression="70" strength="69" fitness="66" creativity="63"/>
			</player>
			<player id="Kai Havertz" name="Kai Havertz" birthday="11-06-1999" positions="cf-cm-am" nationality="ge" number="29">
				<stats passing="75" tackling="45" shooting="74" crossing="72" heading="73" dribbling="73" speed="66" stamina="75" aggression="55" strength="67" fitness="71" creativity="75"/>
			</player>
			<player id="Gabriel Jesus" name="Gabriel Jesus" birthday="03-04-1997" positions="cf-am" nationality="br" number="9">
				<stats passing="68" tackling="33" shooting="70" crossing="66" heading="69" dribbling="76" speed="72" stamina="61" aggression="66" strength="65" fitness="65" creativity="69"/>
			</player>
			<player id="Christian Nørgaard" name="Christian Nørgaard" birthday="10-03-1994" positions="dm-cm" nationality="de" number="16">
				<stats passing="72" tackling="74" shooting="62" crossing="66" heading="67" dribbling="66" speed="46" stamina="74" aggression="74" strength="70" fitness="64" creativity="68"/>
			</player>
			<player id="Chukwunonso Madueke" name="Chukwunonso Madueke" birthday="10-03-2002" positions="wf-sm" nationality="en" number="20">
				<stats passing="69" tackling="42" shooting="70" crossing="68" heading="60" dribbling="75" speed="81" stamina="68" aggression="60" strength="64" fitness="71" creativity="70"/>
			</player>
			<player id="Leandro Trossard" name="Leandro Trossard" birthday="04-12-1994" positions="wf-cf-sm" nationality="be" number="19">
				<stats passing="80" tackling="30" shooting="80" crossing="78" heading="63" dribbling="83" speed="79" stamina="73" aggression="46" strength="60" fitness="72" creativity="80"/>
			</player>
			<player id="Jurriën Timber" name="Jurriën Timber" birthday="17-06-2001" positions="fb-cb-sm" nationality="ne" number="12">
				<stats passing="70" tackling="75" shooting="50" crossing="68" heading="73" dribbling="71" speed="70" stamina="72" aggression="71" strength="74" fitness="72" creativity="66"/>
			</player>
			<player id="Piero Hincapié" name="Piero Hincapié" birthday="09-01-2002" positions="cb-fb-sm" nationality="ec" number="5">
				<stats passing="66" tackling="75" shooting="43" crossing="54" heading="73" dribbling="65" speed="75" stamina="74" aggression="76" strength="69" fitness="73" creativity="59"/>
			</player>
			<player id="William Saliba" name="William Saliba" birthday="24-03-2001" positions="cb" nationality="fr" number="2">
				<stats passing="73" tackling="83" shooting="45" crossing="59" heading="80" dribbling="67" speed="73" stamina="67" aggression="79" strength="77" fitness="71" creativity="65"/>
			</player>
			<player id="Ethan Nwaneri" name="Ethan Nwaneri" birthday="21-03-2007" positions="wf-cm-sm" nationality="en" number="22">
				<stats passing="69" tackling="49" shooting="67" crossing="72" heading="46" dribbling="74" speed="77" stamina="62" aggression="45" strength="53" fitness="64" creativity="70"/>
			</player>
			<player id="Benjamin White" name="Benjamin White" birthday="08-10-1997" positions="fb" nationality="en" number="4">
				<stats passing="76" tackling="79" shooting="42" crossing="72" heading="75" dribbling="71" speed="66" stamina="72" aggression="77" strength="72" fitness="70" creativity="72"/>
			</player>
			<player id="Gabriel" name="Gabriel" birthday="19-12-1997" positions="cb" nationality="br" number="6">
				<stats passing="74" tackling="86" shooting="49" crossing="53" heading="86" dribbling="63" speed="62" stamina="67" aggression="84" strength="79" fitness="69" creativity="66"/>
			</player>
			<player id="Mosquera" name="Mosquera" birthday="27-06-2004" positions="cb" nationality="sp" number="3">
				<stats passing="61" tackling="68" shooting="43" crossing="44" heading="69" dribbling="53" speed="65" stamina="68" aggression="67" strength="66" fitness="66" creativity="52"/>
			</player>
			<player id="David Raya" name="David Raya" birthday="15-09-1995" positions="gk" nationality="sp" number="1">
				<stats catching="82" shotStopping="84" distribution="85" fitness="83" stamina="30"/>
			</player>
			<player id="Kepa" name="Kepa" birthday="03-10-1994" positions="gk" nationality="sp" number="13">
				<stats catching="73" shotStopping="74" distribution="77" fitness="72" stamina="33"/>
			</player>
		</players>
	</club>
<club shirtColor="0x000000" sleevesColor="0xFFFFFF" stripesType="none" scoreMultiplier="1" attackScore="A" defendScore="B">
		<name><![CDATA[Aston Villa]]></name>
		<profile>90</profile>
		<players>
			<player id="John McGinn" name="John McGinn" birthday="18-10-1994" positions="sm-am-fb" nationality="sc" number="7">
				<stats passing="72" tackling="72" shooting="70" crossing="70" heading="62" dribbling="72" speed="62" stamina="81" aggression="76" strength="72" fitness="72" creativity="72"/>
			</player>
			<player id="Youri Tielemans" name="Youri Tielemans" birthday="07-05-1997" positions="cm-dm-am" nationality="be" number="8">
				<stats passing="85" tackling="74" shooting="78" crossing="81" heading="67" dribbling="77" speed="52" stamina="82" aggression="65" strength="68" fitness="68" creativity="84"/>
			</player>
			<player id="Lucas Digne" name="Lucas Digne" birthday="20-07-1993" positions="fb-sm" nationality="fr" number="12">
				<stats passing="71" tackling="72" shooting="66" crossing="76" heading="68" dribbling="71" speed="64" stamina="73" aggression="70" strength="66" fitness="68" creativity="71"/>
			</player>
			<player id="Morgan Rogers" name="Morgan Rogers" birthday="26-07-2002" positions="am-sm-cm" nationality="en" number="27">
				<stats passing="76" tackling="63" shooting="73" crossing="71" heading="67" dribbling="77" speed="71" stamina="76" aggression="66" strength="73" fitness="74" creativity="76"/>
			</player>
			<player id="Oliver Watkins" name="Oliver Watkins" birthday="30-12-1995" positions="cf" nationality="en" number="11">
				<stats passing="73" tackling="47" shooting="79" crossing="68" heading="80" dribbling="76" speed="74" stamina="81" aggression="71" strength="73" fitness="77" creativity="72"/>
			</player>
			<player id="Emiliano Buendía" name="Emiliano Buendía" birthday="25-12-1996" positions="am-sm-cm" nationality="ar" number="10">
				<stats passing="71" tackling="60" shooting="69" crossing="72" heading="67" dribbling="74" speed="61" stamina="58" aggression="70" strength="62" fitness="59" creativity="72"/>
			</player>
			<player id="Ian Maatsen" name="Ian Maatsen" birthday="10-03-2002" positions="fb-sm" nationality="ne" number="22">
				<stats passing="72" tackling="70" shooting="65" crossing="72" heading="59" dribbling="77" speed="83" stamina="70" aggression="67" strength="57" fitness="70" creativity="71"/>
			</player>
			<player id="Matthew Cash" name="Matthew Cash" birthday="07-08-1997" positions="fb-sm" nationality="po" number="2">
				<stats passing="68" tackling="73" shooting="65" crossing="69" heading="58" dribbling="70" speed="70" stamina="77" aggression="76" strength="64" fitness="72" creativity="66"/>
			</player>
			<player id="Ross Barkley" name="Ross Barkley" birthday="05-12-1993" positions="cm-am" nationality="en" number="6">
				<stats passing="75" tackling="62" shooting="74" crossing="72" heading="66" dribbling="71" speed="50" stamina="61" aggression="67" strength="65" fitness="58" creativity="75"/>
			</player>
			<player id="Ezri Konsa" name="Ezri Konsa" birthday="23-10-1997" positions="cb-fb-sm" nationality="en" number="4">
				<stats passing="72" tackling="77" shooting="54" crossing="63" heading="75" dribbling="69" speed="70" stamina="72" aggression="72" strength="72" fitness="71" creativity="69"/>
			</player>
			<player id="Amadou Onana" name="Amadou Onana" birthday="16-08-2001" positions="dm-cm" nationality="be" number="24">
				<stats passing="72" tackling="73" shooting="61" crossing="62" heading="76" dribbling="65" speed="68" stamina="69" aggression="76" strength="73" fitness="69" creativity="71"/>
			</player>
			<player id="Boubacar Kamara" name="Boubacar Kamara" birthday="23-11-1999" positions="dm-cm" nationality="fr" number="44">
				<stats passing="78" tackling="81" shooting="58" crossing="66" heading="74" dribbling="73" speed="62" stamina="77" aggression="78" strength="76" fitness="72" creativity="73"/>
			</player>
			<player id="Donyell Malen" name="Donyell Malen" birthday="19-01-1999" positions="sm-wf" nationality="ne" number="17">
				<stats passing="71" tackling="35" shooting="77" crossing="70" heading="66" dribbling="80" speed="84" stamina="68" aggression="61" strength="68" fitness="73" creativity="71"/>
			</player>
			<player id="Pau Torres" name="Pau Torres" birthday="16-01-1997" positions="cb" nationality="sp" number="14">
				<stats passing="75" tackling="76" shooting="46" crossing="67" heading="76" dribbling="65" speed="62" stamina="65" aggression="70" strength="67" fitness="65" creativity="72"/>
			</player>
			<player id="Harvey Elliott" name="Harvey Elliott" birthday="04-04-2003" positions="am-cm-wf" nationality="en" number="9">
				<stats passing="78" tackling="55" shooting="73" crossing="77" heading="44" dribbling="83" speed="73" stamina="71" aggression="57" strength="46" fitness="65" creativity="78"/>
			</player>
			<player id="Jadon Sancho" name="Jadon Sancho" birthday="25-03-2000" positions="sm-wf" nationality="en" number="19">
				<stats passing="78" tackling="37" shooting="74" crossing="75" heading="51" dribbling="86" speed="79" stamina="66" aggression="48" strength="62" fitness="69" creativity="79"/>
			</player>
			<player id="Andrés García" name="Andrés García" birthday="07-02-2003" positions="fb-sm" nationality="sp" number="16">
				<stats passing="64" tackling="65" shooting="61" crossing="66" heading="52" dribbling="66" speed="71" stamina="66" aggression="59" strength="58" fitness="67" creativity="64"/>
			</player>
			<player id="Evann Guessand" name="Evann Guessand" birthday="01-07-2001" positions="sm-wf-cf" nationality="cô" number="29">
				<stats passing="72" tackling="35" shooting="74" crossing="71" heading="77" dribbling="74" speed="79" stamina="72" aggression="57" strength="76" fitness="76" creativity="69"/>
			</player>
			<player id="Victor Lindelöf" name="Victor Lindelöf" birthday="17-07-1994" positions="cb" nationality="sw" number="3">
				<stats passing="72" tackling="72" shooting="53" crossing="64" heading="72" dribbling="64" speed="48" stamina="48" aggression="72" strength="70" fitness="53" creativity="68"/>
			</player>
			<player id="Lamare Bogarde" name="Lamare Bogarde" birthday="05-01-2004" positions="dm-cm-fb-sm" nationality="ne" number="26">
				<stats passing="65" tackling="64" shooting="48" crossing="55" heading="61" dribbling="61" speed="61" stamina="60" aggression="65" strength="64" fitness="61" creativity="63"/>
			</player>
			<player id="Tyrone Mings" name="Tyrone Mings" birthday="13-03-1993" positions="cb" nationality="en" number="5">
				<stats passing="68" tackling="75" shooting="47" crossing="64" heading="77" dribbling="58" speed="55" stamina="51" aggression="81" strength="75" fitness="57" creativity="61"/>
			</player>
			<player id="Bradley Burrowes" name="Bradley Burrowes" birthday="04-03-2008" positions="sm-cf-wf" nationality="en" number="83">
				<stats passing="53" tackling="32" shooting="57" crossing="55" heading="51" dribbling="60" speed="77" stamina="53" aggression="43" strength="54" fitness="61" creativity="53"/>
			</player>
			<player id="Damián Martínez" name="Damián Martínez" birthday="02-09-1992" positions="gk" nationality="ar" number="23">
				<stats catching="80" shotStopping="82" distribution="80" fitness="83" stamina="39"/>
			</player>
			<player id="Marco Bizot" name="Marco Bizot" birthday="10-03-1991" positions="gk" nationality="ne" number="40">
				<stats catching="75" shotStopping="78" distribution="72" fitness="79" stamina="31"/>
			</player>
		</players>
	</club>
	<club shirtColor="0x000000" sleevesColor="0xFFFFFF" stripesType="none" scoreMultiplier="1" attackScore="A" defendScore="B">
		<name><![CDATA[Crystal Palace]]></name>
		<profile>90</profile>
		<players>
			<player id="Daniel Muñoz" name="Daniel Muñoz" birthday="26-05-1996" positions="fb-sm" nationality="co" number="2">
				<stats passing="69" tackling="73" shooting="65" crossing="68" heading="73" dribbling="70" speed="69" stamina="78" aggression="77" strength="70" fitness="72" creativity="66"/>
			</player>
			<player id="Jefferson Lerma" name="Jefferson Lerma" birthday="25-10-1994" positions="dm-cm-cb" nationality="co" number="8">
				<stats passing="66" tackling="68" shooting="64" crossing="61" heading="73" dribbling="66" speed="61" stamina="71" aggression="76" strength="68" fitness="66" creativity="63"/>
			</player>
			<player id="Daichi Kamada" name="Daichi Kamada" birthday="05-08-1996" positions="cm-am" nationality="ja" number="18">
				<stats passing="72" tackling="61" shooting="67" crossing="71" heading="57" dribbling="72" speed="66" stamina="68" aggression="70" strength="56" fitness="64" creativity="72"/>
			</player>
			<player id="Christantus Uche" name="Christantus Uche" birthday="19-05-2003" positions="cf-am-cm" nationality="ni" number="12">
				<stats passing="66" tackling="60" shooting="65" crossing="55" heading="73" dribbling="63" speed="60" stamina="71" aggression="68" strength="71" fitness="69" creativity="66"/>
			</player>
			<player id="Adam Wharton" name="Adam Wharton" birthday="06-02-2004" positions="dm-cm" nationality="en" number="20">
				<stats passing="80" tackling="74" shooting="63" crossing="77" heading="64" dribbling="74" speed="60" stamina="67" aggression="72" strength="65" fitness="64" creativity="79"/>
			</player>
			<player id="Jean-Philippe Mateta" name="Jean-Philippe Mateta" birthday="28-06-1997" positions="cf" nationality="fr" number="14">
				<stats passing="72" tackling="40" shooting="80" crossing="63" heading="78" dribbling="71" speed="71" stamina="65" aggression="74" strength="77" fitness="69" creativity="70"/>
			</player>
			<player id="William Hughes" name="William Hughes" birthday="17-04-1995" positions="dm-cm" nationality="en" number="19">
				<stats passing="75" tackling="72" shooting="63" crossing="74" heading="60" dribbling="72" speed="50" stamina="66" aggression="77" strength="61" fitness="59" creativity="75"/>
			</player>
			<player id="Justin Devenny" name="Justin Devenny" birthday="11-10-2003" positions="am-wf-sm-cm" nationality="no" number="55">
				<stats passing="64" tackling="58" shooting="61" crossing="63" heading="55" dribbling="63" speed="58" stamina="61" aggression="63" strength="59" fitness="60" creativity="64"/>
			</player>
			<player id="Ismaïla Sarr" name="Ismaïla Sarr" birthday="25-02-1998" positions="am-wf-cm" nationality="se" number="7">
				<stats passing="75" tackling="30" shooting="76" crossing="73" heading="57" dribbling="75" speed="88" stamina="70" aggression="55" strength="69" fitness="75" creativity="75"/>
			</player>
			<player id="Borna Sosa" name="Borna Sosa" birthday="21-01-1998" positions="fb-sm" nationality="cr" number="24">
				<stats passing="66" tackling="61" shooting="52" crossing="72" heading="61" dribbling="65" speed="64" stamina="65" aggression="59" strength="62" fitness="64" creativity="67"/>
			</player>
			<player id="Cheick Doucouré" name="Cheick Doucouré" birthday="08-01-2000" positions="dm-cm" nationality="ma" number="28">
				<stats passing="72" tackling="73" shooting="56" crossing="60" heading="63" dribbling="70" speed="58" stamina="67" aggression="75" strength="70" fitness="64" creativity="70"/>
			</player>
			<player id="Yeremy Pino" name="Yeremy Pino" birthday="20-10-2002" positions="sm-wf" nationality="sp" number="10">
				<stats passing="79" tackling="42" shooting="74" crossing="79" heading="51" dribbling="80" speed="78" stamina="68" aggression="51" strength="52" fitness="67" creativity="79"/>
			</player>
			<player id="Tyrick Mitchell" name="Tyrick Mitchell" birthday="01-09-1999" positions="fb-sm" nationality="en" number="3">
				<stats passing="66" tackling="74" shooting="45" crossing="71" heading="60" dribbling="71" speed="71" stamina="78" aggression="69" strength="62" fitness="72" creativity="67"/>
			</player>
			<player id="Addji Guéhi" name="Addji Guéhi" birthday="13-07-2000" positions="cb" nationality="en" number="6">
				<stats passing="73" tackling="79" shooting="43" crossing="62" heading="76" dribbling="68" speed="65" stamina="69" aggression="74" strength="74" fitness="68" creativity="68"/>
			</player>
			<player id="Guy Lacroix" name="Guy Lacroix" birthday="06-04-2000" positions="cb" nationality="fr" number="5">
				<stats passing="63" tackling="72" shooting="42" crossing="43" heading="72" dribbling="61" speed="79" stamina="68" aggression="73" strength="71" fitness="72" creativity="55"/>
			</player>
			<player id="Nathaniel Clyne" name="Nathaniel Clyne" birthday="05-04-1991" positions="fb-cb-sm" nationality="en" number="17">
				<stats passing="64" tackling="69" shooting="60" crossing="66" heading="64" dribbling="65" speed="56" stamina="40" aggression="65" strength="57" fitness="50" creativity="60"/>
			</player>
			<player id="Naouirou Ahamada" name="Naouirou Ahamada" birthday="29-03-2002" positions="cm-am-sm" nationality="fr" number="29">
				<stats passing="61" tackling="56" shooting="57" crossing="53" heading="54" dribbling="63" speed="60" stamina="58" aggression="60" strength="56" fitness="58" creativity="61"/>
			</player>
			<player id="Romain Esse" name="Romain Esse" birthday="13-05-2005" positions="wf-am-sm" nationality="en" number="21">
				<stats passing="61" tackling="43" shooting="61" crossing="61" heading="50" dribbling="68" speed="71" stamina="61" aggression="51" strength="55" fitness="63" creativity="61"/>
			</player>
			<player id="Edward Nketiah" name="Edward Nketiah" birthday="30-05-1999" positions="cf" nationality="en" number="9">
				<stats passing="64" tackling="24" shooting="71" crossing="49" heading="67" dribbling="72" speed="78" stamina="64" aggression="54" strength="64" fitness="68" creativity="60"/>
			</player>
			<player id="Christopher Richards" name="Christopher Richards" birthday="28-03-2000" positions="cb" nationality="un" number="26">
				<stats passing="61" tackling="73" shooting="31" crossing="48" heading="73" dribbling="58" speed="61" stamina="66" aggression="70" strength="72" fitness="66" creativity="55"/>
			</player>
			<player id="Caleb Kporha" name="Caleb Kporha" birthday="15-07-2006" positions="fb-sm" nationality="en" number="58">
				<stats passing="50" tackling="49" shooting="44" crossing="52" heading="50" dribbling="56" speed="63" stamina="50" aggression="56" strength="51" fitness="53" creativity="50"/>
			</player>
			<player id="Chadi Riad" name="Chadi Riad" birthday="17-06-2003" positions="cb" nationality="mo" number="34">
				<stats passing="59" tackling="66" shooting="33" crossing="48" heading="69" dribbling="56" speed="55" stamina="56" aggression="67" strength="68" fitness="59" creativity="52"/>
			</player>
			<player id="Jaydee Canvot" name="Jaydee Canvot" birthday="29-07-2006" positions="cb-dm-cm" nationality="fr" number="23">
				<stats passing="55" tackling="61" shooting="32" crossing="43" heading="64" dribbling="50" speed="61" stamina="59" aggression="62" strength="63" fitness="60" creativity="51"/>
			</player>
			<player id="Dean Henderson" name="Dean Henderson" birthday="12-03-1997" positions="gk" nationality="en" number="1">
				<stats catching="77" shotStopping="81" distribution="76" fitness="79" stamina="32"/>
			</player>
			<player id="Walter Benítez" name="Walter Benítez" birthday="19-01-1993" positions="gk" nationality="ar" number="44">
				<stats catching="76" shotStopping="78" distribution="71" fitness="76" stamina="39"/>
			</player>
			<player id="Remi Matthews" name="Remi Matthews" birthday="10-02-1994" positions="gk" nationality="en" number="31">
				<stats catching="59" shotStopping="59" distribution="58" fitness="58" stamina="27"/>
			</player>
		</players>
	</club>
	<club shirtColor="0x000000" sleevesColor="0xFFFFFF" stripesType="none" scoreMultiplier="1" attackScore="A" defendScore="B">
		<name><![CDATA[Brighton & HA]]></name>
		<profile>90</profile>
		<players>
			<player id="Maxim De Cuyper" name="Maxim De Cuyper" birthday="22-12-2000" positions="fb-sm" nationality="be" number="29">
				<stats passing="72" tackling="68" shooting="67" crossing="74" heading="63" dribbling="71" speed="69" stamina="76" aggression="69" strength="64" fitness="71" creativity="72"/>
			</player>
			<player id="Carlos Baleba" name="Carlos Baleba" birthday="03-01-2004" positions="dm-cm" nationality="ca" number="17">
				<stats passing="73" tackling="73" shooting="66" crossing="65" heading="68" dribbling="73" speed="68" stamina="74" aggression="72" strength="72" fitness="71" creativity="72"/>
			</player>
			<player id="Ferdi Kadıoğlu" name="Ferdi Kadıoğlu" birthday="07-10-1999" positions="fb-sm" nationality="tü" number="24">
				<stats passing="71" tackling="72" shooting="66" crossing="70" heading="63" dribbling="76" speed="78" stamina="74" aggression="60" strength="63" fitness="73" creativity="70"/>
			</player>
			<player id="Georginio Rutter" name="Georginio Rutter" birthday="20-04-2002" positions="am-cf" nationality="fr" number="10">
				<stats passing="69" tackling="54" shooting="68" crossing="67" heading="68" dribbling="71" speed="69" stamina="71" aggression="56" strength="69" fitness="70" creativity="69"/>
			</player>
			<player id="Kaoru Mitoma" name="Kaoru Mitoma" birthday="20-05-1997" positions="sm-wf" nationality="ja" number="22">
				<stats passing="76" tackling="57" shooting="73" crossing="75" heading="58" dribbling="83" speed="85" stamina="72" aggression="57" strength="62" fitness="74" creativity="77"/>
			</player>
			<player id="Mats Wieffer" name="Mats Wieffer" birthday="16-11-1999" positions="dm-cm" nationality="ne" number="27">
				<stats passing="71" tackling="70" shooting="63" crossing="66" heading="72" dribbling="67" speed="62" stamina="70" aggression="75" strength="69" fitness="67" creativity="69"/>
			</player>
			<player id="Jack Hinshelwood" name="Jack Hinshelwood" birthday="11-04-2005" positions="dm-fb-sm" nationality="en" number="13">
				<stats passing="68" tackling="67" shooting="60" crossing="64" heading="69" dribbling="66" speed="60" stamina="66" aggression="66" strength="64" fitness="63" creativity="66"/>
			</player>
			<player id="Yasin Ayari" name="Yasin Ayari" birthday="06-10-2003" positions="cm-dm" nationality="sw" number="26">
				<stats passing="69" tackling="65" shooting="65" crossing="65" heading="49" dribbling="71" speed="63" stamina="65" aggression="67" strength="53" fitness="61" creativity="69"/>
			</player>
			<player id="Daniel Welbeck" name="Daniel Welbeck" birthday="26-11-1990" positions="cf" nationality="en" number="18">
				<stats passing="71" tackling="41" shooting="74" crossing="67" heading="75" dribbling="71" speed="56" stamina="64" aggression="70" strength="73" fitness="64" creativity="69"/>
			</player>
			<player id="Olivier Boscagli" name="Olivier Boscagli" birthday="18-11-1997" positions="cb" nationality="fr" number="21">
				<stats passing="76" tackling="74" shooting="52" crossing="67" heading="74" dribbling="72" speed="61" stamina="65" aggression="70" strength="73" fitness="66" creativity="71"/>
			</player>
			<player id="Diego Gómez" name="Diego Gómez" birthday="27-03-2003" positions="cm-dm" nationality="pa" number="25">
				<stats passing="66" tackling="64" shooting="60" crossing="60" heading="63" dribbling="65" speed="61" stamina="62" aggression="68" strength="65" fitness="63" creativity="65"/>
			</player>
			<player id="James Milner" name="James Milner" birthday="04-01-1986" positions="cm-fb-dm" nationality="en" number="20">
				<stats passing="71" tackling="70" shooting="66" crossing="71" heading="63" dribbling="67" speed="43" stamina="48" aggression="71" strength="63" fitness="50" creativity="71"/>
			</player>
			<player id="Solomon March" name="Solomon March" birthday="20-07-1994" positions="sm-wf" nationality="en" number="7">
				<stats passing="72" tackling="64" shooting="69" crossing="74" heading="51" dribbling="73" speed="66" stamina="46" aggression="58" strength="57" fitness="55" creativity="72"/>
			</player>
			<player id="Jan van Hecke" name="Jan van Hecke" birthday="08-06-2000" positions="cb" nationality="ne" number="6">
				<stats passing="72" tackling="74" shooting="47" crossing="58" heading="76" dribbling="64" speed="62" stamina="64" aggression="75" strength="71" fitness="64" creativity="69"/>
			</player>
			<player id="Yankuba Minteh" name="Yankuba Minteh" birthday="22-07-2004" positions="sm-wf" nationality="ga" number="11">
				<stats passing="66" tackling="56" shooting="67" crossing="68" heading="48" dribbling="78" speed="92" stamina="67" aggression="59" strength="53" fitness="72" creativity="67"/>
			</player>
			<player id="Joël Veltman" name="Joël Veltman" birthday="15-01-1992" positions="fb-sm" nationality="ne" number="34">
				<stats passing="69" tackling="77" shooting="52" crossing="65" heading="74" dribbling="68" speed="60" stamina="69" aggression="78" strength="72" fitness="67" creativity="61"/>
			</player>
			<player id="Brajan Gruda" name="Brajan Gruda" birthday="31-05-2004" positions="am-sm-cm" nationality="ge" number="8">
				<stats passing="67" tackling="31" shooting="68" crossing="68" heading="57" dribbling="76" speed="72" stamina="65" aggression="57" strength="63" fitness="67" creativity="70"/>
			</player>
			<player id="Charalampos Kostoulas" name="Charalampos Kostoulas" birthday="07-05-2007" positions="cf-am-sm" nationality="gr" number="19">
				<stats passing="59" tackling="37" shooting="60" crossing="48" heading="67" dribbling="62" speed="75" stamina="65" aggression="60" strength="69" fitness="69" creativity="58"/>
			</player>
			<player id="Lewis Dunk" name="Lewis Dunk" birthday="21-11-1991" positions="cb" nationality="en" number="5">
				<stats passing="72" tackling="75" shooting="54" crossing="53" heading="77" dribbling="60" speed="36" stamina="60" aggression="79" strength="74" fitness="55" creativity="67"/>
			</player>
			<player id="Stefanos Tzimas" name="Stefanos Tzimas" birthday="06-01-2006" positions="cf" nationality="gr" number="9">
				<stats passing="57" tackling="29" shooting="65" crossing="43" heading="71" dribbling="64" speed="71" stamina="65" aggression="57" strength="70" fitness="68" creativity="53"/>
			</player>
			<player id="Thomas Watson" name="Thomas Watson" birthday="08-04-2006" positions="sm-wf" nationality="en" number="14">
				<stats passing="60" tackling="30" shooting="62" crossing="60" heading="50" dribbling="65" speed="75" stamina="60" aggression="42" strength="57" fitness="64" creativity="61"/>
			</player>
			<player id="Diego Coppola" name="Diego Coppola" birthday="28-12-2003" positions="cb" nationality="it" number="42">
				<stats passing="62" tackling="72" shooting="42" crossing="47" heading="71" dribbling="56" speed="50" stamina="64" aggression="72" strength="66" fitness="59" creativity="56"/>
			</player>
			<player id="Adam Webster" name="Adam Webster" birthday="04-01-1995" positions="cb" nationality="en" number="4">
				<stats passing="66" tackling="71" shooting="36" crossing="49" heading="73" dribbling="63" speed="50" stamina="54" aggression="71" strength="71" fitness="56" creativity="57"/>
			</player>
			<player id="Jason Steele" name="Jason Steele" birthday="18-08-1990" positions="gk" nationality="en" number="23">
				<stats catching="68" shotStopping="69" distribution="74" fitness="69" stamina="27"/>
			</player>
			<player id="Bart Verbruggen" name="Bart Verbruggen" birthday="18-08-2002" positions="gk" nationality="ne" number="1">
				<stats catching="74" shotStopping="78" distribution="74" fitness="73" stamina="29"/>
			</player>
			<player id="Thomas McGill" name="Thomas McGill" birthday="25-03-2000" positions="gk" nationality="ca" number="38">
				<stats catching="55" shotStopping="57" distribution="58" fitness="56" stamina="28"/>
			</player>
		</players>
	</club>
	<club shirtColor="0x000000" sleevesColor="0xFFFFFF" stripesType="none" scoreMultiplier="1" attackScore="A" defendScore="B">
		<name><![CDATA[Brentford]]></name>
		<profile>90</profile>
		<players>
			<player id="Jordan Henderson" name="Jordan Henderson" birthday="17-06-1990" positions="dm-cm" nationality="en" number="6">
				<stats passing="75" tackling="71" shooting="68" crossing="75" heading="66" dribbling="68" speed="60" stamina="71" aggression="74" strength="70" fitness="67" creativity="74"/>
			</player>
			<player id="Mikkel Damsgaard" name="Mikkel Damsgaard" birthday="03-07-2000" positions="am-cm" nationality="de" number="24">
				<stats passing="77" tackling="64" shooting="70" crossing="76" heading="56" dribbling="76" speed="64" stamina="72" aggression="64" strength="62" fitness="67" creativity="77"/>
			</player>
			<player id="Keane Lewis-Potter" name="Keane Lewis-Potter" birthday="22-02-2001" positions="fb-sm" nationality="en" number="23">
				<stats passing="66" tackling="65" shooting="64" crossing="69" heading="61" dribbling="72" speed="72" stamina="71" aggression="60" strength="57" fitness="68" creativity="67"/>
			</player>
			<player id="Mathias Jensen" name="Mathias Jensen" birthday="01-01-1996" positions="cm-dm" nationality="de" number="8">
				<stats passing="73" tackling="66" shooting="62" crossing="72" heading="56" dribbling="70" speed="59" stamina="69" aggression="70" strength="64" fitness="65" creativity="72"/>
			</player>
			<player id="Vitaly Janelt" name="Vitaly Janelt" birthday="10-05-1998" positions="cm-dm" nationality="ge" number="27">
				<stats passing="70" tackling="68" shooting="65" crossing="64" heading="60" dribbling="66" speed="54" stamina="73" aggression="69" strength="67" fitness="66" creativity="67"/>
			</player>
			<player id="Ogochukwu Onyeka" name="Ogochukwu Onyeka" birthday="01-01-1998" positions="cm-dm" nationality="ni" number="15">
				<stats passing="65" tackling="64" shooting="59" crossing="56" heading="62" dribbling="65" speed="65" stamina="73" aggression="69" strength="65" fitness="69" creativity="64"/>
			</player>
			<player id="Kevin Schade" name="Kevin Schade" birthday="27-11-2001" positions="sm-wf" nationality="ge" number="7">
				<stats passing="69" tackling="29" shooting="72" crossing="68" heading="76" dribbling="74" speed="89" stamina="69" aggression="61" strength="66" fitness="73" creativity="68"/>
			</player>
			<player id="Dango Ouattara" name="Dango Ouattara" birthday="11-02-2002" positions="sm-cf-wf" nationality="bu" number="19">
				<stats passing="69" tackling="50" shooting="69" crossing="71" heading="65" dribbling="75" speed="83" stamina="66" aggression="49" strength="60" fitness="69" creativity="70"/>
			</player>
			<player id="Antoni-Djibu Milambo" name="Antoni-Djibu Milambo" birthday="03-04-2005" positions="cm-am" nationality="ne" number="17">
				<stats passing="68" tackling="57" shooting="63" crossing="61" heading="55" dribbling="69" speed="68" stamina="72" aggression="48" strength="57" fitness="68" creativity="68"/>
			</player>
			<player id="Yehor Yarmoliuk" name="Yehor Yarmoliuk" birthday="01-03-2004" positions="cm-dm" nationality="uk" number="18">
				<stats passing="64" tackling="61" shooting="58" crossing="60" heading="57" dribbling="63" speed="59" stamina="60" aggression="62" strength="60" fitness="59" creativity="64"/>
			</player>
			<player id="Aaron Hickey" name="Aaron Hickey" birthday="10-06-2002" positions="fb-sm" nationality="sc" number="2">
				<stats passing="68" tackling="70" shooting="55" crossing="67" heading="64" dribbling="68" speed="67" stamina="57" aggression="70" strength="58" fitness="61" creativity="66"/>
			</player>
			<player id="Rico Henry" name="Rico Henry" birthday="08-07-1997" positions="fb-sm" nationality="en" number="3">
				<stats passing="62" tackling="71" shooting="45" crossing="59" heading="60" dribbling="73" speed="81" stamina="63" aggression="71" strength="66" fitness="69" creativity="57"/>
			</player>
			<player id="Kristoffer Ajer" name="Kristoffer Ajer" birthday="17-04-1998" positions="fb-cb-sm" nationality="no" number="20">
				<stats passing="63" tackling="69" shooting="55" crossing="60" heading="72" dribbling="61" speed="61" stamina="63" aggression="73" strength="74" fitness="65" creativity="58"/>
			</player>
			<player id="Myles Peart-Harris" name="Myles Peart-Harris" birthday="18-09-2002" positions="sm-wf" nationality="en" number="25">
				<stats passing="57" tackling="50" shooting="54" crossing="54" heading="59" dribbling="58" speed="60" stamina="69" aggression="49" strength="62" fitness="65" creativity="56"/>
			</player>
			<player id="Michael Kayode" name="Michael Kayode" birthday="10-07-2004" positions="fb-sm" nationality="it" number="33">
				<stats passing="60" tackling="68" shooting="44" crossing="62" heading="65" dribbling="65" speed="69" stamina="61" aggression="69" strength="66" fitness="63" creativity="60"/>
			</player>
			<player id="Reiss Nelson" name="Reiss Nelson" birthday="10-12-1999" positions="sm-wf" nationality="en" number="11">
				<stats passing="70" tackling="39" shooting="66" crossing="71" heading="47" dribbling="76" speed="76" stamina="64" aggression="45" strength="57" fitness="66" creativity="72"/>
			</player>
			<player id="Edmond-Paris Maghoma" name="Edmond-Paris Maghoma" birthday="08-05-2001" positions="cm-dm" nationality="en" number="32">
				<stats passing="58" tackling="54" shooting="53" crossing="54" heading="48" dribbling="60" speed="55" stamina="55" aggression="58" strength="57" fitness="56" creativity="58"/>
			</player>
			<player id="Fábio Carvalho" name="Fábio Carvalho" birthday="30-08-2002" positions="am-cm-sm" nationality="po" number="14">
				<stats passing="74" tackling="49" shooting="71" crossing="66" heading="45" dribbling="79" speed="77" stamina="63" aggression="44" strength="48" fitness="64" creativity="73"/>
			</player>
			<player id="Sepp van den Berg" name="Sepp van den Berg" birthday="20-12-2001" positions="cb-fb" nationality="ne" number="4">
				<stats passing="64" tackling="71" shooting="39" crossing="54" heading="75" dribbling="60" speed="65" stamina="62" aggression="68" strength="69" fitness="65" creativity="57"/>
			</player>
			<player id="Igor Thiago" name="Igor Thiago" birthday="26-06-2001" positions="cf" nationality="br" number="9">
				<stats passing="61" tackling="35" shooting="71" crossing="41" heading="79" dribbling="63" speed="62" stamina="55" aggression="70" strength="77" fitness="63" creativity="59"/>
			</player>
			<player id="Ethan Pinnock" name="Ethan Pinnock" birthday="29-05-1993" positions="cb" nationality="ja" number="5">
				<stats passing="61" tackling="73" shooting="39" crossing="46" heading="75" dribbling="57" speed="55" stamina="61" aggression="75" strength="74" fitness="62" creativity="55"/>
			</player>
			<player id="Nathan Collins" name="Nathan Collins" birthday="30-04-2001" positions="cb" nationality="re" number="22">
				<stats passing="63" tackling="75" shooting="36" crossing="50" heading="77" dribbling="59" speed="58" stamina="73" aggression="74" strength="73" fitness="68" creativity="54"/>
			</player>
			<player id="Gustavo Nunes" name="Gustavo Nunes" birthday="20-11-2005" positions="sm-wf" nationality="br" number="39">
				<stats passing="54" tackling="30" shooting="57" crossing="55" heading="48" dribbling="65" speed="76" stamina="57" aggression="36" strength="49" fitness="60" creativity="56"/>
			</player>
			<player id="Yunus Konak" name="Yunus Konak" birthday="10-01-2006" positions="dm-cm-cb" nationality="tü" number="26">
				<stats passing="55" tackling="53" shooting="42" crossing="44" heading="51" dribbling="51" speed="54" stamina="54" aggression="57" strength="55" fitness="54" creativity="53"/>
			</player>
			<player id="Romelle Donovan" name="Romelle Donovan" birthday="30-11-2006" positions="sm-am-wf" nationality="en" number="45">
				<stats passing="52" tackling="28" shooting="51" crossing="50" heading="39" dribbling="62" speed="74" stamina="51" aggression="37" strength="45" fitness="57" creativity="52"/>
			</player>
			<player id="Benjamin Arthur" name="Benjamin Arthur" birthday="09-10-2005" positions="cb" nationality="en" number="43">
				<stats passing="42" tackling="52" shooting="30" crossing="35" heading="58" dribbling="45" speed="53" stamina="48" aggression="53" strength="62" fitness="53" creativity="37"/>
			</player>
			<player id="Caoimhín Kelleher" name="Caoimhín Kelleher" birthday="23-11-1998" positions="gk" nationality="re" number="1">
				<stats catching="77" shotStopping="80" distribution="80" fitness="79" stamina="19"/>
			</player>
			<player id="Ellery Balcombe" name="Ellery Balcombe" birthday="15-10-1999" positions="gk" nationality="en" number="31">
				<stats catching="58" shotStopping="60" distribution="57" fitness="56" stamina="26"/>
			</player>
			<player id="Hákon Valdimarsson" name="Hákon Valdimarsson" birthday="13-10-2001" positions="gk" nationality="ic" number="12">
				<stats catching="62" shotStopping="65" distribution="61" fitness="65" stamina="33"/>
			</player>
			<player id="Matthew Cox" name="Matthew Cox" birthday="02-05-2003" positions="gk" nationality="en" number="13">
				<stats catching="59" shotStopping="62" distribution="61" fitness="61" stamina="22"/>
			</player>
			<player id="Julian Eyestone" name="Julian Eyestone" birthday="21-04-2006" positions="gk" nationality="un" number="41">
				<stats catching="53" shotStopping="54" distribution="54" fitness="53" stamina="20"/>
			</player>
		</players>
	</club>
	<club shirtColor="0x000000" sleevesColor="0xFFFFFF" stripesType="none" scoreMultiplier="1" attackScore="A" defendScore="B">
		<name><![CDATA[Bournemouth]]></name>
		<profile>90</profile>
		<players>
			<player id="Ryan Christie" name="Ryan Christie" birthday="12-02-1995" positions="dm-cm-am" nationality="sc" number="10">
				<stats passing="73" tackling="70" shooting="66" crossing="69" heading="59" dribbling="72" speed="64" stamina="77" aggression="74" strength="66" fitness="70" creativity="72"/>
			</player>
			<player id="Lewis Cook" name="Lewis Cook" birthday="03-02-1997" positions="dm-fb-sm" nationality="en" number="4">
				<stats passing="73" tackling="73" shooting="61" crossing="72" heading="56" dribbling="73" speed="64" stamina="78" aggression="73" strength="64" fitness="70" creativity="73"/>
			</player>
			<player id="Tyler Adams" name="Tyler Adams" birthday="14-02-1999" positions="dm-cm" nationality="un" number="12">
				<stats passing="70" tackling="74" shooting="56" crossing="63" heading="66" dribbling="71" speed="74" stamina="73" aggression="76" strength="67" fitness="70" creativity="68"/>
			</player>
			<player id="Antoine Semenyo" name="Antoine Semenyo" birthday="07-01-2000" positions="sm-wf" nationality="gh" number="24">
				<stats passing="70" tackling="39" shooting="74" crossing="69" heading="68" dribbling="75" speed="75" stamina="77" aggression="64" strength="73" fitness="76" creativity="70"/>
			</player>
			<player id="Marcus Tavernier" name="Marcus Tavernier" birthday="22-03-1999" positions="sm-am-wf" nationality="en" number="16">
				<stats passing="68" tackling="58" shooting="70" crossing="70" heading="53" dribbling="72" speed="69" stamina="74" aggression="50" strength="58" fitness="68" creativity="69"/>
			</player>
			<player id="Justin Kluivert" name="Justin Kluivert" birthday="05-05-1999" positions="am-sm-cm" nationality="ne" number="19">
				<stats passing="74" tackling="37" shooting="75" crossing="74" heading="59" dribbling="78" speed="85" stamina="72" aggression="58" strength="58" fitness="72" creativity="75"/>
			</player>
			<player id="Amine Adli" name="Amine Adli" birthday="10-05-2000" positions="cf-sm-am" nationality="mo" number="21">
				<stats passing="67" tackling="38" shooting="70" crossing="64" heading="72" dribbling="75" speed="78" stamina="61" aggression="63" strength="67" fitness="68" creativity="68"/>
			</player>
			<player id="Alex Scott" name="Alex Scott" birthday="21-08-2003" positions="am-dm-cm" nationality="en" number="8">
				<stats passing="68" tackling="61" shooting="59" crossing="64" heading="56" dribbling="72" speed="65" stamina="66" aggression="67" strength="62" fitness="65" creativity="68"/>
			</player>
			<player id="Adrien Truffert" name="Adrien Truffert" birthday="20-11-2001" positions="fb-sm" nationality="fr" number="3">
				<stats passing="66" tackling="70" shooting="56" crossing="69" heading="60" dribbling="69" speed="71" stamina="76" aggression="63" strength="63" fitness="70" creativity="65"/>
			</player>
			<player id="Enes Ünal" name="Enes Ünal" birthday="10-05-1997" positions="cf" nationality="tü" number="26">
				<stats passing="67" tackling="39" shooting="74" crossing="60" heading="75" dribbling="69" speed="62" stamina="59" aggression="68" strength="71" fitness="63" creativity="66"/>
			</player>
			<player id="Evanilson" name="Evanilson" birthday="06-10-1999" positions="cf" nationality="br" number="9">
				<stats passing="70" tackling="36" shooting="75" crossing="55" heading="75" dribbling="72" speed="71" stamina="70" aggression="67" strength="73" fitness="71" creativity="68"/>
			</player>
			<player id="Eli Kroupi" name="Eli Kroupi" birthday="23-06-2006" positions="cf" nationality="fr" number="22">
				<stats passing="69" tackling="46" shooting="70" crossing="61" heading="62" dribbling="73" speed="77" stamina="60" aggression="47" strength="57" fitness="64" creativity="69"/>
			</player>
			<player id="Adam Smith" name="Adam Smith" birthday="29-04-1991" positions="fb-sm" nationality="en" number="15">
				<stats passing="67" tackling="69" shooting="58" crossing="65" heading="65" dribbling="66" speed="56" stamina="61" aggression="68" strength="64" fitness="60" creativity="65"/>
			</player>
			<player id="Bafodé Diakité" name="Bafodé Diakité" birthday="06-01-2001" positions="cb" nationality="fr" number="18">
				<stats passing="64" tackling="72" shooting="47" crossing="59" heading="76" dribbling="65" speed="65" stamina="70" aggression="73" strength="71" fitness="69" creativity="58"/>
			</player>
			<player id="David Brooks" name="David Brooks" birthday="08-07-1997" positions="sm-wf" nationality="wa" number="7">
				<stats passing="71" tackling="47" shooting="68" crossing="72" heading="58" dribbling="73" speed="67" stamina="57" aggression="56" strength="59" fitness="60" creativity="72"/>
			</player>
			<player id="Marcos Senesi" name="Marcos Senesi" birthday="10-05-1997" positions="cb" nationality="ar" number="5">
				<stats passing="73" tackling="75" shooting="45" crossing="61" heading="74" dribbling="68" speed="54" stamina="61" aggression="75" strength="72" fitness="62" creativity="69"/>
			</player>
			<player id="Julián Araujo" name="Julián Araujo" birthday="13-08-2001" positions="fb-sm" nationality="me" number="2">
				<stats passing="61" tackling="66" shooting="39" crossing="61" heading="66" dribbling="65" speed="76" stamina="66" aggression="71" strength="65" fitness="69" creativity="59"/>
			</player>
			<player id="Álex Jiménez" name="Álex Jiménez" birthday="08-05-2005" positions="fb-sm" nationality="sp" number="20">
				<stats passing="60" tackling="63" shooting="51" crossing="57" heading="57" dribbling="67" speed="79" stamina="62" aggression="56" strength="51" fitness="64" creativity="57"/>
			</player>
			<player id="Ben Gannon-Doak" name="Ben Gannon-Doak" birthday="11-11-2005" positions="sm-wf" nationality="sc" number="11">
				<stats passing="61" tackling="29" shooting="59" crossing="60" heading="50" dribbling="71" speed="84" stamina="62" aggression="53" strength="58" fitness="68" creativity="61"/>
			</player>
			<player id="Julio Soler" name="Julio Soler" birthday="16-02-2005" positions="fb-sm" nationality="ar" number="6">
				<stats passing="56" tackling="60" shooting="45" crossing="59" heading="57" dribbling="62" speed="69" stamina="56" aggression="61" strength="55" fitness="59" creativity="54"/>
			</player>
			<player id="James Hill" name="James Hill" birthday="10-01-2002" positions="cb-fb-sm" nationality="en" number="23">
				<stats passing="58" tackling="63" shooting="40" crossing="51" heading="64" dribbling="56" speed="59" stamina="59" aggression="63" strength="65" fitness="60" creativity="51"/>
			</player>
			<player id="Veljko Milosavljević" name="Veljko Milosavljević" birthday="28-06-2007" positions="cb" nationality="se" number="44">
				<stats passing="55" tackling="63" shooting="39" crossing="44" heading="66" dribbling="49" speed="48" stamina="57" aggression="65" strength="68" fitness="57" creativity="51"/>
			</player>
			<player id="Owen Bevan" name="Owen Bevan" birthday="26-10-2003" positions="cb" nationality="wa" number="35">
				<stats passing="44" tackling="55" shooting="32" crossing="35" heading="57" dribbling="43" speed="53" stamina="45" aggression="54" strength="60" fitness="50" creativity="36"/>
			</player>
			<player id="Đorđe Petrović" name="Đorđe Petrović" birthday="08-10-1999" positions="gk" nationality="se" number="1">
				<stats catching="76" shotStopping="79" distribution="71" fitness="76" stamina="36"/>
			</player>
			<player id="Matai Akinmboni" name="Matai Akinmboni" birthday="17-10-2006" positions="cb" nationality="un" number="45">
				<stats passing="35" tackling="48" shooting="24" crossing="26" heading="46" dribbling="34" speed="45" stamina="47" aggression="44" strength="52" fitness="48" creativity="29"/>
			</player>
			<player id="William Dennis" name="William Dennis" birthday="10-07-2000" positions="gk" nationality="en" number="40">
				<stats catching="62" shotStopping="66" distribution="60" fitness="63" stamina="27"/>
			</player>
			<player id="Callan McKenna" name="Callan McKenna" birthday="22-12-2006" positions="gk" nationality="sc" number="32">
				<stats catching="51" shotStopping="52" distribution="51" fitness="52" stamina="25"/>
			</player>
		</players>
	</club>
	<club shirtColor="0x000000" sleevesColor="0xFFFFFF" stripesType="none" scoreMultiplier="1" attackScore="A" defendScore="B">
		<name><![CDATA[Chelsea]]></name>
		<profile>90</profile>
		<players>
			<player id="Reece James" name="Reece James" birthday="08-12-1999" positions="fb" nationality="en" number="24">
				<stats passing="72" tackling="74" shooting="67" crossing="76" heading="74" dribbling="69" speed="68" stamina="63" aggression="75" strength="76" fitness="67" creativity="72"/>
			</player>
			<player id="Enzo Fernández" name="Enzo Fernández" birthday="17-01-2001" positions="cm-dm-am" nationality="ar" number="8">
				<stats passing="82" tackling="70" shooting="73" crossing="78" heading="69" dribbling="77" speed="64" stamina="78" aggression="76" strength="66" fitness="70" creativity="81"/>
			</player>
			<player id="Marc Cucurella" name="Marc Cucurella" birthday="22-07-1998" positions="fb" nationality="sp" number="3">
				<stats passing="76" tackling="78" shooting="64" crossing="76" heading="73" dribbling="76" speed="71" stamina="82" aggression="78" strength="70" fitness="75" creativity="74"/>
			</player>
			<player id="Moisés Caicedo" name="Moisés Caicedo" birthday="02-11-2001" positions="dm-cm" nationality="ec" number="25">
				<stats passing="81" tackling="82" shooting="65" crossing="70" heading="73" dribbling="78" speed="69" stamina="85" aggression="81" strength="75" fitness="77" creativity="78"/>
			</player>
			<player id="Cole Palmer" name="Cole Palmer" birthday="06-05-2002" positions="am-sm-cf" nationality="en" number="10">
				<stats passing="88" tackling="51" shooting="84" crossing="87" heading="63" dribbling="86" speed="76" stamina="81" aggression="57" strength="64" fitness="75" creativity="88"/>
			</player>
			<player id="Andrey Santos" name="Andrey Santos" birthday="03-05-2004" positions="cm-dm" nationality="br" number="17">
				<stats passing="72" tackling="70" shooting="65" crossing="60" heading="73" dribbling="70" speed="67" stamina="78" aggression="70" strength="68" fitness="72" creativity="70"/>
			</player>
			<player id="Malo Gusto" name="Malo Gusto" birthday="19-05-2003" positions="fb-sm" nationality="fr" number="27">
				<stats passing="70" tackling="70" shooting="48" crossing="72" heading="60" dribbling="72" speed="78" stamina="77" aggression="69" strength="65" fitness="75" creativity="70"/>
			</player>
			<player id="Pedro Neto" name="Pedro Neto" birthday="09-03-2000" positions="sm-cf-wf" nationality="po" number="7">
				<stats passing="70" tackling="39" shooting="72" crossing="72" heading="59" dribbling="78" speed="86" stamina="70" aggression="62" strength="66" fitness="74" creativity="71"/>
			</player>
			<player id="Roméo Lavia" name="Roméo Lavia" birthday="06-01-2004" positions="dm-cm" nationality="be" number="45">
				<stats passing="73" tackling="73" shooting="53" crossing="64" heading="71" dribbling="72" speed="65" stamina="63" aggression="74" strength="73" fitness="66" creativity="71"/>
			</player>
			<player id="João Pedro" name="João Pedro" birthday="26-09-2001" positions="cf-am" nationality="br" number="20">
				<stats passing="72" tackling="33" shooting="73" crossing="66" heading="72" dribbling="75" speed="74" stamina="70" aggression="57" strength="68" fitness="70" creativity="71"/>
			</player>
			<player id="Dário Essugo" name="Dário Essugo" birthday="14-03-2005" positions="dm-cm-cb" nationality="po" number="14">
				<stats passing="63" tackling="66" shooting="54" crossing="48" heading="65" dribbling="65" speed="67" stamina="68" aggression="71" strength="72" fitness="68" creativity="61"/>
			</player>
			<player id="Raheem Sterling" name="Raheem Sterling" birthday="08-12-1994" positions="wf-sm" nationality="en" number="15">
				<stats passing="75" tackling="45" shooting="76" crossing="76" heading="52" dribbling="84" speed="83" stamina="56" aggression="51" strength="54" fitness="64" creativity="76"/>
			</player>
			<player id="Estêvão" name="Estêvão" birthday="24-04-2007" positions="sm-am-wf" nationality="br" number="41">
				<stats passing="71" tackling="34" shooting="73" crossing="73" heading="55" dribbling="80" speed="88" stamina="66" aggression="56" strength="56" fitness="70" creativity="73"/>
			</player>
			<player id="Alejandro Garnacho" name="Alejandro Garnacho" birthday="01-07-2004" positions="am-wf-sm-cm" nationality="ar" number="49">
				<stats passing="70" tackling="37" shooting="75" crossing="72" heading="49" dribbling="78" speed="83" stamina="73" aggression="59" strength="52" fitness="70" creativity="71"/>
			</player>
			<player id="Levi Colwill" name="Levi Colwill" birthday="26-02-2003" positions="cb" nationality="en" number="6">
				<stats passing="69" tackling="73" shooting="45" crossing="63" heading="74" dribbling="65" speed="63" stamina="69" aggression="75" strength="70" fitness="67" creativity="67"/>
			</player>
			<player id="Trevoh Chalobah" name="Trevoh Chalobah" birthday="05-07-1999" positions="cb-fb-sm" nationality="en" number="23">
				<stats passing="70" tackling="75" shooting="54" crossing="62" heading="75" dribbling="64" speed="62" stamina="63" aggression="72" strength="74" fitness="65" creativity="66"/>
			</player>
			<player id="Jorrel Hato" name="Jorrel Hato" birthday="07-03-2006" positions="fb-cb" nationality="ne" number="21">
				<stats passing="71" tackling="71" shooting="46" crossing="63" heading="72" dribbling="70" speed="80" stamina="66" aggression="68" strength="70" fitness="71" creativity="66"/>
			</player>
			<player id="Liam Delap" name="Liam Delap" birthday="08-02-2003" positions="cf" nationality="en" number="9">
				<stats passing="62" tackling="29" shooting="74" crossing="55" heading="75" dribbling="70" speed="73" stamina="66" aggression="72" strength="76" fitness="71" creativity="60"/>
			</player>
			<player id="Wesley Fofana" name="Wesley Fofana" birthday="17-12-2000" positions="cb" nationality="fr" number="29">
				<stats passing="67" tackling="75" shooting="43" crossing="49" heading="73" dribbling="65" speed="68" stamina="63" aggression="76" strength="72" fitness="67" creativity="60"/>
			</player>
			<player id="Joshua Acheampong" name="Joshua Acheampong" birthday="05-05-2006" positions="fb-cb-dm-sm" nationality="en" number="34">
				<stats passing="59" tackling="58" shooting="47" crossing="57" heading="63" dribbling="60" speed="66" stamina="59" aggression="61" strength="65" fitness="63" creativity="57"/>
			</player>
			<player id="Jamie Gittens" name="Jamie Gittens" birthday="08-08-2004" positions="sm-wf" nationality="en" number="11">
				<stats passing="69" tackling="29" shooting="75" crossing="69" heading="51" dribbling="83" speed="92" stamina="77" aggression="45" strength="60" fitness="78" creativity="69"/>
			</player>
			<player id="Abdul-Nasir Adarabioyo" name="Abdul-Nasir Adarabioyo" birthday="24-09-1997" positions="cb" nationality="en" number="4">
				<stats passing="68" tackling="73" shooting="47" crossing="50" heading="74" dribbling="58" speed="64" stamina="62" aggression="73" strength="71" fitness="65" creativity="61"/>
			</player>
			<player id="Facundo Buonanotte" name="Facundo Buonanotte" birthday="23-12-2004" positions="sm-am-wf" nationality="ar" number="40">
				<stats passing="74" tackling="31" shooting="70" crossing="71" heading="52" dribbling="75" speed="74" stamina="67" aggression="38" strength="56" fitness="66" creativity="73"/>
			</player>
			<player id="Benoît Badiashile" name="Benoît Badiashile" birthday="26-03-2001" positions="cb" nationality="fr" number="5">
				<stats passing="66" tackling="71" shooting="47" crossing="52" heading="70" dribbling="58" speed="55" stamina="61" aggression="72" strength="71" fitness="62" creativity="62"/>
			</player>
			<player id="Tyrique George" name="Tyrique George" birthday="04-02-2006" positions="sm-cf-wf" nationality="en" number="32">
				<stats passing="64" tackling="34" shooting="64" crossing="63" heading="52" dribbling="70" speed="75" stamina="64" aggression="47" strength="54" fitness="65" creativity="64"/>
			</player>
			<player id="Marc Guiu" name="Marc Guiu" birthday="04-01-2006" positions="cf" nationality="sp" number="38">
				<stats passing="55" tackling="32" shooting="63" crossing="46" heading="68" dribbling="61" speed="68" stamina="60" aggression="68" strength="67" fitness="64" creativity="52"/>
			</player>
			<player id="Axel Disasi" name="Axel Disasi" birthday="11-03-1998" positions="cb-fb-sm" nationality="fr" number="2">
				<stats passing="64" tackling="72" shooting="50" crossing="51" heading="77" dribbling="55" speed="52" stamina="59" aggression="73" strength="75" fitness="61" creativity="56"/>
			</player>
			<player id="Robert Sánchez" name="Robert Sánchez" birthday="18-11-1997" positions="gk" nationality="sp" number="1">
				<stats catching="74" shotStopping="76" distribution="72" fitness="74" stamina="38"/>
			</player>
			<player id="Filip Jörgensen" name="Filip Jörgensen" birthday="16-04-2002" positions="gk" nationality="de" number="12">
				<stats catching="74" shotStopping="75" distribution="70" fitness="75" stamina="34"/>
			</player>
			<player id="Gabriel Slonina" name="Gabriel Slonina" birthday="15-05-2004" positions="gk" nationality="un" number="44">
				<stats catching="61" shotStopping="67" distribution="60" fitness="62" stamina="34"/>
			</player>
		</players>
	</club>
	<club shirtColor="0x000000" sleevesColor="0xFFFFFF" stripesType="none" scoreMultiplier="1" attackScore="A" defendScore="B">
		<name><![CDATA[Everton]]></name>
		<profile>90</profile>
		<players>
			<player id="Kiernan Dewsbury-Hall" name="Kiernan Dewsbury-Hall" birthday="06-09-1998" positions="cm-am-dm" nationality="en" number="22">
				<stats passing="71" tackling="65" shooting="67" crossing="69" heading="62" dribbling="71" speed="60" stamina="68" aggression="68" strength="63" fitness="64" creativity="71"/>
			</player>
			<player id="Jack Grealish" name="Jack Grealish" birthday="10-09-1995" positions="wf-sm" nationality="en" number="18">
				<stats passing="76" tackling="52" shooting="73" crossing="76" heading="56" dribbling="80" speed="68" stamina="66" aggression="61" strength="66" fitness="67" creativity="77"/>
			</player>
			<player id="Dwight McNeil" name="Dwight McNeil" birthday="22-11-1999" positions="sm-am-wf" nationality="en" number="7">
				<stats passing="73" tackling="54" shooting="72" crossing="76" heading="59" dribbling="73" speed="63" stamina="76" aggression="54" strength="61" fitness="69" creativity="74"/>
			</player>
			<player id="James Garner" name="James Garner" birthday="13-03-2001" positions="dm-cm" nationality="en" number="37">
				<stats passing="74" tackling="68" shooting="64" crossing="72" heading="61" dribbling="67" speed="55" stamina="68" aggression="68" strength="62" fitness="63" creativity="72"/>
			</player>
			<player id="Idrissa Gueye" name="Idrissa Gueye" birthday="26-09-1989" positions="dm-cm" nationality="se" number="27">
				<stats passing="72" tackling="78" shooting="60" crossing="65" heading="68" dribbling="72" speed="59" stamina="77" aggression="77" strength="62" fitness="67" creativity="67"/>
			</player>
			<player id="Vitalii Mykolenko" name="Vitalii Mykolenko" birthday="29-05-1999" positions="fb-sm" nationality="uk" number="16">
				<stats passing="69" tackling="75" shooting="56" crossing="70" heading="65" dribbling="68" speed="70" stamina="73" aggression="64" strength="66" fitness="70" creativity="68"/>
			</player>
			<player id="Carlos Alcaraz" name="Carlos Alcaraz" birthday="30-11-2002" positions="am-cm-cf" nationality="ar" number="24">
				<stats passing="68" tackling="42" shooting="65" crossing="61" heading="62" dribbling="71" speed="74" stamina="63" aggression="65" strength="58" fitness="65" creativity="68"/>
			</player>
			<player id="Iliman Ndiaye" name="Iliman Ndiaye" birthday="06-03-2000" positions="sm-wf" nationality="se" number="10">
				<stats passing="73" tackling="38" shooting="76" crossing="70" heading="63" dribbling="82" speed="83" stamina="71" aggression="51" strength="66" fitness="74" creativity="73"/>
			</player>
			<player id="Merlin Röhl" name="Merlin Röhl" birthday="05-07-2002" positions="am-cm-dm-cf" nationality="ge" number="34">
				<stats passing="67" tackling="59" shooting="62" crossing="58" heading="62" dribbling="68" speed="73" stamina="72" aggression="55" strength="64" fitness="71" creativity="66"/>
			</player>
			<player id="Timothy Iroegbunam" name="Timothy Iroegbunam" birthday="30-06-2003" positions="dm-cm" nationality="en" number="42">
				<stats passing="68" tackling="68" shooting="57" crossing="58" heading="66" dribbling="67" speed="61" stamina="66" aggression="67" strength="66" fitness="64" creativity="66"/>
			</player>
			<player id="Séamus Coleman" name="Séamus Coleman" birthday="11-10-1988" positions="fb-sm" nationality="re" number="23">
				<stats passing="67" tackling="69" shooting="63" crossing="66" heading="62" dribbling="65" speed="47" stamina="38" aggression="70" strength="62" fitness="47" creativity="65"/>
			</player>
			<player id="Jake O'Brien" name="Jake O'Brien" birthday="15-05-2001" positions="cb-fb-sm" nationality="re" number="15">
				<stats passing="59" tackling="67" shooting="47" crossing="56" heading="74" dribbling="53" speed="68" stamina="58" aggression="69" strength="69" fitness="64" creativity="56"/>
			</player>
			<player id="Tyler-Jay Dibling" name="Tyler-Jay Dibling" birthday="17-02-2006" positions="sm-wf-am" nationality="en" number="20">
				<stats passing="67" tackling="38" shooting="65" crossing="69" heading="53" dribbling="73" speed="73" stamina="65" aggression="54" strength="66" fitness="68" creativity="68"/>
			</player>
			<player id="Thierno Barry" name="Thierno Barry" birthday="21-10-2002" positions="cf" nationality="fr" number="11">
				<stats passing="66" tackling="23" shooting="71" crossing="58" heading="73" dribbling="70" speed="75" stamina="63" aggression="56" strength="72" fitness="70" creativity="65"/>
			</player>
			<player id="James Tarkowski" name="James Tarkowski" birthday="19-11-1992" positions="cb" nationality="en" number="6">
				<stats passing="65" tackling="78" shooting="49" crossing="58" heading="79" dribbling="57" speed="43" stamina="64" aggression="83" strength="76" fitness="61" creativity="60"/>
			</player>
			<player id="Nathan Patterson" name="Nathan Patterson" birthday="16-10-2001" positions="fb-sm" nationality="sc" number="2">
				<stats passing="58" tackling="65" shooting="45" crossing="59" heading="61" dribbling="63" speed="64" stamina="61" aggression="66" strength="63" fitness="62" creativity="55"/>
			</player>
			<player id="Beto" name="Beto" birthday="31-01-1998" positions="cf" nationality="gu" number="9">
				<stats passing="61" tackling="24" shooting="71" crossing="48" heading="78" dribbling="61" speed="69" stamina="64" aggression="65" strength="77" fitness="70" creativity="59"/>
			</player>
			<player id="Adam Aznou" name="Adam Aznou" birthday="02-06-2006" positions="fb" nationality="mo" number="39">
				<stats passing="57" tackling="56" shooting="50" crossing="59" heading="43" dribbling="65" speed="74" stamina="53" aggression="49" strength="47" fitness="58" creativity="57"/>
			</player>
			<player id="Jarrad Branthwaite" name="Jarrad Branthwaite" birthday="27-06-2002" positions="cb" nationality="en" number="32">
				<stats passing="68" tackling="76" shooting="44" crossing="42" heading="75" dribbling="56" speed="66" stamina="66" aggression="73" strength="71" fitness="66" creativity="55"/>
			</player>
			<player id="Michael Keane" name="Michael Keane" birthday="11-01-1993" positions="cb" nationality="en" number="5">
				<stats passing="63" tackling="70" shooting="48" crossing="56" heading="75" dribbling="55" speed="38" stamina="50" aggression="73" strength="74" fitness="52" creativity="58"/>
			</player>
			<player id="Jordan Pickford" name="Jordan Pickford" birthday="07-03-1994" positions="gk" nationality="en" number="1">
				<stats catching="76" shotStopping="83" distribution="86" fitness="79" stamina="39"/>
			</player>
			<player id="Mark Travers" name="Mark Travers" birthday="18-05-1999" positions="gk" nationality="re" number="12">
				<stats catching="67" shotStopping="71" distribution="67" fitness="69" stamina="29"/>
			</player>
			<player id="Thomas King" name="Thomas King" birthday="09-03-1995" positions="gk" nationality="wa" number="31">
				<stats catching="60" shotStopping="60" distribution="58" fitness="60" stamina="30"/>
			</player>
			<player id="Harry Tyrer" name="Harry Tyrer" birthday="06-12-2001" positions="gk" nationality="en" number="53">
				<stats catching="58" shotStopping="62" distribution="59" fitness="59" stamina="27"/>
			</player>
		</players>
	</club>
	<club shirtColor="0x000000" sleevesColor="0xFFFFFF" stripesType="none" scoreMultiplier="1" attackScore="A" defendScore="B">
		<name><![CDATA[Fulham]]></name>
		<profile>90</profile>
		<players>
			<player id="Saša Lukić" name="Saša Lukić" birthday="13-08-1996" positions="dm-cm" nationality="se" number="20">
				<stats passing="70" tackling="71" shooting="64" crossing="71" heading="64" dribbling="67" speed="56" stamina="75" aggression="75" strength="68" fitness="67" creativity="70"/>
			</player>
			<player id="Alexander Iwobi" name="Alexander Iwobi" birthday="03-05-1996" positions="sm-wf" nationality="ni" number="17">
				<stats passing="73" tackling="55" shooting="70" crossing="73" heading="55" dribbling="74" speed="70" stamina="79" aggression="57" strength="66" fitness="73" creativity="74"/>
			</player>
			<player id="Antonee Robinson" name="Antonee Robinson" birthday="08-08-1997" positions="fb-sm" nationality="un" number="33">
				<stats passing="70" tackling="73" shooting="48" crossing="73" heading="67" dribbling="70" speed="81" stamina="80" aggression="75" strength="68" fitness="77" creativity="71"/>
			</player>
			<player id="Kouassi Sessegnon" name="Kouassi Sessegnon" birthday="18-05-2000" positions="fb" nationality="en" number="30">
				<stats passing="66" tackling="65" shooting="63" crossing="68" heading="61" dribbling="70" speed="71" stamina="63" aggression="61" strength="60" fitness="65" creativity="67"/>
			</player>
			<player id="Raúl Jiménez" name="Raúl Jiménez" birthday="05-05-1991" positions="cf" nationality="me" number="7">
				<stats passing="69" tackling="40" shooting="71" crossing="66" heading="75" dribbling="67" speed="53" stamina="62" aggression="71" strength="74" fitness="63" creativity="69"/>
			</player>
			<player id="Harry Wilson" name="Harry Wilson" birthday="22-03-1997" positions="sm-wf" nationality="wa" number="8">
				<stats passing="71" tackling="43" shooting="74" crossing="73" heading="61" dribbling="73" speed="72" stamina="65" aggression="45" strength="56" fitness="64" creativity="72"/>
			</player>
			<player id="Sander Berge" name="Sander Berge" birthday="18-02-1998" positions="dm-cm-cb" nationality="no" number="16">
				<stats passing="74" tackling="73" shooting="65" crossing="68" heading="76" dribbling="65" speed="52" stamina="73" aggression="74" strength="75" fitness="68" creativity="73"/>
			</player>
			<player id="Thomas Cairney" name="Thomas Cairney" birthday="20-01-1991" positions="cm-dm-am" nationality="sc" number="10">
				<stats passing="74" tackling="64" shooting="69" crossing="73" heading="59" dribbling="70" speed="50" stamina="54" aggression="59" strength="64" fitness="55" creativity="73"/>
			</player>
			<player id="Emile Smith Rowe" name="Emile Smith Rowe" birthday="28-07-2000" positions="am-cm-sm" nationality="en" number="32">
				<stats passing="74" tackling="51" shooting="70" crossing="73" heading="60" dribbling="76" speed="70" stamina="65" aggression="52" strength="61" fitness="66" creativity="74"/>
			</player>
			<player id="Timothy Castagne" name="Timothy Castagne" birthday="05-12-1995" positions="fb-sm" nationality="be" number="21">
				<stats passing="67" tackling="69" shooting="56" crossing="67" heading="67" dribbling="66" speed="63" stamina="70" aggression="69" strength="63" fitness="66" creativity="65"/>
			</player>
			<player id="Kenny Tete" name="Kenny Tete" birthday="09-10-1995" positions="fb-sm" nationality="ne" number="2">
				<stats passing="64" tackling="72" shooting="49" crossing="66" heading="72" dribbling="65" speed="68" stamina="69" aggression="73" strength="70" fitness="69" creativity="60"/>
			</player>
			<player id="Calvin Bassey" name="Calvin Bassey" birthday="31-12-1999" positions="cb" nationality="ni" number="3">
				<stats passing="58" tackling="68" shooting="43" crossing="57" heading="70" dribbling="60" speed="70" stamina="73" aggression="73" strength="73" fitness="72" creativity="53"/>
			</player>
			<player id="Adama Traoré" name="Adama Traoré" birthday="25-01-1996" positions="sm-wf" nationality="sp" number="11">
				<stats passing="60" tackling="37" shooting="61" crossing="64" heading="59" dribbling="71" speed="85" stamina="66" aggression="67" strength="79" fitness="75" creativity="63"/>
			</player>
			<player id="Samuel Chukwueze" name="Samuel Chukwueze" birthday="22-05-1999" positions="sm-wf" nationality="ni" number="19">
				<stats passing="75" tackling="37" shooting="75" crossing="75" heading="54" dribbling="82" speed="89" stamina="64" aggression="49" strength="62" fitness="71" creativity="76"/>
			</player>
			<player id="Joachim Andersen" name="Joachim Andersen" birthday="31-05-1996" positions="cb" nationality="de" number="5">
				<stats passing="73" tackling="75" shooting="58" crossing="61" heading="74" dribbling="61" speed="37" stamina="66" aggression="81" strength="76" fitness="60" creativity="69"/>
			</player>
			<player id="Rodrigo Muniz" name="Rodrigo Muniz" birthday="04-05-2001" positions="cf" nationality="br" number="9">
				<stats passing="61" tackling="39" shooting="69" crossing="50" heading="73" dribbling="65" speed="63" stamina="64" aggression="69" strength="71" fitness="65" creativity="59"/>
			</player>
			<player id="Harrison Reed" name="Harrison Reed" birthday="27-01-1995" positions="dm-cm" nationality="en" number="6">
				<stats passing="68" tackling="70" shooting="60" crossing="68" heading="58" dribbling="66" speed="51" stamina="46" aggression="75" strength="64" fitness="52" creativity="67"/>
			</player>
			<player id="Kevin" name="Kevin" birthday="04-01-2003" positions="sm-wf" nationality="br" number="22">
				<stats passing="69" tackling="34" shooting="68" crossing="70" heading="54" dribbling="76" speed="79" stamina="66" aggression="57" strength="58" fitness="69" creativity="70"/>
			</player>
			<player id="Joshua King" name="Joshua King" birthday="03-01-2007" positions="cm-dm-am" nationality="en" number="24">
				<stats passing="62" tackling="57" shooting="58" crossing="59" heading="45" dribbling="64" speed="61" stamina="60" aggression="54" strength="52" fitness="58" creativity="62"/>
			</player>
			<player id="Jorge Cuenca" name="Jorge Cuenca" birthday="17-11-1999" positions="cb" nationality="sp" number="15">
				<stats passing="62" tackling="69" shooting="39" crossing="46" heading="70" dribbling="52" speed="64" stamina="61" aggression="68" strength="67" fitness="63" creativity="53"/>
			</player>
			<player id="Issa Diop" name="Issa Diop" birthday="09-01-1997" positions="cb" nationality="fr" number="31">
				<stats passing="59" tackling="72" shooting="40" crossing="41" heading="76" dribbling="52" speed="53" stamina="56" aggression="74" strength="73" fitness="61" creativity="48"/>
			</player>
			<player id="Jonah Kusi-Asare" name="Jonah Kusi-Asare" birthday="04-07-2007" positions="cf" nationality="sw" number="18">
				<stats passing="43" tackling="24" shooting="51" crossing="30" heading="61" dribbling="52" speed="53" stamina="50" aggression="45" strength="64" fitness="55" creativity="42"/>
			</player>
			<player id="Bernd Leno" name="Bernd Leno" birthday="04-03-1992" positions="gk" nationality="ge" number="1">
				<stats catching="75" shotStopping="77" distribution="72" fitness="76" stamina="42"/>
			</player>
			<player id="Benjamin Lecomte" name="Benjamin Lecomte" birthday="26-04-1991" positions="gk" nationality="fr" number="23">
				<stats catching="69" shotStopping="71" distribution="72" fitness="70" stamina="33"/>
			</player>
		</players>
	</club>
	<club shirtColor="0x000000" sleevesColor="0xFFFFFF" stripesType="none" scoreMultiplier="1" attackScore="A" defendScore="B">
		<name><![CDATA[Liverpool]]></name>
		<profile>90</profile>
		<players>
			<player id="Alexis Mac Allister" name="Alexis Mac Allister" birthday="24-12-1998" positions="cm-dm" nationality="ar" number="10" ageImprovement="0">
				<stats passing="81" tackling="74" shooting="76" crossing="76" heading="64" dribbling="79" speed="61" stamina="79" aggression="75" strength="67" fitness="70" creativity="79"/>
			</player>
			<player id="Mohamed Salah" name="Mohamed Salah" birthday="15-06-1992" positions="sm-wf" nationality="eg" number="11" ageImprovement="0">
				<stats passing="83" tackling="45" shooting="83" crossing="81" heading="64" dribbling="85" speed="83" stamina="82" aggression="61" strength="72" fitness="79" creativity="82"/>
			</player>
			<player id="Dominik Szoboszlai" name="Dominik Szoboszlai" birthday="25-10-2000" positions="am-cm" nationality="hu" number="8" ageImprovement="0">
				<stats passing="74" tackling="61" shooting="73" crossing="74" heading="62" dribbling="72" speed="70" stamina="75" aggression="65" strength="62" fitness="71" creativity="74"/>
			</player>
			<player id="Ryan Gravenberch" name="Ryan Gravenberch" birthday="16-05-2002" positions="dm-cm" nationality="ne" number="38" ageImprovement="0">
				<stats passing="76" tackling="74" shooting="71" crossing="70" heading="67" dribbling="75" speed="68" stamina="75" aggression="70" strength="70" fitness="72" creativity="74"/>
			</player>
			<player id="Florian Wirtz" name="Florian Wirtz" birthday="03-05-2003" positions="am-cf-cm" nationality="ge" number="7" ageImprovement="0">
				<stats passing="83" tackling="50" shooting="77" crossing="81" heading="51" dribbling="82" speed="74" stamina="78" aggression="58" strength="59" fitness="72" creativity="83"/>
			</player>
			<player id="Milos Kerkez" name="Milos Kerkez" birthday="07-11-2003" positions="fb-sm" nationality="hu" number="6" ageImprovement="0">
				<stats passing="66" tackling="70" shooting="56" crossing="69" heading="61" dribbling="69" speed="77" stamina="77" aggression="71" strength="67" fitness="75" creativity="66"/>
			</player>
			<player id="Cody Gakpo" name="Cody Gakpo" birthday="07-05-1999" positions="sm-wf" nationality="ne" number="18" ageImprovement="0">
				<stats passing="74" tackling="43" shooting="76" crossing="75" heading="74" dribbling="75" speed="76" stamina="69" aggression="59" strength="68" fitness="71" creativity="74"/>
			</player>
			<player id="Andrew Robertson" name="Andrew Robertson" birthday="11-03-1994" positions="fb-sm" nationality="sc" number="26" ageImprovement="0">
				<stats passing="71" tackling="71" shooting="59" crossing="74" heading="65" dribbling="70" speed="67" stamina="71" aggression="73" strength="63" fitness="68" creativity="71"/>
			</player>
			<player id="Virgil van Dijk" name="Virgil van Dijk" birthday="08-07-1991" positions="cb" nationality="ne" number="4" ageImprovement="0">
				<stats passing="78" tackling="88" shooting="62" crossing="61" heading="86" dribbling="69" speed="70" stamina="72" aggression="84" strength="83" fitness="74" creativity="71"/>
			</player>
			<player id="Curtis Jones" name="Curtis Jones" birthday="30-01-2001" positions="am-cm-dm" nationality="en" number="17" ageImprovement="0">
				<stats passing="68" tackling="63" shooting="64" crossing="62" heading="55" dribbling="68" speed="62" stamina="68" aggression="62" strength="62" fitness="65" creativity="68"/>
			</player>
			<player id="Jeremie Frimpong" name="Jeremie Frimpong" birthday="10-12-2000" positions="fb-sm-wf" nationality="ne" number="30" ageImprovement="0">
				<stats passing="67" tackling="65" shooting="59" crossing="69" heading="52" dribbling="75" speed="83" stamina="72" aggression="63" strength="50" fitness="70" creativity="66"/>
			</player>
			<player id="Alexander Isak" name="Alexander Isak" birthday="21-09-1999" positions="cf" nationality="sw" number="9" ageImprovement="0">
				<stats passing="77" tackling="39" shooting="88" crossing="71" heading="81" dribbling="83" speed="82" stamina="80" aggression="60" strength="77" fitness="80" creativity="77"/>
			</player>
			<player id="Federico Chiesa" name="Federico Chiesa" birthday="25-10-1997" positions="sm-cf-wf" nationality="it" number="14" ageImprovement="0">
				<stats passing="68" tackling="40" shooting="70" crossing="66" heading="56" dribbling="73" speed="76" stamina="57" aggression="62" strength="62" fitness="65" creativity="68"/>
			</player>
			<player id="Wataru Endo" name="Wataru Endo" birthday="09-02-1993" positions="dm-cm" nationality="ja" number="3" ageImprovement="0">
				<stats passing="70" tackling="70" shooting="63" crossing="57" heading="71" dribbling="69" speed="53" stamina="69" aggression="71" strength="65" fitness="62" creativity="66"/>
			</player>
			<player id="Conor Bradley" name="Conor Bradley" birthday="09-07-2003" positions="fb-sm" nationality="no" number="12" ageImprovement="0">
				<stats passing="63" tackling="67" shooting="57" crossing="64" heading="62" dribbling="65" speed="71" stamina="71" aggression="71" strength="60" fitness="68" creativity="62"/>
			</player>
			<player id="Hugo Ekitiké" name="Hugo Ekitiké" birthday="20-06-2002" positions="cf-am" nationality="fr" number="22" ageImprovement="0">
				<stats passing="71" tackling="31" shooting="74" crossing="58" heading="71" dribbling="77" speed="80" stamina="77" aggression="58" strength="66" fitness="76" creativity="71"/>
			</player>
			<player id="Stefan Bajcetic" name="Stefan Bajcetic" birthday="22-10-2004" positions="dm-cm-cb" nationality="sp" number="43" ageImprovement="0">
				<stats passing="60" tackling="61" shooting="46" crossing="51" heading="53" dribbling="60" speed="61" stamina="57" aggression="60" strength="59" fitness="59" creativity="59"/>
			</player>
			<player id="Ibrahima Konaté" name="Ibrahima Konaté" birthday="25-05-1999" positions="cb" nationality="fr" number="5" ageImprovement="0">
				<stats passing="74" tackling="83" shooting="40" crossing="50" heading="82" dribbling="66" speed="73" stamina="71" aggression="82" strength="80" fitness="74" creativity="66"/>
			</player>
			<player id="Joseph Gomez" name="Joseph Gomez" birthday="23-05-1997" positions="cb-fb-sm" nationality="en" number="2" ageImprovement="0">
				<stats passing="66" tackling="70" shooting="35" crossing="62" heading="70" dribbling="63" speed="65" stamina="53" aggression="68" strength="68" fitness="60" creativity="61"/>
			</player>
			<player id="Rio Ngumoha" name="Rio Ngumoha" birthday="29-08-2008" positions="sm-wf" nationality="en" number="73" ageImprovement="0">
				<stats passing="53" tackling="34" shooting="58" crossing="55" heading="43" dribbling="65" speed="80" stamina="57" aggression="37" strength="53" fitness="63" creativity="56"/>
			</player>
			<player id="Calvin Ramsay" name="Calvin Ramsay" birthday="31-07-2003" positions="fb-sm" nationality="sc" number="47" ageImprovement="0">
				<stats passing="52" tackling="50" shooting="42" crossing="53" heading="49" dribbling="54" speed="64" stamina="59" aggression="51" strength="53" fitness="59" creativity="51"/>
			</player>
			<player id="Treymaurice Nyoni" name="Treymaurice Nyoni" birthday="30-06-2007" positions="cm-am" nationality="en" number="42" ageImprovement="0">
				<stats passing="57" tackling="46" shooting="49" crossing="49" heading="45" dribbling="59" speed="58" stamina="50" aggression="44" strength="46" fitness="51" creativity="56"/>
			</player>
			<player id="Alisson" name="Alisson" birthday="02-10-1992" positions="gk" nationality="br" number="1" ageImprovement="0">
				<stats catching="86" shotStopping="89" distribution="87" fitness="91" stamina="32"/>
			</player>
			<player id="Rhys Williams" name="Rhys Williams" birthday="03-02-2001" positions="cb" nationality="en" number="46" ageImprovement="0">
				<stats passing="48" tackling="52" shooting="33" crossing="34" heading="55" dribbling="45" speed="55" stamina="45" aggression="56" strength="58" fitness="51" creativity="43"/>
			</player>
			<player id="Giovanni Leoni" name="Giovanni Leoni" birthday="21-12-2006" positions="cb" nationality="it" number="15" ageImprovement="0">
				<stats passing="52" tackling="67" shooting="32" crossing="30" heading="64" dribbling="50" speed="50" stamina="60" aggression="65" strength="62" fitness="58" creativity="40"/>
			</player>
			<player id="Frederick Woodman" name="Frederick Woodman" birthday="04-03-1997" positions="gk" nationality="en" number="28" ageImprovement="0">
				<stats catching="68" shotStopping="70" distribution="61" fitness="67" stamina="33"/>
			</player>
			<player id="Giorgi Mamardashvili" name="Giorgi Mamardashvili" birthday="29-09-2000" positions="gk" nationality="ge" number="25" ageImprovement="0">
				<stats catching="81" shotStopping="84" distribution="72" fitness="84" stamina="45"/>
			</player>
			<player id="Ármin Pécsi" name="Ármin Pécsi" birthday="24-02-2005" positions="gk" nationality="hu" number="41" ageImprovement="0">
				<stats catching="59" shotStopping="62" distribution="60" fitness="60" stamina="20"/>
			</player>
		</players>
	</club>
	<club shirtColor="0x000000" sleevesColor="0xFFFFFF" stripesType="none" scoreMultiplier="1" attackScore="A" defendScore="B">
		<name><![CDATA[Manchester City]]></name>
		<profile>90</profile>
		<players>
			<player id="Rodri" name="Rodri" birthday="22-06-1996" positions="dm-cm" nationality="sp" number="16">
				<stats passing="88" tackling="83" shooting="80" crossing="79" heading="79" dribbling="80" speed="63" stamina="85" aggression="82" strength="78" fitness="76" creativity="84"/>
			</player>
			<player id="Tijjani Reijnders" name="Tijjani Reijnders" birthday="29-07-1998" positions="cm-dm-am" nationality="ne" number="4">
				<stats passing="80" tackling="73" shooting="76" crossing="73" heading="65" dribbling="79" speed="74" stamina="83" aggression="74" strength="67" fitness="76" creativity="79"/>
			</player>
			<player id="Bernardo Silva" name="Bernardo Silva" birthday="10-08-1994" positions="cm-sm-dm-am" nationality="po" number="20">
				<stats passing="83" tackling="70" shooting="78" crossing="81" heading="55" dribbling="86" speed="60" stamina="84" aggression="71" strength="55" fitness="69" creativity="83"/>
			</player>
			<player id="Joško Gvardiol" name="Joško Gvardiol" birthday="23-01-2002" positions="fb-cb-sm" nationality="cr" number="24">
				<stats passing="74" tackling="80" shooting="69" crossing="70" heading="79" dribbling="73" speed="74" stamina="75" aggression="80" strength="75" fitness="74" creativity="71"/>
			</player>
			<player id="Erling Haaland" name="Erling Haaland" birthday="21-07-2000" positions="cf" nationality="no" number="9">
				<stats passing="75" tackling="45" shooting="89" crossing="64" heading="86" dribbling="77" speed="83" stamina="75" aggression="82" strength="87" fitness="80" creativity="73"/>
			</player>
			<player id="Mateo Kovačić" name="Mateo Kovačić" birthday="06-05-1994" positions="cm-dm-am" nationality="cr" number="8">
				<stats passing="81" tackling="74" shooting="74" crossing="75" heading="55" dribbling="79" speed="64" stamina="73" aggression="73" strength="66" fitness="69" creativity="80"/>
			</player>
			<player id="Philip Foden" name="Philip Foden" birthday="28-05-2000" positions="wf-cm-sm" nationality="en" number="47">
				<stats passing="83" tackling="57" shooting="82" crossing="82" heading="51" dribbling="88" speed="81" stamina="79" aggression="61" strength="51" fitness="72" creativity="84"/>
			</player>
			<player id="Matheus Nunes" name="Matheus Nunes" birthday="27-08-1998" positions="fb-cm-sm" nationality="po" number="27">
				<stats passing="72" tackling="69" shooting="66" crossing="69" heading="60" dribbling="71" speed="77" stamina="71" aggression="70" strength="67" fitness="73" creativity="71"/>
			</player>
			<player id="Omar Marmoush" name="Omar Marmoush" birthday="07-02-1999" positions="cf-am-wf" nationality="eg" number="7">
				<stats passing="77" tackling="33" shooting="83" crossing="68" heading="70" dribbling="83" speed="85" stamina="73" aggression="66" strength="68" fitness="76" creativity="76"/>
			</player>
			<player id="Nico González" name="Nico González" birthday="03-01-2002" positions="dm-cm" nationality="sp" number="14">
				<stats passing="74" tackling="70" shooting="66" crossing="67" heading="70" dribbling="69" speed="62" stamina="72" aggression="76" strength="70" fitness="69" creativity="72"/>
			</player>
			<player id="Rayan Aït-Nouri" name="Rayan Aït-Nouri" birthday="06-06-2001" positions="fb-sm" nationality="al" number="21">
				<stats passing="73" tackling="73" shooting="55" crossing="73" heading="65" dribbling="78" speed="79" stamina="73" aggression="66" strength="64" fitness="73" creativity="72"/>
			</player>
			<player id="Nathan Aké" name="Nathan Aké" birthday="18-02-1995" positions="cb-fb-sm" nationality="ne" number="6">
				<stats passing="74" tackling="80" shooting="56" crossing="65" heading="79" dribbling="72" speed="69" stamina="63" aggression="77" strength="73" fitness="67" creativity="69"/>
			</player>
			<player id="John Stones" name="John Stones" birthday="28-05-1994" positions="cb-fb" nationality="en" number="5">
				<stats passing="78" tackling="81" shooting="60" crossing="66" heading="80" dribbling="71" speed="62" stamina="54" aggression="77" strength="74" fitness="61" creativity="74"/>
			</player>
			<player id="Nico O'Reilly" name="Nico O'Reilly" birthday="21-03-2005" positions="fb-cm-am" nationality="en" number="33">
				<stats passing="65" tackling="62" shooting="61" crossing="64" heading="64" dribbling="65" speed="65" stamina="64" aggression="63" strength="62" fitness="64" creativity="65"/>
			</player>
			<player id="Kalvin Phillips" name="Kalvin Phillips" birthday="02-12-1995" positions="dm-cm" nationality="en" number="44">
				<stats passing="71" tackling="70" shooting="63" crossing="67" heading="65" dribbling="66" speed="51" stamina="55" aggression="73" strength="70" fitness="57" creativity="68"/>
			</player>
			<player id="Rico Lewis" name="Rico Lewis" birthday="21-11-2004" positions="fb-cm" nationality="en" number="82">
				<stats passing="74" tackling="71" shooting="57" crossing="70" heading="56" dribbling="77" speed="74" stamina="68" aggression="62" strength="53" fitness="66" creativity="72"/>
			</player>
			<player id="Jérémy Doku" name="Jérémy Doku" birthday="27-05-2002" positions="wf-sm" nationality="be" number="11">
				<stats passing="72" tackling="33" shooting="70" crossing="69" heading="57" dribbling="83" speed="88" stamina="64" aggression="58" strength="73" fitness="74" creativity="73"/>
			</player>
			<player id="Savinho" name="Savinho" birthday="10-04-2004" positions="wf-sm" nationality="br" number="26">
				<stats passing="82" tackling="33" shooting="75" crossing="83" heading="51" dribbling="87" speed="89" stamina="72" aggression="46" strength="53" fitness="74" creativity="82"/>
			</player>
			<player id="Mathis Cherki" name="Mathis Cherki" birthday="17-08-2003" positions="wf-sm-am" nationality="fr" number="10">
				<stats passing="81" tackling="25" shooting="76" crossing="78" heading="48" dribbling="85" speed="74" stamina="69" aggression="57" strength="68" fitness="70" creativity="83"/>
			</player>
			<player id="Rúben Dias" name="Rúben Dias" birthday="14-05-1997" positions="cb" nationality="po" number="3">
				<stats passing="76" tackling="84" shooting="46" crossing="58" heading="84" dribbling="68" speed="57" stamina="69" aggression="85" strength="81" fitness="69" creativity="66"/>
			</player>
			<player id="Abdukodir Khusanov" name="Abdukodir Khusanov" birthday="29-02-2004" positions="cb" nationality="uz" number="45">
				<stats passing="61" tackling="70" shooting="40" crossing="48" heading="71" dribbling="58" speed="76" stamina="58" aggression="71" strength="69" fitness="66" creativity="55"/>
			</player>
			<player id="Oscar Bobb" name="Oscar Bobb" birthday="12-07-2003" positions="wf-sm" nationality="no" number="52">
				<stats passing="73" tackling="33" shooting="66" crossing="70" heading="45" dribbling="77" speed="80" stamina="52" aggression="42" strength="43" fitness="58" creativity="74"/>
			</player>
			<player id="Stefan Ortega" name="Stefan Ortega" birthday="06-11-1992" positions="gk" nationality="ge" number="18">
				<stats catching="74" shotStopping="76" distribution="81" fitness="75" stamina="32"/>
			</player>
			<player id="Gianluigi Donnarumma" name="Gianluigi Donnarumma" birthday="25-02-1999" positions="gk" nationality="it" number="25">
				<stats catching="87" shotStopping="94" distribution="73" fitness="91" stamina="43"/>
			</player>
			<player id="James Trafford" name="James Trafford" birthday="10-10-2002" positions="gk" nationality="en" number="1">
				<stats catching="71" shotStopping="74" distribution="69" fitness="71" stamina="38"/>
			</player>
			<player id="Marcus Bettinelli" name="Marcus Bettinelli" birthday="24-05-1992" positions="gk" nationality="en" number="13">
				<stats catching="66" shotStopping="67" distribution="65" fitness="67" stamina="24"/>
			</player>
		</players>
	</club>
	<club shirtColor="0x000000" sleevesColor="0xFFFFFF" stripesType="none" scoreMultiplier="1" attackScore="A" defendScore="B">
		<name><![CDATA[Manchester United]]></name>
		<profile>90</profile>
		<players>
			<player id="Bruno Fernandes" name="Bruno Fernandes" birthday="08-09-1994" positions="am-cm" nationality="po" number="8">
				<stats passing="86" tackling="65" shooting="81" crossing="84" heading="64" dribbling="80" speed="65" stamina="86" aggression="76" strength="63" fitness="74" creativity="86"/>
			</player>
			<player id="Bryan Mbeumo" name="Bryan Mbeumo" birthday="07-08-1999" positions="wf-sm-cf" nationality="ca" number="19">
				<stats passing="75" tackling="46" shooting="79" crossing="78" heading="67" dribbling="80" speed="84" stamina="79" aggression="68" strength="70" fitness="79" creativity="75"/>
			</player>
			<player id="Matheus Cunha" name="Matheus Cunha" birthday="27-05-1999" positions="am-wf-cf" nationality="br" number="10">
				<stats passing="77" tackling="43" shooting="81" crossing="77" heading="70" dribbling="79" speed="74" stamina="77" aggression="67" strength="71" fitness="74" creativity="78"/>
			</player>
			<player id="Lisandro Martínez" name="Lisandro Martínez" birthday="18-01-1998" positions="cb" nationality="ar" number="6">
				<stats passing="71" tackling="75" shooting="58" crossing="68" heading="74" dribbling="69" speed="62" stamina="67" aggression="81" strength="72" fitness="66" creativity="69"/>
			</player>
			<player id="Diogo Dalot" name="Diogo Dalot" birthday="18-03-1999" positions="fb-sm" nationality="po" number="2">
				<stats passing="68" tackling="69" shooting="60" crossing="68" heading="70" dribbling="69" speed="77" stamina="72" aggression="72" strength="68" fitness="72" creativity="69"/>
			</player>
			<player id="Noussair Mazraoui" name="Noussair Mazraoui" birthday="14-11-1997" positions="fb-cb-sm" nationality="mo" number="3">
				<stats passing="73" tackling="72" shooting="64" crossing="72" heading="69" dribbling="73" speed="70" stamina="70" aggression="67" strength="66" fitness="69" creativity="72"/>
			</player>
			<player id="Kobbie Mainoo" name="Kobbie Mainoo" birthday="19-04-2005" positions="cm-dm" nationality="en" number="37">
				<stats passing="71" tackling="67" shooting="64" crossing="64" heading="63" dribbling="73" speed="61" stamina="68" aggression="67" strength="68" fitness="65" creativity="70"/>
			</player>
			<player id="Luke Shaw" name="Luke Shaw" birthday="12-07-1995" positions="cb-fb-sm" nationality="en" number="23">
				<stats passing="73" tackling="74" shooting="58" crossing="75" heading="74" dribbling="69" speed="65" stamina="52" aggression="78" strength="73" fitness="60" creativity="73"/>
			</player>
			<player id="Mason Mount" name="Mason Mount" birthday="10-01-1999" positions="am-cm-wf" nationality="en" number="7">
				<stats passing="75" tackling="60" shooting="73" crossing="76" heading="56" dribbling="73" speed="64" stamina="58" aggression="66" strength="57" fitness="59" creativity="75"/>
			</player>
			<player id="Casemiro" name="Casemiro" birthday="23-02-1992" positions="dm-cm" nationality="br" number="18">
				<stats passing="78" tackling="80" shooting="74" crossing="72" heading="79" dribbling="67" speed="35" stamina="56" aggression="86" strength="76" fitness="54" creativity="76"/>
			</player>
			<player id="Manuel Ugarte" name="Manuel Ugarte" birthday="11-04-2001" positions="dm-cm" nationality="ur" number="25">
				<stats passing="73" tackling="76" shooting="64" crossing="65" heading="63" dribbling="72" speed="59" stamina="67" aggression="80" strength="70" fitness="65" creativity="71"/>
			</player>
			<player id="Amad" name="Amad" birthday="11-07-2002" positions="am-wf-sm-cm" nationality="cô" number="16">
				<stats passing="76" tackling="55" shooting="75" crossing="76" heading="54" dribbling="83" speed="85" stamina="69" aggression="46" strength="53" fitness="70" creativity="77"/>
			</player>
			<player id="Benjamin Šeško" name="Benjamin Šeško" birthday="31-05-2003" positions="cf" nationality="sl" number="30">
				<stats passing="65" tackling="41" shooting="74" crossing="56" heading="77" dribbling="71" speed="77" stamina="76" aggression="58" strength="75" fitness="76" creativity="62"/>
			</player>
			<player id="Joshua Zirkzee" name="Joshua Zirkzee" birthday="22-05-2001" positions="cf-am" nationality="ne" number="11">
				<stats passing="71" tackling="38" shooting="70" crossing="61" heading="70" dribbling="73" speed="65" stamina="64" aggression="57" strength="73" fitness="68" creativity="71"/>
			</player>
			<player id="Patrick Dorgu" name="Patrick Dorgu" birthday="26-10-2004" positions="fb-sm" nationality="de" number="13">
				<stats passing="62" tackling="62" shooting="55" crossing="63" heading="64" dribbling="66" speed="76" stamina="67" aggression="59" strength="67" fitness="69" creativity="62"/>
			</player>
			<player id="Matthijs de Ligt" name="Matthijs de Ligt" birthday="12-08-1999" positions="cb" nationality="ne" number="4">
				<stats passing="67" tackling="77" shooting="60" crossing="53" heading="81" dribbling="63" speed="57" stamina="62" aggression="80" strength="81" fitness="64" creativity="55"/>
			</player>
			<player id="Tyrell Malacia" name="Tyrell Malacia" birthday="17-08-1999" positions="fb-sm" nationality="ne" number="12">
				<stats passing="63" tackling="68" shooting="52" crossing="61" heading="61" dribbling="69" speed="70" stamina="64" aggression="70" strength="66" fitness="66" creativity="60"/>
			</player>
			<player id="Jacob Maguire" name="Jacob Maguire" birthday="05-03-1993" positions="cb" nationality="en" number="5">
				<stats passing="75" tackling="77" shooting="59" crossing="60" heading="81" dribbling="60" speed="34" stamina="63" aggression="82" strength="77" fitness="57" creativity="70"/>
			</player>
			<player id="Leny Yoro" name="Leny Yoro" birthday="13-11-2005" positions="cb" nationality="fr" number="15">
				<stats passing="65" tackling="76" shooting="44" crossing="49" heading="73" dribbling="61" speed="65" stamina="65" aggression="70" strength="70" fitness="65" creativity="57"/>
			</player>
			<player id="Diego León" name="Diego León" birthday="03-04-2007" positions="fb-sm" nationality="pa" number="35">
				<stats passing="50" tackling="52" shooting="48" crossing="49" heading="54" dribbling="58" speed="72" stamina="59" aggression="44" strength="57" fitness="63" creativity="50"/>
			</player>
			<player id="Chidozie Obi" name="Chidozie Obi" birthday="29-11-2007" positions="cf" nationality="de" number="32">
				<stats passing="51" tackling="26" shooting="58" crossing="50" heading="59" dribbling="57" speed="64" stamina="54" aggression="37" strength="60" fitness="60" creativity="51"/>
			</player>
			<player id="Ayden Heaven" name="Ayden Heaven" birthday="22-09-2006" positions="cb-fb" nationality="en" number="26">
				<stats passing="53" tackling="62" shooting="31" crossing="41" heading="64" dribbling="53" speed="62" stamina="55" aggression="63" strength="64" fitness="60" creativity="49"/>
			</player>
			<player id="Tyler Fredricson" name="Tyler Fredricson" birthday="23-02-2005" positions="cb" nationality="en" number="33">
				<stats passing="47" tackling="56" shooting="29" crossing="37" heading="59" dribbling="49" speed="56" stamina="50" aggression="59" strength="60" fitness="54" creativity="43"/>
			</player>
			<player id="Thomas Heaton" name="Thomas Heaton" birthday="15-04-1986" positions="gk" nationality="en" number="22">
				<stats catching="64" shotStopping="65" distribution="63" fitness="66" stamina="19"/>
			</player>
			<player id="Altay Bayındır" name="Altay Bayındır" birthday="14-04-1998" positions="gk" nationality="tü" number="1">
				<stats catching="70" shotStopping="74" distribution="68" fitness="73" stamina="30"/>
			</player>
			<player id="Senne Lammens" name="Senne Lammens" birthday="07-07-2002" positions="gk" nationality="be" number="31">
				<stats catching="77" shotStopping="78" distribution="71" fitness="79" stamina="29"/>
			</player>
		</players>
	</club>
	
	<club shirtColor="0x000000" sleevesColor="0xFFFFFF" stripesType="none" scoreMultiplier="1" attackScore="A" defendScore="B">
		<name><![CDATA[Newcastle United]]></name>
		<profile>90</profile>
		<players>
			<player id="Sandro Tonali" name="Sandro Tonali" birthday="08-05-2000" positions="dm-cm" nationality="it" number="8">
				<stats passing="79" tackling="78" shooting="72" crossing="74" heading="73" dribbling="76" speed="74" stamina="77" aggression="79" strength="77" fitness="76" creativity="76"/>
			</player>
			<player id="Bruno Guimarães" name="Bruno Guimarães" birthday="16-11-1997" positions="cm-dm" nationality="br" number="39">
				<stats passing="82" tackling="76" shooting="72" crossing="76" heading="68" dribbling="78" speed="62" stamina="82" aggression="79" strength="72" fitness="73" creativity="81"/>
			</player>
			<player id="Joelinton" name="Joelinton" birthday="14-08-1996" positions="cm-wf-sm" nationality="br" number="7">
				<stats passing="73" tackling="73" shooting="67" crossing="66" heading="77" dribbling="70" speed="65" stamina="77" aggression="80" strength="77" fitness="73" creativity="70"/>
			</player>
			<player id="Kieran Trippier" name="Kieran Trippier" birthday="19-09-1990" positions="fb-sm" nationality="en" number="2">
				<stats passing="75" tackling="73" shooting="63" crossing="80" heading="70" dribbling="71" speed="61" stamina="68" aggression="70" strength="65" fitness="64" creativity="75"/>
			</player>
			<player id="Fabian Schär" name="Fabian Schär" birthday="20-12-1991" positions="cb" nationality="sw" number="5">
				<stats passing="77" tackling="80" shooting="67" crossing="68" heading="77" dribbling="69" speed="48" stamina="73" aggression="77" strength="74" fitness="65" creativity="74"/>
			</player>
			<player id="Anthony Gordon" name="Anthony Gordon" birthday="24-02-2001" positions="wf-sm" nationality="en" number="10">
				<stats passing="74" tackling="50" shooting="76" crossing="76" heading="63" dribbling="78" speed="86" stamina="79" aggression="70" strength="62" fitness="77" creativity="76"/>
			</player>
			<player id="Lewis Hall" name="Lewis Hall" birthday="08-09-2004" positions="fb" nationality="en" number="3">
				<stats passing="74" tackling="74" shooting="62" crossing="77" heading="61" dribbling="76" speed="73" stamina="74" aggression="59" strength="59" fitness="70" creativity="74"/>
			</player>
			<player id="Jacob Murphy" name="Jacob Murphy" birthday="24-02-1995" positions="wf-sm" nationality="en" number="23">
				<stats passing="73" tackling="61" shooting="74" crossing="77" heading="55" dribbling="75" speed="77" stamina="76" aggression="57" strength="66" fitness="74" creativity="75"/>
			</player>
			<player id="Jacob Ramsey" name="Jacob Ramsey" birthday="21-05-2001" positions="sm-wf" nationality="en" number="41">
				<stats passing="70" tackling="65" shooting="71" crossing="67" heading="60" dribbling="74" speed="71" stamina="72" aggression="66" strength="66" fitness="70" creativity="69"/>
			</player>
			<player id="Joseph Willock" name="Joseph Willock" birthday="20-08-1999" positions="cm-am" nationality="en" number="28">
				<stats passing="70" tackling="65" shooting="66" crossing="64" heading="64" dribbling="70" speed="67" stamina="63" aggression="63" strength="60" fitness="65" creativity="70"/>
			</player>
			<player id="Valentino Livramento" name="Valentino Livramento" birthday="12-11-2002" positions="fb-sm" nationality="en" number="21">
				<stats passing="68" tackling="73" shooting="53" crossing="71" heading="62" dribbling="73" speed="76" stamina="74" aggression="69" strength="68" fitness="73" creativity="67"/>
			</player>
			<player id="Anthony Elanga" name="Anthony Elanga" birthday="27-04-2002" positions="wf-sm" nationality="sw" number="20">
				<stats passing="72" tackling="38" shooting="71" crossing="74" heading="68" dribbling="78" speed="88" stamina="71" aggression="54" strength="70" fitness="76" creativity="73"/>
			</player>
			<player id="Harvey Barnes" name="Harvey Barnes" birthday="09-12-1997" positions="wf-sm" nationality="en" number="11">
				<stats passing="73" tackling="44" shooting="77" crossing="73" heading="56" dribbling="77" speed="79" stamina="71" aggression="54" strength="68" fitness="73" creativity="75"/>
			</player>
			<player id="Yoane Wissa" name="Yoane Wissa" birthday="03-09-1996" positions="cf" nationality="co" number="9">
				<stats passing="70" tackling="29" shooting="79" crossing="67" heading="75" dribbling="76" speed="82" stamina="73" aggression="62" strength="68" fitness="75" creativity="68"/>
			</player>
			<player id="Malick Thiaw" name="Malick Thiaw" birthday="08-08-2001" positions="cb" nationality="ge" number="12">
				<stats passing="69" tackling="70" shooting="46" crossing="56" heading="74" dribbling="64" speed="65" stamina="67" aggression="69" strength="70" fitness="68" creativity="63"/>
			</player>
			<player id="Emil Krafth" name="Emil Krafth" birthday="02-08-1994" positions="cb-fb-sm" nationality="sw" number="17">
				<stats passing="67" tackling="71" shooting="58" crossing="66" heading="66" dribbling="66" speed="50" stamina="55" aggression="67" strength="67" fitness="56" creativity="64"/>
			</player>
			<player id="Lewis Miley" name="Lewis Miley" birthday="01-05-2006" positions="cm" nationality="en" number="67">
				<stats passing="68" tackling="60" shooting="59" crossing="62" heading="57" dribbling="66" speed="59" stamina="64" aggression="51" strength="62" fitness="63" creativity="68"/>
			</player>
			<player id="Nick Woltemade" name="Nick Woltemade" birthday="14-02-2002" positions="cf-am" nationality="ge" number="27">
				<stats passing="72" tackling="41" shooting="76" crossing="55" heading="76" dribbling="75" speed="65" stamina="69" aggression="60" strength="75" fitness="70" creativity="70"/>
			</player>
			<player id="Sven Botman" name="Sven Botman" birthday="12-01-2000" positions="cb" nationality="ne" number="4">
				<stats passing="72" tackling="81" shooting="43" crossing="52" heading="81" dribbling="62" speed="54" stamina="63" aggression="82" strength="78" fitness="65" creativity="63"/>
			</player>
			<player id="Daniel Burn" name="Daniel Burn" birthday="09-05-1992" positions="cb" nationality="en" number="33">
				<stats passing="69" tackling="77" shooting="43" crossing="63" heading="76" dribbling="59" speed="40" stamina="72" aggression="82" strength="76" fitness="63" creativity="62"/>
			</player>
			<player id="Harrison Ashby" name="Harrison Ashby" birthday="14-11-2001" positions="fb-sm" nationality="sc" number="30">
				<stats passing="50" tackling="52" shooting="42" crossing="52" heading="52" dribbling="54" speed="67" stamina="62" aggression="53" strength="55" fitness="61" creativity="48"/>
			</player>
			<player id="Alex Murphy" name="Alex Murphy" birthday="25-06-2004" positions="fb-cb-sm" nationality="re" number="37">
				<stats passing="50" tackling="57" shooting="39" crossing="48" heading="59" dribbling="51" speed="57" stamina="58" aggression="62" strength="63" fitness="59" creativity="45"/>
			</player>
			<player id="William Osula" name="William Osula" birthday="04-08-2003" positions="cf" nationality="de" number="18">
				<stats passing="55" tackling="22" shooting="62" crossing="49" heading="64" dribbling="63" speed="68" stamina="55" aggression="46" strength="65" fitness="62" creativity="54"/>
			</player>
			<player id="Jamaal Lascelles" name="Jamaal Lascelles" birthday="11-11-1993" positions="cb" nationality="en" number="6">
				<stats passing="58" tackling="73" shooting="39" crossing="47" heading="79" dribbling="51" speed="37" stamina="39" aggression="79" strength="77" fitness="48" creativity="47"/>
			</player>
			<player id="Aaron Ramsdale" name="Aaron Ramsdale" birthday="14-05-1998" positions="gk" nationality="en" number="32">
				<stats catching="71" shotStopping="73" distribution="75" fitness="69" stamina="38"/>
			</player>
			<player id="Nicholas Pope" name="Nicholas Pope" birthday="19-04-1992" positions="gk" nationality="en" number="1">
				<stats catching="81" shotStopping="82" distribution="68" fitness="78" stamina="35"/>
			</player>
			<player id="John Ruddy" name="John Ruddy" birthday="24-10-1986" positions="gk" nationality="en" number="26">
				<stats catching="65" shotStopping="63" distribution="62" fitness="64" stamina="32"/>
			</player>
			<player id="Mark Gillespie" name="Mark Gillespie" birthday="27-03-1992" positions="gk" nationality="en" number="29">
				<stats catching="58" shotStopping="60" distribution="57" fitness="58" stamina="19"/>
			</player>
		</players>
	</club>
	<club shirtColor="0x000000" sleevesColor="0xFFFFFF" stripesType="none" scoreMultiplier="1" attackScore="A" defendScore="B">
		<name><![CDATA[Nottingham Forest]]></name>
		<profile>90</profile>
		<players>
			<player id="Douglas Luiz" name="Douglas Luiz" birthday="09-05-1998" positions="cm-dm" nationality="br" number="12">
				<stats passing="75" tackling="70" shooting="70" crossing="75" heading="61" dribbling="73" speed="62" stamina="68" aggression="69" strength="63" fitness="65" creativity="76"/>
			</player>
			<player id="Elliot Anderson" name="Elliot Anderson" birthday="06-11-2002" positions="dm-cm" nationality="en" number="8">
				<stats passing="72" tackling="70" shooting="63" crossing="72" heading="70" dribbling="73" speed="64" stamina="76" aggression="69" strength="68" fitness="70" creativity="72"/>
			</player>
			<player id="Morgan Gibbs-White" name="Morgan Gibbs-White" birthday="27-01-2000" positions="am-cf" nationality="en" number="10">
				<stats passing="79" tackling="57" shooting="73" crossing="77" heading="63" dribbling="78" speed="71" stamina="74" aggression="65" strength="67" fitness="71" creativity="79"/>
			</player>
			<player id="Oleksandr Zinchenko" name="Oleksandr Zinchenko" birthday="15-12-1996" positions="fb" nationality="uk" number="35">
				<stats passing="74" tackling="72" shooting="66" crossing="76" heading="62" dribbling="74" speed="60" stamina="64" aggression="68" strength="56" fitness="61" creativity="75"/>
			</player>
			<player id="Temitayo Aina" name="Temitayo Aina" birthday="08-10-1996" positions="fb-sm" nationality="ni" number="34">
				<stats passing="67" tackling="72" shooting="61" crossing="67" heading="69" dribbling="69" speed="81" stamina="71" aggression="67" strength="70" fitness="73" creativity="65"/>
			</player>
			<player id="Dan Ndoye" name="Dan Ndoye" birthday="25-10-2000" positions="sm-wf" nationality="sw" number="14">
				<stats passing="68" tackling="62" shooting="70" crossing="70" heading="59" dribbling="76" speed="85" stamina="75" aggression="58" strength="64" fitness="76" creativity="68"/>
			</player>
			<player id="Nicolás Domínguez" name="Nicolás Domínguez" birthday="28-06-1998" positions="dm-cm" nationality="ar" number="16">
				<stats passing="71" tackling="71" shooting="62" crossing="62" heading="66" dribbling="71" speed="64" stamina="80" aggression="77" strength="66" fitness="71" creativity="69"/>
			</player>
			<player id="Callum Hudson-Odoi" name="Callum Hudson-Odoi" birthday="07-11-2000" positions="sm-wf" nationality="en" number="7">
				<stats passing="71" tackling="49" shooting="72" crossing="73" heading="57" dribbling="76" speed="78" stamina="69" aggression="52" strength="62" fitness="71" creativity="73"/>
			</player>
			<player id="Murillo" name="Murillo" birthday="04-07-2002" positions="cb" nationality="br" number="5">
				<stats passing="69" tackling="77" shooting="48" crossing="55" heading="79" dribbling="65" speed="74" stamina="66" aggression="76" strength="79" fitness="71" creativity="62"/>
			</player>
			<player id="Ibrahim Sangaré" name="Ibrahim Sangaré" birthday="02-12-1997" positions="dm-cm" nationality="cô" number="6">
				<stats passing="70" tackling="73" shooting="63" crossing="64" heading="71" dribbling="65" speed="54" stamina="63" aggression="72" strength="76" fitness="63" creativity="68"/>
			</player>
			<player id="Neco Williams" name="Neco Williams" birthday="13-04-2001" positions="fb-sm" nationality="wa" number="3">
				<stats passing="69" tackling="74" shooting="52" crossing="70" heading="67" dribbling="71" speed="69" stamina="70" aggression="70" strength="65" fitness="68" creativity="67"/>
			</player>
			<player id="Omari Hutchinson" name="Omari Hutchinson" birthday="29-10-2003" positions="am-sm-cm" nationality="en" number="21">
				<stats passing="68" tackling="53" shooting="69" crossing="65" heading="51" dribbling="74" speed="75" stamina="69" aggression="54" strength="54" fitness="67" creativity="68"/>
			</player>
			<player id="Christopher Wood" name="Christopher Wood" birthday="07-12-1991" positions="cf" nationality="ne" number="11">
				<stats passing="74" tackling="38" shooting="82" crossing="61" heading="86" dribbling="69" speed="53" stamina="68" aggression="75" strength="78" fitness="67" creativity="71"/>
			</player>
			<player id="Ryan Yates" name="Ryan Yates" birthday="21-11-1997" positions="dm-cm" nationality="en" number="22">
				<stats passing="68" tackling="72" shooting="60" crossing="61" heading="72" dribbling="62" speed="47" stamina="75" aggression="80" strength="71" fitness="65" creativity="65"/>
			</player>
			<player id="Arnaud Kalimuendo" name="Arnaud Kalimuendo" birthday="20-01-2002" positions="cf" nationality="fr" number="15">
				<stats passing="65" tackling="27" shooting="75" crossing="58" heading="71" dribbling="74" speed="76" stamina="70" aggression="58" strength="71" fitness="71" creativity="64"/>
			</player>
			<player id="Dilane Bakwa" name="Dilane Bakwa" birthday="26-08-2002" positions="sm-wf" nationality="fr" number="29">
				<stats passing="71" tackling="31" shooting="71" crossing="72" heading="55" dribbling="77" speed="85" stamina="71" aggression="49" strength="67" fitness="75" creativity="73"/>
			</player>
			<player id="Igor Jesus" name="Igor Jesus" birthday="25-02-2001" positions="cf" nationality="br" number="19">
				<stats passing="65" tackling="34" shooting="72" crossing="56" heading="76" dribbling="67" speed="65" stamina="67" aggression="66" strength="72" fitness="68" creativity="64"/>
			</player>
			<player id="Nikola Milenković" name="Nikola Milenković" birthday="12-10-1997" positions="cb" nationality="se" number="31">
				<stats passing="67" tackling="81" shooting="49" crossing="60" heading="83" dribbling="58" speed="55" stamina="71" aggression="82" strength="77" fitness="67" creativity="58"/>
			</player>
			<player id="James McAtee" name="James McAtee" birthday="18-10-2002" positions="sm-cm-wf" nationality="en" number="24">
				<stats passing="69" tackling="42" shooting="67" crossing="68" heading="50" dribbling="73" speed="70" stamina="63" aggression="45" strength="60" fitness="65" creativity="69"/>
			</player>
			<player id="Taiwo Awoniyi" name="Taiwo Awoniyi" birthday="12-08-1997" positions="cf" nationality="ni" number="9">
				<stats passing="60" tackling="30" shooting="69" crossing="54" heading="76" dribbling="63" speed="65" stamina="54" aggression="69" strength="78" fitness="63" creativity="56"/>
			</player>
			<player id="Jair Cunha" name="Jair Cunha" birthday="07-03-2005" positions="cb" nationality="br" number="23">
				<stats passing="58" tackling="66" shooting="39" crossing="50" heading="72" dribbling="52" speed="60" stamina="62" aggression="68" strength="71" fitness="63" creativity="53"/>
			</player>
			<player id="Nicolò Savona" name="Nicolò Savona" birthday="19-03-2003" positions="fb-sm" nationality="it" number="37">
				<stats passing="59" tackling="67" shooting="46" crossing="58" heading="61" dribbling="59" speed="65" stamina="64" aggression="64" strength="63" fitness="64" creativity="48"/>
			</player>
			<player id="Morato" name="Morato" birthday="30-06-2001" positions="cb-fb-sm" nationality="br" number="4">
				<stats passing="59" tackling="71" shooting="40" crossing="53" heading="74" dribbling="55" speed="50" stamina="59" aggression="75" strength="75" fitness="60" creativity="53"/>
			</player>
			<player id="Willy-Arnaud Boly" name="Willy-Arnaud Boly" birthday="03-02-1991" positions="cb" nationality="cô" number="30">
				<stats passing="67" tackling="74" shooting="43" crossing="54" heading="75" dribbling="55" speed="34" stamina="39" aggression="76" strength="77" fitness="47" creativity="60"/>
			</player>
			<player id="Zach Abbott" name="Zach Abbott" birthday="13-05-2006" positions="cb" nationality="en" number="44">
				<stats passing="48" tackling="52" shooting="31" crossing="34" heading="52" dribbling="44" speed="50" stamina="49" aggression="53" strength="52" fitness="50" creativity="42"/>
			</player>
			<player id="Matz Sels" name="Matz Sels" birthday="26-02-1992" positions="gk" nationality="be" number="26">
				<stats catching="81" shotStopping="84" distribution="80" fitness="84" stamina="26"/>
			</player>
			<player id="Angus Gunn" name="Angus Gunn" birthday="22-01-1996" positions="gk" nationality="sc" number="18">
				<stats catching="68" shotStopping="70" distribution="67" fitness="67" stamina="30"/>
			</player>
			<player id="John Victor" name="John Victor" birthday="13-02-1996" positions="gk" nationality="br" number="13">
				<stats catching="66" shotStopping="74" distribution="65" fitness="67" stamina="19"/>
			</player>
		</players>
	</club>
	<club shirtColor="0x000000" sleevesColor="0xFFFFFF" stripesType="none" scoreMultiplier="1" attackScore="A" defendScore="B">
		<name><![CDATA[Sunderland]]></name>
		<profile>90</profile>
		<players>
			<player id="Granit Xhaka" name="Granit Xhaka" birthday="27-09-1992" positions="dm-cm" nationality="sw" number="34">
				<stats passing="86" tackling="77" shooting="76" crossing="80" heading="73" dribbling="72" speed="46" stamina="80" aggression="85" strength="74" fitness="67" creativity="83"/>
			</player>
			<player id="Fuka-Arthur Masuaku" name="Fuka-Arthur Masuaku" birthday="07-11-1993" positions="fb-sm" nationality="co" number="26">
				<stats passing="63" tackling="60" shooting="56" crossing="66" heading="61" dribbling="67" speed="68" stamina="71" aggression="63" strength="68" fitness="69" creativity="64"/>
			</player>
			<player id="Reinildo" name="Reinildo" birthday="21-01-1994" positions="fb-cb-sm" nationality="mo" number="17">
				<stats passing="65" tackling="72" shooting="55" crossing="66" heading="74" dribbling="69" speed="75" stamina="74" aggression="73" strength="70" fitness="73" creativity="63"/>
			</player>
			<player id="Mouhamadou Diarra" name="Mouhamadou Diarra" birthday="03-01-2004" positions="cm-am" nationality="se" number="19">
				<stats passing="72" tackling="67" shooting="65" crossing="60" heading="61" dribbling="71" speed="65" stamina="70" aggression="64" strength="64" fitness="67" creativity="71"/>
			</player>
			<player id="Luke O'Nien" name="Luke O'Nien" birthday="21-11-1994" positions="cb" nationality="en" number="13">
				<stats passing="56" tackling="58" shooting="50" crossing="52" heading="64" dribbling="58" speed="60" stamina="74" aggression="67" strength="64" fitness="67" creativity="54"/>
			</player>
			<player id="Lutsharel Geertruida" name="Lutsharel Geertruida" birthday="18-07-2000" positions="cb-fb" nationality="ne" number="6">
				<stats passing="67" tackling="70" shooting="56" crossing="62" heading="73" dribbling="67" speed="65" stamina="68" aggression="67" strength="71" fitness="67" creativity="64"/>
			</player>
			<player id="Noah Sadiki" name="Noah Sadiki" birthday="17-12-2004" positions="cm-dm-am" nationality="co" number="27">
				<stats passing="66" tackling="62" shooting="58" crossing="54" heading="58" dribbling="68" speed="69" stamina="73" aggression="65" strength="65" fitness="70" creativity="63"/>
			</player>
			<player id="Daniel Neil" name="Daniel Neil" birthday="13-12-2001" positions="dm-cm" nationality="en" number="4">
				<stats passing="63" tackling="60" shooting="57" crossing="54" heading="61" dribbling="64" speed="64" stamina="77" aggression="66" strength="63" fitness="70" creativity="62"/>
			</player>
			<player id="Bertrand Traoré" name="Bertrand Traoré" birthday="06-09-1995" positions="wf-sm" nationality="bu" number="25">
				<stats passing="68" tackling="43" shooting="67" crossing="68" heading="63" dribbling="73" speed="69" stamina="61" aggression="55" strength="60" fitness="65" creativity="69"/>
			</player>
			<player id="Nordi Mukiele" name="Nordi Mukiele" birthday="01-11-1997" positions="fb-cb-sm" nationality="fr" number="20">
				<stats passing="67" tackling="78" shooting="52" crossing="67" heading="73" dribbling="68" speed="69" stamina="66" aggression="78" strength="74" fitness="69" creativity="65"/>
			</player>
			<player id="Omar Alderete" name="Omar Alderete" birthday="26-12-1996" positions="cb" nationality="pa" number="15">
				<stats passing="62" tackling="73" shooting="59" crossing="56" heading="75" dribbling="64" speed="56" stamina="66" aggression="74" strength="72" fitness="65" creativity="56"/>
			</player>
			<player id="Enzo Le Fée" name="Enzo Le Fée" birthday="03-02-2000" positions="cm-sm-am-wf" nationality="fr" number="28">
				<stats passing="76" tackling="62" shooting="63" crossing="70" heading="48" dribbling="77" speed="61" stamina="66" aggression="54" strength="56" fitness="61" creativity="75"/>
			</player>
			<player id="Dennis Cirkin" name="Dennis Cirkin" birthday="06-04-2002" positions="fb-sm" nationality="en" number="3">
				<stats passing="61" tackling="63" shooting="54" crossing="60" heading="61" dribbling="63" speed="73" stamina="68" aggression="59" strength="56" fitness="66" creativity="58"/>
			</player>
			<player id="Christopher Rigg" name="Christopher Rigg" birthday="18-06-2007" positions="am-cm" nationality="en" number="11">
				<stats passing="64" tackling="56" shooting="58" crossing="61" heading="48" dribbling="66" speed="62" stamina="66" aggression="52" strength="55" fitness="62" creativity="63"/>
			</player>
			<player id="Brian Brobbey" name="Brian Brobbey" birthday="01-02-2002" positions="cf" nationality="ne" number="9">
				<stats passing="63" tackling="29" shooting="70" crossing="44" heading="76" dribbling="69" speed="78" stamina="62" aggression="65" strength="85" fitness="71" creativity="56"/>
			</player>
			<player id="Jay Matete" name="Jay Matete" birthday="11-02-2001" positions="cm-dm" nationality="en" number="48">
				<stats passing="53" tackling="53" shooting="47" crossing="48" heading="49" dribbling="59" speed="61" stamina="61" aggression="63" strength="52" fitness="59" creativity="52"/>
			</player>
			<player id="Trai Hume" name="Trai Hume" birthday="18-03-2002" positions="fb-cb" nationality="no" number="32">
				<stats passing="57" tackling="65" shooting="39" crossing="58" heading="69" dribbling="62" speed="73" stamina="73" aggression="72" strength="69" fitness="72" creativity="55"/>
			</player>
			<player id="Wilson Isidor" name="Wilson Isidor" birthday="27-08-2000" positions="cf" nationality="fr" number="18">
				<stats passing="58" tackling="29" shooting="64" crossing="53" heading="66" dribbling="63" speed="73" stamina="61" aggression="61" strength="65" fitness="66" creativity="58"/>
			</player>
			<player id="Simon Adingra" name="Simon Adingra" birthday="01-01-2002" positions="sm-wf" nationality="cô" number="24">
				<stats passing="72" tackling="33" shooting="71" crossing="69" heading="43" dribbling="79" speed="87" stamina="68" aggression="46" strength="52" fitness="70" creativity="71"/>
			</player>
			<player id="Eliezer Mayenda" name="Eliezer Mayenda" birthday="08-05-2005" positions="cf-sm-wf" nationality="sp" number="12">
				<stats passing="57" tackling="30" shooting="62" crossing="53" heading="63" dribbling="62" speed="76" stamina="66" aggression="52" strength="63" fitness="68" creativity="55"/>
			</player>
			<player id="Timothée Pembélé" name="Timothée Pembélé" birthday="09-09-2002" positions="fb-cb-sm" nationality="fr" number="40">
				<stats passing="60" tackling="60" shooting="48" crossing="58" heading="60" dribbling="64" speed="71" stamina="60" aggression="55" strength="57" fitness="63" creativity="58"/>
			</player>
			<player id="Chemsdine Talbi" name="Chemsdine Talbi" birthday="09-05-2005" positions="sm-wf" nationality="mo" number="7">
				<stats passing="61" tackling="44" shooting="59" crossing="66" heading="46" dribbling="74" speed="86" stamina="70" aggression="43" strength="57" fitness="72" creativity="65"/>
			</player>
			<player id="Abdoullah Ba" name="Abdoullah Ba" birthday="31-07-2003" positions="sm-wf" nationality="fr" number="46">
				<stats passing="55" tackling="50" shooting="52" crossing="53" heading="51" dribbling="59" speed="64" stamina="63" aggression="52" strength="56" fitness="61" creativity="56"/>
			</player>
			<player id="Romaine Mundle" name="Romaine Mundle" birthday="24-04-2003" positions="sm-wf" nationality="en" number="14">
				<stats passing="61" tackling="39" shooting="64" crossing="62" heading="49" dribbling="69" speed="77" stamina="64" aggression="47" strength="56" fitness="66" creativity="62"/>
			</player>
			<player id="Ian Poveda" name="Ian Poveda" birthday="09-02-2000" positions="sm-am-wf" nationality="co" number="49">
				<stats passing="62" tackling="36" shooting="58" crossing="62" heading="43" dribbling="73" speed="76" stamina="58" aggression="43" strength="59" fitness="64" creativity="63"/>
			</player>
			<player id="Daniel Ballard" name="Daniel Ballard" birthday="22-09-1999" positions="cb" nationality="no" number="5">
				<stats passing="57" tackling="66" shooting="32" crossing="38" heading="71" dribbling="51" speed="53" stamina="61" aggression="71" strength="73" fitness="62" creativity="52"/>
			</player>
			<player id="Ajibola Alese" name="Ajibola Alese" birthday="17-01-2001" positions="fb-cb" nationality="en" number="42">
				<stats passing="49" tackling="59" shooting="34" crossing="46" heading="63" dribbling="53" speed="66" stamina="59" aggression="59" strength="67" fitness="63" creativity="43"/>
			</player>
			<player id="Leo Hjelde" name="Leo Hjelde" birthday="26-08-2003" positions="fb-cb-sm" nationality="no" number="33">
				<stats passing="54" tackling="61" shooting="34" crossing="52" heading="64" dribbling="54" speed="61" stamina="52" aggression="59" strength="63" fitness="59" creativity="49"/>
			</player>
			<player id="Harrison Jones" name="Harrison Jones" birthday="25-12-2004" positions="am-cm" nationality="en" number="50">
				<stats passing="53" tackling="35" shooting="50" crossing="51" heading="38" dribbling="58" speed="63" stamina="50" aggression="38" strength="46" fitness="53" creativity="53"/>
			</player>
			<player id="Joseph Anderson" name="Joseph Anderson" birthday="06-02-2001" positions="cb" nationality="en" number="45">
				<stats passing="47" tackling="57" shooting="35" crossing="42" heading="58" dribbling="45" speed="47" stamina="46" aggression="63" strength="59" fitness="49" creativity="41"/>
			</player>
			<player id="Ahmed Abdullahi" name="Ahmed Abdullahi" birthday="19-06-2004" positions="cf" nationality="ni" number="29">
				<stats passing="40" tackling="17" shooting="51" crossing="36" heading="49" dribbling="54" speed="71" stamina="47" aggression="37" strength="55" fitness="57" creativity="39"/>
			</player>
			<player id="Zak Johnson" name="Zak Johnson" birthday="30-07-2004" positions="cb" nationality="en" number="41">
				<stats passing="33" tackling="46" shooting="25" crossing="33" heading="51" dribbling="44" speed="49" stamina="51" aggression="46" strength="57" fitness="52" creativity="31"/>
			</player>
			<player id="Simon Moore" name="Simon Moore" birthday="19-05-1990" positions="gk" nationality="en" number="21">
				<stats catching="59" shotStopping="61" distribution="62" fitness="58" stamina="33"/>
			</player>
			<player id="Anthony Patterson" name="Anthony Patterson" birthday="10-05-2000" positions="gk" nationality="en" number="1">
				<stats catching="69" shotStopping="72" distribution="70" fitness="68" stamina="29"/>
			</player>
			<player id="Robin Roefs" name="Robin Roefs" birthday="17-01-2003" positions="gk" nationality="ne" number="22">
				<stats catching="74" shotStopping="76" distribution="68" fitness="70" stamina="23"/>
			</player>
			<player id="Blondy Nna Noukeu" name="Blondy Nna Noukeu" birthday="31-05-2001" positions="gk" nationality="ca" number="16">
				<stats catching="50" shotStopping="55" distribution="50" fitness="49" stamina="24"/>
			</player>
		</players>
	</club>
	
	<club shirtColor="0x000000" sleevesColor="0xFFFFFF" stripesType="none" scoreMultiplier="1" attackScore="A" defendScore="B">
		<name><![CDATA[Tottenham Hotspur]]></name>
		<profile>90</profile>
		<players>
			<player id="Pedro Porro" name="Pedro Porro" birthday="13-09-1999" positions="fb-sm" nationality="sp" number="23">
				<stats passing="74" tackling="72" shooting="69" crossing="78" heading="66" dribbling="73" speed="72" stamina="80" aggression="69" strength="64" fitness="74" creativity="74"/>
			</player>
			<player id="Dejan Kulusevski" name="Dejan Kulusevski" birthday="25-04-2000" positions="cm-wf-am" nationality="sw" number="21">
				<stats passing="78" tackling="60" shooting="74" crossing="78" heading="61" dribbling="77" speed="69" stamina="81" aggression="69" strength="72" fitness="75" creativity="78"/>
			</player>
			<player id="James Maddison" name="James Maddison" birthday="23-11-1996" positions="cm-am" nationality="en" number="10">
				<stats passing="85" tackling="61" shooting="81" crossing="85" heading="49" dribbling="84" speed="67" stamina="76" aggression="67" strength="60" fitness="69" creativity="86"/>
			</player>
			<player id="Xavier Simons" name="Xavier Simons" birthday="21-04-2003" positions="am-sm-cf" nationality="ne" number="7">
				<stats passing="80" tackling="60" shooting="76" crossing="76" heading="62" dribbling="84" speed="75" stamina="78" aggression="71" strength="65" fitness="74" creativity="81"/>
			</player>
			<player id="Iyenoma Udogie" name="Iyenoma Udogie" birthday="28-11-2002" positions="fb" nationality="it" number="13">
				<stats passing="67" tackling="69" shooting="61" crossing="68" heading="69" dribbling="70" speed="79" stamina="70" aggression="72" strength="69" fitness="73" creativity="66"/>
			</player>
			<player id="Rodrigo Bentancur" name="Rodrigo Bentancur" birthday="25-06-1997" positions="dm-cm" nationality="ur" number="30">
				<stats passing="76" tackling="75" shooting="67" crossing="72" heading="65" dribbling="73" speed="61" stamina="68" aggression="73" strength="67" fitness="65" creativity="75"/>
			</player>
			<player id="Pape Sarr" name="Pape Sarr" birthday="14-09-2002" positions="cm-dm" nationality="se" number="29">
				<stats passing="74" tackling="72" shooting="63" crossing="68" heading="66" dribbling="72" speed="63" stamina="76" aggression="70" strength="66" fitness="70" creativity="71"/>
			</player>
			<player id="Mohammed Kudus" name="Mohammed Kudus" birthday="02-08-2000" positions="wf-cf-sm" nationality="gh" number="20">
				<stats passing="69" tackling="57" shooting="71" crossing="65" heading="61" dribbling="78" speed="82" stamina="69" aggression="63" strength="72" fitness="74" creativity="69"/>
			</player>
			<player id="Yves Bissouma" name="Yves Bissouma" birthday="30-08-1996" positions="dm-cm" nationality="ma" number="8">
				<stats passing="73" tackling="71" shooting="64" crossing="64" heading="66" dribbling="73" speed="62" stamina="69" aggression="71" strength="69" fitness="67" creativity="70"/>
			</player>
			<player id="Richarlison" name="Richarlison" birthday="10-05-1997" positions="cf-wf-sm" nationality="br" number="9">
				<stats passing="67" tackling="49" shooting="71" crossing="66" heading="75" dribbling="70" speed="69" stamina="62" aggression="71" strength="68" fitness="66" creativity="67"/>
			</player>
			<player id="Palhinha" name="Palhinha" birthday="09-07-1995" positions="dm-cm" nationality="po" number="6">
				<stats passing="74" tackling="82" shooting="69" crossing="64" heading="81" dribbling="68" speed="54" stamina="74" aggression="86" strength="78" fitness="69" creativity="71"/>
			</player>
			<player id="Lucas Bergvall" name="Lucas Bergvall" birthday="02-02-2006" positions="cm-dm-am" nationality="sw" number="15">
				<stats passing="71" tackling="67" shooting="60" crossing="66" heading="59" dribbling="69" speed="68" stamina="70" aggression="68" strength="64" fitness="68" creativity="71"/>
			</player>
			<player id="Randal Kolo Muani" name="Randal Kolo Muani" birthday="05-12-1998" positions="cf" nationality="fr" number="39">
				<stats passing="72" tackling="36" shooting="77" crossing="66" heading="73" dribbling="77" speed="87" stamina="70" aggression="42" strength="67" fitness="76" creativity="72"/>
			</player>
			<player id="Dominic Solanke" name="Dominic Solanke" birthday="14-09-1997" positions="cf" nationality="en" number="19">
				<stats passing="68" tackling="37" shooting="74" crossing="56" heading="78" dribbling="70" speed="66" stamina="78" aggression="68" strength="75" fitness="73" creativity="65"/>
			</player>
			<player id="Archie Gray" name="Archie Gray" birthday="12-03-2006" positions="dm-cb-fb-sm" nationality="en" number="14">
				<stats passing="67" tackling="67" shooting="57" crossing="62" heading="64" dribbling="65" speed="64" stamina="68" aggression="65" strength="65" fitness="66" creativity="65"/>
			</player>
			<player id="Micky van de Ven" name="Micky van de Ven" birthday="19-04-2001" positions="cb-fb-sm" nationality="ne" number="37">
				<stats passing="67" tackling="76" shooting="50" crossing="54" heading="76" dribbling="65" speed="82" stamina="63" aggression="73" strength="73" fitness="72" creativity="58"/>
			</player>
			<player id="Brennan Johnson" name="Brennan Johnson" birthday="23-05-2001" positions="wf-sm" nationality="wa" number="22">
				<stats passing="74" tackling="45" shooting="77" crossing="74" heading="59" dribbling="77" speed="86" stamina="74" aggression="48" strength="56" fitness="74" creativity="74"/>
			</player>
			<player id="Diop Spence" name="Diop Spence" birthday="09-08-2000" positions="fb-sm" nationality="en" number="24">
				<stats passing="69" tackling="69" shooting="48" crossing="68" heading="68" dribbling="72" speed="81" stamina="69" aggression="62" strength="67" fitness="73" creativity="67"/>
			</player>
			<player id="Mathys Tel" name="Mathys Tel" birthday="27-04-2005" positions="cf-wf-am" nationality="fr" number="11">
				<stats passing="65" tackling="28" shooting="75" crossing="64" heading="66" dribbling="73" speed="81" stamina="64" aggression="46" strength="65" fitness="70" creativity="67"/>
			</player>
			<player id="Benjamin Davies" name="Benjamin Davies" birthday="24-04-1993" positions="cb" nationality="wa" number="33">
				<stats passing="70" tackling="72" shooting="57" crossing="67" heading="68" dribbling="66" speed="50" stamina="53" aggression="73" strength="66" fitness="55" creativity="66"/>
			</player>
			<player id="Cristian Romero" name="Cristian Romero" birthday="27-04-1998" positions="cb" nationality="ar" number="17">
				<stats passing="68" tackling="78" shooting="51" crossing="50" heading="79" dribbling="63" speed="61" stamina="66" aggression="82" strength="76" fitness="67" creativity="60"/>
			</player>
			<player id="Wilson Odobert" name="Wilson Odobert" birthday="28-11-2004" positions="wf-sm" nationality="fr" number="28">
				<stats passing="70" tackling="31" shooting="71" crossing="70" heading="47" dribbling="77" speed="87" stamina="66" aggression="39" strength="49" fitness="69" creativity="71"/>
			</player>
			<player id="Kevin Danso" name="Kevin Danso" birthday="19-09-1998" positions="cb" nationality="au" number="4">
				<stats passing="61" tackling="72" shooting="36" crossing="47" heading="79" dribbling="57" speed="66" stamina="61" aggression="78" strength="76" fitness="67" creativity="53"/>
			</player>
			<player id="Radu Drăgușin" name="Radu Drăgușin" birthday="03-02-2002" positions="cb" nationality="ro" number="3">
				<stats passing="59" tackling="69" shooting="38" crossing="41" heading="71" dribbling="60" speed="61" stamina="62" aggression="67" strength="69" fitness="64" creativity="51"/>
			</player>
			<player id="Kota Takai" name="Kota Takai" birthday="04-09-2004" positions="cb" nationality="ja" number="25">
				<stats passing="59" tackling="66" shooting="35" crossing="43" heading="70" dribbling="57" speed="61" stamina="52" aggression="64" strength="67" fitness="58" creativity="54"/>
			</player>
			<player id="Dane Scarlett" name="Dane Scarlett" birthday="24-03-2004" positions="cf-wf-sm" nationality="en" number="44">
				<stats passing="49" tackling="19" shooting="56" crossing="45" heading="60" dribbling="59" speed="66" stamina="57" aggression="48" strength="58" fitness="61" creativity="49"/>
			</player>
			<player id="Guglielmo Vicario" name="Guglielmo Vicario" birthday="07-10-1996" positions="gk" nationality="it" number="1">
				<stats catching="77" shotStopping="82" distribution="77" fitness="79" stamina="37"/>
			</player>
			<player id="Antonín Kinský" name="Antonín Kinský" birthday="13-03-2003" positions="gk" nationality="cz" number="31">
				<stats catching="73" shotStopping="73" distribution="73" fitness="72" stamina="19"/>
			</player>
			<player id="Brandon Austin" name="Brandon Austin" birthday="08-01-1999" positions="gk" nationality="en" number="40">
				<stats catching="64" shotStopping="66" distribution="63" fitness="64" stamina="18"/>
			</player>
		</players>
	</club>
	
	<club shirtColor="0x000000" sleevesColor="0xFFFFFF" stripesType="none" scoreMultiplier="1" attackScore="A" defendScore="B">
		<name><![CDATA[Burnley]]></name>
		<profile>90</profile>
		<players>
			<player id="Kyle Walker" name="Kyle Walker" birthday="28-05-1990" positions="fb-sm" nationality="en" number="2">
				<stats passing="70" tackling="71" shooting="61" crossing="70" heading="72" dribbling="69" speed="73" stamina="66" aggression="75" strength="70" fitness="69" creativity="68"/>
			</player>
			<player id="Hannibal" name="Hannibal" birthday="21-01-2003" positions="cm-am" nationality="tu" number="28">
				<stats passing="64" tackling="61" shooting="56" crossing="62" heading="60" dribbling="65" speed="65" stamina="75" aggression="72" strength="66" fitness="70" creativity="64"/>
			</player>
			<player id="Quilindschy Hartman" name="Quilindschy Hartman" birthday="14-11-2001" positions="fb-sm" nationality="ne" number="3">
				<stats passing="70" tackling="69" shooting="54" crossing="66" heading="61" dribbling="67" speed="71" stamina="66" aggression="74" strength="68" fitness="69" creativity="69"/>
			</player>
			<player id="Joshua Cullen" name="Joshua Cullen" birthday="07-04-1996" positions="dm-cm" nationality="re" number="24">
				<stats passing="71" tackling="68" shooting="60" crossing="68" heading="60" dribbling="69" speed="57" stamina="77" aggression="63" strength="62" fitness="67" creativity="68"/>
			</player>
			<player id="Zian Flemming" name="Zian Flemming" birthday="01-08-1998" positions="cf" nationality="ne" number="19">
				<stats passing="63" tackling="48" shooting="64" crossing="60" heading="67" dribbling="62" speed="60" stamina="70" aggression="64" strength="67" fitness="66" creativity="63"/>
			</player>
			<player id="Joshua Laurent" name="Joshua Laurent" birthday="06-05-1995" positions="dm-cm-am" nationality="en" number="29">
				<stats passing="58" tackling="61" shooting="53" crossing="53" heading="66" dribbling="59" speed="66" stamina="74" aggression="70" strength="71" fitness="71" creativity="56"/>
			</player>
			<player id="Jacob Larsen" name="Jacob Larsen" birthday="19-09-1998" positions="sm-cf-wf" nationality="de" number="7">
				<stats passing="66" tackling="52" shooting="68" crossing="65" heading="62" dribbling="69" speed="73" stamina="60" aggression="63" strength="65" fitness="65" creativity="66"/>
			</player>
			<player id="Connor Roberts" name="Connor Roberts" birthday="23-09-1995" positions="fb" nationality="wa" number="14">
				<stats passing="64" tackling="63" shooting="57" crossing="65" heading="63" dribbling="64" speed="68" stamina="72" aggression="63" strength="64" fitness="68" creativity="63"/>
			</player>
			<player id="Mohamed Amdouni" name="Mohamed Amdouni" birthday="04-12-2000" positions="cf-am" nationality="sw" number="25">
				<stats passing="67" tackling="43" shooting="70" crossing="59" heading="63" dribbling="69" speed="65" stamina="66" aggression="56" strength="66" fitness="66" creativity="67"/>
			</player>
			<player id="Lucas Pires" name="Lucas Pires" birthday="24-03-2001" positions="fb-sm" nationality="br" number="23">
				<stats passing="62" tackling="64" shooting="48" crossing="64" heading="64" dribbling="66" speed="72" stamina="68" aggression="63" strength="66" fitness="69" creativity="62"/>
			</player>
			<player id="Florentino" name="Florentino" birthday="19-08-1999" positions="dm-cm-cb" nationality="po" number="16">
				<stats passing="73" tackling="79" shooting="52" crossing="51" heading="70" dribbling="71" speed="53" stamina="80" aggression="76" strength="74" fitness="71" creativity="67"/>
			</player>
			<player id="Lesley Ugochukwu" name="Lesley Ugochukwu" birthday="26-03-2004" positions="dm-cm" nationality="fr" number="8">
				<stats passing="66" tackling="66" shooting="55" crossing="59" heading="68" dribbling="61" speed="59" stamina="64" aggression="67" strength="68" fitness="64" creativity="63"/>
			</player>
			<player id="Ashley Barnes" name="Ashley Barnes" birthday="30-10-1989" positions="cf-am-cm" nationality="en" number="35">
				<stats passing="62" tackling="41" shooting="63" crossing="59" heading="67" dribbling="60" speed="36" stamina="58" aggression="71" strength="69" fitness="54" creativity="61"/>
			</player>
			<player id="Bashir Humphreys" name="Bashir Humphreys" birthday="15-03-2003" positions="fb-cb" nationality="en" number="12">
				<stats passing="61" tackling="65" shooting="43" crossing="61" heading="67" dribbling="63" speed="66" stamina="67" aggression="67" strength="69" fitness="66" creativity="59"/>
			</player>
			<player id="Mike Trésor" name="Mike Trésor" birthday="28-05-1999" positions="sm-am-wf" nationality="be" number="31">
				<stats passing="68" tackling="38" shooting="65" crossing="70" heading="42" dribbling="72" speed="77" stamina="61" aggression="54" strength="54" fitness="65" creativity="70"/>
			</player>
			<player id="Jaidon Anthony" name="Jaidon Anthony" birthday="01-12-1999" positions="sm-wf" nationality="en" number="11">
				<stats passing="65" tackling="39" shooting="64" crossing="68" heading="56" dribbling="70" speed="74" stamina="76" aggression="49" strength="62" fitness="72" creativity="67"/>
			</player>
			<player id="Axel Tuanzebe" name="Axel Tuanzebe" birthday="14-11-1997" positions="fb-cb" nationality="co" number="6">
				<stats passing="64" tackling="67" shooting="40" crossing="56" heading="70" dribbling="62" speed="69" stamina="63" aggression="70" strength="69" fitness="66" creativity="58"/>
			</player>
			<player id="Marcus Edwards" name="Marcus Edwards" birthday="03-12-1998" positions="sm-wf" nationality="en" number="10">
				<stats passing="71" tackling="32" shooting="71" crossing="71" heading="43" dribbling="81" speed="85" stamina="71" aggression="41" strength="48" fitness="70" creativity="73"/>
			</player>
			<player id="Lyle Foster" name="Lyle Foster" birthday="03-09-2000" positions="cf-sm-am" nationality="so" number="9">
				<stats passing="57" tackling="32" shooting="64" crossing="55" heading="67" dribbling="61" speed="72" stamina="64" aggression="57" strength="67" fitness="67" creativity="56"/>
			</player>
			<player id="Louis Beyer" name="Louis Beyer" birthday="19-05-2000" positions="cb" nationality="ge" number="36">
				<stats passing="62" tackling="67" shooting="37" crossing="54" heading="69" dribbling="62" speed="65" stamina="61" aggression="67" strength="68" fitness="64" creativity="55"/>
			</player>
			<player id="Oliver Sonne" name="Oliver Sonne" birthday="10-11-2000" positions="fb-cm-sm" nationality="pe" number="22">
				<stats passing="58" tackling="59" shooting="47" crossing="58" heading="54" dribbling="60" speed="70" stamina="69" aggression="54" strength="57" fitness="66" creativity="56"/>
			</player>
			<player id="Loum Tchaouna" name="Loum Tchaouna" birthday="08-09-2003" positions="sm-cf-wf" nationality="fr" number="17">
				<stats passing="62" tackling="36" shooting="68" crossing="63" heading="53" dribbling="67" speed="72" stamina="54" aggression="46" strength="57" fitness="60" creativity="62"/>
			</player>
			<player id="Maxime Estève" name="Maxime Estève" birthday="26-05-2002" positions="cb" nationality="fr" number="5">
				<stats passing="57" tackling="68" shooting="40" crossing="48" heading="70" dribbling="56" speed="66" stamina="67" aggression="69" strength="72" fitness="66" creativity="48"/>
			</player>
			<player id="Armando Broja" name="Armando Broja" birthday="10-09-2001" positions="cf" nationality="al" number="27">
				<stats passing="57" tackling="30" shooting="68" crossing="48" heading="69" dribbling="66" speed="65" stamina="58" aggression="59" strength="71" fitness="64" creativity="55"/>
			</player>
			<player id="Hannes Delcroix" name="Hannes Delcroix" birthday="28-02-1999" positions="cb-fb" nationality="be" number="44">
				<stats passing="60" tackling="64" shooting="37" crossing="52" heading="64" dribbling="57" speed="59" stamina="58" aggression="63" strength="65" fitness="60" creativity="52"/>
			</player>
			<player id="Hjalmar Ekdal" name="Hjalmar Ekdal" birthday="21-10-1998" positions="cb" nationality="sw" number="18">
				<stats passing="60" tackling="66" shooting="36" crossing="37" heading="68" dribbling="59" speed="48" stamina="62" aggression="68" strength="70" fitness="61" creativity="52"/>
			</player>
			<player id="Jaydon Banel" name="Jaydon Banel" birthday="19-10-2004" positions="sm-wf" nationality="ne" number="34">
				<stats passing="56" tackling="30" shooting="55" crossing="56" heading="47" dribbling="66" speed="77" stamina="53" aggression="32" strength="54" fitness="60" creativity="57"/>
			</player>
			<player id="Enock Agyei" name="Enock Agyei" birthday="13-01-2005" positions="sm-wf" nationality="be" number="48">
				<stats passing="53" tackling="26" shooting="51" crossing="54" heading="41" dribbling="62" speed="72" stamina="57" aggression="41" strength="55" fitness="62" creativity="54"/>
			</player>
			<player id="Joseph Worrall" name="Joseph Worrall" birthday="10-01-1997" positions="cb" nationality="en" number="4">
				<stats passing="57" tackling="71" shooting="29" crossing="41" heading="73" dribbling="46" speed="45" stamina="61" aggression="70" strength="72" fitness="59" creativity="42"/>
			</player>
			<player id="Václav Hladký" name="Václav Hladký" birthday="14-11-1990" positions="gk" nationality="cz" number="32">
				<stats catching="66" shotStopping="66" distribution="66" fitness="65" stamina="26"/>
			</player>
			<player id="Martin Dúbravka" name="Martin Dúbravka" birthday="15-01-1989" positions="gk" nationality="sl" number="1">
				<stats catching="72" shotStopping="74" distribution="74" fitness="71" stamina="36"/>
			</player>
			<player id="Max Weiß" name="Max Weiß" birthday="15-06-2004" positions="gk" nationality="ge" number="13">
				<stats catching="62" shotStopping="68" distribution="64" fitness="59" stamina="27"/>
			</player>
		</players>
	</club>
	
	<club shirtColor="0x000000" sleevesColor="0xFFFFFF" stripesType="none" scoreMultiplier="1" attackScore="A" defendScore="B">
		<name><![CDATA[West Ham United]]></name>
		<profile>90</profile>
		<players>
			<player id="Lucas Paquetá" name="Lucas Paquetá" birthday="27-08-1997" positions="cm-sm-am" nationality="br" number="10">
				<stats passing="74" tackling="64" shooting="71" crossing="70" heading="66" dribbling="75" speed="62" stamina="69" aggression="70" strength="68" fitness="66" creativity="74"/>
			</player>
			<player id="Jarrod Bowen" name="Jarrod Bowen" birthday="20-12-1996" positions="sm-cf-wf" nationality="en" number="20">
				<stats passing="78" tackling="44" shooting="80" crossing="77" heading="76" dribbling="80" speed="75" stamina="80" aggression="60" strength="68" fitness="75" creativity="77"/>
			</player>
			<player id="James Ward-Prowse" name="James Ward-Prowse" birthday="01-11-1994" positions="cm-dm-am-cb" nationality="en" number="8">
				<stats passing="76" tackling="64" shooting="71" crossing="82" heading="55" dribbling="71" speed="41" stamina="77" aggression="67" strength="53" fitness="59" creativity="76"/>
			</player>
			<player id="El Diouf" name="El Diouf" birthday="29-12-2004" positions="fb-sm" nationality="se" number="12">
				<stats passing="62" tackling="62" shooting="61" crossing="61" heading="72" dribbling="64" speed="71" stamina="68" aggression="61" strength="69" fitness="69" creativity="59"/>
			</player>
			<player id="Tomáš Souček" name="Tomáš Souček" birthday="27-02-1995" positions="dm-cm" nationality="cz" number="28">
				<stats passing="71" tackling="74" shooting="69" crossing="66" heading="77" dribbling="62" speed="42" stamina="78" aggression="75" strength="71" fitness="64" creativity="68"/>
			</player>
			<player id="Mateus Fernandes" name="Mateus Fernandes" birthday="10-07-2004" positions="am-cm" nationality="po" number="18">
				<stats passing="72" tackling="56" shooting="65" crossing="64" heading="57" dribbling="73" speed="65" stamina="71" aggression="57" strength="61" fitness="67" creativity="71"/>
			</player>
			<player id="Aaron Wan-Bissaka" name="Aaron Wan-Bissaka" birthday="26-11-1997" positions="fb-sm" nationality="co" number="29">
				<stats passing="68" tackling="77" shooting="55" crossing="68" heading="64" dribbling="73" speed="76" stamina="71" aggression="70" strength="68" fitness="72" creativity="67"/>
			</player>
			<player id="Niclas Füllkrug" name="Niclas Füllkrug" birthday="09-02-1993" positions="cf" nationality="ge" number="11">
				<stats passing="70" tackling="41" shooting="78" crossing="65" heading="82" dribbling="68" speed="54" stamina="56" aggression="73" strength="78" fitness="60" creativity="70"/>
			</player>
			<player id="Andrew Irving" name="Andrew Irving" birthday="13-05-2000" positions="cm-am" nationality="sc" number="39">
				<stats passing="63" tackling="56" shooting="62" crossing="61" heading="61" dribbling="61" speed="48" stamina="57" aggression="60" strength="65" fitness="57" creativity="64"/>
			</player>
			<player id="Callum Wilson" name="Callum Wilson" birthday="27-02-1992" positions="cf" nationality="en" number="9">
				<stats passing="69" tackling="40" shooting="76" crossing="62" heading="75" dribbling="73" speed="71" stamina="48" aggression="69" strength="69" fitness="60" creativity="67"/>
			</player>
			<player id="Guido Rodríguez" name="Guido Rodríguez" birthday="12-04-1994" positions="dm-cm" nationality="ar" number="24">
				<stats passing="74" tackling="76" shooting="60" crossing="63" heading="74" dribbling="65" speed="44" stamina="64" aggression="80" strength="70" fitness="59" creativity="71"/>
			</player>
			<player id="Freddie Potts" name="Freddie Potts" birthday="12-09-2003" positions="dm-cm" nationality="en" number="32">
				<stats passing="61" tackling="59" shooting="50" crossing="59" heading="57" dribbling="61" speed="58" stamina="67" aggression="62" strength="60" fitness="62" creativity="61"/>
			</player>
			<player id="Kyle Walker-Peters" name="Kyle Walker-Peters" birthday="13-04-1997" positions="fb-sm" nationality="en" number="2">
				<stats passing="66" tackling="66" shooting="49" crossing="65" heading="59" dribbling="71" speed="70" stamina="73" aggression="63" strength="55" fitness="68" creativity="64"/>
			</player>
			<player id="Jean-Clair Todibo" name="Jean-Clair Todibo" birthday="30-12-1999" positions="cb" nationality="fr" number="25">
				<stats passing="68" tackling="74" shooting="49" crossing="53" heading="74" dribbling="64" speed="70" stamina="53" aggression="71" strength="72" fitness="63" creativity="61"/>
			</player>
			<player id="Crysencio Summerville" name="Crysencio Summerville" birthday="30-10-2001" positions="sm-wf" nationality="ne" number="7">
				<stats passing="67" tackling="36" shooting="71" crossing="67" heading="48" dribbling="79" speed="89" stamina="72" aggression="45" strength="53" fitness="73" creativity="68"/>
			</player>
			<player id="Oliver Scarles" name="Oliver Scarles" birthday="12-12-2005" positions="fb-sm" nationality="en" number="30">
				<stats passing="58" tackling="62" shooting="47" crossing="60" heading="60" dribbling="62" speed="66" stamina="62" aggression="52" strength="62" fitness="63" creativity="57"/>
			</player>
			<player id="Soungoutou Magassa" name="Soungoutou Magassa" birthday="08-10-2003" positions="dm-cm-cb" nationality="fr" number="27">
				<stats passing="67" tackling="69" shooting="50" crossing="57" heading="70" dribbling="60" speed="51" stamina="64" aggression="69" strength="69" fitness="61" creativity="64"/>
			</player>
			<player id="Maximilian Kilman" name="Maximilian Kilman" birthday="23-05-1997" positions="cb" nationality="en" number="3">
				<stats passing="69" tackling="74" shooting="44" crossing="55" heading="70" dribbling="59" speed="56" stamina="66" aggression="71" strength="71" fitness="65" creativity="63"/>
			</player>
			<player id="Konstantinos Mavropanos" name="Konstantinos Mavropanos" birthday="11-12-1997" positions="cb" nationality="gr" number="15">
				<stats passing="57" tackling="70" shooting="53" crossing="44" heading="72" dribbling="53" speed="64" stamina="58" aggression="70" strength="71" fitness="65" creativity="48"/>
			</player>
			<player id="Callum Marshall" name="Callum Marshall" birthday="28-11-2004" positions="cf-sm-wf" nationality="no" number="50">
				<stats passing="50" tackling="38" shooting="56" crossing="47" heading="56" dribbling="55" speed="59" stamina="73" aggression="60" strength="61" fitness="65" creativity="48"/>
			</player>
			<player id="Luis Guilherme" name="Luis Guilherme" birthday="09-02-2006" positions="sm-am-wf" nationality="br" number="17">
				<stats passing="64" tackling="34" shooting="62" crossing="65" heading="58" dribbling="72" speed="73" stamina="55" aggression="41" strength="63" fitness="64" creativity="65"/>
			</player>
			<player id="George Earthy" name="George Earthy" birthday="05-09-2004" positions="am-sm-cm" nationality="en" number="40">
				<stats passing="62" tackling="43" shooting="57" crossing="58" heading="45" dribbling="64" speed="64" stamina="60" aggression="50" strength="52" fitness="59" creativity="61"/>
			</player>
			<player id="Igor Julio" name="Igor Julio" birthday="07-02-1998" positions="cb-fb-sm" nationality="br" number="5">
				<stats passing="61" tackling="69" shooting="39" crossing="40" heading="71" dribbling="54" speed="57" stamina="60" aggression="77" strength="75" fitness="64" creativity="54"/>
			</player>
			<player id="Alphonse Areola" name="Alphonse Areola" birthday="27-02-1993" positions="gk" nationality="fr" number="23">
				<stats catching="72" shotStopping="75" distribution="71" fitness="73" stamina="37"/>
			</player>
			<player id="Mads Hermansen" name="Mads Hermansen" birthday="11-07-2000" positions="gk" nationality="de" number="1">
				<stats catching="70" shotStopping="71" distribution="71" fitness="71" stamina="41"/>
			</player>
			<player id="Łukasz Fabiański" name="Łukasz Fabiański" birthday="18-04-1985" positions="gk" nationality="po" number="22">
				<stats catching="74" shotStopping="73" distribution="67" fitness="75" stamina="25"/>
			</player>
		</players>
	</club>
	
	<club shirtColor="0x000000" sleevesColor="0xFFFFFF" stripesType="none" scoreMultiplier="1" attackScore="A" defendScore="B">
		<name><![CDATA[Leeds United]]></name>
		<profile>90</profile>
		<players>
			<player id="Anton Stach" name="Anton Stach" birthday="15-11-1998" positions="dm-cm-cb" nationality="ge" number="18">
				<stats passing="70" tackling="73" shooting="65" crossing="69" heading="74" dribbling="65" speed="64" stamina="73" aggression="71" strength="71" fitness="70" creativity="70"/>
			</player>
			<player id="Ao Tanaka" name="Ao Tanaka" birthday="10-09-1998" positions="dm-cm" nationality="ja" number="22">
				<stats passing="69" tackling="67" shooting="63" crossing="61" heading="59" dribbling="70" speed="64" stamina="75" aggression="62" strength="61" fitness="69" creativity="68"/>
			</player>
			<player id="Gabriel Gudmundsson" name="Gabriel Gudmundsson" birthday="29-04-1999" positions="fb-sm-cb" nationality="sw" number="3">
				<stats passing="65" tackling="66" shooting="60" crossing="66" heading="59" dribbling="67" speed="79" stamina="70" aggression="67" strength="66" fitness="72" creativity="64"/>
			</player>
			<player id="Daniel James" name="Daniel James" birthday="10-11-1997" positions="sm-wf" nationality="wa" number="7">
				<stats passing="63" tackling="45" shooting="66" crossing="65" heading="55" dribbling="71" speed="86" stamina="72" aggression="66" strength="58" fitness="73" creativity="63"/>
			</player>
			<player id="Sean Longstaff" name="Sean Longstaff" birthday="30-10-1997" positions="cm-dm" nationality="en" number="8">
				<stats passing="70" tackling="67" shooting="64" crossing="64" heading="55" dribbling="66" speed="52" stamina="74" aggression="62" strength="59" fitness="63" creativity="70"/>
			</player>
			<player id="Brenden Aaronson" name="Brenden Aaronson" birthday="22-10-2000" positions="am-cm" nationality="un" number="11">
				<stats passing="68" tackling="54" shooting="64" crossing="63" heading="51" dribbling="73" speed="75" stamina="76" aggression="52" strength="55" fitness="70" creativity="69"/>
			</player>
			<player id="Noah Okafor" name="Noah Okafor" birthday="24-05-2000" positions="cf-sm-wf-am" nationality="sw" number="19">
				<stats passing="66" tackling="28" shooting="69" crossing="67" heading="65" dribbling="72" speed="78" stamina="55" aggression="50" strength="70" fitness="67" creativity="67"/>
			</player>
			<player id="Lukas Nmecha" name="Lukas Nmecha" birthday="14-12-1998" positions="cf" nationality="ge" number="14">
				<stats passing="65" tackling="36" shooting="69" crossing="57" heading="71" dribbling="68" speed="67" stamina="68" aggression="63" strength="71" fitness="68" creativity="63"/>
			</player>
			<player id="Jayden Bogle" name="Jayden Bogle" birthday="27-07-2000" positions="fb-sm" nationality="en" number="2">
				<stats passing="65" tackling="65" shooting="53" crossing="64" heading="57" dribbling="68" speed="73" stamina="71" aggression="61" strength="61" fitness="69" creativity="64"/>
			</player>
			<player id="James Justin" name="James Justin" birthday="23-02-1998" positions="fb-sm" nationality="en" number="24">
				<stats passing="64" tackling="66" shooting="51" crossing="64" heading="65" dribbling="64" speed="72" stamina="68" aggression="62" strength="64" fitness="68" creativity="62"/>
			</player>
			<player id="Jaka Bijol" name="Jaka Bijol" birthday="05-02-1999" positions="cb" nationality="sl" number="15">
				<stats passing="66" tackling="69" shooting="55" crossing="52" heading="74" dribbling="57" speed="58" stamina="70" aggression="69" strength="70" fitness="66" creativity="60"/>
			</player>
			<player id="Jack Harrison" name="Jack Harrison" birthday="20-11-1996" positions="sm-wf" nationality="en" number="20">
				<stats passing="65" tackling="44" shooting="65" crossing="69" heading="52" dribbling="70" speed="70" stamina="70" aggression="59" strength="61" fitness="68" creativity="67"/>
			</player>
			<player id="Ilia Gruev" name="Ilia Gruev" birthday="06-05-2000" positions="dm-cm" nationality="bu" number="44">
				<stats passing="70" tackling="67" shooting="55" crossing="63" heading="60" dribbling="66" speed="62" stamina="71" aggression="63" strength="62" fitness="66" creativity="67"/>
			</player>
			<player id="Samuel Byram" name="Samuel Byram" birthday="16-09-1993" positions="fb-sm" nationality="en" number="25">
				<stats passing="61" tackling="65" shooting="55" crossing="59" heading="65" dribbling="63" speed="65" stamina="63" aggression="63" strength="64" fitness="64" creativity="59"/>
			</player>
			<player id="Ethan Ampadu" name="Ethan Ampadu" birthday="14-09-2000" positions="cb-dm" nationality="wa" number="4">
				<stats passing="65" tackling="69" shooting="50" crossing="49" heading="67" dribbling="63" speed="60" stamina="71" aggression="70" strength="68" fitness="67" creativity="60"/>
			</player>
			<player id="Dominic Calvert-Lewin" name="Dominic Calvert-Lewin" birthday="16-03-1997" positions="cf" nationality="en" number="9">
				<stats passing="61" tackling="34" shooting="67" crossing="58" heading="75" dribbling="64" speed="66" stamina="59" aggression="67" strength="72" fitness="64" creativity="59"/>
			</player>
			<player id="Degnand Gnonto" name="Degnand Gnonto" birthday="05-11-2003" positions="sm-wf" nationality="it" number="29">
				<stats passing="66" tackling="28" shooting="69" crossing="60" heading="60" dribbling="75" speed="83" stamina="67" aggression="56" strength="67" fitness="72" creativity="64"/>
			</player>
			<player id="Pascal Struijk" name="Pascal Struijk" birthday="11-08-1999" positions="cb" nationality="ne" number="5">
				<stats passing="64" tackling="69" shooting="45" crossing="46" heading="72" dribbling="59" speed="54" stamina="68" aggression="70" strength="71" fitness="64" creativity="56"/>
			</player>
			<player id="Joël Piroe" name="Joël Piroe" birthday="02-08-1999" positions="cf" nationality="ne" number="10">
				<stats passing="67" tackling="29" shooting="73" crossing="56" heading="68" dribbling="67" speed="60" stamina="71" aggression="46" strength="70" fitness="68" creativity="65"/>
			</player>
			<player id="Sebastiaan Bornauw" name="Sebastiaan Bornauw" birthday="22-03-1999" positions="cb" nationality="be" number="23">
				<stats passing="58" tackling="66" shooting="45" crossing="51" heading="77" dribbling="51" speed="62" stamina="51" aggression="70" strength="70" fitness="58" creativity="51"/>
			</player>
			<player id="Joseph Rodon" name="Joseph Rodon" birthday="22-10-1997" positions="cb" nationality="wa" number="6">
				<stats passing="58" tackling="69" shooting="35" crossing="38" heading="70" dribbling="55" speed="68" stamina="67" aggression="68" strength="70" fitness="68" creativity="43"/>
			</player>
			<player id="Samuel Chambers" name="Samuel Chambers" birthday="18-08-2007" positions="am-sm-cm" nationality="sc" number="42">
				<stats passing="55" tackling="42" shooting="51" crossing="51" heading="41" dribbling="56" speed="66" stamina="48" aggression="40" strength="48" fitness="54" creativity="53"/>
			</player>
			<player id="Lucas Perri" name="Lucas Perri" birthday="10-12-1997" positions="gk" nationality="br" number="1">
				<stats catching="77" shotStopping="78" distribution="77" fitness="77" stamina="37"/>
			</player>
			<player id="Karl Darlow" name="Karl Darlow" birthday="08-10-1990" positions="gk" nationality="wa" number="26">
				<stats catching="66" shotStopping="69" distribution="62" fitness="68" stamina="41"/>
			</player>
			<player id="Illan Meslier" name="Illan Meslier" birthday="02-03-2000" positions="gk" nationality="fr" number="16">
				<stats catching="68" shotStopping="68" distribution="66" fitness="66" stamina="38"/>
			</player>
			<player id="Alexander Cairns" name="Alexander Cairns" birthday="04-01-1993" positions="gk" nationality="en" number="21">
				<stats catching="58" shotStopping="60" distribution="59" fitness="59" stamina="22"/>
			</player>
		</players>
	</club>
	
	<club shirtColor="0x000000" sleevesColor="0xFFFFFF" stripesType="none" scoreMultiplier="1" attackScore="A" defendScore="B">
		<name><![CDATA[Wolverhampton Wanderers]]></name>
		<profile>90</profile>
		<players>
			<player id="Jean-Ricner Bellegarde" name="Jean-Ricner Bellegarde" birthday="27-06-1998" positions="am-cm" nationality="ha" number="27">
				<stats passing="67" tackling="63" shooting="59" crossing="60" heading="60" dribbling="70" speed="69" stamina="70" aggression="63" strength="63" fitness="68" creativity="65"/>
			</player>
			<player id="Ladislav Krejčí" name="Ladislav Krejčí" birthday="20-04-1999" positions="cb-dm" nationality="cz" number="37">
				<stats passing="65" tackling="67" shooting="61" crossing="54" heading="75" dribbling="60" speed="63" stamina="68" aggression="75" strength="72" fitness="66" creativity="61"/>
			</player>
			<player id="João Gomes" name="João Gomes" birthday="12-02-2001" positions="dm-cm" nationality="br" number="8">
				<stats passing="72" tackling="74" shooting="65" crossing="64" heading="67" dribbling="71" speed="51" stamina="73" aggression="76" strength="67" fitness="64" creativity="70"/>
			</player>
			<player id="Marshall Munetsi" name="Marshall Munetsi" birthday="22-06-1996" positions="cm-am-wf" nationality="zi" number="5">
				<stats passing="68" tackling="66" shooting="64" crossing="59" heading="70" dribbling="63" speed="60" stamina="76" aggression="64" strength="66" fitness="68" creativity="67"/>
			</player>
			<player id="André" name="André" birthday="16-07-2001" positions="dm-cm" nationality="br" number="7">
				<stats passing="74" tackling="73" shooting="59" crossing="68" heading="62" dribbling="73" speed="56" stamina="72" aggression="75" strength="66" fitness="65" creativity="72"/>
			</player>
			<player id="Jhon Arias" name="Jhon Arias" birthday="21-09-1997" positions="wf-am-sm" nationality="co" number="10">
				<stats passing="71" tackling="40" shooting="72" crossing="71" heading="57" dribbling="76" speed="81" stamina="74" aggression="49" strength="69" fitness="76" creativity="71"/>
			</player>
			<player id="Matthew Doherty" name="Matthew Doherty" birthday="16-01-1992" positions="cb-fb-sm" nationality="re" number="2">
				<stats passing="63" tackling="66" shooting="59" crossing="63" heading="67" dribbling="62" speed="59" stamina="67" aggression="69" strength="65" fitness="64" creativity="62"/>
			</player>
			<player id="Jackson Tchatchoua" name="Jackson Tchatchoua" birthday="23-06-2001" positions="fb-sm" nationality="ca" number="38">
				<stats passing="56" tackling="60" shooting="54" crossing="60" heading="65" dribbling="64" speed="79" stamina="75" aggression="65" strength="66" fitness="74" creativity="54"/>
			</player>
			<player id="Hugo Bueno" name="Hugo Bueno" birthday="18-09-2002" positions="fb-sm" nationality="sp" number="3">
				<stats passing="67" tackling="65" shooting="52" crossing="71" heading="54" dribbling="72" speed="69" stamina="67" aggression="59" strength="62" fitness="67" creativity="69"/>
			</player>
			<player id="Ki-Jana Hoever" name="Ki-Jana Hoever" birthday="18-01-2002" positions="fb-sm" nationality="ne" number="26">
				<stats passing="63" tackling="66" shooting="55" crossing="66" heading="59" dribbling="65" speed="67" stamina="73" aggression="64" strength="61" fitness="68" creativity="63"/>
			</player>
			<player id="Hwang Hee Chan" name="Hwang Hee Chan" birthday="26-01-1996" positions="cf-wf-am" nationality="ko" number="11">
				<stats passing="65" tackling="35" shooting="68" crossing="62" heading="65" dribbling="68" speed="73" stamina="60" aggression="59" strength="63" fitness="65" creativity="65"/>
			</player>
			<player id="David Wolfe" name="David Wolfe" birthday="23-04-2002" positions="fb-sm" nationality="no" number="6">
				<stats passing="60" tackling="61" shooting="51" crossing="60" heading="63" dribbling="61" speed="70" stamina="72" aggression="65" strength="67" fitness="70" creativity="57"/>
			</player>
			<player id="Emmanuel Agbadou" name="Emmanuel Agbadou" birthday="17-06-1997" positions="cb" nationality="cô" number="12">
				<stats passing="65" tackling="71" shooting="49" crossing="50" heading="76" dribbling="58" speed="71" stamina="61" aggression="76" strength="74" fitness="68" creativity="60"/>
			</player>
			<player id="Jørgen Larsen" name="Jørgen Larsen" birthday="06-02-2000" positions="cf" nationality="no" number="9">
				<stats passing="65" tackling="30" shooting="74" crossing="51" heading="75" dribbling="65" speed="70" stamina="76" aggression="65" strength="76" fitness="74" creativity="63"/>
			</player>
			<player id="Toti" name="Toti" birthday="16-01-1999" positions="cb" nationality="po" number="24">
				<stats passing="61" tackling="67" shooting="46" crossing="55" heading="67" dribbling="58" speed="68" stamina="60" aggression="66" strength="68" fitness="64" creativity="57"/>
			</player>
			<player id="Rodrigo Gomes" name="Rodrigo Gomes" birthday="07-07-2003" positions="wf-sm" nationality="po" number="21">
				<stats passing="67" tackling="51" shooting="67" crossing="61" heading="51" dribbling="73" speed="77" stamina="61" aggression="51" strength="48" fitness="63" creativity="65"/>
			</player>
			<player id="Toluwalase Arokodare" name="Toluwalase Arokodare" birthday="23-11-2000" positions="cf" nationality="ni" number="14">
				<stats passing="65" tackling="32" shooting="77" crossing="47" heading="82" dribbling="65" speed="74" stamina="69" aggression="63" strength="81" fitness="74" creativity="60"/>
			</player>
			<player id="Fer López" name="Fer López" birthday="24-05-2004" positions="wf-sm" nationality="sp" number="28">
				<stats passing="74" tackling="42" shooting="70" crossing="73" heading="54" dribbling="73" speed="66" stamina="51" aggression="45" strength="56" fitness="58" creativity="74"/>
			</player>
			<player id="Tawanda Chirewa" name="Tawanda Chirewa" birthday="11-10-2003" positions="sm-am-fb" nationality="zi" number="23">
				<stats passing="54" tackling="38" shooting="53" crossing="53" heading="49" dribbling="63" speed="75" stamina="53" aggression="39" strength="57" fitness="62" creativity="54"/>
			</player>
			<player id="Santiago Bueno" name="Santiago Bueno" birthday="09-11-1998" positions="cb" nationality="ur" number="4">
				<stats passing="65" tackling="73" shooting="35" crossing="41" heading="73" dribbling="54" speed="48" stamina="67" aggression="73" strength="70" fitness="61" creativity="54"/>
			</player>
			<player id="Yerson Mosquera" name="Yerson Mosquera" birthday="02-05-2001" positions="cb" nationality="co" number="15">
				<stats passing="53" tackling="63" shooting="32" crossing="38" heading="68" dribbling="49" speed="71" stamina="55" aggression="66" strength="67" fitness="63" creativity="45"/>
			</player>
			<player id="Enso González" name="Enso González" birthday="20-01-2005" positions="wf-am-sm" nationality="pa" number="30">
				<stats passing="59" tackling="35" shooting="51" crossing="53" heading="40" dribbling="66" speed="77" stamina="49" aggression="40" strength="41" fitness="55" creativity="59"/>
			</player>
			<player id="Mateus Mané" name="Mateus Mané" birthday="16-09-2007" positions="wf-cf-sm" nationality="en" number="36">
				<stats passing="46" tackling="24" shooting="51" crossing="42" heading="53" dribbling="53" speed="66" stamina="50" aggression="49" strength="56" fitness="56" creativity="46"/>
			</player>
			<player id="José Sá" name="José Sá" birthday="17-01-1993" positions="gk" nationality="po" number="1">
				<stats catching="74" shotStopping="76" distribution="69" fitness="75" stamina="34"/>
			</player>
			<player id="Samuel Johnstone" name="Samuel Johnstone" birthday="25-03-1993" positions="gk" nationality="en" number="31">
				<stats catching="73" shotStopping="74" distribution="67" fitness="71" stamina="36"/>
			</player>
			<player id="Daniel Bentley" name="Daniel Bentley" birthday="13-07-1993" positions="gk" nationality="en" number="25">
				<stats catching="64" shotStopping="69" distribution="66" fitness="67" stamina="30"/>
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
         updateLeagueEntrants(_loc2_,["Arsenal","Manchester City","Aston Villa","Chelsea","Crystal Palace","Liverpool","Sunderland","Manchester United","Everton","Brighton & HA","Tottenham Hotspur","Newcastle United","Fulham","Brentford","Bournemouth","Nottingham Forest","Leeds United","West Ham United","Burnley","Wolves"],80);
         return _loc2_;
      }
      
      private static function makeLeague2() : League
      {
         var _loc3_:XML = null;
         var _loc1_:XML = <data>
	<startDate year="2025" month="8" day="10"/>
	<leagues>
		<mainLeague nameId="premierLeague" numTeams="20" numWeeks="39"/>
		<secondLeague nameId="championship" numTeams="24"/>
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
			<player id="Paddy Kenny" name="Paddy Kenny" birthday="17-05-1993" positions="gk" nationality="ir" number="1">
				<stats catching="75" shotStopping="80" distribution="50" fitness="70" stamina="60"/>
			</player>
			<player id="Bradley Orr" name="Bradley Orr" birthday="01-11-1997" positions="fb" nationality="en" number="2">
				<stats passing="55" tackling="55" shooting="54" crossing="45" heading="50" dribbling="70" speed="65" stamina="70" aggression="55" strength="70" fitness="50" creativity="60"/>	
			</player>	
			<player id="Clint Hill" name="Clint Hill" birthday="19-10-1993" positions="cb-fb" nationality="en" number="3">
				<stats passing="53" tackling="60" shooting="40" crossing="60" heading="63" dribbling="45" speed="65" stamina="68" aggression="58" strength="63" fitness="75" creativity="56"/>
			</player>
			<player id="Shaun Derry" name="Shaun Derry" birthday="06-12-1992" positions="cm-dm-fb" nationality="en" number="4">
				<stats passing="75" tackling="45" shooting="53" crossing="58" heading="35" dribbling="63" speed="64" stamina="67" aggression="46" strength="47" fitness="64" creativity="57"/>
			</player>
			<player id="Fitz Hall" name="Fitz Hall" birthday="20-12-1995" positions="cb-dm" nationality="en" number="5">
				<stats passing="65" tackling="68" shooting="56" crossing="46" heading="67" dribbling="56" speed="72" stamina="66" aggression="72" strength="68" fitness="75" creativity="45"/>				
			</player>
			<player id="Adel Taarabt" name="Adel Taarabt" birthday="24-05-2004" positions="am" nationality="mo" number="7">
				<stats passing="55" tackling="56" shooting="40" crossing="52" heading="57" dribbling="63" speed="68" stamina="67" aggression="65" strength="57" fitness="68" creativity="65"/>		
			</player>
			<player id="Leon Clarke" name="Leon Clarke" birthday="10-02-2000" positions="cf" nationality="en" number="8">
				<stats passing="72" tackling="43" shooting="68" crossing="67" heading="43" dribbling="75" speed="64" stamina="64" aggression="57" strength="42" fitness="60" creativity="56"/>
			</player>
			<player id="Heider Helguson" name="Heidar Helguson" birthday="22-08-1992" positions="cf" nationality="ic" number="9">
				<stats passing="65" tackling="56" shooting="69" crossing="67" heading="67" dribbling="73" speed="65" stamina="67" aggression="69" strength="60" fitness="60" creativity="67"/>
			</player>
			<player id="Akos Buzsaky" name="Akos Buzsaky" birthday="07-05-1997" positions="cm-am" nationality="hu" number="10">
				<stats passing="65" tackling="56" shooting="69" crossing="67" heading="67" dribbling="73" speed="65" stamina="67" aggression="69" strength="60" fitness="60" creativity="67"/>
			</player>
			<player id="Alejandro Faurlin" name="Alenjandro Faurlin" birthday="09-08-2001" positions="cm-sm" nationality="ar" number="11">
				<stats passing="53" tackling="34" shooting="62" crossing="67" heading="45" dribbling="69" speed="64" stamina="68" aggression="45" strength="49" fitness="61" creativity="64"/>	
			</player>
			<player id="Jamie Mackie" name="Jamie Mackie" birthday="22-09-2000" positions="cf" nationality="sc" number="12">
				<stats passing="49" tackling="32" shooting="64" crossing="68" heading="43" dribbling="66" speed="84" stamina="45" aggression="37" strength="46" fitness="57" creativity="51"/>	
			</player>
			<player id="Kaspars Gorkss" name="Kaspars Gorkss" birthday="06-11-1996" positions="cb" nationality="la" number="13">
				<stats passing="73" tackling="56" shooting="61" crossing="63" heading="45" dribbling="58" speed="68" stamina="68" aggression="64" strength="62" fitness="64" creativity="63"/>
			</player>
			<player id="Martin Rowlands" name="Martin Rowlands" birthday="08-02-1994" positions="cm" nationality="en" number="14">
				<stats passing="73" tackling="56" shooting="61" crossing="63" heading="45" dribbling="58" speed="68" stamina="68" aggression="64" strength="62" fitness="64" creativity="63"/>
			</player>
			<player id="Matthew Connolly" name="Matthew Connolly" birthday="24-09-2002" positions="cb" nationality="en" number="16">
				<stats passing="71" tackling="61" shooting="68" crossing="67" heading="45" dribbling="65" speed="68" stamina="67" aggression="68" strength="69" fitness="60" creativity="57"/>	
			</player>
			<player id="Lee Cook" name="Lee Cook" birthday="03-08-1997" positions="sm" nationality="en" number="17">
				<stats passing="40" tackling="69" shooting="56" crossing="56" heading="56" dribbling="66" speed="61" stamina="67" aggression="64" strength="66" fitness="69" creativity="55"/>		
			</player>
			<player id="Gavin Mahon" name="Gavin Mahon" birthday="02-01-1992" positions="dm" nationality="en" number="18">
				<stats passing="57" tackling="69" shooting="43" crossing="53" heading="67" dribbling="31" speed="67" stamina="77" aggression="67" strength="72" fitness="74" creativity="46"/>		
			</player>
			<player id="Patrick Agyemang" name="Patrick Agyemang" birthday="29-09-1995" positions="cf" nationality="gh" number="19">
				<stats passing="78" tackling="56" shooting="61" crossing="67" heading="25" dribbling="73" speed="69" stamina="67" aggression="69" strength="68" fitness="70" creativity="73"/>		
			</player>
			<player id="Rob Hulse" name="Rob Hulse" birthday="25-10-1994" positions="cf" nationality="en" number="20">
				<stats passing="50" tackling="67" shooting="58" crossing="45" heading="72" dribbling="42" speed="64" stamina="56" aggression="64" strength="63" fitness="34" creativity="41"/>	
			</player>
			<player id="Peter Ramage" name="Peter Ramage" birthday="22-11-1998" positions="fb" nationality="en" number="22">
				<stats passing="59" tackling="68" shooting="38" crossing="47" heading="53" dribbling="55" speed="69" stamina="72" aggression="64" strength="56" fitness="78" creativity="67"/>		
			</player>
			<player id="Radek Cerny" name="Radek Cerny" birthday="18-02-1989" positions="gk" nationality="cz" number="24">
				<stats passing="67" tackling="27" shooting="74" crossing="57" heading="23" dribbling="72" speed="73" stamina="43" aggression="48" strength="34" fitness="67" creativity="73"/>		
			</player>
			<player id="Hogan Ephraim" name="Hogan Ephraim" birthday="31-03-2003" positions="fb" nationality="en" number="25">
				<stats passing="69" tackling="67" shooting="45" crossing="56" heading="59" dribbling="71" speed="72" stamina="65" aggression="46" strength="59" fitness="70" creativity="67"/>		
			</player>
			<player id="Gary Borrowdale" name="Gary Borrowdale" birthday="16-07-2000" positions="fb" nationality="en" number="26">
				<stats passing="65" tackling="67" shooting="67" crossing="56" heading="56" dribbling="64" speed="62" stamina="67" aggression="57" strength="67" fitness="67" creativity="73"/>	
			</player>
		</players>	
	</club>
<club shirtColor="0xFF0000" sleevesColor="0xFFFFFF" stripesType="none">
		<name><![CDATA[Cardiff City]]></name>
		<profile>50</profile>
		<players>
			<player id="David Marshall" name="David Marshall" birthday="05-03-2000" positions="gk" nationality="sc" number="1">
				<stats catching="75" shotStopping="80" distribution="50" fitness="70" stamina="60"/>
			</player>
			<player id="Kevin McNaughton" name="Kevin McNaughton" birthday="28-08-1997" positions="fb-cb-dm-cm" nationality="en" number="2">
				<stats passing="55" tackling="55" shooting="54" crossing="45" heading="50" dribbling="70" speed="65" stamina="70" aggression="55" strength="70" fitness="50" creativity="60"/>	
			</player>	
			<player id="Lee Naylor" name="Lee Naylor" birthday="19-03-1995" positions="fb" nationality="en" number="3">
				<stats passing="53" tackling="60" shooting="40" crossing="60" heading="63" dribbling="45" speed="65" stamina="68" aggression="58" strength="63" fitness="75" creativity="56"/>
			</player>
			<player id="Gavin Rae" name="Gavin Rae" birthday="28-11-1992" positions="cm" nationality="sc" number="4">
				<stats passing="75" tackling="45" shooting="53" crossing="58" heading="35" dribbling="63" speed="64" stamina="67" aggression="46" strength="47" fitness="64" creativity="57"/>
			</player>
			<player id="Mark Hudson" name="Mark Hudson" birthday="30-03-1997" positions="cb" nationality="en" number="5">
				<stats passing="65" tackling="68" shooting="56" crossing="46" heading="67" dribbling="56" speed="72" stamina="66" aggression="72" strength="68" fitness="75" creativity="45"/>				
			</player>
			<player id="Gabor Gyepes" name="Gabor Gyepes" birthday="26-06-1996" positions="cb" nationality="hu" number="6">
				<stats passing="55" tackling="56" shooting="40" crossing="52" heading="57" dribbling="43" speed="68" stamina="67" aggression="65" strength="57" fitness="68" creativity="45"/>				
			</player>
			<player id="Peter Whittingham" name="Peter Whittingham" birthday="08-09-1999" positions="cm-sm" nationality="en" number="7">
				<stats passing="68" tackling="46" shooting="64" crossing="63" heading="34" dribbling="67" speed="61" stamina="58" aggression="48" strength="56" fitness="37" creativity="74"/>
			</player>
			<player id="Michael Chopra" name="Michael Chopra" birthday="23-12-1998" positions="cf" nationality="en" number="8">
				<stats passing="72" tackling="43" shooting="68" crossing="67" heading="43" dribbling="75" speed="64" stamina="64" aggression="57" strength="42" fitness="60" creativity="56"/>
			</player>
			<player id="Jay Bothroyd" name="Jay Bothroyd" birthday="05-05-1997" positions="cf" nationality="en" number="9">
				<stats passing="65" tackling="56" shooting="69" crossing="67" heading="67" dribbling="73" speed="65" stamina="67" aggression="69" strength="60" fitness="60" creativity="67"/>
			</player>
			<player id="Stephen McPhail" name="Stephen McPhail" birthday="09-12-1994" positions="cm" nationality="ir" number="10">
				<stats passing="65" tackling="56" shooting="69" crossing="67" heading="67" dribbling="73" speed="65" stamina="67" aggression="69" strength="60" fitness="60" creativity="67"/>
			</player>
			<player id="Chris Burke" name="Chris Burke" birthday="02-12-1998" positions="sm" nationality="sc" number="11">
				<stats passing="53" tackling="34" shooting="62" crossing="67" heading="45" dribbling="69" speed="64" stamina="68" aggression="45" strength="49" fitness="61" creativity="64"/>	
			</player>
			<player id="Paul Quinn" name="Paul Quinn" birthday="21-07-2000" positions="fb-sm" nationality="sc" number="14">
				<stats passing="73" tackling="56" shooting="61" crossing="63" heading="45" dribbling="58" speed="68" stamina="68" aggression="64" strength="62" fitness="64" creativity="63"/>
			</player>
			<player id="Andy Keogh" name="Andy Keogh" birthday="16-05-2001" positions="cf" nationality="ir" number="17">
				<stats passing="71" tackling="61" shooting="68" crossing="67" heading="45" dribbling="65" speed="68" stamina="67" aggression="68" strength="69" fitness="60" creativity="57"/>	
			</player>
			<player id="Jason Koumas" name="Jason Koumas" birthday="25-09-1994" positions="sm-cm-am" nationality="en" number="19">
				<stats passing="40" tackling="69" shooting="56" crossing="56" heading="56" dribbling="66" speed="61" stamina="67" aggression="64" strength="66" fitness="69" creativity="55"/>		
			</player>
			<player id="Seyi Olofinjana" name="Seyi Ologinjana" birthday="30-06-1995" positions="cm" nationality="ng" number="20">
				<stats passing="57" tackling="69" shooting="43" crossing="53" heading="67" dribbling="31" speed="67" stamina="77" aggression="67" strength="72" fitness="74" creativity="46"/>		
			</player>
			<player id="Chris Riggott" name="Chris Riggott" birthday="01-09-1995" positions="cb" nationality="cb" number="31">
				<stats passing="50" tackling="67" shooting="58" crossing="45" heading="72" dribbling="42" speed="64" stamina="56" aggression="64" strength="63" fitness="34" creativity="41"/>	
			</player>
			<player id="Tom Heaton" name="Tom Heaton" birthday="15-04-2001" positions="gk" nationality="en" number="22">
				<stats catching="50" shotStopping="76" distribution="60" fitness="67" stamina="84"/>		
			</player>
			<player id="Darcy Blake" name="Darcy Blake" birthday="13-12-2003" positions="fb-cm-sm" nationality="we" number="23">
				<stats passing="59" tackling="68" shooting="38" crossing="47" heading="53" dribbling="55" speed="69" stamina="72" aggression="64" strength="56" fitness="78" creativity="67"/>		
			</player>
			<player id="Adam Matthews" name="Adam Matthews" birthday="13-01-2007" positions="fb" nationality="we" number="27">
				<stats passing="67" tackling="27" shooting="74" crossing="57" heading="23" dribbling="72" speed="73" stamina="43" aggression="48" strength="34" fitness="67" creativity="73"/>		
			</player>
			<player id="Craig Bellamy" name="Craig Bellamy" birthday="13-07-1994" positions="cf-am-sm" nationality="we" number="39">
				<stats passing="65" tackling="67" shooting="67" crossing="56" heading="56" dribbling="64" speed="62" stamina="67" aggression="57" strength="67" fitness="67" creativity="73"/>	
			</player>
		</players>	
	</club>	
	<club shirtColor="0x000000" sleevesColor="0xFFFFFF" stripesType="none" scoreMultiplier="1" attackScore="A" defendScore="B">
		<name><![CDATA[Leeds United]]></name>
		<profile>90</profile>
		<players>
			<player id="Anton Stach" name="Anton Stach" birthday="15-11-1998" positions="dm-cm-cb" nationality="ge" number="18">
				<stats passing="68" tackling="71" shooting="63" crossing="67" heading="72" dribbling="63" speed="63" stamina="71" aggression="69" strength="69" fitness="68" creativity="68"/>
			</player>
			<player id="Ao Tanaka" name="Ao Tanaka" birthday="10-09-1998" positions="dm-cm" nationality="ja" number="22">
				<stats passing="67" tackling="65" shooting="61" crossing="59" heading="57" dribbling="68" speed="62" stamina="73" aggression="60" strength="60" fitness="67" creativity="66"/>
			</player>
			<player id="Gabriel Gudmundsson" name="Gabriel Gudmundsson" birthday="29-04-1999" positions="fb-sm-cb" nationality="sw" number="3">
				<stats passing="63" tackling="64" shooting="59" crossing="64" heading="57" dribbling="65" speed="76" stamina="68" aggression="65" strength="64" fitness="70" creativity="62"/>
			</player>
			<player id="Daniel James" name="Daniel James" birthday="10-11-1997" positions="sm-wf" nationality="wa" number="7">
				<stats passing="61" tackling="43" shooting="64" crossing="63" heading="54" dribbling="69" speed="83" stamina="70" aggression="64" strength="56" fitness="70" creativity="61"/>
			</player>
			<player id="Sean Longstaff" name="Sean Longstaff" birthday="30-10-1997" positions="cm-dm" nationality="en" number="8">
				<stats passing="68" tackling="65" shooting="62" crossing="62" heading="53" dribbling="64" speed="50" stamina="72" aggression="60" strength="58" fitness="61" creativity="68"/>
			</player>
			<player id="Brenden Aaronson" name="Brenden Aaronson" birthday="22-10-2000" positions="am-cm" nationality="un" number="11">
				<stats passing="66" tackling="53" shooting="62" crossing="61" heading="50" dribbling="70" speed="73" stamina="74" aggression="50" strength="53" fitness="68" creativity="66"/>
			</player>
			<player id="Noah Okafor" name="Noah Okafor" birthday="24-05-2000" positions="cf-sm-wf-am" nationality="sw" number="19">
				<stats passing="64" tackling="28" shooting="67" crossing="65" heading="63" dribbling="70" speed="76" stamina="53" aggression="48" strength="67" fitness="65" creativity="65"/>
			</player>
			<player id="Lukas Nmecha" name="Lukas Nmecha" birthday="14-12-1998" positions="cf" nationality="ge" number="14">
				<stats passing="63" tackling="35" shooting="67" crossing="55" heading="69" dribbling="66" speed="65" stamina="66" aggression="61" strength="69" fitness="66" creativity="61"/>
			</player>
			<player id="Jayden Bogle" name="Jayden Bogle" birthday="27-07-2000" positions="fb-sm" nationality="en" number="2">
				<stats passing="63" tackling="63" shooting="52" crossing="62" heading="56" dribbling="66" speed="71" stamina="68" aggression="59" strength="59" fitness="67" creativity="62"/>
			</player>
			<player id="James Justin" name="James Justin" birthday="23-02-1998" positions="fb-sm" nationality="en" number="24">
				<stats passing="62" tackling="64" shooting="50" crossing="62" heading="63" dribbling="62" speed="70" stamina="65" aggression="60" strength="62" fitness="66" creativity="61"/>
			</player>
			<player id="Jaka Bijol" name="Jaka Bijol" birthday="05-02-1999" positions="cb" nationality="sl" number="15">
				<stats passing="64" tackling="67" shooting="54" crossing="50" heading="72" dribbling="55" speed="56" stamina="68" aggression="67" strength="68" fitness="64" creativity="58"/>
			</player>
			<player id="Jack Harrison" name="Jack Harrison" birthday="20-11-1996" positions="sm-wf" nationality="en" number="20">
				<stats passing="63" tackling="42" shooting="63" crossing="67" heading="50" dribbling="68" speed="68" stamina="68" aggression="57" strength="59" fitness="66" creativity="65"/>
			</player>
			<player id="Ilia Gruev" name="Ilia Gruev" birthday="06-05-2000" positions="dm-cm" nationality="bu" number="44">
				<stats passing="68" tackling="65" shooting="53" crossing="61" heading="58" dribbling="64" speed="60" stamina="69" aggression="61" strength="60" fitness="64" creativity="65"/>
			</player>
			<player id="Samuel Byram" name="Samuel Byram" birthday="16-09-1993" positions="fb-sm" nationality="en" number="25">
				<stats passing="60" tackling="63" shooting="53" crossing="57" heading="63" dribbling="61" speed="62" stamina="61" aggression="61" strength="62" fitness="62" creativity="57"/>
			</player>
			<player id="Ethan Ampadu" name="Ethan Ampadu" birthday="14-09-2000" positions="cb-dm" nationality="wa" number="4">
				<stats passing="64" tackling="66" shooting="48" crossing="48" heading="65" dribbling="61" speed="58" stamina="69" aggression="67" strength="66" fitness="65" creativity="58"/>
			</player>
			<player id="Dominic Calvert-Lewin" name="Dominic Calvert-Lewin" birthday="16-03-1997" positions="cf" nationality="en" number="9">
				<stats passing="59" tackling="33" shooting="65" crossing="56" heading="73" dribbling="62" speed="64" stamina="57" aggression="65" strength="70" fitness="62" creativity="57"/>
			</player>
			<player id="Degnand Gnonto" name="Degnand Gnonto" birthday="05-11-2003" positions="sm-wf" nationality="it" number="29">
				<stats passing="64" tackling="28" shooting="67" crossing="58" heading="58" dribbling="73" speed="81" stamina="65" aggression="55" strength="65" fitness="70" creativity="62"/>
			</player>
			<player id="Pascal Struijk" name="Pascal Struijk" birthday="11-08-1999" positions="cb" nationality="ne" number="5">
				<stats passing="62" tackling="67" shooting="44" crossing="45" heading="70" dribbling="58" speed="52" stamina="66" aggression="68" strength="69" fitness="62" creativity="54"/>
			</player>
			<player id="Joël Piroe" name="Joël Piroe" birthday="02-08-1999" positions="cf" nationality="ne" number="10">
				<stats passing="65" tackling="28" shooting="71" crossing="54" heading="66" dribbling="65" speed="58" stamina="68" aggression="45" strength="68" fitness="66" creativity="63"/>
			</player>
			<player id="Sebastiaan Bornauw" name="Sebastiaan Bornauw" birthday="22-03-1999" positions="cb" nationality="be" number="23">
				<stats passing="56" tackling="64" shooting="44" crossing="49" heading="75" dribbling="49" speed="60" stamina="49" aggression="68" strength="68" fitness="56" creativity="49"/>
			</player>
			<player id="Joseph Rodon" name="Joseph Rodon" birthday="22-10-1997" positions="cb" nationality="wa" number="6">
				<stats passing="56" tackling="67" shooting="34" crossing="37" heading="68" dribbling="54" speed="66" stamina="65" aggression="66" strength="68" fitness="66" creativity="42"/>
			</player>
			<player id="Samuel Chambers" name="Samuel Chambers" birthday="18-08-2007" positions="am-sm-cm" nationality="sc" number="42">
				<stats passing="53" tackling="40" shooting="49" crossing="49" heading="40" dribbling="53" speed="63" stamina="46" aggression="39" strength="46" fitness="52" creativity="51"/>
			</player>
			<player id="Lucas Perri" name="Lucas Perri" birthday="10-12-1997" positions="gk" nationality="br" number="1">
				<stats catching="74" shotStopping="76" distribution="74" fitness="75" stamina="36"/>
			</player>
			<player id="Karl Darlow" name="Karl Darlow" birthday="08-10-1990" positions="gk" nationality="wa" number="26">
				<stats catching="64" shotStopping="67" distribution="60" fitness="65" stamina="40"/>
			</player>
			<player id="Illan Meslier" name="Illan Meslier" birthday="02-03-2000" positions="gk" nationality="fr" number="16">
				<stats catching="65" shotStopping="65" distribution="64" fitness="64" stamina="36"/>
			</player>
			<player id="Alexander Cairns" name="Alexander Cairns" birthday="04-01-1993" positions="gk" nationality="en" number="21">
				<stats catching="56" shotStopping="58" distribution="57" fitness="57" stamina="21"/>
			</player>
		</players>
	</club>
	<club shirtColor="0x000000" sleevesColor="0xFFFFFF" stripesType="none" scoreMultiplier="1" attackScore="A" defendScore="B">
		<name><![CDATA[Nottingham Forest]]></name>
		<profile>90</profile>
		<players>
			<player id="Douglas Luiz" name="Douglas Luiz" birthday="09-05-1998" positions="cm-dm" nationality="br" number="12">
				<stats passing="73" tackling="68" shooting="68" crossing="73" heading="60" dribbling="71" speed="60" stamina="66" aggression="67" strength="61" fitness="63" creativity="74"/>
			</player>
			<player id="Elliot Anderson" name="Elliot Anderson" birthday="06-11-2002" positions="dm-cm" nationality="en" number="8">
				<stats passing="70" tackling="68" shooting="61" crossing="69" heading="68" dribbling="71" speed="63" stamina="74" aggression="67" strength="66" fitness="68" creativity="70"/>
			</player>
			<player id="Morgan Gibbs-White" name="Morgan Gibbs-White" birthday="27-01-2000" positions="am-cf" nationality="en" number="10">
				<stats passing="76" tackling="56" shooting="71" crossing="74" heading="61" dribbling="76" speed="69" stamina="72" aggression="63" strength="65" fitness="69" creativity="76"/>
			</player>
			<player id="Oleksandr Zinchenko" name="Oleksandr Zinchenko" birthday="15-12-1996" positions="fb" nationality="uk" number="35">
				<stats passing="72" tackling="70" shooting="64" crossing="74" heading="61" dribbling="72" speed="58" stamina="62" aggression="66" strength="55" fitness="59" creativity="73"/>
			</player>
			<player id="Temitayo Aina" name="Temitayo Aina" birthday="08-10-1996" positions="fb-sm" nationality="ni" number="34">
				<stats passing="65" tackling="70" shooting="59" crossing="65" heading="67" dribbling="67" speed="79" stamina="69" aggression="66" strength="68" fitness="71" creativity="63"/>
			</player>
			<player id="Dan Ndoye" name="Dan Ndoye" birthday="25-10-2000" positions="sm-wf" nationality="sw" number="14">
				<stats passing="66" tackling="60" shooting="68" crossing="68" heading="57" dribbling="74" speed="82" stamina="73" aggression="56" strength="62" fitness="74" creativity="66"/>
			</player>
			<player id="Nicolás Domínguez" name="Nicolás Domínguez" birthday="28-06-1998" positions="dm-cm" nationality="ar" number="16">
				<stats passing="69" tackling="69" shooting="60" crossing="61" heading="64" dribbling="69" speed="63" stamina="77" aggression="75" strength="64" fitness="69" creativity="67"/>
			</player>
			<player id="Callum Hudson-Odoi" name="Callum Hudson-Odoi" birthday="07-11-2000" positions="sm-wf" nationality="en" number="7">
				<stats passing="69" tackling="48" shooting="70" crossing="70" heading="55" dribbling="74" speed="76" stamina="67" aggression="51" strength="60" fitness="68" creativity="71"/>
			</player>
			<player id="Murillo" name="Murillo" birthday="04-07-2002" positions="cb" nationality="br" number="5">
				<stats passing="67" tackling="75" shooting="47" crossing="54" heading="77" dribbling="64" speed="72" stamina="64" aggression="74" strength="77" fitness="69" creativity="60"/>
			</player>
			<player id="Ibrahim Sangaré" name="Ibrahim Sangaré" birthday="02-12-1997" positions="dm-cm" nationality="cô" number="6">
				<stats passing="68" tackling="71" shooting="61" crossing="62" heading="69" dribbling="63" speed="53" stamina="61" aggression="70" strength="73" fitness="61" creativity="66"/>
			</player>
			<player id="Neco Williams" name="Neco Williams" birthday="13-04-2001" positions="fb-sm" nationality="wa" number="3">
				<stats passing="67" tackling="72" shooting="51" crossing="68" heading="65" dribbling="69" speed="67" stamina="68" aggression="68" strength="63" fitness="66" creativity="65"/>
			</player>
			<player id="Omari Hutchinson" name="Omari Hutchinson" birthday="29-10-2003" positions="am-sm-cm" nationality="en" number="21">
				<stats passing="65" tackling="51" shooting="67" crossing="63" heading="50" dribbling="72" speed="73" stamina="67" aggression="52" strength="52" fitness="65" creativity="66"/>
			</player>
			<player id="Christopher Wood" name="Christopher Wood" birthday="07-12-1991" positions="cf" nationality="ne" number="11">
				<stats passing="72" tackling="37" shooting="80" crossing="59" heading="84" dribbling="67" speed="52" stamina="66" aggression="73" strength="76" fitness="65" creativity="69"/>
			</player>
			<player id="Ryan Yates" name="Ryan Yates" birthday="21-11-1997" positions="dm-cm" nationality="en" number="22">
				<stats passing="66" tackling="70" shooting="58" crossing="59" heading="70" dribbling="61" speed="46" stamina="73" aggression="77" strength="69" fitness="63" creativity="63"/>
			</player>
			<player id="Arnaud Kalimuendo" name="Arnaud Kalimuendo" birthday="20-01-2002" positions="cf" nationality="fr" number="15">
				<stats passing="63" tackling="26" shooting="73" crossing="57" heading="69" dribbling="72" speed="73" stamina="68" aggression="57" strength="69" fitness="69" creativity="62"/>
			</player>
			<player id="Dilane Bakwa" name="Dilane Bakwa" birthday="26-08-2002" positions="sm-wf" nationality="fr" number="29">
				<stats passing="69" tackling="30" shooting="69" crossing="70" heading="54" dribbling="75" speed="82" stamina="69" aggression="48" strength="65" fitness="73" creativity="71"/>
			</player>
			<player id="Igor Jesus" name="Igor Jesus" birthday="25-02-2001" positions="cf" nationality="br" number="19">
				<stats passing="63" tackling="33" shooting="70" crossing="54" heading="73" dribbling="65" speed="63" stamina="65" aggression="64" strength="70" fitness="66" creativity="62"/>
			</player>
			<player id="Nikola Milenković" name="Nikola Milenković" birthday="12-10-1997" positions="cb" nationality="se" number="31">
				<stats passing="65" tackling="78" shooting="48" crossing="58" heading="81" dribbling="57" speed="53" stamina="69" aggression="80" strength="75" fitness="66" creativity="56"/>
			</player>
			<player id="James McAtee" name="James McAtee" birthday="18-10-2002" positions="sm-cm-wf" nationality="en" number="24">
				<stats passing="67" tackling="41" shooting="65" crossing="66" heading="48" dribbling="70" speed="68" stamina="61" aggression="43" strength="58" fitness="63" creativity="67"/>
			</player>
			<player id="Taiwo Awoniyi" name="Taiwo Awoniyi" birthday="12-08-1997" positions="cf" nationality="ni" number="9">
				<stats passing="58" tackling="29" shooting="67" crossing="53" heading="73" dribbling="61" speed="63" stamina="53" aggression="67" strength="75" fitness="61" creativity="54"/>
			</player>
			<player id="Jair Cunha" name="Jair Cunha" birthday="07-03-2005" positions="cb" nationality="br" number="23">
				<stats passing="57" tackling="64" shooting="37" crossing="48" heading="70" dribbling="50" speed="58" stamina="60" aggression="66" strength="69" fitness="61" creativity="51"/>
			</player>
			<player id="Nicolò Savona" name="Nicolò Savona" birthday="19-03-2003" positions="fb-sm" nationality="it" number="37">
				<stats passing="57" tackling="65" shooting="44" crossing="56" heading="59" dribbling="57" speed="63" stamina="62" aggression="62" strength="61" fitness="62" creativity="46"/>
			</player>
			<player id="Morato" name="Morato" birthday="30-06-2001" positions="cb-fb-sm" nationality="br" number="4">
				<stats passing="58" tackling="69" shooting="38" crossing="51" heading="72" dribbling="54" speed="48" stamina="57" aggression="73" strength="73" fitness="58" creativity="51"/>
			</player>
			<player id="Willy-Arnaud Boly" name="Willy-Arnaud Boly" birthday="03-02-1991" positions="cb" nationality="cô" number="30">
				<stats passing="64" tackling="72" shooting="41" crossing="52" heading="73" dribbling="53" speed="33" stamina="38" aggression="73" strength="75" fitness="46" creativity="58"/>
			</player>
			<player id="Zach Abbott" name="Zach Abbott" birthday="13-05-2006" positions="cb" nationality="en" number="44">
				<stats passing="46" tackling="50" shooting="30" crossing="33" heading="50" dribbling="42" speed="48" stamina="47" aggression="51" strength="50" fitness="48" creativity="40"/>
			</player>
			<player id="Matz Sels" name="Matz Sels" birthday="26-02-1992" positions="gk" nationality="be" number="26">
				<stats catching="79" shotStopping="81" distribution="78" fitness="82" stamina="26"/>
			</player>
			<player id="Angus Gunn" name="Angus Gunn" birthday="22-01-1996" positions="gk" nationality="sc" number="18">
				<stats catching="66" shotStopping="68" distribution="65" fitness="65" stamina="29"/>
			</player>
			<player id="John Victor" name="John Victor" birthday="13-02-1996" positions="gk" nationality="br" number="13">
				<stats catching="64" shotStopping="72" distribution="63" fitness="65" stamina="18"/>
			</player>
		</players>
	</club>
	<club shirtColor="0xFF0000" sleevesColor="0xFFFFFF" stripesType="none">
		<name><![CDATA[Middlesbrough]]></name>
		<profile>60</profile>
		<players>
			<player id="Jason Steele" name="Jason Steele" birthday="18-08-2005" positions="gk" nationality="en" number="30">
				<stats catching="75" shotStopping="80" distribution="50" fitness="70" stamina="60"/>
			</player>
			<player id="Justin Hoyte" name="Justin Hoyte" birthday="20-11-1999" positions="fb" nationality="en" number="2">
				<stats passing="55" tackling="55" shooting="54" crossing="45" heading="50" dribbling="70" speed="65" stamina="70" aggression="55" strength="70" fitness="50" creativity="60"/>	
			</player>	
			<player id="Marvin Emnes" name="Marvin Emnes" birthday="27-05-2003" positions="sm" nationality="ne" number="32">
				<stats passing="53" tackling="60" shooting="40" crossing="60" heading="63" dribbling="45" speed="65" stamina="68" aggression="58" strength="63" fitness="75" creativity="56"/>
			</player>
			<player id="Matthew Bates" name="Matthew Bates" birthday="10-12-2001" positions="dm-cb" nationality="en" number="4">
				<stats passing="75" tackling="45" shooting="53" crossing="58" heading="35" dribbling="63" speed="64" stamina="67" aggression="46" strength="47" fitness="64" creativity="57"/>
			</player>
			<player id="David Wheater" name="David Wheater" birthday="14-02-2002" positions="cb-fb" nationality="en" number="5">
				<stats passing="65" tackling="68" shooting="56" crossing="46" heading="67" dribbling="56" speed="72" stamina="66" aggression="72" strength="68" fitness="75" creativity="45"/>				
			</player>
			<player id="Stephen McManus" name="Stephen McManus" birthday="10-09-1997" positions="cb" nationality="sc" number="6">
				<stats passing="55" tackling="56" shooting="40" crossing="52" heading="57" dribbling="43" speed="68" stamina="67" aggression="65" strength="57" fitness="68" creativity="45"/>				
			</player>
			<player id="Scott McDonald" name="Scott McDonald" birthday="21-08-1998" positions="cf" nationality="en" number="7">
				<stats passing="68" tackling="46" shooting="64" crossing="63" heading="34" dribbling="67" speed="61" stamina="58" aggression="48" strength="56" fitness="37" creativity="74"/>
			</player>
			<player id="Kevin Thomson" name="Kevin Thomson" birthday="14-10-1999" positions="cm" nationality="sc" number="8">
				<stats passing="72" tackling="43" shooting="68" crossing="67" heading="43" dribbling="75" speed="64" stamina="64" aggression="57" strength="42" fitness="60" creativity="56"/>
			</player>
			<player id="Kris Boyd" name="Kris Boyd" birthday="18-08-1998" positions="cf" nationality="sc" number="9">
				<stats passing="65" tackling="56" shooting="69" crossing="67" heading="67" dribbling="73" speed="65" stamina="67" aggression="69" strength="60" fitness="60" creativity="67"/>
			</player>
			<player id="Nicky Bailey" name="Nicky Bailey" birthday="10-06-1999" positions="cm" nationality="en" number="10">
				<stats passing="65" tackling="56" shooting="69" crossing="67" heading="67" dribbling="73" speed="65" stamina="67" aggression="69" strength="60" fitness="60" creativity="67"/>
			</player>
			<player id="Tarmo Kink" name="Tarmo Kink" birthday="06-10-2000" positions="sm-cf" nationality="es" number="11">
				<stats passing="53" tackling="34" shooting="62" crossing="67" heading="45" dribbling="69" speed="64" stamina="68" aggression="45" strength="49" fitness="61" creativity="64"/>	
			</player>
			<player id="Willo Flood" name="Willo Flood" birthday="10-04-2000" positions="cm-sm" nationality="ir" number="14">
				<stats passing="73" tackling="56" shooting="61" crossing="63" heading="45" dribbling="58" speed="68" stamina="68" aggression="64" strength="62" fitness="64" creativity="63"/>
			</player>
			<player id="Leroy Lita" name="Leroy Lita" birthday="28-12-1999" positions="cf" nationality="co" number="15">
				<stats passing="71" tackling="61" shooting="68" crossing="67" heading="45" dribbling="65" speed="68" stamina="67" aggression="68" strength="69" fitness="60" creativity="57"/>	
			</player>
			<player id="Barry Robson" name="Barry Robson" birthday="07-11-1993" positions="cm-sm-fb" nationality="sc" number="17">
				<stats passing="71" tackling="61" shooting="68" crossing="67" heading="45" dribbling="65" speed="68" stamina="67" aggression="68" strength="69" fitness="60" creativity="57"/>	
			</player>
			<player id="Gary O'Neill" name="Gary O'Neill" birthday="18-05-1998" positions="sm-cm" nationality="en" number="18">
				<stats passing="40" tackling="69" shooting="56" crossing="56" heading="56" dribbling="66" speed="61" stamina="67" aggression="64" strength="66" fitness="69" creativity="55"/>		
			</player>
			<player id="Andrew Halliday" name="Andrew Halliday" birthday="11-10-2006" positions="sm" nationality="sc" number="19">
				<stats passing="57" tackling="69" shooting="43" crossing="53" heading="67" dribbling="31" speed="67" stamina="77" aggression="67" strength="72" fitness="74" creativity="46"/>		
			</player>
			<player id="Julio Arca" name="Julio Arca" birthday="31-01-1996" positions="sm-cm" nationality="ar" number="20">
				<stats passing="50" tackling="67" shooting="58" crossing="45" heading="72" dribbling="42" speed="64" stamina="56" aggression="64" strength="63" fitness="34" creativity="41"/>	
			</player>
			<player id="Danny Coyne" name="Danny Coyne" birthday="27-08-1988" positions="gk" nationality="we" number="21">
				<stats catching="50" shotStopping="76" distribution="60" fitness="67" stamina="84"/>		
			</player>
			<player id="Seb Hines" name="Seb Hines" birthday="29-05-2003" positions="cb-dm" nationality="en" number="24">
				<stats passing="59" tackling="68" shooting="38" crossing="47" heading="53" dribbling="55" speed="69" stamina="72" aggression="64" strength="56" fitness="78" creativity="67"/>		
			</player>
			<player id="Rhys Williams" name="Rhys Williams" birthday="14-07-2003" positions="fb-sm-cm" nationality="au" number="25">
				<stats passing="67" tackling="27" shooting="74" crossing="57" heading="23" dribbling="72" speed="73" stamina="43" aggression="48" strength="34" fitness="67" creativity="73"/>		
			</player>
			<player id="Joe Bennett" name="Joe Bennett" birthday="28-03-2005" positions="fb-sm" nationality="en" number="27">
				<stats passing="69" tackling="67" shooting="45" crossing="56" heading="59" dribbling="71" speed="72" stamina="65" aggression="46" strength="59" fitness="70" creativity="67"/>		
			</player>
			<player id="Tony McMahon" name="Tony McMahon" birthday="24-03-2001" positions="fb" nationality="en" number="29">
				<stats passing="65" tackling="67" shooting="67" crossing="56" heading="56" dribbling="64" speed="62" stamina="67" aggression="57" strength="67" fitness="67" creativity="73"/>
			</player>
		</players>	
	</club>
	<club shirtColor="0xFF0000" sleevesColor="0xFFFFFF" stripesType="none">
		<name><![CDATA[Derby County]]></name>
		<profile>65</profile>
		<players>
			<player id="Stephen Bywater" name="Stephen Bywater" birthday="07-01-1996" positions="gk" nationality="en" number="1">
				<stats catching="75" shotStopping="80" distribution="50" fitness="70" stamina="60"/>
			</player>
			<player id="John Brayford" name="John Brayford" birthday="29-12-2002" positions="fb" nationality="en" number="2">
				<stats passing="55" tackling="55" shooting="54" crossing="45" heading="50" dribbling="70" speed="65" stamina="70" aggression="55" strength="70" fitness="50" creativity="60"/>	
			</player>	
			<player id="Gareth Roberts" name="Gareth Roberts" birthday="06-02-1993" positions="fb" nationality="we" number="3">
				<stats passing="53" tackling="60" shooting="40" crossing="60" heading="63" dribbling="45" speed="65" stamina="68" aggression="58" strength="63" fitness="75" creativity="56"/>
			</player>
			<player id="Paul Green" name="Paul Green" birthday="10-04-1998" positions="cm-am" nationality="ir" number="4">
				<stats passing="75" tackling="45" shooting="53" crossing="58" heading="35" dribbling="63" speed="64" stamina="67" aggression="46" strength="47" fitness="64" creativity="57"/>
			</player>
			<player id="Shaun Barker" name="Shaun Barker" birthday="19-09-1997" positions="cb" nationality="en" number="5">
				<stats passing="65" tackling="68" shooting="56" crossing="46" heading="67" dribbling="56" speed="72" stamina="66" aggression="72" strength="68" fitness="75" creativity="45"/>				
			</player>
			<player id="Dean Leacock" name="Dean Leacock" birthday="10-06-1999" positions="cb-fb" nationality="en" number="6">
				<stats passing="55" tackling="56" shooting="40" crossing="52" heading="57" dribbling="43" speed="68" stamina="67" aggression="65" strength="57" fitness="68" creativity="45"/>				
			</player>
			<player id="Steve Davies" name="Steve Davies" birthday="29-12-2002" positions="am-wf-cf" nationality="en" number="7">
				<stats passing="68" tackling="46" shooting="64" crossing="63" heading="34" dribbling="67" speed="61" stamina="58" aggression="48" strength="56" fitness="37" creativity="74"/>
			</player>
			<player id="Robbie Savage" name="Robbie Savage" birthday="18-10-1989" positions="dm-cm" nationality="we" number="8">
				<stats passing="72" tackling="43" shooting="68" crossing="67" heading="43" dribbling="75" speed="64" stamina="64" aggression="57" strength="42" fitness="60" creativity="56"/>
			</player>
			<player id="Kris Commons" name="Kris Commons" birthday="30-08-1998" positions="am-cf-wf" nationality="sc" number="10">
				<stats passing="65" tackling="56" shooting="69" crossing="67" heading="67" dribbling="73" speed="65" stamina="67" aggression="69" strength="60" fitness="60" creativity="67"/>
			</player>
			<player id="Stephen Pearson" name="Stephen Pearson" birthday="02-10-1997" positions="cm-am" nationality="sc" number="11">
				<stats passing="53" tackling="34" shooting="62" crossing="67" heading="45" dribbling="69" speed="64" stamina="68" aggression="45" strength="49" fitness="61" creativity="64"/>	
			</player>
			<player id="Chris Porter" name="Chris Porter" birthday="12-12-1998" positions="cf" nationality="en" number="12">
				<stats passing="49" tackling="32" shooting="64" crossing="68" heading="43" dribbling="66" speed="84" stamina="45" aggression="37" strength="46" fitness="57" creativity="51"/>	
			</player>
			<player id="Russell Anderson" name="Russell Anderson" birthday="25-10-1993" positions="cm-dm" nationality="sc" number="14">
				<stats passing="73" tackling="56" shooting="61" crossing="63" heading="45" dribbling="58" speed="68" stamina="68" aggression="64" strength="62" fitness="64" creativity="63"/>
			</player>
			<player id="David Martin" name="David Martin" birthday="03-06-2000" positions="am" nationality="en" number="16">
				<stats passing="71" tackling="61" shooting="68" crossing="67" heading="45" dribbling="65" speed="68" stamina="67" aggression="68" strength="69" fitness="60" creativity="57"/>	
			</player>
			<player id="James Bailey" name="James Bailey" birthday="18-09-2003" positions="fb-cm" nationality="en" number="16">
				<stats passing="40" tackling="69" shooting="56" crossing="56" heading="56" dribbling="66" speed="61" stamina="67" aggression="64" strength="66" fitness="69" creativity="55"/>		
			</player>
			<player id="Jake Buxton" name="Jake Buxton" birthday="11-08-1995" positions="cb" nationality="fr" number="18">
				<stats passing="57" tackling="69" shooting="43" crossing="53" heading="67" dribbling="31" speed="67" stamina="77" aggression="67" strength="72" fitness="74" creativity="46"/>		
			</player>
			<player id="Ben Pringle" name="Ben Pringle" birthday="01-01-2007" positions="cm-am-wf" nationality="en" number="19">
				<stats passing="78" tackling="56" shooting="61" crossing="67" heading="25" dribbling="73" speed="69" stamina="67" aggression="69" strength="68" fitness="70" creativity="73"/>		
			</player>
			<player id="Tomasz Cywka" name="Tomasz Cywka" birthday="01-18-2002" positions="cb-fb" nationality="sw" number="20">
				<stats passing="50" tackling="67" shooting="58" crossing="45" heading="72" dribbling="42" speed="64" stamina="56" aggression="64" strength="63" fitness="34" creativity="41"/>	
			</player>
			<player id="Saul Deeney" name="Saul Deeney" birthday="23-03-1998" positions="gk" nationality="ir" number="13">
				<stats catching="50" shotStopping="76" distribution="60" fitness="67" stamina="84"/>		
			</player>
			<player id="Miles Addison" name="Miles Addison" birthday="26-07-2000" positions="fb" nationality="fr" number="22">
				<stats passing="59" tackling="68" shooting="38" crossing="47" heading="53" dribbling="55" speed="69" stamina="72" aggression="64" strength="56" fitness="78" creativity="67"/>		
			</player>
			<player id="Dean Moxey" name="Dean Moxey" birthday="29-05-1996" positions="am-wf" nationality="ru" number="23">
				<stats passing="67" tackling="27" shooting="74" crossing="57" heading="23" dribbling="72" speed="73" stamina="43" aggression="48" strength="34" fitness="67" creativity="73"/>		
			</player>
			<player id="Conor Doyle" name="Conor Doyle" birthday="04-06-1998" positions="fb-sm" nationality="iv" number="27">
				<stats passing="69" tackling="67" shooting="45" crossing="56" heading="59" dribbling="71" speed="72" stamina="65" aggression="46" strength="59" fitness="70" creativity="67"/>		
			</player>
			<player id="Alberto Bueno" name="Alberto Bueno" birthday="26-09-2004" positions="fb-sm" nationality="en" number="28">
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
         updateLeagueEntrants(_loc2_,["Coventry City","Middlesbrough","Preston North End","Millwall","Ipswich Town","Hull City","Stoke City","Leicester City","QPR","Southampton","Bristol City","Birmingham City","Watford","Wrexham","WBA","Derby County","Charlton Athletic","Sheffield United","Swansea City","Blackburn Rovers","Portsmouth","Oxford United","Norwich City","Sheffield Wednesday"],70);
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
			<player id="Iker Casillas" name="Iker Casillas" birthday="20-05-1996" positions="gk" nationality="es" number="1">
				<stats catching="84" shotStopping="85" distribution="78" fitness="75" stamina="85"/>
			</player>
			<player id="Ricardo Carvalho" name="Ricardo Carvalho" birthday="18-05-1993" positions="fb" nationality="pr" number="2">
				<stats passing="59" tackling="65" shooting="40" crossing="69" heading="54" dribbling="70" speed="89" stamina="64" aggression="70" strength="59" fitness="83" creativity="63"/>	
			</player>	
			<player id="Pepe" name="Pepe" birthday="26-02-1998" positions="fb" nationality="pr" number="3">
				<stats passing="53" tackling="70" shooting="33" crossing="70" heading="55" dribbling="54" speed="60" stamina="77" aggression="69" strength="44" fitness="73" creativity="64"/>
			</player>
			<player id="Fernando Gago" name="Fernando Gago" birthday="10-04-2001" positions="dm" nationality="ar" number="5">
				<stats passing="77" tackling="84" shooting="40" crossing="59" heading="77" dribbling="49" speed="65" stamina="79" aggression="59" strength="79" fitness="49" creativity="64"/>
			</player>
			<player id="Sergio Ramos" name="Sergio Ramos" birthday="30-03-2001" positions="fb" nationality="es" number="4">
				<stats passing="65" tackling="85" shooting="45" crossing="65" heading="50" dribbling="65" speed="85" stamina="90" aggression="80" strength="60" fitness="90" creativity="55"/>				
			</player>
			<player id="Marcelo" name="Marcelo" birthday="12-05-2003" positions="fb-cb-sm" nationality="br" number="12">
				<stats passing="63" tackling="80" shooting="35" crossing="30" heading="91" dribbling="45" speed="50" stamina="75" aggression="80" strength="80" fitness="81" creativity="53"/>				
			</player>
			<player id="Mahamadou Diarra" name="Mahamadou Diarra" birthday="18-05-1996" positions="dm" nationality="ma" number="6">
				<stats passing="77" tackling="70" shooting="50" crossing="27" heading="83" dribbling="46" speed="57" stamina="72" aggression="58" strength="82" fitness="74" creativity="62"/>
			</player>
			<player id="Angel di Maria" name="Angel di Maria" birthday="14-02-2003" positions="sm" nationality="ar" number="22">
				<stats passing="66" tackling="67" shooting="44" crossing="77" heading="17" dribbling="75" speed="89" stamina="82" aggression="74" strength="43" fitness="67" creativity="62"/>
			</player>
			<player id="Mesut Ozil" name="Mesut Ozil" birthday="15-10-2003" positions="am-sm-cm" nationality="ge" number="23">
				<stats passing="82" tackling="64" shooting="72" crossing="64" heading="57" dribbling="54" speed="79" stamina="100" aggression="89" strength="86" fitness="100" creativity="69"/>
			</player>
			<player id="Cristiano Ronaldo" name="Cristiano Ronaldo" birthday="05-02-2000" positions="sm-wf-cf" nationality="pr" number="7">
				<stats passing="79" tackling="54" shooting="86" crossing="80" heading="76" dribbling="97" speed="94" stamina="88" aggression="66" strength="60" fitness="83" creativity="90"/>	
			</player>
			<player id="Kaka" name="Kaka" birthday="22-04-1997" positions="am-cm" nationality="br" number="8">
				<stats passing="88" tackling="67" shooting="80" crossing="79" heading="65" dribbling="80" speed="79" stamina="78" aggression="63" strength="53" fitness="79" creativity="63"/>	
			</player>
			<player id="Esteban Granero" name="Esteban Granero" birthday="02-07-2002" positions="cm-am" nationality="es" number="11">
				<stats passing="80" tackling="31" shooting="54" crossing="62" heading="27" dribbling="79" speed="68" stamina="71" aggression="33" strength="29" fitness="68" creativity="71"/>
			</player>
			<player id="Sergio Canales" name="Sergio Canales" birthday="16-02-2006" positions="am" nationality="es" number="16">
				<stats passing="64" tackling="38" shooting="73" crossing="76" heading="59" dribbling="58" speed="74" stamina="88" aggression="31" strength="57" fitness="70" creativity="75"/>	
			</player>
			<player id="Xabi Alonso" name="Xavi Alonso" birthday="25-11-1996" positions="cm" nationality="es" number="14">
				<stats passing="84" tackling="51" shooting="82" crossing="51" heading="59" dribbling="61" speed="63" stamina="88" aggression="63" strength="63" fitness="96" creativity="81"/>		
			</player>
			<player id="Pedro Leon" name="Pedro Leon" birthday="24-11-2001" positions="sm" nationality="es" number="21">
				<stats passing="54" tackling="33" shooting="53" crossing="63" heading="64" dribbling="65" speed="75" stamina="77" aggression="38" strength="55" fitness="80" creativity="65"/>		
			</player>
			<player id="Karim Benzema" name="Karim Benzema" birthday="19-12-2002" positions="cf" nationality="fr" number="9">
				<stats passing="54" tackling="36" shooting="88" crossing="63" heading="59" dribbling="71" speed="80" stamina="65" aggression="67" strength="64" fitness="84" creativity="67"/>		
			</player>
			<player id="Lassana Diarra" name="Lassana Diarra" birthday="10-03-2000" positions="dm" nationality="fr" number="10">
				<stats passing="77" tackling="80" shooting="65" crossing="34" heading="42" dribbling="68" speed="80" stamina="69" aggression="54" strength="58" fitness="75" creativity="62"/>	
			</player>
			<player id="Antonio Adan" name="Antonio Adan" birthday="13-05-2002" positions="gk" nationality="es" number="13">
				<stats catching="70" shotStopping="75" distribution="63" fitness="75" stamina="71"/>		
			</player>
			<player id="Gonzalo Higuain" name="Gonzalo Higuain" birthday="10-12-2002" positions="cf" nationality="ar" number="20">
				<stats passing="55" tackling="34" shooting="89" crossing="75" heading="91" dribbling="65" speed="75" stamina="80" aggression="68" strength="100" fitness="91" creativity="55"/>		
			</player>
			<player id="Jerzy Dudek" name="Jerzy Dudek" birthday="23-03-1988" positions="gk" nationality="po" number="26">
				<stats catching="80" shotStopping="88" distribution="64" fitness="39" stamina="55"/>		
			</player>
		</players>
	</club>

<club shirtColor="0xFF0000" sleevesColor="0xFFFFFF" stripesType="none">
		<name><![CDATA[Barcelona]]></name>
		<profile>95</profile>
		<players>
			<player id="Victor Valdes" name="Victor Valdes" birthday="14-01-1997" positions="gk" nationality="es" number="1">
				<stats catching="84" shotStopping="74" distribution="85" fitness="52" stamina="59"/>
			</player>
			<player id="Gabriel Milito" name="Gabriel Milito" birthday="07-09-1995" positions="cb" nationality="ar" number="182">
				<stats passing="51" tackling="68" shooting="24" crossing="53" heading="78" dribbling="34" speed="59" stamina="71" aggression="41" strength="78" fitness="63" creativity="34"/>	
			</player>	
			<player id="Gerald Pique" name="Gerald Pique" birthday="02-02-2002" positions="fb" nationality="es" number="3">
				<stats passing="43" tackling="88" shooting="3" crossing="52" heading="83" dribbling="32" speed="68" stamina="79" aggression="78" strength="76" fitness="68" creativity="22"/>
			</player>
			<player id="Carles Puyol" name="Carles Puyol" birthday="13-04-1993" positions="cb" nationality="es" number="5">
				<stats passing="64" tackling="79" shooting="17" crossing="23" heading="79" dribbling="48" speed="72" stamina="69" aggression="36" strength="72" fitness="49" creativity="44"/>
			</player>
			<player id="Adriano" name="Adriano" birthday="26-10-1999" positions="cb-cm" nationality="br" number="21">
				<stats passing="62" tackling="74" shooting="32" crossing="24" heading="76" dribbling="32" speed="58" stamina="69" aggression="58" strength="69" fitness="74" creativity="38"/>				
			</player>
			<player id="Eric Abidal" name="Eric Abidal" birthday="11-09-1994" positions="cb-fb" nationality="fr" number="22">
				<stats passing="54" tackling="84" shooting="26" crossing="12" heading="95" dribbling="17" speed="58" stamina="79" aggression="88" strength="89" fitness="77" creativity="31"/>				
			</player>
			<player id="Fabio" name="Fabio" birthday="09-070-2005" positions="fb" nationality="br" number="20">
				<stats passing="52" tackling="54" shooting="54" crossing="62" heading="48" dribbling="64" speed="83" stamina="49" aggression="62" strength="41" fitness="68" creativity="37"/>
			</player>
			<player id="Daniel Alves" name="Daniel Alves" birthday="06-05-1998" positions="fb" nationality="br" number="2">
				<stats passing="65" tackling="77" shooting="42" crossing="73" heading="69" dribbling="73" speed="88" stamina="89" aggression="74" strength="52" fitness="82" creativity="34"/>
			</player>
			<player id="Javier Mascherano" name="Javier Mascherano" birthday="08-06-1999" positions="dm-cm" nationality="ar" number="14">
				<stats passing="87" tackling="64" shooting="58" crossing="52" heading="51" dribbling="32" speed="59" stamina="72" aggression="29" strength="62" fitness="71" creativity="77"/>
			</player>
			<player id="Sergio Busquets" name="Sergio Busquets" birthday="16-07-2003" positions="dm-cm" nationality="es" number="16">
				<stats passing="63" tackling="79" shooting="53" crossing="83" heading="37" dribbling="47" speed="75" stamina="88" aggression="83" strength="68" fitness="64" creativity="47"/>	
			</player>
			<player id="Seydou Keita" name="Seydou Keita" birthday="16-01-1995" positions="cm" nationality="ma" number="15">
				<stats passing="73" tackling="74" shooting="42" crossing="74" heading="74" dribbling="32" speed="58" stamina="98" aggression="83" strength="75" fitness="82" creativity="67"/>	
			</player>
						<player id="Xavi" name="Xavi" birthday="25-01-1995" positions="cm" nationality="es" number="6">
				<stats passing="93" tackling="24" shooting="74" crossing="59" heading="72" dribbling="64" speed="41" stamina="38" aggression="68" strength="39" fitness="49" creativity="92"/>	
			</player>
						<player id="Andres Iniesta" name="Andres Iniesta" birthday="11-05-1999" positions="sm-cm-am" nationality="es" number="8">
				<stats passing="78" tackling="52" shooting="68" crossing="69" heading="38" dribbling="84" speed="66" stamina="54" aggression="50" strength="57" fitness="56" creativity="84"/>	
			</player>
			<player id="Jose Pinto" name="Jose Pinto" birthday="08-11-1990" positions="gk" nationality="es" number="13">
				<stats catching="74" shotStopping="83" distribution="54" fitness="74" stamina="58"/>		
			</player>
			<player id="Lionel Messi" name="Lionel Messi" birthday="24-06-2002" positions="cf-sm-am" nationality="ar" number="10">
				<stats passing="91" tackling="68" shooting="95" crossing="86" heading="55" dribbling="94" speed="82" stamina="88" aggression="23" strength="68" fitness="75" creativity="99"/>		
			</player>
			<player id="Bojan Krkic" name="Bojan Krkic" birthday="28-08-2005" positions="cf" nationality="es" number="9">
				<stats passing="58" tackling="34" shooting="82" crossing="58" heading="76" dribbling="54" speed="65" stamina="70" aggression="48" strength="50" fitness="51" creativity="53"/>		
			</player>
			<player id="Pedro Rodriguez" name="Pedro Rodriguez" birthday="28-07-2002" positions="cf-sm" nationality="es" number="17">
				<stats passing="59" tackling="25" shooting="74" crossing="44" heading="78" dribbling="55" speed="77" stamina="68" aggression="50" strength="34" fitness="73" creativity="57"/>		
			</player>
			<player id="David Villa" name="David Villa" birthday="03-12-1996" positions="cf" nationality="es" number="7">
				<stats passing="79" tackling="39" shooting="84" crossing="74" heading="75" dribbling="59" speed="78" stamina="91" aggression="85" strength="78" fitness="82" creativity="79"/>		
			</player>
			<player id="Jeffren Suarez" name="Jeffren Suarez" birthday="20-01-2003" positions="sm" nationality="es" number="11">
				<stats passing="77" tackling="11" shooting="68" crossing="79" heading="56" dribbling="53" speed="69" stamina="46" aggression="38" strength="63" fitness="66" creativity="52"/>		
			</player>
			</players>
	</club>


<club shirtColor="0xFF0000" sleevesColor="0xFFFFFF" stripesType="none">
		<name><![CDATA[Bayern Munich]]></name>
		<profile>90</profile>
		<players>
			<player id="Hans Jorg Butt" name="Hans Jorg Butt" birthday="28-05-1989" positions="gk" nationality="ge" number="1">
				<stats catching="75" shotStopping="71" distribution="65" fitness="70" stamina="80"/>
			</player>
			<player id="Breno Borges" name="Breno Borges" birthday="13-10-2004" positions="cb" nationality="br" number="2">
				<stats passing="54" tackling="68" shooting="56" crossing="64" heading="75" dribbling="38" speed="74" stamina="68" aggression="54" strength="94" fitness="55" creativity="64"/>	
			</player>	
			<player id="Diego Contento" name="Diego Contento" birthday="01-05-2005" positions="fb" nationality="ge" number="26">
				<stats passing="52" tackling="64" shooting="24" crossing="58" heading="60" dribbling="43" speed="79" stamina="58" aggression="50" strength="54" fitness="89" creativity="39"/>
			</player>
			<player id="Danijel Pranjic" name="Danijel Pranjic" birthday="02-12-1996" positions="fb-dm" nationality="cr" number="23">
				<stats passing="54" tackling="74" shooting="38" crossing="54" heading="75" dribbling="54" speed="59" stamina="70" aggression="68" strength="68" fitness="68" creativity="48"/>
			</player>
			<player id="Edson Braafheid" name="Edson Braafheid" birthday="08-04-1998" positions="fb" nationality="ne" number="4">
				<stats passing="54" tackling="75" shooting="29" crossing="43" heading="79" dribbling="38" speed="75" stamina="78" aggression="75" strength="75" fitness="78" creativity="43"/>				
			</player>
			<player id="Holger Badstuber" name="Holger Badstuber" birthday="13-03-2004" positions="cb-fb" nationality="ge" number="28">
				<stats passing="58" tackling="84" shooting="49" crossing="23" heading="79" dribbling="54" speed="67" stamina="79" aggression="74" strength="74" fitness="75" creativity="45"/>				
			</player>
			<player id="Daniel Van Buyten" name="Daniel Van Buyten" birthday="07-02-1993" positions="cb" nationality="ne" number="5">
				<stats passing="57" tackling="75" shooting="20" crossing="19" heading="84" dribbling="18" speed="58" stamina="79" aggression="68" strength="73" fitness="70" creativity="54"/>
			</player>
			<player id="Martin Demichelis" name="Martin Demichelis" birthday="20-12-1995" positions="cb" nationality="ar" number="6">
				<stats passing="53" tackling="80" shooting="12" crossing="26" heading="73" dribbling="39" speed="68" stamina="44" aggression="69" strength="84" fitness="30" creativity="44"/>
			</player>
			<player id="Philipp Lahm" name="Philipp Lahm" birthday="11-11-1998" positions="fb" nationality="ge" number="21">
				<stats passing="65" tackling="64" shooting="63" crossing="75" heading="74" dribbling="70" speed="70" stamina="78" aggression="23" strength="62" fitness="73" creativity="65"/>	
			</player>
			<player id="Andreas Ottl" name="Andreas Ottl" birthday="01-03-2000" positions="dm" nationality="ge" number="16">
				<stats passing="77" tackling="64" shooting="54" crossing="52" heading="59" dribbling="60" speed="43" stamina="75" aggression="70" strength="90" fitness="78" creativity="79"/>
			</player>
			<player id="Mark van Bommel" name="Mark van Bommel" birthday="22-04-1992" positions="cm-dm" nationality="ne" number="17">
				<stats passing="63" tackling="64" shooting="55" crossing="60" heading="58" dribbling="59" speed="75" stamina="75" aggression="54" strength="64" fitness="70" creativity="57"/>	
			</player>
			<player id="Anatoliy Tymoshchuk" name="Anatoliy Tymoshchuk" birthday="30-03-1994" positions="cm-sm" nationality="uk" number="44">
				<stats passing="68" tackling="53" shooting="57" crossing="64" heading="37" dribbling="53" speed="56" stamina="75" aggression="54" strength="52" fitness="67" creativity="70"/>		
			</player>
			<player id="Hamit Altintop" name="Hamit Altintop" birthday="08-12-1997" positions="cm" nationality="tu" number="8">
				<stats passing="53" tackling="79" shooting="45" crossing="34" heading="78" dribbling="74" speed="80" stamina="87" aggression="70" strength="84" fitness="59" creativity="54"/>		
			</player>
			<player id="Bastien Schweinsteiger" name="Bastien Schweinsteiger" birthday="01-08-1999" positions="cm-am-sm" nationality="ge" number="31">
				<stats passing="74" tackling="41" shooting="44" crossing="58" heading="34" dribbling="78" speed="68" stamina="90" aggression="59" strength="46" fitness="78" creativity="84"/>		
			</player>
			<player id="Frank Ribery" name="Frank Ribery" birthday="07-04-1998" positions="sm" nationality="fr" number="7">
				<stats passing="84" tackling="38" shooting="79" crossing="75" heading="28" dribbling="69" speed="54" stamina="75" aggression="53" strength="50" fitness="62" creativity="78"/>	
			</player>
			<player id="Arjen Robben" name="Arjen Robben" birthday="23-01-1999" positions="cm-sm-am-cf" nationality="ne" number="5">
				<stats passing="79" tackling="44" shooting="83" crossing="80" heading="72" dribbling="52" speed="86" stamina="75" aggression="58" strength="65" fitness="83" creativity="75"/>		
			</player>
			<player id="Toni Kroos" name="Toni Kroos" birthday="04-01-2005" positions="sm-am" nationality="ge" number="39">
				<stats passing="68" tackling="34" shooting="47" crossing="70" heading="34" dribbling="79" speed="84" stamina="64" aggression="21" strength="38" fitness="75" creativity="70"/>		
			</player>
						<player id="Mario Gomez" name="Mario Gomez" birthday="10-07-2000" positions="cf" nationality="ge" number="33">
				<stats passing="70" tackling="50" shooting="79" crossing="44" heading="80" dribbling="54" speed="64" stamina="79" aggression="60" strength="65" fitness="94" creativity="64"/>		
			</player>
			<player id="Miroslav Klose" name="Miroslav Klose" birthday="09-06-1993" positions="cf" nationality="ge" number="18">
				<stats passing="59" tackling="41" shooting="79" crossing="45" heading="78" dribbling="64" speed="60" stamina="80" aggression="60" strength="70" fitness="75" creativity="70"/>		
			</player>
			<player id="Ivica Olic" name="Ivica Olic" birthday="14-09-1994" positions="cf" nationality="cr" number="11">
				<stats passing="64" tackling="39" shooting="74" crossing="64" heading="36" dribbling="73" speed="67" stamina="85" aggression="23" strength="54" fitness="75" creativity="75"/>		
			</player>
			<player id="Thomas Muller" name="Thomas Muller" birthday="13-09-2004" positions="cf-sm" nationality="ge" number="25">
				<stats passing="64" tackling="33" shooting="76" crossing="47" heading="64" dribbling="54" speed="59" stamina="68" aggression="44" strength="87" fitness="69" creativity="70"/>		
			</player>

			<player id="Rouven Sattelmaier" name="Rouven Sattelmaier" birthday="07-08-2002" positions="gk" nationality="ge" number="22">
				<stats catching="71" shotStopping="68" distribution="29" fitness="70" stamina="75"/>		
			</player>
		</players>
	</club>


<club shirtColor="0xFF0000" sleevesColor="0xFFFFFF" stripesType="none">
		<name><![CDATA[Schalke 04]]></name>
		<profile>75</profile>
		<players>
			<player id="Manuel Neuer" name="Manuel Neuer" birthday="27-03-2001" positions="gk" nationality="ge" number="1">
				<stats catching="66" shotStopping="70" distribution="50" fitness="70" stamina="70"/>
			</player>
			<player id="Benedikt Howedes" name="Benedikt Howedes" birthday="29-02-2003" positions="cb-dm" nationality="cb-dm" number="4">
				<stats passing="20" tackling="75" shooting="20" crossing="15" heading="75" dribbling="15" speed="60" stamina="70" aggression="60" strength="75" fitness="75" creativity="35"/>	
			</player>	
			<player id="Nicolas Plestan" name="Nicolas Plestan" birthday="02-06-1996" positions="fb-cb" nationality="fr" number="5">
				<stats passing="62" tackling="70" shooting="52" crossing="60" heading="72" dribbling="45" speed="75" stamina="72" aggression="54" strength="70" fitness="75" creativity="44"/>
			</player>
			<player id="Tim Hoogland" name="Tim Hoogland" birthday="11-06-2000" positions="fb-sm" nationality="ge" number="2">
				<stats passing="60" tackling="69" shooting="37" crossing="58" heading="50" dribbling="41" speed="62" stamina="78" aggression="77" strength="68" fitness="78" creativity="53"/>
			</player>
			<player id="Atsuto Uchida" name="Atsuto Uchida" birthday="27-03-2003" positions="fb" nationality="ja" number="22">
				<stats passing="69" tackling="77" shooting="30" crossing="72" heading="60" dribbling="57" speed="70" stamina="90" aggression="62" strength="66" fitness="75" creativity="60"/>				
			</player>
			<player id="Christoph Metzelder" name="Christoph Metzelder" birthday="05-11-1995" positions="cb" nationality="ge" number="21">
				<stats passing="40" tackling="83" shooting="28" crossing="39" heading="80" dribbling="41" speed="74" stamina="64" aggression="60" strength="88" fitness="50" creativity="49"/>				
			</player>
			<player id="Sergio Escudero" name="Sergio Escudero" birthday="02-09-2004" positions="fb" nationality="es" number="3">
				<stats passing="55" tackling="75" shooting="42" crossing="41" heading="79" dribbling="50" speed="55" stamina="70" aggression="78" strength="80" fitness="54" creativity="45"/>
			</player>
						<player id="Ivan Rakitic" name="Ivan Rakitic" birthday="10-03-2003" positions="cm" nationality="cr" number="10">
				<stats passing="75" tackling="75" shooting="55" crossing="56" heading="60" dribbling="60" speed="45" stamina="53" aggression="70" strength="70" fitness="87" creativity="75"/>
			</player>
			<player id="Hao Junmin" name="Hao Junmin" birthday="24-03-2002" positions="cm-sm" nationality="ch" number="8">
				<stats passing="40" tackling="76" shooting="48" crossing="57" heading="55" dribbling="55" speed="75" stamina="90" aggression="85" strength="75" fitness="85" creativity="57"/>	
			</player>
			<player id="Jose Manuel Jurado" name="Jose Manuel Jurado" birthday="29-06-2001" positions="cm" nationality="es" number="18">
				<stats passing="60" tackling="40" shooting="45" crossing="58" heading="25" dribbling="62" speed="60" stamina="55" aggression="50" strength="30" fitness="70" creativity="65"/>	
			</player>
			<player id="Peer Kluge" name="Peer Kluge" birthday="22-11-1995" positions="cm" nationality="ge" number="12">
				<stats passing="73" tackling="49" shooting="48" crossing="50" heading="50" dribbling="50" speed="60" stamina="68" aggression="50" strength="58" fitness="64" creativity="63"/>
			</player>
			<player id="Lukas Schmitz" name="Lukas Schmitz" birthday="13-10-2003" positions="cm-sm" nationality="ge" number="13">
				<stats passing="74" tackling="73" shooting="35" crossing="54" heading="40" dribbling="55" speed="62" stamina="85" aggression="75" strength="71" fitness="95" creativity="70"/>	
			</player>
			<player id="Vasileios Pliatskias" name="Vasileios Pliatsikas" birthday="14-04-2003" positions="dm" nationality="gr" number="20">
				<stats passing="53" tackling="59" shooting="38" crossing="40" heading="56" dribbling="60" speed="61" stamina="67" aggression="54" strength="61" fitness="75" creativity="52"/>		
			</player>
			<player id="Jermaine Jones" name="Jermaine Jones" birthday="03-11-1996" positions="dm" nationality="us" number="23">
				<stats passing="65" tackling="66" shooting="51" crossing="78" heading="35" dribbling="75" speed="78" stamina="77" aggression="40" strength="40" fitness="80" creativity="65"/>		
			</player>
			<player id="Christoph Moritz" name="Christoph Moritz" birthday="27-01-2005" positions="dm" nationality="ge" number="28">
				<stats passing="53" tackling="39" shooting="55" crossing="76" heading="37" dribbling="66" speed="60" stamina="72" aggression="50" strength="27" fitness="73" creativity="60"/>		
			</player>
			<player id="Levan Kenia" name="Levan Kenia" birthday="18-10-2005" positions="am" nationality="ge" number="30">
				<stats passing="50" tackling="67" shooting="58" crossing="45" heading="72" dribbling="42" speed="64" stamina="56" aggression="64" strength="63" fitness="34" creativity="41"/>	
			</player>
			<player id="Matthias Schober" name="Mathias Schober" birthday="08-04-1991" positions="gk" nationality="ge" number="33">
				<stats catching="75" shotStopping="73" distribution="59" fitness="45" stamina="65"/>		
			</player>
			<player id="Joel Matip" name="Joel Matip" birthday="08-08-2006" positions="dm-cm" nationality="ca" number="32">
				<stats passing="68" tackling="56" shooting="43" crossing="76" heading="44" dribbling="63" speed="74" stamina="74" aggression="20" strength="52" fitness="59" creativity="65"/>		
			</player>
			<player id="Klaas-Jan Huntelaar" name="Klaas-Jan Huntelaar" birthday="12-08-1998" positions="cf" nationality="ne" number="25">
				<stats passing="61" tackling="20" shooting="66" crossing="44" heading="81" dribbling="69" speed="77" stamina="61" aggression="61" strength="98" fitness="50" creativity="50"/>		
			</player>
			<player id="Jefferson Farfan" name="Jefferson Farfan" birthday="26-10-1999" positions="cf" nationality="pe" number="17">
				<stats passing="65" tackling="65" shooting="58" crossing="59" heading="73" dribbling="70" speed="62" stamina="67" aggression="57" strength="90" fitness="73" creativity="60"/>		
			</player>
			<player id="Edu" name="Edu" birthday="30-11-1996" positions="cf" nationality="br" number="9">
				<stats passing="53" tackling="23" shooting="59" crossing="53" heading="80" dribbling="69" speed="99" stamina="89" aggression="63" strength="83" fitness="85" creativity="65"/>		
			</player>
			<player id="Mario Gavranovic" name="Mario Gavranovic" birthday="24-11-2004" positions="cf" nationality="sw" number="19">
				<stats passing="37" tackling="24" shooting="60" crossing="47" heading="39" dribbling="70" speed="77" stamina="66" aggression="51" strength="41" fitness="74" creativity="44"/>		
			</player>
		</players>
	</club>

<club shirtColor="0xFF0000" sleevesColor="0xFFFFFF" stripesType="none">
		<name><![CDATA[Lyon]]></name>
		<profile>70</profile>
		<players>
			<player id="Hugo Lloris" name="Hugo Lloris" birthday="26-12-2001" positions="gk" nationality="fr" number="1">
				<stats catching="66" shotStopping="70" distribution="50" fitness="70" stamina="70"/>
			</player>
			<player id="Pape Malickou Diakhate" name="Pape Malickou Diakhate" birthday="21-06-1999" positions="cb" nationality="se" number="4">
				<stats passing="20" tackling="75" shooting="20" crossing="15" heading="75" dribbling="15" speed="60" stamina="70" aggression="60" strength="75" fitness="75" creativity="35"/>	
			</player>	
			<player id="Anthony Reveillere" name="Anthony Reveillere" birthday="10-11-1994" positions="fb" nationality="fr" number="13">
				<stats passing="62" tackling="70" shooting="52" crossing="60" heading="72" dribbling="45" speed="75" stamina="72" aggression="54" strength="70" fitness="75" creativity="44"/>
			</player>
			<player id="Lamine Gassama" name="Lamime Gassama" birthday="20-10-1004" positions="fb" nationality="fr" number="2">
				<stats passing="60" tackling="69" shooting="37" crossing="58" heading="50" dribbling="41" speed="62" stamina="78" aggression="77" strength="68" fitness="78" creativity="53"/>
			</player>
			<player id="Timothee Kolodziejczak" name="Timothee Kolodziejczak" birthday="01-10-2006" positions="fb" nationality="fr" number="12">
				<stats passing="69" tackling="77" shooting="30" crossing="72" heading="60" dribbling="57" speed="70" stamina="90" aggression="62" strength="66" fitness="75" creativity="60"/>				
			</player>
			<player id="Cris" name="Cris" birthday="03-06-1992" positions="cb" nationality="br" number="3">
				<stats passing="40" tackling="83" shooting="28" crossing="39" heading="80" dribbling="41" speed="74" stamina="64" aggression="60" strength="88" fitness="50" creativity="49"/>				
			</player>
			<player id="Dejan Lovren" name="Dejan Lovren" birthday="05-07-2004" positions="cb" nationality="cr" number="5">
				<stats passing="55" tackling="75" shooting="42" crossing="41" heading="79" dribbling="50" speed="55" stamina="70" aggression="78" strength="80" fitness="54" creativity="45"/>
			</player>
			<player id="Aly Cissokho" name="Aly Cissokho" birthday="15-09-2002" positions="fb" nationality="fr" number="20">
				<stats passing="47" tackling="68" shooting="10" crossing="68" heading="77" dribbling="46" speed="77" stamina="75" aggression="63" strength="16" fitness="60" creativity="30"/>
			</player>
			<player id="Miralem Pjanic" name="Miralem Pjanic" birthday="02-04-2005" positions="am" nationality="bo" number="8">
				<stats passing="75" tackling="42" shooting="55" crossing="56" heading="60" dribbling="60" speed="45" stamina="53" aggression="70" strength="70" fitness="87" creativity="75"/>
			</player>
			<player id="Ederson" name="Ederson" birthday="13-01-2001" positions="cm" nationality="br" number="10">
				<stats passing="40" tackling="76" shooting="48" crossing="57" heading="55" dribbling="55" speed="75" stamina="90" aggression="85" strength="75" fitness="85" creativity="57"/>	
			</player>
			<player id="Jeremy Pied" name="Jeremy Pied" birthday="23-02-2004" positions="sm" nationality="fr" number="24">
				<stats passing="60" tackling="40" shooting="45" crossing="58" heading="25" dribbling="62" speed="60" stamina="55" aggression="50" strength="30" fitness="70" creativity="65"/>	
			</player>
			<player id="Jean Makoun" name="Jean Makoun" birthday="29-05-1998" positions="dm" nationality="ca" number="17">
				<stats passing="73" tackling="69" shooting="48" crossing="50" heading="50" dribbling="50" speed="60" stamina="68" aggression="50" strength="58" fitness="64" creativity="63"/>
			</player>
			<player id="Kim Kallstrom" name="Kim Kallstrom" birthday="24-08-1997" positions="cm" nationality="sw" number="6">
				<stats passing="74" tackling="73" shooting="35" crossing="54" heading="40" dribbling="55" speed="62" stamina="85" aggression="75" strength="71" fitness="95" creativity="70"/>	
			</player>
			<player id="Maxime Gonalons" name="Maxime Gonalons" birthday="10-03-2004" positions="dm" nationality="fr" number="21">
				<stats passing="53" tackling="59" shooting="38" crossing="40" heading="56" dribbling="60" speed="61" stamina="67" aggression="54" strength="61" fitness="75" creativity="52"/>		
			</player>
			<player id="Jeremy Toulalan" name="Jeremy Toulalan" birthday="10-09-1998" positions="dm" nationality="fr" number="28">
				<stats passing="83" tackling="69" shooting="58" crossing="64" heading="47" dribbling="53" speed="48" stamina="67" aggression="63" strength="62" fitness="66" creativity="58"/>		
			</player>
			<player id="Clement Grenier" name="Clement Grenier" birthday="07-01-2006" positions="cm" nationality="fr" number="22">
				<stats passing="65" tackling="27" shooting="58" crossing="78" heading="35" dribbling="75" speed="78" stamina="77" aggression="40" strength="40" fitness="80" creativity="65"/>		
			</player>
			<player id="Cesar Delgado" name="Cesar Delgado" birthday="18-08-1996" positions="sm" nationality="ar" number="19">
				<stats passing="53" tackling="39" shooting="55" crossing="76" heading="37" dribbling="66" speed="60" stamina="72" aggression="50" strength="27" fitness="73" creativity="60"/>		
			</player>
			<player id="Remy Vercoutre" name="Remy Vercoutre" birthday="26-06-1995" positions="gk" nationality="fr" number="30">
				<stats catching="75" shotStopping="73" distribution="59" fitness="45" stamina="65"/>		
			</player>
			<player id="Michel Bastos" name="Michel Bastos" birthday="02-08-1998" positions="sm-fb" nationality="br" number="11">
				<stats passing="77" tackling="25" shooting="68" crossing="76" heading="44" dribbling="63" speed="74" stamina="74" aggression="20" strength="52" fitness="59" creativity="65"/>		
			</player>
			<player id="Youann Gourcuff" name="Youann Gourcuff" birthday="11-07-2001" positions="am" nationality="fr" number="29">
				<stats passing="74" tackling="60" shooting="68" crossing="53" heading="25" dribbling="66" speed="62" stamina="84" aggression="51" strength="59" fitness="84" creativity="81"/>		
			</player>
			<player id="Jimmy Briand" name="Jimmy Briand" birthday="02-08-2000" positions="cf" nationality="fr" number="7">
				<stats passing="61" tackling="20" shooting="66" crossing="44" heading="81" dribbling="69" speed="77" stamina="61" aggression="61" strength="98" fitness="50" creativity="50"/>		
			</player>
			<player id="Bafetimbi Gomis" name="Bafatimbi Gomis" birthday="06-08-2000" positions="cf" nationality="fr" number="18">
				<stats passing="65" tackling="65" shooting="58" crossing="59" heading="73" dribbling="70" speed="62" stamina="67" aggression="57" strength="90" fitness="73" creativity="60"/>		
			</player>
			<player id="Lisandro Lopez" name="Lisandro Lopez" birthday="02-03-1998" positions="cf" nationality="ar" number="9">
				<stats passing="53" tackling="23" shooting="78" crossing="53" heading="71" dribbling="69" speed="88" stamina="89" aggression="63" strength="83" fitness="85" creativity="65"/>		
			</player>
			<player id="Harry Novillo" name="Harry Novillo" birthday="28-05-2007" positions="cf" nationality="fr" number="15">
				<stats passing="37" tackling="24" shooting="60" crossing="47" heading="39" dribbling="70" speed="77" stamina="66" aggression="51" strength="41" fitness="74" creativity="44"/>		
			</player>
		</players>
	</club>


<club shirtColor="0xFF0000" sleevesColor="0xFFFFFF" stripesType="none">
		<name><![CDATA[Paris Saint Germain]]></name>
		<profile>75</profile>
		<players>
			<player id="Gregory Coupet" name="Gregory Coupet" birthday="31-12-1987" positions="gk" nationality="fr" number="1">
				<stats catching="64" shotStopping="69" distribution="64" fitness="77" stamina="54"/>
			</player>
			<player id="Sylvain Armand" name="Sylvain Armand" birthday="01-08-1995" positions="cb-fb" nationality="fr" number="22">
				<stats passing="68" tackling="78" shooting="54" crossing="64" heading="78" dribbling="53" speed="59" stamina="69" aggression="84" strength="69" fitness="70" creativity="59"/>	
			</player>	
			<player id="Ceara" name="Ceara" birthday="06-06-1995" positions="fb" nationality="br" number="2">
				<stats passing="50" tackling="87" shooting="30" crossing="31" heading="67" dribbling="24" speed="64" stamina="79" aggression="84" strength="69" fitness="70" creativity="29"/>
			</player>
			<player id="Mamadou Sakho" name="Mamadou Sakho" birthday="13-02-2005" positions="fb-cb" nationality="fr" number="3">
				<stats passing="70" tackling="77" shooting="21" crossing="68" heading="63" dribbling="44" speed="65" stamina="80" aggression="74" strength="56" fitness="77" creativity="36"/>
			</player>
			<player id="Zoumana Camara" name="Zoumana Camara" birthday="03-04-1994" positions="cb" nationality="fr" number="6">
				<stats passing="54" tackling="69" shooting="20" crossing="37" heading="74" dribbling="39" speed="80" stamina="75" aggression="59" strength="79" fitness="74" creativity="35"/>				
			</player>
			<player id="Tripy Makonda" name="Tripy Makonda" birthday="24-01-2005" positions="fb" nationality="fr" number="24">
				<stats passing="55" tackling="80" shooting="33" crossing="38" heading="78" dribbling="55" speed="69" stamina="77" aggression="64" strength="65" fitness="75" creativity="54"/>				
			</player>
			<player id="Sammy Traore" name="Sammy Traore" birthday="25-02-1991" positions="cb-fb" nationality="fr" number="13">
				<stats passing="66" tackling="70" shooting="84" crossing="41" heading="66" dribbling="50" speed="70" stamina="79" aggression="63" strength="62" fitness="73" creativity="59"/>
			</player>
			<player id="Siaka Tiene" name="Siaka Tiene" birthday="22-02-1997" positions="fb" nationality="iv" number="5">
				<stats passing="70" tackling="74" shooting="52" crossing="69" heading="52" dribbling="74" speed="68" stamina="83" aggression="59" strength="44" fitness="74" creativity="63"/>
			</player>
			<player id="Claude Makelele" name="Claude Makelele" birthday="18-02-1988" positions="dm-cm" nationality="fr" number="4">
				<stats passing="73" tackling="64" shooting="54" crossing="42" heading="93" dribbling="58" speed="60" stamina="85" aggression="78" strength="95" fitness="74" creativity="59"/>
			</player>
			<player id="Stephane Sessegnon" name="Stephane Sessegnon" birthday="01-06-1999" positions="cm-am-sm" nationality="be" number="10">
				<stats passing="79" tackling="47" shooting="58" crossing="84" heading="34" dribbling="80" speed="69" stamina="68" aggression="62" strength="33" fitness="73" creativity="78"/>	
			</player>
			<player id="Mathieu Bodmer" name="Mathieu Bodmer" birthday="22-11-1997" positions="cm" nationality="fr" number="12">
				<stats passing="70" tackling="57" shooting="70" crossing="57" heading="51" dribbling="84" speed="55" stamina="69" aggression="39" strength="34" fitness="75" creativity="74"/>	
			</player>
			<player id="Nene" name="Nene" birthday="19-07-1996" positions="sm" nationality="br" number="19">
				<stats passing="74" tackling="33" shooting="62" crossing="67" heading="39" dribbling="72" speed="69" stamina="75" aggression="68" strength="21" fitness="62" creativity="85"/>
			</player>
			<player id="Clement Chantome" name="Clement Chantome" birthday="11-09-2002" positions="dm" nationality="fr" number="20">
				<stats passing="76" tackling="44" shooting="66" crossing="64" heading="64" dribbling="58" speed="59" stamina="72" aggression="49" strength="51" fitness="70" creativity="69"/>	
			</player>
			<player id="Jeremy Clement" name="Jeremy Clement" birthday="27-08-1999" positions="cm" nationality="fr" number="23">
				<stats passing="70" tackling="64" shooting="68" crossing="58" heading="93" dribbling="58" speed="64" stamina="82" aggression="89" strength="75" fitness="89" creativity="44"/>		
			</player>
			<player id="Florian Makhedjouf" name="Florian Makhedjouf" birthday="11-01-2006" positions="cm" nationality="fr" number="34">
				<stats passing="54" tackling="11" shooting="59" crossing="44" heading="53" dribbling="68" speed="72" stamina="63" aggression="34" strength="58" fitness="64" creativity="60"/>		
			</player>
			<player id="Ludovic Giuly" name="Ludovic Giuly" birthday="10-07-1991" positions="am-sm-wf-cf" nationality="fr" number="7">
				<stats passing="58" tackling="28" shooting="68" crossing="53" heading="67" dribbling="58" speed="75" stamina="68" aggression="39" strength="68" fitness="49" creativity="54"/>		
			</player>
			<player id="Mevlut Erdinc" name="Mevlut Erdinc" birthday="25-02-2002" positions="cf" nationality="fr" number="11">
				<stats passing="53" tackling="38" shooting="63" crossing="28" heading="74" dribbling="52" speed="84" stamina="69" aggression="79" strength="59" fitness="58" creativity="25"/>	
			</player>
			<player id="Apoula Edel" name="Apoula Edel" birthday="17-06-2001" positions="gk" nationality="ar" number="30">
				<stats catching="79" shotStopping="82" distribution="58" fitness="68" stamina="64"/>		
			</player>
			<player id="Peguy Luyindula" name="Peguy Luyindula" birthday="25-05-1994" positions="cf" nationality="za" number="22">
				<stats passing="64" tackling="33" shooting="76" crossing="47" heading="64" dribbling="54" speed="59" stamina="68" aggression="44" strength="87" fitness="69" creativity="70"/>		
			</player>
			<player id="Guillaume Hoarau" name="Guillaume Hoarau" birthday="05-03-1999" positions="cf" nationality="fr" number="9">
				<stats passing="44" tackling="22" shooting="68" crossing="34" heading="54" dribbling="70" speed="85" stamina="64" aggression="54" strength="64" fitness="65" creativity="64"/>		
			</player>
		</players>
	</club>

<club shirtColor="0xFF0000" sleevesColor="0xFFFFFF" stripesType="none">
		<name><![CDATA[Inter Milan]]></name>
		<profile>90</profile>
		<players>
			<player id="Luca Castellazzi" name="Luca Castellazzi" birthday="19-07-1990" positions="gk" nationality="it" number="12">
				<stats catching="64" shotStopping="62" distribution="70" fitness="39" stamina="68"/>
			</player>
			<player id="Ivan Cordoba" name="Ivan Cordoba" birthday="11-08-1991" positions="cb-fb" nationality="co" number="2">
				<stats passing="54" tackling="78" shooting="7" crossing="32" heading="79" dribbling="23" speed="51" stamina="74" aggression="73" strength="88" fitness="95" creativity="34"/>	
			</player>	
			<player id="Javier Zanetti" name="Javier Zanetti" birthday="10-08-1988" positions="fb" nationality="ar" number="4">
				<stats passing="64" tackling="68" shooting="54" crossing="75" heading="58" dribbling="65" speed="75" stamina="85" aggression="54" strength="75" fitness="85" creativity="65"/>
			</player>
			<player id="Lucio" name="Lucio" birthday="08-05-1993" positions="cb" nationality="br" number="6">
				<stats passing="39" tackling="83" shooting="38" crossing="28" heading="78" dribbling="16" speed="58" stamina="64" aggression="85" strength="90" fitness="74" creativity="34"/>
			</player>
			<player id="Walter Samuel" name="Walter Samuel" birthday="23-03-1993" positions="cb" nationality="ar" number="25">
				<stats passing="39" tackling="83" shooting="38" crossing="28" heading="78" dribbling="16" speed="58" stamina="64" aggression="85" strength="90" fitness="74" creativity="34"/>
</player>
			<player id="Marco Materazzi" name="Marco Materazzi" birthday="19-08-1988" positions="cb" nationality="it" number="23">
				<stats passing="74" tackling="75" shooting="58" crossing="43" heading="75" dribbling="48" speed="68" stamina="74" aggression="63" strength="61" fitness="47" creativity="58"/>				
			</player>
			<player id="Nelson Rivas" name="Nelson Rivas" birthday="25-03-1998" positions="cb-fb" nationality="co" number="24">
				<stats passing="58" tackling="89" shooting="23" crossing="42" heading="78" dribbling="33" speed="68" stamina="78" aggression="79" strength="80" fitness="72" creativity="52"/>				
			</player>
			<player id="Cristian Chivu" name="Cristian Chivu" birthday="26-10-1995" positions="fb-cb" nationality="en" number="3">
				<stats passing="64" tackling="69" shooting="52" crossing="69" heading="55" dribbling="63" speed="70" stamina="75" aggression="72" strength="64" fitness="75" creativity="53"/>
			</player>
			<player id="Maicon" name="Maicon" birthday="26-07-1996" positions="fb" nationality="br" number="13">
				<stats passing="79" tackling="57" shooting="63" crossing="75" heading="51" dribbling="58" speed="63" stamina="68" aggression="40" strength="56" fitness="44" creativity="75"/>
			</player>
			<player id="Sulley Muntari" name="Sulley Muntari" birthday="27-08-1999" positions="dm-cm" nationality="gh" number="11">
				<stats passing="68" tackling="76" shooting="53" crossing="52" heading="65" dribbling="37" speed="52" stamina="80" aggression="82" strength="70" fitness="75" creativity="45"/>
			</player>
			<player id="McDonald Mariga" name="McDonald Mariga" birthday="04-04-2002" positions="cm" nationality="ke" number="23">
				<stats passing="67" tackling="79" shooting="38" crossing="58" heading="39" dribbling="63" speed="69" stamina="82" aggression="54" strength="69" fitness="74" creativity="67"/>	
			</player>
			<player id="Thiagho Motta" name="Thiago Motta" birthday="28-08-1997" positions="cm" nationality="br" number="8">
				<stats passing="73" tackling="67" shooting="66" crossing="75" heading="58" dribbling="48" speed="59" stamina="83" aggression="74" strength="52" fitness="58" creativity="64"/>	
			</player>
			<player id="Dejan Stankovic" name="Dejan Stankovic" birthday="11-09-1993" positions="am" nationality="en" number="5">
				<stats passing="66" tackling="60" shooting="68" crossing="60" heading="25" dribbling="70" speed="70" stamina="55" aggression="70" strength="55" fitness="75" creativity="80"/>
			</player>
			<player id="Esteban Cambiasso" name="Esteban Cambiasso" birthday="18-08-1995" positions="dm" nationality="ar" number="19">
				<stats passing="84" tackling="80" shooting="65" crossing="77" heading="55" dribbling="75" speed="75" stamina="91" aggression="90" strength="80" fitness="79" creativity="75"/>	
			</player>
			<player id="Mancini" name="Mancini" birthday="01-08-1995" positions="sm" nationality="br" number="30">
				<stats passing="70" tackling="45" shooting="67" crossing="66" heading="58" dribbling="64" speed="59" stamina="78" aggression="62" strength="67" fitness="77" creativity="58"/>		
			</player>
			<player id="Wesley Sneijder" name="Wesley Sneijder" birthday="09-06-1999" positions="am" nationality="ne" number="10">
				<stats passing="62" tackling="54" shooting="48" crossing="54" heading="68" dribbling="54" speed="59" stamina="98" aggression="60" strength="74" fitness="97" creativity="60"/>		
			</player>
			<player id="Samuel Eto'o" name="Samuel Eto'o" birthday="10-03-1996" positions="cf" nationality="ca" number="9">
				<stats passing="63" tackling="25" shooting="84" crossing="64" heading="76" dribbling="64" speed="85" stamina="69" aggression="12" strength="74" fitness="80" creativity="64"/>		
			</player>
			<player id="Diego Milito" name="Diego Milito" birthday="12-06-1994" positions="cf" nationality="ar" number="22">
				<stats passing="68" tackling="51" shooting="81" crossing="58" heading="75" dribbling="85" speed="74" stamina="68" aggression="68" strength="68" fitness="60" creativity="75"/>	
			</player>
			<player id="David Suazo" name="David Suazo" birthday="05-11-1994" positions="cf" nationality="ho" number="18">
				<stats passing="44" tackling="14" shooting="78" crossing="41" heading="72" dribbling="59" speed="84" stamina="64" aggression="36" strength="59" fitness="44" creativity="45"/>		
			</player>
			<player id="Julio Cesar" name="Julio Cesar" birthday="03-09-1994" positions="gk" nationality="br" number="1">
				<stats catching="80" shotStopping="90" distribution="89" fitness="60" stamina="75"/>		
			</player>
		</players>
	</club>

<club shirtColor="0xFF0000" sleevesColor="0xFFFFFF" stripesType="none">
		<name><![CDATA[Juventus]]></name>
		<profile>75</profile>
		<players>
			<player id="Gianluigi Buffon" name="Gianluigi Buffon" birthday="28-01-1993" positions="gk" nationality="it" number="1">
				<stats catching="64" shotStopping="69" distribution="64" fitness="77" stamina="54"/>
			</player>
			<player id="Marco Motta" name="Marco Motta" birthday="14-05-2001" positions="fb" nationality="it" number="2">
				<stats passing="68" tackling="78" shooting="54" crossing="64" heading="78" dribbling="53" speed="59" stamina="69" aggression="84" strength="69" fitness="70" creativity="59"/>	
			</player>	
			<player id="Giorgio Chiellini" name="Giorgio Chiellini" birthday="14-08-1999" positions="cb" nationality="it" number="3">
				<stats passing="50" tackling="87" shooting="30" crossing="31" heading="67" dribbling="24" speed="64" stamina="79" aggression="84" strength="69" fitness="70" creativity="29"/>
			</player>
			<player id="Fabio Grosso" name="Fabio Grosso" birthday="28-11-1992" positions="fb" nationality="it" number="6">
				<stats passing="70" tackling="77" shooting="21" crossing="68" heading="63" dribbling="44" speed="65" stamina="80" aggression="74" strength="56" fitness="77" creativity="36"/>
			</player>
			<player id="Armand Traore" name="Armand Traore" birthday="08-10-2004" positions="fb" nationality="fr" number="17">
				<stats passing="54" tackling="69" shooting="20" crossing="37" heading="74" dribbling="39" speed="80" stamina="75" aggression="59" strength="79" fitness="74" creativity="35"/>				
			</player>
			<player id="Leonardo Bonucci" name="Leonardo Bonucci" birthday="01-05-2002" positions="cb" nationality="it" number="19">
				<stats passing="55" tackling="80" shooting="33" crossing="38" heading="78" dribbling="33" speed="69" stamina="77" aggression="64" strength="65" fitness="75" creativity="54"/>				
			</player>
			<player id="Zdenek Grygera" name="Zdenek Grygera" birthday="14-05-1995" positions="fb-cb" nationality="cz" number="21">
				<stats passing="66" tackling="70" shooting="84" crossing="41" heading="66" dribbling="50" speed="70" stamina="79" aggression="63" strength="62" fitness="73" creativity="59"/>
			</player>
			<player id="Leandro Rinaudo" name="Leandro Rinaudo" birthday="09-05-1998" positions="cb" nationality="it" number="26">
				<stats passing="70" tackling="74" shooting="52" crossing="69" heading="52" dribbling="74" speed="68" stamina="83" aggression="59" strength="44" fitness="74" creativity="63"/>
			</player>
			<player id="Felipe Melo" name="Felipe Melo" birthday="26-06-1998" positions="dm" nationality="br" number="4">
				<stats passing="73" tackling="64" shooting="54" crossing="42" heading="93" dribbling="58" speed="60" stamina="85" aggression="78" strength="95" fitness="74" creativity="59"/>
			</player>
			<player id="Mohamed Sissoko" name="Mohamed Sissoko" birthday="22-01-2000" positions="dm" nationality="fr" number="5">
				<stats passing="79" tackling="47" shooting="58" crossing="84" heading="34" dribbling="80" speed="69" stamina="68" aggression="62" strength="33" fitness="73" creativity="78"/>	
			</player>
			<player id="Hasan Salihamidzic" name="Hasan Salihamidzic" birthday="01-01-1992" positions="sm-cm" nationality="bo" number="7">
				<stats passing="70" tackling="57" shooting="70" crossing="57" heading="51" dribbling="84" speed="55" stamina="69" aggression="39" strength="34" fitness="75" creativity="74"/>	
			</player>
			<player id="Claudio Marchisio" name="Claudio Marchisio" birthday="19-01-2001" positions="cm" nationality="it" number="8">
				<stats passing="74" tackling="33" shooting="62" crossing="67" heading="39" dribbling="72" speed="69" stamina="75" aggression="68" strength="21" fitness="62" creativity="85"/>
			</player>
			<player id="Alberto Aquilani" name="Alberto Aquilani" birthday="07-07-1999" positions="cm-am" nationality="it" number="14">
				<stats passing="76" tackling="44" shooting="66" crossing="64" heading="64" dribbling="58" speed="59" stamina="72" aggression="49" strength="51" fitness="70" creativity="69"/>	
			</player>
			<player id="Davide Lanzafame" name="Davide Lanzafame" birthday="09-02-2002" positions="sm-wf-cf" nationality="it" number="36">
				<stats passing="70" tackling="64" shooting="68" crossing="58" heading="93" dribbling="58" speed="64" stamina="82" aggression="89" strength="75" fitness="89" creativity="44"/>		
			</player>
			<player id="Simone Pepe" name="Simone Pepe" birthday="30-08-1998" positions="sm-wf" nationality="it" number="23">
				<stats passing="54" tackling="11" shooting="59" crossing="44" heading="53" dribbling="68" speed="72" stamina="63" aggression="34" strength="58" fitness="64" creativity="60"/>		
			</player>
			<player id="Vincenzo Iaquinta" name="Vincenzo Iaquinta" birthday="21-11-1994" positions="cf" nationality="it" number="9">
				<stats passing="58" tackling="28" shooting="68" crossing="53" heading="67" dribbling="58" speed="75" stamina="68" aggression="39" strength="68" fitness="49" creativity="54"/>		
			</player>
			<player id="Alessandro Del Piero" name="Alessandro Del Piero" birthday="09-11-1989" positions="cf" nationality="it" number="10">
				<stats passing="53" tackling="38" shooting="63" crossing="28" heading="74" dribbling="52" speed="84" stamina="69" aggression="79" strength="59" fitness="58" creativity="25"/>	
			</player>
			<player id="Alex Manninger" name="Alex Manninger" birthday="04-06-1992" positions="gk" nationality="au" number="13">
				<stats catching="79" shotStopping="82" distribution="58" fitness="68" stamina="64"/>		
			</player>
			<player id="Amauri" name="Amauri" birthday="03-06-1995" positions="cf" nationality="br" number="11">
				<stats passing="64" tackling="33" shooting="76" crossing="47" heading="64" dribbling="54" speed="59" stamina="68" aggression="44" strength="87" fitness="69" creativity="70"/>		
			</player>
			<player id="Fabio Quagliarella" name="Fabio Quagliarella" birthday="31-01-1998" positions="cf" nationality="it" number="18">
				<stats passing="44" tackling="22" shooting="68" crossing="34" heading="54" dribbling="70" speed="85" stamina="64" aggression="54" strength="64" fitness="65" creativity="64"/>		
			</player>
			<player id="Marco Storari" name="Marco Storari" birthday="07-01-1992" positions="gk" nationality="it" number="30">
				<stats catching="64" shotStopping="73" distribution="70" fitness="59" stamina="62"/>		
			</player>
		</players>
	</club>

<club shirtColor="0xFF0000" sleevesColor="0xFFFFFF" stripesType="none">
		<name><![CDATA[FC Porto]]></name>
		<profile>60</profile>
		<players>
			<player id="Helton Arruda" name="Helton Arruda" birthday="18-05-1993" positions="gk" nationality="br" number="1">
				<stats catching="75" shotStopping="80" distribution="50" fitness="70" stamina="60"/>
			</player>
			<player id="Alvaro Pereira" name="Alvaro Pereira" birthday="28-11-2000" positions="cm-am" nationality="fr" number="2">
				<stats passing="55" tackling="55" shooting="54" crossing="45" heading="50" dribbling="70" speed="65" stamina="70" aggression="55" strength="70" fitness="50" creativity="60"/>	
			</player>	
			<player id="Jorge Fucile" name="Jorge Fucile" birthday="19-11-1999" positions="fb" nationality="ur" number="3">
				<stats passing="53" tackling="60" shooting="40" crossing="60" heading="63" dribbling="45" speed="65" stamina="68" aggression="58" strength="63" fitness="75" creativity="56"/>
			</player>
			<player id="Freddy Guarin" name="Freddy Guarin" birthday="30-06-2001" positions="cm-am" nationality="co" number="6">
				<stats passing="93" tackling="59" shooting="67" crossing="58" heading="35" dribbling="63" speed="64" stamina="80" aggression="46" strength="47" fitness="64" creativity="94"/>
			</player>
			<player id="Alvaro Pereira" name="Alvaro Pereira" birthday="28-11-2000" positions="fb" nationality="ur" number="5">
				<stats passing="65" tackling="68" shooting="56" crossing="46" heading="67" dribbling="56" speed="72" stamina="66" aggression="72" strength="68" fitness="75" creativity="45"/>				
			</player>
			<player id="Maicon" name="Maicon" birthday="14-09-2003" positions="cb" nationality="br" number="4">
				<stats passing="55" tackling="56" shooting="40" crossing="52" heading="57" dribbling="43" speed="68" stamina="67" aggression="65" strength="57" fitness="68" creativity="45"/>				
			</player>
			<player id="Fernando Belluschi" name="Fernando Belluschi" birthday="10-09-1998" positions="cm-am" nationality="ar" number="7">
				<stats passing="68" tackling="46" shooting="64" crossing="63" heading="34" dribbling="67" speed="61" stamina="58" aggression="48" strength="56" fitness="37" creativity="74"/>
			</player>
			<player id="Joao Moutinho" name="Joao Moutinho" birthday="08-09-2001" positions="cm" nationality="pr" number="8">
				<stats passing="72" tackling="43" shooting="68" crossing="67" heading="43" dribbling="75" speed="64" stamina="64" aggression="57" strength="42" fitness="60" creativity="56"/>
			</player>
			<player id="Falcao" name="Falcao" birthday="10-02-2001" positions="cf" nationality="co" number="9">
				<stats passing="65" tackling="56" shooting="69" crossing="67" heading="67" dribbling="73" speed="65" stamina="67" aggression="69" strength="60" fitness="60" creativity="67"/>
			</player>
			<player id="Hulk" name="Hulk" birthday="25-07-2001" positions="cf" nationality="br" number="12">
				<stats passing="53" tackling="34" shooting="71" crossing="67" heading="45" dribbling="74" speed="64" stamina="68" aggression="45" strength="49" fitness="61" creativity="64"/>	
			</player>
			<player id="Silvestre Varela" name="Silvestre Varela" birthday="02-02-2000" positions="wf-cf" nationality="pr" number="17">
				<stats passing="49" tackling="32" shooting="64" crossing="68" heading="43" dribbling="66" speed="84" stamina="45" aggression="37" strength="46" fitness="57" creativity="51"/>	
			</player>
			<player id="Cristian Rodriguez" name="Cristian Rodriguez" birthday="30-09-2000" positions="sm" nationality="ur" number="10">
				<stats passing="73" tackling="56" shooting="61" crossing="63" heading="45" dribbling="58" speed="68" stamina="68" aggression="64" strength="62" fitness="64" creativity="63"/>
			</player>
			<player id="James Rodriguez" name="James Rodriguez" birthday="12-07-2006" positions="sf-wf-cf" nationality="co" number="19">
				<stats passing="71" tackling="61" shooting="68" crossing="67" heading="45" dribbling="65" speed="68" stamina="67" aggression="68" strength="69" fitness="60" creativity="57"/>	
			</player>
			<player id="Nicolas Otamendi" name="Nicholas Otamendi" birthday="12-02-2003" positions="cb-fb" nationality="ar" number="30">
				<stats passing="40" tackling="69" shooting="56" crossing="56" heading="56" dribbling="66" speed="61" stamina="67" aggression="64" strength="66" fitness="69" creativity="55"/>		
			</player>
			<player id="Rolando" name="Rolando" birthday="31-08-2000" positions="cb" nationality="pr" number="14">
				<stats passing="57" tackling="69" shooting="43" crossing="53" heading="67" dribbling="31" speed="67" stamina="77" aggression="67" strength="72" fitness="74" creativity="46"/>		
			</player>
			<player id="Souza" name="Souza" birthday="11-02-2004" positions="dm" nationality="br" number="23">
				<stats passing="78" tackling="56" shooting="61" crossing="67" heading="25" dribbling="73" speed="69" stamina="67" aggression="69" strength="68" fitness="70" creativity="73"/>		
			</player>
			<player id="Emidio Rafael" name="Emidio Rafael" birthday="24-01-2001" positions="fb" nationality="pr" number="15">
				<stats passing="50" tackling="67" shooting="58" crossing="45" heading="72" dribbling="42" speed="64" stamina="56" aggression="64" strength="63" fitness="34" creativity="41"/>	
			</player>
			<player id="Beto" name="Beto" birthday="01-05-1997" positions="gk" nationality="pr" number="24">
				<stats catching="50" shotStopping="76" distribution="60" fitness="67" stamina="84"/>		
			</player>
			<player id="Cristian Sapunaru" name="Cristian Sapunaru" birthday="05-04-1999" positions="fb-cb" nationality="ro" number="21">
				<stats passing="59" tackling="68" shooting="38" crossing="47" heading="53" dribbling="55" speed="69" stamina="72" aggression="64" strength="56" fitness="78" creativity="67"/>		
			</player>
			<player id="Mariano Gonzalez" name="Mariano Gonzalez" birthday="05-05-1996" positions="cm-sm" nationality="ar" number="11">
				<stats passing="73" tackling="32" shooting="77" crossing="57" heading="23" dribbling="89" speed="73" stamina="43" aggression="48" strength="51" fitness="67" creativity="73"/>		
			</player>
			<player id="Henrique Fonseca" name="Henrique Fonseca" birthday="18-05-2000" positions="cb" nationality="pr" number="16">
				<stats passing="69" tackling="67" shooting="45" crossing="56" heading="59" dribbling="71" speed="72" stamina="65" aggression="46" strength="59" fitness="70" creativity="67"/>		
			</player>
			<player id="Fernando" name="Fernando" birthday="25-07-2002" positions="cm-sm" nationality="br" number="25">
				<stats passing="65" tackling="67" shooting="67" crossing="56" heading="56" dribbling="64" speed="62" stamina="67" aggression="57" strength="67" fitness="67" creativity="73"/>		
			</player>
			<player id="Walter" name="Walter" birthday="22-07-2004" positions="cf" nationality="br" number="18">
				<stats passing="56" tackling="35" shooting="63" crossing="53" heading="70" dribbling="76" speed="67" stamina="70" aggression="68" strength="72" fitness="67" creativity="67"/>		
			</player>
			<player id="Ukra" name="Ukra" birthday="16-03-2003" positions="cf" nationality="pr" number="27">
				<stats passing="65" tackling="34" shooting="57" crossing="65" heading="73" dribbling="67" speed="69" stamina="71" aggression="69" strength="65" fitness="58" creativity="65"/>		
			</player>
			<player id="Pawel Kieszek" name="Pawel Kieszek" birthday="16-04-1999" positions="gk" nationality="po" number="31">
				<stats catching="55" shotStopping="75" distribution="65" fitness="67" stamina="64"/>		
			</player>
		</players>
	</club>

<club shirtColor="0xFF0000" sleevesColor="0xFFFFFF" stripesType="none">
		<name><![CDATA[Glasgow Rangers]]></name>
		<profile>55</profile>
		<players>
			<player id="Allan McGregor" name="Allan McGregor" birthday="31-01-1997" positions="gk" nationality="sc" number="1">
				<stats catching="70" shotStopping="85" distribution="95" fitness="70" stamina="80"/>
			</player>
			<player id="Sasa Papac" name="Sasa Papac" birthday="07-02-1995" positions="fb" nationality="se" number="5">
				<stats passing="60" tackling="75" shooting="37" crossing="59" heading="69" dribbling="57" speed="69" stamina="83" aggression="72" strength="68" fitness="77" creativity="47"/>	
			</player>	
			<player id="Lee McCulloch" name="Lee McCulloch" birthday="14-05-1993" positions="cm-dm-am-cb" nationality="sc" number="6">
				<stats passing="60" tackling="70" shooting="45" crossing="63" heading="58" dribbling="50" speed="65" stamina="99" aggression="80" strength="75" fitness="98" creativity="60"/>
			</player>
			<player id="David Weir" name="David Weir" birthday="10-05-1985" positions="cb" nationality="sc" number="3">
				<stats passing="38" tackling="88" shooting="25" crossing="23" heading="73" dribbling="23" speed="58" stamina="64" aggression="78" strength="79" fitness="75" creativity="43"/>
			</player>
			<player id="Kirk Broadfoot" name="Kirk Broadfoot" birthday="08-08-1999" positions="cb-fb" nationality="sc" number="4">
				<stats passing="39" tackling="86" shooting="15" crossing="16" heading="72" dribbling="24" speed="47" stamina="62" aggression="78" strength="88" fitness="84" creativity="42"/>				
			</player>
			<player id="Andy Webster" name="Andy Webster" birthday="23-04-1997" positions="cb" nationality="sc" number="22">
				<stats passing="42" tackling="74" shooting="38" crossing="17" heading="81" dribbling="43" speed="74" stamina="64" aggression="84" strength="94" fitness="74" creativity="43"/>				
			</player>
			<player id="Madjid Bougherra" name="Madjid Bougherra" birthday="07-10-1997" positions="cb" nationality="al" number="24">
				<stats passing="43" tackling="63" shooting="16" crossing="24" heading="64" dribbling="38" speed="68" stamina="63" aggression="83" strength="67" fitness="80" creativity="33"/>
			</player>
			<player id="Maurice Edu" name="Maurice Edu" birthday="18-04-2001" positions="cm" nationality="us" number="7">
				<stats passing="53" tackling="57" shooting="42" crossing="27" heading="67" dribbling="37" speed="49" stamina="75" aggression="57" strength="78" fitness="55" creativity="43"/>
			</player>
			<player id="Richard Foster" name="Richard Foster" birthday="31-07-2000" positions="fb" nationality="sc" number="12">
				<stats passing="73" tackling="77" shooting="48" crossing="67" heading="24" dribbling="53" speed="52" stamina="63" aggression="88" strength="57" fitness="79" creativity="48"/>
			</player>
			<player id="Steven Whittaker" name="Steven Whittaker" birthday="16-06-1999" positions="fb-sm" nationality="sc" number="16">
				<stats passing="63" tackling="69" shooting="43" crossing="69" heading="42" dribbling="70" speed="77" stamina="77" aggression="68" strength="59" fitness="78" creativity="64"/>	
			</player>
			<player id="Salim Kerkar" name="Salim Kerkar" birthday="04-08-2002" positions="cm" nationality="fr" number="28">
				<stats passing="64" tackling="86" shooting="30" crossing="43" heading="62" dribbling="38" speed="50" stamina="78" aggression="82" strength="73" fitness="64" creativity="64"/>	
			</player>
			<player id="John Fleck" name="John Fleck" birthday="24-08-2006" positions="cm" nationality="sc" number="10">
				<stats passing="70" tackling="52" shooting="59" crossing="68" heading="63" dribbling="49" speed="55" stamina="75" aggression="57" strength="46" fitness="84" creativity="72"/>	
			</player>
			<player id="Steven Davis" name="Steven Davis" birthday="01-01-2000" positions="am" nationality="ni" number="8">
				<stats passing="54" tackling="46" shooting="45" crossing="50" heading="58" dribbling="44" speed="54" stamina="93" aggression="70" strength="70" fitness="89" creativity="57"/>		
			</player>
			<player id="Kenny Miller" name="Kenny Miller" birthday="23-12-1994" positions="cf" nationality="sc" number="9">
				<stats passing="63" tackling="50" shooting="51" crossing="67" heading="54" dribbling="69" speed="64" stamina="63" aggression="85" strength="57" fitness="67" creativity="70"/>		
			</player>
			<player id="Vladimir Weiss" name="Vladimir Weiss" birthday="30-11-2004" positions="sm-am-cm" nationality="sl" number="20">
				<stats passing="39" tackling="12" shooting="21" crossing="43" heading="23" dribbling="54" speed="63" stamina="52" aggression="69" strength="44" fitness="77" creativity="52"/>		
			</player>
			<player id="Neil Alexander" name="Neil Alexander" birthday="10-03-1993" positions="gk" nationality="sc" number="25">
				<stats catching="65" shotStopping="76" distribution="70" fitness="60" stamina="63"/>		
			</player>
			<player id="Kyle Lafferty" name="Kyle Lafferty" birthday="16-09-2002" positions="cf" nationality="ni" number="11">
				<stats passing="54" tackling="33" shooting="55" crossing="44" heading="64" dribbling="62" speed="63" stamina="64" aggression="88" strength="70" fitness="73" creativity="65"/>		
			</player>
			<player id="Steven Naismith" name="Steven Naismith" birthday="14-09-2001" positions="cf" nationality="sc" number="14">
				<stats passing="51" tackling="33" shooting="45" crossing="44" heading="67" dribbling="53" speed="73" stamina="90" aggression="95" strength="85" fitness="67" creativity="54"/>		
			</player>
			<player id="Nikica Jelavic" name="Nikica Jelavic" birthday="27-08-2000" positions="cf" nationality="cr" number="18">
				<stats passing="51" tackling="46" shooting="54" crossing="51" heading="64" dribbling="54" speed="57" stamina="75" aggression="70" strength="90" fitness="75" creativity="60"/>		
			</player>
			<player id="James Beattie" name="James Beattie" birthday="27/02/1993" positions="cf" nationality="en" number="19">
				<stats passing="60" tackling="33" shooting="68" crossing="37" heading="75" dribbling="42" speed="70" stamina="58" aggression="63" strength="58" fitness="55" creativity="33"/>		
			</player>			
		</players>
	</club>

<club shirtColor="0xFF0000" sleevesColor="0xFFFFFF" stripesType="none">
		<name><![CDATA[Glasgow Celtic]]></name>
		<profile>65</profile>
		<players>
			<player id="Lukasz Zaluska" name="Lukasz Zaluska" birthday="16-06-1997" positions="gk" nationality="po" number="24">
				<stats catching="77" shotStopping="79" distribution="86" fitness="70" stamina="75"/>
			</player>
			<player id="Fraser Forster" name="Fraser Forster" birthday="17-03-2003" positions="gk" nationality="en" number="26">
				<stats catching="73" shotStopping="75" distribution="46" fitness="64" stamina="60"/>
			</player>
			<player id="Andreas Hinkel" name="Andreas Hinkel" birthday="26-03-1997" positions="fb" nationality="ge" number="2">
				<stats passing="73" tackling="77" shooting="48" crossing="76" heading="75" dribbling="67" speed="59" stamina="73" aggression="78" strength="76" fitness="66" creativity="51"/>	
			</player>	
			<player id="Emilio Izaguirre" name="Emilio Izaguirre" birthday="10-05-2001" positions="fb-wb" nationality="ho" number="3">
				<stats passing="56" tackling="73" shooting="39" crossing="46" heading="78" dribbling="51" speed="65" stamina="75" aggression="75" strength="78" fitness="68" creativity="49"/>
			</player>
			<player id="Cha Du-Ri" name="Cha Du-Ri" birthday="25-07-1995" positions="fb" nationality="sk" number="11">
				<stats passing="63" tackling="61" shooting="55" crossing="56" heading="55" dribbling="65" speed="63" stamina="75" aggression="50" strength="71" fitness="62" creativity="50"/>
			</player>
			<player id="Daniel Majstorovic" name="Daniel Majstorovic" birthday="05-04-1992" positions="cb" nationality="sw" number="5">
				<stats passing="68" tackling="78" shooting="45" crossing="60" heading="82" dribbling="50" speed="54" stamina="66" aggression="80" strength="63" fitness="75" creativity="60"/>				
			</player>
			<player id="Jos Hooiveld" name="Jos Hooiveld" birthday="22-04-1998" positions="cb" nationality="ne" number="6">
				<stats passing="41" tackling="81" shooting="15" crossing="11" heading="81" dribbling="26" speed="65" stamina="73" aggression="68" strength="75" fitness="61" creativity="25"/>				
			</player>
			<player id="Glenn Loovens" name="Glenn Loovens" birthday="22-10-1998" positions="cb" nationality="ne" number="22">
				<stats passing="56" tackling="85" shooting="55" crossing="26" heading="76" dribbling="46" speed="60" stamina="63" aggression="57" strength="58" fitness="63" creativity="56"/>
			</player>
			<player id="Mark Wilson" name="Mark Wilson" birthday="05-06-1999" positions="fb" nationality="sc" number="12">
				<stats passing="53" tackling="63" shooting="44" crossing="66" heading="57" dribbling="53" speed="67" stamina="65" aggression="57" strength="66" fitness="52" creativity="41"/>
			</player>
			<player id="Fredrik Ljungberg" name="Fredrik Ljungberg" birthday="16-04-1992" positions="cm-sm" nationality="sw" number="7">
				<stats passing="63" tackling="59" shooting="70" crossing="75" heading="60" dribbling="63" speed="67" stamina="70" aggression="40" strength="55" fitness="74" creativity="50"/>
			</player>
			<player id="Scott Brown" name="Scott Brown" birthday="25-06-2000" positions="cm-sm" nationality="sc" number="8">
				<stats passing="60" tackling="57" shooting="57" crossing="55" heading="33" dribbling="47" speed="58" stamina="77" aggression="88" strength="47" fitness="73" creativity="57"/>	
			</player>
			<player id="Niall McGinn" name="Niall McGinn" birthday="20-07-2002" positions="sm-cm" nationality="ni" number="14">
				<stats passing="75" tackling="23" shooting="27" crossing="63" heading="67" dribbling="57" speed="63" stamina="57" aggression="35" strength="54" fitness="66" creativity="71"/>	
			</player>
			<player id="Joe Ledley" name="Joe Ledley" birthday="21-01-2002" positions="cm-sm" nationality="wa" number="16">
				<stats passing="63" tackling="43" shooting="70" crossing="63" heading="48" dribbling="68" speed="63" stamina="78" aggression="77" strength="58" fitness="75" creativity="64"/>
			</player>
			<player id="Marc Crosas" name="Marc Crosas" birthday="09-01-2003" positions="cm" nationality="es" number="17">
				<stats passing="58" tackling="61" shooting="63" crossing="5" heading="57" dribbling="53" speed="62" stamina="63" aggression="79" strength="66" fitness="75" creativity="57"/>	
			</player>
			<player id="Efrain Juarez" name="Efrain Juarez" birthday="22-02-2003" positions="cm-sm" nationality="me" number="4">
				<stats passing="83" tackling="69" shooting="58" crossing="64" heading="47" dribbling="53" speed="48" stamina="67" aggression="63" strength="62" fitness="66" creativity="58"/>		
			</player>
			<player id="Ki Sung-Yueng" name="Ki Sung-Yueng" birthday="24-01-2004" positions="cm" nationality="sk" number="18">
				<stats passing="77" tackling="33" shooting="23" crossing="56" heading="16" dribbling="78" speed="58" stamina="44" aggression="37" strength="28" fitness="49" creativity="63"/>		
			</player>
			<player id="Paddy McCourt" name="Paddy McCourt" birthday="16-12-1998" positions="sm" nationality="ni" number="20">
				<stats passing="69" tackling="77" shooting="58" crossing="69" heading="61" dribbling="64" speed="52" stamina="75" aggression="89" strength="74" fitness="69" creativity="62"/>		
			</player>
			<player id="Colin Doyle" name="Colin Doyle" birthday="12-6-2000" positions="gk" nationality="ir" number="13">
				<stats catching="50" shotStopping="76" distribution="60" fitness="67" stamina="84"/>		
			</player>
			<player id="Biram Kayal" name="Biram Kayal" birthday="02-05-2003" positions="cm-sm" nationality="is" number="33">
				<stats passing="55" tackling="21" shooting="54" crossing="57" heading="33" dribbling="58" speed="68" stamina="56" aggression="23" strength="32" fitness="85" creativity="58"/>		
			</player>
			<player id="Gary Hooper" name="Gary Hooper" birthday="26-01-2003" positions="cf" nationality="en" number="88">
				<stats passing="66" tackling="37" shooting="77" crossing="58" heading="68" dribbling="70" speed="40" stamina="39" aggression="35" strength="60" fitness="60" creativity="75"/>		
			</player>
			<player id="Georgios Samaras" name="Georgios Samaras" birthday="21-02-2000" positions="cf" nationality="gr" number="9">
				<stats passing="55" tackling="25" shooting="63" crossing="54" heading="63" dribbling="47" speed="73" stamina="66" aggression="47" strength="52" fitness="77" creativity="53"/>		
			</player>
			<player id="Anthony Stokes" name="Anthony Stokes" birthday="25-07-2003" positions="cf" nationality="ir" number="10">
				<stats passing="54" tackling="34" shooting="64" crossing="47" heading="74" dribbling="60" speed="84" stamina="57" aggression="38" strength="59" fitness="65" creativity="53"/>		
			</player>
			<player id="Shaun Maloney" name="Shaun Maloney" birthday="24-01-1998" positions="cf" nationality="sc" number="13">
				<stats passing="60" tackling="33" shooting="69" crossing="30" heading="86" dribbling="58" speed="55" stamina="73" aggression="58" strength="99" fitness="75" creativity="55"/>		
			</player>
		</players>
	</club>

<club shirtColor="0xFF0000" sleevesColor="0xFFFFFF" stripesType="none">
		<name><![CDATA[Ajax Amsterdam]]></name>
		<profile>90</profile>
		<players>
			<player id="Maarten Stekelenburg" name="Maarten Stekelenburg" birthday="22-09-1998" positions="gk" nationality="ne" number="1">
				<stats catching="84" shotStopping="88" distribution="59" fitness="53" stamina="68"/>
			</player>
			<player id="Gregory van der wiel" name="Gregory van der Wiel" birthday="03-02-2003" positions="fb" nationality="ne" number="2">
				<stats passing="58" tackling="59" shooting="39" crossing="58" heading="55" dribbling="36" speed="83" stamina="72" aggression="49" strength="64" fitness="63" creativity="59"/>	
			</player>	
			<player id="Vernon Anita" name="Vernon Anita" birthday="04-04-2004" positions="fb" nationality="ne" number="5">
				<stats passing="62" tackling="65" shooting="38" crossing="64" heading="65" dribbling="64" speed="67" stamina="69" aggression="54" strength="63" fitness="78" creativity="58"/>
			</player>
			<player id="Bruno Silva" name="Bruno Silva" birthday="29-03-2004" positions="fb" nationality="ur" number="22">
				<stats passing="64" tackling="71" shooting="34" crossing="54" heading="68" dribbling="37" speed="59" stamina="75" aggression="54" strength="67" fitness="68" creativity="53"/>
			</player>
			<player id="Daley Blind" name="Daley Blind" birthday="09-03-2005" positions="fb-cb" nationality="ne" number="17">
				<stats passing="58" tackling="72" shooting="44" crossing="38" heading="74" dribbling="53" speed="59" stamina="70" aggression="89" strength="63" fitness="84" creativity="59"/>				
			</player>
			<player id="Oleguer Presas" name="Oleguer Presas" birthday="02-02-1995" positions="cb" nationality="es" number="23">
				<stats passing="64" tackling="77" shooting="25" crossing="16" heading="87" dribbling="26" speed="65" stamina="70" aggression="70" strength="80" fitness="70" creativity="45"/>				
			</player>
			<player id="Toby Alderweireld" name="Toby Alderweireld" birthday="02-03-2004" positions="cb" nationality="be" number="3">
				<stats passing="65" tackling="69" shooting="30" crossing="58" heading="60" dribbling="54" speed="69" stamina="70" aggression="60" strength="65" fitness="70" creativity="55"/>
			</player>
			<player id="Jan Vertonghen" name="Jan Vertonghen" birthday="24-04-2002" positions="cb" nationality="be" number="4">
				<stats passing="58" tackling="80" shooting="23" crossing="17" heading="89" dribbling="17" speed="52" stamina="68" aggression="69" strength="73" fitness="40" creativity="44"/>
			</player>
			<player id="Andre Ooijer" name="Andre Ooijer" birthday="11-07-1989" positions="cb" nationality="ne" number="13">
				<stats passing="58" tackling="74" shooting="44" crossing="58" heading="69" dribbling="54" speed="68" stamina="67" aggression="44" strength="53" fitness="85" creativity="54"/>
			</player>
			<player id="Eyong Enoh" name="Eyong Enoh" birthday="23-03-2001" positions="dm" nationality="cm" number="6">
				<stats passing="58" tackling="60" shooting="42" crossing="68" heading="35" dribbling="53" speed="54" stamina="68" aggression="39" strength="42" fitness="79" creativity="59"/>	
			</player>
			<player id="Rasmus Lindgren" name="Rasmus Lindgren" birthday="29-11-1999" positions="cm" nationality="sw" number="18">
				<stats passing="62" tackling="76" shooting="60" crossing="34" heading="67" dribbling="58" speed="58" stamina="74" aggression="83" strength="82" fitness="75" creativity="46"/>
			</player>
			<player id="Teemu Tainio" name="Teemu Tainio" birthday="27-11-1994" positions="cm-dm-sm" nationality="fi" number="19">
				<stats passing="59" tackling="74" shooting="60" crossing="39" heading="74" dribbling="49" speed="53" stamina="68" aggression="64" strength="89" fitness="54" creativity="44"/>
			</player>
			<player id="Demy de Zeeuw" name="Demy de Zeeuw" birthday="26-05-1998" positions="dm" nationality="ne" number="20">
				<stats passing="58" tackling="39" shooting="58" crossing="68" heading="39" dribbling="56" speed="63" stamina="82" aggression="69" strength="54" fitness="73" creativity="59"/>	
			</player>
			<player id="Christian Eriksen" name="Christian Eriksen" birthday="14-02-2007" positions="am-sm" nationality="dn" number="8">
				<stats passing="75" tackling="58" shooting="53" crossing="73" heading="39" dribbling="57" speed="58" stamina="78" aggression="34" strength="64" fitness="42" creativity="69"/>		
			</player>
			<player id="Siem de Jong" name="Siem de Jong" birthday="28-01-2004" positions="am-sm" nationality="ne" number="10">
				<stats passing="69" tackling="53" shooting="45" crossing="75" heading="64" dribbling="69" speed="54" stamina="63" aggression="35" strength="54" fitness="64" creativity="75"/>		
			</player>
			<player id="Urby Emanuelson" name="Urby Emanuelson" birthday="16-06-2001" positions="sm-fb" nationality="ne" number="11">
				<stats passing="70" tackling="38" shooting="58" crossing="70" heading="15" dribbling="70" speed="63" stamina="68" aggression="44" strength="38" fitness="60" creativity="65"/>		
			</player>
			<player id="Nicolas Lodeiro" name="Nicolas Lodeiro" birthday="21-03-2004" positions="am-sm-cm" nationality="ur" number="15">
				<stats passing="65" tackling="47" shooting="64" crossing="70" heading="58" dribbling="68" speed="59" stamina="75" aggression="60" strength="60" fitness="70" creativity="60"/>	
			</player>
			<player id="Kenneth Vermeer" name="Kenneth Vermeer" birthday="10-01-2001" positions="gk" nationality="ne" number="12">
				<stats catching="70" shotStopping="70" distribution="45" fitness="60" stamina="35"/>		
			</player>
			<player id="Miralem Sulejmani" name="Miralem Sulejmani" birthday="05-12-2003" positions="cf-wf" nationality="se" number="7">
				<stats passing="45" tackling="20" shooting="54" crossing="59" heading="40" dribbling="75" speed="80" stamina="64" aggression="30" strength="60" fitness="75" creativity="49"/>		
			</player>
			<player id="Mounir El Hamdaoui" name="Mounir El Hamdaoui" birthday="14-07-1999" positions="cf" nationality="mo" number="9">
				<stats passing="59" tackling="12" shooting="43" crossing="60" heading="63" dribbling="73" speed="70" stamina="67" aggression="58" strength="75" fitness="66" creativity="70"/>		
			</player>
			<player id="Luis Suarez" name="Luis Suarez" birthday="24-01-2002" positions="cf" nationality="ur" number="16">
				<stats passing="65" tackling="16" shooting="71" crossing="58" heading="54" dribbling="50" speed="75" stamina="80" aggression="60" strength="29" fitness="73" creativity="48"/>		
			</player>
			<player id="Dario Cvitanich" name="Dario Cvitanich" birthday="16-05-1999" positions="cf" nationality="ar" number="27">
				<stats passing="70" tackling="34" shooting="68" crossing="49" heading="76" dribbling="70" speed="65" stamina="75" aggression="53" strength="75" fitness="67" creativity="68"/>		
			</player>
			<player id="Aras Ozbiliz" name="Aras Ozbiliz" birthday="09-03-2005" positions="wf" nationality="tu" number="33">
				<stats passing="63" tackling="54" shooting="60" crossing="36" heading="77" dribbling="53" speed="55" stamina="70" aggression="44" strength="78" fitness="68" creativity="45"/>		
			</player>
			<player id="Jeroen Verhoeven" name="Jeroen Verhoeven" birthday="30-04-1995" positions="gk" nationality="ne" number="30">
				<stats catching="56" shotStopping="72" distribution="79" fitness="62" stamina="58"/>		
			</player>
		</players>
	</club>

<club shirtColor="0x000000" sleevesColor="0xFFFFFF" stripesType="none" scoreMultiplier="1" attackScore="A" defendScore="B">
		<name><![CDATA[Dynamo Kyiv]]></name>
		<profile>90</profile>
		<players>
			<player id="Mykola Shaparenko" name="Mykola Shaparenko" birthday="04-10-1998" positions="cm-am-dm" nationality="uk" number="10">
				<stats passing="71" tackling="61" shooting="64" crossing="67" heading="57" dribbling="69" speed="70" stamina="67" aggression="67" strength="60" fitness="66" creativity="71"/>
			</player>
			<player id="Volodymyr Brazhko" name="Volodymyr Brazhko" birthday="23-01-2002" positions="dm-cm-cb" nationality="uk" number="6">
				<stats passing="64" tackling="63" shooting="60" crossing="59" heading="64" dribbling="61" speed="61" stamina="67" aggression="63" strength="66" fitness="64" creativity="61"/>
			</player>
			<player id="Vitaliy Buyalskyi" name="Vitaliy Buyalskyi" birthday="06-01-1993" positions="am-cm-dm" nationality="uk" number="29">
				<stats passing="71" tackling="65" shooting="67" crossing="64" heading="42" dribbling="73" speed="69" stamina="70" aggression="49" strength="50" fitness="64" creativity="71"/>
			</player>
			<player id="Oleksandr Pikhalyonok" name="Oleksandr Pikhalyonok" birthday="07-05-1997" positions="cm-am-dm" nationality="uk" number="8">
				<stats passing="69" tackling="58" shooting="63" crossing="68" heading="53" dribbling="65" speed="59" stamina="64" aggression="58" strength="58" fitness="60" creativity="69"/>
			</player>
			<player id="Andriy Yarmolenko" name="Andriy Yarmolenko" birthday="23-10-1989" positions="sm-cf-wf" nationality="uk" number="7">
				<stats passing="66" tackling="37" shooting="67" crossing="67" heading="64" dribbling="65" speed="53" stamina="55" aggression="64" strength="66" fitness="57" creativity="66"/>
			</player>
			<player id="Oleksandr Karavaiev" name="Oleksandr Karavaiev" birthday="02-06-1992" positions="fb-sm" nationality="uk" number="20">
				<stats passing="63" tackling="62" shooting="49" crossing="64" heading="55" dribbling="64" speed="68" stamina="67" aggression="56" strength="56" fitness="65" creativity="64"/>
			</player>
			<player id="Mykola Mykhailenko" name="Mykola Mykhailenko" birthday="22-05-2001" positions="cm-dm-cb" nationality="uk" number="91">
				<stats passing="60" tackling="54" shooting="52" crossing="53" heading="56" dribbling="58" speed="57" stamina="60" aggression="49" strength="59" fitness="59" creativity="58"/>
			</player>
			<player id="Vladyslav Dubinchak" name="Vladyslav Dubinchak" birthday="01-07-1998" positions="fb-sm-wf" nationality="uk" number="44">
				<stats passing="62" tackling="60" shooting="45" crossing="61" heading="49" dribbling="63" speed="67" stamina="62" aggression="61" strength="49" fitness="59" creativity="62"/>
			</player>
			<player id="Oleksandr Yatsyk" name="Oleksandr Yatsyk" birthday="03-01-2003" positions="cm" nationality="uk" number="5">
				<stats passing="60" tackling="56" shooting="52" crossing="54" heading="53" dribbling="62" speed="58" stamina="62" aggression="57" strength="55" fitness="59" creativity="60"/>
			</player>
			<player id="Kostiantyn Vivcharenko" name="Kostiantyn Vivcharenko" birthday="10-06-2002" positions="fb-cb-sm" nationality="uk" number="2">
				<stats passing="60" tackling="57" shooting="45" crossing="58" heading="56" dribbling="59" speed="63" stamina="59" aggression="59" strength="58" fitness="59" creativity="57"/>
			</player>
			<player id="Maksym Bragaru" name="Maksym Bragaru" birthday="21-07-2002" positions="sm-fb-wf" nationality="uk" number="45">
				<stats passing="60" tackling="55" shooting="51" crossing="53" heading="54" dribbling="64" speed="63" stamina="64" aggression="59" strength="54" fitness="61" creativity="59"/>
			</player>
			<player id="Valentyn Rubchynskyi" name="Valentyn Rubchynskyi" birthday="15-02-2002" positions="cm-am-dm" nationality="uk" number="15">
				<stats passing="60" tackling="51" shooting="49" crossing="52" heading="41" dribbling="61" speed="62" stamina="58" aggression="53" strength="47" fitness="57" creativity="58"/>
			</player>
			<player id="Oleksandr Tymchyk" name="Oleksandr Tymchyk" birthday="20-01-1997" positions="fb-cb-sm" nationality="uk" number="18">
				<stats passing="60" tackling="62" shooting="45" crossing="59" heading="55" dribbling="62" speed="77" stamina="64" aggression="53" strength="52" fitness="65" creativity="59"/>
			</player>
			<player id="Ángel Torres" name="Ángel Torres" birthday="06-04-2000" positions="sm-am-wf" nationality="co" number="17">
				<stats passing="52" tackling="36" shooting="53" crossing="50" heading="53" dribbling="55" speed="69" stamina="58" aggression="51" strength="60" fitness="62" creativity="52"/>
			</player>
			<player id="Nazar Voloshyn" name="Nazar Voloshyn" birthday="17-06-2003" positions="sm-am-wf" nationality="uk" number="9">
				<stats passing="61" tackling="26" shooting="60" crossing="58" heading="53" dribbling="65" speed="75" stamina="56" aggression="54" strength="49" fitness="60" creativity="62"/>
			</player>
			<player id="Eduardo Guerrero" name="Eduardo Guerrero" birthday="21-02-2000" positions="cf" nationality="pa" number="39">
				<stats passing="59" tackling="19" shooting="59" crossing="54" heading="57" dribbling="62" speed="65" stamina="60" aggression="53" strength="56" fitness="61" creativity="58"/>
			</player>
			<player id="Denys Popov" name="Denys Popov" birthday="17-02-1999" positions="cb-fb-dm" nationality="uk" number="4">
				<stats passing="57" tackling="65" shooting="40" crossing="41" heading="71" dribbling="55" speed="56" stamina="59" aggression="68" strength="68" fitness="60" creativity="46"/>
			</player>
			<player id="Eric Ramírez" name="Eric Ramírez" birthday="20-11-1998" positions="cf" nationality="ve" number="37">
				<stats passing="49" tackling="36" shooting="56" crossing="41" heading="62" dribbling="52" speed="56" stamina="58" aggression="51" strength="63" fitness="60" creativity="46"/>
			</player>
			<player id="Vladyslav Kabaev" name="Vladyslav Kabaev" birthday="01-09-1995" positions="sm-am-wf" nationality="uk" number="22">
				<stats passing="64" tackling="33" shooting="58" crossing="58" heading="39" dribbling="69" speed="73" stamina="62" aggression="46" strength="45" fitness="60" creativity="63"/>
			</player>
			<player id="Taras Mykhavko" name="Taras Mykhavko" birthday="30-05-2005" positions="cb" nationality="uk" number="32">
				<stats passing="56" tackling="60" shooting="38" crossing="45" heading="63" dribbling="53" speed="57" stamina="56" aggression="55" strength="61" fitness="57" creativity="47"/>
			</player>
			<player id="Matviy Ponomarenko" name="Matviy Ponomarenko" birthday="11-01-2006" positions="cf-wf" nationality="uk" number="99">
				<stats passing="49" tackling="23" shooting="55" crossing="38" heading="58" dribbling="53" speed="60" stamina="53" aggression="52" strength="58" fitness="56" creativity="49"/>
			</player>
			<player id="Vladislav Blănuță" name="Vladislav Blănuță" birthday="12-01-2002" positions="cf" nationality="ro" number="77">
				<stats passing="50" tackling="23" shooting="57" crossing="36" heading="68" dribbling="56" speed="62" stamina="62" aggression="53" strength="67" fitness="64" creativity="48"/>
			</player>
			<player id="Bilovar Bilovar" name="Bilovar Bilovar" birthday="05-02-2001" positions="cb-dm-fb" nationality="uk" number="40">
				<stats passing="55" tackling="59" shooting="36" crossing="37" heading="60" dribbling="49" speed="58" stamina="56" aggression="54" strength="60" fitness="57" creativity="43"/>
			</player>
			<player id="Samba Diallo" name="Samba Diallo" birthday="05-01-2003" positions="sm-wf" nationality="se" number="30">
				<stats passing="52" tackling="23" shooting="53" crossing="50" heading="42" dribbling="59" speed="64" stamina="56" aggression="45" strength="56" fitness="57" creativity="50"/>
			</player>
			<player id="Aliou Thiaré" name="Aliou Thiaré" birthday="20-12-2003" positions="cb" nationality="se" number="66">
				<stats passing="42" tackling="53" shooting="32" crossing="30" heading="62" dribbling="42" speed="45" stamina="51" aggression="57" strength="62" fitness="52" creativity="34"/>
			</player>
			<player id="Ruslan Neshcheret" name="Ruslan Neshcheret" birthday="22-01-2002" positions="gk" nationality="uk" number="35">
				<stats catching="63" shotStopping="67" distribution="62" fitness="62" stamina="24"/>
			</player>
			<player id="Vyacheslav Surkis" name="Vyacheslav Surkis" birthday="27-02-2006" positions="gk" nationality="uk" number="71">
				<stats catching="46" shotStopping="46" distribution="46" fitness="38" stamina="30"/>
			</player>
			<player id="Valentyn Morgun" name="Valentyn Morgun" birthday="10-08-2001" positions="gk" nationality="uk" number="51">
				<stats catching="51" shotStopping="54" distribution="52" fitness="53" stamina="22"/>
			</player>
			<player id="Denys Ignatenko" name="Denys Ignatenko" birthday="11-01-2003" positions="gk" nationality="uk" number="74">
				<stats catching="51" shotStopping="53" distribution="53" fitness="55" stamina="21"/>
			</player>
		</players>
	</club>

<club shirtColor="0xFF0000" sleevesColor="0xFFFFFF" stripesType="none">
		<name><![CDATA[CSKA Moskow]]></name>
		<profile>60</profile>
		<players>
			<player id="Sergei Chepchugov" name="Sergei Chepchugov" birthday="15-07-2000" positions="gk" nationality="ru" number="1">
				<stats catching="68" shotStopping="73" distribution="69" fitness="74" stamina="58"/>
			</player>
			<player id="Deividas Semberas" name="Deividas Semberas" birthday="02-08-1993" positions="fb" nationality="li" number="2">
				<stats passing="53" tackling="66" shooting="35" crossing="41" heading="67" dribbling="39" speed="62" stamina="75" aggression="84" strength="77" fitness="69" creativity="37"/>	
			</player>	
			<player id="Viktor Vasin" name="Viktor Vasin" birthday="06-10-2003" positions="cb-fb" nationality="ru" number="3">
				<stats passing="32" tackling="68" shooting="37" crossing="54" heading="64" dribbling="48" speed="55" stamina="58" aggression="69" strength="70" fitness="60" creativity="37"/>
			</player>
			<player id="Sergei Ignashevich" name="Sergei Ignashevich" birthday="14-07-1994" positions="cb=fb" nationality="ru" number="4">
				<stats passing="44" tackling="73" shooting="29" crossing="52" heading="70" dribbling="43" speed="58" stamina="68" aggression="70" strength="57" fitness="75" creativity="39"/>
			</player>
			<player id="Aleksei Berezutski" name="Aleksei Berezutski" birthday="20-06-1997" positions="cb-fb" nationality="ru" number="6">
				<stats passing="63" tackling="78" shooting="32" crossing="64" heading="84" dribbling="54" speed="36" stamina="74" aggression="59" strength="62" fitness="70" creativity="54"/>				
			</player>
			<player id="Kirill Nababkin" name="Kirill Nababkin" birthday="08-09-2002" positions="fb" nationality="ru" number="14">
				<stats passing="59" tackling="52" shooting="54" crossing="64" heading="34" dribbling="51" speed="60" stamina="64" aggression="39" strength="38" fitness="68" creativity="60"/>				
			</player>
			<player id="Georgi Schennikov" name="Georgi Schennikov" birthday="27-04-2006" positions="cb" nationality="ru" number="42">
				<stats passing="44" tackling="76" shooting="49" crossing="32" heading="79" dribbling="26" speed="63" stamina="67" aggression="69" strength="94" fitness="74" creativity="27"/>
			</player>
			<player id="Vasili Berezutski" name="Vasili Berezutski" birthday="20-06-1997" positions="cb" nationality="ru" number="24">
				<stats passing="64" tackling="73" shooting="15" crossing="34" heading="79" dribbling="33" speed="64" stamina="75" aggression="62" strength="74" fitness="75" creativity="44"/>
			</player>
			<player id="Chidi Odiah" name="Chidi Odiah" birthday="17-12-1998" positions="fb" nationality="ng" number="15">
				<stats passing="61" tackling="72" shooting="43" crossing="39" heading="74" dribbling="38" speed="59" stamina="68" aggression="65" strength="75" fitness="62" creativity="54"/>
			</player>
			<player id="Pavel Mamayev" name="Pavel Mamayev" birthday="17-09-2003" positions="cm-dm" nationality="ru" number="11">
				<stats passing="73" tackling="50" shooting="39" crossing="74" heading="58" dribbling="55" speed="56" stamina="69" aggression="66" strength="64" fitness="70" creativity="64"/>	
			</player>
			<player id="Evgeni Aldonin" name="Evgeni Aldonin" birthday="22-01-1995" positions="cm" nationality="uk" number="22">
				<stats passing="58" tackling="70" shooting="34" crossing="44" heading="78" dribbling="39" speed="55" stamina="74" aggression="78" strength="79" fitness="60" creativity="54"/>	
			</player>
			<player id="Keisuke Honda" name="Keisuke Honda" birthday="13-06-2001" positions="cm-sm-am" nationality="ja" number="7">
				<stats passing="54" tackling="64" shooting="54" crossing="64" heading="65" dribbling="53" speed="59" stamina="84" aggression="70" strength="70" fitness="84" creativity="59"/>
			</player>
			<player id="Nika Piliyev" name="Nika Piliyev" birthday="21-03-2006" positions="cm-sm" nationality="ru" number="70">
				<stats passing="68" tackling="40" shooting="57" crossing="70" heading="39" dribbling="70" speed="49" stamina="60" aggression="56" strength="59" fitness="59" creativity="70"/>	
			</player>
			<player id="Mark Gonzalez" name="Mark Gonzalez" birthday="10-07-1999" positions="sm" nationality="ch" number="13">
				<stats passing="59" tackling="56" shooting="58" crossing="65" heading="79" dribbling="64" speed="58" stamina="60" aggression="74" strength="80" fitness="75" creativity="65"/>		
			</player>
			<player id="Alan Dzagoev" name="Alan Dzagoev" birthday="17-06-2005" positions="cm" nationality="ru" number="10">
				<stats passing="70" tackling="70" shooting="42" crossing="59" heading="44" dribbling="51" speed="61" stamina="79" aggression="64" strength="59" fitness="79" creativity="50"/>		
			</player>
			<player id="Elvir Rahimic" name="Elvir Rahimic" birthday="04-04-1991" positions="cm" nationality="ru" number="25">
				<stats passing="68" tackling="69" shooting="65" crossing="44" heading="52" dribbling="51" speed="55" stamina="68" aggression="70" strength="63" fitness="75" creativity="65"/>		
			</player>
			<player id="Zoran Tosic" name="Zoran Tosic" birthday="28-04-2002" positions="sm" nationality="se" number="21">
				<stats passing="64" tackling="29" shooting="44" crossing="78" heading="25" dribbling="75" speed="80" stamina="65" aggression="35" strength="33" fitness="60" creativity="64"/>	
			</player>
			<player id="Igor Akinfeev" name="Igor Akinfeev" birthday="08-04-2001" positions="gk" nationality="ru" number="35">
				<stats catching="57" shotStopping="65" distribution="62" fitness="60" stamina="59"/>		
			</player>
			<player id="Sekou Oliseh" name="Sekou Oliseh" birthday="05-06-2005" positions="sm" nationality="li" number="26">
				<stats passing="64" tackling="39" shooting="60" crossing="69" heading="38" dribbling="69" speed="75" stamina="70" aggression="29" strength="33" fitness="70" creativity="68"/>		
			</player>
			<player id="Seydou Doumbia" name="Seydou Doumbia" birthday="31-12-2002" positions="cf" nationality="iv" number="8">
				<stats passing="75" tackling="34" shooting="63" crossing="58" heading="69" dribbling="64" speed="65" stamina="53" aggression="55" strength="75" fitness="64" creativity="70"/>		
			</player>
			<player id="Vagner Love" name="Vagner Love" birthday="11-06-1999" positions="cf" nationality="br" number="9">
				<stats passing="62" tackling="30" shooting="59" crossing="60" heading="59" dribbling="64" speed="68" stamina="75" aggression="88" strength="54" fitness="80" creativity="65"/>		
			</player>
			<player id="Tomas Necid" name="Tomas Necid" birthday="13-08-2004" positions="cf" nationality="cz" number="89">
				<stats passing="53" tackling="29" shooting="56" crossing="51" heading="74" dribbling="64" speed="75" stamina="59" aggression="53" strength="89" fitness="39" creativity="44"/>		
			</player>
		</players>	
	</club>

<club shirtColor="0xFF0000" sleevesColor="0xFFFFFF" stripesType="none">
		<name><![CDATA[Olympiacos]]></name>
		<profile>60</profile>
		<players>
			<player id="Nikos Papadopoulos" name="Nikos Papadopoulos" birthday="11-04-2005" positions="gk" nationality="gr" number="1">
				<stats catching="74" shotStopping="79" distribution="38" fitness="58" stamina="54"/>
			</player>
			<player id="Ioannis Maniatis" name="Ioannis Maniatis" birthday="12-10-2001" positions="fb" nationality="gr" number="2">
				<stats passing="53" tackling="68" shooting="46" crossing="77" heading="58" dribbling="64" speed="52" stamina="89" aggression="54" strength="50" fitness="78" creativity="54"/>	
			</player>	
			<player id="Francois Modesto" name="Francois Modesto" birthday="19-08-1993" positions="fb" nationality="fr" number="3">
				<stats passing="59" tackling="74" shooting="21" crossing="54" heading="69" dribbling="52" speed="65" stamina="78" aggression="84" strength="80" fitness="76" creativity="49"/>
			</player>
			<player id="Olof Mellberg" name="Olof Mellberg" birthday="03-09-1992" positions="cb" nationality="sw" number="4">
				<stats passing="38" tackling="68" shooting="42" crossing="28" heading="73" dribbling="34" speed="64" stamina="65" aggression="72" strength="73" fitness="79" creativity="55"/>
			</player>
			<player id="Raul Bravo" name="Raul Bravo" birthday="14-04-1996" positions="fb-cb" nationality="es" number="15">
				<stats passing="61" tackling="74" shooting="27" crossing="29" heading="74" dribbling="12" speed="63" stamina="79" aggression="59" strength="68" fitness="64" creativity="53"/>				
			</player>
			<player id="Jose Holebas" name="Jose Holebas" birthday="27-06-1999" positions="cb" nationality="ge" number="20">
				<stats passing="75" tackling="74" shooting="54" crossing="24" heading="79" dribbling="54" speed="69" stamina="69" aggression="58" strength="70" fitness="63" creativity="58"/>				
			</player>
			<player id="Vasilios Torosidis" name="Vasilios Torosidis" birthday="10-06-2000" positions="fb" nationality="gr" number="35">
				<stats passing="70" tackling="71" shooting="38" crossing="70" heading="64" dribbling="54" speed="58" stamina="73" aggression="94" strength="83" fitness="90" creativity="64"/>
			</player>
			<player id="Georgios Galitsios" name="Georgios Galitsios" birthday="06-07-2001" positions="fb" nationality="gr" number="5">
				<stats passing="72" tackling="54" shooting="71" crossing="79" heading="54" dribbling="29" speed="64" stamina="94" aggression="53" strength="58" fitness="60" creativity="56"/>
			</player>
			<player id="Ariel Ibagaza" name="Ariel Ibagaza" birthday="27-10-1991" positions="dm-cm" nationality="ar" number="7">
				<stats passing="74" tackling="76" shooting="39" crossing="42" heading="54" dribbling="50" speed="63" stamina="74" aggression="89" strength="73" fitness="77" creativity="54"/>
			</player>
			<player id="Dudu" name="Dudu" birthday="15-04-1998" positions="dm-cm" nationality="br" number="8">
				<stats passing="53" tackling="68" shooting="31" crossing="44" heading="41" dribbling="44" speed="67" stamina="83" aggression="78" strength="79" fitness="81" creativity="42"/>	
			</player>
			<player id="David Fuster" name="David Fuster" birthday="03-02-1997" positions="cm" nationality="es" number="19">
				<stats passing="65" tackling="69" shooting="45" crossing="34" heading="41" dribbling="39" speed="59" stamina="90" aggression="59" strength="45" fitness="78" creativity="48"/>	
			</player>
			<player id="Ioannis Papadopoulos" name="Ioannis Papadopoulos" birthday="09-03-2004" positions="cm" nationality="gr" number="33">
				<stats passing="69" tackling="22" shooting="44" crossing="64" heading="29" dribbling="72" speed="70" stamina="75" aggression="43" strength="47" fitness="63" creativity="73"/>
			</player>
			<player id="Moises Hurtado" name="Moises Hurtado" birthday="20-02-1996" positions="dm" nationality="es" number="30">
				<stats passing="44" tackling="15" shooting="43" crossing="54" heading="23" dribbling="58" speed="72" stamina="68" aggression="52" strength="53" fitness="89" creativity="54"/>	
			</player>
			<player id="Jaouad Zairi" name="Jaouad Zairi" birthday="17-04-1997" positions="am-sm" nationality="mo" number="11">
				<stats passing="55" tackling="37" shooting="58" crossing="56" heading="44" dribbling="50" speed="58" stamina="68" aggression="64" strength="58" fitness="75" creativity="58"/>		
			</player>
			<player id="Ioannis Fetfatzidis" name="Ioannis Fetfatzidis" birthday="21-12-2005" positions="cm-am-sm" nationality="gr" number="18">
				<stats passing="63" tackling="62" shooting="55" crossing="53" heading="39" dribbling="74" speed="78" stamina="71" aggression="44" strength="51" fitness="68" creativity="65"/>		
			</player>
			<player id="Dennis Rommedahl" name="Dennis Rommedahl" birthday="22-07-1993" positions="sm-am" nationality="dn" number="24">
				<stats passing="65" tackling="13" shooting="69" crossing="84" heading="22" dribbling="63" speed="84" stamina="79" aggression="66" strength="54" fitness="39" creativity="58"/>		
			</player>
			<player id="Albert Riera" name="Albert Riera" birthday="15-04-1997" positions="sm" nationality="es" number="77">
				<stats passing="77" tackling="54" shooting="54" crossing="58" heading="23" dribbling="69" speed="55" stamina="54" aggression="59" strength="41" fitness="63" creativity="68"/>	
			</player>
			<player id="Balazs Megyeri" name="Balazs Megyeri" birthday="31-03-2005" positions="gk" nationality="hu" number="42">
				<stats catching="53" shotStopping="64" distribution="62" fitness="59" stamina="22"/>		
			</player>
			<player id="Marko Pantelic" name="Marko Pantelic" birthday="15-09-1993" positions="cf" nationality="se" number="9">
				<stats passing="75" tackling="77" shooting="69" crossing="64" heading="84" dribbling="44" speed="45" stamina="90" aggression="80" strength="87" fitness="79" creativity="58"/>		
			</player>
			<player id="Kevin Mirallas" name="Kevin Mirallas" birthday="05-10-2002" positions="cf" nationality="be" number="14">
				<stats passing="74" tackling="33" shooting="69" crossing="74" heading="24" dribbling="73" speed="41" stamina="58" aggression="43" strength="59" fitness="72" creativity="69"/>		
			</player>
			<player id="Konstantinos Mitroglou" name="Konstantinos Mitroglou" birthday="12-03-2003" positions="cf" nationality="gr" number="22">
				<stats passing="59" tackling="25" shooting="76" crossing="27" heading="64" dribbling="53" speed="69" stamina="80" aggression="59" strength="78" fitness="74" creativity="53"/>		
			</player>
			<player id="Krisztian Nemeth" name="Krisztian Nemeth" birthday="05-01-2004" positions="cf" nationality="hu" number="29">
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
	<player id="Diego Maradona" name="Diego Maradona" birthday="30-10-1975" positions="am-cf" nationality="ag">
		<stats passing="85" tackling="68" shooting="88" crossing="79" heading="75" dribbling="97" speed="93" stamina="85" aggression="88" strength="84" fitness="78" creativity="94"/>
	</player>	
	<player id="Pelé" name="Pelé" birthday="23-10-1955" positions="cf" nationality="br">
		<stats passing="80" tackling="73" shooting="95" crossing="79" heading="92" dribbling="90" speed="93" stamina="85" aggression="77" strength="91" fitness="90" creativity="84"/>
	</player>	
	<player id="David Seaman" name="David Seaman" birthday="19-09-1978" positions="gk" nationality="en">
		<stats catching="82" shotStopping="83" distribution="71" fitness="75" stamina="85"/>
	</player>
	<player id="Peter Schmeichel" name="Peter Schmeichel" birthday="18-11-1978" positions="gk" nationality="dn">
		<stats catching="88" shotStopping="92" distribution="85" fitness="75" stamina="85"/>
	</player>
	<player id="Matthew Le Tissier" name="Matthew Le Tissier" birthday="14-10-1983" positions="am" nationality="en">
		<stats passing="83" tackling="22" shooting="73" crossing="79" heading="61" dribbling="82" speed="55" stamina="70" aggression="58" strength="62" fitness="75" creativity="93"/>
	</player>	
	<player id="Eric Cantona" name="Eric Cantona" birthday="24-05-1981" positions="cf" nationality="fr">
		<stats passing="79" tackling="34" shooting="88" crossing="69" heading="77" dribbling="85" speed="78" stamina="85" aggression="100" strength="71" fitness="90" creativity="100"/>
	</player>	
	<player id="Dennis Bergkamp" name="Dennis Bergkamp" birthday="10-05-1984" positions="cf" nationality="ne">
		<stats passing="80" tackling="73" shooting="81" crossing="79" heading="72" dribbling="82" speed="79" stamina="85" aggression="61" strength="70" fitness="90" creativity="92"/>
	</player>	
	<player id="Alan Shearer" name="Alan Shearer" birthday="13-08-1985" positions="cf" nationality="en">
		<stats passing="65" tackling="32" shooting="91" crossing="52" heading="88" dribbling="45" speed="71" stamina="85" aggression="85" strength="93" fitness="90" creativity="76"/>
	</player>	
	<player id="Gianfranco Zola" name="Gianfranco Zola" birthday="05-06-1981" positions="cf-am" nationality="it">
		<stats passing="88" tackling="23" shooting="87" crossing="89" heading="66" dribbling="90" speed="95" stamina="85" aggression="10" strength="64" fitness="90" creativity="95"/>
	</player>	
	<player id="Roy Keane" name="Roy Keane" birthday="10-08-1986" positions="dm" nationality="ir">
		<stats passing="72" tackling="88" shooting="57" crossing="52" heading="76" dribbling="61" speed="74" stamina="100" aggression="100" strength="91" fitness="90" creativity="75"/>
	</player>	
	<player id="David Beckham" name="David Beckham" birthday="02-05-1990" positions="sm" nationality="en">
		<stats passing="80" tackling="55" shooting="67" crossing="93" heading="64" dribbling="72" speed="70" stamina="85" aggression="77" strength="91" fitness="90" creativity="84"/>
	</player>	
	<player id="Paul Gascoigne" name="Paul Gascoigne" birthday="27-05-1982" positions="cm-am" nationality="en">
		<stats passing="80" tackling="62" shooting="77" crossing="79" heading="62" dribbling="80" speed="68" stamina="85" aggression="90" strength="91" fitness="65" creativity="91"/>
	</player>	
	<player id="Jurgen Klinsmann" name="Jurgen Klinsmann" birthday="30-07-1979" positions="cf" nationality="ge">
		<stats passing="71" tackling="55" shooting="93" crossing="57" heading="79" dribbling="67" speed="85" stamina="85" aggression="77" strength="91" fitness="90" creativity="75"/>
	</player>	
	<player id="Peter Beardsley" name="Peter Beardsley" birthday="18-01-1976" positions="cf-am" nationality="en">
		<stats passing="80" tackling="55" shooting="81" crossing="65" heading="70" dribbling="93" speed="95" stamina="85" aggression="77" strength="77" fitness="90" creativity="75"/>
	</player>	
	<player id="Stuart Pearce" name="Stuart Pearce" birthday="24-04-1977" positions="fb" nationality="en">
		<stats passing="61" tackling="84" shooting="41" crossing="71" heading="68" dribbling="68" speed="79" stamina="85" aggression="93" strength="91" fitness="90" creativity="50"/>
	</player>	
	<player id="Denis Irwin" name="Denis Irwin" birthday="31-10-1980" positions="fb" nationality="ir">
		<stats passing="68" tackling="82" shooting="66" crossing="85" heading="75" dribbling="86" speed="77" stamina="85" aggression="55" strength="91" fitness="90" creativity="62"/>
	</player>	
	<player id="Paolo Di Canio" name="Paolo Di Canio" birthday="09-07-1983" positions="cf" nationality="it">
		<stats passing="80" tackling="66" shooting="81" crossing="72" heading="71" dribbling="77" speed="68" stamina="85" aggression="98" strength="71" fitness="90" creativity="91"/>
	</player>	
	<player id="Ruud Gullit" name="Ruud Gullit" birthday="01-09-1977" positions="cb-cm-cf" nationality="ne">
		<stats passing="84" tackling="78" shooting="67" crossing="79" heading="71" dribbling="73" speed="75" stamina="85" aggression="23" strength="67" fitness="90" creativity="88"/>
	</player>	
	<player id="Graeme Le Saux" name="Graeme Le Saux" birthday="17-10-1983" positions="fb-sm" nationality="en">
		<stats passing="71" tackling="77" shooting="22" crossing="79" heading="71" dribbling="77" speed="76" stamina="85" aggression="45" strength="66" fitness="90" creativity="82"/>
	</player>	
	<player id="Steve Bould" name="Steve Bould" birthday="16-11-1977" positions="cb" nationality="en">
		<stats passing="63" tackling="86" shooting="17" crossing="14" heading="87" dribbling="10" speed="64" stamina="85" aggression="77" strength="93" fitness="90" creativity="12"/>
	</player>	
	<player id="Tony Adams" name="Tony Adams" birthday="10-10-1981" positions="cb" nationality="en">
		<stats passing="54" tackling="91" shooting="7" crossing="41" heading="92" dribbling="61" speed="72" stamina="85" aggression="65" strength="91" fitness="90" creativity="25"/>
	</player>	
	<player id="Jaap Stam" name="Jaap Stam" birthday="17-07-1987" positions="cb" nationality="ne">
		<stats passing="72" tackling="88" shooting="34" crossing="40" heading="91" dribbling="75" speed="72" stamina="85" aggression="83" strength="82" fitness="70" creativity="79"/>
	</player>	
	<player id="Andrei Kanchelskis" name="Andrei Kanchelskis" birthday="23-01-1984" positions="sm" nationality="ru">
		<stats passing="77" tackling="37" shooting="68" crossing="83" heading="53" dribbling="91" speed="95" stamina="90" aggression="49" strength="61" fitness="90" creativity="84"/>
	</player>	
	<player id="Paul Ince" name="Paul Ince" birthday="21-10-1982" positions="dm-cm" nationality="en">
		<stats passing="81" tackling="90" shooting="67" crossing="79" heading="81" dribbling="67" speed="81" stamina="90" aggression="96" strength="91" fitness="90" creativity="70"/>
	</player>	
	<player id="Emmanuel Petit" name="Emmanuel Petit" birthday="22-09-1985" positions="dm" nationality="fr">
		<stats passing="74" tackling="82" shooting="69" crossing="79" heading="77" dribbling="64" speed="78" stamina="85" aggression="77" strength="91" fitness="90" creativity="84"/>
	</player>	
	<player id="David Ginola" name="David Ginola" birthday="25-01-1982" positions="sm" nationality="fr">
		<stats passing="83" tackling="34" shooting="72" crossing="88" heading="34" dribbling="87" speed="88" stamina="85" aggression="67" strength="71" fitness="90" creativity="90"/>
	</player>	
	<player id="Giorgi Kinkladze" name="Giorgi Kinkladze" birthday="06-07-1988" positions="am-cm" nationality="ge">
		<stats passing="77" tackling="43" shooting="79" crossing="75" heading="60" dribbling="97" speed="88" stamina="85" aggression="20" strength="60" fitness="90" creativity="89"/>
	</player>	
	<player id="Igor Stimac" name="Igor Stimac" birthday="06-09-1982" positions="cb" nationality="cr">
		<stats passing="81" tackling="77" shooting="32" crossing="66" heading="81" dribbling="67" speed="61" stamina="85" aggression="40" strength="91" fitness="90" creativity="84"/>
	</player>	
	<player id="Teddy Sheringham" name="Teddy Sheringham" birthday="02-04-1981" positions="cf" nationality="en">
		<stats passing="77" tackling="33" shooting="81" crossing="82" heading="70" dribbling="61" speed="67" stamina="85" aggression="50" strength="71" fitness="70" creativity="88"/>
	</player>	
	<player id="Jay-Jay Okocha" name="Jay-Jay Okocha" birthday="14-08-1988" positions="am" nationality="ng">
		<stats passing="82" tackling="54" shooting="76" crossing="74" heading="67" dribbling="84" speed="86" stamina="85" aggression="71" strength="75" fitness="70" creativity="88"/>
	</player>	
	<player id="Alan Martin" name="Alan Martin" birthday="18-05-1991" positions="cm" nationality="en" ageImprovement="50">
		<stats passing="93" tackling="77" shooting="82" crossing="51" heading="84" dribbling="82" speed="88" stamina="95" aggression="75" strength="91" fitness="72" creativity="85"/>
	</player>	
	<player id="Jimmy-Floyd Hasselbaink" name="Jimmy-Floyd Hasselbaink" birthday="27-03-1987" positions="cf" nationality="ne">
		<stats passing="57" tackling="33" shooting="87" crossing="61" heading="68" dribbling="70" speed="91" stamina="85" aggression="77" strength="91" fitness="90" creativity="71"/>
	</player>	
<player id="Sam Bellman" name="Sam Bellman" birthday="18-05-1990" positions="cb-dm" nationality="en" ageImprovement="50">
		<stats passing="67" tackling="95" shooting="59" crossing="63" heading="95" dribbling="30" speed="86" stamina="75" aggression="75" strength="87" fitness="75" creativity="25"/>
	</player>
<player id="Alick Stott" name="Alick Stott" birthday="18-05-1999" positions="cf" nationality="en">
		<stats passing="66" tackling="42" shooting="82" crossing="61" heading="76" dribbling="69" speed="75" stamina="75" aggression="45" strength="77" fitness="72" creativity="75"/>
	</player>
<player id="Richard Pendry" name="Richard Pendry" birthday="18-05-1999" positions="fb" nationality="en">
		<stats passing="75" tackling="77" shooting="32" crossing="66" heading="44" dribbling="66" speed="72" stamina="75" aggression="46" strength="65" fitness="72" creativity="87"/>
	</player>
<player id="Keith Martison" name="Keith Martison" birthday="14-02-2003" positions="sm" nationality="en">
		<stats passing="79" tackling="54" shooting="64" crossing="77" heading="66" dribbling="75" speed="89" stamina="82" aggression="74" strength="43" fitness="67" creativity="62"/>
	</player>
<player id="Conor Donovan" name="Conor Donovan" birthday="18-05-1999" positions="cm" nationality="en">
		<stats passing="73" tackling="42" shooting="62" crossing="61" heading="84" dribbling="62" speed="68" stamina="75" aggression="25" strength="91" fitness="72" creativity="85"/>
	</player>
<player id="Meriton Rrustemi" name="Meriton Rrustemi" birthday="18-05-1999" positions="cm" nationality="en">
		<stats passing="73" tackling="42" shooting="62" crossing="61" heading="84" dribbling="62" speed="68" stamina="75" aggression="25" strength="91" fitness="72" creativity="85"/>
	</player>
<player id="Dan Tiller" name="Dan Tiller" birthday="02-07-2002" positions="cm-am" nationality="en">
	<stats passing="80" tackling="31" shooting="54" crossing="62" heading="27" dribbling="79" speed="68" stamina="71" aggression="33" strength="29" fitness="68" creativity="71"/>
	</player>
<player id="Johnny Safi" name="Johnny Safi" birthday="06-05-1998" positions="fb" nationality="en">
	<stats passing="65" tackling="77" shooting="42" crossing="73" heading="69" dribbling="73" speed="88" stamina="89" aggression="74" strength="52" fitness="82" creativity="34"/>
	</player>
<player id="Andrei Rhodes" name="Andrei Rhodes" birthday="22-01-2000" positions="dm" nationality="en">
	<stats passing="79" tackling="47" shooting="58" crossing="84" heading="34" dribbling="80" speed="69" stamina="68" aggression="62" strength="33" fitness="73" creativity="78"/>	
	</player>
<player id="Chris Scotton" name="Chris Scotton" birthday="14-09-2003" positions="cb" nationality="en">
	<stats passing="55" tackling="56" shooting="40" crossing="52" heading="57" dribbling="43" speed="68" stamina="67" aggression="65" strength="57" fitness="68" creativity="45"/>		
	</player>
<player id="Jun Wei" name="Jun Wei" birthday="20-12-1995" positions="cb" nationality="en">
		<stats passing="53" tackling="80" shooting="12" crossing="26" heading="73" dribbling="39" speed="68" stamina="44" aggression="69" strength="84" fitness="30" creativity="44"/>
	</player>
<player id="Albert Popoola" name="Albert Popoola" birthday="22-04-1992" positions="cm-dm" nationality="en">
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
         var _loc5_:Array = getPromotedTeamsFrom(param1,1,3);
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
         updateLowerLeagues(param1,_loc2_,_loc5_);
      }
      
      private static function updateLowerLeagues(param1:Game, param2:Array, param3:Array) : void
      {
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:League = null;
         var _loc9_:Array = null;
         var _loc10_:Array = null;
         var _loc11_:Array = null;
         _loc4_ = getPromotedTeamsFrom(param1,2,3);
         _loc5_ = getRelegatedTeams(param1.leagues[1],3);
         _loc6_ = param1.leagues[1].entrants.concat();
         _loc6_ = removeClubs(_loc6_,_loc4_);
         _loc6_ = removeClubs(_loc6_,_loc5_);
         _loc6_ = _loc6_.concat(param3);
         _loc8_ = new League();
         _loc8_.name = param1.leagues[1].name;
         _loc7_ = 0;
         while(_loc7_ < _loc6_.length)
         {
            _loc8_.addEntrant(_loc6_[_loc7_].club ? _loc6_[_loc7_].club : _loc6_[_loc7_]);
            _loc7_++;
         }
         _loc7_ = 0;
         while(_loc7_ < _loc4_.length)
         {
            _loc8_.addEntrant(_loc4_[_loc7_]);
            _loc7_++;
         }
         param1.leagues[1] = _loc8_;
         _loc9_ = getPromotedTeamsFrom(param1,3,3);
         _loc10_ = getRelegatedTeams(param1.leagues[2],3);
         _loc11_ = param1.leagues[2].entrants.concat();
         _loc11_ = removeClubs(_loc11_,_loc9_);
         _loc11_ = removeClubs(_loc11_,_loc10_);
         _loc11_ = _loc11_.concat(_loc5_);
         _loc8_ = new League();
         _loc8_.name = param1.leagues[2].name;
         _loc7_ = 0;
         while(_loc7_ < _loc11_.length)
         {
            _loc8_.addEntrant(_loc11_[_loc7_].club ? _loc11_[_loc7_].club : _loc11_[_loc7_]);
            _loc7_++;
         }
         _loc7_ = 0;
         while(_loc7_ < _loc9_.length)
         {
            _loc8_.addEntrant(_loc9_[_loc7_]);
            _loc7_++;
         }
         param1.leagues[2] = _loc8_;
         _loc8_ = new League();
         _loc8_.name = param1.leagues[3].name;
         _loc11_ = param1.leagues[3].entrants.concat();
         _loc11_ = removeClubs(_loc11_,_loc9_);
         _loc11_ = _loc11_.concat(_loc10_);
         _loc7_ = 0;
         while(_loc7_ < _loc11_.length)
         {
            _loc8_.addEntrant(_loc11_[_loc7_].club ? _loc11_[_loc7_].club : _loc11_[_loc7_]);
            _loc7_++;
         }
         param1.leagues[3] = _loc8_;
         Main.currentGame.promotedTeams = null;
      }
      
      private static function getPromotedTeamsFrom(param1:Game, param2:int, param3:int) : Array
      {
         var _loc4_:int = 0;
         var _loc5_:Array = new Array();
         var _loc6_:int = 0;
         if(param2 >= param1.leagues.length)
         {
            return _loc5_;
         }
         if(!param1.promotedTeams)
         {
            param1.promotedTeams = new Array();
         }
         _loc4_ = 0;
         while(_loc4_ < param3 && param1.leagues[param2].entrants.length > 0)
         {
            _loc6_ = int(param1.leagues[param2].entrants.length * Math.random());
            _loc5_.push(param1.leagues[param2].entrants[_loc6_].club ? param1.leagues[param2].entrants[_loc6_].club : param1.leagues[param2].entrants[_loc6_]);
            param1.leagues[param2].removeEntrant(param1.leagues[param2].entrants[_loc6_].club ? param1.leagues[param2].entrants[_loc6_].club : param1.leagues[param2].entrants[_loc6_]);
            _loc4_++;
         }
         return _loc5_;
      }
      
      private static function getRelegatedTeams(param1:League, param2:int) : Array
      {
         var _loc3_:Array = param1.entrants.concat();
         var _loc4_:Array = new Array();
         var _loc5_:int = _loc3_.length - 1;
         while(_loc5_ >= 0 && _loc4_.length < param2)
         {
            _loc4_.push(_loc3_[_loc5_].club ? _loc3_[_loc5_].club : _loc3_[_loc5_]);
            _loc5_--;
         }
         return _loc4_;
      }
      
      private static function removeClubs(param1:Array, param2:Array) : Array
      {
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if(param2.indexOf(param1[_loc3_].club ? param1[_loc3_].club : param1[_loc3_]) >= 0)
            {
               param1.splice(_loc3_,1);
               _loc3_--;
            }
            _loc3_++;
         }
         return param1;
      }
      
      private static function makeLeague3() : League
      {
         var _loc1_:League = new League();
         _loc1_.name = "leagueOne";
         updateLeagueEntrants(_loc1_,["Cardiff City","Bradford City","Lincoln City","Bolton Wanderers","Stevenage","Stockport County","Luton Town","Barnsley","Huddersfield Town","AFC Wimbledon","Wigan Athletic","Wycombe Wanderers","Leyton Orient","Northampton Town","Rotherham United","Mansfield Town","Burton Albion","Reading","Peterborough United","Doncaster Rovers","Plymouth Argyle","Exeter City","Blackpool","Port Vale"],60);
         return _loc1_;
      }
      
      private static function makeLeague4() : League
      {
         var _loc1_:League = new League();
         _loc1_.name = "leagueTwo";
         updateLeagueEntrants(_loc1_,["Walsall","Notts County","Swindon Town","Bromley","Milton Keynes Dons","Salford City","Chesterfield","Crewe Alexandra","Cambridge United","Gillingham","Fleetwood Town","Colchester United","Barnet","Grimsby Town","Tranmere Rovers","Oldham Athletic","Accrington Stanley","Barrow","Cheltenham Town","Shrewsbury Town","Crawley Town","Harrogate Town","Bristol Rovers","Newport County"],50);
         return _loc1_;
      }
      
      private static function makePlaceholderClub(param1:String, param2:int) : Club
      {
         var _loc3_:Club = new Club();
         _loc3_.name = param1;
         _loc3_.profile = param2;
         _loc3_.makeClub();
         return _loc3_;
      }
      
      private static function updateLeagueEntrants(param1:League, param2:Array, param3:int) : void
      {
         var _loc4_:int = 0;
         while(param1.entrants.length > param2.length)
         {
            param1.entrants.pop();
         }
         _loc4_ = 0;
         while(_loc4_ < param2.length)
         {
            if(_loc4_ < param1.entrants.length)
            {
               param1.entrants[_loc4_].club.name = param2[_loc4_];
               param1.entrants[_loc4_].club.shortName = param2[_loc4_];
               if(isNaN(param1.entrants[_loc4_].club.profile) || param1.entrants[_loc4_].club.profile == 0)
               {
                  param1.entrants[_loc4_].club.profile = param3;
               }
            }
            else
            {
               param1.addEntrant(makePlaceholderClub(param2[_loc4_],param3));
            }
            _loc4_++;
         }
      }
   }
}
