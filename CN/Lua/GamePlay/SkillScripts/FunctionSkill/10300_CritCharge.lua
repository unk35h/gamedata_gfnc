-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_10300 = class("bs_10300", LuaSkillBase)
local base = LuaSkillBase
bs_10300.config = {}
bs_10300.ctor = function(self)
  -- function num : 0_0
end

bs_10300.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1
  self:AddAfterHurtTrigger("bs_10300_3", 1, self.OnAfterHurt, self.caster)
end

bs_10300.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if self:IsReadyToTake() and sender == self.caster and isCrit and skill.isCommonAttack then
    local skills = (self.caster):GetBattleSkillList()
    if skills ~= nil then
      local skillCount = skills.Count
      if skillCount > 0 then
        for j = 0, skillCount - 1 do
          local curTotalCd = (skills[j]).totalCDTime * (self.arglist)[1] // 1000
          LuaSkillCtrl:CallResetCDForSingleSkill(skills[j], curTotalCd)
          self:OnSkillTake()
        end
      end
    end
    do
      self:PlayChipEffect()
    end
  end
end

bs_10300.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_10300

