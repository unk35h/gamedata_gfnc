-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_209201 = class("bs_209201", LuaSkillBase)
local base = LuaSkillBase
bs_209201.config = {buffId = 209201, buffId_Boss = 3017}
bs_209201.ctor = function(self)
  -- function num : 0_0
end

bs_209201.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddLuaTrigger(eSkillLuaTrigger.OnRealSummonerCaster, self.OnRealSummonerCaster)
  self:AddTrigger(eSkillTriggerType.RoleDie, "bs_209201_1", 1, self.OnRoleDie)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_209201_2", 1, self.OnAfterBattleStart)
end

bs_209201.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local breakComponent = (self.caster):GetBreakComponent()
  if breakComponent == nil then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_Boss, 1, nil, true)
  end
  self:addBuffStart()
end

bs_209201.OnRealSummonerCaster = function(self, summonerEntity)
  -- function num : 0_3
  if summonerEntity.belongNum == (self.caster).belongNum then
    self:addBuff()
  end
end

bs_209201.OnRoleDie = function(self, killer, role)
  -- function num : 0_4
  if role.belongNum == (self.caster).belongNum then
    self:deleteBuff()
  end
end

bs_209201.addBuffStart = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local targetList = LuaSkillCtrl:CallTargetSelect(self, 2, 10)
  local targetsNum = targetList.Count
  if targetsNum > 0 then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, targetsNum)
  end
end

bs_209201.addBuff = function(self)
  -- function num : 0_6 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1)
end

bs_209201.deleteBuff = function(self)
  -- function num : 0_7 , upvalues : _ENV
  LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId, 1)
end

bs_209201.OnCasterDie = function(self)
  -- function num : 0_8 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_209201

