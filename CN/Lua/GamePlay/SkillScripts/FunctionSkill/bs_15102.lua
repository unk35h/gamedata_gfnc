-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_15102 = class("bs_15102", LuaSkillBase)
local base = LuaSkillBase
bs_15102.config = {effecIdAoe = 10943, effecIdHit = 10944}
bs_15102.ctor = function(self)
  -- function num : 0_0
end

bs_15102.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : _ENV
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_15102_1", 1, self.OnAfterBattleStart)
  self.hurtTime = nil
end

bs_15102.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if self.hurtTime ~= nil then
    (self.hurtTime):Stop()
    self.hurtTime = nil
  end
  local callback = BindCallback(self, self.FunSkill)
  self.hurtTime = LuaSkillCtrl:StartTimer(nil, (self.arglist)[1], callback, nil, -1, (self.arglist)[1])
end

bs_15102.FunSkill = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local targetlist = LuaSkillCtrl:FindRolesAroundRole(self.caster)
  if targetlist == nil then
    return 
  end
  if targetlist.Count > 0 then
    local value = ((self.caster).def + (self.caster).magic_res) * (self.arglist)[2] // 1000
    local Num = 0
    for i = 0, targetlist.Count - 1 do
      local targetRole = targetlist[i]
      if targetRole.belongNum == eBattleRoleBelong.enemy and not targetRole:IsUnSelect(self.caster) then
        local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, targetRole)
        LuaSkillCtrl:HurtResultWithConfig(self, skillResult, 14, {value}, true, true)
        skillResult:EndResult()
        Num = Num + 1
      end
    end
    if Num > 0 then
      LuaSkillCtrl:CallEffect(self.caster, (self.config).effecIdAoe, self)
    end
  end
end

bs_15102.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  if self.hurtTime ~= nil then
    (self.hurtTime):Stop()
    self.hurtTime = nil
  end
  ;
  (base.OnCasterDie)(self)
end

return bs_15102

