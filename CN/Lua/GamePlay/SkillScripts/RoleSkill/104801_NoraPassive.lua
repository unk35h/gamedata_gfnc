-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_104801 = class("bs_104801", LuaSkillBase)
local base = LuaSkillBase
bs_104801.config = {buffId_down = 104801, buffId_Atk1 = 104802, buffId_Atk2 = 104803, buffId_Atk3 = 104804, buffId_Luk = 104808, buffId_stun = 7, audioId_caijin = 104808}
bs_104801.ctor = function(self)
  -- function num : 0_0
end

bs_104801.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSelfTrigger(eSkillTriggerType.AfterBattleStart, "bs_104801_1", 1, self.OnAfterBattleStart)
  self:AddSelfTrigger(eSkillTriggerType.BuffDie, "bs_104801_2", 1, self.OnBuffDie)
end

bs_104801.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if self.caster == nil or (self.caster).hp <= 0 then
    return 
  end
  LuaSkillCtrl:StartTimer(nil, 1, function()
    -- function num : 0_2_0 , upvalues : _ENV, self
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_Atk1, 3, (self.arglist)[2], true)
  end
)
end

bs_104801.OnBuffDie = function(self, buff, target, removeType)
  -- function num : 0_3 , upvalues : _ENV
  if target ~= self.caster then
    return 
  end
  if buff.dataId == (self.config).buffId_Atk1 then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_Atk2, 2, (self.arglist)[2], true)
  end
  if buff.dataId == (self.config).buffId_Atk2 then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_Atk3, 1, (self.arglist)[2], true)
  end
  if buff.dataId == (self.config).buffId_Atk3 then
    LuaSkillCtrl:CallBreakAllSkill(self.caster)
    LuaSkillCtrl:PlayAuSource(self.caster, (self.config).audioId_caijin)
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_down, 1, nil, true)
    LuaSkillCtrl:CallRoleAction(self.caster, 1037, 1)
    LuaSkillCtrl:CallRoleAction(self.caster, 1041, 1)
  end
  if buff.dataId == (self.config).buffId_Luk then
    LuaSkillCtrl:CallBreakAllSkill(self.caster)
    LuaSkillCtrl:PlayAuSource(self.caster, (self.config).audioId_caijin)
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_down, 1, nil, true)
    LuaSkillCtrl:CallRoleAction(self.caster, 1037, 1)
    LuaSkillCtrl:CallRoleAction(self.caster, 1041, 1)
  end
end

bs_104801.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  self:BreakLieDown()
  ;
  (base.OnCasterDie)(self)
end

bs_104801.BreakLieDown = function(self)
  -- function num : 0_5 , upvalues : _ENV
  LuaSkillCtrl:CallRoleAction(self.caster, 1042, 1)
end

return bs_104801

