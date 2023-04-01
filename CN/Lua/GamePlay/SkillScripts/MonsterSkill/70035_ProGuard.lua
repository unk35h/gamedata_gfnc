-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_70035 = class("bs_70035", LuaSkillBase)
local base = LuaSkillBase
bs_70035.config = {timeDuration = 15, animID = 1002, animLoopTime = 30, formula1 = 10153, formula2 = 10154, formula3 = 10155, nanaka_buffId = 102603, buffId_endure = 198, buffId_cantSelect = 60501, buffId_slow = 60502, buffId_live = 3009, campNotBeSelectBuff = 50, audioId1 = 389, audioId2 = 390}
bs_70035.ctor = function(self)
  -- function num : 0_0
end

bs_70035.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_70035_1", 0, self.OnAfterBattleStart)
  self:AddSetHealTrigger("bs_70035_5", 1, self.OnSetHeal, nil, self.caster)
  self:AddBeforeAddBuffTrigger("bs_70035_6", 1, self.OnBeforeAddBuff, nil, self.caster, eBattleRoleBelong.player)
  self:AddTrigger(eSkillTriggerType.BeforeBattleEnd, "bs_70035_7", 0, self.OnBeforeBattleEnd)
  -- DECOMPILER ERROR at PC36: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).IsGuardPro = true
end

bs_70035.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_endure, 1, nil, true)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_cantSelect, 1, nil, true)
  local targetlist = LuaSkillCtrl:CallTargetSelect(self, 2, 10)
  if targetlist.Count <= 0 then
    return 
  end
  for i = 0, targetlist.Count - 1 do
    local targetRole = (targetlist[i]).targetRole
    if targetRole.belongNum ~= 0 then
      LuaSkillCtrl:CallBuff(self, targetRole, (self.config).buffId_slow, 1, nil, true)
    end
  end
end

bs_70035.OnSetHeal = function(self, context)
  -- function num : 0_3
  if context.target == self.caster then
    context.heal = 0
  end
end

bs_70035.OnSetHurt = function(self, context)
  -- function num : 0_4
  if context.target == self.caster then
    local hurt = (self.caster).maxHp // (self.arglist)[1] + 1
    context.hurt = hurt
  end
end

bs_70035.OnBeforeAddBuff = function(self, target, context)
  -- function num : 0_5
  if (context.buff).maker == self.caster then
    return 
  end
  context.active = false
end

bs_70035.OnBeforeBattleEnd = function(self)
  -- function num : 0_6 , upvalues : _ENV
  if LuaSkillCtrl.IsInVerify then
    return 
  end
  local playerList = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.player)
  if playerList == nil then
    return 
  end
  for i = 0, playerList.Count - 1 do
    local role = playerList[i]
    if not role.isDead then
      (role.roleView):ClearDeadAnimation()
    end
  end
end

bs_70035.OnCasterDie = function(self)
  -- function num : 0_7 , upvalues : base, _ENV
  (base.OnCasterDie)(self)
  LuaSkillCtrl:ForceEndBattle(false)
end

return bs_70035

