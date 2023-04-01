-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_102101 = class("bs_102101", LuaSkillBase)
local base = LuaSkillBase
bs_102101.config = {effectId_Grid = 10709, buffId_lockCD = 170, audioId1 = 77, 
AOE = {effect_shape = 3, aoe_select_code = 4, aoe_range = 10}
, weaponLv = 0, buffId_dodge_weapon = 102103, buffId_hot_weapon = 102101, effectId_hot_weapon = 102107, effectId_all_weapon = 102105, buffId_ys = 102107}
bs_102101.ctor = function(self)
  -- function num : 0_0
end

bs_102101.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_102101_3", 1, self.OnAfterHurt, nil, nil, nil, (self.caster).belongNum, nil, eBattleRoleType.character)
end

bs_102101.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if isMiss and target.roleType == eBattleRoleType.character and target.belongNum == (self.caster).belongNum then
    if (self.config).weaponLv >= 2 then
      LuaSkillCtrl:CallResetCDNumForRole(self.caster, (self.arglist)[1] + (self.arglist)[2])
    else
      if (self.caster):GetBuffTier((self.config).buffId_lockCD) == 0 then
        LuaSkillCtrl:CallResetCDNumForRole(self.caster, (self.arglist)[1])
      end
    end
    if (self.config).weaponLv >= 3 then
      LuaSkillCtrl:CallBuff(self, sender, (self.config).buffId_ys, 1, (self.arglist)[4])
    end
  end
end

bs_102101.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

bs_102101.LuaDispose = function(self)
  -- function num : 0_4 , upvalues : base
  (base.LuaDispose)(self)
end

return bs_102101

