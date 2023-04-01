-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_106001 = class("bs_106001", LuaSkillBase)
local base = LuaSkillBase
bs_106001.config = {hurtConfigId = 3, effectId_hit = 106003, effectId_hit_pass = 106017, buffId_A = 106001, buffId_C = 106004, buffId_ult = 106003}
bs_106001.ctor = function(self)
  -- function num : 0_0
end

bs_106001.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_106001_02", 1, self.OnAfterBattleStart)
  self:AddAfterHurtTrigger("bs_106001_03", 1, self.OnAfterHurt, nil, nil, nil, (self.caster).belongNum)
  self:AddOnRoleDieTrigger("bs_106001_04", 1, self.OnRoleDie, nil, nil, (self.caster).belongNum)
  -- DECOMPILER ERROR at PC30: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).clueTable = {}
  self.clueCount = 0
  -- DECOMPILER ERROR at PC36: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).passive_arg1 = (self.arglist)[1]
  -- DECOMPILER ERROR at PC39: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).Helper = nil
  self:AddLuaTrigger(eSkillLuaTrigger.DupinAttack, self.AccTimer)
end

bs_106001.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  self.updateTimer = LuaSkillCtrl:StartTimer(nil, 3, function()
    -- function num : 0_2_0 , upvalues : self, _ENV
    local clueTable = ((self.caster).recordTable).clueTable
    if clueTable ~= nil then
      local curFrame = (LuaSkillCtrl.battleCtrl).frame
      local tempI = 0
      for i = 1, #clueTable do
        local clue = clueTable[i]
        local frame = clue % 100000
        if curFrame - frame >= ((self.caster).recordTable).passive_skill1 then
          do
            tempI = i
            -- DECOMPILER ERROR at PC22: LeaveBlock: unexpected jumping out IF_THEN_STMT

            -- DECOMPILER ERROR at PC22: LeaveBlock: unexpected jumping out IF_STMT

          end
        end
      end
      do
        if tempI ~= 0 then
          local tempTable = {}
          for i = 1, #clueTable do
            if tempI < i then
              (table.insert)(tempTable, clueTable[i])
            end
          end
          -- DECOMPILER ERROR at PC40: Confused about usage of register: R4 in 'UnsetPending'

          ;
          ((self.caster).recordTable).clueTable = tempTable
        end
        clueTable = nil
      end
    end
  end
, nil, -1)
end

bs_106001.AccTimer = function(self, target)
  -- function num : 0_3 , upvalues : _ENV
  local hurt = self.clueCount * (self.arglist)[2]
  if hurt == 0 then
    LuaSkillCtrl:CallEffect(target, (self.config).effectId_hit, self)
    return 
  end
  LuaSkillCtrl:CallEffect(target, (self.config).effectId_hit_pass, self)
  local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
  LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).hurtConfigId, {hurt})
  skillResult:EndResult()
  self.clueCount = 0
  LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_A, 0)
end

bs_106001.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_4 , upvalues : _ENV
  if skill.isCommonAttack then
    local curFrame = (LuaSkillCtrl.battleCtrl).frame
    local senderUid = sender.uid
    local clue = sender.uid * 100000 + curFrame
    ;
    (table.insert)(((self.caster).recordTable).clueTable, clue)
    if isMiss == true then
      local addCount = 1
      if target:GetBuffTier((self.config).buffId_ult) > 0 then
        addCount = 2
        LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_C, 1)
      end
      self.clueCount = self.clueCount + addCount
      LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_A, addCount)
    end
  end
end

bs_106001.OnRoleDie = function(self, killer, role)
  -- function num : 0_5 , upvalues : _ENV
  local clueTable = ((self.caster).recordTable).clueTable
  local uid = role.uid
  for i = #clueTable, 1, -1 do
    local clue = clueTable[i]
    local senderUid = (math.modf)(clue / 100000)
    if uid == senderUid then
      (table.remove)(clueTable, i)
    end
  end
end

bs_106001.OnCasterDie = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnCasterDie)(self)
  if self.updateTimer ~= nil then
    (self.updateTimer):Stop()
    self.updateTimer = nil
  end
end

bs_106001.LuaDispose = function(self)
  -- function num : 0_7 , upvalues : base
  (base.LuaDispose)(self)
  if self.updateTimer ~= nil then
    (self.updateTimer):Stop()
    self.updateTimer = nil
  end
end

return bs_106001

