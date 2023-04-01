-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_206900 = class("bs_206900", LuaSkillBase)
local base = LuaSkillBase
bs_206900.config = {timeDuration = 15, action1 = 1008, action2 = 1007, action3 = 1025, formula1 = 10153, formula2 = 10154, formula3 = 10155, noDeadBuff = 32, noDamageBuff = 88, HideBuff = 3004, unSelectableBuff = 50}
local MonsterState = {normal = 0, overkill = 3}
FoolBattleGroupTimer = {[16] = 450, [20] = 675, [21] = 675}
bs_206900.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_0 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  local sceneId = ((LuaSkillCtrl.battleCtrl).BattleRoomData):GetSceneId()
  local time = FoolBattleGroupTimer[sceneId] or 675
  self.totalTime = time
  self.isAlone = false
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_206900_1", 1, self.OnAfterBattleStart)
  self:AddSetDeadHurtTrigger("bs_206900_2", 1, self.OnSetDeadHurt, nil, self.caster)
  self:AddSetHurtTrigger("bs_206900_3", 999, self.OnSetHurt, nil, self.caster)
  self:AddSetHealTrigger("bs_206900_4", 999, self.OnSetHeal, nil, self.caster)
  self:AddTrigger(eSkillTriggerType.OnBattleEnd, "bs_206900_5", 1, self.OnBattleEnd)
end

bs_206900.OnSetHeal = function(self, context)
  -- function num : 0_1 , upvalues : MonsterState
  if self.state ~= MonsterState.overkill then
    return 
  end
  context.heal = 0
end

bs_206900.OnSetDeadHurt = function(self, context)
  -- function num : 0_2 , upvalues : MonsterState, _ENV
  if context.isMiss or self.state == MonsterState.overkill then
    return 
  end
  if not self.isAlone then
    local teamMates = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.enemy)
    local teamMateCount = teamMates.Count
    if teamMateCount > 1 then
      for i = teamMateCount - 1, 0, -1 do
        local role = teamMates[i]
        if role ~= self.caster then
          local target = LuaSkillCtrl:GetTargetWithGrid(role.x, role.y)
          LuaSkillCtrl:CallEffect(target, 206900, self)
          if not LuaSkillCtrl.IsInVerify then
            ((role.lsObject).gameObject):SetActive(false)
          end
          role:SubHp(role.maxHp)
          role:OnDead(self.caster, self.cskill)
        end
      end
    end
    do
      do
        self.isAlone = true
        LuaSkillCtrl:CallRoleAction(self.caster, (self.config).action1)
        self:EnterOverKill()
      end
    end
  end
end

bs_206900.EnterOverKill = function(self)
  -- function num : 0_3 , upvalues : MonsterState, _ENV
  self.state = MonsterState.overkill
  local target = LuaSkillCtrl:GetTargetWithGrid((self.caster).x, (self.caster).y)
  LuaSkillCtrl:CallEffect(target, 206902, self)
end

bs_206900.OnSetHurt = function(self, context)
  -- function num : 0_4 , upvalues : MonsterState, _ENV
  if self.state ~= MonsterState.overkill then
    return 
  end
  self.overkillDamage = self.overkillDamage + context.hurt
  MsgCenter:Broadcast(eMsgEventId.OnOverKillValueChange, self.overkillDamage, false)
  LuaSkillCtrl:CallEffect(self.caster, 206901, self)
  LuaSkillCtrl:SetGameScoreValue(3, self.overkillDamage)
end

bs_206900.OnAfterBattleStart = function(self)
  -- function num : 0_5 , upvalues : MonsterState, _ENV
  self.isAlone = false
  self:CheckIsAlone()
  self.state = MonsterState.normal
  self.overkillDamage = 0
  LuaSkillCtrl:SetGameScoreAcitve(2, true)
  LuaSkillCtrl:SetGameScoreValue(2, self.totalTime // 15)
  LuaSkillCtrl:RecordLimitTime(self.totalTime)
  local timeInvoker = BindCallback(self, self.TimeUpdate)
  self.timer = LuaSkillCtrl:StartTimer(nil, (self.config).timeDuration, timeInvoker, self, -1)
  LuaSkillCtrl:CallBuff(self, self.caster, 198, 1, nil, true)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).noDeadBuff, 1, nil, true)
end

bs_206900.CheckIsAlone = function(self)
  -- function num : 0_6 , upvalues : _ENV
  local teamMates = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.enemy)
  self.isAlone = teamMates.Count <= 1
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

bs_206900.TimeUp = function(self)
  -- function num : 0_7 , upvalues : _ENV, MonsterState
  self.timer = nil
  local score = ((self.caster).maxHp - (self.caster).hp + self.overkillDamage) * 1000 // (self.caster).maxHp
  LuaSkillCtrl:SetFinalScoreValue(2, score)
  LuaSkillCtrl:SetFinalScoreValue(3, self.overkillDamage)
  MsgCenter:Broadcast(eMsgEventId.OnOverKillValueChange, self.overkillDamage, true)
  local result = self.state == MonsterState.overkill
  LuaSkillCtrl:ForceEndBattle(result)
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

bs_206900.TimeUpdate = function(self)
  -- function num : 0_8 , upvalues : _ENV
  self.totalTime = self.totalTime - (self.config).timeDuration
  local showTime = self.totalTime // 15
  LuaSkillCtrl:SetGameScoreValue(2, showTime)
  if self.totalTime <= 0 then
    self:TimeUp()
  end
end

bs_206900.OnBattleEnd = function(self)
  -- function num : 0_9 , upvalues : _ENV
  if self.timer ~= nil then
    (self.timer):Stop()
    self.timer = nil
  end
  MsgCenter:Broadcast(eMsgEventId.OnOverKillValueChange, self.overkillDamage, true)
end

bs_206900.OnCasterDie = function(self)
  -- function num : 0_10 , upvalues : base
  (base.OnCasterDie)(self)
  if self.timer ~= nil then
    (self.timer):Stop()
    self.timer = nil
  end
end

bs_206900.LuaDispose = function(self)
  -- function num : 0_11 , upvalues : base
  (base.LuaDispose)(self)
  if self.timer ~= nil then
    (self.timer):Stop()
    self.timer = nil
  end
  self.overkillDamage = nil
end

return bs_206900

