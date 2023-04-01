-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_22002 = class("bs_22002", LuaSkillBase)
local base = LuaSkillBase
bs_22002.config = {buffId = 110040}
bs_22002.ctor = function(self)
  -- function num : 0_0
end

bs_22002.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_22002_1", 1, self.OnAfterBattleStart)
end

bs_22002.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local table = {1016, 1028, 1033, 1044, 1043}
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

bs_22002.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_22002

