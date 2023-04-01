-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_30050 = class("bs_30050", LuaSkillBase)
local base = LuaSkillBase
bs_30050.config = {checkBuffId = 1228, buffId = 1229, buffTier = 1, buffDuration = 180}
bs_30050.ctor = function(self)
  -- function num : 0_0
end

bs_30050.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_30050_3", 1, self.OnAfterBattleStart)
  self:AddAfterAddBuffTrigger("bs_30050_7", 1, self.OnAfterAddBuff, nil, nil, nil, nil, (self.config).checkBuffId)
  self:AddBeforeBuffDispelTrigger("bs_30050_2", 2, self.BeforeBuffDispel, nil, nil, (self.config).checkBuffId)
  self:AddBuffDieTrigger("bs_30050_1", 1, self.OnBuffDie, nil, nil, (self.config).checkBuffId)
end

bs_30050.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local arriveCallBack = BindCallback(self, self.OnArriveAction)
  if self.timer == nil then
    self.timer = LuaSkillCtrl:StartTimer(nil, (self.arglist)[2], arriveCallBack, self, -1)
  end
end

bs_30050.OnArriveAction = function(self, target)
  -- function num : 0_3 , upvalues : _ENV
  if self.timer ~= nil and (self.timer):IsOver() then
    self.timer = nil
  end
  local targetlist = LuaSkillCtrl:CallTargetSelect(self, 64, 10)
  if targetlist.Count < 1 then
    return 
  end
  for i = 0, targetlist.Count - 1 do
    local targetRole = (targetlist[i]).targetRole
    if targetRole ~= nil then
      do
        local buffTier = targetRole:GetBuffTier((self.config).checkBuffId)
        if buffTier == 0 then
          LuaSkillCtrl:CallBuff(self, targetRole, (self.config).checkBuffId, (self.config).buffTier, (self.config).buffDuration)
          break
        end
        -- DECOMPILER ERROR at PC46: LeaveBlock: unexpected jumping out IF_THEN_STMT

        -- DECOMPILER ERROR at PC46: LeaveBlock: unexpected jumping out IF_STMT

      end
    end
  end
end

bs_30050.OnAfterAddBuff = function(self, buff, target)
  -- function num : 0_4 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, target, (self.config).buffId, (self.config).buffTier, nil, true)
end

bs_30050.BeforeBuffDispel = function(self, targetRole, context)
  -- function num : 0_5 , upvalues : _ENV
  LuaSkillCtrl:DispelBuff(targetRole, (self.config).buffId, 0)
end

bs_30050.OnBuffDie = function(self, buff, target, removeType)
  -- function num : 0_6 , upvalues : _ENV
  LuaSkillCtrl:DispelBuff(target, (self.config).buffId, 0)
end

bs_30050.LuaDispose = function(self)
  -- function num : 0_7 , upvalues : base
  (base.LuaDispose)(self)
  self.timer = nil
end

bs_30050.OnCasterDie = function(self)
  -- function num : 0_8 , upvalues : base
  (base.OnCasterDie)(self)
  if self.timer ~= nil then
    (self.timer):Stop()
    self.timer = nil
  end
end

return bs_30050

