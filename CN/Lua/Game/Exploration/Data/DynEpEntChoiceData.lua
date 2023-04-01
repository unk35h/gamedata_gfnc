-- params : ...
-- function num : 0 , upvalues : _ENV
local DynEpEntChoiceData = class("DynEpEntChoiceData")
local ExplorationEnum = require("Game.Exploration.ExplorationEnum")
DynEpEntChoiceData.CreateChoiceData = function(idx, msgData)
  -- function num : 0_0 , upvalues : DynEpEntChoiceData
  local data = (DynEpEntChoiceData.New)()
  data:InitDynEpEnChoiceData(idx, msgData)
  return data
end

DynEpEntChoiceData.ctor = function(self)
  -- function num : 0_1
end

DynEpEntChoiceData.InitDynEpEnChoiceData = function(self, idx, msgData)
  -- function num : 0_2
  self.idx = idx
  self.choiceId = msgData.id
  self.isRandom = msgData.random
  self.catId = msgData.cat
  self.cfg = self:_GetChoiceCfg(msgData.cat)
  self.displayNewData = self:_AnalysisChoiceGetNew(self.cfg)
end

DynEpEntChoiceData._GetChoiceCfg = function(self, catId)
  -- function num : 0_3 , upvalues : ExplorationEnum, _ENV
  local cfg = nil
  if catId == (ExplorationEnum.eEventRoomChoiceType).Normal then
    cfg = (ConfigData.event_choice)[self.choiceId]
    if cfg == nil then
      error("Can`t find choiceCfg id:" .. tostring(self.choiceId))
      return 
    end
  else
    if catId == (ExplorationEnum.eEventRoomChoiceType).Upgrade then
      cfg = (ConfigData.event_upgrade)[self.choiceId]
    else
      if catId == (ExplorationEnum.eEventRoomChoiceType).Jump then
        cfg = (ConfigData.event_jump)[self.choiceId]
      else
        if catId == (ExplorationEnum.eEventRoomChoiceType).Assist then
          cfg = (ConfigData.event_assist)[self.choiceId]
        else
          if catId == (ExplorationEnum.eEventRoomChoiceType).AssistEx then
            cfg = (ConfigData.event_assist_ex)[self.choiceId]
          else
            error("Unsupported eEventRoomChoiceType, id = " .. tostring(self.choiceId))
            return 
          end
        end
      end
    end
  end
  return cfg
end

DynEpEntChoiceData._AnalysisChoiceGetNew = function(self, cfg)
  -- function num : 0_4 , upvalues : _ENV
  local displayNewData = nil
  if cfg.ignore_onboard then
    return nil
  end
  local getItems = cfg.choiceGetNew
  if getItems ~= nil and #getItems > 0 then
    for _,v in ipairs(getItems) do
      -- DECOMPILER ERROR at PC32: Unhandled construct in 'MakeBoolean' P1

      if v.dataType == eEpEvtChoiceGetNewType.item and ConfigData:GetItemType(v.dataId) == ConfigData:GetItemType(v.dataId) then
        displayNewData = {}
        displayNewData.type = v.dataType
        displayNewData.dataId = v.dataId
        displayNewData.dataNum = v.dataNum
        return displayNewData
      end
      if v.dataType == eEpEvtChoiceGetNewType.expBuff then
        local buffCfg = (ConfigData.exploration_buff)[v.dataId]
        if buffCfg == nil then
          error("找不到对应的探索buff配置,id:" .. v.dataId)
        end
        if buffCfg.is_onboard then
          displayNewData = {}
          displayNewData.type = v.dataType
          displayNewData.dataId = v.dataId
          return displayNewData
        end
      end
    end
  end
  do
    return displayNewData
  end
end

return DynEpEntChoiceData

