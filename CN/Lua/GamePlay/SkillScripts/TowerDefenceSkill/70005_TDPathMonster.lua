-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_70005 = class("bs_70005", LuaSkillBase)
local base = LuaSkillBase
bs_70005.config = {buffId_god = 3009, pathBuffId = 1201}
bs_70005.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_0 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:OnAfterBattleStart()
end

bs_70005.OnAfterBattleStart = function(self)
  -- function num : 0_1 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_god, 1, 29, true)
end

bs_70005.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  local arriveCallBack = BindCallback(self, self.OnArriveAction)
  LuaSkillCtrl:StartTimer(nil, 30, arriveCallBack)
end

bs_70005.OnArriveAction = function(self)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_god, 0, true)
  LuaSkillCtrl:DispelBuff(self.caster, (self.config).pathBuffId, 0, true)
  LuaSkillCtrl:RemoveLife((self.caster).hp + 1, self, self.caster, true, nil, false, true)
end

bs_70005.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_70005

