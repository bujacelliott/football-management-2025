package com.utterlySuperb.chumpManager.engine
{
   import flash.utils.ByteArray;
   
   public class TransferBudgetHelper
   {
      
      [Embed(source="../../../../../transfer_budgets_by_league_then_club.csv", mimeType="application/octet-stream")]
      private static const BudgetData:Class;
      
      private static var budgetMap:Object;
      
      private static var budgetList:Array;
      
      public function TransferBudgetHelper()
      {
         super();
      }
      
      public static function getBudget(param1:String, param2:String) : int
      {
         var _loc3_:String = normalize(param1);
         var _loc4_:String = normalize(param2);
         if(!_loc3_ || !_loc4_)
         {
            return 0;
         }
         if(!budgetMap)
         {
            buildBudgetMap();
         }
         var _loc5_:String = _loc3_ + "|" + _loc4_;
         if(budgetMap && budgetMap.hasOwnProperty(_loc5_))
         {
            return int(budgetMap[_loc5_]);
         }
         if(budgetList)
         {
            for each(var _loc6_:Object in budgetList)
            {
               if(_loc6_.league != _loc3_)
               {
                  continue;
               }
               if(_loc6_.club.indexOf(_loc4_) >= 0 || _loc4_.indexOf(_loc6_.club) >= 0)
               {
                  return int(_loc6_.value);
               }
               if(matchClubAlias(_loc4_,_loc6_.club))
               {
                  return int(_loc6_.value);
               }
            }
         }
         return 0;
      }
      
      private static function buildBudgetMap() : void
      {
         var _loc1_:ByteArray = new BudgetData() as ByteArray;
         if(!_loc1_)
         {
            return;
         }
         var _loc2_:String = _loc1_.readUTFBytes(_loc1_.length);
         var _loc3_:Array = _loc2_.split(/\r?\n/);
         if(_loc3_.length <= 1)
         {
            return;
         }
         budgetMap = {};
         budgetList = [];
         var _loc4_:Array = String(_loc3_[0]).split(",");
         var _loc5_:Object = {};
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_.length)
         {
            _loc5_[_loc4_[_loc6_]] = _loc6_;
            _loc6_++;
         }
         var _loc7_:int = 1;
         while(_loc7_ < _loc3_.length)
         {
            if(String(_loc3_[_loc7_]).length == 0)
            {
               _loc7_++;
               continue;
            }
            var _loc8_:Array = String(_loc3_[_loc7_]).split(",");
            var _loc9_:String = normalize(_loc8_[_loc5_["League"]]);
            var _loc10_:String = normalize(_loc8_[_loc5_["Club"]]);
            var _loc11_:String = _loc8_[_loc5_["TransferBudgetGBP"]];
            var _loc12_:int = int(Number(_loc11_));
            if(_loc9_.length > 0 && _loc10_.length > 0 && _loc12_ > 0)
            {
               budgetMap[_loc9_ + "|" + _loc10_] = _loc12_;
               budgetList.push({
                  "league":_loc9_,
                  "club":_loc10_,
                  "value":_loc12_
               });
            }
            _loc7_++;
         }
      }
      
      private static function normalize(param1:String) : String
      {
         if(!param1)
         {
            return "";
         }
         return param1.replace(/^\s+|\s+$/g,"").toLowerCase();
      }

      private static function matchClubAlias(param1:String, param2:String) : Boolean
      {
         var _loc3_:String = stripClubTokens(param1);
         var _loc4_:String = stripClubTokens(param2);
         if(_loc3_.length == 0 || _loc4_.length == 0)
         {
            return false;
         }
         return _loc4_.indexOf(_loc3_) >= 0 || _loc3_.indexOf(_loc4_) >= 0;
      }

      private static function stripClubTokens(param1:String) : String
      {
         var _loc2_:String = param1.toLowerCase();
         _loc2_ = _loc2_.replace(/[^a-z0-9 ]/g,"");
         _loc2_ = _loc2_.replace(/\b(fc|afc|cf|sc|ac|ssc|us|tsg|vfb|vfl|rb|real|club)\b/g,"");
         _loc2_ = _loc2_.replace(/\s+/g,"").replace(/^\s+|\s+$/g,"");
         return _loc2_;
      }
   }
}
