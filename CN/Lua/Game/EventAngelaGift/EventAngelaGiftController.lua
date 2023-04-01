-- params : ...
-- function num : 0 , upvalues : _ENV
local EventAngelaGiftController = class("EventAngelaGiftController", ControllerBase)
local base = ControllerBase
local EventAngelaGiftData = require("Game.EventAngelaGift.Data.EventAngelaGiftData")
EventAngelaGiftController.OnInit = function(self)
  -- function num : 0_0
  self._dataDic = {}
end

EventAngelaGiftController.InitAngelaGift = function(self, actFrameData)
  -- function num : 0_1 , upvalues : EventAngelaGiftData
  if (self._dataDic)[actFrameData:GetActId()] ~= nil then
    return 
  end
  local data = (EventAngelaGiftData.New)()
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self._dataDic)[actFrameData:GetActId()] = data
  data:InitAngelaGiftData(actFrameData:GetActId())
end

EventAngelaGiftController.GetTheLatestAngelaGiftData = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local res = nil
  for k,v in pairs(self._dataDic) do
    if res == nil then
      res = v
    else
      if res:GetActivityBornTime() < v:GetActivityBornTime() then
        res = v
      end
    end
  end
  return res
end

EventAngelaGiftController.GetAngelaGiftDataByActId = function(self, actId)
  -- function num : 0_3
  return (self._dataDic)[actId]
end

return EventAngelaGiftController

