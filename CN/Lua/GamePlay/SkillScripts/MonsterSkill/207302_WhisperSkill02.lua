-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_207302 = class("bs_207302", LuaSkillBase)
local base = LuaSkillBase
bs_207302.config = {}
bs_207302.ctor = function(self)
  -- function num : 0_0
end

bs_207302.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_207302_1", 1, self.OnAfterHurt, nil, nil, nil, nil, nil, nil, nil, eSkillTag.commonAttack)
end

bs_207302.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if skill.isCommonAttack and sender == self.caster and not isMiss then
    local skills = target:GetBattleSkillList()
    if skills ~= nil then
      local skillCount = skills.Count
      if skillCount > 0 then
        for j = 0, skillCount - 1 do
          local curTotalCd = (skills[j]).totalCDTime * -1 * (self.arglist)[1] // 1000
          if not (skills[j]).isCommonAttack then
            LuaSkillCtrl:CallResetCDForSingleSkill(skills[j], curTotalCd)
          end
        end
      end
    end
  end
end

bs_207302.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_207302

