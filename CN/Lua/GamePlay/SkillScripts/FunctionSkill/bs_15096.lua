-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_15096 = class("bs_15096", LuaSkillBase)
local base = LuaSkillBase
bs_15096.config = {fenEnBuff = 101901}
bs_15096.ctor = function(self)
  -- function num : 0_0
end

bs_15096.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddBeforeAddBuffTrigger("bs_15096_3", 2, self.OnBeforeAddBuff, self.caster, nil, nil, eBattleRoleBelong.enemy, 101901)
  self:AddAfterAddBuffTrigger("bs_15096_2", 1, self.OnAfterAddBuff, self.caster, nil, nil, eBattleRoleBelong.enemy, nil, nil, eBuffFeatureType.BeatBack)
end

bs_15096.OnAfterAddBuff = function(self, buff, target)
  -- function num : 0_2 , upvalues : _ENV
  if target.belongNum == eBattleRoleBelong.enemy and self:IsReadyToTake() then
    local skills = (self.caster):GetBattleSkillList()
    if skills ~= nil then
      local skillCount = skills.Count
      if skillCount > 0 then
        for j = 0, skillCount - 1 do
          local curTotalCd = (skills[j]).totalCDTime * (self.arglist)[1] // 1000
          if not (skills[j]).isCommonAttack then
            LuaSkillCtrl:CallResetCDForSingleSkill(skills[j], curTotalCd)
          end
        end
      end
    end
    do
      self:OnSkillTake()
    end
  end
end

bs_15096.OnBeforeAddBuff = function(self, target, context)
  -- function num : 0_3 , upvalues : _ENV
  if target.belongNum == eBattleRoleBelong.enemy and self:IsReadyToTake() then
    local skills = (self.caster):GetBattleSkillList()
    if skills ~= nil then
      local skillCount = skills.Count
      if skillCount > 0 then
        for j = 0, skillCount - 1 do
          local curTotalCd = (skills[j]).totalCDTime * (self.arglist)[1] // 1000
          if not (skills[j]).isCommonAttack then
            LuaSkillCtrl:CallResetCDForSingleSkill(skills[j], curTotalCd)
          end
        end
      end
    end
    do
      self:OnSkillTake()
    end
  end
end

bs_15096.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_15096

