-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_92091 = class("bs_92091", LuaSkillBase)
local base = LuaSkillBase
bs_92091.config = {buffId = 2073}
bs_92091.ctor = function(self)
  -- function num : 0_0
end

bs_92091.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterPlaySkill, "bs_92091_1", 1, self.OnAfterPlaySkill)
end

bs_92091.OnAfterPlaySkill = function(self, skill, role)
  -- function num : 0_2 , upvalues : _ENV
  if skill.skillTag ~= eSkillTag.ultSkill then
    return 
  end
  local buffTier = role:GetBuffTier((self.config).buffId)
  if buffTier < 1 then
    return 
  end
  LuaSkillCtrl:CallAddPlayerHmp((ConfigData.game_config).ultMpCost * (self.arglist)[1] * buffTier // 1000)
end

bs_92091.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_92091

