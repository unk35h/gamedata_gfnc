-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_310702 = class("bs_310702", LuaSkillBase)
local base = LuaSkillBase
bs_310702.config = {buffId_doblueTower = 196, buffId_down = 110047, buffId_downDam = 110046, buffId_Atk1 = 110048, buffId_Atk2 = 110049, buffId_Atk3 = 110050, buffId_Luk = 110054, buffId_stun = 7, audioId_caijin = 104808}
bs_310702.ctor = function(self)
  -- function num : 0_0
end

bs_310702.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddLuaTrigger(eSkillLuaTrigger.OnRealSummonerCaster, self.OnRealSummonerCaster)
  self:AddSelfTrigger(eSkillTriggerType.BuffDie, "bs_310702_2", 1, self.OnBuffDie)
  self:AddSelfTrigger(eSkillTriggerType.AfterBattleStart, "bs_310702_1", 1, self.OnAfterBattleStart)
end

bs_310702.OnRealSummonerCaster = function(self, role)
  -- function num : 0_2 , upvalues : _ENV
  if role ~= self.caster then
    return val
  end
  if self.caster == nil or (self.caster).hp <= 0 then
    return 
  end
  LuaSkillCtrl:StartTimer(self, 1, function()
    -- function num : 0_2_0 , upvalues : _ENV, self
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_Atk1, 3, (self.arglist)[2], true)
  end
)
end

bs_310702.OnAfterBattleStart = function(self, role)
  -- function num : 0_3 , upvalues : _ENV
  if self.caster == nil or (self.caster).hp <= 0 then
    return 
  end
  LuaSkillCtrl:StartTimer(self, 1, function()
    -- function num : 0_3_0 , upvalues : _ENV, self
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_Atk1, 3, (self.arglist)[2], true)
  end
)
end

bs_310702.OnBuffDie = function(self, buff, target, removeType)
  -- function num : 0_4 , upvalues : _ENV
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
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_downDam, 1, nil, true)
    LuaSkillCtrl:CallRoleAction(self.caster, 1, 1)
  end
  if buff.dataId == (self.config).buffId_Luk then
    LuaSkillCtrl:CallBreakAllSkill(self.caster)
    LuaSkillCtrl:PlayAuSource(self.caster, (self.config).audioId_caijin)
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_down, 1, nil, true)
    LuaSkillCtrl:CallRoleAction(self.caster, 1, 1)
  end
end

bs_310702.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_310702

