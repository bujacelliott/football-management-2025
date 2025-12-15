package com.utterlySuperb.ui.dropDown
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class DropDownSettings
   {
      
      public var overLineThickness:uint;
      
      public var width:uint;
      
      public var height:uint;
      
      public var numRows:uint;
      
      public var defLineThickness:uint;
      
      public var fontSize:uint;
      
      public var defFontColor:Number;
      
      public var overFontColor:Number;
      
      public var defLineColor:Number;
      
      public var defLineAlpha:Number;
      
      public var defBgColor:Number;
      
      public var defBgAlpha:Number;
      
      public var overLineColor:Number;
      
      public var overLineAlpha:Number;
      
      public var overBgColor:Number;
      
      public var overBgAlpha:Number;
      
      public var prompt:String;
      
      public var textStyle:String;
      
      public var mainBG:Sprite;
      
      public var itemBg:Sprite;
      
      public var scrollbarBG:Sprite;
      
      public var scroller:Sprite;
      
      public var scrollBarBtn:Class;
      
      public var btn:MovieClip;
      
      public var expandDown:Boolean;
      
      public var font:String;
      
      public function DropDownSettings(param1:Object)
      {
         var i:String = null;
         var ddOb:Object = param1;
         super();
         this.font = "";
         this.numRows = 6;
         this.fontSize = 12;
         this.width = 40;
         this.height = 20;
         this.prompt = "Please Select";
         this.textStyle = "noScaleLeft";
         this.defFontColor = 16777215;
         this.overFontColor = 16777215;
         this.defLineThickness = 0;
         this.defLineColor = 0;
         this.defLineAlpha = 0;
         this.defBgColor = 0;
         this.defBgAlpha = 1;
         this.overLineThickness = 0;
         this.overLineColor = 0;
         this.overLineAlpha = 0;
         this.overBgColor = 15084830;
         this.overBgAlpha = 1;
         this.expandDown = true;
         for(i in ddOb)
         {
            try
            {
               this[i] = ddOb[i];
            }
            catch(e:Error)
            {
            }
         }
      }
      
      public static function getObject(param1:int = 160) : Object
      {
         return {"width":param1};
      }
   }
}

