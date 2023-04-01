-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_105707 = class("bs_105707", LuaSkillBase)
local base = LuaSkillBase
bs_105707.config = {monsterId = 61, buffId_speed = 105701, buffId_crazy = 105705, effectId_trail = 105715, effectId = 105716, configId = 3}
bs_105707.ctor = function(self)
  -- function num : 0_0
end

local SyncAttrList = {eHeroAttr.dodge, eHeroAttr.crit, eHeroAttr.critDamage, eHeroAttr.sunder, eHeroAttr.damage_increase, eHeroAttr.injury_reduce, eHeroAttr.heal, eHeroAttr.treatment, eHeroAttr.magic_pen, eHeroAttr.cd_reduce, eHeroAttr.resistance}
bs_105707.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_105707_1", 1, self.OnAfterBattleStart)
  self:AddOnRoleDieTrigger("bs_105707_2", 1, self.OnRoleDie, nil, nil, nil, (self.caster).belongNum)
  self.maxCount = 3
  self.table = {}
  self.Count = 0
end

bs_105707.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  self.timer = LuaSkillCtrl:StartTimer(nil, (self.arglist)[1], (BindCallback(self, self.doSummon)), nil, -1, 0)
end

bs_105707.doSummon = function(self)
  -- function num : 0_3 , upvalues : _ENV
  if self.Count < self.maxCount then
    self:Summon()
  else
    for i = 1, self.maxCount do
      if (self.table)[i] ~= nil then
        LuaSkillCtrl:CallBuff(self, (self.table)[i], (self.config).buffId_speed, 1, (self.arglist)[2])
      end
    end
    self:OnSyncAttrFromHost()
  end
end

bs_105707.Summon = function(self)
  -- function num : 0_4 , upvalues : _ENV, SyncAttrList
  local Grid = LuaSkillCtrl:CallFindEmptyGridNearest(self.caster)
  if Grid == nil then
    Grid = LuaSkillCtrl:FindRoleRightEmptyGrid(self.caster, 10)
  end
  local summonerEntity = nil
  if Grid ~= nil then
    local target = LuaSkillCtrl:GetTargetWithGrid(Grid.x, Grid.y)
    local summoner = LuaSkillCtrl:CreateSummoner(self, (self.config).monsterId, Grid.x, Grid.y)
    summoner:SetAttr(eHeroAttr.maxHp, (self.caster).maxHp * (self.arglist)[3] // 1000)
    summoner:SetAttr(eHeroAttr.skill_intensity, (self.caster).skill_intensity * (self.arglist)[4] // 1000)
    summoner:SetAttr(eHeroAttr.pow, (self.caster).pow * (self.arglist)[4] // 1000)
    summoner:SetAttr(eHeroAttr.speed, (self.caster).speed)
    summoner:SetAttr(eHeroAttr.moveSpeed, (self.caster).moveSpeed)
    summoner:SetAttr(eHeroAttr.def, (self.caster).def * (self.arglist)[5] // 1000)
    summoner:SetAttr(eHeroAttr.magic_res, (self.caster).magic_res * (self.arglist)[5] // 1000)
    summoner:SetAttr(eHeroAttr.lucky, self.lucky)
    for i,v in ipairs(SyncAttrList) do
      local curValue = (self.caster):GetRealProperty(v)
      summoner:SetAttr(v, curValue)
    end
    summoner:SetAsRealEntity(1)
    local arg1 = nil
    local arg2 = (self.arglist)[6]
    local arg3 = (self.arglist)[11]
    if (self.table)[1] == nil then
      arg1 = 1
    else
      if (self.table)[2] == nil then
        arg1 = 2
      else
        arg1 = 3
      end
    end
    local tab = {arg_1 = arg1, arg_2 = arg2, arg_3 = arg3}
    summoner:SetRecordTable(tab)
    summonerEntity = LuaSkillCtrl:AddSummonerRole(summoner)
    -- DECOMPILER ERROR at PC145: Confused about usage of register: R9 in 'UnsetPending'

    if arg1 == 1 then
      (self.table)[1] = summonerEntity
      self.Count = self.Count + 1
    else
      -- DECOMPILER ERROR at PC153: Confused about usage of register: R9 in 'UnsetPending'

      if arg1 == 2 then
        (self.table)[2] = summonerEntity
        self.Count = self.Count + 1
      else
        -- DECOMPILER ERROR at PC161: Confused about usage of register: R9 in 'UnsetPending'

        if arg1 == 3 then
          (self.table)[3] = summonerEntity
          self.Count = self.Count + 1
        end
      end
    end
  end
end

bs_105707.OnRoleDie = function(self, killer, role)
  -- function num : 0_5 , upvalues : _ENV
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R3 in 'UnsetPending'

  if role == (self.table)[1] then
    (self.table)[1] = nil
    self.Count = self.Count - 1
  else
    -- DECOMPILER ERROR at PC15: Confused about usage of register: R3 in 'UnsetPending'

    if role == (self.table)[2] then
      (self.table)[2] = nil
      self.Count = self.Count - 1
    else
      -- DECOMPILER ERROR at PC25: Confused about usage of register: R3 in 'UnsetPending'

      if role == (self.table)[3] then
        (self.table)[3] = nil
        self.Count = self.Count - 1
      end
    end
  end
  if role.belongNum == (self.caster).belongNum and role.roleType == eBattleRoleType.realSummoner and killer.belongNum == eBattleRoleBelong.enemy then
    LuaSkillCtrl:CallEffectWithArgOverride(killer, (self.config).effectId_trail, self, self.caster, nil, nil, self.SkillEventFunc)
    LuaSkillCtrl:CallEffect(killer, (self.config).effectId_trail, self, nil, self.caster, nil, true)
    LuaSkillCtrl:CallEffect(killer, (self.config).effectId_trail, self, nil, self.caster, nil, true)
    local targetList = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.player)
    if targetList.Count > 0 then
      for i = 0, targetList.Count - 1 do
        local role = targetList[i]
        if role ~= nil and role.hp > 0 and role.roleType == eBattleRoleType.realSummoner then
          LuaSkillCtrl:CallBuff(self, role, (self.config).buffId_crazy, 1, (self.arglist)[10])
        end
      end
    end
  end
end

bs_105707.SkillEventFunc = function(self, effect, eventId, target)
  -- function num : 0_6 , upvalues : _ENV
  if effect.dataId == (self.config).effectId_trail and eventId == eBattleEffectEvent.Trigger then
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
    LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).configId, {(self.arglist)[8]}, nil, nil)
    skillResult:EndResult()
    LuaSkillCtrl:CallEffect(target, (self.config).effectId, self, nil, nil, nil, true)
  end
end

bs_105707.OnSyncAttrFromHost = function(self)
  -- function num : 0_7 , upvalues : _ENV, SyncAttrList
  if self.Count <= 1 then
    return 
  end
  for i = 1, self.maxCount do
    local summonerEntity = (self.table)[i]
    if summonerEntity == nil then
      return 
    end
    local originAttrList = summonerEntity.originAttrList
    for i,v in ipairs(SyncAttrList) do
      local attrValue = summonerEntity:GetRealProperty(v)
      local curValue = (self.caster):GetRealProperty(v)
      if curValue - attrValue > 0 then
        summonerEntity:AddRoleProperty(v, curValue - attrValue, eHeroAttrType.Origin)
      end
    end
    local attrValue_def = originAttrList[eHeroAttr.def]
    local attrValue_ma_def = originAttrList[eHeroAttr.magic_res]
    local curValue1 = (self.caster).def * (self.arglist)[5] // 1000
    local curValue2 = (self.caster).magic_res * (self.arglist)[5] // 1000
    summonerEntity:AddRoleProperty(eHeroAttr.def, curValue1 - attrValue_def, eHeroAttrType.Origin)
    summonerEntity:AddRoleProperty(eHeroAttr.magic_res, curValue2 - attrValue_ma_def, eHeroAttrType.Origin)
    local attrValue_pow = originAttrList[eHeroAttr.pow]
    local attrValue_int = originAttrList[eHeroAttr.skill_intensity]
    local curValue3 = (self.caster).pow * (self.arglist)[4] // 1000
    local curValue4 = (self.caster).skill_intensity * (self.arglist)[4] // 1000
    summonerEntity:AddRoleProperty(eHeroAttr.pow, curValue3 - attrValue_pow, eHeroAttrType.Origin)
    summonerEntity:AddRoleProperty(eHeroAttr.skill_intensity, curValue4 - attrValue_int, eHeroAttrType.Origin)
    local hp_per = summonerEntity.hp * 1000 // summonerEntity.maxHp
    local curValue_hp = (self.caster).maxHp * (self.arglist)[3] // 1000
    local attrValue_hp = originAttrList[eHeroAttr.maxHp]
    summonerEntity:AddRoleProperty(eHeroAttr.maxHp, curValue_hp - attrValue_hp, eHeroAttrType.Origin)
    if curValue_hp - attrValue_hp > 0 then
      local num = curValue_hp - attrValue_hp
      LuaSkillCtrl:CallHeal(num, self, summonerEntity, true)
    else
      do
        do
          if curValue_hp - attrValue_hp < 0 then
            local num = attrValue_hp - curValue_hp
            LuaSkillCtrl:RemoveLife(num, self, summonerEntity, true, nil, false, true, 2, true)
          end
          -- DECOMPILER ERROR at PC148: LeaveBlock: unexpected jumping out DO_STMT

          -- DECOMPILER ERROR at PC148: LeaveBlock: unexpected jumping out IF_ELSE_STMT

          -- DECOMPILER ERROR at PC148: LeaveBlock: unexpected jumping out IF_STMT

        end
      end
    end
  end
end

bs_105707.OnCasterDie = function(self)
  -- function num : 0_8 , upvalues : base
  (base.OnCasterDie)(self)
  if self.timer ~= nil then
    (self.timer):Stop()
    self.timer = nil
  end
end

bs_105707.LuaDispose = function(self)
  -- function num : 0_9 , upvalues : base
  self.table = nil
  ;
  (base.LuaDispose)(self)
end

return bs_105707

