-- params : ...
-- function num : 0 , upvalues : _ENV
local DormInteractActionData = class("DormCharInteractData")
local DormEnum = require("Game.Dorm.DormEnum")
DormInteractActionData.ResetData = function(self)
  -- function num : 0_0
  self.interPointEntity = nil
  self.talkCharEntity = nil
  self.__interactFunc = nil
  self.__interactType = nil
  self._interactEnable = false
end

DormInteractActionData.InitFntAction = function(self, interPointEntity, interactFunc)
  -- function num : 0_1 , upvalues : DormEnum
  self._interactEnable = true
  self.interPointEntity = interPointEntity
  self.__interactFunc = interactFunc
  self.__interactType = (DormEnum.CharInteractState).Fnt
end

DormInteractActionData.InitTalkAction = function(self, charEntity, interactFunc)
  -- function num : 0_2 , upvalues : DormEnum
  self._interactEnable = true
  self.talkCharEntity = charEntity
  self.__interactFunc = interactFunc
  self.__interactType = (DormEnum.CharInteractState).Talk
end

DormInteractActionData.InitGreetAction = function(self, charEntity, interactFunc)
  -- function num : 0_3 , upvalues : DormEnum
  self._interactEnable = true
  self.talkCharEntity = charEntity
  self.__interactFunc = interactFunc
  self.__interactType = (DormEnum.CharInteractState).Greet
end

DormInteractActionData.InitDoorAction = function(self, interactFunc)
  -- function num : 0_4 , upvalues : DormEnum
  self._interactEnable = true
  self.__interactFunc = interactFunc
  self.__interactType = (DormEnum.CharInteractState).LeaveDoor
end

DormInteractActionData.GetActionData = function(self)
  -- function num : 0_5 , upvalues : DormEnum, _ENV
  local desc = ""
  local spriteName = ""
  local title = ""
  local hasNew = false
  if self.__interactType == (DormEnum.CharInteractState).Fnt then
    local InterPointData = (self.interPointEntity):GetInterPointData()
    local fntCfg = InterPointData:GetFntCfg()
    local categoryCfg = (ConfigData.dorm_fnt_category)[fntCfg.category]
    desc = (InterPointData.fntData):GetName()
    spriteName = categoryCfg.icon
    title = InterPointData:GetInteractName()
  else
    do
      if self.__interactType == (DormEnum.CharInteractState).Talk then
        desc = (self.talkCharEntity):GetRoleName()
        spriteName = "Icon_99"
        title = ConfigData:GetTipContent(2032)
        hasNew = not (self.talkCharEntity):IsAllTalked()
      else
        if self.__interactType == (DormEnum.CharInteractState).LeaveDoor then
          desc = ConfigData:GetTipContent(2033)
          spriteName = "Icon_98"
          title = ConfigData:GetTipContent(2034)
        else
          if self.__interactType == (DormEnum.CharInteractState).Greet then
            desc = (self.talkCharEntity):GetRoleName()
            spriteName = "Icon_99"
            title = ConfigData:GetTipContent(2035)
          end
        end
      end
      return desc, spriteName, title, hasNew
    end
  end
end

DormInteractActionData.SetInteractActionEnable = function(self, active)
  -- function num : 0_6
  self._interactEnable = active
end

DormInteractActionData.GetInteractActionEnable = function(self)
  -- function num : 0_7
  return self._interactEnable
end

DormInteractActionData.GetInteractType = function(self)
  -- function num : 0_8
  return self.__interactType
end

DormInteractActionData.InvokeInteractAction = function(self)
  -- function num : 0_9
  if self.__interactFunc ~= nil then
    (self.__interactFunc)(self)
  end
end

return DormInteractActionData

