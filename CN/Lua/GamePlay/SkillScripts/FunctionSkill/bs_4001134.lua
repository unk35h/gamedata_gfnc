-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_4010434 = class("bs_4010434", LuaSkillBase)
local base = LuaSkillBase
bs_4010434.config = {buffId = 2095, 
ScaleTable = {0.8, 0.6, 0.5, 0.4}
}
bs_4010434.ctor = function(self)
  -- function num : 0_0
end

bs_4010434.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterPlaySkillTrigger("bs_4010434", 10, self.OnAfterPlaySkill, nil, nil, nil, nil, nil, nil, nil, eSkillTag.ultSkill)
end

bs_4010434.OnAfterPlaySkill = function(self, skill, role)
  -- function num : 0_2 , upvalues : _ENV
  local targetList = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.enemy)
  if targetList.Count < 1 then
    return 
  end
  for i = 0, targetList.Count - 1 do
    LuaSkillCtrl:CallBuff(self, targetList[i], (self.config).buffId, 1, nil, true)
    local tier = (targetList[i]):GetBuffTier((self.config).buffId)
    local scale = ((self.config).ScaleTable)[tier]
    LuaSkillCtrl:CallStartLocalScale(targetList[i], (Vector3.New)(scale, scale, scale), 0.4)
  end
end

bs_4010434.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_4010434

