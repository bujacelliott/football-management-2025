package
{
   import flash.display.Bitmap;

   public class Kits2D
   {
      [Embed(source="../kits/bundesliga_kits/1. fc heidenheim home 2d.png")]
      private static const _1__Fc_HeidenheimKit:Class;
      [Embed(source="../kits/bundesliga_kits/1. fc köln home 2d.png")]
      private static const _1__Fc_K_lnKit:Class;
      [Embed(source="../kits/bundesliga_kits/1. fsv mainz 05 home 2d.png")]
      private static const _1__Fsv_Mainz_05Kit:Class;
      [Embed(source="../kits/serie a_kits/ac milan home 2d.png")]
      private static const Ac_MilanKit:Class;
      [Embed(source="../kits/league two_kits/accrington stanley home 2d.png")]
      private static const Accrington_StanleyKit:Class;
      [Embed(source="../kits/serie a_kits/acf fiorentina home 2d.png")]
      private static const Acf_FiorentinaKit:Class;
      [Embed(source="../kits/premier league_kits/afc bournemouth home 2d.png")]
      private static const Afc_BournemouthKit:Class;
      [Embed(source="../kits/league one_kits/afc wimbledon home 2d.png")]
      private static const Afc_WimbledonKit:Class;
      [Embed(source="../kits/ligue 1_kits/aj auxerre home 2d.png")]
      private static const Aj_AuxerreKit:Class;
      [Embed(source="../kits/ligue 1_kits/angers sco home 2d.png")]
      private static const Angers_ScoKit:Class;
      [Embed(source="../kits/premier league_kits/arsenal fc home 2d.png")]
      private static const Arsenal_FcKit:Class;
      [Embed(source="../kits/ligue 1_kits/as monaco home 2d.png")]
      private static const As_MonacoKit:Class;
      [Embed(source="../kits/serie a_kits/as roma home 2d.png")]
      private static const As_RomaKit:Class;
      [Embed(source="../kits/premier league_kits/aston villa home 2d.png")]
      private static const Aston_VillaKit:Class;
      [Embed(source="../kits/serie a_kits/atalanta bc home 2d.png")]
      private static const Atalanta_BcKit:Class;
      [Embed(source="../kits/la liga_kits/athletic club home 2d.png")]
      private static const Athletic_ClubKit:Class;
      [Embed(source="../kits/la liga_kits/atlético madrid home 2d.png")]
      private static const Atl_tico_MadridKit:Class;
      [Embed(source="../kits/league two_kits/barnet home 2d.png")]
      private static const BarnetKit:Class;
      [Embed(source="../kits/league one_kits/barnsley fc home 2d.png")]
      private static const Barnsley_FcKit:Class;
      [Embed(source="../kits/league two_kits/barrow home 2d.png")]
      private static const BarrowKit:Class;
      [Embed(source="../kits/bundesliga_kits/bayer 04 leverkusen home 2d.png")]
      private static const Bayer_04_LeverkusenKit:Class;
      [Embed(source="../kits/bundesliga_kits/bayern münchen home 2d.png")]
      private static const Bayern_M_nchenKit:Class;
      [Embed(source="../kits/championship_kits/birmingham city home 2d.png")]
      private static const Birmingham_CityKit:Class;
      [Embed(source="../kits/championship_kits/blackburn rovers home 2d.png")]
      private static const Blackburn_RoversKit:Class;
      [Embed(source="../kits/league one_kits/blackpool home 2d.png")]
      private static const BlackpoolKit:Class;
      [Embed(source="../kits/serie a_kits/bologna fc home 2d.png")]
      private static const Bologna_FcKit:Class;
      [Embed(source="../kits/league one_kits/bolton wanderers home 2d.png")]
      private static const Bolton_WanderersKit:Class;
      [Embed(source="../kits/bundesliga_kits/borussia dortmund home 2d.png")]
      private static const Borussia_DortmundKit:Class;
      [Embed(source="../kits/bundesliga_kits/borussia mönchengladbach home 2d.png")]
      private static const Borussia_M_nchengladbachKit:Class;
      [Embed(source="../kits/league one_kits/bradford city home 2d.png")]
      private static const Bradford_CityKit:Class;
      [Embed(source="../kits/premier league_kits/brentford fc home 2d.png")]
      private static const Brentford_FcKit:Class;
      [Embed(source="../kits/premier league_kits/brighton & hove albion home 2d.png")]
      private static const Brighton___Hove_AlbionKit:Class;
      [Embed(source="../kits/championship_kits/bristol city home 2d.png")]
      private static const Bristol_CityKit:Class;
      [Embed(source="../kits/league two_kits/bristol rovers home 2d.png")]
      private static const Bristol_RoversKit:Class;
      [Embed(source="../kits/league two_kits/bromley home 2d.png")]
      private static const BromleyKit:Class;
      [Embed(source="../kits/premier league_kits/burnley fc home 2d.png")]
      private static const Burnley_FcKit:Class;
      [Embed(source="../kits/league one_kits/burton albion home 2d.png")]
      private static const Burton_AlbionKit:Class;
      [Embed(source="../kits/la liga_kits/ca osasuna home 2d.png")]
      private static const Ca_OsasunaKit:Class;
      [Embed(source="../kits/serie a_kits/cagliari calcio home 2d.png")]
      private static const Cagliari_CalcioKit:Class;
      [Embed(source="../kits/league two_kits/cambridge united home 2d.png")]
      private static const Cambridge_UnitedKit:Class;
      [Embed(source="../kits/league one_kits/cardiff city home 2d.png")]
      private static const Cardiff_CityKit:Class;
      [Embed(source="../kits/la liga_kits/celta vigo home 2d.png")]
      private static const Celta_VigoKit:Class;
      [Embed(source="../kits/championship_kits/charlton athletic home 2d.png")]
      private static const Charlton_AthleticKit:Class;
      [Embed(source="../kits/premier league_kits/chelsea fc home 2d.png")]
      private static const Chelsea_FcKit:Class;
      [Embed(source="../kits/league two_kits/cheltenham town home 2d.png")]
      private static const Cheltenham_TownKit:Class;
      [Embed(source="../kits/league two_kits/chesterfield fc home 2d.png")]
      private static const Chesterfield_FcKit:Class;
      [Embed(source="../kits/league two_kits/colchester united home 2d.png")]
      private static const Colchester_UnitedKit:Class;
      [Embed(source="../kits/serie a_kits/como 1907 home 2d.png")]
      private static const Como_1907Kit:Class;
      [Embed(source="../kits/championship_kits/coventry city home 2d.png")]
      private static const Coventry_CityKit:Class;
      [Embed(source="../kits/league two_kits/crawley town home 2d.png")]
      private static const Crawley_TownKit:Class;
      [Embed(source="../kits/league two_kits/crewe alexandra home 2d.png")]
      private static const Crewe_AlexandraKit:Class;
      [Embed(source="../kits/premier league_kits/crystal palace home 2d.png")]
      private static const Crystal_PalaceKit:Class;
      [Embed(source="../kits/la liga_kits/deportivo alavés home 2d.png")]
      private static const Deportivo_Alav_sKit:Class;
      [Embed(source="../kits/championship_kits/derby county home 2d.png")]
      private static const Derby_CountyKit:Class;
      [Embed(source="../kits/league one_kits/doncaster rovers home 2d.png")]
      private static const Doncaster_RoversKit:Class;
      [Embed(source="../kits/bundesliga_kits/eintracht frankfurt home 2d.png")]
      private static const Eintracht_FrankfurtKit:Class;
      [Embed(source="../kits/la liga_kits/elche cf home 2d.png")]
      private static const Elche_CfKit:Class;
      [Embed(source="../kits/premier league_kits/everton fc home 2d.png")]
      private static const Everton_FcKit:Class;
      [Embed(source="../kits/league one_kits/exeter city home 2d.png")]
      private static const Exeter_CityKit:Class;
      [Embed(source="../kits/bundesliga_kits/fc augsburg home 2d.png")]
      private static const Fc_AugsburgKit:Class;
      [Embed(source="../kits/la liga_kits/fc barcelona home 2d.png")]
      private static const Fc_BarcelonaKit:Class;
      [Embed(source="../kits/ligue 1_kits/fc metz home 2d.png")]
      private static const Fc_MetzKit:Class;
      [Embed(source="../kits/ligue 1_kits/fc nantes home 2d.png")]
      private static const Fc_NantesKit:Class;
      [Embed(source="../kits/bundesliga_kits/fc st. pauli home 2d.png")]
      private static const Fc_St__PauliKit:Class;
      [Embed(source="../kits/league two_kits/fleetwood town home 2d.png")]
      private static const Fleetwood_TownKit:Class;
      [Embed(source="../kits/premier league_kits/fulham fc home 2d.png")]
      private static const Fulham_FcKit:Class;
      [Embed(source="../kits/serie a_kits/genoa cfc home 2d.png")]
      private static const Genoa_CfcKit:Class;
      [Embed(source="../kits/la liga_kits/getafe cf home 2d.png")]
      private static const Getafe_CfKit:Class;
      [Embed(source="../kits/league two_kits/gillingham fc home 2d.png")]
      private static const Gillingham_FcKit:Class;
      [Embed(source="../kits/la liga_kits/girona fc home 2d.png")]
      private static const Girona_FcKit:Class;
      [Embed(source="../kits/league two_kits/grimsby town home 2d.png")]
      private static const Grimsby_TownKit:Class;
      [Embed(source="../kits/bundesliga_kits/hamburger sv home 2d.png")]
      private static const Hamburger_SvKit:Class;
      [Embed(source="../kits/league two_kits/harrogate town home 2d.png")]
      private static const Harrogate_TownKit:Class;
      [Embed(source="../kits/serie a_kits/hellas verona home 2d.png")]
      private static const Hellas_VeronaKit:Class;
      [Embed(source="../kits/league one_kits/huddersfield town home 2d.png")]
      private static const Huddersfield_TownKit:Class;
      [Embed(source="../kits/championship_kits/hull city afc home 2d.png")]
      private static const Hull_City_AfcKit:Class;
      [Embed(source="../kits/serie a_kits/inter milan home 2d.png")]
      private static const Inter_MilanKit:Class;
      [Embed(source="../kits/championship_kits/ipswich town home 2d.png")]
      private static const Ipswich_TownKit:Class;
      [Embed(source="../kits/serie a_kits/juventus fc home 2d.png")]
      private static const Juventus_FcKit:Class;
      [Embed(source="../kits/ligue 1_kits/le havre home 2d.png")]
      private static const Le_HavreKit:Class;
      [Embed(source="../kits/premier league_kits/leeds united home 2d.png")]
      private static const Leeds_UnitedKit:Class;
      [Embed(source="../kits/championship_kits/leicester city home 2d.png")]
      private static const Leicester_CityKit:Class;
      [Embed(source="../kits/la liga_kits/levante ud home 2d.png")]
      private static const Levante_UdKit:Class;
      [Embed(source="../kits/league one_kits/leyton orient home 2d.png")]
      private static const Leyton_OrientKit:Class;
      [Embed(source="../kits/ligue 1_kits/lille losc home 2d.png")]
      private static const Lille_LoscKit:Class;
      [Embed(source="../kits/league one_kits/lincoln city home 2d.png")]
      private static const Lincoln_CityKit:Class;
      [Embed(source="../kits/premier league_kits/liverpool fc home 2d.png")]
      private static const Liverpool_FcKit:Class;
      [Embed(source="../kits/ligue 1_kits/lorient home 2d.png")]
      private static const LorientKit:Class;
      [Embed(source="../kits/league one_kits/luton town home 2d.png")]
      private static const Luton_TownKit:Class;
      [Embed(source="../kits/premier league_kits/manchester city home 2d.png")]
      private static const Manchester_CityKit:Class;
      [Embed(source="../kits/premier league_kits/manchester united home 2d.png")]
      private static const Manchester_UnitedKit:Class;
      [Embed(source="../kits/league one_kits/mansfield town home 2d.png")]
      private static const Mansfield_TownKit:Class;
      [Embed(source="../kits/championship_kits/middlesbrough home 2d.png")]
      private static const MiddlesbroughKit:Class;
      [Embed(source="../kits/championship_kits/millwall fc home 2d.png")]
      private static const Millwall_FcKit:Class;
      [Embed(source="../kits/league two_kits/mk dons home 2d.png")]
      private static const Mk_DonsKit:Class;
      [Embed(source="../kits/premier league_kits/newcastle united home 2d.png")]
      private static const Newcastle_UnitedKit:Class;
      [Embed(source="../kits/league two_kits/newport county afc home 2d.png")]
      private static const Newport_County_AfcKit:Class;
      [Embed(source="../kits/ligue 1_kits/nice home 2d.png")]
      private static const NiceKit:Class;
      [Embed(source="../kits/league one_kits/northampton town home 2d.png")]
      private static const Northampton_TownKit:Class;
      [Embed(source="../kits/championship_kits/norwich city home 2d.png")]
      private static const Norwich_CityKit:Class;
      [Embed(source="../kits/premier league_kits/nottingham forest home 2d.png")]
      private static const Nottingham_ForestKit:Class;
      [Embed(source="../kits/league two_kits/notts county home 2d.png")]
      private static const Notts_CountyKit:Class;
      [Embed(source="../kits/league two_kits/oldham athletic home 2d.png")]
      private static const Oldham_AthleticKit:Class;
      [Embed(source="../kits/ligue 1_kits/olympique lyonnais home 2d.png")]
      private static const Olympique_LyonnaisKit:Class;
      [Embed(source="../kits/ligue 1_kits/olympique marseille home 2d.png")]
      private static const Olympique_MarseilleKit:Class;
      [Embed(source="../kits/championship_kits/oxford united home 2d.png")]
      private static const Oxford_UnitedKit:Class;
      [Embed(source="../kits/ligue 1_kits/paris fc home 2d.png")]
      private static const Paris_FcKit:Class;
      [Embed(source="../kits/ligue 1_kits/paris saint-germain home 2d.png")]
      private static const Paris_Saint_GermainKit:Class;
      [Embed(source="../kits/serie a_kits/parma calcio home 2d.png")]
      private static const Parma_CalcioKit:Class;
      [Embed(source="../kits/league one_kits/peterborough united home 2d.png")]
      private static const Peterborough_UnitedKit:Class;
      [Embed(source="../kits/serie a_kits/pisa home 2d.png")]
      private static const PisaKit:Class;
      [Embed(source="../kits/league one_kits/plymouth argyle home 2d.png")]
      private static const Plymouth_ArgyleKit:Class;
      [Embed(source="../kits/league one_kits/port vale home 2d.png")]
      private static const Port_ValeKit:Class;
      [Embed(source="../kits/championship_kits/portsmouth fc home 2d.png")]
      private static const Portsmouth_FcKit:Class;
      [Embed(source="../kits/championship_kits/preston north end home 2d.png")]
      private static const Preston_North_EndKit:Class;
      [Embed(source="../kits/championship_kits/queens park rangers home 2d.png")]
      private static const Queens_Park_RangersKit:Class;
      [Embed(source="../kits/la liga_kits/rayo vallecano home 2d.png")]
      private static const Rayo_VallecanoKit:Class;
      [Embed(source="../kits/bundesliga_kits/rb leipzig home 2d.png")]
      private static const Rb_LeipzigKit:Class;
      [Embed(source="../kits/ligue 1_kits/rc lens home 2d.png")]
      private static const Rc_LensKit:Class;
      [Embed(source="../kits/la liga_kits/rcd espanyol home 2d.png")]
      private static const Rcd_EspanyolKit:Class;
      [Embed(source="../kits/la liga_kits/rcd mallorca home 2d.png")]
      private static const Rcd_MallorcaKit:Class;
      [Embed(source="../kits/league one_kits/reading home 2d.png")]
      private static const ReadingKit:Class;
      [Embed(source="../kits/la liga_kits/real betis home 2d.png")]
      private static const Real_BetisKit:Class;
      [Embed(source="../kits/la liga_kits/real madrid home 2d.png")]
      private static const Real_MadridKit:Class;
      [Embed(source="../kits/la liga_kits/real oviedo home 2d.png")]
      private static const Real_OviedoKit:Class;
      [Embed(source="../kits/la liga_kits/real sociedad home 2d.png")]
      private static const Real_SociedadKit:Class;
      [Embed(source="../kits/league one_kits/rotherham united home 2d.png")]
      private static const Rotherham_UnitedKit:Class;
      [Embed(source="../kits/league two_kits/salford city home 2d.png")]
      private static const Salford_CityKit:Class;
      [Embed(source="../kits/serie a_kits/sassuolo home 2d.png")]
      private static const SassuoloKit:Class;
      [Embed(source="../kits/bundesliga_kits/sc freiburg home 2d.png")]
      private static const Sc_FreiburgKit:Class;
      [Embed(source="../kits/la liga_kits/sevilla fc home 2d.png")]
      private static const Sevilla_FcKit:Class;
      [Embed(source="../kits/championship_kits/sheffield united home 2d.png")]
      private static const Sheffield_UnitedKit:Class;
      [Embed(source="../kits/championship_kits/sheffield wednesday home 2d.png")]
      private static const Sheffield_WednesdayKit:Class;
      [Embed(source="../kits/league two_kits/shrewsbury town home 2d.png")]
      private static const Shrewsbury_TownKit:Class;
      [Embed(source="../kits/championship_kits/southampton fc home 2d.png")]
      private static const Southampton_FcKit:Class;
      [Embed(source="../kits/serie a_kits/ss lazio home 2d.png")]
      private static const Ss_LazioKit:Class;
      [Embed(source="../kits/serie a_kits/ssc napoli home 2d.png")]
      private static const Ssc_NapoliKit:Class;
      [Embed(source="../kits/ligue 1_kits/stade brestois home 2d.png")]
      private static const Stade_BrestoisKit:Class;
      [Embed(source="../kits/ligue 1_kits/stade rennais home 2d.png")]
      private static const Stade_RennaisKit:Class;
      [Embed(source="../kits/league one_kits/stevenage home 2d.png")]
      private static const StevenageKit:Class;
      [Embed(source="../kits/league one_kits/stockport county home 2d.png")]
      private static const Stockport_CountyKit:Class;
      [Embed(source="../kits/championship_kits/stoke city home 2d.png")]
      private static const Stoke_CityKit:Class;
      [Embed(source="../kits/ligue 1_kits/strasbourg home 2d.png")]
      private static const StrasbourgKit:Class;
      [Embed(source="../kits/premier league_kits/sunderland afc home 2d.png")]
      private static const Sunderland_AfcKit:Class;
      [Embed(source="../kits/championship_kits/swansea city home 2d.png")]
      private static const Swansea_CityKit:Class;
      [Embed(source="../kits/league two_kits/swindon town home 2d.png")]
      private static const Swindon_TownKit:Class;
      [Embed(source="../kits/serie a_kits/torino fc home 2d.png")]
      private static const Torino_FcKit:Class;
      [Embed(source="../kits/premier league_kits/tottenham hotspur home 2d.png")]
      private static const Tottenham_HotspurKit:Class;
      [Embed(source="../kits/ligue 1_kits/toulouse fc home 2d.png")]
      private static const Toulouse_FcKit:Class;
      [Embed(source="../kits/league two_kits/tranmere rovers home 2d.png")]
      private static const Tranmere_RoversKit:Class;
      [Embed(source="../kits/bundesliga_kits/tsg 1899 hoffenheim home 2d.png")]
      private static const Tsg_1899_HoffenheimKit:Class;
      [Embed(source="../kits/serie a_kits/udinese calcio home 2d.png")]
      private static const Udinese_CalcioKit:Class;
      [Embed(source="../kits/bundesliga_kits/union berlin home 2d.png")]
      private static const Union_BerlinKit:Class;
      [Embed(source="../kits/serie a_kits/us cremonese home 2d.png")]
      private static const Us_CremoneseKit:Class;
      [Embed(source="../kits/serie a_kits/us lecce home 2d.png")]
      private static const Us_LecceKit:Class;
      [Embed(source="../kits/la liga_kits/valencia cf home 2d.png")]
      private static const Valencia_CfKit:Class;
      [Embed(source="../kits/bundesliga_kits/vfb stuttgart home 2d.png")]
      private static const Vfb_StuttgartKit:Class;
      [Embed(source="../kits/bundesliga_kits/vfl wolfsburg home 2d.png")]
      private static const Vfl_WolfsburgKit:Class;
      [Embed(source="../kits/la liga_kits/villarreal cf home 2d.png")]
      private static const Villarreal_CfKit:Class;
      [Embed(source="../kits/league two_kits/walsall fc home 2d.png")]
      private static const Walsall_FcKit:Class;
      [Embed(source="../kits/championship_kits/watford fc home 2d.png")]
      private static const Watford_FcKit:Class;
      [Embed(source="../kits/bundesliga_kits/werder bremen home 2d.png")]
      private static const Werder_BremenKit:Class;
      [Embed(source="../kits/championship_kits/west bromwich albion home 2d.png")]
      private static const West_Bromwich_AlbionKit:Class;
      [Embed(source="../kits/premier league_kits/west ham united home 2d.png")]
      private static const West_Ham_UnitedKit:Class;
      [Embed(source="../kits/league one_kits/wigan athletic home 2d.png")]
      private static const Wigan_AthleticKit:Class;
      [Embed(source="../kits/premier league_kits/wolverhampton wanderers home 2d.png")]
      private static const Wolverhampton_WanderersKit:Class;
      [Embed(source="../kits/championship_kits/wrexham home 2d.png")]
      private static const WrexhamKit:Class;
      [Embed(source="../kits/league one_kits/wycombe wanderers home 2d.png")]
      private static const Wycombe_WanderersKit:Class;

      public function Kits2D()
      {
         super();
      }

      public static function getKit(param1:String) : Bitmap
      {
         switch(param1)
         {
            case "1. FC Heidenheim 1846":
               return new _1__Fc_HeidenheimKit();
            case "1. FC Köln":
               return new _1__Fc_K_lnKit();
            case "1. FC Union Berlin":
               return new Union_BerlinKit();
            case "1. FSV Mainz 05":
               return new _1__Fsv_Mainz_05Kit();
            case "AC Milan":
               return new Ac_MilanKit();
            case "AFC Wimbledon":
               return new Afc_WimbledonKit();
            case "AJ Auxerre":
               return new Aj_AuxerreKit();
            case "AS Monaco":
               return new As_MonacoKit();
            case "Accrington Stanley":
               return new Accrington_StanleyKit();
            case "Angers SCO":
               return new Angers_ScoKit();
            case "Arsenal":
               return new Arsenal_FcKit();
            case "Aston Villa":
               return new Aston_VillaKit();
            case "Atalanta":
               return new Atalanta_BcKit();
            case "Athletic Club":
               return new Athletic_ClubKit();
            case "Atlético Madrid":
               return new Atl_tico_MadridKit();
            case "Barnet":
               return new BarnetKit();
            case "Barnsley":
               return new Barnsley_FcKit();
            case "Barrow":
               return new BarrowKit();
            case "Bayer 04 Leverkusen":
               return new Bayer_04_LeverkusenKit();
            case "Birmingham City":
               return new Birmingham_CityKit();
            case "Blackburn Rovers":
               return new Blackburn_RoversKit();
            case "Blackpool":
               return new BlackpoolKit();
            case "Bologna":
               return new Bologna_FcKit();
            case "Bolton Wanderers":
               return new Bolton_WanderersKit();
            case "Borussia Dortmund":
               return new Borussia_DortmundKit();
            case "Borussia Mönchengladbach":
               return new Borussia_M_nchengladbachKit();
            case "Bournemouth":
               return new Afc_BournemouthKit();
            case "Bradford City":
               return new Bradford_CityKit();
            case "Brentford":
               return new Brentford_FcKit();
            case "Brighton & HA":
               return new Brighton___Hove_AlbionKit();
            case "Bristol City":
               return new Bristol_CityKit();
            case "Bristol Rovers":
               return new Bristol_RoversKit();
            case "Bromley":
               return new BromleyKit();
            case "Burnley":
               return new Burnley_FcKit();
            case "Burton Albion":
               return new Burton_AlbionKit();
            case "CA Osasuna":
               return new Ca_OsasunaKit();
            case "Cagliari":
               return new Cagliari_CalcioKit();
            case "Cambridge United":
               return new Cambridge_UnitedKit();
            case "Cardiff City":
               return new Cardiff_CityKit();
            case "Charlton Athletic":
               return new Charlton_AthleticKit();
            case "Chelsea":
               return new Chelsea_FcKit();
            case "Cheltenham Town":
               return new Cheltenham_TownKit();
            case "Chesterfield":
               return new Chesterfield_FcKit();
            case "Colchester United":
               return new Colchester_UnitedKit();
            case "Como":
               return new Como_1907Kit();
            case "Coventry City":
               return new Coventry_CityKit();
            case "Crawley Town":
               return new Crawley_TownKit();
            case "Cremonese":
               return new Us_CremoneseKit();
            case "Crewe Alexandra":
               return new Crewe_AlexandraKit();
            case "Crystal Palace":
               return new Crystal_PalaceKit();
            case "Deportivo Alavés":
               return new Deportivo_Alav_sKit();
            case "Derby County":
               return new Derby_CountyKit();
            case "Doncaster Rovers":
               return new Doncaster_RoversKit();
            case "Eintracht Frankfurt":
               return new Eintracht_FrankfurtKit();
            case "Elche CF":
               return new Elche_CfKit();
            case "Everton":
               return new Everton_FcKit();
            case "Exeter City":
               return new Exeter_CityKit();
            case "FC Augsburg":
               return new Fc_AugsburgKit();
            case "FC Barcelona":
               return new Fc_BarcelonaKit();
            case "FC Bayern München":
               return new Bayern_M_nchenKit();
            case "FC Lorient":
               return new LorientKit();
            case "FC Metz":
               return new Fc_MetzKit();
            case "FC Nantes":
               return new Fc_NantesKit();
            case "FC St. Pauli":
               return new Fc_St__PauliKit();
            case "Fiorentina":
               return new Acf_FiorentinaKit();
            case "Fleetwood Town":
               return new Fleetwood_TownKit();
            case "Fulham":
               return new Fulham_FcKit();
            case "Genoa":
               return new Genoa_CfcKit();
            case "Getafe CF":
               return new Getafe_CfKit();
            case "Gillingham":
               return new Gillingham_FcKit();
            case "Girona FC":
               return new Girona_FcKit();
            case "Grimsby Town":
               return new Grimsby_TownKit();
            case "Hamburger SV":
               return new Hamburger_SvKit();
            case "Harrogate Town":
               return new Harrogate_TownKit();
            case "Hellas Verona FC":
               return new Hellas_VeronaKit();
            case "Huddersfield Town":
               return new Huddersfield_TownKit();
            case "Hull City":
               return new Hull_City_AfcKit();
            case "Inter":
               return new Inter_MilanKit();
            case "Ipswich Town":
               return new Ipswich_TownKit();
            case "Juventus":
               return new Juventus_FcKit();
            case "Lazio":
               return new Ss_LazioKit();
            case "Le Havre AC":
               return new Le_HavreKit();
            case "Lecce":
               return new Us_LecceKit();
            case "Leeds United":
               return new Leeds_UnitedKit();
            case "Leicester City":
               return new Leicester_CityKit();
            case "Levante UD":
               return new Levante_UdKit();
            case "Leyton Orient":
               return new Leyton_OrientKit();
            case "Lille OSC":
               return new Lille_LoscKit();
            case "Lincoln City":
               return new Lincoln_CityKit();
            case "Liverpool":
               return new Liverpool_FcKit();
            case "Luton Town":
               return new Luton_TownKit();
            case "Manchester City":
               return new Manchester_CityKit();
            case "Manchester United":
               return new Manchester_UnitedKit();
            case "Mansfield Town":
               return new Mansfield_TownKit();
            case "Middlesbrough":
               return new MiddlesbroughKit();
            case "Millwall":
               return new Millwall_FcKit();
            case "Milton Keynes Dons":
               return new Mk_DonsKit();
            case "Napoli":
               return new Ssc_NapoliKit();
            case "Newcastle United":
               return new Newcastle_UnitedKit();
            case "Newport County":
               return new Newport_County_AfcKit();
            case "Northampton Town":
               return new Northampton_TownKit();
            case "Norwich City":
               return new Norwich_CityKit();
            case "Nottingham Forest":
               return new Nottingham_ForestKit();
            case "Notts County":
               return new Notts_CountyKit();
            case "OGC Nice":
               return new NiceKit();
            case "Oldham Athletic":
               return new Oldham_AthleticKit();
            case "Olympique Lyonnais":
               return new Olympique_LyonnaisKit();
            case "Olympique de Marseille":
               return new Olympique_MarseilleKit();
            case "Oxford United":
               return new Oxford_UnitedKit();
            case "Paris FC":
               return new Paris_FcKit();
            case "Paris Saint-Germain":
               return new Paris_Saint_GermainKit();
            case "Parma":
               return new Parma_CalcioKit();
            case "Peterborough United":
               return new Peterborough_UnitedKit();
            case "Pisa":
               return new PisaKit();
            case "Plymouth Argyle":
               return new Plymouth_ArgyleKit();
            case "Port Vale":
               return new Port_ValeKit();
            case "Portsmouth":
               return new Portsmouth_FcKit();
            case "Preston North End":
               return new Preston_North_EndKit();
            case "QPR":
               return new Queens_Park_RangersKit();
            case "RB Leipzig":
               return new Rb_LeipzigKit();
            case "RC Celta":
               return new Celta_VigoKit();
            case "RC Lens":
               return new Rc_LensKit();
            case "RC Strasbourg Alsace":
               return new StrasbourgKit();
            case "RCD Espanyol":
               return new Rcd_EspanyolKit();
            case "RCD Mallorca":
               return new Rcd_MallorcaKit();
            case "Rayo Vallecano":
               return new Rayo_VallecanoKit();
            case "Reading":
               return new ReadingKit();
            case "Real Betis Balompié":
               return new Real_BetisKit();
            case "Real Madrid":
               return new Real_MadridKit();
            case "Real Oviedo":
               return new Real_OviedoKit();
            case "Real Sociedad":
               return new Real_SociedadKit();
            case "Roma":
               return new As_RomaKit();
            case "Rotherham United":
               return new Rotherham_UnitedKit();
            case "SC Freiburg":
               return new Sc_FreiburgKit();
            case "SV Werder Bremen":
               return new Werder_BremenKit();
            case "Salford City":
               return new Salford_CityKit();
            case "Sassuolo":
               return new SassuoloKit();
            case "Sevilla FC":
               return new Sevilla_FcKit();
            case "Sheffield United":
               return new Sheffield_UnitedKit();
            case "Sheffield Wednesday":
               return new Sheffield_WednesdayKit();
            case "Shrewsbury Town":
               return new Shrewsbury_TownKit();
            case "Southampton":
               return new Southampton_FcKit();
            case "Stade Brestois 29":
               return new Stade_BrestoisKit();
            case "Stade Rennais FC":
               return new Stade_RennaisKit();
            case "Stevenage":
               return new StevenageKit();
            case "Stockport County":
               return new Stockport_CountyKit();
            case "Stoke City":
               return new Stoke_CityKit();
            case "Sunderland":
               return new Sunderland_AfcKit();
            case "Swansea City":
               return new Swansea_CityKit();
            case "Swindon Town":
               return new Swindon_TownKit();
            case "TSG 1899 Hoffenheim":
               return new Tsg_1899_HoffenheimKit();
            case "Torino":
               return new Torino_FcKit();
            case "Tottenham Hotspur":
               return new Tottenham_HotspurKit();
            case "Toulouse FC":
               return new Toulouse_FcKit();
            case "Tranmere Rovers":
               return new Tranmere_RoversKit();
            case "Udinese":
               return new Udinese_CalcioKit();
            case "Valencia CF":
               return new Valencia_CfKit();
            case "VfB Stuttgart":
               return new Vfb_StuttgartKit();
            case "VfL Wolfsburg":
               return new Vfl_WolfsburgKit();
            case "Villarreal CF":
               return new Villarreal_CfKit();
            case "WBA":
               return new West_Bromwich_AlbionKit();
            case "Walsall":
               return new Walsall_FcKit();
            case "Watford":
               return new Watford_FcKit();
            case "West Ham United":
               return new West_Ham_UnitedKit();
            case "Wigan Athletic":
               return new Wigan_AthleticKit();
            case "Wolverhampton Wanderers":
               return new Wolverhampton_WanderersKit();
            case "Wrexham":
               return new WrexhamKit();
            case "Wycombe Wanderers":
               return new Wycombe_WanderersKit();
         }
         return null;
      }
   }
}