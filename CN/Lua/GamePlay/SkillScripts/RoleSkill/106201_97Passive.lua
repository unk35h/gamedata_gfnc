-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_106201 = class("bs_106201", LuaSkillBase)
local base = LuaSkillBase
bs_106201.config = {buffId_Taunt = 3002, buffId_unselected = 206806, buffId1 = 106201, buffId2 = 106203, MoveDuration = 4, effectId_show = 106216, effectId_cc = 106209, effectId_showdd = 106206, actionId1_start = 1008, actionId1_loop = 1007, actionId1_end = 1009, actionId1_end2 = 1056, actionId_start_time = 13, MoveDuration = 5, monsterId = 62}
bs_106201.ctor = function(self)
  -- function num : 0_0
end

bs_106201.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHealTrigger("bs_106201_5", 2, self.OnAfterHeal, nil, nil, (self.caster).belongNum)
  self:AddAfterHurtTrigger("bs_106201_3", 1, self.OnAfterHurt, nil, nil, (self.caster).belongNum)
  self:AddAfterAddBuffTrigger("bs_106201_7", 1, self.OnAfterAddBuff, nil, nil, (self.caster).belongNum, nil, (self.config).buffId2)
  self:AddLuaTrigger(eSkillLuaTrigger.OnJiangyuSkill, self.OnJiangyuSkill)
  self:AddOnRoleDieTrigger("bs_106201_2", 1, self.OnRoleDie, nil, nil, nil, (self.caster).belongNum)
  self.num = 0
  -- DECOMPILER ERROR at PC49: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).c_add = (self.arglist)[9]
  -- DECOMPILER ERROR at PC54: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).c_addH = (self.arglist)[10]
  -- DECOMPILER ERROR at PC58: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).is_pass = flase
  self.maxCount = 2
  self.table = {}
  self.time = 0
  self.time2 = 0
end

bs_106201.OnJiangyuSkill = function(self, target)
  -- function num : 0_2 , upvalues : _ENV
  if self.time2 < 1 then
    self.time2 = self.time2 + 1
    local grid = self:FindGrid(target)
    do
      if (table.length)(self.table) < self.maxCount and grid ~= nil then
        LuaSkillCtrl:StartTimer(nil, 1 + (self.config).actionId_start_time, function()
    -- function num : 0_2_0 , upvalues : _ENV, grid, self
    local targetGrid = LuaSkillCtrl:GetTargetWithGrid(grid.x, grid.y)
    LuaSkillCtrl:CallEffect(targetGrid, (self.config).effectId_showdd, self)
  end
)
        LuaSkillCtrl:StartTimer(nil, 2 + (self.config).actionId_start_time, function()
    -- function num : 0_2_1 , upvalues : self, grid
    self:Summon(grid)
  end
)
      end
    end
  end
end

bs_106201.OnAfterAddBuff = function(self, buff, target)
  -- function num : 0_3 , upvalues : _ENV
  if target.belongNum ~= (self.caster).belongNum then
    LuaSkillCtrl:CallBuff(self, target, (self.config).buffId1, 1, (self.arglist)[7], false)
  end
end

bs_106201.OnAfterHeal = function(self, sender, target, skill, heal, isStealHeal, isCrit, isTriggerSet)
  -- function num : 0_4 , upvalues : _ENV
  if sender.belongNum == (self.caster).belongNum and isCrit and not isTriggerSet then
    self.num = self.num + 1
    if (self.arglist)[1] <= self.num and not ((self.caster).recordTable).IsInSkill1 and not LuaSkillCtrl:RoleContainsBuffFeature(self.caster, eBuffFeatureType.Stun) then
      self:Passive()
    end
  end
end

bs_106201.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_5 , upvalues : _ENV
  if sender.belongNum == (self.caster).belongNum and isCrit and not isTriggerSet then
    self.num = self.num + 1
    if (self.arglist)[1] <= self.num and not ((self.caster).recordTable).IsInSkill1 and not LuaSkillCtrl:RoleContainsBuffFeature(self.caster, eBuffFeatureType.Stun) then
      self:Passive()
    end
  end
end

bs_106201.Passive = function(self)
  -- function num : 0_6 , upvalues : _ENV
  local target = ((self.caster).recordTable).lastAttackRole
  self.num = 0
  local grid_now = LuaSkillCtrl:GetGridWithRole(self.caster)
  local last_target = ((self.caster).recordTable).lastAttackRole
  local target = nil
  if last_target ~= nil and last_target.hp > 0 and last_target.belongNum ~= eBattleRoleBelong.neutral and LuaSkillCtrl:IsAbleAttackTarget(self.caster, last_target, (self.cskill).SkillRange) then
    target = last_target
  else
    local tempTarget = self:GetMoveSelectTarget()
    if tempTarget == nil then
      self.num = (self.arglist)[1]
      return 
    end
    target = tempTarget.targetRole
  end
  do
    if target == nil or target.hp <= 0 then
      self.num = (self.arglist)[1]
      return 
    end
    local grid = self:FindGrid(target)
    if grid == nil then
      self.num = (self.arglist)[1]
      return 
    end
    LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId1_start, 1)
    self:CallCasterWait((self.config).actionId_start_time + (self.config).MoveDuration + 3)
    LuaSkillCtrl:PreSetRolePos(grid, self.caster)
    LuaSkillCtrl:StartTimer(self, (self.config).actionId_start_time, function()
    -- function num : 0_6_0 , upvalues : _ENV, self, grid
    LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId_loop, 1)
    LuaSkillCtrl:CanclePreSetPos(self.caster)
    LuaSkillCtrl:CallPhaseMove(self, self.caster, grid.x, grid.y, (self.config).MoveDuration, (self.config).buffId_unselected)
    LuaSkillCtrl:StartTimer(nil, 1, function()
      -- function num : 0_6_0_0
    end
)
    local effect = LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_cc, self)
    LuaSkillCtrl:StartTimer(nil, (self.config).MoveDuration + 3, function()
      -- function num : 0_6_0_1 , upvalues : effect
      if effect ~= nil then
        effect:Die()
        effect = nil
      end
    end
)
    LuaSkillCtrl:CallResetCDNumForRole(self.caster, (self.arglist)[11])
  end
)
    if (table.length)(self.table) < self.maxCount then
      LuaSkillCtrl:StartTimer(nil, 2 + (self.config).actionId_start_time, function()
    -- function num : 0_6_1 , upvalues : _ENV, grid_now, self
    local targetGrid = LuaSkillCtrl:GetTargetWithGrid(grid_now.x, grid_now.y)
    LuaSkillCtrl:CallEffect(targetGrid, (self.config).effectId_showdd, self)
  end
)
      LuaSkillCtrl:StartTimer(nil, 3 + (self.config).actionId_start_time, function()
    -- function num : 0_6_2 , upvalues : self, grid_now, target
    self:Summon(grid_now, target)
  end
)
    else
      self.time = self.time + 1
      do
        -- DECOMPILER ERROR at PC127: Unhandled construct in 'MakeBoolean' P1

        if self.time % 2 == 0 and self.maxCount <= (table.length)(self.table) then
          local role = (self.table)[2]
          if role ~= nil and role.hp > 0 then
            LuaSkillCtrl:DispelBuff(role, 106205)
            LuaSkillCtrl:RemoveLife(role.maxHp * 10, self, role, false, nil, false, true, 1, true)
          end
        end
        do
          if self.maxCount <= (table.length)(self.table) then
            local role = (self.table)[1]
            if role ~= nil and role.hp > 0 then
              LuaSkillCtrl:DispelBuff(role, 106205)
              LuaSkillCtrl:RemoveLife(role.maxHp * 10, self, role, false, nil, false, true, 1, true)
            end
          end
          LuaSkillCtrl:StartTimer(nil, 1 + (self.config).actionId_start_time, function()
    -- function num : 0_6_3 , upvalues : _ENV, grid_now, self
    local targetGrid = LuaSkillCtrl:GetTargetWithGrid(grid_now.x, grid_now.y)
    LuaSkillCtrl:CallEffect(targetGrid, (self.config).effectId_showdd, self)
  end
)
          LuaSkillCtrl:StartTimer(nil, 2 + (self.config).actionId_start_time, function()
    -- function num : 0_6_4 , upvalues : self, grid_now, target
    self:Summon(grid_now, target)
  end
)
          LuaSkillCtrl:StartTimer(self, (self.config).actionId_start_time + (self.config).MoveDuration, function()
    -- function num : 0_6_5 , upvalues : _ENV, self, target
    LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId1_end, 1)
    -- DECOMPILER ERROR at PC13: Confused about usage of register: R0 in 'UnsetPending'

    if target ~= nil then
      ((self.caster).recordTable).lastAttackRole = target
    end
  end
)
        end
      end
    end
  end
end

bs_106201.Summon = function(self, grid1, target)
  -- function num : 0_7 , upvalues : _ENV
  if grid1 ~= nil then
    local summonerEntity = nil
    local role1 = (LuaSkillCtrl:GetRoleWithPos(grid1.x, grid1.y))
    local Grid = nil
    if role1 ~= nil then
      local Grid = self:FindGrid(target)
    else
      do
        local Grid = grid1
        local monsterId = (self.config).monsterId
        if LuaSkillCtrl:GetCasterSkinId(self.caster) == 306203 then
          monsterId = 64
        end
        local summoner = LuaSkillCtrl:CreateSummoner(self, monsterId, Grid.x, Grid.y)
        summoner:SetAttr(eHeroAttr.maxHp, (self.caster).maxHp * (self.arglist)[2] // 1000)
        summoner:SetAttr(eHeroAttr.skill_intensity, (self.caster).skill_intensity * (self.arglist)[3] // 1000)
        summoner:SetAttr(eHeroAttr.pow, (self.caster).pow * (self.arglist)[3] // 1000)
        summoner:SetAttr(eHeroAttr.speed, (self.caster).speed)
        summoner:SetAttr(eHeroAttr.moveSpeed, 0)
        summoner:SetAttr(eHeroAttr.def, (self.caster).def)
        summoner:SetAttr(eHeroAttr.magic_res, (self.caster).magic_res)
        summoner:SetAttr(eHeroAttr.lucky, (self.caster).lucky)
        summoner:SetAttr(eHeroAttr.crit, (self.caster).crit * (self.arglist)[4] // 1000)
        summoner:SetAttr(eHeroAttr.critDamage, (self.caster).critDamage)
        summoner:SetAttr(eHeroAttr.sunder, (self.caster).sunder)
        summoner:SetAttr(eHeroAttr.damage_increase, (self.caster).damage_increase)
        summoner:SetAttr(eHeroAttr.injury_reduce, (self.caster).injury_reduce)
        summoner:SetAttr(eHeroAttr.magic_pen, (self.caster).magic_pen)
        summoner:SetAsRealEntity(1)
        local arg1 = (self.arglist)[6]
        local arg2 = nil
        if (self.table)[1] == nil then
          arg2 = 1
        else
          if (self.table)[2] == nil then
            arg2 = 2
          end
        end
        local arg3 = (self.arglist)[5]
        local arg4 = (self.arglist)[2]
        local skinId = 106200
        if LuaSkillCtrl:GetCasterSkinId(self.caster) == 306203 then
          skinId = 306203
        end
        local tab = {arg_1 = arg1, arg_2 = arg2, arg_3 = arg3, arg_4 = arg4, skinId = skinId}
        summoner:SetRecordTable(tab)
        summonerEntity = LuaSkillCtrl:AddSummonerRole(summoner)
        -- DECOMPILER ERROR at PC179: Confused about usage of register: R15 in 'UnsetPending'

        if (self.table)[1] == nil then
          (self.table)[1] = summonerEntity
        else
          -- DECOMPILER ERROR at PC186: Confused about usage of register: R15 in 'UnsetPending'

          if (self.table)[2] == nil then
            (self.table)[2] = summonerEntity
          end
        end
      end
    end
  end
end

bs_106201.OnRoleDie = function(self, killer, role)
  -- function num : 0_8
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R3 in 'UnsetPending'

  if role == (self.table)[1] then
    (self.table)[1] = nil
  else
    -- DECOMPILER ERROR at PC12: Confused about usage of register: R3 in 'UnsetPending'

    if role == (self.table)[2] then
      (self.table)[2] = nil
    end
  end
end

bs_106201.FindGrid = function(self, role)
  -- function num : 0_9 , upvalues : _ENV
  if role ~= nil then
    local grid_dict = LuaSkillCtrl:FindEmptyGridsWithinRange(role.x, role.y, 1)
    if grid_dict == nil or grid_dict.Count <= 0 then
      local targetList = (LuaSkillCtrl:CallTargetSelect(self, 9, 10))
      local grid2 = nil
      for i = 0, targetList.Count - 1 do
        if targetList[i] ~= nil and (targetList[i]).targetRole ~= nil and ((targetList[i]).targetRole).belongNum ~= eBattleRoleBelong.neutral then
          local role1 = (targetList[i]).targetRole
          local grid_dict1 = LuaSkillCtrl:FindEmptyGridsWithinRange(role1.x, role1.y, 1)
          if grid_dict1 == nil or grid_dict1.Count == 0 then
            grid2 = nil
          else
            grid2 = grid_dict1[0]
            return grid2
          end
        end
      end
      local grid7 = LuaSkillCtrl:FindEmptyGrid(nil)
      return grid7
    else
      do
        local dismax = 0
        do
          local grid1 = grid_dict[0]
          for i = 0, grid_dict.Count - 1 do
            local dis = LuaSkillCtrl:GetGridsDistance((self.caster).x, (self.caster).y, (grid_dict[i]).x, (grid_dict[i]).y)
            if dismax < dis then
              dismax = dis
              grid1 = grid_dict[i]
            end
          end
          do return grid1 end
          local targetList = (LuaSkillCtrl:CallTargetSelect(self, 9, 10))
          -- DECOMPILER ERROR at PC94: Overwrote pending register: R3 in 'AssignReg'

          local grid4 = .end
          for i = 0, targetList.Count - 1 do
            if targetList[i] ~= nil and (targetList[i]).targetRole ~= nil and ((targetList[i]).targetRole).belongNum ~= eBattleRoleBelong.neutral then
              local role1 = (targetList[i]).targetRole
              local grid_dict1 = LuaSkillCtrl:FindEmptyGridsWithinRange(role1.x, role1.y, 1)
              if grid_dict1 == nil or grid_dict1.Count == 0 then
                grid4 = nil
              else
                grid4 = grid_dict1[0]
                return grid4
              end
            end
          end
          local grid7 = LuaSkillCtrl:FindEmptyGrid(nil)
          do return grid7 end
        end
      end
    end
  end
end

bs_106201.OnCasterDie = function(self)
  -- function num : 0_10 , upvalues : _ENV, base
  LuaSkillCtrl:CanclePreSetPos(self.caster)
  ;
  (base.OnCasterDie)(self)
end

bs_106201.LuaDispose = function(self)
  -- function num : 0_11 , upvalues : base
  self.table = nil
  ;
  (base.LuaDispose)(self)
end

return bs_106201

