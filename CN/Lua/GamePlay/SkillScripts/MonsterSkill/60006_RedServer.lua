-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_60006 = class("bs_60006", LuaSkillBase)
local base = LuaSkillBase
bs_60006.config = {buffId1 = 175, buffId2 = 1033, buffId3 = 198, buffId = 3010, buffStun = 66, buffUndefeatable = 88, buffIds1 = 302901, buffIds2 = 302902, effectId_skill = 208302, time_hurt = 4, effectId_trail = 302903, buffIdjx = 302903, effectId_Z = 302906, time_strat = 15}
bs_60006.ctor = function(self)
  -- function num : 0_0
end

bs_60006.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_60006_1", 1, self.OnAfterBattleStart)
  self.buff_list = {}
end

bs_60006.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId3, 1, nil, true)
  LuaSkillCtrl:CallBuff(self, self.caster, 302907, 1, 999999, true)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffIdjx, (self.arglist)[5], 999999, true)
end

bs_60006.PlaySkill = function(self, data)
  -- function num : 0_3 , upvalues : _ENV
  self.buff_list = {}
  if ((self.caster).recordTable).cando == 0 then
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffIdjx, 1)
    LuaSkillCtrl:CallRoleAction(self.caster, 1002)
    LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_Z, self)
    LuaSkillCtrl:StartTimer(nil, 4, function()
    -- function num : 0_3_0 , upvalues : self, _ENV
    local num = (self.arglist)[2]
    local targetList = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.player)
    local targetList1 = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.enemy)
    -- DECOMPILER ERROR at PC30: Unhandled construct in 'MakeBoolean' P1

    -- DECOMPILER ERROR at PC30: Unhandled construct in 'MakeBoolean' P1

    if targetList ~= nil and targetList1 ~= nil and targetList.Count < targetList1.Count and targetList1[0] ~= nil then
      self:RealPlaySkill(nil, targetList1[0], 1, 1, 0)
      -- DECOMPILER ERROR at PC33: Confused about usage of register: R3 in 'UnsetPending'

      ;
      (self.buff_list)[targetList1[0]] = true
    end
    if targetList[0] ~= nil then
      self:RealPlaySkill(nil, targetList[0], 1, 0, 0)
      -- DECOMPILER ERROR at PC48: Confused about usage of register: R3 in 'UnsetPending'

      ;
      (self.buff_list)[targetList[0]] = true
    end
  end
)
  end
end

bs_60006.RealPlaySkill = function(self, sender, target, JNId, Belong, IsChange)
  -- function num : 0_4 , upvalues : _ENV
  if sender == nil then
    LuaSkillCtrl:StartTimer(nil, (self.config).time_hurt, function()
    -- function num : 0_4_0 , upvalues : _ENV, target, self, JNId, Belong, IsChange
    LuaSkillCtrl:CallEffectWithArgOverride(target, (self.config).effectId_trail, self, self.caster, false, false, self.SkillEventFunc, JNId, Belong, IsChange)
  end
)
  else
    if JNId <= 1 then
      LuaSkillCtrl:StartTimer(nil, (self.config).time_hurt, function()
    -- function num : 0_4_1 , upvalues : _ENV, target, self, sender, JNId, Belong, IsChange
    LuaSkillCtrl:CallEffectWithArgOverride(target, (self.config).effectId_trail, self, sender, false, false, self.SkillEventFunc, JNId, Belong, IsChange)
  end
)
    else
      LuaSkillCtrl:StartTimer(nil, (self.config).time_hurt, function()
    -- function num : 0_4_2 , upvalues : _ENV, target, self, sender, JNId, Belong, IsChange
    LuaSkillCtrl:CallEffectWithArgOverride(target, (self.config).effectId_trail, self, sender, false, false, self.SkillEventFunc, JNId, Belong, IsChange)
  end
)
    end
  end
end

bs_60006.SkillEventFunc = function(self, JNId, Belong, IsChange, effect, eventId, target)
  -- function num : 0_5 , upvalues : _ENV
  if effect.dataId == (self.config).effectId_trail and eventId == eBattleEffectEvent.Trigger then
    LuaSkillCtrl:StartTimer(nil, (self.config).time_hurt, function()
    -- function num : 0_5_0 , upvalues : _ENV, self, target
    LuaSkillCtrl:CallBuff(self, target.targetRole, (self.config).buffIds1, 1, (self.arglist)[1])
  end
)
    local num = (self.arglist)[2]
    if JNId < (self.arglist)[2] then
      if Belong == 0 then
        local targetList = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.player)
        local targetList1 = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.enemy)
        local num = targetList.Count
        local IsSet = flase
        if IsChange == 0 and targetList ~= nil and targetList.Count ~= 0 then
          for i = 0, targetList.Count - 1 do
            if (self.buff_list)[targetList[i]] == nil then
              self:RealPlaySkill(target.targetRole, targetList[i], JNId + 1, 0, 0)
              -- DECOMPILER ERROR at PC62: Confused about usage of register: R16 in 'UnsetPending'

              ;
              (self.buff_list)[targetList[i]] = true
              IsSet = true
              break
            end
          end
          do
            IsChange = 1
            if IsSet == flase and IsChange == 1 and targetList1 ~= nil and targetList1.Count ~= 0 then
              for i = 0, targetList1.Count - 1 do
                if (self.buff_list)[targetList1[i]] == nil then
                  self:RealPlaySkill(target.targetRole, targetList1[i], JNId + 1, 0, 1)
                  -- DECOMPILER ERROR at PC96: Confused about usage of register: R16 in 'UnsetPending'

                  ;
                  (self.buff_list)[targetList1[i]] = true
                  break
                end
              end
            end
            do
              if Belong == 1 then
                local targetList = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.enemy)
                local targetList1 = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.player)
                local num = targetList.Count
                local IsSet = flase
                if IsChange == 0 and targetList ~= nil and targetList.Count ~= 0 then
                  for i = 0, targetList.Count - 1 do
                    if (self.buff_list)[targetList[i]] == nil then
                      self:RealPlaySkill(target.targetRole, targetList[i], JNId + 1, 1, 0)
                      -- DECOMPILER ERROR at PC140: Confused about usage of register: R16 in 'UnsetPending'

                      ;
                      (self.buff_list)[targetList[i]] = true
                      IsSet = true
                      break
                    end
                  end
                  do
                    IsChange = 1
                    if IsSet == flase and IsChange == 1 and targetList1 ~= nil and targetList1.Count ~= 0 then
                      for i = 0, targetList1.Count - 1 do
                        if (self.buff_list)[targetList1[i]] == nil then
                          self:RealPlaySkill(target.targetRole, targetList1[i], JNId + 1, 1, 1)
                          -- DECOMPILER ERROR at PC174: Confused about usage of register: R16 in 'UnsetPending'

                          ;
                          (self.buff_list)[targetList1[i]] = true
                          break
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end

bs_60006.OnCasterDie = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_60006

