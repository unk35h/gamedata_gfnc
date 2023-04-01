-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_10322 = class("bs_10322", LuaSkillBase)
local base = LuaSkillBase
bs_10322.config = {}
bs_10322.ctor = function(self)
  -- function num : 0_0
end

bs_10322.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_10322_4", 1, self.OnAfterHurt, self.caster)
end

bs_10322.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if sender == self.caster and hurtType == eHurtType.MagicDmg and self:IsReadyToTake() and LuaSkillCtrl:CallRange(1, 1000) <= (self.arglist)[1] then
    local skills = (self.caster):GetBattleSkillList()
    if skills ~= nil then
      local skillCount = skills.Count
      if skillCount > 0 then
        for j = 0, skillCount - 1 do
          local curTotalCd = (skills[j]).totalCDTime * (self.arglist)[2] // 1000
          if not (skills[j]).isCommonAttack then
            self:OnSkillTake()
            LuaSkillCtrl:CallResetCDForSingleSkill(skills[j], curTotalCd)
          end
        end
      end
    end
  end
end

bs_10322.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_10322

