package com.utterlySuperb.text
{
   import flash.events.Event;
   import flash.system.Capabilities;
   import flash.text.AntiAliasType;
   import flash.text.Font;
   import flash.text.StyleSheet;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class TextHelper
   {
      
      public static const STATIC_LEFT:String = "staticLeft";
      
      public static const STATIC_CENTER:String = "staticCenter";
      
      public static const STATIC_RIGHT:String = "staticRight";
      
      public static const INPUT_LEFT:String = "inputLeft";
      
      public static const INPUT_CENTER:String = "inputCenter";
      
      public static const INPUT_RIGHT:String = "inputRight";
      
      public function TextHelper()
      {
         super();
      }
      
      public static function firefoxBugFix(param1:TextField) : void
      {
         var _loc2_:String = Capabilities.playerType;
         if(_loc2_ == "PlugIn")
         {
            param1.addEventListener(Event.CHANGE,firefoxBugFixHandler);
         }
      }
      
      public static function doTextField(param1:TextField, param2:Font, param3:int = 12, param4:Number = 0, param5:Object = null) : void
      {
         var _loc6_:TextSettings = new TextSettings(param5);
         param1.multiline = _loc6_.multiline;
         param1.wordWrap = _loc6_.wordWrap;
         param1.mouseEnabled = _loc6_.mouseEnabled;
         var _loc7_:String = "Arial";
         if(param2.fontName)
         {
            _loc7_ = param2.fontName;
            param1.embedFonts = true;
         }
         var _loc8_:TextFormat = new TextFormat(_loc7_,param3,param4);
         _loc8_.align = _loc6_.align;
         param1.selectable = _loc6_.selectable;
         param1.type = _loc6_.type;
         param1.autoSize = _loc6_.autoSize;
         param1.defaultTextFormat = _loc8_;
         param1.setTextFormat(_loc8_);
      }
      
      public static function fitTextField(param1:TextField) : void
      {
         param1.width = param1.textWidth + 5;
         param1.height = param1.textHeight + 5;
      }
      
      public static function formatText(param1:String, param2:String = "#000000", param3:int = 12) : String
      {
         return "<font color=\'" + param2 + "\' size=\'" + param3.toString() + "\'>" + param1 + "</font>";
      }
      
      private static function firefoxBugFixHandler(param1:Event) : void
      {
         var _loc2_:TextField = param1.target as TextField;
         var _loc3_:String = _loc2_.text.replace("\"","@");
         _loc2_.text = _loc3_;
      }
      
      public static function constrainTextHeight(param1:TextField, param2:int, param3:Boolean = false, param4:int = -1, param5:Boolean = false) : void
      {
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:Boolean = false;
         var _loc10_:* = null;
         if(param1.textHeight > param2)
         {
            _loc6_ = param4 < 0 ? 2 : param1.text.length - param4;
            _loc7_ = param1.text;
            _loc8_ = " ";
            _loc9_ = true;
            while((param1.textHeight > param2 || !_loc9_) && _loc6_ < _loc7_.length)
            {
               if(param5)
               {
                  _loc8_ = _loc7_.charAt(_loc7_.length - _loc6_);
                  _loc9_ = _loc8_ == " " || _loc8_ == "." || _loc8_ == ",";
               }
               _loc10_ = _loc7_.substr(0,_loc7_.length - _loc6_++);
               if(param3)
               {
                  _loc10_ += "...";
               }
               param1.text = _loc10_;
            }
         }
      }
      
      public static function fillTextField(param1:TextField, param2:String, param3:Boolean = false) : void
      {
         if(param3)
         {
            param1.htmlText = param2;
         }
         else
         {
            param1.text = param2;
         }
         fitTextField(param1);
      }
      
      public static function capitalise(param1:String) : String
      {
         return param1.charAt(0).toUpperCase() + param1.slice(1);
      }
      
      public static function reduceTextWidthStyledHtml(param1:TextField, param2:int, param3:String, param4:int = 20, param5:int = 1) : void
      {
         var _loc6_:String = null;
         if(param1.textWidth > param2)
         {
            _loc6_ = param1.text;
            while(param1.textWidth > param2 && 20 < param4)
            {
               param1.htmlText = getStyleString("<font size=\'" + param4 + "\'>" + _loc6_ + "</font>",param3);
               param4 -= param5;
            }
         }
         param1.width = param1.textWidth + 5;
      }
      
      public static function addHtmlFont(param1:String, param2:String = "", param3:String = "", param4:String = "") : String
      {
         var _loc5_:* = "<font ";
         if(param2.length > 0)
         {
            _loc5_ = _loc5_ + "face=\'" + param2 + "\' ";
         }
         if(param3.length > 0)
         {
            _loc5_ = _loc5_ + "size=\'" + param3 + "\' ";
         }
         if(param4.length > 0)
         {
            _loc5_ = _loc5_ + "color=\'" + param4 + "\' ";
         }
         return _loc5_ + ">" + param1 + "</font>";
      }
      
      public static function styleTextField(param1:TextField, param2:StyleSheet, param3:Boolean = false, param4:Boolean = true) : void
      {
         param1.styleSheet = param2;
         param1.selectable = false;
         param1.embedFonts = param4;
         param1.antiAliasType = AntiAliasType.ADVANCED;
         param1.wordWrap = param1.multiline = param3;
      }
      
      public static function reduceTextWidthHtml(param1:TextField, param2:int, param3:int = 20, param4:int = 1) : void
      {
         var _loc5_:String = null;
         if(param1.textWidth > param2)
         {
            _loc5_ = param1.text;
            while(param1.textWidth > param2 && 20 < param3)
            {
               param1.htmlText = "<font size=\'" + param3 + "\'>" + _loc5_ + "</font>";
               param3 -= param4;
            }
         }
         param1.width = param1.textWidth + 5;
      }
      
      public static function prettifyNumber(param1:int, param2:int = 1, param3:int = 0) : String
      {
         param1 = Math.abs(param1);
         var _loc4_:String = param3 > 0 ? (param1 / param2).toFixed(param3).toString() : int(param1 / param2).toString();
         var _loc5_:Array = [];
         var _loc6_:int = _loc4_.length - 1;
         if(_loc4_.indexOf(".") >= 0)
         {
            _loc6_ = _loc4_.indexOf(".") - 1;
         }
         var _loc7_:int = _loc4_.length - 1;
         while(_loc7_ >= 0)
         {
            if(_loc6_ - _loc7_ > 0 && (_loc6_ - _loc7_) % 3 == 0)
            {
               _loc5_.push(",");
            }
            _loc5_.push(_loc4_.charAt(_loc7_));
            _loc7_--;
         }
         return _loc5_.reverse().join("");
      }
      
      public static function getStyleString(param1:String, param2:String) : String
      {
         return "<span class=\"" + param2 + "\">" + param1 + "</span>";
      }
      
      public static function stringOK(param1:String) : Boolean
      {
         return param1.length > 0 && param1 != " ";
      }
      
      public static function contrainTextWidth(param1:TextField, param2:int, param3:Boolean = false, param4:int = -1) : void
      {
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:* = null;
         if(param1.textWidth > param2)
         {
            _loc5_ = param4 < 0 ? 2 : param1.text.length - param4;
            _loc6_ = param1.text;
            while(param1.textWidth > param2 && _loc5_ < _loc6_.length)
            {
               _loc7_ = _loc6_.substr(0,_loc6_.length - _loc5_++);
               if(param3)
               {
                  _loc7_ += "...";
               }
               param1.text = _loc7_;
            }
            param1.width = param1.textWidth + 5;
         }
      }
      
      public static function checkEmail(param1:String) : Boolean
      {
         var _loc2_:RegExp = /^[a-z][\w.-]+@\w[\w.-]+\.[\w.-]*[a-z][a-z]$/i;
         return _loc2_.test(param1);
      }
      
      public static function doTextField2(param1:TextField, param2:String = "Arial", param3:int = 12, param4:Number = 0, param5:Object = null) : void
      {
         var _loc6_:TextSettings = new TextSettings(param5);
         param1.multiline = _loc6_.multiline;
         param1.wordWrap = _loc6_.wordWrap;
         param1.mouseEnabled = _loc6_.mouseEnabled;
         param1.embedFonts = true;
         var _loc7_:TextFormat = new TextFormat(param2,param3,param4);
         _loc7_.align = _loc6_.align;
         param1.selectable = _loc6_.selectable;
         param1.type = _loc6_.type;
         _loc7_.bold = _loc6_.bold;
         _loc7_.leading = _loc6_.leading;
         param1.autoSize = _loc6_.autoSize;
         param1.antiAliasType = AntiAliasType.ADVANCED;
         param1.defaultTextFormat = _loc7_;
         param1.setTextFormat(_loc7_);
      }
      
      public static function reduceTextHeight(param1:TextField, param2:int, param3:int = 20) : void
      {
         var _loc4_:TextFormat = new TextFormat();
         _loc4_.size = param3;
         param1.setTextFormat(_loc4_);
         if(param1.textHeight > param2)
         {
            while(param1.textHeight > param2 && param3 > 1)
            {
               _loc4_.size = --param3;
               param1.setTextFormat(_loc4_);
            }
         }
      }
   }
}

