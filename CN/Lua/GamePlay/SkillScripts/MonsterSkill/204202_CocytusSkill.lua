-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_204202 = class("bs_204202", LuaSkillBase)
local base = LuaSkillBase
bs_204202.config = {restBuffId = 204202, restBuffId2 = 204203, select_id = 6, select_range = 10}
bs_204202.ctor = function(self)
  -- function num : 0_0
end

bs_204202.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_204202_1", 1, self.OnAfterBattleStart)
  self:AddAfterHurtTrigger("bs_204202_3", 1, self.OnAfterHurt, nil, nil, (self.caster).belongNum, not (self.caster).belongNum)
  self:AddLuaTrigger(eSkillLuaTrigger.OnRealSummonerCaster, self.CallBuffForSameCamp)
end

bs_204202.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local targetList = LuaSkillCtrl:CallTargetSelect(self, (self.config).select_id, (self.config).select_range)
  if targetList.Count > 0 then
    for i = 0, targetList.Count - 1 do
      if (targetList[i]).targetRole ~= nil then
        self:CallBuffForSameCamp((targetList[i]).targetRole)
      end
    end
  end
end

bs_204202.CallBuffForSameCamp = function(self, role)
  -- function num : 0_3 , upvalues : _ENV
  local camp = role.camp
  if role.roleType == eBattleRoleType.realSummoner then
    camp = LuaSkillCtrl:GetSummonerCamp(role)
  end
  if camp == (self.caster).camp then
    LuaSkillCtrl:CallBuff(self, role, (self.config).restBuffId, 1, nil)
  end
end

bs_204202.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_4 , upvalues : _ENV
  local arg = ((self.caster).recordTable).arg
  if hurtType == eHurtType.MagicDmg and LuaSkillCtrl:CallRange(1, 1000) <= (self.arglist)[2] and target.hp > 0 and sender ~= self.caster then
    LuaSkillCtrl:CallBuff(self, target, (self.config).restBuffId2, 1, arg)
  end
end

bs_204202.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base, _ENV
  (base.OnCasterDie)(self)
  local teamMates = LuaSkillCtrl:GetSelectTeamRoles((self.caster).belongNum)
  if teamMates.Count > 0 then
    for i = 0, teamMates.Count - 1 do
      if (teamMates[i]).hp > 0 then
        LuaSkillCtrl:DispelBuff(teamMates[i], (self.config).restBuffId, 1, true)
      end
    end
  end
end

return bs_204202

