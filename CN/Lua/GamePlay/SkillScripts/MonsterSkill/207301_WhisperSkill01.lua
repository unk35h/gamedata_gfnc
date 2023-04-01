-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_207301 = class("bs_207301", LuaSkillBase)
local base = LuaSkillBase
bs_207301.config = {effectId = 207303, effectId1 = 207302, HurtConfigID = 3, effectId_ex = 210004, effectId1_ex = 210003}
bs_207301.ctor = function(self)
  -- function num : 0_0
end

bs_207301.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_207301.PlaySkill = function(self)
  -- function num : 0_2 , upvalues : _ENV
  self:RemoveSkillTrigger(eSkillTriggerType.AfterHurt)
  self:AddAfterHurtTrigger("bs_207301_1", 1, self.OnAfterHurt, nil, nil, nil, nil, nil, nil, nil, eSkillTag.commonAttack)
  self.moveTimer = LuaSkillCtrl:StartTimer(nil, (self.arglist)[1], function()
    -- function num : 0_2_0 , upvalues : self, _ENV
    self:RemoveSkillTrigger(eSkillTriggerType.AfterHurt)
    -- DECOMPILER ERROR at PC7: Confused about usage of register: R0 in 'UnsetPending'

    ;
    ((self.caster).recordTable).onAction2 = nil
  end
)
  -- DECOMPILER ERROR at PC22: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.caster).recordTable).onAction2 = true
end

bs_207301.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_3 , upvalues : _ENV
  if skill.isCommonAttack and sender == self.caster and not isMiss then
    if self.dataID == 210003 then
      LuaSkillCtrl:CallEffect(target, (self.config).effectId1_ex, self)
    else
      LuaSkillCtrl:CallEffect(target, (self.config).effectId1, self)
    end
    local targetList = LuaSkillCtrl:FindAllRolesWithinRange(target, 1, false)
    if targetList.Count > 0 then
      for i = 0, targetList.Count - 1 do
        local skills = (targetList[i]):GetBattleSkillList()
        if (targetList[i]).belongNum ~= (self.caster).belongNum then
          if skills ~= nil then
            local skillCount = skills.Count
            if skillCount > 0 then
              for j = 0, skillCount - 1 do
                local curTotalCd = (skills[j]).totalCDTime * -1 * (self.arglist)[3] // 1000
                if not (skills[j]).isCommonAttack then
                  LuaSkillCtrl:CallResetCDForSingleSkill(skills[j], curTotalCd)
                end
              end
            end
          end
          do
            do
              local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, targetList[i])
              LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).HurtConfigID, {(self.arglist)[2]}, true)
              skillResult:EndResult()
              if self.dataID == 210003 then
                LuaSkillCtrl:CallEffect(targetList[i], (self.config).effectId_ex, self)
              else
                LuaSkillCtrl:CallEffect(targetList[i], (self.config).effectId, self)
              end
              -- DECOMPILER ERROR at PC112: LeaveBlock: unexpected jumping out DO_STMT

              -- DECOMPILER ERROR at PC112: LeaveBlock: unexpected jumping out IF_THEN_STMT

              -- DECOMPILER ERROR at PC112: LeaveBlock: unexpected jumping out IF_STMT

            end
          end
        end
      end
    end
  end
end

bs_207301.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  if self.moveTimer ~= nil then
    (self.moveTimer):Stop()
    self.moveTimer = nil
  end
  ;
  (base.OnCasterDie)(self)
end

bs_207301.LuaDispose = function(self)
  -- function num : 0_5 , upvalues : base
  if self.moveTimer ~= nil then
    (self.moveTimer):Stop()
    self.moveTimer = nil
  end
  ;
  (base.LuaDispose)(self)
end

return bs_207301

