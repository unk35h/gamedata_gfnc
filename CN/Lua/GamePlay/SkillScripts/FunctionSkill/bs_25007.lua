-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_25007 = class("bs_25007", LuaSkillBase)
local base = LuaSkillBase
bs_25007.config = {selectTargetId = 6}
bs_25007.ctor = function(self)
  -- function num : 0_0
end

bs_25007.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.BeforeBattleEnd, "bs_25007_5", 1, self.BeforeEndBattle)
end

bs_25007.BeforeEndBattle = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local targetlist = LuaSkillCtrl:CallTargetSelect(self, (self.config).selectTargetId, 10)
  if targetlist.Count > 0 then
    for i = 0, targetlist.Count - 1 do
      local role = (targetlist[i]).targetRole
      if role.hp * 1000 // role.maxHp < (self.arglist)[1] then
        local value = role.maxHp * (self.arglist)[2] // 1000
        LuaSkillCtrl:CallHeal(value, self, role, true)
      end
    end
  end
end

bs_25007.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_25007

