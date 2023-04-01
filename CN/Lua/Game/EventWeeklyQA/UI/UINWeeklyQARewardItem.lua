-- params : ...
-- function num : 0 , upvalues : _ENV
local UINWeeklyQARewardItem = class("UINWeeklyQARewardItem", UIBaseNode)
local base = UIBaseNode
local EventWeeklyQAQuestionRewardData = require("Game.EventWeeklyQA.Data.EventWeeklyQAQuestionRewardData")
UINWeeklyQARewardItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self.isPicking = false
  ;
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).rewardItem, self, self.__OnBtnClick)
end

UINWeeklyQARewardItem.InitWeeklyQARewardItem = function(self, index, state, pointCount, onClickFunc)
  -- function num : 0_1 , upvalues : _ENV
  self.index = index
  self.state = state
  self.onClickFunc = onClickFunc
  ;
  ((self.ui).tex_Point):SetIndex(0, tostring(pointCount))
  ;
  ((self.ui).obj_viewState):SetActive(false)
  ;
  ((self.ui).obj_isPicked):SetActive(false)
  ;
  ((self.ui).obj_canRecive):SetActive(false)
  self:__RefreshItemStateUI()
end

UINWeeklyQARewardItem.__RefreshItemStateUI = function(self)
  -- function num : 0_2 , upvalues : EventWeeklyQAQuestionRewardData
  ;
  ((self.ui).rewardStateImg):SetIndex(self.state == (EventWeeklyQAQuestionRewardData.eRewardState).Picked and 1 or 0)
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).img_ring).color = ((self.ui).stateColor)[self.state + 1]
  local isCompleted = self.state == (EventWeeklyQAQuestionRewardData.eRewardState).CompleteNoPicked
  self.isPicked = self.state == (EventWeeklyQAQuestionRewardData.eRewardState).Picked
  ;
  ((self.ui).fx_go):SetActive(isCompleted)
  ;
  ((self.ui).obj_canRecive):SetActive(isCompleted)
  ;
  ((self.ui).obj_completed):SetActive(self.isPicked)
  ;
  ((self.ui).obj_isPicked):SetActive(self.isPicked)
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UINWeeklyQARewardItem.SetPicking = function(self, flag)
  -- function num : 0_3
  self.isPicking = flag
end

UINWeeklyQARewardItem.SetViewState = function(self, active)
  -- function num : 0_4
  ((self.ui).obj_viewState):SetActive(active)
  if self.isPicked then
    ((self.ui).obj_isPicked):SetActive(not active)
  end
end

UINWeeklyQARewardItem.__OnBtnClick = function(self)
  -- function num : 0_5
  if self.isPicking then
    return 
  end
  if self.onClickFunc then
    (self.onClickFunc)(self, self.index)
  end
end

UINWeeklyQARewardItem.OnDelete = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnDelete)(self)
end

return UINWeeklyQARewardItem

