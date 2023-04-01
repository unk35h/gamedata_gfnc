-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_104200 = class("bs_104200", bs_1)
local base = bs_1
bs_104200.config = {effectId_1 = 104201, effectId_2 = 104202, audioId3 = 104202}
bs_104200.config = setmetatable(bs_104200.config, {__index = base.config})
bs_104200.ctor = function(self)
  -- function num : 0_0
end

bs_104200.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_104200.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  if self.loopTimer ~= nil then
    (self.loopTimer):Stop()
    self.loopTimer = nil
  end
  ;
  (base.OnCasterDie)(self)
end

bs_104200.LuaDispose = function(self)
  -- function num : 0_3 , upvalues : base
  if self.loopTimer ~= nil then
    (self.loopTimer):Stop()
    self.loopTimer = nil
  end
  ;
  (base.LuaDispose)(self)
end

return bs_104200

