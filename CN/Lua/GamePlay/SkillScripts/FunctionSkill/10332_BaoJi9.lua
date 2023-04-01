-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_10332 = class("bs_10332", LuaSkillBase)
local base = LuaSkillBase
bs_10332.config = {buffId = 2061, effectId = 10975, effectId2 = 10976}
bs_10332.ctor = function(self)
  -- function num : 0_0
end

bs_10332.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_10332_1", 1, self.OnAfterBattleStart)
  self.timer = nil
end

bs_10332.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local arriveCallBack = BindCallback(self, self.doFun)
  LuaSkillCtrl:StartTimer(nil, (self.arglist)[1], arriveCallBack, nil, -1)
end

bs_10332.doFun = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local targetlist = LuaSkillCtrl:CallTargetSelectWithRange(self, 6, 1)
  LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId2, self)
  if targetlist.Count > 0 then
    for i = 0, targetlist.Count - 1 do
      if (targetlist[i]).targetRole ~= self.caster and LuaSkillCtrl:IsRoleAdjacent((targetlist[i]).targetRole, self.caster) then
        LuaSkillCtrl:CallBuff(self, (targetlist[i]).targetRole, (self.config).buffId, 1, nil)
        local buffTier = ((targetlist[i]).targetRole):GetBuffTier((self.config).buffId) - 1
        local countBuffEffect = LuaSkillCtrl:CallEffect((targetlist[i]).targetRole, (self.config).effectId, self)
        LuaSkillCtrl:EffectSetCountValue(countBuffEffect, buffTier)
      end
    end
  end
end

bs_10332.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

bs_10332.LuaDispose = function(self)
  -- function num : 0_5 , upvalues : base
  (base.LuaDispose)(self)
end

return bs_10332

