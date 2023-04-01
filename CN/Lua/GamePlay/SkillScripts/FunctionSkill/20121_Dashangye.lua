-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_20121 = class("bs_20121", LuaSkillBase)
local base = LuaSkillBase
bs_20121.config = {buffId = 1126, buffTier = 1, effectId = 10927}
bs_20121.ctor = function(self)
  -- function num : 0_0
end

bs_20121.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_20121_1", 1, self.OnAfterBattleStart)
end

bs_20121.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local target = LuaSkillCtrl:GetTargetWithGrid(3, 2)
  LuaSkillCtrl:CallEffect(target, (self.config).effectId, self)
  local targetlist = LuaSkillCtrl:CallTargetSelect(self, 5, 0)
  if targetlist.Count < 1 then
    return 
  end
  for i = 0, targetlist.Count - 1 do
    local targetRole = (targetlist[i]).targetRole
    if targetRole.hp > 0 then
      LuaSkillCtrl:CallBuff(self, targetRole, (self.config).buffId, (self.config).buffTier, nil, true)
    end
  end
end

bs_20121.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_20121

