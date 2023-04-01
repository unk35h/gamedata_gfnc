-- params : ...
-- function num : 0 , upvalues : _ENV
local UINCarnivalRank = class("UINCarnivalRank", UIBaseNode)
local base = UIBaseNode
local UINCarnivalRankItem = require("Game.ActivityCarnival.UI.CarnivalMiniGame.UINCarnivalRankItem")
UINCarnivalRank.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).background, self, self.Hide)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self.Hide)
  self.itemDic = {}
end

UINCarnivalRank.BindCarnivalRankFunc = function(self, callback)
  -- function num : 0_1
  self._callback = callback
end

UINCarnivalRank.InitCarnivalRank = function(self, allFriendData, mineGrade, callback)
  -- function num : 0_2 , upvalues : _ENV
  self.allFriendDataList = allFriendData
  local myRank = 0
  for index,data in pairs(self.allFriendDataList) do
    if data == mineGrade then
      myRank = index
    end
  end
  self._mineGrade = mineGrade
  ;
  ((self.ui).tex_Rank):SetIndex(0, tostring(myRank))
  ;
  ((self.ui).tex_Score):SetIndex(0, tostring(mineGrade.score))
  -- DECOMPILER ERROR at PC34: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).rankFrame).onChangeItem = BindCallback(self, self.__OnChangeItem)
  -- DECOMPILER ERROR at PC41: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).rankFrame).onInstantiateItem = BindCallback(self, self.__OnInstantiateItem)
  -- DECOMPILER ERROR at PC46: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).rankFrame).totalCount = #self.allFriendDataList
  ;
  ((self.ui).rankFrame):RefillCells()
end

UINCarnivalRank.SetBestScore = function(self, bestScore)
  -- function num : 0_3 , upvalues : _ENV
  (((self.ui).tex_BestScore).gameObject):SetActive(true)
  ;
  ((self.ui).tex_BestScore):SetIndex(0, tostring(bestScore))
end

UINCarnivalRank.__OnChangeItem = function(self, go, index)
  -- function num : 0_4
  local item = (self.itemDic)[go]
  local itemData = (self.allFriendDataList)[index + 1]
  local isMine = self._mineGrade == itemData
  item:InitCarnivalItem(itemData, index + 1, isMine)
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UINCarnivalRank.__OnInstantiateItem = function(self, go)
  -- function num : 0_5 , upvalues : UINCarnivalRankItem
  local item = (UINCarnivalRankItem.New)()
  item:Init(go)
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.itemDic)[go] = item
end

UINCarnivalRank.OnHide = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnHide)(self)
  if self._callback ~= nil then
    (self._callback)()
  end
end

return UINCarnivalRank

