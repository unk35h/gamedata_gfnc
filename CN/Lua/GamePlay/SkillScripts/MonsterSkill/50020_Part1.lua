-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("GamePlay.SkillScripts.MonsterSkill.50023_equipmentCommonSkill")
local bs_50020 = class("bs_50020", base)
bs_50020.config = {configId_Repel = 3, effectId_Repel = 5002001, effectId_Repel_hit = 5002002, attack_time = 11, selectId_skill = 10001, buffId_Repel = 5002001, buffId_stun = 3006}
bs_50020.ctor = function(self)
  -- function num : 0_0
end

bs_50020.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_50020.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local caster = LuaSkillCtrl:GetEquipmentSummonerOrHostEntity(self.caster)
  self.skill = LuaSkillCtrl:StartTimer(nil, (self.arglist)[1], (BindCallback(self, self.OnRepel, caster)), nil, -1, (self.arglist)[1])
end

bs_50020.OnRepel = function(self, caster)
  -- function num : 0_3 , upvalues : _ENV, base
  LuaSkillCtrl:CallEffect(caster, (self.config).effectId_Repel, self)
  LuaSkillCtrl:CallRoleAction(self.caster, 1002, 1)
  LuaSkillCtrl:StartTimer(self, (self.config).attack_time, function()
    -- function num : 0_3_0 , upvalues : _ENV, self, caster, base
    local targetList = LuaSkillCtrl:CallTargetSelectWithRange(self, (self.config).selectId_skill, 1, caster)
    if targetList.Count > 0 then
      for i = 0, targetList.Count - 1 do
        local role = (targetList[i]).targetRole
        if LuaSkillCtrl:IsAbleAttackTarget(caster, role, caster.attackRange) and role.belongNum ~= caster.belongNum then
          (base.OnSyncAttrFromHost)(self, caster)
          local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, role)
          LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).configId_Repel, {(self.arglist)[2]}, true)
          skillResult:EndResult()
        end
        if role.intensity == 0 and role.belongNum == eBattleRoleBelong.neutral then
          do
            LuaSkillCtrl:CallBuff(self, role, (self.config).buffId_Repel, 1, 3)
            LuaSkillCtrl:CallBuff(self, role, (self.config).buffId_stun, 1, (self.arglist)[3] + 3)
            LuaSkillCtrl:CallEffect(role, (self.config).effectId_Repel_hit, self)
            -- DECOMPILER ERROR at PC89: LeaveBlock: unexpected jumping out IF_THEN_STMT

            -- DECOMPILER ERROR at PC89: LeaveBlock: unexpected jumping out IF_STMT

          end
        end
      end
    end
  end
)
end

bs_50020.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
  if self.skill ~= nil then
    (self.skill):Stop()
    self.skill = nil
  end
end

return bs_50020

