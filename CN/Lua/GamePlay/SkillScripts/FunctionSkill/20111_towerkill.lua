-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_20111 = class("bs_20111", LuaSkillBase)
local base = LuaSkillBase
bs_20111.config = {}
bs_20111.ctor = function(self)
  -- function num : 0_0
end

bs_20111.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.BeforeBattleEnd, "bs_20111", 1, self.BeforeEndBattle)
end

bs_20111.BeforeEndBattle = function(self)
  -- function num : 0_2 , upvalues : _ENV
  self:DispelTargetBuffFeature(eBuffFeatureType.Invinciable)
  self:DispelTargetBuffFeature(eBuffFeatureType.NoDeath)
  LuaSkillCtrl:LoadOffTowerCharacter(self.caster, false)
end

bs_20111.DispelTargetBuffFeature = function(self, buffFeatureId)
  -- function num : 0_3 , upvalues : _ENV
  local targetBuffList = LuaSkillCtrl:GetRoleAllBuffsByFeature(self.caster, buffFeatureId)
  if targetBuffList == nil or targetBuffList.Count <= 0 then
    return 
  end
  for i = 0, targetBuffList.Count - 1 do
    LuaSkillCtrl:DispelBuff(self.caster, (targetBuffList[i]).dataId, 0)
  end
end

bs_20111.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_20111

