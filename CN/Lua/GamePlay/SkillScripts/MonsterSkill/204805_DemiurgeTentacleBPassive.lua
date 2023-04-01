-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_204805 = class("bs_204805", LuaSkillBase)
local base = LuaSkillBase
bs_204805.config = {buff = 2048039, buffFeature_ignoreDie = 6, buffId_SuperArmor = 2048036, buffId_attackCD = 104205, start_time = 13}
bs_204805.ctor = function(self)
  -- function num : 0_0
end

bs_204805.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:SelfDie()
end

bs_204805.SelfDie = function(self)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buff, 1)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_SuperArmor, 1)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_attackCD, 1, (self.config).start_time, true)
  LuaSkillCtrl:StartTimer(self, (self.arglist)[1], function()
    -- function num : 0_2_0 , upvalues : _ENV, self
    local IfRoleCotainsIgnoreDieBuff = LuaSkillCtrl:RoleContainsBuffFeature(self.caster, (self.config).buffFeature_ignoreDie)
    if IfRoleCotainsIgnoreDieBuff == true then
      local buff_ignoreDie = LuaSkillCtrl:GetRoleAllBuffsByFeature(self.caster, (self.config).buffFeature_ignoreDie)
      if buff_ignoreDie.Count > 0 then
        for i = 0, buff_ignoreDie.Count - 1 do
          LuaSkillCtrl:DispelBuff(self.caster, (buff_ignoreDie[i]).dataId, 0)
          IfRoleCotainsIgnoreDieBuff = false
        end
      end
    end
    do
      if (self.caster).hp > 0 and IfRoleCotainsIgnoreDieBuff == false then
        LuaSkillCtrl:RemoveLife((self.caster).hp, self, self.caster, true, nil, false, true, eHurtType.RealDmg, true)
      end
    end
  end
)
end

bs_204805.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

bs_204805.LuaDispose = function(self)
  -- function num : 0_4 , upvalues : base
  (base.LuaDispose)(self)
end

return bs_204805

