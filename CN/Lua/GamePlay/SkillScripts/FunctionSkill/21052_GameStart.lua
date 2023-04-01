-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_21052 = class("bs_21052", LuaSkillBase)
local base = LuaSkillBase
bs_21052.config = {effectId = 10164}
bs_21052.ctor = function(self)
  -- function num : 0_0
end

bs_21052.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_21052_1", 1, self.OnAfterBattleStart)
end

bs_21052.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local skills = (self.caster):GetBattleSkillList()
  if skills ~= nil then
    local count = skills.Count
    if count > 0 then
      for i = 0, count - 1 do
        local curCd = (skills[i]).totalCDTime
        if not (skills[i]).isCommonAttack then
          LuaSkillCtrl:CallResetCDForSingleSkill(skills[i], curCd)
        end
      end
      LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId, self)
    end
  end
end

bs_21052.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_21052

