-- params : ...
-- function num : 0 , upvalues : _ENV
local RecommeFormationSingleData = class("RecommeFormationSingleData")
local HeroData = require("Game.PlayerData.Hero.HeroData")
local ChipData = require("Game.PlayerData.Item.ChipData")
local CommanderSkillTreeData = require("Game.CommanderSkill.CommanderSkillTreeData")
local CommanderSkillData = require("Game.CommanderSkill.CommanderSkillData")
RecommeFormationSingleData.ctor = function(self)
  -- function num : 0_0
end

RecommeFormationSingleData.SetRecommeSinglePara = function(self, isDungeon, stageId)
  -- function num : 0_1
  self._isDungeon = isDungeon
  self._stageId = stageId
end

RecommeFormationSingleData.InitRecommeSingleData = function(self, data, formationRuleCfg)
  -- function num : 0_2 , upvalues : _ENV, ChipData
  self.playerId = data.uid
  self.playerName = data.name
  self.playerLevel = data.level
  self.mvpHeroId = data.mvp
  self.slotSkillList = {}
  self:__CollectSkill(data)
  self:CalculateHeroData(data.hero, formationRuleCfg)
  self.chipList = {}
  for key,value in pairs(data.alg) do
    local chipData = (ChipData.New)(key, value)
    ;
    (table.insert)(self.chipList, chipData)
  end
end

RecommeFormationSingleData.__CollectSkill = function(self, data)
  -- function num : 0_3 , upvalues : _ENV, CommanderSkillData, CommanderSkillTreeData
  do
    if self._isDungeon then
      local dungeonStageCfg = (ConfigData.battle_dungeon)[self._stageId]
      if #dungeonStageCfg.const_cstIds > 0 then
        self._isFixedSkill = true
        self.slotSkillList = dungeonStageCfg.const_cstIds
        return 
      end
    end
    self._isFixedSkill = false
    if (data.cst).treeId > 0 then
      self.treeCfg = (ConfigData.commander_skill)[(data.cst).treeId]
      if (data.cst).skillGroup ~= nil and (table.count)((data.cst).skillGroup) > 0 then
        local skillDic = {}
        local placeMax = 0
        for skillId,_ in pairs((data.cst).skillGroup) do
          local skillCfg = self:GetSkillById(skillId, (data.cst).treeId)
          if skillCfg ~= nil and skillCfg.skill_type == (CommanderSkillData.skillType).active then
            skillDic[skillCfg.place] = skillId
            if skillCfg.place >= placeMax or not placeMax then
              placeMax = skillCfg.place
            end
          end
        end
        for i = 1, placeMax do
          if skillDic[i] ~= nil then
            (table.insert)(self.slotSkillList, skillDic[i])
          end
        end
      end
    end
    do
      if self.treeCfg == nil or #self.slotSkillList == 0 then
        local commandSkill = (CommanderSkillTreeData.New)(1, 1, 0)
        self.treeCfg = commandSkill.treeCfg
        self.slotSkillList = commandSkill.slotSkillList
      end
    end
  end
end

RecommeFormationSingleData.GetSkillById = function(self, skillId, treeId)
  -- function num : 0_4 , upvalues : _ENV
  local unlockSkillCfg = (ConfigData.commander_skill_unlock)[treeId]
  for k,v in pairs(unlockSkillCfg) do
    if k == skillId then
      return v
    end
  end
end

RecommeFormationSingleData.CalculateHeroData = function(self, heroMsg, formationRuleCfg)
  -- function num : 0_5 , upvalues : _ENV, HeroData
  self.recommanHeroDic = {}
  self.firstPower = 0
  self.benchPower = 0
  self.heroCount = 0
  self.starMax = 0
  self.levelMax = 0
  self.idAddtion = 0
  LocalFunc_CalculateIndex = function(self, index, heroList)
    -- function num : 0_5_0 , upvalues : HeroData
    for i = 1, #heroList do
      index = index + 1
      -- DECOMPILER ERROR at PC17: Confused about usage of register: R7 in 'UnsetPending'

      ;
      (self.recommanHeroDic)[index] = {basic = (HeroData.New)(heroList[i]), power = (heroList[i]).power, position = (heroList[i]).position}
    end
    return index
  end

  local xMax = 0
  local yMax = 0
  local posHeroDic = {}
  local benchDic = {}
  for k,v in pairs(heroMsg) do
    local x, y = (BattleUtil.Pos2XYCoord)(v.position or 0)
    if (yMax < y and y) or x == (ConfigData.buildinConfig).BenchX then
      local yArry = benchDic[y]
      if yArry == nil then
        yArry = {}
        benchDic[y] = yArry
      end
      ;
      (table.insert)(yArry, v)
    else
      do
        if xMax >= x or not x then
          local xDic = posHeroDic[x]
          if xDic == nil then
            xDic = {}
            posHeroDic[x] = xDic
          end
          do
            local yArry = xDic[y]
            if yArry == nil then
              yArry = {}
              xDic[y] = yArry
            end
            ;
            (table.insert)(yArry, v)
            -- DECOMPILER ERROR at PC67: LeaveBlock: unexpected jumping out IF_THEN_STMT

            -- DECOMPILER ERROR at PC67: LeaveBlock: unexpected jumping out IF_STMT

            -- DECOMPILER ERROR at PC67: LeaveBlock: unexpected jumping out DO_STMT

            -- DECOMPILER ERROR at PC67: LeaveBlock: unexpected jumping out IF_ELSE_STMT

            -- DECOMPILER ERROR at PC67: LeaveBlock: unexpected jumping out IF_STMT

          end
        end
      end
    end
  end
  local curIndex = 0
  for x = 0, xMax do
    if posHeroDic[x] ~= nil then
      for y = 0, yMax do
        local heroList = (posHeroDic[x])[y]
        if heroList ~= nil and #heroList > 0 then
          curIndex = LocalFunc_CalculateIndex(self, curIndex, heroList)
        end
      end
    end
  end
  if (table.count)(benchDic) > 0 then
    local benchCount = 0
    for i = 0, yMax do
      if benchDic[i] ~= nil then
        benchCount = benchCount + (table.count)(benchDic[i])
      end
    end
    if benchCount <= formationRuleCfg.bench_num then
      curIndex = formationRuleCfg.stage_num
    else
      curIndex = formationRuleCfg.stage_num + formationRuleCfg.bench_num - (benchCount)
    end
    for i = 0, yMax do
      if benchDic[i] ~= nil then
        curIndex = LocalFunc_CalculateIndex(self, curIndex, benchDic[i])
      end
    end
  end
  do
    for key,value in pairs(self.recommanHeroDic) do
      if key <= formationRuleCfg.stage_num then
        self.firstPower = self.firstPower + value.power
      else
        self.benchPower = self.benchPower + value.power
      end
      self.heroCount = self.heroCount + 1
      if (value.basic).star >= self.starMax or not self.starMax then
        self.starMax = (value.basic).star
        if (value.basic).level >= self.levelMax or not self.levelMax then
          do
            self.levelMax = (value.basic).level
            self.idAddtion = self.idAddtion + (value.basic).dataId
            -- DECOMPILER ERROR at PC185: LeaveBlock: unexpected jumping out IF_THEN_STMT

            -- DECOMPILER ERROR at PC185: LeaveBlock: unexpected jumping out IF_STMT

            -- DECOMPILER ERROR at PC185: LeaveBlock: unexpected jumping out IF_THEN_STMT

            -- DECOMPILER ERROR at PC185: LeaveBlock: unexpected jumping out IF_STMT

          end
        end
      end
    end
    self.firstPower = self.firstPower + (ConfigData.GetFormulaValue)(eFormulaType.Commander, {power = self.firstPower})
    self.firstPower = (math.floor)(self.firstPower)
    self.power = self.firstPower + self.benchPower
  end
end

RecommeFormationSingleData.IsAllowCopy = function(self)
  -- function num : 0_6 , upvalues : _ENV
  local indexMax = ConfigData:GetFormationHeroCount()
  for index,data in pairs(self.recommanHeroDic) do
    if index <= indexMax and (PlayerDataCenter.heroDic)[(data.basic).dataId] ~= nil then
      return true
    end
  end
  return false
end

RecommeFormationSingleData.GetHaveCount = function(self)
  -- function num : 0_7 , upvalues : _ENV
  local indexMax = ConfigData:GetFormationHeroCount()
  local count = 0
  for index,data in pairs(self.recommanHeroDic) do
    if index <= indexMax and (PlayerDataCenter.heroDic)[(data.basic).dataId] ~= nil then
      count = count + 1
    end
  end
  return count
end

RecommeFormationSingleData.CopyFormation = function(self)
  -- function num : 0_8 , upvalues : _ENV
  local indexMax = ConfigData:GetFormationHeroCount()
  local res = {}
  for index,data in pairs(self.recommanHeroDic) do
    if index <= indexMax and (PlayerDataCenter.heroDic)[(data.basic).dataId] ~= nil then
      res[index] = (data.basic).dataId
    end
  end
  return res
end

RecommeFormationSingleData.IsRecommeFixedSkill = function(self)
  -- function num : 0_9
  return self._isFixedSkill
end

return RecommeFormationSingleData

