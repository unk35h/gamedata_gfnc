-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_207904 = class("bs_207904", LuaSkillBase)
local base = LuaSkillBase
bs_207904.config = {hurt_config = 3, buffId_151 = 151, skill_time = 38, skill_speed = 1, start_time = 13, startAnimId = 1020, effectId_JXG = 207910, effectId_DG = 207911, effectId_AOE = 207912, effectId_JT = 207913, monsterId1 = 44, monsterId2 = 45, maxHpPer = 50, powPer = 1000}
bs_207904.ctor = function(self)
  -- function num : 0_0
end

bs_207904.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.RoleDie, "bs_207904_1", 1, self.OnRoleDie)
  self.A_num = 0
  self.B_num = 0
end

bs_207904.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBreakAllSkill(self.caster)
  local attackTrigger = BindCallback(self, self.OnAttackTrigger, data)
  self:CallCasterWait((self.config).skill_time)
  LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).startAnimId, (self.config).skill_speed, (self.config).start_time, attackTrigger)
  self:AbandonSkillCdAutoReset(true)
end

bs_207904.OnAttackTrigger = function(self, data)
  -- function num : 0_3 , upvalues : _ENV
  self:EndSkillAndCallNext()
  local number = 1 - (self.caster).attackRange
  local targetList = LuaSkillCtrl:CallTargetSelect(self, 9, number)
  if targetList ~= nil then
    for i = 0, targetList.Count - 1 do
      LuaSkillCtrl:CallEffect((targetList[i]).targetRole, (self.config).effectId_JT, self)
      local buff = LuaSkillCtrl:CallBuff(self, (targetList[i]).targetRole, (self.config).buffId_151, 1, 10)
    end
  end
  do
    LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_JXG, self, nil, nil, nil, true)
    local targetList = LuaSkillCtrl:CallTargetSelect(self, 9, 10)
    if targetList.Count <= 0 then
      return 
    end
    for i = 0, targetList.Count - 1 do
      LuaSkillCtrl:CallEffectWithArg((targetList[i]).targetRole, (self.config).effectId_AOE, self, false, false, self.SkillEventFunc)
      local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, (targetList[i]).targetRole)
      LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).hurt_config, {(self.arglist)[1]})
    end
    LuaSkillCtrl:StartTimer(nil, 4, (BindCallback(self, self.SummonAll)), nil)
  end
end

bs_207904.SummonAll = function(self)
  -- function num : 0_4 , upvalues : _ENV
  if self.A_num < 3 then
    local num = 3 - self.A_num
    for i = 1, num do
      LuaSkillCtrl:StartTimer(nil, i * 3, function()
    -- function num : 0_4_0 , upvalues : _ENV, self
    local grid = LuaSkillCtrl:CallFindEmptyGridNearest(self.caster)
    if grid ~= nil then
      self:summoner(grid, "A")
      self.A_num = self.A_num + 1
    end
  end
, self, 0, 3)
    end
  end
  do
    if self.B_num < 3 then
      local num = 3 - self.B_num
      local ALLtargetList = LuaSkillCtrl:CallTargetSelect(self, 9, 10)
      local num_ex = 3 - self.B_num
      for i = 1, num do
        for j = 0, ALLtargetList.Count - 1 do
          if (ALLtargetList[j]).targetRole ~= nil then
            local role = (ALLtargetList[j]).targetRole
            if role ~= nil then
              local grid_role = LuaSkillCtrl:CallFindEmptyGridNearest(role)
              if grid_role ~= nil and LuaSkillCtrl:GetGridsDistance(role.x, role.y, grid_role.x, grid_role.y) == 1 then
                self:summoner(grid_role, "B")
                self.B_num = self.B_num + 1
              end
            end
          end
        end
      end
    end
    do
      if num_ex <= self.B_num or num_ex > self.B_num then
      end
    end
  end
end

bs_207904.summoner = function(self, grid, team)
  -- function num : 0_5 , upvalues : _ENV
  local x = grid.x
  local y = grid.y
  local target = LuaSkillCtrl:GetTargetWithGrid(grid.x, grid.y)
  if not ((self.caster).recordTable).CasterSkill then
    local cskill = self.cskill
  end
  local summoner = LuaSkillCtrl:CreateSummonerWithCSkill(cskill, (self.config).monsterId1, x, y)
  summoner:SetAttr(eHeroAttr.maxHp, (self.caster).maxHp * (self.config).maxHpPer // 1000)
  summoner:SetAttr(eHeroAttr.pow, (self.caster).pow * (self.config).powPer // 1000)
  summoner:SetAttr(eHeroAttr.skill_intensity, (self.caster).skill_intensity * (self.config).powPer // 1000)
  summoner:SetAttr(eHeroAttr.speed, (self.caster).speed)
  summoner:SetAttr(eHeroAttr.def, (self.caster).def // 10)
  summoner:SetAttr(eHeroAttr.magic_res, (self.caster).magic_res // 10)
  summoner:SetAsRealEntity(1)
  local table = {team1 = team}
  summoner:SetRecordTable(table)
  local summonerEntity = LuaSkillCtrl:AddSummonerRole(summoner)
  LuaSkillCtrl:CallEffect(summonerEntity, (self.config).effectId_DG, self)
end

bs_207904.OnRoleDie = function(self, killer, role)
  -- function num : 0_6
  if (role.recordTable).team1 == "B" and role.roleDataId == (self.config).monsterId1 then
    self.B_num = self.B_num - 1
  else
    if (role.recordTable).team1 == "A" and role.roleDataId == (self.config).monsterId1 then
      self.A_num = self.A_num - 1
    end
  end
end

bs_207904.SkillEventFunc = function(self, effect, eventId, target)
  -- function num : 0_7 , upvalues : _ENV
  if effect.dataId == (self.config).effectId_JT and eventId == eBattleEffectEvent.Trigger then
    local targetRole = target.targetRole
  end
end

bs_207904.EndSkillAndCallNext = function(self)
  -- function num : 0_8
  if self.caster == nil then
    return 
  end
  self:CancleCasterWait()
  local skillMgr = (self.caster):GetSkillComponent()
  if skillMgr == nil then
    return 
  end
  skillMgr.lastSkill = self.cskill
  self:CallNextBossSkill()
end

bs_207904.OnCasterDie = function(self)
  -- function num : 0_9 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_207904

