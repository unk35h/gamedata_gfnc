-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_10308 = class("bs_10308", LuaSkillBase)
local base = LuaSkillBase
bs_10308.config = {buffId = 110007}
bs_10308.ctor = function(self)
  -- function num : 0_0
end

bs_10308.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_10308_1", 1, self.OnAfterBattleStart)
end

bs_10308.OnAfterBattleStart = function(self, isMidway)
  -- function num : 0_2 , upvalues : _ENV
  if not isMidway then
    return 
  end
  self:PlayChipEffect()
  LuaSkillCtrl:AddPlayerTowerMp((self.arglist)[1])
  if self.caster == nil then
    return 
  end
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1, (self.arglist)[2])
end

bs_10308.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_10308

