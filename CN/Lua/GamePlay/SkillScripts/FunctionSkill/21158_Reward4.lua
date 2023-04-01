-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_21158 = class("bs_21158", LuaSkillBase)
local base = LuaSkillBase
bs_21158.config = {buffId = 110033}
bs_21158.ctor = function(self)
  -- function num : 0_0
end

bs_21158.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_21158_1", 1, self.OnAfterBattleStart)
end

bs_21158.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local targetlist = LuaSkillCtrl:CallTargetSelectWithRange(self, 6, 1)
  if targetlist.Count > 0 then
    for i = 0, targetlist.Count - 1 do
      if (targetlist[i]).targetRole ~= self.caster and LuaSkillCtrl:IsRoleAdjacent((targetlist[i]).targetRole, self.caster) then
        LuaSkillCtrl:CallBuff(self, (targetlist[i]).targetRole, (self.config).buffId, 1, nil)
      end
    end
  end
end

bs_21158.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_21158

