-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.PlayerData.Hero.HeroData")
local FriendSupportHeroData = class("FriendSupportHeroData", base)
local attrIdOffset = 100
FriendSupportHeroData.ctor = function(self, data)
  -- function num : 0_0
  self.isFriendSupport = true
  self.athDic = {}
  self.athSkills = {}
  self.skillLevelDic = {}
  self.attrAddDic = {}
  self._defaultPow = nil
  self._pow = nil
  self.userInfo = nil
end

FriendSupportHeroData.GenSupportHeroData = function(userInfoData, briefId, fixCfg)
  -- function num : 0_1 , upvalues : FriendSupportHeroData
  local SupportHeroData = userInfoData:GetSupportHeroDataById(briefId)
  local assistsBrief = SupportHeroData.assistsBrief
  local assistsRandom = SupportHeroData.assistsRandom
  local data = (FriendSupportHeroData.CreatSupportHeroDataBase)(assistsBrief, assistsRandom, fixCfg)
  data.userInfo = userInfoData
  return data
end

FriendSupportHeroData.CreatSupportHeroDataBase = function(assistsBrief, assistsRandom, fixCfg)
  -- function num : 0_2 , upvalues : _ENV, FriendSupportHeroData
  local basic = {}
  local skillLevelData = {}
  basic.id = assistsBrief.id
  basic.level = assistsBrief.level
  basic.exp = 0
  basic.ts = nil
  basic.potentialLvl = assistsBrief.potential
  basic.archive = nil
  basic.audio = nil
  basic.star = assistsBrief.star
  basic.skinId = (PlayerDataCenter.skinData):DealNotSelfHaveHeroSkinOverraid(assistsBrief.skin, assistsBrief.id)
  if fixCfg ~= nil then
    basic.level = fixCfg.fixLv
    basic.potentialLvl = fixCfg.fixPotential
  end
  if assistsRandom ~= nil then
    skillLevelData = assistsRandom.skills
  end
  local fakeData = {}
  fakeData.basic = basic
  fakeData.skill = {}
  -- DECOMPILER ERROR at PC35: Confused about usage of register: R6 in 'UnsetPending'

  ;
  (fakeData.skill).data = skillLevelData
  if assistsRandom ~= nil and assistsRandom.specWeapon ~= nil then
    fakeData.spWeapon = assistsRandom.specWeapon
  end
  local data = (FriendSupportHeroData.New)(fakeData)
  data._defaultPow = assistsBrief.power
  data.__fixCfg = fixCfg
  if fixCfg ~= nil then
    data.__fixAlgAttr = fixCfg.fixAlgAttr / 1000
  else
    data.__fixAlgAttr = 1
  end
  if fixCfg ~= nil then
    for skillId,skillData in pairs(data.skillDic) do
      if (skillData:IsNormalSkill() or skillData:IsPassiveSkill()) and fixCfg.fixSkillLv < skillData.level then
        skillData:UpdateSkill(fixCfg.fixSkillLv)
      end
    end
  end
  do
    if assistsRandom ~= nil then
      data.skillLevelDic = assistsRandom.skills
      data.athDic = assistsRandom.athLoc
      data.athSkills = assistsRandom.athSkills
      data.talentSkillDic = assistsRandom.talentSkills
      data.attrAddDic = {}
      for attrId,attrVal in pairs(assistsRandom.athAttr) do
        -- DECOMPILER ERROR at PC96: Confused about usage of register: R12 in 'UnsetPending'

        (data.attrAddDic)[attrId] = attrVal
      end
      for attrId,attrVal in pairs(assistsRandom.talentAttr) do
        local count = (data.attrAddDic)[attrId] or 0
        -- DECOMPILER ERROR at PC110: Confused about usage of register: R13 in 'UnsetPending'

        ;
        (data.attrAddDic)[attrId] = count + attrVal
      end
    end
    do
      data.isRemoveAllBounce = true
      data._assistsBrief = assistsBrief
      data._assistsRandom = assistsRandom
      data:CalSupporterPow()
      data:CalAthSuit(fixCfg)
      return data
    end
  end
end

FriendSupportHeroData.OnSupporterLevelChange = function(self, level)
  -- function num : 0_3
  self.level = level
  self:__UpdateBaseArriDic()
  self:CalSupporterPow()
end

FriendSupportHeroData.CalSupporterPow = function(self)
  -- function num : 0_4
  self._pow = self:GetFightingPower()
end

FriendSupportHeroData.GetSupporterPow = function(self)
  -- function num : 0_5
  return self._pow or 0
end

FriendSupportHeroData.GetFightingPower = function(self, isDefault)
  -- function num : 0_6 , upvalues : base
  do return not isDefault or self._defaultPow or 0 end
  local power = (base.GetFightingPower)(self)
  power = power + (self._assistsRandom).talentEfficiency
  return power
end

FriendSupportHeroData.CalAthSuit = function(self, fixCfg)
  -- function num : 0_7 , upvalues : _ENV
  local suitDic = {}
  if fixCfg ~= nil and fixCfg.fixAlgSuit <= 0 then
    self.athSuitDic = suitDic
    return 
  end
  for _,athId in pairs(self.athDic) do
    local athCfg = (ConfigData.arithmetic)[athId]
    if athCfg ~= nil then
      local suitId = athCfg.suit
      if not suitDic[suitId] then
        local count = suitId or 0 == 0 or 0
      end
      suitDic[suitId] = count + 1
    end
  end
  for suitId,count in pairs(suitDic) do
    local athSuitCfg = (ConfigData.ath_suit)[suitId]
    if count < (athSuitCfg[1]).num then
      suitDic[suitId] = nil
    end
  end
  self.athSuitDic = suitDic
end

FriendSupportHeroData.GetAthSlotInfo = function(self, index)
  -- function num : 0_8 , upvalues : _ENV
  local res = {}
  for key,athId in pairs(self.athDic) do
    local tempIndex = key >> 16
    if tempIndex == index then
      local slot = key & 65535
      res[slot] = athId
    end
  end
  return res
end

FriendSupportHeroData.GetAthSuit = function(self)
  -- function num : 0_9
  return self.athSuitDic
end

FriendSupportHeroData.GetSkillFightingPower = function(self, heroPower)
  -- function num : 0_10 , upvalues : _ENV, base
  local fightingPower = 0
  for skillId,skillLevel in pairs(self.athSkills) do
    local battleCfg = (ConfigData.battle_skill)[skillId]
    fightingPower = PlayerDataCenter:GetBattleSkillFightPower(skillId, skillLevel, heroPower) + fightingPower
  end
  return (base.GetSkillFightingPower)(self, heroPower) + (fightingPower)
end

FriendSupportHeroData.GetUserInfo = function(self)
  -- function num : 0_11
  return self.userInfo
end

FriendSupportHeroData.UseFixCfg2ChangeSupportorAttr = function(self, fixCfg)
  -- function num : 0_12 , upvalues : _ENV
  if self.__fixCfg ~= fixCfg then
    do return  end
    local fakeData = {
basic = {level = fixCfg.fixLv, potentialLvl = fixCfg.fixPotential}
}
    self:UpdateHeroData(fakeData)
    for skillId,skillData in pairs(self.skillDic) do
      if (skillData:IsNormalSkill() or skillData:IsPassiveSkill()) and fixCfg.fixSkillLv < skillData.level then
        skillData:UpdateSkill(fixCfg.fixSkillLv)
      end
    end
    self:CalSupporterPow()
  end
end

FriendSupportHeroData.__CalBaseAttr = function(self, attrId, withoutAth, athHeroId)
  -- function num : 0_13 , upvalues : attrIdOffset, base, _ENV
  local baseAttrId = attrId + attrIdOffset
  local specWeaponDic = self._specWeaponDic
  self._specWeaponDic = nil
  local res = (base.__CalBaseAttr)(self, attrId, withoutAth, athHeroId) + (math.floor)(((self.attrAddDic)[baseAttrId] or 0) * self.__fixAlgAttr)
  self._specWeaponDic = specWeaponDic
  return res
end

FriendSupportHeroData.__CalRatioAttr = function(self, atrValue, attrId, withoutAth, athHeroId)
  -- function num : 0_14 , upvalues : attrIdOffset, base, _ENV
  local ratioAttrId = attrId + attrIdOffset * 2
  local specWeaponDic = self._specWeaponDic
  self._specWeaponDic = nil
  local res = (base.__CalRatioAttr)(self, atrValue, attrId, withoutAth, athHeroId, (math.floor)(((self.attrAddDic)[ratioAttrId] or 0) * self.__fixAlgAttr))
  self._specWeaponDic = specWeaponDic
  return res
end

FriendSupportHeroData.__CalExtraAttr = function(self, atrValue, attrId, withoutAth, athHeroId)
  -- function num : 0_15 , upvalues : base, _ENV
  local specWeaponDic = self._specWeaponDic
  self._specWeaponDic = nil
  local res = (base.__CalExtraAttr)(self, atrValue, attrId, withoutAth, athHeroId) + (math.floor)(((self.attrAddDic)[attrId] or 0) * self.__fixAlgAttr)
  self._specWeaponDic = specWeaponDic
  return res
end

FriendSupportHeroData.GetMaxPotential = function(self)
  -- function num : 0_16 , upvalues : _ENV
  return (math.max)(5, self.potential)
end

FriendSupportHeroData.GetAthSlotList = function(self, isFull)
  -- function num : 0_17 , upvalues : base
  return (base.GetAthSlotList)(self, isFull, (self._assistsBrief).star, (self._assistsBrief).potential, (self._assistsBrief).level)
end

FriendSupportHeroData.GetSupportHerotalentLevel = function(self)
  -- function num : 0_18
  return (self._assistsBrief).talent or 0
end

return FriendSupportHeroData

