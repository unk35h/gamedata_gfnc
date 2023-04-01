-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_15100 = class("bs_15100", LuaSkillBase)
local base = LuaSkillBase
bs_15100.config = {buffId = 110091}
bs_15100.ctor = function(self)
  -- function num : 0_0
end

bs_15100.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterPlaySkillTrigger("bs_15100_13", 1, self.OnAfterPlaySkill, nil, nil, (self.caster).belongNum, nil, nil, nil, nil, eSkillTag.ultSkill)
end

bs_15100.OnAfterPlaySkill = function(self, skill, role)
  -- function num : 0_2 , upvalues : _ENV
  if skill.isUltSkill then
    local targetList = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.player)
    if targetList == nil then
      return 
    end
    if targetList.Count > 0 then
      for i = 0, targetList.Count - 1 do
        local targetRole = targetList[i]
        local buffTier = targetRole:GetBuffTier((self.config).buffId)
        if targetRole.roleType == eBattleRoleType.character and buffTier < (self.arglist)[3] then
          LuaSkillCtrl:CallBuff(self, targetRole, (self.config).buffId, 1, (self.arglist)[2])
        end
      end
    end
  end
end

bs_15100.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_15100

