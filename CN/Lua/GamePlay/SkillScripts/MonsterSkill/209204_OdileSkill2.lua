-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_209204 = class("bs_209204", LuaSkillBase)
local base = LuaSkillBase
bs_209204.config = {skill_time = 25, actionId = 1020, action_speed = 1, start_time = 8, monsterId = 51, effectId_summon = 209210, effectId_summoner = 209211}
bs_209204.ctor = function(self)
  -- function num : 0_0
end

bs_209204.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self.SummonerTable = {53, 54, 55, 56}
end

bs_209204.PlaySkill = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local attackTrigger = BindCallback(self, self.OnAttackTrigger)
  self:CallCasterWait((self.config).skill_time)
  LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).actionId, (self.config).action_speed, (self.config).start_time, attackTrigger)
  LuaSkillCtrl:CallBuff(self, self.caster, 170, 1, (self.config).skill_time)
  self:AbandonSkillCdAutoReset(true)
end

bs_209204.OnAttackTrigger = function(self)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_summon, self)
  for i = 1, (self.arglist)[5] do
    do
      LuaSkillCtrl:StartTimer(self, i * 4, function()
    -- function num : 0_3_0 , upvalues : self, i
    self:Summon(i)
  end
, nil)
    end
  end
  self:EndSkillAndCallNext()
end

bs_209204.Summon = function(self, num)
  -- function num : 0_4 , upvalues : _ENV
  local Grid = LuaSkillCtrl:FindRoleRightEmptyGrid(self.caster, 10)
  if Grid == nil then
    Grid = LuaSkillCtrl:CallFindEmptyGridNearest(self.caster)
  end
  if Grid ~= nil then
    local target = LuaSkillCtrl:GetTargetWithGrid(Grid.x, Grid.y)
    LuaSkillCtrl:CallEffect(target, (self.config).effectId_summoner, self)
    local summoner = nil
    if num ~= 5 then
      summoner = LuaSkillCtrl:CreateSummoner(self, (self.config).monsterId, Grid.x, Grid.y)
    else
      local length = #self.SummonerTable
      local id = LuaSkillCtrl:CallRange(1, length)
      summoner = LuaSkillCtrl:CreateSummoner(self, (self.SummonerTable)[id], Grid.x, Grid.y)
    end
    do
      summoner:SetAttr(eHeroAttr.maxHp, (self.caster).maxHp * (self.arglist)[1] // 1000)
      summoner:SetAttr(eHeroAttr.skill_intensity, (self.caster).skill_intensity * (self.arglist)[2] // 1000)
      summoner:SetAttr(eHeroAttr.pow, (self.caster).pow * (self.arglist)[2] // 1000)
      summoner:SetAttr(eHeroAttr.speed, (self.caster).speed)
      summoner:SetAttr(eHeroAttr.moveSpeed, (self.caster).moveSpeed)
      summoner:SetAttr(eHeroAttr.def, (self.caster).def * (self.arglist)[3] // 1000)
      summoner:SetAttr(eHeroAttr.magic_res, (self.caster).magic_res * (self.arglist)[3] // 1000)
      summoner:SetAttr(eHeroAttr.lucky, self.lucky)
      summoner:SetAttr(eHeroAttr.sunder, (self.caster).sunder)
      summoner:SetAttr(eHeroAttr.magic_pen, (self.caster).magic_pen)
      summoner:SetAsRealEntity(1)
      local arg1 = (self.arglist)[4]
      local tab = {arg_1 = arg1}
      summoner:SetRecordTable(tab)
      LuaSkillCtrl:AddSummonerRole(summoner)
    end
  end
end

bs_209204.EndSkillAndCallNext = function(self)
  -- function num : 0_5 , upvalues : _ENV
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
  LuaSkillCtrl:StopShowSkillDurationTime(self)
end

bs_209204.OnCasterDie = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_209204

