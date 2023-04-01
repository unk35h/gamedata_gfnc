-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_210002 = class("bs_210002", LuaSkillBase)
local base = LuaSkillBase
bs_210002.config = {buffId_1 = 210001}
bs_210002.ctor = function(self)
  -- function num : 0_0
end

bs_210002.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_210002_1", 9, self.OnAfterHurt, self.caster, nil, nil, nil, nil, nil, nil, eSkillTag.commonAttack)
  self:AddSelfTrigger(eSkillTriggerType.AfterPlaySkill, "bs_210002_2", 1, self.OnAfterPlaySkill)
end

bs_210002.OnAfterPlaySkill = function(self, skill, role)
  -- function num : 0_2 , upvalues : _ENV
  if role == self.caster and skill.isCommonAttack ~= true and role:GetBuffTier((self.config).buffId_1) < (self.arglist)[4] then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_1, 1)
  end
end

bs_210002.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_3 , upvalues : _ENV
  if sender == self.caster and skill.isCommonAttack == true and isMiss ~= true and isTriggerSet ~= true then
    local skil_1 = target:GetBattleSkillList()
    if skil_1 ~= nil then
      local skillCount = skil_1.Count
      if skillCount > 0 then
        for j = 0, skillCount - 1 do
          local curTotalCd = (skil_1[j]).totalCDTime * -1 * (self.arglist)[1] // 1000
          if not (skil_1[j]).isCommonAttack then
            LuaSkillCtrl:CallResetCDForSingleSkill(skil_1[j], curTotalCd)
          end
        end
      end
    end
    do
      local skills = sender:GetBattleSkillList()
      if skills ~= nil then
        local skillCount = skills.Count
        if skillCount > 0 then
          for j = 0, skillCount - 1 do
            local curTotalCd = (skills[j]).totalCDTime * (self.arglist)[2] // 1000
            if not (skills[j]).isCommonAttack then
              LuaSkillCtrl:CallResetCDForSingleSkill(skills[j], curTotalCd)
            end
          end
        end
      end
    end
  end
end

bs_210002.PlaySkill = function(self, data)
  -- function num : 0_4
end

bs_210002.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_210002

