-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_102903 = class("bs_102903", LuaSkillBase)
local base = LuaSkillBase
bs_102903.config = {monsterId = 17, buff_id = 102901, buffId_bati = 198, audioIdStart = 102905, audioIdMovie = 102906, audioIdEnd = 102907, buffId = 3014}
bs_102903.CheckManualSkillTakeAvailable = function(self, role)
  -- function num : 0_0 , upvalues : base
  if role ~= nil then
    return false
  end
  return (base.CheckManualSkillTakeAvailable)(self, role)
end

bs_102903.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  if LuaSkillCtrl.IsInTDBattle and LuaSkillCtrl.cluaSkillCtrl ~= nil then
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId, 1, true, true)
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1, nil, true)
  end
end

bs_102903.PlayUltMovie = function(self, moveSelectTarget, selectTargetCoord, selectRoles)
  -- function num : 0_2 , upvalues : base, _ENV
  if not self:IsConsumeSkill() then
    return (base.PlayUltMovie)(self, moveSelectTarget, selectTargetCoord, selectRoles)
  end
  if selectTargetCoord == nil then
    return true
  end
  local targetGrid_role = LuaSkillCtrl:GetRoleWithPos(selectTargetCoord.x, selectTargetCoord.y)
  if targetGrid_role ~= nil then
    return true
  end
  return (base.PlayUltMovie)(self, moveSelectTarget, selectTargetCoord, selectRoles)
end

bs_102903.PlaySkill = function(self, data, selectTargetCoord, selectRoles)
  -- function num : 0_3 , upvalues : _ENV
  local arg1 = (self.arglist)[1]
  local arg2 = (self.arglist)[2]
  local arg3 = (self.arglist)[3]
  local tab = {arg_1 = arg1, arg_2 = arg2, arg_3 = arg3}
  self:CallCasterWait(5)
  if selectTargetCoord ~= nil then
    local targetGrid_role = LuaSkillCtrl:GetRoleWithPos(selectTargetCoord.x, selectTargetCoord.y)
    if targetGrid_role == nil then
      local summoner = LuaSkillCtrl:CreateSummoner(self, (self.config).monsterId, selectTargetCoord.x, selectTargetCoord.y)
      summoner:SetAttr(eHeroAttr.maxHp, arg1)
      summoner:SetAsRealEntity(1)
      summoner:SetRecordTable(tab)
      local summonerEntity = LuaSkillCtrl:AddSummonerRole(summoner)
      LuaSkillCtrl:CallBuff(self, summonerEntity, (self.config).buff_id, 1, arg2, true)
      LuaSkillCtrl:CallBuff(self, summonerEntity, (self.config).buffId_bati, 1, nil, true)
    end
  end
end

bs_102903.PlayUltEffect = function(self, data, selectTargetCoord, selectRoles)
  -- function num : 0_4 , upvalues : base, _ENV
  (base.PlayUltEffect)(self)
  local targetRole = LuaSkillCtrl:GetRoleWithPos(selectTargetCoord.x, selectTargetCoord.y)
  if targetRole ~= nil then
    return true
  end
  LuaSkillCtrl:CallBuff(self, self.caster, 196, 1, 15, true)
  LuaSkillCtrl:CallFocusTimeLine(self.caster)
end

bs_102903.OnUltRoleAction = function(self)
  -- function num : 0_5 , upvalues : base, _ENV
  (base.OnUltRoleAction)(self)
  LuaSkillCtrl:StartTimerInUlt(self, 7, self.PlayUltMovie)
  LuaSkillCtrl:CallRoleAction(self.caster, 1005, 1)
end

bs_102903.OnCasterDie = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_102903

