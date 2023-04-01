-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_200203 = require("GamePlay.SkillScripts.MonsterSkill.200203_SQZ_PurgerAOE")
local bs_203901 = class("bs_203901", bs_200203)
local base = bs_200203
bs_203901.config = {attackTime = 2, select_id = 43}
bs_203901.config = setmetatable(bs_203901.config, {__index = base.config})
bs_203901.ctor = function(self)
  -- function num : 0_0
end

bs_203901.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_203901.OnMoveAttackTrigger = function(self, targetList)
  -- function num : 0_2 , upvalues : _ENV
  if (self.config).audioId1 ~= nil then
    LuaSkillCtrl:PlayAuSource(self.caster, (self.config).audioId1)
  end
  local index = 0
  for i = 0, (self.config).attackTime - 1 do
    if ((targetList[index]).targetRole).intensity == 0 then
      index = 0
    end
    if (targetList[index]).targetRole ~= nil then
      LuaSkillCtrl:CallEffect((targetList[index]).targetRole, (self.config).effectId, self, self.SkillEventFunc)
    end
    index = index + 1
  end
  do
    if targetList.Count > index then
    end
  end
end

bs_203901.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_203901

