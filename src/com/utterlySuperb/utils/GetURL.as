package com.utterlySuperb.utils
{
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   
   public class GetURL
   {
      
      public function GetURL()
      {
         super();
      }
      
      public static function getURL(param1:String, param2:Boolean = false) : void
      {
         var url:String = param1;
         var newWin:Boolean = param2;
         var window:String = newWin ? "_blank" : "_self";
         var req:URLRequest = new URLRequest(url);
         try
         {
            navigateToURL(req,window);
         }
         catch(e:Error)
         {
         }
      }
   }
}

