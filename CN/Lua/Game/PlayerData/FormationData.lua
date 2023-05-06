-- params : ...
-- function num : 0 , upvalues : _ENV
local FormationData = class("FormationData")
local CommanderSkillTreeData = require("Game.CommanderSkill.CommanderSkillTreeData")
FormationData.ctor = function(self)
  -- function num : 0_0
end

FormationData.FromUserData = function(userFormation)
  -- function num : 0_1 , upvalues : FormationData
  local formation = (FormationData.New)()
  formation.id = userFormation.id
  formation.data = userFormation.data
  formation.name = userFormation.name
  formation.cstId = userFormation.tree
  return formation
end

FormationData.FromCustomData = function(id, data, cstId, csList)
  -- function num : 0_2 , upvalues : FormationData, CommanderSkillTreeData
  local formation = (FormationData.New)()
  formation.id = id
  formation.data = data
  formation.name = nil
  formation.userSkill = csList
  formation.customCstData = (CommanderSkillTreeData.New)(cstId)
  ;
  (formation.customCstData):ApplySavingData(csList)
  return formation
end

FormationData.CreateDefault = function(id)
  -- function num : 0_3 , upvalues : _ENV, FormationData
  local fmtHeroCount = ConfigData:GetFormationHeroCount()
  local data = {}
  for k,v in ipairs((ConfigData.game_config).first_formation) do
    if fmtHeroCount >= k then
      do
        (table.insert)(data, v)
        -- DECOMPILER ERROR at PC17: LeaveBlock: unexpected jumping out IF_THEN_STMT

        -- DECOMPILER ERROR at PC17: LeaveBlock: unexpected jumping out IF_STMT

      end
    end
  end
  local formation = (FormationData.New)()
  formation.id = id
  formation.data = data
  local isCSUnlock = FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_commander_skill)
  if isCSUnlock then
    formation:__CreateDefaultCSTByFormation()
  end
  return formation
end

FormationData.Create = function(id)
  -- function num : 0_4 , upvalues : FormationData, _ENV
  local formation = (FormationData.New)()
  formation.id = id
  formation.data = {}
  local isCSUnlock = FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_commander_skill)
  if isCSUnlock then
    formation:__CreateDefaultCSTByFormation()
  end
  return formation
end

FormationData.CreateDefultCST = function(formId)
  -- function num : 0_5 , upvalues : _ENV
  local formation = (PlayerDataCenter.formationDic)[formId]
  formation:__CreateDefaultCSTByFormation()
end

FormationData.SetCustomCstData = function(self, customCstData)
  -- function num : 0_6
  self.customCstData = customCstData
end

FormationData.GetCustomCstData = function(self)
  -- function num : 0_7
  return self.customCstData
end

FormationData.CopyCST = function(self, otherFmtData)
  -- function num : 0_8 , upvalues : _ENV
  if otherFmtData.customCstData ~= nil then
    self.userSkill = (table.deepCopy)(otherFmtData.userSkill)
    self.customCstData = (table.deepCopy)(otherFmtData.customCstData)
  else
    self.cstId = otherFmtData.cstId
  end
end

FormationData.IsIllegalCST = function(self, change2Default)
  -- function num : 0_9 , upvalues : _ENV
  local isUnlock = FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_commander_skill)
  if not isUnlock then
    return false
  end
  local illMark = false
  if not self.customCstData then
    local cstData = (PlayerDataCenter.cstDataDic)[self.cstId]
  end
  if self.cstId == nil or self.cstId == 0 or cstData == nil or cstData.treeCfg == nil then
    illMark = true
  end
  if not illMark then
    local skills = cstData:GetUsingCmdSkillList()
    for _,skillId in ipairs(skills) do
      local cmdSkillData = (cstData.commanderSkillDataDic)[skillId]
      if cmdSkillData == nil or not cmdSkillData:IsCmdSkillUnlock() then
        illMark = true
        break
      end
    end
  end
  do
    if not illMark then
      local skillSlots = cstData.slotSkillList
      for slot,skillId in ipairs(skillSlots) do
        if skillId == 0 then
          local defaultSkillId = ((cstData.slotSkillOverloadList)[slot])[1]
          if defaultSkillId ~= nil and ((cstData.commanderSkillDataDic)[defaultSkillId]):IsCmdSkillUnlock() then
            illMark = true
            break
          end
        end
      end
    end
    do
      if not illMark then
        return false
      end
      if change2Default then
        if cstData == nil or cstData.treeCfg == nil then
          self:__CreateDefaultCSTByFormation()
        else
          local fixSkills = {}
          local skillSlots = cstData.slotSkillList
          for slot,skillId in ipairs(skillSlots) do
            skillId = skillId ~= 0 or ((cstData.slotSkillOverloadList)[slot])[1] or 0
            local cmdSkillData = (cstData.commanderSkillDataDic)[skillId]
            if cmdSkillData ~= nil and cmdSkillData:IsCmdSkillUnlock() then
              (table.insert)(fixSkills, skillId)
            end
          end
          cstData:ApplySavingData(fixSkills)
        end
      end
      do
        return true
      end
    end
  end
end

FormationData.__CreateDefaultCSTByFormation = function(self)
  -- function num : 0_10 , upvalues : _ENV, CommanderSkillTreeData
  local defaultTreeId = (ConfigData.game_config).FormationDefaultCommanderSkillTree
  self.cstId = defaultTreeId
  local cstData = (PlayerDataCenter.cstDataDic)[defaultTreeId]
  if cstData == nil then
    cstData = (CommanderSkillTreeData.New)(defaultTreeId)
    -- DECOMPILER ERROR at PC15: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (PlayerDataCenter.cstDataDic)[defaultTreeId] = cstData
  end
  local skills = cstData:GetUsingCmdSkillList()
  ;
  (NetworkManager:GetNetwork(NetworkTypeID.CommanderSkill)):CS_COMMANDSKILL_SaveFromFormation(self.id, defaultTreeId, skills)
end

FormationData.GetFmtCSTData = function(self)
  -- function num : 0_11 , upvalues : _ENV
  if self.customCstData ~= nil then
    return self.customCstData
  end
  local cstData = (PlayerDataCenter.cstDataDic)[self.cstId]
  do
    if cstData == nil then
      local defaultTreeId = (ConfigData.game_config).FormationDefaultCommanderSkillTree
      if (PlayerDataCenter.cstDataDic)[defaultTreeId] == nil then
        self:__CreateDefaultCSTByFormation()
      end
      cstData = (PlayerDataCenter.cstDataDic)[defaultTreeId]
    end
    return cstData
  end
end

FormationData.ModifyCSTData = function(self, cstTreeData)
  -- function num : 0_12 , upvalues : _ENV
  if cstTreeData == nil then
    self.cstId = nil
    return 
  end
  PlayerDataCenter:UpdCstData(cstTreeData.id, cstTreeData.skills)
  self.cstId = cstTreeData.id
end

FormationData.ModifyFormationData = function(self, formationData, newHeroDic)
  -- function num : 0_13 , upvalues : _ENV
  if formationData ~= nil then
    self:CleanFormation()
    for index,heroId in pairs(formationData:GetFormationHeroDic(true)) do
      self:SetHero2Formation(index, heroId)
    end
    self.isHaveSupport = formationData.isHaveSupport
    self.suooprtHeroData = formationData.suooprtHeroData
    self.__suooprtHeroData = formationData.__suooprtHeroData
    self.isHaveOfficialSupport = formationData.isHaveOfficialSupport
    self.officialSuppotDic = formationData.officialSuppotDic
  else
    if newHeroDic ~= nil then
      self:CleanFormation()
      for index,heroId in pairs(newHeroDic) do
        self:SetHero2Formation(index, heroId)
      end
    end
  end
end

FormationData.SetHero2Formation = function(self, index, heroId)
  -- function num : 0_14
  self:ClearFormationIdx(index)
  -- DECOMPILER ERROR at PC4: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.data)[index] = heroId
end

FormationData.ClearFormationIdx = function(self, index)
  -- function num : 0_15 , upvalues : _ENV
  if self.isHaveSupport and (self.suooprtHeroData).formIdx == index then
    self:CleanSupportData()
  end
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R2 in 'UnsetPending'

  if self.isHaveOfficialSupport and (self.officialSuppotDic)[index] ~= nil then
    (self.officialSuppotDic)[index] = nil
    if (table.IsEmptyTable)(self.officialSuppotDic) then
      self:CleanOfficialSupportData()
    end
  end
  -- DECOMPILER ERROR at PC27: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (self.data)[index] = nil
end

FormationData.Exchange2Hero = function(self, index1, index2)
  -- function num : 0_16
  local exchangeNN = function(index1, index2)
    -- function num : 0_16_0 , upvalues : self
    -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

    -- DECOMPILER ERROR at PC7: Confused about usage of register: R2 in 'UnsetPending'

    (self.data)[index2] = (self.data)[index1]
  end

  local exchangeSN = function(supportIndex, normalIndex)
    -- function num : 0_16_1 , upvalues : self
    -- DECOMPILER ERROR at PC3: Confused about usage of register: R2 in 'UnsetPending'

    (self.data)[supportIndex] = (self.data)[normalIndex]
    -- DECOMPILER ERROR at PC5: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (self.data)[normalIndex] = nil
    -- DECOMPILER ERROR at PC7: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (self.suooprtHeroData).formIdx = normalIndex
  end

  local exchangeNO = function(officialIndex, normalIndex)
    -- function num : 0_16_2 , upvalues : self
    -- DECOMPILER ERROR at PC3: Confused about usage of register: R2 in 'UnsetPending'

    (self.data)[officialIndex] = (self.data)[normalIndex]
    -- DECOMPILER ERROR at PC5: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (self.data)[normalIndex] = nil
    -- DECOMPILER ERROR at PC9: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (self.officialSuppotDic)[normalIndex] = (self.officialSuppotDic)[officialIndex]
    -- DECOMPILER ERROR at PC11: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (self.officialSuppotDic)[officialIndex] = nil
  end

  local exchangeSO = function(supportIndex, officialIndex)
    -- function num : 0_16_3 , upvalues : self
    -- DECOMPILER ERROR at PC3: Confused about usage of register: R2 in 'UnsetPending'

    (self.officialSuppotDic)[supportIndex] = (self.officialSuppotDic)[officialIndex]
    -- DECOMPILER ERROR at PC5: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (self.officialSuppotDic)[officialIndex] = nil
    -- DECOMPILER ERROR at PC7: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (self.suooprtHeroData).formIdx = officialIndex
  end

  local exchangeOO = function(index1, index2)
    -- function num : 0_16_4 , upvalues : self
    -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

    -- DECOMPILER ERROR at PC7: Confused about usage of register: R2 in 'UnsetPending'

    (self.officialSuppotDic)[index2] = (self.officialSuppotDic)[index1]
  end

  if self.isHaveSupport then
    if (self.suooprtHeroData).formIdx == index1 then
      if (self.data)[index2] ~= nil then
        exchangeSN(index1, index2)
      else
        if self.isHaveOfficialSupport and (self.officialSuppotDic)[index2] ~= nil then
          exchangeSO(index1, index2)
        else
          exchangeSN(index1, index2)
        end
      end
      return 
    end
    if (self.suooprtHeroData).formIdx == index2 then
      if (self.data)[index1] ~= nil then
        exchangeSN(index2, index1)
      else
        if self.isHaveOfficialSupport and (self.officialSuppotDic)[index1] ~= nil then
          exchangeSO(index2, index1)
        else
          exchangeSN(index2, index1)
        end
      end
      return 
    end
  end
  if self.isHaveOfficialSupport then
    if (self.officialSuppotDic)[index1] ~= nil and (self.officialSuppotDic)[index2] then
      exchangeOO(index1, index2)
      return 
    else
      if (self.officialSuppotDic)[index1] ~= nil then
        exchangeNO(index1, index2)
        return 
      end
      if (self.officialSuppotDic)[index2] ~= nil then
        exchangeNO(index2, index1)
        return 
      end
    end
  end
  exchangeNN(index1, index2)
end

FormationData.CleanFormation = function(self)
  -- function num : 0_17
  self:CleanSupportData()
  self:CleanOfficialSupportData()
  self.data = {}
end

FormationData.GetFormationHeroDic = function(self, isNotNeedExtra)
  -- function num : 0_18 , upvalues : _ENV
  do
    if self._fixedHeroIdList ~= nil and not isNotNeedExtra then
      local data = {}
      for key,value in pairs(self._fixedHeroIdList) do
        data[key] = value
      end
      for key,value in pairs(self.data) do
        data[key] = value
      end
      return data
    end
    if not isNotNeedExtra then
      local data = {}
      for key,value in pairs(self.data) do
        data[key] = value
      end
      data = self:_GetExcludeHeroList(data)
      if self.isHaveSupport then
        data[(self.suooprtHeroData).formIdx] = (self.suooprtHeroData).heroId
      end
      if self.isHaveOfficialSupport then
        for formIdx,officialSuppotData in pairs(self.officialSuppotDic) do
          data[formIdx] = officialSuppotData.heroId
        end
      end
      do
        do
          do return data end
          return self:_GetExcludeHeroList(self.data)
        end
      end
    end
  end
end

FormationData._GetExcludeHeroList = function(self, heroIdxDic)
  -- function num : 0_19 , upvalues : _ENV
  if self._excludeHeroIdDic == nil then
    return heroIdxDic
  end
  local data = {}
  for idx,heroId in pairs(heroIdxDic) do
    if (self._excludeHeroIdDic)[heroId] == nil then
      data[idx] = heroId
    end
  end
  return data
end

FormationData.GetFormationHeroData = function(self, index)
  -- function num : 0_20 , upvalues : _ENV
  local heroId = nil
  if self.isHaveSupport and (self.suooprtHeroData).formIdx == index then
    return self.__suooprtHeroData
  else
    if self.isHaveOfficialSupport and (self.officialSuppotDic)[index] ~= nil then
      return ((self.officialSuppotDic)[index]).o_heroData
    else
      heroId = (self.data)[index]
    end
  end
  if heroId == nil then
    if self._fixedHeroList ~= nil then
      return (self._fixedHeroList)[index]
    end
    return nil
  end
  if self._excludeHeroIdDic ~= nil and (self._excludeHeroIdDic)[heroId] ~= nil then
    return nil
  end
  if self.specialRuleGenerator ~= nil then
    return (self.specialRuleGenerator):GetSpecificHeroData(heroId, self.specificHeroDataRuler)
  end
  return PlayerDataCenter:GetHeroData(heroId)
end

FormationData.SetSupportHeroData = function(self, suooprtHeroData, index, useLast)
  -- function num : 0_21
  self:ClearFormationIdx(index)
  if self.suooprtHeroData == nil then
    self.suooprtHeroData = {}
  end
  self.isHaveSupport = true
  self.__suooprtHeroData = suooprtHeroData
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self.suooprtHeroData).formIdx = index
  -- DECOMPILER ERROR at PC19: Confused about usage of register: R4 in 'UnsetPending'

  if not useLast then
    (self.suooprtHeroData).uid = (suooprtHeroData:GetUserInfo()):GetUserUID()
  end
  -- DECOMPILER ERROR at PC22: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self.suooprtHeroData).heroId = suooprtHeroData.dataId
end

FormationData.GetSupportHeroData = function(self)
  -- function num : 0_22
  if self.isHaveSupport then
    return self.suooprtHeroData
  end
end

FormationData.GetRealSupportHeroData = function(self)
  -- function num : 0_23
  if self.isHaveSupport then
    return self.__suooprtHeroData
  end
end

FormationData.CleanSupportData = function(self)
  -- function num : 0_24
  self.isHaveSupport = false
  self.__suooprtHeroData = nil
  self.suooprtHeroData = nil
end

FormationData.SetOfficialSupportHeroData = function(self, officialSuppotData, index)
  -- function num : 0_25
  self:ClearFormationIdx(index)
  if self.officialSuppotDic == nil then
    self.officialSuppotDic = {}
  end
  self.isHaveOfficialSupport = true
  local officialSupportCfgId = officialSuppotData:GetOfficialSupportCfgId()
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self.officialSuppotDic)[index] = {o_heroData = officialSuppotData, heroId = officialSuppotData.dataId, cfgId = officialSupportCfgId}
end

FormationData.CleanOfficialSupportData = function(self)
  -- function num : 0_26
  self.isHaveOfficialSupport = false
  self.officialSuppotDic = nil
end

FormationData.GetIsHaveOfficialSupport = function(self)
  -- function num : 0_27
  return self.isHaveOfficialSupport
end

FormationData.GetIsHaveOfficialSupportDic = function(self)
  -- function num : 0_28
  return self.officialSuppotDic
end

FormationData.GetFmtOfficeAssistData = function(self)
  -- function num : 0_29 , upvalues : _ENV
  if not self:GetIsHaveOfficialSupport() then
    return 
  end
  local teamId = nil
  local assistElem = {}
  local dic = self:GetIsHaveOfficialSupportDic()
  for fmtIdx,officialSuppotData in pairs(dic) do
    if teamId == nil then
      teamId = officialSuppotData.cfgId
    else
      if teamId ~= officialSuppotData.cfgId then
        error("offical support team id not same, pls check")
      end
    end
    ;
    (table.insert)(assistElem, {heroId = officialSuppotData.heroId, formIdx = fmtIdx})
  end
  return {teamId = teamId, assistElem = assistElem}
end

FormationData.GetCstSkillList = function(self)
  -- function num : 0_30 , upvalues : _ENV
  if not (PlayerDataCenter.cstDataDic)[self.cstId] then
    return table.emptytable
  end
end

FormationData.GetIsOnlyHaveSupportHero = function(self)
  -- function num : 0_31 , upvalues : _ENV
  if not self.isHaveSupport then
    return false
  end
  local count = 0
  for _,_ in pairs(self:GetFormationHeroDic()) do
    count = count + 1
    if count >= 2 then
      return false
    end
  end
  return true
end

FormationData.SetFmtFixedHeroList = function(self, heroList, heroIdList)
  -- function num : 0_32
  self._fixedHeroList = heroList
  self._fixedHeroIdList = heroIdList
end

FormationData.ClearFmtFixedHero = function(self)
  -- function num : 0_33
  self._fixedHeroList = nil
  self._fixedHeroIdList = nil
end

FormationData.SetFmtExcludeHeroIdDic = function(self, excludeHeroIdDic)
  -- function num : 0_34
  self._excludeHeroIdDic = excludeHeroIdDic
end

FormationData.ClearFmtExcludeHeroIdDic = function(self)
  -- function num : 0_35
  self._excludeHeroIdDic = nil
end

FormationData.DeepCopyFmtData = function(self)
  -- function num : 0_36 , upvalues : _ENV
  local fntData = DeepCopy(self)
  fntData.__suooprtHeroData = self.__suooprtHeroData
  return fntData
end

return FormationData

