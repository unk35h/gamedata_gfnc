-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_10323 = class("bs_10323", LuaSkillBase)
local base = LuaSkillBase
bs_10323.config = {buffWKId = 1248, buffDuration = 60, buffDuration2 = 120, buffDamageTime = 15, 
aoe_config = {effect_shape = 3, aoe_select_code = 4, aoe_range = 1}
, 
hurt_config = {hit_formula = 0, basehurt_formula = 10185, crit_formula = 0}
, effectIdHit = 10939, effectIdXS = 10940}
bs_10323.ctor = function(self)
  -- function num : 0_0
end

bs_10323.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddOnRoleDieTrigger("bs_10323_10", 1, self.OnRoleDie, self.caster, nil, nil, nil, nil, nil, (self.config).skillId)
  self.num = 0
end

bs_10323.OnRoleDie = function(self, killer, role)
  -- function num : 0_2 , upvalues : _ENV
  if killer == self.caster and role.belongNum ~= 0 then
    local targetlist = LuaSkillCtrl:GetAllFriendRoles()
    if #targetlist < 1 then
      return 
    end
    for k,v in pairs(targetlist) do
      local targetRole = v
      if targetRole ~= nil then
        local buffTier = targetRole:GetBuffTier((self.config).buffWKId)
        if buffTier == 0 then
          if ((self.caster).recordTable)["30056_WK"] then
            LuaSkillCtrl:CallBuff(self, targetRole, (self.config).buffWKId, (self.arglist)[1], (self.config).buffDuration2)
            self.num = self.num + 1
            local arriveCallBack = BindCallback(self, self.OnArriveAction, targetRole)
            local damageTime = (self.config).buffDuration2 // (self.config).buffDamageTime
            if self.timer == nil then
              self.timer = LuaSkillCtrl:StartTimer(nil, (self.config).buffDamageTime, arriveCallBack, nil, damageTime, (self.config).buffDamageTime)
            else
              if self.timer ~= nil then
                (self.timer):Stop()
                self.timer = nil
              end
              self.timer = LuaSkillCtrl:StartTimer(nil, (self.config).buffDamageTime, arriveCallBack, nil, damageTime, (self.config).buffDamageTime)
            end
          else
            do
              LuaSkillCtrl:CallBuff(self, targetRole, (self.config).buffWKId, (self.arglist)[1], (self.config).buffDuration)
              self.num = self.num + 1
              local arriveCallBack = BindCallback(self, self.OnArriveAction, targetRole)
              do
                local damageTime = (self.config).buffDuration // (self.config).buffDamageTime
                if self.timer == nil then
                  self.timer = LuaSkillCtrl:StartTimer(nil, (self.config).buffDamageTime, arriveCallBack, nil, damageTime, (self.config).buffDamageTime)
                else
                  if self.timer ~= nil then
                    (self.timer):Stop()
                    self.timer = nil
                  end
                  self.timer = LuaSkillCtrl:StartTimer(nil, (self.config).buffDamageTime, arriveCallBack, nil, damageTime, (self.config).buffDamageTime)
                end
                -- DECOMPILER ERROR at PC153: LeaveBlock: unexpected jumping out DO_STMT

                -- DECOMPILER ERROR at PC153: LeaveBlock: unexpected jumping out IF_ELSE_STMT

                -- DECOMPILER ERROR at PC153: LeaveBlock: unexpected jumping out IF_STMT

                -- DECOMPILER ERROR at PC153: LeaveBlock: unexpected jumping out IF_THEN_STMT

                -- DECOMPILER ERROR at PC153: LeaveBlock: unexpected jumping out IF_STMT

                -- DECOMPILER ERROR at PC153: LeaveBlock: unexpected jumping out IF_THEN_STMT

                -- DECOMPILER ERROR at PC153: LeaveBlock: unexpected jumping out IF_STMT

              end
            end
          end
        end
      end
    end
    if self.num < 1 then
      self.num = 0
    end
  end
end

bs_10323.OnArriveAction = function(self, targetRole)
  -- function num : 0_3 , upvalues : _ENV
  if self.timer ~= nil and (self.timer):IsOver() then
    self.timer = nil
  end
  local tier = targetRole:GetBuffTier((self.config).buffWKId)
  if tier > 0 then
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, targetRole, (self.config).aoe_config)
    LuaSkillCtrl:HurtResult(self, skillResult, (self.config).hurt_config, {tier}, true)
    if (skillResult.roleList).Count > 0 then
      for i = 0, (skillResult.roleList).Count - 1 do
        local role = (skillResult.roleList)[i]
        LuaSkillCtrl:CallEffect(role, (self.config).effectIdHit, self, nil, targetRole)
      end
    end
    do
      do
        skillResult:EndResult()
        if self.timer ~= nil then
          (self.timer):Stop()
          self.timer = nil
        end
      end
    end
  end
end

bs_10323.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
  if self.timer ~= nil then
    (self.timer):Stop()
    self.timer = nil
  end
end

bs_10323.LuaDispose = function(self)
  -- function num : 0_5 , upvalues : base
  if self.timer ~= nil then
    (self.timer):Stop()
    self.timer = nil
  end
  ;
  (base.LuaDispose)(self)
end

return bs_10323

