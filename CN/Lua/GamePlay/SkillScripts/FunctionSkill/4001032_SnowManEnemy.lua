-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_4001032 = class("bs_4001032", LuaSkillBase)
local base = LuaSkillBase
bs_4001032.config = {buffId = 3025}
bs_4001032.ctor = function(self)
  -- function num : 0_0
end

bs_4001032.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_4001032_1", 1, self.OnAfterBattleStart)
  self.flag = false
  self:AddBuffDieTrigger("bs_4001032_2", 3, self.OnBuffDie, nil, nil, (self.config).buffId)
  self:AddAfterBuffRemoveTrigger("bs_4001032_3", 4, self.AfterBuffRemove, nil, nil, (self.config).buffId)
end

bs_4001032.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if self.flag then
    return 
  end
  self.flag = true
  local targetList = LuaSkillCtrl:CallTargetSelect(self, 7, 10)
  local role = (targetList[0]).targetRole
  LuaSkillCtrl:CallBuff(self, role, (self.config).buffId, 1, (self.arglist)[1])
  if role:GetBuffTier((self.config).buffId) ~= nil then
    buffTier = role:GetBuffTier((self.config).buffId)
  end
  if buffTier > 0 then
    LuaSkillCtrl:CallStartLocalScale(role, (Vector3.New)(0.2, 0.2, 0.2))
  end
end

bs_4001032.OnBuffDie = function(self, buff, target, removeType)
  -- function num : 0_3 , upvalues : _ENV
  if buff.buffId ~= (self.config).buffId then
    return 
  end
  LuaSkillCtrl:CallStartLocalScale(target, (Vector3.New)(1, 1, 1))
end

bs_4001032.AfterBuffRemove = function(self, buffId, target, removeType)
  -- function num : 0_4 , upvalues : _ENV
  if buffId ~= (self.config).buffId then
    return 
  end
  LuaSkillCtrl:CallStartLocalScale(target, (Vector3.New)(1, 1, 1))
end

bs_4001032.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_4001032

