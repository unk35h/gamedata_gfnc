-- params : ...
-- function num : 0 , upvalues : _ENV
local UINTimeLimitTasklimitNode = class("UINTimeLimitTasklimitNode", UIBaseNode)
local base = UIBaseNode
UINTimeLimitTasklimitNode.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self.taskCtrl = ControllerManager:GetController(ControllerTypeId.Task)
  ;
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self:Hide()
end

UINTimeLimitTasklimitNode.InitWithCurTaskDatas = function(self, typeId)
  -- function num : 0_1 , upvalues : _ENV
  self.typeId = typeId
  self:RefreshTaskLeftTime()
  if self.shopTimer == nil then
    self.shopTimer = TimerManager:StartTimer(1, self.RefreshTaskLeftTime, self)
  else
    TimerManager:ResumeTimer(self.shopTimer)
  end
end

UINTimeLimitTasklimitNode.RefreshTaskLeftTime = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local outOfDataTm = ((self.taskCtrl).timeLimitTaskendTime)[self.typeId]
  if outOfDataTm == nil then
    return 
  end
  local leftTime = outOfDataTm - PlayerDataCenter.timestamp
  if leftTime < 0 then
    ((self.ui).tex_lefttime):SetIndex(2)
    return 
  end
  local d, h, m, s = TimeUtil:TimestampToTimeInter(leftTime, false, true)
  if d > 0 then
    ((self.ui).tex_lefttime):SetIndex(0, tostring(d), (string.format)("%02d:%02d:%02d", tostring(h), tostring(m), tostring(s)))
  else
    ;
    ((self.ui).tex_lefttime):SetIndex(1, (string.format)("%02d:%02d:%02d", tostring(h), tostring(m), tostring(s)))
  end
end

UINTimeLimitTasklimitNode.OnHide = function(self)
  -- function num : 0_3 , upvalues : _ENV, base
  if self.shopTimer ~= nil then
    TimerManager:PauseTimer(self.shopTimer)
  end
  ;
  (base.OnHide)(self)
end

UINTimeLimitTasklimitNode.OnDelete = function(self)
  -- function num : 0_4 , upvalues : _ENV, base
  if self.shopTimer ~= nil then
    TimerManager:StopTimer(self.shopTimer)
    self.shopTimer = nil
  end
  ;
  (base.OnDelete)(self)
end

return UINTimeLimitTasklimitNode

