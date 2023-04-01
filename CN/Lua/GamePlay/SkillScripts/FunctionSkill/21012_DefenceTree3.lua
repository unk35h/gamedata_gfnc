-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_21012 = class("bs_21012", LuaSkillBase)
local base = LuaSkillBase
bs_21012.config = {
hurt_config = {hit_formula = 0, basehurt_formula = 10187, crit_formula = 0}
, effectId = 10945}
bs_21012.ctor = function(self)
  -- function num : 0_0
end

bs_21012.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHealTrigger("bs_21012_1", 1, self.OnAfterHeal, self.caster)
end

bs_21012.OnAfterHeal = function(self, sender, target, skill, heal, isStealHeal, isCrit, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if sender == self.caster and not isTriggerSet then
    local targetlist = (LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.enemy))
    local role = nil
    if targetlist.Count > 0 then
      for i = 0, targetlist.Count - 1 do
        if (targetlist[i]).belongNum == eBattleRoleBelong.enemy then
          if role == nil then
            role = targetlist[i]
          else
            if (targetlist[i]).hp <= role.hp then
              role = targetlist[i]
            end
          end
        end
      end
    end
    do
      local value = heal * (self.arglist)[1] // 1000
      local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, role)
      LuaSkillCtrl:HurtResult(self, skillResult, (self.config).hurt_config, {value}, true)
      LuaSkillCtrl:CallEffect(role, (self.config).effectId, self)
      skillResult:EndResult()
    end
  end
end

bs_21012.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_21012

