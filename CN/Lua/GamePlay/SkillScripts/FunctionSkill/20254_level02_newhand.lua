-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_20254 = class("bs_20254", LuaSkillBase)
local base = LuaSkillBase
bs_20254.config = {}
bs_20254.ctor = function(self)
  -- function num : 0_0
end

bs_20254.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_20254_1", 1, self.OnAfterBattleStart)
end

bs_20254.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  self.HumNum = 0
  if self.HumNum == 0 then
    local value = LuaSkillCtrl:GetUltHMp()
    LuaSkillCtrl:CallAddPlayerHmp((ConfigData.game_config).ultMpCost * (self.arglist)[1] // 10)
    self.HumNum = 1
  end
end

bs_20254.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_20254

