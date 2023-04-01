-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_104609 = class("bs_104609", LuaSkillBase)
local base = LuaSkillBase
bs_104609.config = {buffId_inspire = 1046021, 
hurt_config = {crit_formula = 9992, crithur_ratio = 9995}
, buffId_1 = 104602}
bs_104609.ctor = function(self)
  -- function num : 0_0
end

bs_104609.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddHurtResultStartTrigger("bs_104609_15", 40, self.OnHurtResultStart, self.caster, nil, eBattleRoleBelong.player)
end

bs_104609.OnHurtResultStart = function(self, skill, context)
  -- function num : 0_2 , upvalues : _ENV
  if skill.skillType == eBattleSkillLogicType.Original and not skill.isCommonAttack and (context.sender):GetBuffTier((self.config).buffId_inspire) > 0 and context.sender == self.caster and not context.isTriggerSet and context.extraArg ~= (ConfigData.buildinConfig).HurtIgnoreKey and context.hurt_type ~= 2 then
    local critFurmula = (context.config).crit_formula
    if critFurmula == nil or critFurmula == 0 then
      context.new_config = (self.config).hurt_config
      setmetatable(context.new_config, {__index = context.config})
      return 
    end
    local hazeWeaponLv = ((self.caster).recordTable).haze_weaponLv
    if hazeWeaponLv ~= nil and hazeWeaponLv > 0 and (critFurmula ~= 0 or critFurmula ~= nil) then
      local number = hazeWeaponLv
      if (self.caster):GetBuffTier((self.config).buffId_1) <= 0 then
        LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_1, number, 1, true)
      end
    end
  end
end

bs_104609.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_104609

