-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_105001 = class("bs_105001", LuaSkillBase)
local base = LuaSkillBase
bs_105001.config = {summonerId = 47, effectId = 105004, effectId_tip = 105013, selectId = 21, buffId = 105003, born_time = 20}
local SyncAttrList = {eHeroAttr.pow, eHeroAttr.skill_intensity, eHeroAttr.moveSpeed, eHeroAttr.dodge, eHeroAttr.speed, eHeroAttr.crit, eHeroAttr.critDamage, eHeroAttr.sunder, eHeroAttr.damage_increase, eHeroAttr.injury_reduce, eHeroAttr.heal, eHeroAttr.treatment, eHeroAttr.magic_pen, eHeroAttr.return_damage, eHeroAttr.life_steal, eHeroAttr.spell_life_steal}
bs_105001.ctor = function(self)
  -- function num : 0_0
end

bs_105001.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_105001_1", 1, self.OnAfterBattleStart)
  self:AddTrigger(eSkillTriggerType.RoleDie, "bs_105001_11", 1, self.OnRoleDie)
  self.__callSummoner = BindCallback(self, self.CallSummoner)
  self:AddLuaTrigger(eSkillLuaTrigger.PuzzleSummonerTimerAcc, self.AccTimer)
  self:AddTrigger(eSkillTriggerType.BeforeBattleEnd, "bs_105001_2", 1, self.BeforeBattleEnd)
  self.timer = 0
  -- DECOMPILER ERROR at PC38: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).ult_tip = false
end

bs_105001.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  self.startTime = LuaSkillCtrl:StartTimer(nil, (self.arglist)[1], self.__callSummoner)
  self.effect_tip = true
end

bs_105001.BeforeBattleEnd = function(self)
  -- function num : 0_3 , upvalues : _ENV
  if not LuaSkillCtrl.IsInVerify then
    LuaSkillCtrl:SetCountingColor(self.caster, 255, 255, 255, 255)
  end
  LuaSkillCtrl:HideCounting(self.caster)
end

bs_105001.CallSummoner = function(self)
  -- function num : 0_4 , upvalues : _ENV, SyncAttrList
  local grid = LuaSkillCtrl:CallFindEmptyGridMostRolesArounded(2)
  if grid == nil then
    self.startTime = LuaSkillCtrl:StartTimer(nil, (self.arglist)[1], self.__callSummoner)
    return 
  end
  local targetList = LuaSkillCtrl:FindRolesAroundGrid(grid, 2)
  if targetList == nil or targetList.Count == 0 then
    grid = LuaSkillCtrl:CallFindEmptyGridNearest(self.caster)
  end
  if grid == nil then
    self.startTime = LuaSkillCtrl:StartTimer(nil, (self.arglist)[1], self.__callSummoner)
    return 
  end
  if self.effect_tip == true then
    self.effect_tip = false
    local target = LuaSkillCtrl:GetTargetWithGrid(grid.x, grid.y)
    LuaSkillCtrl:CallEffect(target, (self.config).effectId, self)
  end
  do
    local summoner = LuaSkillCtrl:CreateSummoner(self, (self.config).summonerId, grid.x, grid.y)
    local ownerSkillIntensity = (self.caster).skill_intensity
    local defAndMagicRes = ownerSkillIntensity * (self.arglist)[2] // 1000
    summoner:SetAttr(eHeroAttr.magic_res, defAndMagicRes)
    summoner:SetAttr(eHeroAttr.def, defAndMagicRes)
    local hpAndMaxhp = ownerSkillIntensity * (self.arglist)[3] // 1000
    summoner:SetAttr(eHeroAttr.maxHp, hpAndMaxhp)
    local hostEntity = self.caster
    if hostEntity == nil or hostEntity.hp <= 0 then
      return over
    end
    for i,v in ipairs(SyncAttrList) do
      local curValue = (self.caster):GetRealProperty(v)
      summoner:SetAttr(v, curValue)
    end
    summoner:SetAsRealEntity(1)
    local arg1 = (self.arglist)[4]
    local arg2 = (self.arglist)[5]
    local tab = {arg_1 = arg1, arg_2 = arg2}
    summoner:SetRecordTable(tab)
    local summonerEntity = LuaSkillCtrl:AddSummonerRole(summoner)
    -- DECOMPILER ERROR at PC131: Confused about usage of register: R12 in 'UnsetPending'

    ;
    ((self.caster).recordTable)["105001_summoner"] = summonerEntity
    -- DECOMPILER ERROR at PC134: Confused about usage of register: R12 in 'UnsetPending'

    ;
    ((self.caster).recordTable)["105001_summoner_alive"] = true
    LuaSkillCtrl:CallBuff(self, summonerEntity, (self.config).buffId, 1, (self.config).born_time)
  end
end

bs_105001.OnSyncAttrFromHost = function(self)
  -- function num : 0_5 , upvalues : _ENV, SyncAttrList
  local summonerEntity = ((self.caster).recordTable)["105001_summoner"]
  if summonerEntity == nil then
    return 
  end
  local ownerSkillIntensity = (self.caster).skill_intensity
  for i,v in ipairs(SyncAttrList) do
    local attrValue = summonerEntity:GetRealProperty(v)
    local curValue = (self.caster):GetRealProperty(v)
    summonerEntity:AddRoleProperty(v, curValue - attrValue, eHeroAttrType.Origin)
  end
  local attrValue_def = summonerEntity:GetRealProperty(eHeroAttr.def)
  local attrValue_ma_def = summonerEntity:GetRealProperty(eHeroAttr.magic_res)
  local curValue = ownerSkillIntensity * (self.arglist)[2] // 1000
  summonerEntity:AddRoleProperty(eHeroAttr.def, curValue - attrValue_def, eHeroAttrType.Origin)
  summonerEntity:AddRoleProperty(eHeroAttr.magic_res, curValue - attrValue_ma_def, eHeroAttrType.Origin)
  local hp_per = summonerEntity.hp * 1000 // summonerEntity.maxHp
  local curValue_hp = ownerSkillIntensity * (self.arglist)[3] // 1000
  local attrValue_hp = summonerEntity:GetRealProperty(eHeroAttr.maxHp)
  summonerEntity:AddRoleProperty(eHeroAttr.maxHp, curValue_hp - attrValue_hp, eHeroAttrType.Origin)
  local hp_now = curValue_hp * hp_per // 1000
  if summonerEntity.hp < hp_now then
    local num = hp_now - summonerEntity.hp
    LuaSkillCtrl:CallHeal(num, self, summonerEntity, true)
  else
    do
      local num = summonerEntity.hp - hp_now
      LuaSkillCtrl:RemoveLife(num, self, summonerEntity, true, nil, false, true, 2, true)
    end
  end
end

bs_105001.OnRoleDie = function(self, killer, role, killSkill)
  -- function num : 0_6 , upvalues : _ENV
  if role.roleDataId ~= (self.config).summonerId or role.roleType ~= eBattleRoleType.realSummoner then
    return 
  end
  LuaSkillCtrl:CallEffect(role, (self.config).effectId_tip, self)
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.caster).recordTable)["105001_summoner_alive"] = false
  self.timer = 0
  -- DECOMPILER ERROR at PC24: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.caster).recordTable).ult_tip = true
end

bs_105001.AccTimer = function(self, arg)
  -- function num : 0_7 , upvalues : _ENV
  local arg4 = ((self.caster).recordTable).arg4
  do
    if arg == -1 then
      local grid = LuaSkillCtrl:CallFindEmptyGridMostRolesArounded(2)
      if grid == nil then
        LuaSkillCtrl:ShowCounting(self.caster, arg4, arg4)
        self.timer = arg4 - 1
        return 
      end
      -- DECOMPILER ERROR at PC22: Confused about usage of register: R4 in 'UnsetPending'

      ;
      ((self.caster).recordTable).ult_tip = false
      self:__callSummoner()
      LuaSkillCtrl:HideCounting(self.caster)
      self.timer = 0
      return 
    end
    if arg == -2 then
      self:OnSyncAttrFromHost()
      return 
    end
    self.timer = self.timer + 1
    if self.timer == arg then
      local grid = LuaSkillCtrl:CallFindEmptyGridMostRolesArounded(2)
      if grid == nil then
        LuaSkillCtrl:ShowCounting(self.caster, self.timer, arg)
        self.timer = self.timer - 1
        return 
      end
      self.effect_tip = true
      self:__callSummoner()
      LuaSkillCtrl:HideCounting(self.caster)
      self.timer = 0
    else
      do
        LuaSkillCtrl:ShowCounting(self.caster, self.timer, arg)
      end
    end
  end
end

bs_105001.OnCasterDie = function(self)
  -- function num : 0_8 , upvalues : base, _ENV
  (base.OnCasterDie)(self)
  LuaSkillCtrl:HideCounting(self.caster)
  if self.startTime ~= nil then
    (self.startTime):Stop()
    self.startTime = nil
  end
end

bs_105001.LuaDispose = function(self)
  -- function num : 0_9 , upvalues : base
  (base.LuaDispose)(self)
  if self.startTime ~= nil then
    (self.startTime):Stop()
    self.startTime = nil
  end
end

return bs_105001

