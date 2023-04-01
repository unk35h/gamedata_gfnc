-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_80018 = class("bs_80018", LuaSkillBase)
local base = LuaSkillBase
bs_80018.config = {curCd = 30, buffId_doblueTower = 196}
bs_80018.ctor = function(self)
  -- function num : 0_0
end

bs_80018.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_80018_1", 1, self.OnAfterBattleStart)
end

bs_80018.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:StartTimer(self, 1, function()
    -- function num : 0_2_0 , upvalues : _ENV, self
    local targetList = LuaSkillCtrl:CallTargetSelect(self, 9, 10)
    if targetList.Count > 0 then
      for i = 0, targetList.Count - 1 do
        local targetListRole = (targetList[i]).targetRole
        LuaSkillCtrl:DispelBuff(targetListRole, (self.config).buffId_doblueTower, 0)
      end
    end
  end
)
  LuaSkillCtrl:CallCreateEfcGrid(0, 0, 22)
  LuaSkillCtrl:CallCreateEfcGrid(6, 0, 22)
  LuaSkillCtrl:CallCreateEfcGrid(0, 4, 22)
  LuaSkillCtrl:CallCreateEfcGrid(6, 4, 22)
end

bs_80018.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_80018

