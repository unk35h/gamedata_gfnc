-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("GamePlay.SkillScripts.RoleFSkill.FakeCommonPassive")
local bs_1009012 = class("bs_1009012", base)
bs_1009012.config = {buffId_speed = 10090101}
bs_1009012.ctor = function(self)
  -- function num : 0_0
end

bs_1009012.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_1009012_1", 1, self.OnAfterBattleStart)
end

bs_1009012.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local targetList = LuaSkillCtrl:FindRolesAroundRole(self.caster)
  if targetList ~= nil and targetList.Count > 0 then
    for i = 0, targetList.Count - 1 do
      local role = targetList[i]
      if role.y == (self.caster).y and role.belongNum == (self.caster).belongNum then
        LuaSkillCtrl:CallBuff(self, role, (self.config).buffId_speed, 1)
      end
    end
  end
end

bs_1009012.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_1009012

