-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_22001 = class("bs_22001", LuaSkillBase)
local base = LuaSkillBase
bs_22001.config = {buffId = 110039}
bs_22001.ctor = function(self)
  -- function num : 0_0
end

bs_22001.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_22001_1", 1, self.OnAfterBattleStart)
end

bs_22001.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local table = {1007, 1012, 1013, 1018, 1025, 1033, 1036, 1047, 1050, 1052}
  local selfRole = (self.caster).roleDataId
  local listNum = #table
  if listNum ~= 0 then
    for i = 1, listNum do
      local roleIdNow = table[i]
      if roleIdNow == selfRole then
        LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1, (self.arglist)[2], false)
        LuaSkillCtrl:CallStartLocalScale(self.caster, (Vector3.New)(1.3, 1.3, 1.3), 0.2)
        break
      end
    end
  end
end

bs_22001.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_22001

