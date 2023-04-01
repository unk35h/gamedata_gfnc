-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_92006 = class("bs_92006", LuaSkillBase)
local base = LuaSkillBase
bs_92006.config = {effectId = 10964}
bs_92006.ctor = function(self)
  -- function num : 0_0
end

bs_92006.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSelfTrigger(eSkillTriggerType.AfterBattleStart, "bs_92006_1", 1, self.OnAfterBattleStart)
end

bs_92006.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local arriveCallBack = BindCallback(self, self.OnArriveAction)
  self.timer = LuaSkillCtrl:StartTimer(nil, (self.arglist)[1], arriveCallBack, nil, -1, (self.arglist)[1])
end

bs_92006.OnArriveAction = function(self)
  -- function num : 0_3 , upvalues : _ENV
  if self.timer ~= nil and (self.timer):IsOver() then
    self.timer = nil
  end
  local targetList = LuaSkillCtrl:FindRolesAroundRole(self.caster)
  if targetList ~= nil and targetList.Count > 0 then
    for i = 0, targetList.Count - 1 do
      local damage = (self.caster).maxHp * (self.arglist)[2] // 1000
      if (targetList[i]).belongNum ~= (self.caster).belongNum then
        LuaSkillCtrl:RemoveLife(damage, self, targetList[i], true, nil, true)
        LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId, self)
      end
    end
  end
end

bs_92006.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
  if self.timer ~= nil then
    (self.timer):Stop()
    self.timer = nil
  end
end

return bs_92006

