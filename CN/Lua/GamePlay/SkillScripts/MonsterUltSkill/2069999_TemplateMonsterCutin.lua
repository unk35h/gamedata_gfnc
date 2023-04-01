-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_2069999 = class("bs_2069999", LuaSkillBase)
local base = LuaSkillBase
bs_2069999.config = {delayInvoke = 20, actionId_start = 1001, buffId_Super = 3003}
bs_2069999.PlaySkill = function(self, data, selectTargetCoord, selectRoles)
  -- function num : 0_0 , upvalues : _ENV
  self:OnMonsterUltPlay(data, selectTargetCoord, selectRoles, true, BindCallback(self, self.ExecuteUltSkill))
end

bs_2069999.ExecuteUltSkill = function(self)
  -- function num : 0_1 , upvalues : _ENV
  print("实际释放逻辑")
end

bs_2069999.PlayUltEffect = function(self)
  -- function num : 0_2 , upvalues : base, _ENV
  (base.PlayUltEffect)(self)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_Super, 1, 15, true)
  LuaSkillCtrl:CallFocusTimeLine(self.caster)
end

bs_2069999.OnUltRoleAction = function(self)
  -- function num : 0_3 , upvalues : base, _ENV
  (base.OnUltRoleAction)(self)
  LuaSkillCtrl:StartTimerInUlt(self, 15, self.PlayUltMovie)
  LuaSkillCtrl:CallRoleAction(self.caster, 1005)
end

return bs_2069999

