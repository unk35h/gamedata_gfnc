-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_91020 = class("bs_91020", LuaSkillBase)
local base = LuaSkillBase
bs_91020.config = {buffId1 = 2031}
bs_91020.ctor = function(self)
  -- function num : 0_0
end

bs_91020.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_91020_1", 1, self.OnAfterBattleStart)
  self.hp_value = 0
  self.highHpTarget = nil
end

bs_91020.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local targetList = LuaSkillCtrl:CallTargetSelect(self, 69, 10)
  if targetList.Count > 0 then
    self.highHpTarget = (targetList[0]).targetRole
    self.hp_value = ((targetList[0]).targetRole).maxHp * (self.arglist)[1] * (self.arglist)[2] // 1000000
    LuaSkillCtrl:CallBuff(self, self.highHpTarget, (self.config).buffId1, 1)
    ;
    (self.highHpTarget):UpdateHp()
    self:PlayChipEffect()
  end
  local targetListAll = LuaSkillCtrl:CallTargetSelect(self, 6, 10)
  if targetListAll.Count > 0 then
    for i = 0, targetListAll.Count - 1 do
      if (targetListAll[i]).targetRole ~= self.highHpTarget then
        LuaSkillCtrl:CallAddRoleProperty((targetListAll[i]).targetRole, eHeroAttr.maxHp, self.hp_value, eHeroAttrType.Extra)
        ;
        ((targetListAll[i]).targetRole):UpdateHp()
      end
    end
  end
end

bs_91020.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_91020

