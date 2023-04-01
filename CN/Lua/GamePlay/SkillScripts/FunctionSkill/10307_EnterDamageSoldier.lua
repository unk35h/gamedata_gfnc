-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_10307 = class("bs_10307", LuaSkillBase)
local base = LuaSkillBase
bs_10307.config = {effectId = 12023, 
hurtConfig = {hit_formula = 0, basehurt_formula = 10078, crit_formula = 0}
}
bs_10307.ctor = function(self)
  -- function num : 0_0
end

bs_10307.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_10307_1", 1, self.OnAfterBattleStart)
  self.time = nil
  self.Effect = nil
end

bs_10307.OnAfterBattleStart = function(self, isMidway)
  -- function num : 0_2 , upvalues : _ENV
  if not isMidway then
    return 
  end
  if self.caster == nil then
    return 
  end
  if self.time ~= nil then
    (self.time):Stop()
    self.time = nil
  end
  self:PlayChipEffect()
  LuaSkillCtrl:AddPlayerTowerMp((self.arglist)[1])
  local callback = BindCallback(self, self.DamageSoldier)
  local efcCallBack = BindCallback(self, self.CallEfc)
  local loopTime = (self.arglist)[2] // 15
  LuaSkillCtrl:StartTimer(self, 3, efcCallBack)
  self.time = LuaSkillCtrl:StartTimer(self, 15, callback, nil, loopTime, 15)
  LuaSkillCtrl:StartTimer(self, 15 * loopTime, function()
    -- function num : 0_2_0 , upvalues : self
    if self.effect ~= nil then
      (self.effect):Die()
      self.effect = nil
    end
  end
, self)
end

bs_10307.CallEfc = function(self)
  -- function num : 0_3 , upvalues : _ENV
  self.effect = LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId, self)
end

bs_10307.DamageSoldier = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local targetList = LuaSkillCtrl:CallTargetSelect(self, 9, 0)
  if targetList == nil or targetList.Count < 1 then
    return 
  end
  self:PlayChipEffect()
  for i = 0, targetList.Count - 1 do
    local targetRole = (targetList[i]).targetRole
    if targetRole ~= nil and targetRole.hp > 0 and targetRole.belongNum ~= (self.caster).belongNum then
      self:PlayChipEffect()
      local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, targetRole)
      LuaSkillCtrl:HurtResult(self, skillResult, (self.config).hurtConfig, nil, true)
    end
  end
end

bs_10307.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
  if self.time ~= nil then
    (self.time):Stop()
    self.time = nil
  end
  if self.effect ~= nil then
    (self.effect):Die()
    self.effect = nil
  end
end

bs_10307.LuaDispose = function(self)
  -- function num : 0_6 , upvalues : base
  (base.LuaDispose)(self)
  self.time = nil
end

return bs_10307

