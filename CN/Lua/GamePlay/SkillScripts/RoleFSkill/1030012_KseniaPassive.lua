-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("GamePlay.SkillScripts.RoleFSkill.FakeCommonPassive")
local bs_1030012 = class("bs_1030012", base)
bs_1030012.config = {buffId_int = 103000}
bs_1030012.ctor = function(self)
  -- function num : 0_0
end

bs_1030012.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_1030012_1", 10, self.OnAfterBattleStart)
end

bs_1030012.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local targetList = LuaSkillCtrl:FindRolesAroundRole(self.caster)
  if targetList ~= nil and targetList.Count > 0 then
    for i = 0, targetList.Count - 1 do
      local role = targetList[i]
      if role.y == (self.caster).y and role.x == (self.caster).x + 1 and role.belongNum == (self.caster).belongNum then
        LuaSkillCtrl:CallBuff(self, role, (self.config).buffId_int, 1)
        -- DECOMPILER ERROR at PC41: Confused about usage of register: R7 in 'UnsetPending'

        ;
        ((self.caster).recordTable).pass_target = role
      end
    end
  end
end

bs_1030012.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_1030012

