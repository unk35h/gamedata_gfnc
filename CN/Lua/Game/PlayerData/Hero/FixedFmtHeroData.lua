-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.PlayerData.Hero.HeroData")
local FixedFmtHeroData = class("FixedFmtHeroData", base)
local attrIdOffset = (ConfigData.buildinConfig).AttrIdOffset
local cs_GameData_ins = (CS.GameData).instance
FixedFmtHeroData.FixedFmtHeroData = function(heroId, assisLvCfg)
  -- function num : 0_0 , upvalues : FixedFmtHeroData
  local heroData = (FixedFmtHeroData._GenHeroDataBase)(FixedFmtHeroData, heroId, assisLvCfg)
  heroData.isFixedFmtHero = true
  return heroData
end

FixedFmtHeroData._GenHeroDataBase = function(classTab, heroId, assisLvCfg)
  -- function num : 0_1 , upvalues : FixedFmtHeroData, _ENV
  local msgData = (FixedFmtHeroData.__GetFakeMsgData)(heroId, assisLvCfg)
  local heroData = (classTab.New)(msgData)
  local attrDic = DeepCopy(assisLvCfg.attrDic)
  heroData:_SetAttrDic(attrDic)
  heroData._assisLvCfg = assisLvCfg
  heroData.isRemoveAllBounce = true
  return heroData
end

FixedFmtHeroData.__GetFakeMsgData = function(heroId, assisLvCfg)
  -- function num : 0_2 , upvalues : _ENV, cs_GameData_ins
  local msgData = {
basic = {id = heroId, level = assisLvCfg.hero_level, exp = 0, star = assisLvCfg.hero_rank, potentialLvl = assisLvCfg.hero_potential, skinId = (PlayerDataCenter.skinData):DealNotSelfHaveHeroSkinOverraid(0, heroId)}
, 
skill = {
data = {}
}
}
  local heroCfg = (ConfigData.hero_data)[heroId]
  for k,skilId in ipairs(heroCfg.skill_list) do
    -- DECOMPILER ERROR at PC32: Confused about usage of register: R9 in 'UnsetPending'

    ((msgData.skill).data)[skilId] = assisLvCfg.hero_skill_level
    local skillCfg = (ConfigData.hero_skill)[skilId]
    if skillCfg.type ~= eHeroSkillType.LifeSkill then
      local battleSkillCfg = (cs_GameData_ins.listBattleSkillDatas):GetDataById(skilId)
      if battleSkillCfg == nil then
        error("battle_skill cfg is null,Id:" .. tostring(skilId))
      else
        -- DECOMPILER ERROR at PC67: Confused about usage of register: R11 in 'UnsetPending'

        if battleSkillCfg:IsUltSkill() then
          ((msgData.skill).data)[skilId] = ((ConfigData.hero_rank)[(msgData.basic).star]).ultimateskill_level
        end
      end
    end
  end
  if #assisLvCfg.spec_weapon_level > 0 then
    local weaponId = (PlayerDataCenter.allSpecWeaponData):GetHeroSpecWeaponId(heroId)
    if weaponId ~= nil then
      local step = (assisLvCfg.spec_weapon_level)[1]
      local level = (assisLvCfg.spec_weapon_level)[2]
      msgData.spWeapon = {
{id = weaponId, step = step, level = level}
}
      step = (math.min)(step, ((ConfigData.spec_weapon_step).stepDic)[weaponId])
      local stepListCfg = (ConfigData.spec_weapon_step)[weaponId]
      local stepCfg = stepListCfg[step]
      if stepCfg ~= nil then
        for oriSkillId,newSkillId in pairs(stepCfg.replaceSkillDic) do
          -- DECOMPILER ERROR at PC116: Confused about usage of register: R14 in 'UnsetPending'

          ((msgData.skill).data)[newSkillId] = ((msgData.skill).data)[oriSkillId]
        end
      end
    end
  end
  do
    return msgData
  end
end

FixedFmtHeroData._SetAttrDic = function(self, attrDic)
  -- function num : 0_3
  self.customeAttrDic = attrDic
end

FixedFmtHeroData.__CalBaseAttr = function(self, attrId, withoutAth, athHeroId)
  -- function num : 0_4 , upvalues : attrIdOffset, base
  local baseAttrId = attrId + attrIdOffset
  local customeAttr = (self.customeAttrDic)[baseAttrId] or 0
  if (self._assisLvCfg).attribute_type == true then
    return customeAttr
  end
  local atrValue = (base.__CalBaseAttr)(self, attrId, withoutAth, athHeroId)
  return customeAttr + atrValue
end

FixedFmtHeroData.__CalRatioAttr = function(self, atrValue, attrId, withoutAth, athHeroId, extrValue)
  -- function num : 0_5 , upvalues : attrIdOffset, base
  local ratioAttrId = attrId + attrIdOffset * 2
  local customeAttr = (self.customeAttrDic)[ratioAttrId] or 0
  if (self._assisLvCfg).attribute_type == true then
    return (base.__CalRatioAttr)(self, atrValue, attrId, withoutAth, athHeroId, extrValue, customeAttr)
  end
  extrValue = customeAttr + (extrValue or 0)
  return (base.__CalRatioAttr)(self, atrValue, attrId, withoutAth, athHeroId, extrValue)
end

FixedFmtHeroData.__CalExtraAttr = function(self, atrValue, attrId, withoutAth, athHeroId)
  -- function num : 0_6 , upvalues : base
  local customeAttr = (self.customeAttrDic)[attrId] or 0
  if (self._assisLvCfg).attribute_type == true then
    return atrValue + customeAttr
  end
  return (base.__CalExtraAttr)(self, atrValue, attrId, withoutAth, athHeroId) + customeAttr
end

FixedFmtHeroData.GetAthSlotList = function(self, isFull)
  -- function num : 0_7 , upvalues : base
  return (base.GetAthSlotList)(self, isFull)
end

FixedFmtHeroData.GetAthSlotInfo = function(self, index)
  -- function num : 0_8
  return nil
end

FixedFmtHeroData.GetAthSuit = function(self)
  -- function num : 0_9 , upvalues : _ENV
  return table.emptytable
end

return FixedFmtHeroData

