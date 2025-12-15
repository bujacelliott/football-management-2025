package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol451")]
   public dynamic class MatchDiagramPlayerButton extends MovieClip
   {
      
      public var tf:TextField;
      
      public var bg:MovieClip;
      
      public var light:MovieClip;
      
      public var stamina:MovieClip;
      
      public function MatchDiagramPlayerButton()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}

