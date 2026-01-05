package
{
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.filters.GlowFilter;
   import flash.media.SoundMixer;
   
   /**
    * Code-driven intro animation. Plays once (~2.5s @ 30fps), then dispatches COMPLETE and stops.
    * Linkage/class name stays mb_intro to match the existing splash loader.
    */
   public class mb_intro extends MovieClip
   {
      
      [Embed(source="../_assets/logo.png")]
      private static const LogoPNG:Class;
      
      private var W:int = 800;
      private var H:int = 600;
      private var SAFE_W:int = 700;
      private var SAFE_H:int = 500;
      private const FPS:int = 30;
      private const TOTAL_FRAMES:int = 75; // 2.5s @ 30fps
      
      private var t:int = 0;
      private var logo:Bitmap;
      private var glow:GlowFilter;
      
      public function mb_intro()
      {
         super();
         stop();
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         if(stage)
         {
            this.W = stage.stageWidth;
            this.H = stage.stageHeight;
            this.SAFE_W = Math.max(200,this.W - 100);
            this.SAFE_H = Math.max(200,this.H - 100);
         }
         this.drawBackground();
         this.createLogo();
         this.t = 0;
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function drawBackground() : void
      {
         var _loc1_:Shape = new Shape();
         _loc1_.graphics.beginFill(0);
         _loc1_.graphics.drawRect(0,0,this.W,this.H);
         _loc1_.graphics.endFill();
         addChild(_loc1_);
      }
      
      private function createLogo() : void
      {
         this.logo = new LogoPNG() as Bitmap;
         this.logo.smoothing = true;
         var _loc1_:Number = this.SAFE_W - 60;
         var _loc2_:Number = this.SAFE_H - 140;
         var _loc3_:Number = Math.min(_loc1_ / this.logo.width,_loc2_ / this.logo.height);
         this.logo.scaleX = this.logo.scaleY = _loc3_ * 0.92;
         this.logo.x = (this.W - this.logo.width) * 0.5;
         this.logo.y = (this.H - this.logo.height) * 0.5 + 12;
         this.logo.alpha = 0;
         this.glow = new GlowFilter(0x00ff66,0,18,18,2,2);
         this.logo.filters = [this.glow];
         addChild(this.logo);
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         ++this.t;
         var _loc2_:Number = this.t / this.TOTAL_FRAMES;
         if(_loc2_ > 1)
         {
            _loc2_ = 1;
         }
         var _loc3_:Number = clamp((_loc2_ - 0) / 0.22);
         var _loc4_:Number = clamp((_loc2_ - 0.05) / 0.7);
         this.logo.alpha = easeOutCubic(_loc3_);
         var _loc5_:Number = (this.H - this.logo.height) * 0.5 + 12;
         var _loc6_:Number = (this.H - this.logo.height) * 0.5;
         this.logo.y = lerp(_loc5_,_loc6_,easeOutCubic(_loc3_));
         var _loc7_:Number = Math.min((this.SAFE_W - 60) / this.logo.bitmapData.width,(this.SAFE_H - 140) / this.logo.bitmapData.height);
         var _loc8_:Number = _loc7_ * 0.92;
         var _loc9_:Number = _loc7_ * 1.03;
         var _loc10_:Number = _loc7_;
         var _loc11_:Number = 0;
         if(_loc4_ < 0.45)
         {
            _loc11_ = lerp(_loc8_,_loc9_,easeOutBack(_loc4_ / 0.45));
         }
         else
         {
            _loc11_ = lerp(_loc9_,_loc10_,easeOutCubic((_loc4_ - 0.45) / 0.55));
         }
         this.logo.scaleX = this.logo.scaleY = _loc11_;
         this.logo.x = (this.W - this.logo.width) * 0.5;
         var _loc12_:Number = 0.5 + 0.5 * Math.sin(this.t * 0.18);
         this.glow.alpha = 0.1 + 0.25 * _loc12_;
         this.logo.filters = [this.glow];
         if(this.t >= this.TOTAL_FRAMES)
         {
            removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            SoundMixer.stopAll();
            dispatchEvent(new Event(Event.COMPLETE));
            stop();
         }
      }
      
      private static function clamp(param1:Number, param2:Number = 0, param3:Number = 1) : Number
      {
         if(param1 < param2)
         {
            return param2;
         }
         if(param1 > param3)
         {
            return param3;
         }
         return param1;
      }
      
      private static function lerp(param1:Number, param2:Number, param3:Number) : Number
      {
         return param1 + (param2 - param1) * param3;
      }
      
      private static function easeOutCubic(param1:Number) : Number
      {
         param1 = clamp(param1);
         var _loc2_:Number = param1 - 1;
         return _loc2_ * _loc2_ * _loc2_ + 1;
      }
      
      private static function easeOutBack(param1:Number) : Number
      {
         param1 = clamp(param1);
         var _loc2_:Number = 1.70158;
         param1 -= 1;
         return param1 * param1 * ((_loc2_ + 1) * param1 + _loc2_) + 1;
      }
   }
}
