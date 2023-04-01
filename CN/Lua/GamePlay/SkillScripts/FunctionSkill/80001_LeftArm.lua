-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_80009 = class("bs_80009", LuaSkillBase)
local base = LuaSkillBase
bs_80009.config = {}
bs_80009.ctor = function(self)
  -- function num : 0_0
end

bs_80009.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_80009.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  local atkSpeed = LuaSkillCtrl:CallFormulaNumber(9997, self.caster, self.caster)
  local atkSpeedRatio = self:CalcAtkActionSpeed(atkSpeed, 1)
  LuaSkillCtrl:CallRoleAction(self.caster, 1001, atkSpeedRatio)
end

return bs_80009

