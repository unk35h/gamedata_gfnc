-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_21011 = class("bs_21011", LuaSkillBase)
local base = LuaSkillBase
bs_21011.config = {effecIdAoe = 10943, effecIdHit = 10944}
bs_21011.ctor = function(self)
  -- function num : 0_0
end

bs_21011.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_21011_1", 1, self.OnAfterBattleStart)
  self.hurtTime = nil
end

bs_21011.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if self.hurtTime ~= nil then
    (self.hurtTime):Stop()
    self.hurtTime = nil
  end
  local callback = BindCallback(self, self.FunSkill)
  self.hurtTime = LuaSkillCtrl:StartTimer(nil, (self.arglist)[1], callback, nil, -1, (self.arglist)[1])
end

bs_21011.FunSkill = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local targetlist = LuaSkillCtrl:CallTargetSelectWithRange(self, 9, 1)
  if targetlist.Count > 0 then
    local value = (self.caster).def + (self.caster).magic_res
    local Num = 0
    for i = 0, targetlist.Count - 1 do
      if ((targetlist[i]).targetRole).belongNum == eBattleRoleBelong.enemy and LuaSkillCtrl:IsRoleAdjacent((targetlist[i]).targetRole, self.caster) then
        LuaSkillCtrl:RemoveLife(value, self, (targetlist[i]).targetRole, true, nil, true, true, eHurtType.RealDmg)
        LuaSkillCtrl:CallEffect((targetlist[i]).targetRole, (self.config).effecIdHit, self)
        Num = Num + 1
      end
    end
    if Num > 0 then
      LuaSkillCtrl:CallEffect(self.caster, (self.config).effecIdAoe, self)
    end
  end
end

bs_21011.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
  if self.hurtTime ~= nil then
    (self.hurtTime):Stop()
    self.hurtTime = nil
  end
end

bs_21011.LuaDispose = function(self)
  -- function num : 0_5 , upvalues : base
  if self.hurtTime ~= nil then
    (self.hurtTime):Stop()
    self.hurtTime = nil
  end
  ;
  (base.LuaDispose)(self)
end

return bs_21011

