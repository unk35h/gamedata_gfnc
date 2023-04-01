-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_22004 = class("bs_22004", LuaSkillBase)
local base = LuaSkillBase
bs_22004.config = {buffId = 110042}
bs_22004.ctor = function(self)
  -- function num : 0_0
end

bs_22004.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_22004_1", 1, self.OnAfterBattleStart)
end

bs_22004.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local table = {1002, 1005, 1009, 1014, 1016, 1018, 1019, 1020, 1024, 1029, 1034, 1040, 1042, 1049, 1051, 1052, 1053}
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

bs_22004.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_22004

