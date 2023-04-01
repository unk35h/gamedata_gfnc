-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_105311 = class("bs_105311", LuaSkillBase)
local base = LuaSkillBase
bs_105311.config = {caoTime = 75, monsterId1 = 46, maxHpPer = 250, powPer = 1000, effectIdAttack = 514101, startAnimId = 1002, skill_speed = 1, buffYS = 3004, buffId_bati = 206800}
bs_105311.ctor = function(self)
  -- function num : 0_0
end

bs_105311.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSelfTrigger(eSkillTriggerType.AfterBattleStart, "bs_105311_1", 1, self.OnAfterBattleStart)
end

bs_105311.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_bati, 1, nil, true)
  LuaSkillCtrl:StartAvgWithPauseGame("cpt_imr_s06_3", nil, nil)
  local arriveCallBack1 = BindCallback(self, self.OnArriveAction1)
  LuaSkillCtrl:StartTimer(nil, 15, arriveCallBack1)
end

bs_105311.summoner = function(self, grid)
  -- function num : 0_3 , upvalues : _ENV
  local x = grid.x
  local y = grid.y
  local target = LuaSkillCtrl:GetTargetWithGrid(grid.x, grid.y)
  if not ((self.caster).recordTable).CasterSkill then
    local cskill = self.cskill
  end
  local summoner = LuaSkillCtrl:CreateSummonerWithCSkill(cskill, (self.config).monsterId1, x, y)
  summoner:SetAttr(eHeroAttr.maxHp, (self.caster).maxHp * (self.config).maxHpPer // 10000)
  summoner:SetAttr(eHeroAttr.pow, (self.caster).pow * (self.config).powPer // 1000)
  summoner:SetAttr(eHeroAttr.skill_intensity, (self.caster).skill_intensity * (self.config).powPer // 1000)
  summoner:SetAttr(eHeroAttr.speed, (self.caster).speed)
  summoner:SetAttr(eHeroAttr.def, (self.caster).def // 10)
  summoner:SetAttr(eHeroAttr.magic_res, (self.caster).magic_res // 10)
  summoner:SetAsRealEntity(1)
  summoner:SetRecordTable(table)
  local summonerEntity = LuaSkillCtrl:AddSummonerRole(summoner)
end

bs_105311.OnArriveAction1 = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local gridList = LuaSkillCtrl:FindEmptyGridsWithinRange((self.caster).x, (self.caster).y, 1)
  if gridList == nil then
    return 
  end
  for i = 0, gridList.Count - 1 do
    self:summoner(gridList[i])
  end
  LuaSkillCtrl:StartAvgWithPauseGame("cpt_imr_s06_4", nil, nil)
  local arriveCallBack2 = BindCallback(self, self.OnArriveAction2)
  LuaSkillCtrl:StartTimer(nil, 60, arriveCallBack2)
end

bs_105311.OnArriveAction2 = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local targetlist = LuaSkillCtrl:FindRolesAroundRole(self.caster)
  for i = 0, targetlist.Count - 1 do
    local targetRole = targetlist[i]
    if targetRole.belongNum == (self.caster).belongNum then
      LuaSkillCtrl:RemoveLife(targetRole.maxHp, self, targetRole, true, nil, true, true)
      LuaSkillCtrl:CallEffect(targetRole, (self.config).effectIdAttack, self)
    end
  end
  LuaSkillCtrl:RemoveLife((self.caster).hp - 1, self, self.caster, true, nil, true, true)
  LuaSkillCtrl:CallEffect(self.caster, (self.config).effectIdAttack, self)
  LuaSkillCtrl:StartAvgWithPauseGame("cpt_imr_s06_5", nil, nil)
  local arriveCallBack3 = BindCallback(self, self.OnArriveAction3)
  LuaSkillCtrl:StartTimer(nil, 8, arriveCallBack3)
end

bs_105311.OnArriveAction3 = function(self)
  -- function num : 0_6 , upvalues : _ENV
  LuaSkillCtrl:ForceEndBattle(true)
end

bs_105311.OnCasterDie = function(self)
  -- function num : 0_7 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_105311

