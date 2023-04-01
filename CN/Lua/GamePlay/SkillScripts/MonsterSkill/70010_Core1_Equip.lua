-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_70010 = class("bs_70010", LuaSkillBase)
local base = LuaSkillBase
bs_70010.config = {equipmentSummonerId = 1000, buffId_mark = 1234, skillId = 70026}
bs_70010.ctor = function(self)
  -- function num : 0_0
end

bs_70010.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_70010.PlaySkill = function(self, data, selectTargetCoord, selectRoles)
  -- function num : 0_2 , upvalues : _ENV
  if selectRoles ~= nil and selectRoles.Count >= 1 then
    local role = selectRoles[0]
    local existSummoner = LuaSkillCtrl:GetEquipmentSummonerOrHostEntity(role)
    if existSummoner ~= nil then
      return false
    end
  end
  do
    return self:GetSelectTargetAndExecute(selectRoles, BindCallback(self, self.CallSelectExecute))
  end
end

bs_70010.CallSelectExecute = function(self, role)
  -- function num : 0_3 , upvalues : _ENV
  if role == nil then
    return 
  end
  local existSummoner = LuaSkillCtrl:GetEquipmentSummonerOrHostEntity(role)
  if existSummoner ~= nil then
    warn("该人形已装备了义肢")
    return 
  end
  local roleAtkSkill = nil
  if (self.config).buffId_mark ~= nil and (self.config).skillId then
    LuaSkillCtrl:CallBuff(self, role, (self.config).buffId_mark, 1, nil, true)
    roleAtkSkill = role:GetBattleSkill((self.config).skillId)
  end
  if roleAtkSkill == nil then
    return 
  end
  local summoner = (LuaSkillCtrl.cluaSkillCtrl):CreateSummoner(roleAtkSkill, (self.config).equipmentSummonerId, role.x, role.y, -1)
  summoner:SetAttr(eHeroAttr.maxHp, 1)
  summoner:SetAttr(eHeroAttr.pow, 1)
  summoner:SetAttr(eHeroAttr.intensity, 1)
  summoner:SetAttr(eHeroAttr.speed, role.speed)
  summoner:SetAsRealEntity(7)
  local key = (ConfigData.buildinConfig).EquipmentSummonerKey
  local tab = {[key] = role, equipSummoner = true}
  summoner:SetRecordTable(tab)
  local summonerEntity = LuaSkillCtrl:AddSummonerRole(summoner)
  if summonerEntity ~= nil then
    LuaSkillCtrl:CallBuff(self, summonerEntity, (ConfigData.buildinConfig).EquipmentSummonerInvinsibleBuffId, 1, nil)
    -- DECOMPILER ERROR at PC99: Confused about usage of register: R8 in 'UnsetPending'

    ;
    (role.recordTable)[key] = summonerEntity
    summonerEntity:BindHostEntity(role)
    if not LuaSkillCtrl.IsInVerify then
      local trans = (summonerEntity.lsObject).transform
      if not IsNull(trans) then
        trans:SetLocalScale((trans.localScale).x, (trans.localScale).y, -(trans.localScale).z)
      end
      -- DECOMPILER ERROR at PC127: Confused about usage of register: R9 in 'UnsetPending'

      ;
      ((summonerEntity.lsObject).transform).localRotation = Quaternion.identity
    end
  end
end

return bs_70010

