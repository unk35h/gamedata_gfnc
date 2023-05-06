-- params : ...
-- function num : 0 , upvalues : _ENV
local HeroData = class("HeroData")
local HeroSkillData = require("Game.PlayerData.Skill.HeroSkillData")
local attrIdOffset = (ConfigData.buildinConfig).AttrIdOffset
HeroData.ctor = function(self, data)
  -- function num : 0_0 , upvalues : _ENV, HeroSkillData
  local baseData = data.basic
  self.dataId = baseData.id
  self.level = baseData.level
  self.curExp = baseData.exp
  self.ts = baseData.ts
  self.potential = baseData.potentialLvl or 0
  self.archive = baseData.archive
  self.audio = baseData.audioEx
  self.cat = baseData.cat
  self.questRecord = baseData.questRecord
  self.modelSpecSign = baseData.serverModel and (ResConsts.ModelSignType).GrayMode or 0
  local heroCfg = (ConfigData.hero_data)[self.dataId]
  if heroCfg == nil then
    error("hero cfg is null,id:" .. tostring(self.dataId))
    return 
  end
  self.heroCfg = heroCfg
  self.camp = heroCfg.camp
  self.career = heroCfg.career
  self.rank = baseData.star
  self:UpdateHeroRank(self.rank)
  data.__notHaveLegalSkin = false
  self:UpdateSkin(baseData.skinId)
  self:__UpdateBaseArriDic()
  self.skillDic = {}
  self.skillList = {}
  for k,skillId in ipairs(heroCfg.skill_list) do
    local skillData = (HeroSkillData.New)(skillId, self)
    -- DECOMPILER ERROR at PC75: Confused about usage of register: R10 in 'UnsetPending'

    ;
    (self.skillDic)[skillId] = skillData
    ;
    (table.insert)(self.skillList, skillData)
  end
  ;
  (table.sort)(self.skillList, function(skillData1, skillData2)
    -- function num : 0_0_0
    local isCommonAttack1 = skillData1:IsCommonAttack()
    local isCommonAttack2 = skillData2:IsCommonAttack()
    local isPassive1 = skillData1:IsPassiveSkill()
    local isPassive2 = skillData2:IsPassiveSkill()
    local isUskill1 = skillData2:IsUniqueSkill()
    local isUskill2 = skillData2:IsUniqueSkill()
    if isPassive1 == isPassive2 then
      if isUskill1 == isUskill2 then
        if skillData1.type == skillData2.type then
          if skillData1.dataId >= skillData2.dataId then
            do return isCommonAttack1 ~= isCommonAttack2 end
            do return skillData1.type < skillData2.type end
            do return not isUskill1 end
            do return isPassive1 end
            do return isCommonAttack1 end
            -- DECOMPILER ERROR: 7 unprocessed JMP targets
          end
        end
      end
    end
  end
)
  self.fragId = heroCfg.fragment
  self.__isFavouriteHero = baseData.subscribeDungeon
  if data.spWeapon ~= nil then
    for i,spWeapon in ipairs(data.spWeapon) do
      (PlayerDataCenter.allSpecWeaponData):CreateOrUpdateHeroWeapon(self, spWeapon.id, spWeapon.step, spWeapon.level)
    end
  end
  do
    self:ReplaceHeroSkill()
    if data.skill ~= nil then
      for skillId,skillLevel in pairs((data.skill).data) do
        local skillData = (self.skillDic)[skillId]
        if skillData ~= nil then
          skillData:UpdateSkill(skillLevel)
        end
      end
    end
  end
end

HeroData.UpdateHeroData = function(self, data)
  -- function num : 0_1 , upvalues : _ENV
  local baseData = data.basic
  if baseData.level == self.level and self.rank == baseData.star and self.potential == baseData.potentialLvl then
    local attrChange = baseData == nil
    self.level = baseData.level
    if not baseData.exp then
      self.curExp = self.curExp
      if not baseData.star then
        self.rank = self.rank
        self:UpdateHeroRank(self.rank)
        if not baseData.ts then
          self.ts = self.ts
          self.potential = baseData.potentialLvl or 0
          if not baseData.archive then
            self.archive = self.archive
            if not baseData.audioEx then
              do
                self.audio = self.audio
                self.questRecord = baseData.questRecord
                if baseData.skinId ~= nil then
                  self:UpdateSkin(baseData.skinId)
                end
                if attrChange then
                  self:__UpdateBaseArriDic()
                end
                self.__isFavouriteHero = baseData.subscribeDungeon
                if data.spWeapon ~= nil then
                  for i,spWeapon in ipairs(data.spWeapon) do
                    (PlayerDataCenter.allSpecWeaponData):CreateOrUpdateHeroWeapon(self, spWeapon.id, spWeapon.step, spWeapon.level)
                  end
                end
                self:ReplaceHeroSkill()
                if data.skill ~= nil then
                  for skillId,skillLevel in pairs((data.skill).data) do
                    local skillData = (self.skillDic)[skillId]
                    if skillData ~= nil then
                      skillData:UpdateSkill(skillLevel)
                    end
                  end
                end
                -- DECOMPILER ERROR: 14 unprocessed JMP targets
              end
            end
          end
        end
      end
    end
  end
end

HeroData.UpdateSkin = function(self, skinId)
  -- function num : 0_2 , upvalues : _ENV
  if skinId == nil then
    skinId = (self.heroCfg).default_skin
    self.__notHaveLegalSkin = true
  else
    if skinId == 1 or skinId == 0 then
      skinId = (self.heroCfg).default_skin
    end
  end
  self.skinId = skinId
  local skinCtr = ControllerManager:GetController(ControllerTypeId.Skin, true)
  self.resCfg = skinCtr:GetResModel(self.dataId, self.skinId)
end

HeroData.GetHeroIsNotHaveLegalSkin = function(self)
  -- function num : 0_3
  return self.__notHaveLegalSkin
end

HeroData.GetAttr = function(self, attrId, withoutAth, dontWarning, onlyBaseAttr)
  -- function num : 0_4 , upvalues : _ENV
  local athHeroId = self.dataId
  if withoutAth then
    athHeroId = nil
  end
  if self.isRemoveAllBounce then
    dontWarning = true
    athHeroId = nil
  end
  local atrValue = 0
  atrValue = self:__CalBaseAttr(attrId, withoutAth, athHeroId)
  if onlyBaseAttr then
    return atrValue
  end
  atrValue = self:__CalRatioAttr(atrValue, attrId, withoutAth, athHeroId)
  atrValue = self:__CalExtraAttr(atrValue, attrId, withoutAth, athHeroId)
  if isGameDev and not dontWarning and not withoutAth then
    (PlayerDataCenter.heroAttrChecker):DirtyPlayerHeroAttri(self.dataId, attrId, atrValue)
  end
  return atrValue
end

HeroData.__CalBaseAttr = function(self, attrId, withoutAth, athHeroId)
  -- function num : 0_5 , upvalues : attrIdOffset, _ENV
  local baseAttrId = attrId + attrIdOffset
  local atrValue = (self.baseAttrDic)[attrId]
  if self._talentData ~= nil then
    atrValue = atrValue + (self._talentData):GetAttributeAddtion(baseAttrId)
  end
  if self._specWeaponDic ~= nil then
    for k,v in pairs(self._specWeaponDic) do
      atrValue = atrValue + v:GetSpecWeaponAttriAddtionById(baseAttrId)
    end
  end
  do
    return (PlayerDataCenter.attributeBonus):AtrBonusAdd(self.isRemoveAllBounce, atrValue, attrId, baseAttrId, self.camp, self.career, athHeroId)
  end
end

HeroData.__CalRatioAttr = function(self, atrValue, attrId, withoutAth, athHeroId, extrValue, onlyExtraValue)
  -- function num : 0_6 , upvalues : attrIdOffset, _ENV
  local ratioAttrId = attrId + attrIdOffset * 2
  local heroStarExtraValue = ((self.heroStarCfg).atrExtraDic)[ratioAttrId] or 0
  do
    if not ((self.potentialCfg).extra)[ratioAttrId] then
      local temp = self.potentialCfg == nil or ((self.potentialCfg).extra)[ratioAttrId] == nil or 0
    end
    heroStarExtraValue = heroStarExtraValue + temp
    if self._talentData ~= nil then
      heroStarExtraValue = heroStarExtraValue + (self._talentData):GetAttributeAddtion(ratioAttrId)
    end
    if self._specWeaponDic ~= nil then
      for k,v in pairs(self._specWeaponDic) do
        heroStarExtraValue = heroStarExtraValue + v:GetSpecWeaponAttriAddtionById(ratioAttrId)
      end
    end
    do
      if extrValue ~= nil then
        heroStarExtraValue = heroStarExtraValue + extrValue
      end
      if onlyExtraValue ~= nil then
        heroStarExtraValue = onlyExtraValue
      end
      return (PlayerDataCenter.attributeBonus):AtrBonusAdd(self.isRemoveAllBounce, atrValue, attrId, ratioAttrId, self.camp, self.career, athHeroId, heroStarExtraValue)
    end
  end
end

HeroData.__CalExtraAttr = function(self, atrValue, attrId, withoutAth, athHeroId)
  -- function num : 0_7 , upvalues : _ENV
  local heroStarExtraValue = ((self.heroStarCfg).atrExtraDic)[attrId] or 0
  do
    if not ((self.potentialCfg).extra)[attrId] then
      local temp = self.potentialCfg == nil or ((self.potentialCfg).extra)[attrId] == nil or 0
    end
    heroStarExtraValue = heroStarExtraValue + temp
    if self._talentData ~= nil then
      atrValue = atrValue + (self._talentData):GetAttributeAddtion(attrId)
    end
    if self._specWeaponDic ~= nil then
      for k,v in pairs(self._specWeaponDic) do
        atrValue = atrValue + v:GetSpecWeaponAttriAddtionById(attrId)
      end
    end
    do
      return (PlayerDataCenter.attributeBonus):AtrBonusAdd(self.isRemoveAllBounce, atrValue, attrId, attrId, self.camp, self.career, athHeroId, heroStarExtraValue)
    end
  end
end

HeroData.GetNewLevelAttr = function(self, attrId, newLevel, newRank, newPotential)
  -- function num : 0_8
  self:__UpdateBaseArriDic(newLevel, newRank, newPotential)
  local answer = self:GetAttr(attrId, nil, true)
  self:__UpdateBaseArriDic()
  return answer
end

HeroData.__UpdateBaseArriDic = function(self, newLevel, newRank, newPotential)
  -- function num : 0_9 , upvalues : _ENV, attrIdOffset
  if not newRank then
    local rank = self.rank
  end
  if not newLevel then
    local level = self.level
  end
  if not newPotential then
    local potential = self.potential
  end
  local baseAttrDic = setmetatable({}, {__index = function(tab, key)
    -- function num : 0_9_0
    return 0
  end
})
  self.baseAttrDic = baseAttrDic
  if (ConfigData.hero_star)[self.dataId] == nil or ((ConfigData.hero_star)[self.dataId])[self.rank] == nil then
    error((string.format)("Can\'t get heroStarCfg, heroId = %s,rank = %s", self.dataId, self.rank))
    return 
  end
  local heroStarCfg = ((ConfigData.hero_star)[self.dataId])[rank]
  self.heroStarCfg = heroStarCfg
  local heroLevelCfg = (ConfigData.hero_level)[level]
  if heroLevelCfg == nil then
    error("Can\'t find heroLevelCfg, level = " .. tostring(self.level))
    return 
  end
  for k,v in pairs(heroStarCfg.atrGrowthDic) do
    baseAttrDic[k - 100] = v * heroLevelCfg.level_growth // 1000000 + ((heroStarCfg.atrExtraDic)[k] or 0)
  end
  for k,v in pairs(heroStarCfg.atrBaseDic) do
    local id = k - 100
    baseAttrDic[id] = baseAttrDic[id] + v
  end
  local potentialCfg = ((ConfigData.hero_potential)[self.dataId])[potential]
  self.potentialCfg = potentialCfg
  if potentialCfg ~= nil then
    for k,v in pairs(potentialCfg.atrDic) do
      local id = k - attrIdOffset
      baseAttrDic[id] = baseAttrDic[id] + v
    end
  end
  do
    baseAttrDic[8] = (self.heroCfg).move_spd
    baseAttrDic[16] = (self.heroCfg).range
  end
end

HeroData.GetName = function(self)
  -- function num : 0_10 , upvalues : _ENV
  return (LanguageUtil.GetLocaleText)((self.heroCfg).name)
end

HeroData.GetCurrentUseSkinId = function(self)
  -- function num : 0_11
  return self.skinId
end

HeroData.GetResPicName = function(self, isDefault)
  -- function num : 0_12
  if isDefault then
    return (self.resCfg).res_Name
  end
  if not (self.resCfg).src_id_pic then
    return (self.resCfg).res_Name
  end
end

HeroData.GetResModelName = function(self, isDefault)
  -- function num : 0_13
  if isDefault then
    return (self.resCfg).res_Name
  end
  if not (self.resCfg).src_id_model then
    return (self.resCfg).res_Name
  end
end

HeroData.GetExtendResName = function(self)
  -- function num : 0_14
  return (self.resCfg).extend_res
end

HeroData.GetEnName = function(self)
  -- function num : 0_15 , upvalues : _ENV
  return (LanguageUtil.GetLocaleText)((self.heroCfg).name_en)
end

HeroData.GetHeroTag = function(self)
  -- function num : 0_16
  return (self.heroCfg).tag
end

HeroData.GetHeroDefaultRank = function(self)
  -- function num : 0_17
  return (self.heroCfg).rank
end

HeroData.GetIsCouldMerge = function(self)
  -- function num : 0_18 , upvalues : _ENV
  if self:IsHeroNotMergeable() then
    return false, 0, 0
  end
  local fragId = self.fragId
  local curFrage = PlayerDataCenter:GetItemCount(fragId)
  local mergeCfg = (ConfigData.hero_merge)[self:GetHeroDefaultRank()]
  if mergeCfg == nil then
    error("can\'t get merge cfg for hero:" .. tostring((self.heroData).dataId) .. " defaultRank:" .. tostring((self.heroData):GetHeroDefaultRank()))
    return false, curFrage, "?"
  end
  local mergeNeedFrage = mergeCfg.frag_merge
  local couldMerge = mergeNeedFrage <= curFrage
  do return couldMerge, curFrage, mergeNeedFrage end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

HeroData.IsHeroNotMergeable = function(self)
  -- function num : 0_19
  return (self.heroCfg).not_mergeable
end

HeroData.GetCareerCfg = function(self)
  -- function num : 0_20 , upvalues : _ENV
  local careerCfg = (ConfigData.career)[self.career]
  return careerCfg
end

HeroData.GetCampCfg = function(self)
  -- function num : 0_21 , upvalues : _ENV
  local campCfg = (ConfigData.camp)[self.camp]
  return campCfg
end

HeroData.GetDormMoveSpeed = function(self)
  -- function num : 0_22
  return (self.heroCfg).dorm_move_spd
end

HeroData.GetHeroFragCount = function(self)
  -- function num : 0_23 , upvalues : _ENV
  return PlayerDataCenter:GetItemCount((self.heroCfg).fragment)
end

HeroData.IsFullRank = function(self)
  -- function num : 0_24 , upvalues : _ENV
  do return (ConfigData.hero_rank).maxRank <= self.rank end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

HeroData.UpdateHeroRank = function(self, rank)
  -- function num : 0_25 , upvalues : _ENV
  local rankCfg = (ConfigData.hero_rank)[rank]
  if rankCfg == nil then
    error("Can\'t find rankCfg, id = " .. tostring(rank))
    return 
  end
  self.rankCfg = rankCfg
  self.star = rankCfg.star
  self.rare = rankCfg.rare
end

HeroData.StarNeedFrag = function(self)
  -- function num : 0_26
  if self:IsFullRank() then
    return 0
  end
  return (self.rankCfg).upgrade_star_frag_cost
end

HeroData.StarNeedCurrencyNum = function(self)
  -- function num : 0_27
  if self:IsFullRank() then
    return 0
  end
  local extra_cost = (self.rankCfg).upgrade_star_extra_cost
  if extra_cost[1] ~= nil then
    return (extra_cost[1]).itemId, (extra_cost[1]).num
  end
end

HeroData.StarNeedItemNum = function(self)
  -- function num : 0_28
  if self:IsFullRank() then
    return 0
  end
  local extra_cost = (self.rankCfg).upgrade_star_extra_cost
  if extra_cost[2] ~= nil then
    return (extra_cost[2]).itemId, (extra_cost[2]).num
  end
end

HeroData.AbleUpLevel = function(self)
  -- function num : 0_29 , upvalues : _ENV
  if self:IsFullLevel() or self:IsReachLevelLimit() then
    return false
  end
  do return PlayerDataCenter:GetItemCount(ConstGlobalItem.HeroExp) > 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

HeroData.AbleUpgradeStar = function(self)
  -- function num : 0_30 , upvalues : _ENV
  if self:IsFullRank() then
    return false
  end
  local id, num = nil, nil
  local fitFrag = self:StarNeedFrag() <= self:GetHeroFragCount()
  local fitCurrency, fitItem = nil, nil
  id = self:StarNeedCurrencyNum()
  if num > PlayerDataCenter:GetItemCount(id) then
    fitCurrency = id == nil
    fitCurrency = true
    -- DECOMPILER ERROR at PC34: Overwrote pending register: R2 in 'AssignReg'

    id = self:StarNeedItemNum()
    if num > PlayerDataCenter:GetItemCount(id) then
      fitItem = id == nil
      fitItem = true
      do return not fitFrag or not fitCurrency or fitItem, fitFrag, fitCurrency, fitItem end
      -- DECOMPILER ERROR: 8 unprocessed JMP targets
    end
  end
end

HeroData.IsHalfStar = function(self)
  -- function num : 0_31
  do return self.star % 2 == 1 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

HeroData.AbleUpgrade2FullStar = function(self)
  -- function num : 0_32
  if self:AbleUpgradeStar() then
    return self:IsHalfStar(), true
  end
  return false, false
end

HeroData.GetDifferAttrWhenRankUp = function(self, newRank, newLevel, oldRank, oldLevel, newPotential, oldPotential)
  -- function num : 0_33 , upvalues : _ENV
  local changeList = {}
  for _,attrId in pairs((ConfigData.attribute).baseAttrIds) do
    local oldAttr = nil
    if oldLevel ~= nil or oldRank ~= nil or oldPotential ~= nil then
      oldAttr = self:GetNewLevelAttr(attrId, oldLevel, oldRank, oldPotential)
    else
      oldAttr = self:GetAttr(attrId, nil, true)
    end
    local newAttr = self:GetNewLevelAttr(attrId, newLevel, newRank, newPotential)
    if oldAttr ~= newAttr then
      (table.insert)(changeList, {attrId = attrId, property = ((ConfigData.attribute)[attrId]).attribute_priority, oldAttr = oldAttr, newAttr = newAttr})
    end
  end
  return changeList
end

HeroData.GenHeroCanQuickLevelUp = function(self)
  -- function num : 0_34 , upvalues : _ENV
  if self:IsReachLevelLimit() or self:IsFullLevel() then
    return false
  end
  local remainExp = ((ConfigData.hero_level)[self.level]).exp
  if remainExp <= PlayerDataCenter:GetItemCount(ConstGlobalItem.HeroExp) then
    return true, {[ConstGlobalItem.HeroExp] = remainExp}
  end
  return false
end

HeroData.IsFullLevel = function(self)
  -- function num : 0_35
  do return self:GetHeroMaxLevel() <= self.level end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

HeroData.GetLevelLimit = function(self)
  -- function num : 0_36 , upvalues : _ENV
  return (((ConfigData.hero_potential)[self.dataId])[self.potential]).level_max
end

HeroData.IsReachLevelLimit = function(self)
  -- function num : 0_37
  do return self:GetLevelLimit() <= self.level end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

HeroData.GetExpRatio = function(self)
  -- function num : 0_38
  local totalExp = self:GetLevelTotalExp()
  if totalExp == 0 then
    return 0
  end
  return self.curExp / totalExp
end

HeroData.GetExpByLevel = function(self, level)
  -- function num : 0_39 , upvalues : _ENV
  local levelCfg = (ConfigData.hero_level)[level]
  if levelCfg ~= nil then
    return levelCfg.exp
  end
  return 0
end

HeroData.GetLevelTotalExp = function(self)
  -- function num : 0_40
  return self:GetExpByLevel(self.level)
end

HeroData.GetUpgradeLevelProcess = function(self, oldLevel, oldExp, getExp)
  -- function num : 0_41 , upvalues : _ENV
  local fromlist = {}
  local tolist = {}
  if getExp <= 0 then
    return fromlist, tolist
  end
  getExp = getExp + oldExp
  local heroMaxLevel = self:GetHeroMaxLevel()
  for i = oldLevel, heroMaxLevel - 1 do
    local levelCfg = (ConfigData.hero_level)[i]
    if levelCfg == nil then
      error("hero level cfg is null,id:" .. tostring(i))
      break
    end
    local curLevelTotalExp = levelCfg.exp
    if i == oldLevel then
      (table.insert)(fromlist, oldExp)
    else
      ;
      (table.insert)(fromlist, 0)
    end
    if i == self:GetLevelLimit() then
      (table.insert)(tolist, getExp)
      break
    end
    if getExp < curLevelTotalExp then
      (table.insert)(tolist, getExp)
      break
    else
      if getExp == curLevelTotalExp then
        (table.insert)(tolist, curLevelTotalExp)
        if i < self:GetLevelLimit() then
          (table.insert)(fromlist, 0)
          ;
          (table.insert)(tolist, 0)
        end
        break
      else
        getExp = getExp - curLevelTotalExp
        ;
        (table.insert)(tolist, curLevelTotalExp)
        if i + 1 == heroMaxLevel then
          (table.insert)(fromlist, 0)
          ;
          (table.insert)(tolist, 0)
          break
        end
      end
    end
  end
  do
    return fromlist, tolist
  end
end

HeroData.AddTestExp = function(self, exp)
  -- function num : 0_42 , upvalues : _ENV
  local nextExp = 0
  local nextTotalExp = self:GetLevelTotalExp()
  local overflowExp = 0
  local testExp = exp + self.curExp
  local testLevel = self.level
  local heroMaxLevel = self:GetHeroMaxLevel()
  for i = self.level, heroMaxLevel - 1 do
    local levelCfg = (ConfigData.hero_level)[i]
    if levelCfg == nil then
      error("hero level cfg is null,level:" .. tostring(i))
      return testLevel, nextExp, nextTotalExp, overflowExp
    end
    nextTotalExp = levelCfg.exp
    if testExp >= levelCfg.exp then
      do
        testExp = testExp - levelCfg.exp
        testLevel = i + 1
        -- DECOMPILER ERROR at PC37: LeaveBlock: unexpected jumping out IF_THEN_STMT

        -- DECOMPILER ERROR at PC37: LeaveBlock: unexpected jumping out IF_STMT

      end
    end
  end
  if testLevel == heroMaxLevel then
    nextExp = 0
    overflowExp = testExp
  else
    nextExp = testExp
    overflowExp = 0
  end
  return testLevel, nextExp, nextTotalExp, overflowExp
end

HeroData.GetExp2FullLevel = function(self)
  -- function num : 0_43 , upvalues : _ENV
  if self:IsFullLevel() then
    return 0
  else
    local totalCouldAddExp = -self.curExp
    for i = self.level, self:GetHeroMaxLevel() do
      totalCouldAddExp = totalCouldAddExp + ((ConfigData.hero_level)[i]).exp
    end
    return totalCouldAddExp
  end
end

HeroData.GetExp2LimitLevel = function(self)
  -- function num : 0_44 , upvalues : _ENV
  local total = -self.curExp
  for i = self.level, self:GetLevelLimit() do
    total = total + ((ConfigData.hero_level)[i]).exp
  end
  do
    return total > 0 and total or 0
  end
end

HeroData.GetExpToTargetLevel = function(self, targetLevel)
  -- function num : 0_45 , upvalues : _ENV
  local total = -self.curExp
  for i = self.level, targetLevel do
    total = total + ((ConfigData.hero_level)[i]).exp
  end
  do
    return total > 0 and total or 0
  end
end

HeroData.GetHeroExpAddFromLevel = function(self, fromLevel, fromExp)
  -- function num : 0_46 , upvalues : _ENV
  if fromLevel == self.level then
    return self.curExp - fromExp
  end
  local needExp = 0
  for i = fromLevel, self.level do
    local levelCfg = (ConfigData.hero_level)[i]
    if levelCfg == nil then
      error("hero level cfg is null,level:" .. tostring(i))
      return 0
    end
    if i == fromLevel then
      needExp = needExp + levelCfg.exp - fromExp
    else
      if i == self.level then
        needExp = needExp + self.curExp
      else
        needExp = needExp + levelCfg.exp
      end
    end
  end
  return needExp
end

HeroData.GetHeroAthSuitRecommendDic = function(self)
  -- function num : 0_47
  return (self.heroCfg).recommendSuitDic, (self.heroCfg).recommendAredSuitDic
end

HeroData.GetAthSlotList = function(self, fullSpace, specificRank, specialPotential, specialLevel)
  -- function num : 0_48 , upvalues : _ENV
  local athslotList = {}
  if not specialLevel then
    local level = self.level
  end
  if not specificRank then
    local rank = self.rank
  end
  local athSlotLevel = (PlayerDataCenter.allAthData):GetHeroAthSlotInfo(self.dataId)
  if not specialPotential then
    local potentialLevel = self.potential
  end
  local talentAlgorithmSpaceDic = self._talentData ~= nil and (self._talentData):GetAlgorithmSpace() or nil
  if fullSpace then
    level = self:GetHeroMaxLevel()
    rank = (ConfigData.hero_rank).maxRank
    athSlotLevel = (ConfigData.ath_efficiency).maxLevel
    potentialLevel = self:GetMaxPotential()
    talentAlgorithmSpaceDic = ((ConfigData.hero_talent).maxAlgSpaceDic)[self.dataId]
  end
  local baseSpaceCfg = (self.heroCfg).algorithm_space
  local levelSpaceCfg = ((ConfigData.hero_level)[level]).algorithm_space
  local starSpaceCfg = (((ConfigData.hero_star)[self.dataId])[rank]).algorithm_space
  local athEfccSpaceCfg = ((ConfigData.ath_efficiency)[athSlotLevel]).algorithm_space
  local potentialCfg = (((ConfigData.hero_potential)[self.dataId])[potentialLevel]).algorithm_space
  if #baseSpaceCfg ~= #starSpaceCfg or #baseSpaceCfg ~= #levelSpaceCfg or #baseSpaceCfg ~= #athEfccSpaceCfg then
    error("Hero algorithm_space Config error, heroId = " .. tostring(self.dataId))
    return athslotList
  end
  if (ConfigData.game_config).athSlotCount < #baseSpaceCfg then
    error("Hero algorithm_space Config error, heroId = " .. tostring(self.dataId))
    return athslotList
  end
  for k,v in ipairs(baseSpaceCfg) do
    local space = v + levelSpaceCfg[k] + starSpaceCfg[k] + athEfccSpaceCfg[k] + potentialCfg[k]
    if not talentAlgorithmSpaceDic[k] then
      do
        space = space + (talentAlgorithmSpaceDic == nil or 0)
        athslotList[k] = space
        -- DECOMPILER ERROR at PC119: LeaveBlock: unexpected jumping out IF_THEN_STMT

        -- DECOMPILER ERROR at PC119: LeaveBlock: unexpected jumping out IF_STMT

      end
    end
  end
  return athslotList
end

HeroData.AbleUpgradeSkill = function(self)
  -- function num : 0_49 , upvalues : _ENV
  for _,skillData in ipairs(self.skillList) do
    if not skillData:IsUniqueSkill() and skillData:CanUpgrade() then
      return true
    end
  end
  return false
end

HeroData.AblePotential = function(self)
  -- function num : 0_50 , upvalues : _ENV
  if self:IsFullPotential() then
    return false
  end
  local potentialCfg = ((ConfigData.hero_potential)[self.dataId])[self.potential]
  if potentialCfg == nil then
    return false
  end
  if self.level < potentialCfg.level_max then
    return false
  end
  for k,v in pairs(potentialCfg.cost) do
    local itemData = (PlayerDataCenter.itemDic)[k]
    if itemData == nil or itemData:GetCount() < v then
      return false
    end
  end
  return true
end

HeroData.CanHeroUsePotential = function(self)
  -- function num : 0_51 , upvalues : _ENV
  if not FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_Potential) then
    return false
  end
  if not self:IsReachLevelLimit() then
    return false
  end
  return self:AblePotential()
end

HeroData.IsFullPotential = function(self)
  -- function num : 0_52
  do return self:GetMaxPotential() <= self.potential end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

HeroData.GetHeroPotential = function(self)
  -- function num : 0_53
  return self.potential
end

HeroData.GetMaxPotential = function(self, without6)
  -- function num : 0_54 , upvalues : _ENV
  local potentialMaxNum = nil
  if FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_potential_2_70) and not without6 then
    potentialMaxNum = 6
  else
    potentialMaxNum = 5
  end
  return (math.min)((table.count)((ConfigData.hero_potential)[self.dataId]) - 1, potentialMaxNum)
end

HeroData.IsHeroLongTrailLevel = function(self)
  -- function num : 0_55 , upvalues : _ENV
  do return (ConfigData.buildinConfig).HeroLongTailLevel <= self.level end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

HeroData.GetHeroMaxLevel = function(self)
  -- function num : 0_56 , upvalues : _ENV
  local hero_max_potentialCfg = ((ConfigData.hero_potential)[self.dataId])[self:GetMaxPotential()]
  if hero_max_potentialCfg == nil then
    return (ConfigData.game_config).heroMaxLevel
  end
  return hero_max_potentialCfg.level_max
end

HeroData.GetFormulaAttr = function(self, attrId)
  -- function num : 0_57 , upvalues : _ENV
  if attrId == eHeroAttr.hp then
    local maxHp = self:GetRealAttr(eHeroAttr.maxHp)
    return maxHp
  else
    do
      if attrId == eHeroAttr.attack_range then
        return self.attackRange
      else
        return self:GetAttr(attrId, true)
      end
    end
  end
end

HeroData.GetSkillFightingPower = function(self, heroPower)
  -- function num : 0_58 , upvalues : _ENV
  local fightingPower = 0
  for k,skill in pairs(self.skillDic) do
    local battleCfg = (ConfigData.battle_skill)[skill.dataId]
    if skill.type ~= eHeroSkillType.LifeSkill and skill:GetIsUnlock() and battleCfg ~= nil and battleCfg.skill_comat ~= "" then
      fightingPower = PlayerDataCenter:GetBattleSkillFightPower(skill.dataId, skill.level, heroPower) + fightingPower
    end
  end
  return fightingPower
end

HeroData.GetFightingPower = function(self, attrDic)
  -- function num : 0_59 , upvalues : _ENV
  if attrDic == nil then
    attrDic = self:GetFightHeroAttrDic()
  end
  local heroPower = (ConfigData.GetFormulaValue)(eFormulaType.Hero, attrDic)
  local skillPower = self:GetSkillFightingPower(heroPower)
  local totalPower = heroPower + skillPower
  totalPower = (math.floor)(totalPower)
  if self._talentData ~= nil then
    totalPower = totalPower + (self._talentData):GetHeroTalentFixedComat()
  end
  self.__cachedPower = totalPower
  return totalPower
end

HeroData.TryGetCachedPower = function(self)
  -- function num : 0_60
  if not self.__cachedPower then
    return self:GetFightingPower()
  end
end

HeroData.GetFightHeroAttrDic = function(self)
  -- function num : 0_61 , upvalues : _ENV
  local attrDic = (table.GetDefaulValueTable)(0)
  for i = 1, (ConfigData.attribute).maxPropertyId - 1 do
    attrDic[i] = self:GetAttr(i, nil, true)
  end
  return attrDic
end

HeroData.GetUltimateSkillLevel = function(self)
  -- function num : 0_62 , upvalues : _ENV
  return ((ConfigData.hero_rank)[self.rank]).ultimateskill_level
end

HeroData.GetMaxNeedFragNum = function(self, isMinusBackpack)
  -- function num : 0_63 , upvalues : _ENV
  local num = 0
  for i = self.rank, (ConfigData.hero_rank).maxRank - 1 do
    num = num + ((ConfigData.hero_rank)[i]).upgrade_star_frag_cost
  end
  if (PlayerDataCenter.allSpecWeaponData):IsUnlockSpecWeaponSystem() then
    local heroMapping = (ConfigData.spec_weapon_basic_config).heroWeaponMapping
    local weaponList = heroMapping[self.dataId]
    if weaponList ~= nil then
      for _,weaponId in ipairs(weaponList) do
        local weapon = self._specWeaponDic ~= nil and (self._specWeaponDic)[weaponId] or nil
        if weapon ~= nil then
          num = num + weapon:GetSpecWeaponHeroFragCount()
        else
          local weaponBasicCfg = (ConfigData.spec_weapon_basic_config)[weaponId]
          num = num + weaponBasicCfg.fragTotal
        end
      end
    end
  end
  do
    if isMinusBackpack then
      return num - PlayerDataCenter:GetItemCount(self.fragId)
    else
      return num
    end
  end
end

HeroData.IsHaveCompletedHeroTask = function(self)
  -- function num : 0_64 , upvalues : _ENV
  local beginLevel = 10
  local heroTaskIds = (ConfigData.training_task)[self.dataId]
  for index,task in ipairs(heroTaskIds) do
    if task.param <= self.level and not self:HasGetQuestReward(task.indx) then
      return true
    end
  end
  return false
end

HeroData.GetHeroArchiveInfo = function(self)
  -- function num : 0_65 , upvalues : _ENV
  local birthday = (LanguageUtil.GetLocaleText)((self.heroCfg).birthday)
  local model = (LanguageUtil.GetLocaleText)((self.heroCfg).model)
  local cv = (LanguageUtil.GetLocaleText)((self.heroCfg).cv)
  local archives_career = (LanguageUtil.GetLocaleText)((self.heroCfg).archives_career)
  return birthday, model, cv, archives_career
end

HeroData.IsArchiveUnlocked = function(self, archiveId)
  -- function num : 0_66
  if self.archive == nil then
    return false
  end
  do return self.archive & 1 << archiveId > 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

HeroData.HasGetQuestReward = function(self, questId)
  -- function num : 0_67
  if self.questRecord == nil then
    return false
  end
  do return self.questRecord & 1 << questId > 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

HeroData.SetQuestGeted = function(self, questId)
  -- function num : 0_68
  if self.questRecord == nil then
    self.questRecord = 0
  end
  self.questRecord = self.questRecord | 1 << questId
end

HeroData.SetArchiveUnlocked = function(self, archiveId)
  -- function num : 0_69
  if self.archive == nil then
    self.archive = 0
  end
  self.archive = self.archive | 1 << archiveId
end

HeroData.BindHeroDataTalent = function(self, talentData)
  -- function num : 0_70
  self._talentData = talentData
end

HeroData.GetHeroDataTalent = function(self)
  -- function num : 0_71
  return self._talentData
end

HeroData.IsActivateSpecWeapon = function(self)
  -- function num : 0_72 , upvalues : _ENV
  if self._specWeaponDic == nil then
    return false
  end
  local isHasSpecWeaponData = (PlayerDataCenter.allSpecWeaponData):ContainHeroSpecWeapon(self.dataId)
  if not isHasSpecWeaponData then
    return false
  end
  for weaponId,specWeaponData in pairs(self._specWeaponDic) do
    if specWeaponData ~= nil then
      local specWeaponCurStep = specWeaponData:GetSpecWeaponCurStep()
      if specWeaponCurStep ~= nil and specWeaponCurStep > 0 then
        return true
      end
    end
  end
  return false
end

HeroData.BindHeroSpecWeapon = function(self, specWeaponData)
  -- function num : 0_73
  if self._specWeaponDic == nil then
    self._specWeaponDic = {}
  end
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (self._specWeaponDic)[specWeaponData:GetSpecWeaponId()] = specWeaponData
end

HeroData.GetHeroDataSpecWeapon = function(self, weaponId)
  -- function num : 0_74
  if self._specWeaponDic == nil then
    return nil
  end
  return (self._specWeaponDic)[weaponId]
end

HeroData.GetHeroDataSpecWeaponAll = function(self)
  -- function num : 0_75
  return self._specWeaponDic
end

HeroData.GetSpecWeaponData = function(self)
  -- function num : 0_76 , upvalues : _ENV
  local heroId = self.dataId
  local weaponId = (PlayerDataCenter.allSpecWeaponData):GetHeroSpecWeaponId(heroId)
  if not weaponId then
    return nil, nil
  end
  local weaponData = self:GetHeroDataSpecWeapon(weaponId)
  return weaponId, weaponData
end

HeroData.ReplaceHeroSkill = function(self)
  -- function num : 0_77 , upvalues : _ENV, HeroSkillData
  if self._specWeaponDic == nil then
    return 
  end
  local newReplaceDic = {}
  for k,v in pairs(self._specWeaponDic) do
    local specWeaponReplaceDic = v:GetSpecWeaponReplaceSkillDic()
    if specWeaponReplaceDic ~= nil then
      (table.merge)(newReplaceDic, specWeaponReplaceDic)
    end
  end
  for oriSkillId,newSkillId in pairs(newReplaceDic) do
    if (self.skillDic)[newSkillId] == nil then
      local lastSkillId = oriSkillId
      lastSkillId = self._replaceSkillDic == nil or (self._replaceSkillDic)[oriSkillId] or oriSkillId
      local index = (table.indexof)(self.skillList, (self.skillDic)[lastSkillId])
      if index then
        local newSkillData = (HeroSkillData.New)(newSkillId, self)
        -- DECOMPILER ERROR at PC50: Confused about usage of register: R10 in 'UnsetPending'

        ;
        (self.skillList)[index] = newSkillData
        -- DECOMPILER ERROR at PC52: Confused about usage of register: R10 in 'UnsetPending'

        ;
        (self.skillDic)[lastSkillId] = nil
        -- DECOMPILER ERROR at PC54: Confused about usage of register: R10 in 'UnsetPending'

        ;
        (self.skillDic)[newSkillId] = newSkillData
      else
        do
          do
            if isGameDev then
              error("replace skill is ERROR")
            end
            -- DECOMPILER ERROR at PC62: LeaveBlock: unexpected jumping out DO_STMT

            -- DECOMPILER ERROR at PC62: LeaveBlock: unexpected jumping out IF_ELSE_STMT

            -- DECOMPILER ERROR at PC62: LeaveBlock: unexpected jumping out IF_STMT

            -- DECOMPILER ERROR at PC62: LeaveBlock: unexpected jumping out IF_THEN_STMT

            -- DECOMPILER ERROR at PC62: LeaveBlock: unexpected jumping out IF_STMT

          end
        end
      end
    end
  end
  self._replaceSkillDic = newReplaceDic
end

HeroData.IsHaveCouldGetRewardArchive = function(self)
  -- function num : 0_78 , upvalues : _ENV
  local friendShipLevel = (PlayerDataCenter.allFriendshipData):GetLevel(self.dataId)
  local friendship_awardCfg = (ConfigData.friendship_award)[self.dataId]
  if friendship_awardCfg == nil then
    error("hero " .. tostring(self.dataId) .. "not have friendship_awardCfg")
    return 
  end
  local friendShipLevel = (PlayerDataCenter.allFriendshipData):GetLevel(self.dataId)
  for fsLevel,cfg in pairs(friendship_awardCfg) do
    local state = nil
    if not self:IsArchiveUnlocked(cfg.friendship_level) and fsLevel <= friendShipLevel then
      return true
    end
  end
  return false
end

HeroData.IsAudioListed = function(self, audioId)
  -- function num : 0_79 , upvalues : _ENV
  if self.audio == nil then
    return false
  end
  local pos = (math.floor)(audioId / 32) + 1
  local newAudioId = audioId % 32
  do return not (self.audio)[pos] or (self.audio)[pos] & 1 << newAudioId > 0 end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

HeroData.SetAudioListed = function(self, audioId)
  -- function num : 0_80 , upvalues : _ENV
  if self.audio == nil then
    self.audio = {}
  end
  local pos = (math.floor)(audioId / 32) + 1
  local newAudioId = audioId % 32
  if pos >= 1 then
    for i = 1, pos do
      -- DECOMPILER ERROR at PC22: Confused about usage of register: R8 in 'UnsetPending'

      if (self.audio)[i] == nil then
        (self.audio)[i] = 0
      end
    end
  end
  do
    -- DECOMPILER ERROR at PC29: Confused about usage of register: R4 in 'UnsetPending'

    ;
    (self.audio)[pos] = (self.audio)[pos] | 1 << newAudioId
  end
end

HeroData.GetRepeatExtraItemList = function(self)
  -- function num : 0_81 , upvalues : _ENV
  local ids = (self.rankCfg).repeat_extra_trans_id
  local nums = (self.rankCfg).repeat_extra_trans_num
  local itemList = {}
  for k,id in ipairs(ids) do
    local itemCfg = (ConfigData.item)[id]
    if itemCfg == nil then
      error("Cant get itemCfg, id = " .. tostring(id))
    else
      ;
      (table.insert)(itemList, {itemCfg = itemCfg, num = nums[k]})
    end
  end
  return itemList
end

HeroData.GetRepeatFragTrans = function(self)
  -- function num : 0_82 , upvalues : _ENV
  local itemCfg = (ConfigData.item)[self.fragId]
  local num = (self.rankCfg).repeat_frag_trans
  return itemCfg, num
end

HeroData.IsHeroRecommendAttr = function(self, attrId)
  -- function num : 0_83
  do return ((self.heroCfg).attribute_recommend)[attrId] == true end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

HeroData.SetIsFavouriteHero = function(self, bool)
  -- function num : 0_84
  self.__isFavouriteHero = bool
end

HeroData.IsFavouriteHero = function(self)
  -- function num : 0_85
  return self.__isFavouriteHero
end

HeroData.GetIsNotShowInfo = function(self)
  -- function num : 0_86
  return (self.heroCfg).lock_heroinfo
end

HeroData.GetHeroHeadResName = function(self)
  -- function num : 0_87 , upvalues : _ENV
  local resName = nil
  do
    if self.skinId or 0 ~= 0 then
      local skinCfg = (ConfigData.skin)[self.skinId]
      if skinCfg ~= nil and not (string.IsNullOrEmpty)(skinCfg.src_id_icon) then
        resName = skinCfg.src_id_icon
      end
    end
    do
      if (string.IsNullOrEmpty)(resName) and (self.heroCfg).fragment ~= nil then
        local itemCfg = (ConfigData.item)[(self.heroCfg).fragment]
        if itemCfg ~= nil then
          resName = itemCfg.icon
        end
      end
      return resName
    end
  end
end

HeroData.GetReplaceSkill = function(self, oriSkill)
  -- function num : 0_88
  if self._replaceSkillDic == nil then
    return nil
  end
  return (self._replaceSkillDic)[oriSkill]
end

HeroData.GetHeroSkill = function(self, skillId)
  -- function num : 0_89
  return (self.skillDic)[skillId]
end

return HeroData

