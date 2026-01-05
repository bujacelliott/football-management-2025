package
{
   import flash.display.Bitmap;
   
   public class PremierLeagueKits
   {
      
      [Embed(source="/_assets/premier_league_2d/arsenal fc home 2d.png")]
      private static const ArsenalKit:Class;
      [Embed(source="/_assets/premier_league_2d/aston villa home 2d.png")]
      private static const AstonVillaKit:Class;
      [Embed(source="/_assets/premier_league_2d/afc bournemouth home 2d.png")]
      private static const BournemouthKit:Class;
      [Embed(source="/_assets/premier_league_2d/brentford fc home 2d.png")]
      private static const BrentfordKit:Class;
      [Embed(source="/_assets/premier_league_2d/brighton & hove albion home 2d.png")]
      private static const BrightonKit:Class;
      [Embed(source="/_assets/premier_league_2d/burnley fc home 2d.png")]
      private static const BurnleyKit:Class;
      [Embed(source="/_assets/premier_league_2d/chelsea fc home 2d.png")]
      private static const ChelseaKit:Class;
      [Embed(source="/_assets/premier_league_2d/crystal palace home 2d.png")]
      private static const CrystalPalaceKit:Class;
      [Embed(source="/_assets/premier_league_2d/everton fc home 2d.png")]
      private static const EvertonKit:Class;
      [Embed(source="/_assets/premier_league_2d/fulham fc home 2d.png")]
      private static const FulhamKit:Class;
      [Embed(source="/_assets/premier_league_2d/leeds united home 2d.png")]
      private static const LeedsKit:Class;
      [Embed(source="/_assets/premier_league_2d/liverpool fc home 2d.png")]
      private static const LiverpoolKit:Class;
      [Embed(source="/_assets/premier_league_2d/manchester city home 2d.png")]
      private static const ManCityKit:Class;
      [Embed(source="/_assets/premier_league_2d/manchester united home 2d.png")]
      private static const ManUnitedKit:Class;
      [Embed(source="/_assets/premier_league_2d/newcastle united home 2d.png")]
      private static const NewcastleKit:Class;
      [Embed(source="/_assets/premier_league_2d/nottingham forest home 2d.png")]
      private static const NottinghamForestKit:Class;
      [Embed(source="/_assets/premier_league_2d/sunderland afc home 2d.png")]
      private static const SunderlandKit:Class;
      [Embed(source="/_assets/premier_league_2d/tottenham hotspur home 2d.png")]
      private static const TottenhamKit:Class;
      [Embed(source="/_assets/premier_league_2d/west ham united home 2d.png")]
      private static const WestHamKit:Class;
      [Embed(source="/_assets/premier_league_2d/wolverhampton wanderers home 2d.png")]
      private static const WolvesKit:Class;
      
      public function PremierLeagueKits()
      {
         super();
      }
      
      public static function getKit(param1:String) : Bitmap
      {
         switch(param1)
         {
            case "Arsenal":
               return new ArsenalKit();
            case "Aston Villa":
               return new AstonVillaKit();
            case "Bournemouth":
               return new BournemouthKit();
            case "Brentford":
               return new BrentfordKit();
            case "Brighton & HA":
               return new BrightonKit();
            case "Burnley":
               return new BurnleyKit();
            case "Chelsea":
               return new ChelseaKit();
            case "Crystal Palace":
               return new CrystalPalaceKit();
            case "Everton":
               return new EvertonKit();
            case "Fulham":
               return new FulhamKit();
            case "Leeds United":
               return new LeedsKit();
            case "Liverpool":
               return new LiverpoolKit();
            case "Manchester City":
               return new ManCityKit();
            case "Manchester United":
               return new ManUnitedKit();
            case "Newcastle United":
               return new NewcastleKit();
            case "Nottingham Forest":
               return new NottinghamForestKit();
            case "Sunderland":
               return new SunderlandKit();
            case "Tottenham Hotspur":
               return new TottenhamKit();
            case "West Ham United":
               return new WestHamKit();
            case "Wolverhampton Wanderers":
               return new WolvesKit();
            case "Wolves":
               return new WolvesKit();
         }
         return null;
      }
   }
}
