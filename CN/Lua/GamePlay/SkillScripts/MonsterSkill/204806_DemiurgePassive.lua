-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_204806 = class("bs_204806", LuaSkillBase)
local base = LuaSkillBase
bs_204806.config = {buff_superman = 204801, 
aoe = {effect_shape = 1, aoe_select_code = 2, aoe_range = 10}
, buff_bati = 196, timeDuration = 15}
bs_204806.ctor = function(self)
  -- function num : 0_0
end

bs_204806.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_204806_1", 1, self.OnAfterBattleStart)
  self:AddTrigger(eSkillTriggerType.RoleDie, "bs_204801", 10, self.OnRoleDie)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buff_bati, 1)
  self.totalTime = 1800
  self.timeValue = self.totalTime
  LuaSkillCtrl:SetGameScoreAcitve(2, true)
  LuaSkillCtrl:SetGameScoreValue(2, self.timeValue // 15)
  LuaSkillCtrl:RecordLimitTime(self.totalTime)
end

bs_204806.OnRoleDie = function(self, killer, role)
  -- function num : 0_2 , upvalues : _ENV
  local role1 = role
  local camp = role.camp
  if role.roleType == eBattleRoleType.realSummoner then
    camp = LuaSkillCtrl:GetSummonerCamp(role)
  end
  if camp == (self.caster).camp and role1.hp == 0 and role1 ~= nil then
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, self.caster, (self.config).aoe)
    if (skillResult.roleList).Count <= 0 then
      return 
    end
    for i = 0, (skillResult.roleList).Count - 1 do
      if ((skillResult.roleList)[i]).camp == (self.caster).camp then
        LuaSkillCtrl:CallBuff(self, (skillResult.roleList)[i], (self.config).buff_superman, 1, (self.arglist)[1])
      end
    end
  end
end

bs_204806.OnAfterBattleStart = function(self)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:StartTimer(nil, 15, (BindCallback(self, self.CountDown)), nil, 119, 15)
end

bs_204806.CountDown = function(self)
  -- function num : 0_4 , upvalues : _ENV
  self.timeValue = self.timeValue - (self.config).timeDuration
  local showTime = self.timeValue // 15
  LuaSkillCtrl:SetGameScoreValue(2, showTime)
  if self.timeValue <= 0 then
    LuaSkillCtrl:ForceEndBattle(false)
  end
end

bs_204806.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_204806

