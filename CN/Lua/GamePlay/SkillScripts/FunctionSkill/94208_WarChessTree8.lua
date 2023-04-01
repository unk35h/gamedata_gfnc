-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_94208 = class("bs_94208", LuaSkillBase)
local base = LuaSkillBase
bs_94208.config = {buffIdWind = 502101, buffId = 110064, buffIdStun = 66, buffIdStunWind = 289}
bs_94208.ctor = function(self)
  -- function num : 0_0
end

bs_94208.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterPlaySkill, "bs_94208_13", 1, self.OnAfterPlaySkill)
  self:AddAfterBuffRemoveTrigger("bs_94208_1", 1, self.AfterBuffRemove, nil, eBattleRoleBelong.enemy)
  self:AddBeforeAddBuffTrigger("bs_94208_2", 1, self.OnBeforeAddBuff, nil, nil, nil, eBattleRoleBelong.enemy, (self.config).buffIdStunWind)
end

bs_94208.OnAfterPlaySkill = function(self, skill, role)
  -- function num : 0_2 , upvalues : _ENV
  if skill.maker == self.caster and (skill.dataId == 5021 or skill.dataId == 5022 or skill.dataId == 5023 or skill.dataId == 5024) then
    local targetRole = (skill.selectRoles)[0]
    if targetRole.belongNum == eBattleRoleBelong.player then
      LuaSkillCtrl:DispelBuff(targetRole, (self.config).buffId, 0, false)
      LuaSkillCtrl:CallBuff(self, targetRole, (self.config).buffId, 1, (self.arglist)[2], ture)
    end
  end
end

bs_94208.AfterBuffRemove = function(self, buffId, target, removeType)
  -- function num : 0_3 , upvalues : _ENV
  if buffId == (self.config).buffIdWind then
    LuaSkillCtrl:CallBuff(self, target, (self.config).buffIdStun, 1, (self.arglist)[3])
  end
end

bs_94208.OnBeforeAddBuff = function(self, target, context)
  -- function num : 0_4 , upvalues : _ENV
  if (context.buff).dataId == (self.config).buffIdStunWind then
    context.active = false
    LuaSkillCtrl:DispelBuff(target, (self.config).buffIdStun, 0)
    LuaSkillCtrl:CallBuff(self, target, (self.config).buffIdStun, 1, (self.arglist)[3] + 30)
  end
end

bs_94208.OnBuffDie = function(self, buff, target, removeType)
  -- function num : 0_5 , upvalues : _ENV
  if buff.buffId == (self.config).buffIdWind then
    LuaSkillCtrl:CallBuff(self, target, (self.config).buffIdStun, 1, (self.arglist)[3])
  end
end

bs_94208.OnCasterDie = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_94208

