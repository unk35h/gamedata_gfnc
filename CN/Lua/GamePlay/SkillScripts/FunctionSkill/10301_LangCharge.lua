-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_10301 = class("bs_10301", LuaSkillBase)
local base = LuaSkillBase
bs_10301.config = {eatEffectId = 10735, stunBuff = 110006}
bs_10301.ctor = function(self)
  -- function num : 0_0
end

bs_10301.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddLuaTrigger(eSkillLuaTrigger.OnWaveCollision, self.OnWaveCollision)
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable)["10301_flag"] = true
end

bs_10301.OnWaveCollision = function(self, entity)
  -- function num : 0_2 , upvalues : _ENV
  if entity == self.caster then
    local skills = entity:GetBattleSkillList()
    if skills ~= nil then
      local skillCount = skills.Count
      if skillCount > 0 then
        for j = 0, skillCount - 1 do
          local curTotalCd = (skills[j]).totalCDTime * (self.arglist)[1] // 1000
          if not (skills[j]).isCommonAttack then
            LuaSkillCtrl:CallResetCDForSingleSkill(skills[j], curTotalCd)
            LuaSkillCtrl:CallEffect(entity, (self.config).eatEffectId, self)
          end
        end
      end
    end
  end
end

bs_10301.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_10301

