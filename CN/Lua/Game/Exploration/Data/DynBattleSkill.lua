-- params : ...
-- function num : 0 , upvalues : _ENV
local DynBattleSkill = class("DynBattleSkill")
local CS_GameData_Ins = (CS.GameData).instance
local ExplorationEnum = require("Game.Exploration.ExplorationEnum")
local cs_FormulaUtility = CS.FormulaUtility
local cs_FilePathHelper = (CS.FilePathHelper).Instance
DynBattleSkill.ctor = function(self, dataId, level, skillType, unlockAdvance)
  -- function num : 0_0 , upvalues : _ENV
  self.dataId = dataId
  self.level = level
  self.type = skillType
  self.itemId = 0
  self.unlockAdvance = unlockAdvance or false
  local skillcfg = (ConfigData.battle_skill)[self.dataId]
  if skillcfg == nil then
    error("battle skill cfg is null,id:" .. tostring(self.dataId))
    return 
  end
  if not (string.IsNullOrEmpty)(skillcfg.lua_script) then
    require(PathConsts.LuaSkillScriptsPath .. skillcfg.lua_script)
  end
  self.__isFullLevel = false
  self.__adapterType = 0
  self.labelDic = ((ConfigData.battle_skill).skill_label_Dic)[self.dataId]
end

DynBattleSkill.Update = function(self, level)
  -- function num : 0_1
  self.level = level
end

DynBattleSkill.SetIsFullLevel = function(self, full)
  -- function num : 0_2
  self.__isFullLevel = full
end

DynBattleSkill.GetIsFullLevel = function(self)
  -- function num : 0_3
  return self.__isFullLevel
end

DynBattleSkill.SetSkillAdapterType = function(self, type)
  -- function num : 0_4
  self.__adapterType = type
end

DynBattleSkill.GetSkillAdapterType = function(self)
  -- function num : 0_5
  return self.__adapterType
end

DynBattleSkill.IsSpecialBanSkill = function(self)
  -- function num : 0_6 , upvalues : ExplorationEnum
  do return self.__adapterType == (ExplorationEnum.eSkillAdapterType).Ban end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

DynBattleSkill.GetIsUnlock = function(self)
  -- function num : 0_7
  do return self.level > 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

DynBattleSkill.IsPassiveSkill = function(self)
  -- function num : 0_8 , upvalues : CS_GameData_Ins, _ENV
  local skillCfg = (CS_GameData_Ins.listBattleSkillDatas):GetDataById(self.dataId)
  if skillCfg == nil then
    error("找不到技能配置:" .. tostring(self.dataId))
    return false
  end
  return skillCfg:IsPassiveSkill()
end

DynBattleSkill.IsUniqueSkill = function(self)
  -- function num : 0_9 , upvalues : CS_GameData_Ins, _ENV
  local skillCfg = (CS_GameData_Ins.listBattleSkillDatas):GetDataById(self.dataId)
  if skillCfg == nil then
    error("找不到技能配置:" .. tostring(self.dataId))
    return false
  end
  return skillCfg:IsUltSkill()
end

DynBattleSkill.CreateByChip = function(self, dataId, level, itemId)
  -- function num : 0_10 , upvalues : DynBattleSkill, _ENV
  local skill = (DynBattleSkill.New)(dataId, level, eBattleSkillLogicType.Chip)
  skill.itemId = itemId
  return skill
end

DynBattleSkill.GetLevelDescribe = function(self, level, unlockAdvance, isShowDetail)
  -- function num : 0_11 , upvalues : CS_GameData_Ins, _ENV
  local skillCfg = (CS_GameData_Ins.listBattleSkillDatas):GetDataById(self.dataId)
  if skillCfg == nil then
    error("找不到技能配置:" .. tostring(self.dataId))
    return nil
  end
  if not level then
    local lv = self.level
  end
  if not unlockAdvance then
    local unAdv = self.unlockAdvance
  end
  return skillCfg:GetLevelDescribe(lv, unAdv, isShowDetail)
end

DynBattleSkill.GetIcon = function(self)
  -- function num : 0_12 , upvalues : CS_GameData_Ins, _ENV
  local skillCfg = (CS_GameData_Ins.listBattleSkillDatas):GetDataById(self.dataId)
  if skillCfg == nil then
    error("找不到技能配置:" .. tostring(self.dataId))
    return nil
  end
  return skillCfg.Icon
end

DynBattleSkill.GetName = function(self)
  -- function num : 0_13 , upvalues : CS_GameData_Ins, _ENV
  local skillCfg = (CS_GameData_Ins.listBattleSkillDatas):GetDataById(self.dataId)
  if skillCfg == nil then
    error("找不到技能配置:" .. tostring(self.dataId))
    return nil
  end
  return skillCfg.Name
end

DynBattleSkill.IsHideViewSkill = function(self)
  -- function num : 0_14 , upvalues : CS_GameData_Ins, _ENV
  local skillCfg = (CS_GameData_Ins.listBattleSkillDatas):GetDataById(self.dataId)
  if skillCfg == nil then
    error("找不到技能配置:" .. tostring(self.dataId))
    return true
  end
  return skillCfg.SkillIsShow
end

DynBattleSkill.IsCommonAttack = function(self)
  -- function num : 0_15 , upvalues : CS_GameData_Ins, _ENV
  local skillCfg = (CS_GameData_Ins.listBattleSkillDatas):GetDataById(self.dataId)
  if skillCfg == nil then
    error("找不到技能配置:" .. tostring(self.dataId))
    return false
  end
  return skillCfg:IsCommonAttack()
end

DynBattleSkill.GetSkillTag = function(self)
  -- function num : 0_16 , upvalues : CS_GameData_Ins, _ENV
  local skillCfg = (CS_GameData_Ins.listBattleSkillDatas):GetDataById(self.dataId)
  if skillCfg == nil then
    error("找不到技能配置:" .. tostring(self.dataId))
    return nil
  end
  return skillCfg.SkillTag
end

DynBattleSkill.GetBattleSkillTypeColor = function(self)
  -- function num : 0_17 , upvalues : CS_GameData_Ins, _ENV
  local skillCfg = (CS_GameData_Ins.listBattleSkillDatas):GetDataById(self.dataId)
  if skillCfg == nil then
    error("找不到技能配置:" .. tostring(self.dataId))
    return nil
  end
  return skillCfg.TypeColor
end

DynBattleSkill.GetSkillLabeIdList = function(self, level)
  -- function num : 0_18 , upvalues : _ENV
  if self.labelDic == nil then
    return 
  end
  local compareLv = 1
  compareLv = level == nil and self.level or level
  local tab = {}
  local labelList = ((ConfigData.battle_skill).skill_label_List)[self.dataId]
  for index,id in ipairs(labelList) do
    if (self.labelDic)[id] ~= nil and (self.labelDic)[id] <= compareLv then
      (table.insert)(tab, id)
    end
  end
  return tab
end

DynBattleSkill.PreloadSkill = function(self, effectPoolCtrl, dynHero)
  -- function num : 0_19 , upvalues : _ENV, cs_FilePathHelper
  local skillcfg = (ConfigData.battle_skill)[self.dataId]
  if skillcfg == nil then
    return 
  end
  local resloader = effectPoolCtrl.resloader
  for _,effctId in pairs(skillcfg.effect_id) do
    local effectCfg = (ConfigData.battle_creation)[effctId]
    if effectCfg.src_name ~= nil then
      local loadType = effectCfg.load_type
      if loadType == 1 then
        local path = cs_FilePathHelper:GetSkinCharacterSkillEffectPath(dynHero:GetResModelName(), dynHero:GetResModelName(true), effectCfg.src_name)
        resloader:LoadABAsset(path)
      else
        do
          do
            if loadType == 0 then
              resloader:LoadABAsset(effectCfg.src_name .. PathConsts.PrefabExtension)
            end
            -- DECOMPILER ERROR at PC42: LeaveBlock: unexpected jumping out DO_STMT

            -- DECOMPILER ERROR at PC42: LeaveBlock: unexpected jumping out IF_ELSE_STMT

            -- DECOMPILER ERROR at PC42: LeaveBlock: unexpected jumping out IF_STMT

            -- DECOMPILER ERROR at PC42: LeaveBlock: unexpected jumping out IF_THEN_STMT

            -- DECOMPILER ERROR at PC42: LeaveBlock: unexpected jumping out IF_STMT

          end
        end
      end
    end
  end
end

DynBattleSkill.GetCurrentSkillCDTime = function(self)
  -- function num : 0_20 , upvalues : cs_FormulaUtility
  return (cs_FormulaUtility.CalculateSkillCd)(self.dataId, self.level)
end

DynBattleSkill.GetSkillAdaptationSource = function(self)
  -- function num : 0_21 , upvalues : _ENV
  local skillCfg = (ConfigData.hero_skill)[self.dataId]
  if skillCfg ~= nil then
    return skillCfg.skill_adaption
  end
  return 0
end

DynBattleSkill.SetSkillFromMonsterLabel = function(self, monsterLableId)
  -- function num : 0_22
  self.__monsterLableId = monsterLableId
end

DynBattleSkill.GetSkillMonsterLabel = function(self)
  -- function num : 0_23
  return self.__monsterLableId
end

return DynBattleSkill

