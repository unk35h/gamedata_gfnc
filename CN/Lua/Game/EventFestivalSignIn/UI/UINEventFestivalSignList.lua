-- params : ...
-- function num : 0 , upvalues : _ENV
local UINEventFestivalSignList = class("UINEventFestivalSignList", UIBaseNode)
local base = UIBaseNode
local TaskEnum = require("Game.Task.TaskEnum")
local UINEvtFestivalSignItem = require("Game.EventFestivalSignIn.UI.UINEvtFestivalSignItem")
UINEventFestivalSignList.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINEvtFestivalSignItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self._OnClickClose)
  self.signItemPool = (UIItemPool.New)(UINEvtFestivalSignItem, (self.ui).festivalSignInItem, false)
end

UINEventFestivalSignList.InitEventFestivalSignList = function(self, signData, isShowCloseBtn, closeFunc)
  -- function num : 0_1 , upvalues : _ENV, TaskEnum
  ;
  (((self.ui).btn_Close).gameObject):SetActive(isShowCloseBtn or false)
  self.closeFunc = closeFunc
  local signCfg = signData:GetSignCfg()
  local headDayNumber = signCfg.Icon_day_number
  if headDayNumber ~= 0 then
    headDayNumber = headDayNumber - 1
  end
  ;
  ((self.ui).headImage):SetIndex(headDayNumber)
  local signRewardList = (signData:GetSignRewardList())
  local canPickId = nil
  ;
  (self.signItemPool):HideAll()
  for k,v in ipairs(signRewardList) do
    local signItem = (self.signItemPool):GetOne()
    signItem:InitFestivalSignItem(signData, v)
    local state = signData:GetReceiveState(v.day)
    if state == (TaskEnum.eTaskState).Picked or state == (TaskEnum.eTaskState).Completed then
      canPickId = k
    end
  end
  local maxNum = #signRewardList
  -- DECOMPILER ERROR at PC61: Confused about usage of register: R9 in 'UnsetPending'

  ;
  ((self.ui).scrollRect).verticalNormalizedPosition = 1 - ((canPickId or maxNum) - 1) / (maxNum - 1)
end

UINEventFestivalSignList.UpdUIFestivalSignInList = function(self)
  -- function num : 0_2 , upvalues : _ENV
  for i,v in ipairs((self.signItemPool).listItem) do
    v:UpdUIFestivalSignInItem()
  end
end

UINEventFestivalSignList._OnClickClose = function(self)
  -- function num : 0_3
  if self.closeFunc ~= nil then
    (self.closeFunc)()
  end
end

UINEventFestivalSignList.OnDelete = function(self)
  -- function num : 0_4 , upvalues : base
  (self.signItemPool):DeleteAll()
  ;
  (base.OnDelete)(self)
end

return UINEventFestivalSignList

