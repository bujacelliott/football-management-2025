package
{
   import com.utterlySuperb.text.TextHelper;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   import flash.events.ProgressEvent;
   import flash.text.TextField;
   import flash.utils.getDefinitionByName;
   
   public class Preloader extends MovieClip
   {
      
      private var tf:TextField;
      
      public function Preloader()
      {
         super();
         stage.scaleMode = StageScaleMode.NO_SCALE;
         addEventListener(Event.ENTER_FRAME,this.checkFrame);
         loaderInfo.addEventListener(ProgressEvent.PROGRESS,this.progress);
         Styles.initFonts();
         graphics.beginFill(16777215);
         graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
         this.tf = new TextField();
         TextHelper.doTextField2(this.tf,Styles.HEADER_FONT,20);
         addChild(this.tf);
         this.tf.x = stage.stageWidth / 2;
         this.tf.y = stage.stageHeight / 2;
      }
      
      private function progress(param1:ProgressEvent) : void
      {
         this.tf.text = "LOADED:" + (param1.bytesLoaded / param1.bytesTotal).toFixed(2);
      }
      
      private function checkFrame(param1:Event) : void
      {
         if(currentFrame == totalFrames)
         {
            removeEventListener(Event.ENTER_FRAME,this.checkFrame);
            this.startup();
         }
      }
      
      private function startup() : void
      {
         stop();
         removeChild(this.tf);
         loaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.progress);
         var _loc1_:Class = getDefinitionByName("Main") as Class;
         addChild(new _loc1_() as DisplayObject);
      }
   }
}

