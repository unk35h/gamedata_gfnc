-- params : ...
-- function num : 0 , upvalues : _ENV
local DungeonLevelBase = require("Game.DungeonCenter.Data.DungeonLevelBase")
local ADCDungeonLevelData = class("ADCDungeonLevelData", DungeonLevelBase)
local DungeonLevelEnum = require("Game.DungeonCenter.DungeonLevelEnum")
local cs_MessageCommon = CS.MessageCommon
ADCDungeonLevelData.SetDungeonADCData = function(self, adcData)
  -- function num : 0_0
  self._adcData = adcData
  self._adcDungeonCfg = ((self._adcData):GetADCDungeonCfg())[self:GetDungeonLevelStageId()]
end

ADCDungeonLevelData.GetDungeonLevelType = function(self)
  -- function num : 0_1 , upvalues : DungeonLevelEnum
  return (DungeonLevelEnum.DunLevelType).ADC
end

ADCDungeonLevelData.GetDungeonInfoDesc = function(self)
  -- function num : 0_2 , upvalues : _ENV
  return (LanguageUtil.GetLocaleText)((self._adcDungeonCfg).dungeon_desc)
end

ADCDungeonLevelData.GetDungeonLevelPic = function(self)
  -- function num : 0_3
  return (self._adcDungeonCfg).dungeon_pic
end

ADCDungeonLevelData.DealDungeonResult = function(self, msg)
  -- function num : 0_4
  local adcScore = msg.activityDailyChallengeDungeonScore
  local dungeonId = adcScore[1]
  if dungeonId == nil then
    return 
  end
  local score = adcScore[2] or 0
  if (self._adcData):GetADCDungeonPoint(dungeonId) < score or score == 0 then
    (self._adcData):SetADCDunegonPoint(dungeonId, score)
  end
end

ADCDungeonLevelData.GetLevelResourceGroup = function(self)
  -- function num : 0_5
  return ((self._adcData):GetADCMainCfg()).unlock_item
end

ADCDungeonLevelData.GetDungeonADCData = function(self)
  -- function num : 0_6
  return self._adcData
end

ADCDungeonLevelData.GetDungeonADCScore = function(self)
  -- function num : 0_7
  return (self._adcData):GetADCDungeonPoint(self:GetDungeonLevelStageId())
end

ADCDungeonLevelData.GetDungeonADCRankId = function(self)
  -- function num : 0_8
  return (self._adcDungeonCfg).ranklist_id
end

ADCDungeonLevelData.IsADCDungeonLevelUnlock = function(self)
  -- function num : 0_9
  return (self._adcData):IsADCDungeonUnlock(self:GetDungeonLevelStageId())
end

ADCDungeonLevelData.GetADCDunUnlockItemAndCount = function(self)
  -- function num : 0_10
  return ((self._adcData):GetADCMainCfg()).unlock_item, (self._adcDungeonCfg).unlock_item
end

ADCDungeonLevelData.ReqADCDunUnlock = function(self, callback)
  -- function num : 0_11 , upvalues : cs_MessageCommon, _ENV
  if self:IsADCDungeonLevelUnlock() then
    return 
  end
  local itemId, itemCount = self:GetADCDunUnlockItemAndCount()
  if (self._adcData):GetADCKeyItemCount() < itemCount then
    (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(8414))
    return 
  end
  local itemName = ConfigData:GetItemName(itemId)
  local dungeonName = self:GetDungeonLevelName()
  local tips = (string.format)(ConfigData:GetTipContent(8413), tostring(itemCount), itemName, dungeonName)
  ;
  (cs_MessageCommon.ShowMessageBox)(tips, function()
    -- function num : 0_11_0 , upvalues : self, callback
    (self._adcData):ReqADCUnlockDungeon(self:GetDungeonLevelStageId(), callback)
  end
, nil)
end

return ADCDungeonLevelData

