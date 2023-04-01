-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_21037 = class("bs_21037", LuaSkillBase)
local base = LuaSkillBase
bs_21037.config = {
HurtConfig = {hit_formula = 0, basehurt_formula = 10186}
}
bs_21037.ctor = function(self)
  -- function num : 0_0
end

bs_21037.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_21037_1", 1, self.OnAfterBattleStart)
  self.Timer = nil
end

bs_21037.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if self.Timer ~= nil then
    (self.Timer):Stop()
    self.Timer = nil
  end
  self.Timer = LuaSkillCtrl:StartTimer(nil, (self.arglist)[1], function()
    -- function num : 0_2_0 , upvalues : _ENV, self
    local highAttRole = LuaSkillCtrl:CallTargetSelect(self, 46, 20)
    if highAttRole ~= nil and highAttRole.Count > 0 and highAttRole[0] ~= nil then
      local targetlist = LuaSkillCtrl:GetAllEnmyRoles()
      if #targetlist > 0 then
        for k,v in pairs(targetlist) do
          local targetRole = v
          local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, targetRole)
          LuaSkillCtrl:HurtResult(self, skillResult, (self.config).HurtConfig, {((highAttRole[0]).targetRole).skill_intensity}, true)
          skillResult:EndResult()
        end
      end
    end
  end
, nil, -1, 0)
end

bs_21037.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

bs_21037.LuaDispose = function(self)
  -- function num : 0_4 , upvalues : base
  (base.LuaDispose)(self)
  if self.Timer ~= nil then
    (self.Timer):Stop()
    self.Timer = nil
  end
end

return bs_21037

