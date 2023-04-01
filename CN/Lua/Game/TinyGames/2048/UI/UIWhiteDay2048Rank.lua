-- params : ...
-- function num : 0 , upvalues : _ENV
local UIWhiteDay2048Rank = class("UIWhiteDay2048Rank", UIBaseWindow)
local base = UIBaseWindow
local UINWhiteDay2048RankItem = require("Game.TinyGames.2048.UI.UINWhiteDay2048RankItem")
UIWhiteDay2048Rank.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.SetTopStatus)(self, self._OnClickReturn, nil, nil, nil, true)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self._HideAndBack)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_background, self, self._HideAndBack)
  self.itemDic = {}
end

UIWhiteDay2048Rank.Refresh2048RankingData = function(self, allFriendData, mineGrade)
  -- function num : 0_1 , upvalues : _ENV
  self.allFriendDataList = allFriendData
  local myRank = 0
  for index,data in pairs(self.allFriendDataList) do
    if data == mineGrade then
      myRank = index
    end
  end
  ;
  ((self.ui).tex_Rank):SetIndex(0, tostring(myRank))
  ;
  ((self.ui).tex_Score):SetIndex(0, tostring(mineGrade.score))
  -- DECOMPILER ERROR at PC34: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).loopscroll).onChangeItem = BindCallback(self, self.__OnChangeItem, mineGrade)
  -- DECOMPILER ERROR at PC41: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).loopscroll).onInstantiateItem = BindCallback(self, self.__OnInstantiateItem)
  -- DECOMPILER ERROR at PC46: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).loopscroll).totalCount = #self.allFriendDataList
  ;
  ((self.ui).loopscroll):RefillCells()
end

UIWhiteDay2048Rank.SetBestScore = function(self, bestScore)
  -- function num : 0_2 , upvalues : _ENV
  (((self.ui).tex_BestScore).gameObject):SetActive(true)
  ;
  ((self.ui).tex_BestScore):SetIndex(0, tostring(bestScore))
end

UIWhiteDay2048Rank.__OnChangeItem = function(self, mineGrade, go, index)
  -- function num : 0_3
  local item = (self.itemDic)[go]
  local itemData = (self.allFriendDataList)[index + 1]
  local isMine = mineGrade == itemData
  item:Init2048RankItem(itemData, index + 1, isMine)
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UIWhiteDay2048Rank.__OnInstantiateItem = function(self, go)
  -- function num : 0_4 , upvalues : UINWhiteDay2048RankItem
  local item = (UINWhiteDay2048RankItem.New)()
  item:Init(go)
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.itemDic)[go] = item
end

UIWhiteDay2048Rank._OnClickReturn = function(self)
  -- function num : 0_5
  self:Delete()
end

UIWhiteDay2048Rank._HideAndBack = function(self)
  -- function num : 0_6 , upvalues : _ENV
  (UIUtil.OnClickBack)()
end

UIWhiteDay2048Rank.OnDelete = function(self)
  -- function num : 0_7 , upvalues : base
  (base.OnDelete)(self)
end

return UIWhiteDay2048Rank

