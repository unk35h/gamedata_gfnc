-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_204702 = class("bs_204702", LuaSkillBase)
local base = LuaSkillBase
bs_204702.config = {actionId_start = 1022, actionId_loop = 1023, actionId_end = 1024, effectId = 11005, effectIdDie = 10922, buffID_1158 = 1158, audioId2 = 88, buffId1 = 175, buffId2 = 1033, buffId3 = 198, buffId4 = 88}
bs_204702.ctor = function(self)
  -- function num : 0_0
end

bs_204702.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_204702_03", 1, self.OnAfterBattleStart)
end

bs_204702.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId1, 1, nil, true)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId2, 1, nil, true)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId3, 1, nil, true)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId4, 1, nil, true)
end

bs_204702.PlaySkill = function(self, data)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffID_1158, 1, 360, true)
  self:CallCasterWait(360)
  LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId_start, 1)
  local arriveCallBack = BindCallback(self, self.CallBack)
  LuaSkillCtrl:StartTimer(nil, 12, arriveCallBack)
end

bs_204702.CallBack = function(self)
  -- function num : 0_4 , upvalues : _ENV
  LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId_loop, 1)
  local arriveCallBack = BindCallback(self, self.Damage)
  self.timer = LuaSkillCtrl:StartTimer(nil, 15, arriveCallBack, self, -1, 15)
  local target = LuaSkillCtrl:GetTargetWithGrid(3, 2)
  self.effect = LuaSkillCtrl:CallEffect(target, (self.config).effectId, self)
  self.loopaudio = LuaSkillCtrl:PlayAuSource(self.caster, (self.config).audioId2)
  local arriveCallBack = BindCallback(self, self.CallBackEnd)
  LuaSkillCtrl:StartTimer(nil, 100, arriveCallBack)
end

bs_204702.Damage = function(self)
  -- function num : 0_5 , upvalues : _ENV
  if self.timer ~= nil and (self.timer):IsOver() then
    self.timer = nil
  end
  local targetlist = LuaSkillCtrl:CallTargetSelect(self, 9, 0)
  if targetlist.Count < 1 then
    return 
  end
  for i = 0, targetlist.Count - 1 do
    local targetRole = (targetlist[i]).targetRole
    local hurt1 = targetRole.maxHp // 3
    local hurt2 = targetRole.maxHp // 30
    if targetRole.roleDataId == 1003 then
      local IfRoleCotainsIgnoreDieBuff = LuaSkillCtrl:RoleContainsBuffFeature(targetRole, (self.config).buffFeature_ignoreDie)
      if IfRoleCotainsIgnoreDieBuff then
        local buff_ignoreDie = LuaSkillCtrl:GetRoleAllBuffsByFeature(targetRole, (self.config).buffFeature_ignoreDie)
        if buff_ignoreDie.Count > 0 then
          for i = 0, buff_ignoreDie.Count - 1 do
            LuaSkillCtrl:DispelBuff(targetRole, (buff_ignoreDie[i]).dataId, 0)
          end
        end
      end
      do
        local IfRoleCotainsInvinciableBuff = LuaSkillCtrl:RoleContainsBuffFeature(targetRole, (self.config).buffFeature_Invinciable)
        if IfRoleCotainsInvinciableBuff and not (targetRole.recordTable).equipSummoner then
          local buff_invinciable = LuaSkillCtrl:GetRoleAllBuffsByFeature(targetRole, (self.config).buffFeature_Invinciable)
          if buff_invinciable.Count > 0 then
            for i = 0, buff_invinciable.Count - 1 do
              LuaSkillCtrl:DispelBuff(targetRole, (buff_invinciable[i]).dataId, 0)
            end
          end
        end
        do
          do
            do
              LuaSkillCtrl:DispelBuff(targetRole, 1252, 0)
              LuaSkillCtrl:RemoveLife(hurt1, self, targetRole, true, nil, true, true)
              LuaSkillCtrl:RemoveLife(hurt2, self, targetRole, true, nil, true, true)
              -- DECOMPILER ERROR at PC124: LeaveBlock: unexpected jumping out DO_STMT

              -- DECOMPILER ERROR at PC124: LeaveBlock: unexpected jumping out DO_STMT

              -- DECOMPILER ERROR at PC124: LeaveBlock: unexpected jumping out DO_STMT

              -- DECOMPILER ERROR at PC124: LeaveBlock: unexpected jumping out IF_THEN_STMT

              -- DECOMPILER ERROR at PC124: LeaveBlock: unexpected jumping out IF_STMT

            end
          end
        end
      end
    end
  end
end

bs_204702.CallBackEnd = function(self)
  -- function num : 0_6 , upvalues : _ENV
  LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId_end, 1)
  if self.effect ~= nil then
    (self.effect):Die()
    self.effect = nil
  end
  if self.timer ~= nil then
    (self.timer):Stop()
    self.timer = nil
  end
  local target = LuaSkillCtrl:GetTargetWithGrid(3, 2)
  self.effect = LuaSkillCtrl:CallEffect(target, (self.config).effectIdDie, self)
  LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId, 0)
  self:CancleCasterWait()
  LuaSkillCtrl:StopAudioByBack(self.loopaudio)
end

bs_204702.OnCasterDie = function(self)
  -- function num : 0_7 , upvalues : base, _ENV
  (base.OnCasterDie)(self)
  if self.effect ~= nil then
    (self.effect):Die()
    self.effect = nil
  end
  if self.timer ~= nil then
    (self.timer):Stop()
    self.timer = nil
  end
  LuaSkillCtrl:StopAudioByBack(self.loopaudio)
  self.loopaudio = nil
end

bs_204702.LuaDispose = function(self)
  -- function num : 0_8 , upvalues : base, _ENV
  (base.LuaDispose)(self)
  if self.effect ~= nil then
    (self.effect):Die()
    self.effect = nil
  end
  if self.timer ~= nil then
    (self.timer):Stop()
    self.timer = nil
  end
  LuaSkillCtrl:StopAudioByBack(self.loopaudio)
  self.loopaudio = nil
end

return bs_204702

