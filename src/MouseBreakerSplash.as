package
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.media.SoundMixer;
   
   public class MouseBreakerSplash extends MovieClip
   {
      
      public static const FINISH_SPLASH:String = "finishSplash";
      
      public var doneTimer:Boolean = true;
      
      public var doneAnimation:Boolean = false;
      
      private var stayTime:int;
      
      private var bgColour:Number;
      
      public var mc:MovieClip;
      
      private var stopSoundLoop:Boolean = false;
      
      public function MouseBreakerSplash(param1:Number = 13056, param2:int = 0)
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,init);
         this.bgColour = param1;
         this.stayTime = param2;
      }
      
      private function init(param1:Event) : void
      {
         var _loc2_:Timer = null;
         removeEventListener(Event.ADDED_TO_STAGE,init);
         graphics.beginFill(bgColour);
         graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
         mc = new mb_intro();
         addChild(mc);
         mc.x = 0;
         mc.y = 0;
         mc.addEventListener(Event.COMPLETE,finishAnimationHandler);
         addEventListener(Event.ENTER_FRAME,this.silenceLoop);
         if(stayTime > 0)
         {
            doneTimer = false;
            _loc2_ = new Timer(stayTime,1);
            _loc2_.addEventListener(TimerEvent.TIMER_COMPLETE,finishTimerHandler);
            _loc2_.start();
         }
      }
      
      private function finishTimerHandler(param1:TimerEvent) : void
      {
         param1.target.removeEventListener(TimerEvent.TIMER_COMPLETE,finishTimerHandler);
         doneTimer = true;
         if(doneAnimation)
         {
            SoundMixer.stopAll();
            this.stopSoundLoop = true;
            dispatchEvent(new Event(FINISH_SPLASH));
         }
      }
      
      private function finishAnimationHandler(param1:Event) : void
      {
         mc.removeEventListener(Event.COMPLETE,finishAnimationHandler);
         doneAnimation = true;
         if(doneTimer)
         {
            SoundMixer.stopAll();
            this.stopSoundLoop = true;
            dispatchEvent(new Event(FINISH_SPLASH));
         }
      }

      private function silenceLoop(param1:Event) : void
      {
         if(this.stopSoundLoop)
         {
            removeEventListener(Event.ENTER_FRAME,this.silenceLoop);
            return;
         }
         SoundMixer.stopAll();
      }
   }
}

