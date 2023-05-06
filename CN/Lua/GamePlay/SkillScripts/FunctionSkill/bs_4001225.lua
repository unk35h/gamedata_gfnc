-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_4001225 = class("bs_4001225", LuaSkillBase)
local base = LuaSkillBase
bs_4001225.config = {buffId_fire = 1227, buffId_blood = 195, duration_blood = 75, duration_fire = 90}
bs_4001225.ctor = function(self)
  -- function num : 0_0
end

bs_4001225.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterAddBuffTrigger("bs_4001225", 50, self.OnAfterAddBuff, nil, nil, nil, eBattleRoleBelong.enemy, nil, nil, nil)
end

bs_4001225.OnAfterAddBuff = function(self, buff, target)
  -- function num : 0_2 , upvalues : _ENV
  if buff.dataId == (self.config).buffId_fire then
    LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_blood, 1, (self.config).duration_blood, true)
  end
  if buff.dataId == (self.config).buffId_blood then
    LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_fire, 1, (self.config).duration_fire, true)
  end
end

bs_4001225.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_4001225

