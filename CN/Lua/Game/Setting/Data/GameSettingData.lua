-- params : ...
-- function num : 0 , upvalues : _ENV
local GameSettingData = class("GameSettingData")
GameSettingData.ctor = function(self)
  -- function num : 0_0
end

GameSettingData.InitGameSettingData = function(self, clientRecord)
  -- function num : 0_1
  if clientRecord == nil then
    self:_InitDescribes({})
    self:_InitSetting({})
    self:_InitNewTitleItems({})
    return 
  end
  self:_InitDescribes(clientRecord.describes)
  self:_InitSetting(clientRecord.setting)
  self:_InitNewTitleItems(clientRecord.newTitleItems)
end

GameSettingData._InitDescribes = function(self, describes)
  -- function num : 0_2 , upvalues : _ENV
  self.describes = describes
  if (table.IsEmptyTable)(describes) then
    local oldDescribes = (PersistentManager:GetDataModel((PersistentConfig.ePackage).SystemData)):GetDescribeSettingOld()
    if oldDescribes ~= nil and not (table.IsEmptyTable)(oldDescribes) then
      for k,v in ipairs(oldDescribes) do
        describes[k] = v
      end
      return 
    end
    for index,id in pairs(((ConfigData.game_set_group)[eGameSetType.detail]).order) do
      local cfg = (ConfigData.game_set_describe)[id]
      describes[index] = cfg.defalt_detail ~= 0
    end
  end
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

GameSettingData._InitSetting = function(self, setting)
  -- function num : 0_3
  if not setting then
    self.setting = {}
  end
end

GameSettingData._InitNewTitleItems = function(self, newTitleItems)
  -- function num : 0_4 , upvalues : _ENV
  self.newTitleItemDic = {}
  for i,v in pairs(newTitleItems) do
    -- DECOMPILER ERROR at PC7: Confused about usage of register: R7 in 'UnsetPending'

    (self.newTitleItemDic)[v] = true
  end
end

GameSettingData.GetNewTitleItemDic = function(self)
  -- function num : 0_5
  return self.newTitleItemDic
end

GameSettingData.SetNewTitleItemDicEmpty = function(self)
  -- function num : 0_6
  self.newTitleItemDic = {}
end

GameSettingData.GetNewTitleItemNum = function(self)
  -- function num : 0_7 , upvalues : _ENV
  return (table.count)(self.newTitleItemDic)
end

GameSettingData.TryAddTitleItem = function(self, itemData)
  -- function num : 0_8 , upvalues : _ENV
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R2 in 'UnsetPending'

  if itemData.type == eItemType.Title or itemData.type == eItemType.TitleBackground then
    (self.newTitleItemDic)[itemData.dataId] = true
    local ok, newTitleNode = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.Title)
    if ok then
      newTitleNode:SetRedDotCount(1)
    end
  end
end

GameSettingData.GetGSIsShowDetailDescribeValue = function(self, eDescTypeId)
  -- function num : 0_9
  local bool = self:GetGSIsShowDetailDescribe(eDescTypeId)
  return bool and 1 or 0
end

GameSettingData.GetGSIsShowDetailDescribe = function(self, eDescTypeId)
  -- function num : 0_10
  if self.describes == nil then
    return true
  end
  return (self.describes)[eDescTypeId]
end

GameSettingData.GetSetting = function(self)
  -- function num : 0_11
  return self.setting
end

GameSettingData.SetGSDescribe = function(self, eDescTypeId, bool)
  -- function num : 0_12 , upvalues : _ENV
  local val = (self.describes)[eDescTypeId]
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R4 in 'UnsetPending'

  if val ~= bool then
    (self.describes)[eDescTypeId] = bool
    MsgCenter:Broadcast(eMsgEventId.DescribeSettingChange, eDescTypeId)
    self._isDirty = true
  end
end

GameSettingData.SetGSSetting = function(self, eSettingTypeId, bool)
  -- function num : 0_13 , upvalues : _ENV
  local val = (self.setting)[eSettingTypeId]
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R4 in 'UnsetPending'

  if val ~= bool then
    (self.setting)[eSettingTypeId] = bool
    MsgCenter:Broadcast(eMsgEventId.SettingSettingChange, eSettingTypeId)
    self._isDirty = true
  end
end

GameSettingData.IsGSDataDirty = function(self)
  -- function num : 0_14
  self.newTitleRead = 0
  return self._isDirty, self
end

GameSettingData.ClearGSDataDirty = function(self)
  -- function num : 0_15
  self._isDirty = nil
end

return GameSettingData

