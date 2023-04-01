-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_105500 = class("bs_105500", bs_1)
local base = bs_1
bs_105500.config = {effectId_trail = 105501, effectId = 105520}
bs_105500.config = setmetatable(bs_105500.config, {__index = base.config})
bs_105500.ctor = function(self)
  -- function num : 0_0
end

bs_105500.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_105500.RealPlaySkill = function(self, target, data)
  -- function num : 0_2 , upvalues : _ENV, base
  if LuaSkillCtrl:GetCasterSkinId(self.caster) == 305503 then
    LuaSkillCtrl:StartTimer(self, 8, function()
    -- function num : 0_2_0 , upvalues : _ENV, target, self
    LuaSkillCtrl:CallEffect(target, (self.config).effectId, self, nil, nil, nil, nil)
  end
)
  end
  ;
  (base.RealPlaySkill)(self, target, data)
end

bs_105500.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_105500

