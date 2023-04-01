-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_10326 = class("bs_10326", LuaSkillBase)
local base = LuaSkillBase
bs_10326.config = {Attack1BuffId = 1264}
bs_10326.ctor = function(self)
  -- function num : 0_0
end

bs_10326.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_10326_14", 90, self.OnAfterHurt, nil, nil, (self.caster).belongNum)
end

bs_10326.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if isCrit and self:IsReadyToTake() and not isTriggerSet then
    local targetlist = LuaSkillCtrl:CallTargetSelect(self, 6, 10)
    if targetlist.Count ~= 0 then
      for i = 0, targetlist.Count - 1 do
        LuaSkillCtrl:CallBuff(self, (targetlist[i]).targetRole, (self.config).Attack1BuffId, 1, 75, true)
      end
    end
  end
end

bs_10326.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_10326

