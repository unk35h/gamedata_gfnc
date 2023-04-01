-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_21031 = class("bs_21031", LuaSkillBase)
local base = LuaSkillBase
bs_21031.config = {}
bs_21031.ctor = function(self)
  -- function num : 0_0
end

bs_21031.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_21031_1", 1, self.OnAfterBattleStart)
  self:AddTrigger(eSkillTriggerType.AfterPlaySkill, "bs_21031_13", 1, self.OnAfterPlaySkill)
end

bs_21031.OnAfterBattleStart = function(self)
  -- function num : 0_2
  self.HumNum = 0
end

bs_21031.OnAfterPlaySkill = function(self, skill, role)
  -- function num : 0_3 , upvalues : _ENV
  if skill.isUltSkill and self.HumNum == 0 then
    local value = LuaSkillCtrl:GetUltHMp()
    LuaSkillCtrl:CallAddPlayerHmp((ConfigData.game_config).ultMpCost * (self.arglist)[1] // 10)
    self.HumNum = 1
  end
end

bs_21031.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_21031

