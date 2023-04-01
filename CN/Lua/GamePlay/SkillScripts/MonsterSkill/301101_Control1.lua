-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_301101 = class("bs_301101", LuaSkillBase)
local base = LuaSkillBase
bs_301101.config = {monsterId1 = 32, monsterId2 = 33, buffId = 1033, effectId = 10264, effectId1 = 10263, startAnimID = 1002, buffId1 = 175, buffId2 = 1033, buffId3 = 198, buffId4 = 88, skill_time = 18, maxEnemyNum = 3, maxHpPer = 150, powPer = 700, deathTime = 225}
bs_301101.ctor = function(self)
  -- function num : 0_0
end

bs_301101.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_301101_1", 1, self.OnAfterBattleStart)
  self.count = 0
end

bs_301101.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId1, 1, nil, true)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId2, 1, nil, true)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId3, 1, nil, true)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId4, 1, nil, true)
  LuaSkillCtrl:StartTimer(nil, 20, self.CallBack, self, -1, 20)
  LuaSkillCtrl:StartTimer(nil, (self.config).deathTime, self.Death, self)
end

bs_301101.Death = function(self)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId4, 0)
  LuaSkillCtrl:RemoveLife((self.caster).hp + 1, self, self.caster, true, nil, false, true)
end

bs_301101.CallBack = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local targetList = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.enemy)
  if targetList.Count < (self.config).maxEnemyNum then
    local cback = BindCallback(self, self.CallBack1, (self.config).monsterId1)
    local cback2 = BindCallback(self, self.CallBack1, (self.config).monsterId2)
    LuaSkillCtrl:StartTimer(nil, 2, cback, nil, 0, 0)
  end
end

bs_301101.CallBack1 = function(self, monsterId)
  -- function num : 0_5 , upvalues : _ENV
  local gridData = LuaSkillCtrl:CallFindEmptyGridNearest(self.caster)
  if gridData == nil then
    return 
  end
  local x = gridData.x
  local y = gridData.y
  local target = LuaSkillCtrl:GetTargetWithGrid(x, y)
  LuaSkillCtrl:CallEffect(target, (self.config).effectId, self)
  monsterId = (self.config).monsterId1 + self.count
  local summoner = LuaSkillCtrl:CreateSummoner(self, monsterId, x, y)
  summoner:SetAttr(eHeroAttr.maxHp, (self.caster).maxHp * (self.config).maxHpPer // 1000)
  summoner:SetAttr(eHeroAttr.pow, (self.caster).pow * (self.config).powPer // 1000)
  summoner:SetAttr(eHeroAttr.intensity, (self.caster).intensity * (self.config).powPer // 1000)
  summoner:SetAttr(eHeroAttr.speed, (self.caster).speed)
  summoner:SetAsRealEntity(1)
  local summonerEntity = LuaSkillCtrl:AddSummonerRole(summoner)
  if self.count == 0 then
    self.count = 1
  else
    self.count = 0
  end
end

bs_301101.OnCasterDie = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_301101

