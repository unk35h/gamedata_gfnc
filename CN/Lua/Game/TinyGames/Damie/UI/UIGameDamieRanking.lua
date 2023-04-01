-- params : ...
-- function num : 0 , upvalues : _ENV
local UIGameDamieRanking = class("UIGameDamieRanking", UIBaseNode)
local base = UIBaseNode
local RankingItem = require("Game.TinyGames.FlappyBird.UI.UINRankingItem")
UIGameDamieRanking.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.itemDic = {}
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self.__HideAndBack)
end

UIGameDamieRanking.RefreshDamieRankingData = function(self, allFriendData, mineGrade)
  -- function num : 0_1 , upvalues : _ENV
  ((self.ui).tex_Score):SetIndex(0, tostring(mineGrade.score))
  local curIndex = 1
  for index,v in ipairs(allFriendData) do
    if v == mineGrade then
      curIndex = 
      break
    end
  end
  do
    ;
    ((self.ui).tex_MyRank):SetIndex(0, tostring(curIndex))
    self.allFriendDataList = allFriendData
    -- DECOMPILER ERROR at PC35: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.ui).scroll).onChangeItem = BindCallback(self, self.__OnChangeItem, mineGrade)
    -- DECOMPILER ERROR at PC42: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.ui).scroll).onInstantiateItem = BindCallback(self, self.__OnInstantiateItem)
    -- DECOMPILER ERROR at PC47: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.ui).scroll).totalCount = #self.allFriendDataList
    ;
    ((self.ui).scroll):RefillCells()
  end
end

UIGameDamieRanking.SetBestScore = function(self, bestScore)
  -- function num : 0_2 , upvalues : _ENV
  (((self.ui).tex_BestScore).gameObject):SetActive(true)
  ;
  ((self.ui).tex_BestScore):SetIndex(0, tostring(bestScore))
end

UIGameDamieRanking.__OnChangeItem = function(self, mineGrade, go, index)
  -- function num : 0_3
  local item = (self.itemDic)[go]
  local itemData = (self.allFriendDataList)[index + 1]
  local isMine = mineGrade == itemData
  item:InitWithRankData(itemData, index + 1, isMine)
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UIGameDamieRanking.__OnInstantiateItem = function(self, go)
  -- function num : 0_4 , upvalues : RankingItem
  local item = (RankingItem.New)()
  item:Init(go)
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.itemDic)[go] = item
end

UIGameDamieRanking.__HideAndBack = function(self)
  -- function num : 0_5
  self:Hide()
end

return UIGameDamieRanking

