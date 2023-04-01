-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_21030 = class("bs_21030", LuaSkillBase)
local base = LuaSkillBase
bs_21030.config = {buffId = 110021}
bs_21030.ctor = function(self)
  -- function num : 0_0
end

bs_21030.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_21030_1", 1, self.OnAfterBattleStart)
end

bs_21030.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local targetList = nil
  local Num = 0
  targetList = LuaSkillCtrl:CallTargetSelectWithRange(self, 9, 1)
  if targetList.Count >= 1 then
    for i = 0, targetList.Count - 1 do
      if ((targetList[i]).targetRole).belongNum == 0 and ((targetList[i]).targetRole).intensity == 0 then
        Num = Num + 1
      end
    end
  end
  do
    if Num >= 2 then
      LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1)
      ;
      (self.caster):UpdateHp()
    end
  end
end

bs_21030.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_21030

