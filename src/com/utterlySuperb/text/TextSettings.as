package com.utterlySuperb.text
{
   import flash.text.*;
   
   public class TextSettings
   {
      
      public var type:String;
      
      public var align:String;
      
      public var leading:int;
      
      public var multiline:Boolean;
      
      public var autoSize:String;
      
      public var selectable:Boolean;
      
      public var wordWrap:Boolean;
      
      public var mouseEnabled:Boolean;
      
      public var bold:Boolean;
      
      public function TextSettings(param1:Object)
      {
         var i:Object = null;
         var ob:Object = param1;
         super();
         this.align = TextFormatAlign.LEFT;
         this.autoSize = TextFieldAutoSize.LEFT;
         this.type = TextFieldType.DYNAMIC;
         this.selectable = false;
         this.wordWrap = false;
         this.multiline = false;
         this.mouseEnabled = false;
         this.bold = false;
         this.leading = 0;
         for(i in ob)
         {
            try
            {
               this[i] = ob[i];
            }
            catch(e:Error)
            {
               trace("TextSettings error:" + e.toString());
            }
         }
         if(this.type == TextFieldType.INPUT)
         {
            this.selectable = this.mouseEnabled = true;
         }
         if(this.multiline || this.wordWrap)
         {
            this.wordWrap = this.multiline = true;
         }
      }
   }
}

