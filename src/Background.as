package
{
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   
   public dynamic class Background extends MovieClip
   {
      // Embed the stadium background directly so it always renders, even if the assets SWF is missing.
      [Embed(source="../_assets/artech_background.png")]
      private static const BackgroundImage:Class;
      
      
      public var bg:MovieClip;
      
      public var manager:MovieClip;
      
      public function Background()
      {
         super();
         var _loc1_:Bitmap = new BackgroundImage();
         _loc1_.smoothing = true;
         _loc1_.width = Globals.GAME_WIDTH;
         _loc1_.height = Globals.GAME_HEIGHT;
         _loc1_.x = 0;
         _loc1_.y = 0;
         this.bg = new MovieClip();
         this.bg.addChild(_loc1_);
         addChild(this.bg);
         this.manager = new MovieClip();
         addChild(this.manager);
      }
   }
}

