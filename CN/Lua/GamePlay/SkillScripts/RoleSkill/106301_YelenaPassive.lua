-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_106301 = class("bs_106301", LuaSkillBase)
local base = LuaSkillBase
bs_106301.config = {buffId_red = 106301, buffId_blue = 106302, buffId_yellow = 106303, buffId_att = 106304, buffId_def = 106305, effectId_trail = 106303, effectId_get_1 = 106307, effectId_get_2 = 106308, effectId_get_3 = 106309, HurtConfigID = 17}
bs_106301.colorInfo = {
[1] = {colorName = "red_num", buffId = 106301, effectId = 106307}
, 
[2] = {colorName = "blue_num", buffId = 106302, effectId = 106308}
, 
[3] = {colorName = "yellow_num", buffId = 106303, effectId = 106309}
}
bs_106301.ctor = function(self)
  -- function num : 0_0
end

bs_106301.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).RedAtkDam = (self.arglist)[8]
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).YellowAtkDam = (self.arglist)[10]
  self:AddBeforePlaySkillTrigger("bs_106301_1", 1, self.OnBeforePlaySkill, self.caster, nil, nil, nil, nil, nil, nil, eSkillTag.commonAttack)
  self:AddAfterPlaySkillTrigger("bs_106301_2", 1, self.OnAfterPlaySkill, nil, nil, (self.caster).belongNum, nil, eBattleRoleType.character)
  self:AddAfterHurtTrigger("bs_106301_3", 1, self.OnAfterHurt, nil, nil, (self.caster).belongNum, nil, nil, nil, nil, eSkillTag.commonAttack)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_106301_4", 1, self.OnAfterBattleStart)
  self:AddLuaTrigger(eSkillLuaTrigger.OnPlayYelenaSkill, self.OnPlayYelenaSkill, self)
  -- DECOMPILER ERROR at PC60: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).beforeAttackColor = 0
  -- DECOMPILER ERROR at PC64: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).colorTable = {}
  self:ResetColorTable()
end

bs_106301.OnBeforePlaySkill = function(self, role, context)
  -- function num : 0_2 , upvalues : _ENV
  if role == self.caster and (context.skill).isCommonAttack then
    local random = LuaSkillCtrl:CallRange(1, 10000)
    local index = 1
    local colorTable = ((self.caster).recordTable).colorTable
    if random <= (colorTable[1]).per then
      index = 1
    else
      if random - (colorTable[1]).per < (colorTable[2]).per then
        index = 2
      else
        index = 3
      end
    end
    local colorId = (colorTable[index]).colorId
    local colorInfo = (self.colorInfo)[colorId]
    -- DECOMPILER ERROR at PC38: Confused about usage of register: R8 in 'UnsetPending'

    ;
    ((self.caster).recordTable).beforeAttackColor = colorId
  end
end

bs_106301.OnAfterPlaySkill = function(self, skill, role)
  -- function num : 0_3 , upvalues : _ENV
  if (skill.maker).belongNum ~= (self.caster).belongNum or (skill.maker).roleType ~= eBattleRoleType.character then
    return 
  end
  if skill.isNormalSkill then
    local random = LuaSkillCtrl:CallRange(1, 10000)
    if random <= (self.arglist)[2] then
      self:AddColor(2)
    end
  end
end

bs_106301.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_4 , upvalues : _ENV
  if isTriggerSet then
    return 
  end
  do
    if skill.isCommonAttack and sender.roleType == eBattleRoleType.character and target.belongNum == eBattleRoleBelong.enemy then
      local random = LuaSkillCtrl:CallRange(1, 10000)
      if random <= (self.arglist)[1] then
        self:AddColor(1)
      end
    end
    local colorId = ((self.caster).recordTable).beforeAttackColor
    if colorId == 0 then
      return 
    end
    if sender ~= self.caster or isMiss then
      return 
    end
    if colorId == 1 then
      local originAttrList = (self.caster).originAttrList
      local pow_max = originAttrList[eHeroAttr.pow] * (self.arglist)[11] // 1000
      local pow_tar = target.pow * (self.arglist)[4] // 1000
      local pow_up = (math.min)(pow_max, pow_tar)
      LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_att, pow_up, (self.arglist)[5], true)
    end
    do
      if colorId == 2 then
        local targetList = LuaSkillCtrl:CallTargetSelect(self, 71, 10)
        if targetList.Count < 2 then
          return 
        end
        for i = 0, targetList.Count - 1 do
          if (targetList[i]).targetRole ~= nil and (targetList[i]).targetRole ~= target then
            LuaSkillCtrl:CallEffectWithArgOverride((targetList[i]).targetRole, (self.config).effectId_trail, self, target, false, false, self.SkillEventFunc)
            break
          end
        end
      end
      do
        if colorId == 3 then
          LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_def, 1, (self.arglist)[7], true)
        end
      end
    end
  end
end

bs_106301.SkillEventFunc = function(self, effect, eventId, target)
  -- function num : 0_5 , upvalues : _ENV
  if effect.dataId == (self.config).effectId_trail and eventId == eBattleEffectEvent.Trigger then
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
    LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).HurtConfigID, {(self.arglist)[9]})
    skillResult:EndResult()
  end
end

bs_106301.OnAfterBattleStart = function(self)
  -- function num : 0_6 , upvalues : _ENV
  self.addYellowTimer = LuaSkillCtrl:StartTimer(nil, (self.arglist)[3], function()
    -- function num : 0_6_0 , upvalues : self
    self:AddColor(3)
  end
, self, -1, 0)
end

bs_106301.ResetColorTable = function(self)
  -- function num : 0_7
  local colorTable = ((self.caster).recordTable).colorTable
  colorTable[1] = {colorId = 1, num = 0, per = 3334}
  colorTable[2] = {colorId = 2, num = 0, per = 3333}
  colorTable[3] = {colorId = 3, num = 0, per = 3333}
end

bs_106301.AddColor = function(self, colorId)
  -- function num : 0_8 , upvalues : _ENV
  local colorInfo = (self.colorInfo)[colorId]
  local colorName = colorInfo.colorName
  local buffId = colorInfo.buffId
  local effectId = colorInfo.effectId
  LuaSkillCtrl:CallBuff(self, self.caster, buffId, 1, nil, true)
  LuaSkillCtrl:CallEffect(self.caster, effectId, self)
  self:OnAddColor(colorId)
end

bs_106301.OnAddColor = function(self, colorId)
  -- function num : 0_9
  local colorTable = ((self.caster).recordTable).colorTable
  for i = 1, 3 do
    if (colorTable[i]).colorId == colorId then
      local num = (colorTable[i]).num
      -- DECOMPILER ERROR at PC15: Confused about usage of register: R8 in 'UnsetPending'

      ;
      (colorTable[i]).num = num + 1
      local curNum = (colorTable[i]).num
      if i > 1 then
        for k = i - 1, 1, -1 do
          local lastTable = colorTable[k]
          -- DECOMPILER ERROR at PC31: Confused about usage of register: R14 in 'UnsetPending'

          if lastTable.num < curNum then
            (colorTable[i]).colorId = (colorTable[k]).colorId
            -- DECOMPILER ERROR at PC35: Confused about usage of register: R14 in 'UnsetPending'

            ;
            (colorTable[i]).num = (colorTable[k]).num
            -- DECOMPILER ERROR at PC37: Confused about usage of register: R14 in 'UnsetPending'

            ;
            (colorTable[k]).colorId = colorId
            -- DECOMPILER ERROR at PC39: Confused about usage of register: R14 in 'UnsetPending'

            ;
            (colorTable[k]).num = curNum
            i = k
          end
        end
      end
      break
    end
  end
  do
    self:CalculatePer()
  end
end

bs_106301.OnPlayYelenaSkill = function(self, role, colorId)
  -- function num : 0_10 , upvalues : _ENV
  if role == self.caster then
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_red)
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_blue)
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_yellow)
    self:ResetColorTable()
    self:AddColor(colorId)
  end
end

bs_106301.CalculatePer = function(self)
  -- function num : 0_11
  local colorTable = ((self.caster).recordTable).colorTable
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R2 in 'UnsetPending'

  if (colorTable[2]).num < (colorTable[1]).num then
    (colorTable[1]).per = 6000
    -- DECOMPILER ERROR at PC18: Confused about usage of register: R2 in 'UnsetPending'

    if (colorTable[3]).num < (colorTable[2]).num then
      (colorTable[2]).per = 3000
      -- DECOMPILER ERROR at PC20: Confused about usage of register: R2 in 'UnsetPending'

      ;
      (colorTable[3]).per = 1000
    else
      -- DECOMPILER ERROR at PC23: Confused about usage of register: R2 in 'UnsetPending'

      ;
      (colorTable[2]).per = 2000
      -- DECOMPILER ERROR at PC25: Confused about usage of register: R2 in 'UnsetPending'

      ;
      (colorTable[3]).per = 2000
    end
  else
    -- DECOMPILER ERROR at PC34: Confused about usage of register: R2 in 'UnsetPending'

    if (colorTable[3]).num < (colorTable[2]).num then
      (colorTable[1]).per = 4500
      -- DECOMPILER ERROR at PC36: Confused about usage of register: R2 in 'UnsetPending'

      ;
      (colorTable[2]).per = 4500
      -- DECOMPILER ERROR at PC38: Confused about usage of register: R2 in 'UnsetPending'

      ;
      (colorTable[3]).per = 1000
    else
      -- DECOMPILER ERROR at PC41: Confused about usage of register: R2 in 'UnsetPending'

      ;
      (colorTable[1]).per = 3334
      -- DECOMPILER ERROR at PC43: Confused about usage of register: R2 in 'UnsetPending'

      ;
      (colorTable[2]).per = 3333
      -- DECOMPILER ERROR at PC45: Confused about usage of register: R2 in 'UnsetPending'

      ;
      (colorTable[3]).per = 3333
    end
  end
end

bs_106301.OnCasterDie = function(self)
  -- function num : 0_12 , upvalues : base
  (base.OnCasterDie)(self)
  if self.addYellowTimer ~= nil then
    (self.addYellowTimer):Stop()
    self.addYellowTimer = nil
  end
end

bs_106301.LuaDispose = function(self)
  -- function num : 0_13 , upvalues : base
  (base.LuaDispose)(self)
end

return bs_106301

