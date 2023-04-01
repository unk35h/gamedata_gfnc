-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_7013 = class("bs_7013", LuaSkillBase)
local base = LuaSkillBase
bs_7013.config = {}
bs_7013.ctor = function(self)
  -- function num : 0_0
end

bs_7013.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self.damTimer = LuaSkillCtrl:StartTimer(nil, 15, self.CallBack, self, -1)
  self:AddBuffDieTrigger("bs_7013_1", 1, self.OnBuffDie, self.caster, nil, 105)
end

bs_7013.OnBuffDie = function(self, buff, target, removeType)
  -- function num : 0_2
  if buff.dataId == 195 and (self.caster):GetBuffTier(195) <= 0 and self.damTimer ~= nil then
    (self.damTimer):Stop()
    self.damTimer = nil
  end
end

bs_7013.CallBack = function(self)
  -- function num : 0_3 , upvalues : _ENV
  if self.damTimer ~= nil and (self.damTimer):IsOver() then
    self.damTimer = nil
  end
  if self.caster == nil then
    if self.damTimer ~= nil then
      (self.damTimer):Stop()
      self.damTimer = nil
    end
    return 
  end
  local num = (self.caster):GetBuffTier(195)
  local attack_int = 0
  local pass_target1 = nil
  local targetList = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.player)
  if targetList ~= nil and targetList.Count > 0 then
    for i = 0, targetList.Count - 1 do
      local role = targetList[i]
      if role.belongNum ~= (self.caster).belongNum and role.belongNum ~= eBattleRoleBelong.neutral and (attack_int < role.pow or attack_int < role.skill_intensity) then
        pass_target1 = role
        if role.skill_intensity <= role.pow then
          attack_int = role.pow
        else
          attack_int = role.skill_intensity
        end
      end
    end
  end
  do
    local hurt = (self.caster).maxHp * 2 // 1000
    local hurt1 = attack_int * 100 // 1000
    if hurt1 < hurt then
      hurt = hurt1
    end
    local realhurt = hurt * num
    LuaSkillCtrl:RemoveLife(realhurt, self, self.caster, true, nil, true, true, eHurtType.PhysicsDmg)
  end
end

bs_7013.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  if self.damTimer ~= nil then
    (self.damTimer):Stop()
    self.damTimer = nil
  end
  ;
  (base.OnCasterDie)(self)
end

return bs_7013

