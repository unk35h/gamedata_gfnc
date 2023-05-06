-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_100802 = class("bs_100802", LuaSkillBase)
local base = LuaSkillBase
bs_100802.config = {buffId_160 = 100801, skill_time = 15, buffId_170 = 3008, weaponLv = 0, buffId_atk = 100804}
bs_100802.ctor = function(self)
  -- function num : 0_0
end

bs_100802.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_100802.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  local buff_time = (self.config).skill_time + (self.arglist)[1]
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_160, 1, buff_time, true)
  self:CallCasterWait((self.config).skill_time)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_170, 1, buff_time, true)
  LuaSkillCtrl:CallRoleAction(self.caster, 1002)
  LuaSkillCtrl:StartShowSkillDurationTime(self, buff_time)
  if (self.config).weaponLv >= 3 then
    local targetList = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.player)
    if targetList.Count > 0 then
      for i = 0, targetList.Count - 1 do
        local role = targetList[i]
        if role ~= nil and role.hp > 0 and role.roleType ~= eBattleRoleType.realSummoner then
          LuaSkillCtrl:CallBuff(self, targetList[i], (self.config).buffId_atk, 1, (self.arglist)[3])
        end
      end
    end
  end
end

bs_100802.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_100802

