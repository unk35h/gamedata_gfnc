-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_93042 = class("bs_93042", LuaSkillBase)
local base = LuaSkillBase
bs_93042.config = {}
bs_93042.ctor = function(self)
  -- function num : 0_0
end

bs_93042.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_93042_1", 1, self.OnAfterHurt, nil, self.caster, nil, (self.caster).belongNum, nil, nil, nil, nil, false)
end

bs_93042.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R9 in 'UnsetPending'

  if self.caster == target and isMiss and not isTriggerSet then
    if (sender.recordTable).bs_93042 == nil then
      (sender.recordTable).bs_93042 = 0
    end
    -- DECOMPILER ERROR at PC17: Confused about usage of register: R9 in 'UnsetPending'

    ;
    (sender.recordTable).bs_93042 = (sender.recordTable).bs_93042 + 1
    if (self.arglist)[1] <= (sender.recordTable).bs_93042 then
      local buffs = LuaSkillCtrl:GetRoleBuffs(context.target)
      if buffs == nil or buffs.Count < 1 then
        return 
      end
      for i = 0, buffs.Count - 1 do
        if (buffs[i]).buffType == eBuffType.Debeneficial then
          local buffId = (buffs[i]).dataID
          local buffDuration = (buffs[i]).totalTime
          LuaSkillCtrl:CallBuff(self, sender, buffId, 1, buffDuration, true)
        end
      end
    end
  end
end

bs_93042.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_93042

