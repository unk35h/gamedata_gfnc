-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_301102 = require("GamePlay.SkillScripts.MonsterSkill.301102_Control2")
local bs_206610 = class("bs_206610", bs_301102)
local base = bs_301102
bs_206610.config = {deathRoleId = 40031, monsterId = 36, effectId = 10264, selfDeathTime = 5}
bs_206610.config = setmetatable(bs_206610.config, {__index = base.config})
bs_206610.ctor = function(self)
  -- function num : 0_0
end

bs_206610.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_206610.OnAfterBattleStart = function(self)
  -- function num : 0_2
end

bs_206610.Death = function(self)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:RemoveLife((self.caster).hp + 1, self, self.caster, true, nil, false, true)
end

bs_206610.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_206610

