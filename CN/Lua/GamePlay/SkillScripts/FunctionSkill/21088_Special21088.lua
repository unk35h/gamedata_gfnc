-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_21088 = class("bs_21088", LuaSkillBase)
local base = LuaSkillBase
bs_21088.config = {buffId = 110036}
bs_21088.ctor = function(self)
  -- function num : 0_0
end

bs_21088.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_21088_1", 1, self.OnAfterBattleStart)
end

bs_21088.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local targetlist = LuaSkillCtrl:CallTargetSelect(self, 9, 10)
  local buffTier = 0
  if targetlist.Count > 0 then
    for i = 0, targetlist.Count - 1 do
      if ((targetlist[i]).targetRole).belongNum == eBattleRoleBelong.enemy then
        buffTier = buffTier + 1
      end
    end
    buffTier = (buffTier) * (self.arglist)[1] // 10
  end
  local selflist = LuaSkillCtrl:CallTargetSelect(self, 6, 10)
  if selflist.Count > 0 then
    for i = 0, selflist.Count - 1 do
      LuaSkillCtrl:CallBuff(self, (selflist[i]).targetRole, (self.config).buffId, buffTier, nil)
    end
  end
end

bs_21088.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_21088

