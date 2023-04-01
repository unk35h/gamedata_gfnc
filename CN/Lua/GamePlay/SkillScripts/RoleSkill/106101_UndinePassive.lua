-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_106101 = class("bs_106101", LuaSkillBase)
local base = LuaSkillBase
bs_106101.config = {buffId_crit = 106101, buffId_crit1 = 106102, buffId1 = 106103, HurtConfigID = 3, effectId_trail = 106103, effectId = 106104, configId = 3, 
heal_config = {baseheal_formula = 3022}
, buffId_speed = 106104, monsterId1 = 59, monsterId2 = 60, skilltime = 15, actionId = 1002, action_speed = 1.5, actionId_start_time = 7, effect_cast = 106105, effect_castend = 106106}
bs_106101.ctor = function(self)
  -- function num : 0_0
end

local SyncAttrList = {eHeroAttr.moveSpeed, eHeroAttr.dodge, eHeroAttr.critDamage, eHeroAttr.sunder, eHeroAttr.damage_increase, eHeroAttr.injury_reduce, eHeroAttr.heal, eHeroAttr.treatment, eHeroAttr.magic_pen, eHeroAttr.cd_reduce, eHeroAttr.resistance}
bs_106101.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterPlaySkill, "bs_106101_01", 1, self.OnAfterPlaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_106101_03", 1, self.OnAfterBattleStart)
  self:AddOnRoleDieTrigger("bs_106101_02", 1, self.OnRoleDie)
  self.maxCount = 2
  self.table = {}
  self.gushou = nil
  self.haoshou = nil
  self.haoshou_actor = nil
  self.gushou_actor = nil
end

bs_106101.OnAfterPlaySkill = function(self, skill, role)
  -- function num : 0_2 , upvalues : _ENV
  if skill.isCommonAttack and role == self.caster then
    local targetList = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.player)
    if targetList.Count > 0 then
      for i = 0, targetList.Count - 1 do
        local role = targetList[i]
        if role ~= nil and role.hp > 0 then
          LuaSkillCtrl:CallBuff(self, role, (self.config).buffId_crit1, 1, 125)
        end
      end
    end
  end
  do
    local target = (role.recordTable).lastAttackRole
    if target == nil then
      return 
    end
    if skill.isCommonAttack and (skill.maker).belongNum == (self.caster).belongNum and role.roleType == 4 then
      LuaSkillCtrl:CallEffectWithArgOverride(target, (self.config).effectId_trail, self, self.caster, nil, nil, self.SkillEventFunc)
    end
  end
end

bs_106101.SkillEventFunc = function(self, effect, eventId, target)
  -- function num : 0_3 , upvalues : _ENV
  if effect.dataId == (self.config).effectId_trail and eventId == eBattleEffectEvent.Trigger then
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
    LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).configId, {(self.arglist)[3]}, nil, nil)
    skillResult:EndResult()
    LuaSkillCtrl:CallEffect(target, (self.config).effectId, self, nil, nil, nil, true)
  end
end

bs_106101.OnAfterBattleStart = function(self)
  -- function num : 0_4 , upvalues : _ENV
  self.timer = LuaSkillCtrl:StartTimer(nil, (self.arglist)[4], (BindCallback(self, self.doskill)), nil, -1, 0)
  ;
  (self.caster):AddRoleProperty(eHeroAttr.attackRange, 10, eHeroAttrType.Origin)
end

bs_106101.doskill = function(self)
  -- function num : 0_5 , upvalues : _ENV
  if ((self.caster).recordTable).NeedRestart ~= true and not LuaSkillCtrl:RoleContainsCtrlBuff(self.caster) and #self.table < 2 then
    LuaSkillCtrl:CallBreakAllSkill(self.caster)
    -- DECOMPILER ERROR at PC21: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.caster).recordTable).NeedRestart = true
    LuaSkillCtrl:CallEffect(self.caster, (self.config).effect_cast, self, nil)
    local time = (self.config).skilltime * 10 // 15
    self:CallCasterWait(time)
    LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId, (self.config).action_speed)
    LuaSkillCtrl:StartTimer(nil, (self.config).actionId_start_time, (BindCallback(self, self.OnAttackTrigger)), nil)
  else
    do
      LuaSkillCtrl:StartTimer(nil, (self.config).actionId_start_time, (BindCallback(self, self.OnAttackTrigger)), nil)
    end
  end
end

bs_106101.OnAttackTrigger = function(self)
  -- function num : 0_6 , upvalues : _ENV
  local count = #self.table
  if count < self.maxCount then
    self:Summon()
  else
    for i = 1, #self.table do
      LuaSkillCtrl:CallBuff(self, (self.table)[i], (self.config).buffId_speed, 1, (self.arglist)[7])
      local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, (self.table)[i])
      LuaSkillCtrl:HealResult(skillResult, (self.config).heal_config, {(self.arglist)[5]})
      skillResult:EndResult()
    end
    self:OnSyncAttrFromHost()
  end
end

bs_106101.Summon = function(self)
  -- function num : 0_7 , upvalues : _ENV
  local Grid = LuaSkillCtrl:CallFindEmptyGridNearest(self.caster)
  if Grid == nil then
    Grid = LuaSkillCtrl:FindRoleRightEmptyGrid(self.caster, 10)
  end
  if Grid ~= nil then
    if #self.table == 0 then
      local num = LuaSkillCtrl:CallRange(1, 2)
      if num == 1 then
        self.gushou = true
      else
        if num == 2 then
          self.haoshou = true
        end
      end
      self:doSummon(Grid, num)
    else
      do
        if self.gushou ~= true then
          self:doSummon(Grid, 1)
          self.gushou = true
        else
          if self.haoshou ~= true then
            self:doSummon(Grid, 2)
            self.haoshou = true
          end
        end
      end
    end
  end
end

bs_106101.doSummon = function(self, Grid, num)
  -- function num : 0_8 , upvalues : _ENV, SyncAttrList
  local summonerEntity = nil
  if num == 1 then
    local target = LuaSkillCtrl:GetTargetWithGrid(Grid.x, Grid.y)
    LuaSkillCtrl:CallEffect(target, (self.config).effect_castend, self)
    local summoner = LuaSkillCtrl:CreateSummoner(self, (self.config).monsterId1, Grid.x, Grid.y)
    summoner:SetAttr(eHeroAttr.maxHp, (self.caster).maxHp * (self.arglist)[10] // 1000)
    summoner:SetAttr(eHeroAttr.skill_intensity, (self.caster).skill_intensity * (self.arglist)[8] // 1000)
    summoner:SetAttr(eHeroAttr.pow, (self.caster).pow * (self.arglist)[8] // 1000)
    summoner:SetAttr(eHeroAttr.speed, (self.caster).speed)
    summoner:SetAttr(eHeroAttr.def, (self.caster).def * (self.arglist)[9] // 1000)
    summoner:SetAttr(eHeroAttr.magic_res, (self.caster).magic_res * (self.arglist)[9] // 1000)
    summoner:SetAttr(eHeroAttr.lucky, (self.caster).lucky)
    summoner:SetAttr(eHeroAttr.crit, (self.caster).crit)
    local hostEntity = self.caster
    if hostEntity == nil or hostEntity.hp <= 0 then
      return over
    end
    for i,v in ipairs(SyncAttrList) do
      local curValue = (self.caster):GetRealProperty(v)
      summoner:SetAttr(v, curValue)
    end
    summoner:SetAsRealEntity(1)
    local arg1 = (self.arglist)[11]
    local tab = {arg_1 = arg1}
    summoner:SetRecordTable(tab)
    summonerEntity = LuaSkillCtrl:AddSummonerRole(summoner)
    -- DECOMPILER ERROR at PC133: Confused about usage of register: R9 in 'UnsetPending'

    if (self.table)[1] == nil then
      (self.table)[1] = summonerEntity
      self.gushou_actor = summonerEntity
    else
      -- DECOMPILER ERROR at PC141: Confused about usage of register: R9 in 'UnsetPending'

      if (self.table)[2] == nil then
        (self.table)[2] = summonerEntity
        self.gushou_actor = summonerEntity
      end
    end
  end
  do
    if num == 2 then
      local target = LuaSkillCtrl:GetTargetWithGrid(Grid.x, Grid.y)
      LuaSkillCtrl:CallEffect(target, (self.config).effect_castend, self)
      local summoner = LuaSkillCtrl:CreateSummoner(self, (self.config).monsterId2, Grid.x, Grid.y)
      summoner:SetAttr(eHeroAttr.maxHp, (self.caster).maxHp * (self.arglist)[13] // 1000)
      summoner:SetAttr(eHeroAttr.skill_intensity, (self.caster).skill_intensity * (self.arglist)[8] // 1000)
      summoner:SetAttr(eHeroAttr.pow, (self.caster).pow * (self.arglist)[8] // 1000)
      summoner:SetAttr(eHeroAttr.speed, (self.caster).speed)
      summoner:SetAttr(eHeroAttr.def, (self.caster).def * (self.arglist)[12] // 1000)
      summoner:SetAttr(eHeroAttr.magic_res, (self.caster).magic_res * (self.arglist)[12] // 1000)
      summoner:SetAttr(eHeroAttr.lucky, (self.caster).lucky)
      summoner:SetAttr(eHeroAttr.crit, (self.caster).crit)
      local hostEntity = self.caster
      if hostEntity == nil or hostEntity.hp <= 0 then
        return over
      end
      for i,v in ipairs(SyncAttrList) do
        local curValue = (self.caster):GetRealProperty(v)
        summoner:SetAttr(v, curValue)
      end
      summoner:SetAsRealEntity(1)
      local arg1 = (self.arglist)[14]
      local arg2 = (self.arglist)[15]
      local tab = {arg_1 = arg1, arg_2 = arg2}
      summoner:SetRecordTable(tab)
      summonerEntity = LuaSkillCtrl:AddSummonerRole(summoner)
      -- DECOMPILER ERROR at PC278: Confused about usage of register: R10 in 'UnsetPending'

      if (self.table)[1] == nil then
        (self.table)[1] = summonerEntity
        self.haoshou_actor = summonerEntity
      else
        -- DECOMPILER ERROR at PC286: Confused about usage of register: R10 in 'UnsetPending'

        if (self.table)[2] == nil then
          (self.table)[2] = summonerEntity
          self.haoshou_actor = summonerEntity
        end
      end
    end
  end
end

bs_106101.OnSyncAttrFromHost = function(self)
  -- function num : 0_9 , upvalues : _ENV, SyncAttrList
  if #self.table <= 1 then
    return 
  end
  for i = 1, #self.table do
    if (self.table)[i] == self.gushou_actor then
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
      local curValue1 = (self.caster).def * (self.arglist)[9] // 1000
      local curValue2 = (self.caster).magic_res * (self.arglist)[9] // 1000
      summonerEntity:AddRoleProperty(eHeroAttr.def, curValue1 - attrValue_def, eHeroAttrType.Origin)
      summonerEntity:AddRoleProperty(eHeroAttr.magic_res, curValue2 - attrValue_ma_def, eHeroAttrType.Origin)
      local attrValue_pow = originAttrList[eHeroAttr.pow]
      local attrValue_int = originAttrList[eHeroAttr.skill_intensity]
      local curValue3 = (self.caster).pow * (self.arglist)[8] // 1000
      local curValue4 = (self.caster).skill_intensity * (self.arglist)[8] // 1000
      summonerEntity:AddRoleProperty(eHeroAttr.pow, curValue3 - attrValue_pow, eHeroAttrType.Origin)
      summonerEntity:AddRoleProperty(eHeroAttr.skill_intensity, curValue4 - attrValue_int, eHeroAttrType.Origin)
      local hp_per = summonerEntity.hp * 1000 // summonerEntity.maxHp
      local curValue_hp = (self.caster).maxHp * (self.arglist)[10] // 1000
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
            if (self.table)[i] == self.haoshou_actor then
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
              local curValue1 = (self.caster).def * (self.arglist)[12] // 1000
              local curValue2 = (self.caster).magic_res * (self.arglist)[12] // 1000
              summonerEntity:AddRoleProperty(eHeroAttr.def, curValue1 - attrValue_def, eHeroAttrType.Origin)
              summonerEntity:AddRoleProperty(eHeroAttr.magic_res, curValue2 - attrValue_ma_def, eHeroAttrType.Origin)
              local attrValue_pow = originAttrList[eHeroAttr.pow]
              local attrValue_int = originAttrList[eHeroAttr.skill_intensity]
              local curValue3 = (self.caster).pow * (self.arglist)[8] // 1000
              local curValue4 = (self.caster).skill_intensity * (self.arglist)[8] // 1000
              summonerEntity:AddRoleProperty(eHeroAttr.pow, curValue3 - attrValue_pow, eHeroAttrType.Origin)
              summonerEntity:AddRoleProperty(eHeroAttr.skill_intensity, curValue4 - attrValue_int, eHeroAttrType.Origin)
              local hp_per = summonerEntity.hp * 1000 // summonerEntity.maxHp
              local curValue_hp = (self.caster).maxHp * (self.arglist)[13] // 1000
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
                    -- DECOMPILER ERROR at PC300: LeaveBlock: unexpected jumping out DO_STMT

                    -- DECOMPILER ERROR at PC300: LeaveBlock: unexpected jumping out IF_ELSE_STMT

                    -- DECOMPILER ERROR at PC300: LeaveBlock: unexpected jumping out IF_STMT

                    -- DECOMPILER ERROR at PC300: LeaveBlock: unexpected jumping out IF_THEN_STMT

                    -- DECOMPILER ERROR at PC300: LeaveBlock: unexpected jumping out IF_STMT

                    -- DECOMPILER ERROR at PC300: LeaveBlock: unexpected jumping out DO_STMT

                    -- DECOMPILER ERROR at PC300: LeaveBlock: unexpected jumping out DO_STMT

                    -- DECOMPILER ERROR at PC300: LeaveBlock: unexpected jumping out IF_ELSE_STMT

                    -- DECOMPILER ERROR at PC300: LeaveBlock: unexpected jumping out IF_STMT

                    -- DECOMPILER ERROR at PC300: LeaveBlock: unexpected jumping out IF_THEN_STMT

                    -- DECOMPILER ERROR at PC300: LeaveBlock: unexpected jumping out IF_STMT

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

bs_106101.OnRoleDie = function(self, killer, role)
  -- function num : 0_10 , upvalues : _ENV
  if role == (self.table)[1] and role == self.gushou_actor then
    (table.remove)(self.table, 1)
    self.gushou = nil
  else
    if role == (self.table)[1] and role == self.haoshou_actor then
      (table.remove)(self.table, 1)
      self.haoshou = nil
    else
      if role == (self.table)[2] and role == self.gushou_actor then
        (table.remove)(self.table, 2)
        self.gushou = nil
      else
        if role == (self.table)[2] and role == self.haoshou_actor then
          (table.remove)(self.table, 2)
          self.haoshou = nil
        end
      end
    end
  end
end

bs_106101.OnCasterDie = function(self)
  -- function num : 0_11 , upvalues : base
  (base.OnCasterDie)(self)
  if self.timer ~= nil then
    (self.timer):Stop()
    self.timer = nil
  end
end

return bs_106101

