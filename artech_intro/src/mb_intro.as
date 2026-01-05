package {
  import flash.display.MovieClip;
  import flash.display.Shape;
  import flash.display.Bitmap;
  import flash.events.Event;
  import flash.filters.GlowFilter;

  /**
   * Intro MovieClip for Ar-Tech.
   * Plays once (~2.5s @ 30fps), then dispatches Event.COMPLETE and stops.
   *
   * Linkage / class name MUST be: mb_intro
   */
  public class mb_intro extends MovieClip {

    [Embed(source="../assets/logo.png")]
    private static const LogoPNG:Class;

    private const W:int = 800;
    private const H:int = 600;
    private const SAFE_W:int = 700;
    private const SAFE_H:int = 500;

    private const FPS:int = 30;
    private const TOTAL_FRAMES:int = 75; // 2.5 seconds @ 30fps

    private var _t:int = 0;
    private var _logo:Bitmap;
    private var _glow:GlowFilter;

    public function mb_intro() {
      stop();
      addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    private function onAddedToStage(e:Event):void {
      removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

      // Keep this clip self-contained.
      drawBackground();
      createLogo();

      _t = 0;
      addEventListener(Event.ENTER_FRAME, onEnterFrame);
    }

    private function drawBackground():void {
      var bg:Shape = new Shape();
      bg.graphics.beginFill(0x000000, 1);
      bg.graphics.drawRect(0, 0, W, H);
      bg.graphics.endFill();
      addChild(bg);
    }

    private function createLogo():void {
      _logo = new LogoPNG() as Bitmap;
      _logo.smoothing = true;

      // Fit within safe area (leave some padding).
      var maxW:Number = SAFE_W - 60;
      var maxH:Number = SAFE_H - 140;
      var s:Number = Math.min(maxW / _logo.width, maxH / _logo.height);

      _logo.scaleX = _logo.scaleY = s;
      _logo.x = (W - _logo.width) * 0.5;
      _logo.y = (H - _logo.height) * 0.5;

      // Start state (slightly smaller, lower, invisible).
      _logo.alpha = 0;
      _logo.scaleX = _logo.scaleY = s * 0.92;
      _logo.x = (W - _logo.width) * 0.5;
      _logo.y = (H - _logo.height) * 0.5 + 12;

      _glow = new GlowFilter(0x00ff66, 0.0, 18, 18, 2.0, 2);
      _logo.filters = [_glow];

      addChild(_logo);
    }

    private function onEnterFrame(e:Event):void {
      _t++;

      // Normalized progress 0..1
      var p:Number = _t / TOTAL_FRAMES;
      if (p > 1) p = 1;

      // Phase timings
      var pIn:Number = clamp((p - 0.00) / 0.22);  // fade/slide in ~0.55s
      var pScale:Number = clamp((p - 0.05) / 0.70); // scale settle ~1.75s

      // Alpha: ease out
      _logo.alpha = easeOutCubic(pIn);

      // Position: ease out (slide up a touch)
      var yFrom:Number = (H - _logo.height) * 0.5 + 12;
      var yTo:Number = (H - _logo.height) * 0.5;
      _logo.y = lerp(yFrom, yTo, easeOutCubic(pIn));

      // Scale: little overshoot then settle
      var baseScale:Number = (_logo.scaleX / 0.92); // recover original s each frame? not stable
      // Recompute original fitted scale from current dimensions and stored bitmapData dims.
      var fitted:Number = Math.min((SAFE_W - 60) / (_logo.bitmapData.width), (SAFE_H - 140) / (_logo.bitmapData.height));
      var fromS:Number = fitted * 0.92;
      var overS:Number = fitted * 1.03;
      var toS:Number = fitted * 1.00;

      var s:Number;
      if (pScale < 0.45) {
        s = lerp(fromS, overS, easeOutBack(pScale / 0.45));
      } else {
        s = lerp(overS, toS, easeOutCubic((pScale - 0.45) / 0.55));
      }

      _logo.scaleX = _logo.scaleY = s;
      _logo.x = (W - _logo.width) * 0.5;

      // Glow pulse (subtle)
      var pulse:Number = 0.5 + 0.5 * Math.sin(_t * 0.18);
      _glow.alpha = 0.10 + 0.25 * pulse;
      _logo.filters = [_glow];

      if (_t >= TOTAL_FRAMES) {
        removeEventListener(Event.ENTER_FRAME, onEnterFrame);
        // Match requested behavior: dispatch complete and stop.
        dispatchEvent(new Event(Event.COMPLETE));
        stop();
      }
    }

    private static function clamp(v:Number, min:Number = 0, max:Number = 1):Number {
      if (v < min) return min;
      if (v > max) return max;
      return v;
    }

    private static function lerp(a:Number, b:Number, t:Number):Number {
      return a + (b - a) * t;
    }

    private static function easeOutCubic(t:Number):Number {
      t = clamp(t);
      var u:Number = t - 1;
      return u * u * u + 1;
    }

    // A gentle back-ease for the overshoot.
    private static function easeOutBack(t:Number):Number {
      t = clamp(t);
      var s:Number = 1.70158;
      t = t - 1;
      return (t * t * ((s + 1) * t + s) + 1);
    }
  }
}
