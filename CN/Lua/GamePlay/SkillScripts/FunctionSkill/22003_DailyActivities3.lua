-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_22003 = class("bs_22003", LuaSkillBase)
local base = LuaSkillBase
bs_22003.config = {buffId = 110041}
bs_22003.ctor = function(self)
  -- function num : 0_0
end

bs_22003.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_22003_1", 1, self.OnAfterBattleStart)
end

bs_22003.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local table = {1005, 1006, 1007, 1019, 1028, 1029, 1032, 1033, 1036, 1045, 1048}
  local selfRole = (self.caster).roleDataId
  local listNum = #table
  if listNum ~= 0 then
    for i = 1, listNum do
      local roleIdNow = table[i]
      if roleIdNow == selfRole then
        LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1, nil, false)
        LuaSkillCtrl:CallStartLocalScale(self.caster, (Vector3.New)(1.3, 1.3, 1.3), 0.2)
        break
      end
    end
  end
end

bs_22003.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_22003

