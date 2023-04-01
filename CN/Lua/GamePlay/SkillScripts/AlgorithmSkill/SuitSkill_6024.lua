-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_6024 = class("bs_6024", LuaSkillBase)
local base = LuaSkillBase
bs_6024.config = {buffId_1 = 602401}
bs_6024.ctor = function(self)
  -- function num : 0_0
end

bs_6024.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterPlaySkillTrigger("bs_6024_13", 1, self.OnAfterPlaySkill, self.caster, nil, nil, nil, nil, nil, nil, eSkillTag.normalSkill)
end

bs_6024.OnAfterPlaySkill = function(self, skill, role)
  -- function num : 0_2 , upvalues : _ENV
  local targetList = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.player)
  if targetList ~= nil and targetList.Count > 0 then
    for i = 0, targetList.Count - 1 do
      local role = targetList[i]
      LuaSkillCtrl:CallBuff(self, role, (self.config).buffId_1, 1, (self.arglist)[2], true)
    end
  end
end

bs_6024.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_6024

