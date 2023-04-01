-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_93003 = class("bs_93003", LuaSkillBase)
local base = LuaSkillBase
bs_93003.config = {
monsterId = {1011, 1014}
, 
equipmentSummonerId = {1002, 1003, 1004}
, effectId = 12024, effectId_start = 5002205}
bs_93003.ctor = function(self)
  -- function num : 0_0
end

bs_93003.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  local arriveCallBack = BindCallback(self, self.OnArriveAction)
  self.timer = LuaSkillCtrl:StartTimer(nil, (self.arglist)[1], arriveCallBack, nil, -1, (self.arglist)[1])
  -- DECOMPILER ERROR at PC22: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.caster).recordTable).totalHp = 0
  -- DECOMPILER ERROR at PC25: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.caster).recordTable).totalAtk = 0
  -- DECOMPILER ERROR at PC28: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.caster).recordTable).totalIntensity = 0
  -- DECOMPILER ERROR at PC31: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.caster).recordTable).totalDef = 0
  -- DECOMPILER ERROR at PC34: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.caster).recordTable).totalMagicRes = 0
  local targetlist = LuaSkillCtrl:CallTargetSelect(self, 6, 10)
  if targetlist.Count < 1 then
    return 
  end
  -- DECOMPILER ERROR at PC48: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.caster).recordTable).roleNum = targetlist.Count
  for i = 0, targetlist.Count - 1 do
    local targetRole = (targetlist[i]).targetRole
    -- DECOMPILER ERROR at PC63: Confused about usage of register: R9 in 'UnsetPending'

    ;
    ((self.caster).recordTable).totalHp = ((self.caster).recordTable).totalHp + targetRole.maxHp
    -- DECOMPILER ERROR at PC71: Confused about usage of register: R9 in 'UnsetPending'

    ;
    ((self.caster).recordTable).totalAtk = ((self.caster).recordTable).totalAtk + targetRole.pow
    -- DECOMPILER ERROR at PC79: Confused about usage of register: R9 in 'UnsetPending'

    ;
    ((self.caster).recordTable).totalIntensity = ((self.caster).recordTable).totalIntensity + targetRole.skill_intensity
    -- DECOMPILER ERROR at PC87: Confused about usage of register: R9 in 'UnsetPending'

    ;
    ((self.caster).recordTable).totalDef = ((self.caster).recordTable).totalDef + targetRole.def
    -- DECOMPILER ERROR at PC95: Confused about usage of register: R9 in 'UnsetPending'

    ;
    ((self.caster).recordTable).totalMagicRes = ((self.caster).recordTable).totalMagicRes + targetRole.magic_res
  end
end

bs_93003.OnArriveAction = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if self.timer ~= nil and (self.timer):IsOver() then
    self.timer = nil
  end
  local targetGrid = LuaSkillCtrl:FindEmptyGrid()
  if targetGrid ~= nil then
    local index = LuaSkillCtrl:CallRange(1, 2)
    local monsterId = ((self.config).monsterId)[index]
    local summoner = LuaSkillCtrl:CreateSummoner(self, monsterId, targetGrid.x, targetGrid.y)
    local roleNum = 5
    if ((self.caster).recordTable).roleNum ~= nil then
      roleNum = ((self.caster).recordTable).roleNum
    end
    if roleNum > 0 then
      local num, level = LuaSkillCtrl:GetDynPlayerChipCountAndLevelSum()
      local Finalhp = (1 + level * 150 // 1000) * 100000 // roleNum
      if ((self.caster).recordTable).totalHp ~= nil then
        Finalhp = (1 + level * 150 // 1000) * ((self.caster).recordTable).totalHp // roleNum
      end
      local Finalpow = (1 + level * 120 // 1000) * 5000 // roleNum
      if ((self.caster).recordTable).totalAtk ~= nil then
        Finalpow = (1 + level * 120 // 1000) * ((self.caster).recordTable).totalAtk // roleNum
      end
      local Finalintensity = (1 + level * 120 // 1000) * 5000 // roleNum
      if ((self.caster).recordTable).totalIntensity ~= nil then
        Finalintensity = (1 + level * 120 // 1000) * ((self.caster).recordTable).totalIntensity // roleNum
      end
      local FinalDef = 500
      if ((self.caster).recordTable).totalDef ~= nil then
        FinalDef = ((self.caster).recordTable).totalDef
      end
      local FinalRes = 500
      if ((self.caster).recordTable).totalMagicRes ~= nil then
        FinalRes = ((self.caster).recordTable).totalMagicRes
      end
      summoner:SetAttr(eHeroAttr.maxHp, Finalhp)
      summoner:SetAttr(eHeroAttr.pow, Finalpow)
      summoner:SetAttr(eHeroAttr.skill_intensity, Finalintensity)
      summoner:SetAttr(eHeroAttr.def, FinalDef // roleNum)
      summoner:SetAttr(eHeroAttr.magic_res, FinalRes // roleNum)
      summoner:SetAttr(eHeroAttr.speed, 100)
      summoner:SetAsRealEntity(1)
      local summonerEntity = LuaSkillCtrl:AddSummonerRole(summoner)
      self:CallSelectExecute(summonerEntity)
      LuaSkillCtrl:CallEffect(summonerEntity, (self.config).effectId_start, self)
    end
  end
end

bs_93003.CallSelectExecute = function(self, role)
  -- function num : 0_3 , upvalues : _ENV
  if role == nil then
    return 
  end
  local existSummoner = LuaSkillCtrl:GetEquipmentSummonerOrHostEntity(role)
  if existSummoner ~= nil then
    warn("该人形已装备了义肢")
    return 
  end
  local index = LuaSkillCtrl:CallRange(1, 3)
  local equipmentId = ((self.config).equipmentSummonerId)[index]
  local summoner = LuaSkillCtrl:CreateSummoner(self, equipmentId, role.x, role.y)
  summoner:SetAttr(eHeroAttr.maxHp, 1)
  summoner:SetAttr(eHeroAttr.pow, 1)
  summoner:SetAttr(eHeroAttr.intensity, 1)
  summoner:SetAttr(eHeroAttr.speed, role.speed)
  summoner:SetAsRealEntity(7)
  local key = (ConfigData.buildinConfig).EquipmentSummonerKey
  local tab = {[key] = role}
  summoner:SetRecordTable(tab)
  local summonerEntity = LuaSkillCtrl:AddSummonerRole(summoner)
  if summonerEntity ~= nil then
    LuaSkillCtrl:CallBuff(self, summonerEntity, (ConfigData.buildinConfig).EquipmentSummonerInvinsibleBuffId, 1, nil)
    -- DECOMPILER ERROR at PC76: Confused about usage of register: R9 in 'UnsetPending'

    ;
    (role.recordTable)[key] = summonerEntity
    do
      if not LuaSkillCtrl.IsInVerify then
        local trans = (summonerEntity.lsObject).transform
        if not IsNull(trans) then
          trans:SetLocalScale((trans.localScale).x, (trans.localScale).y, -(trans.localScale).z)
        end
      end
      summonerEntity:BindHostEntity(role)
      LuaSkillCtrl:CallEffect(summonerEntity, (self.config).effectId, self)
    end
  end
end

bs_93003.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
  if self.timer ~= nil then
    (self.timer):Stop()
    self.timer = nil
  end
end

return bs_93003

