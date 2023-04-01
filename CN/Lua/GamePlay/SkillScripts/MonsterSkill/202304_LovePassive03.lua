-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_202302 = require("GamePlay.SkillScripts.MonsterSkill.202302_LovePassive02")
local bs_203204 = class("bs_203204", bs_202302)
local base = bs_202302
bs_203204.config = {}
bs_203204.config = setmetatable(bs_203204.config, {__index = base.config})
bs_203204.ctor = function(self)
  -- function num : 0_0
end

bs_203204.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_203204.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:AddPlayerTowerMp(-10000)
  local targetList = LuaSkillCtrl:CallTargetSelect(self, (self.config).select_id, (self.config).select_range)
  if targetList.Count > 0 then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_191, 15)
    LuaSkillCtrl:CallBuff(self, self.caster, 1064, 1000)
  end
end

bs_203204.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_203204

