-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_81016 = class("bs_81016", LuaSkillBase)
local base = LuaSkillBase
bs_81016.config = {monsterId = 1021, totalTime = 0, maxHp = 39804, pow = 1351, intensity = 1179, speed = 300}
bs_81016.ctor = function(self)
  -- function num : 0_0
end

bs_81016.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_81016_1", 1, self.OnAfterBattleStart)
end

bs_81016.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local targetlist = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.enemy)
  if targetlist.Count < 1 then
    return 
  end
  for i = 0, targetlist.Count - 1 do
    local targetRole = targetlist[i]
    if targetRole.roleDataId == 20097 then
      self.flag = true
    end
  end
  if self.flag then
    local arriveCallBack = BindCallback(self, self.Chuxian)
    LuaSkillCtrl:StartTimer(nil, (self.config).totalTime, arriveCallBack)
  end
end

bs_81016.Chuxian = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local grid = LuaSkillCtrl:FindEmptyGrid(nil)
  if grid ~= nil then
    local summoner = LuaSkillCtrl:CreateSummoner(self, (self.config).monsterId, grid.x, grid.y)
    summoner:SetAttr(eHeroAttr.maxHp, (self.config).maxHp)
    summoner:SetAttr(eHeroAttr.pow, (self.config).pow)
    summoner:SetAttr(eHeroAttr.skill_intensity, (self.config).intensity)
    summoner:SetAttr(eHeroAttr.speed, (self.config).speed)
    summoner:SetAsRealEntity(1)
    local summonerEntity = LuaSkillCtrl:AddSummonerRole(summoner)
    LuaSkillCtrl:CallEffect(summonerEntity, 10264, self)
    if not LuaSkillCtrl.IsInVerify then
      local battleCtrl = ((CS.BattleManager).Instance).CurBattleController
      local actionComponent = summonerEntity:GetActionComponent()
      actionComponent:ResetAnimator(true, true)
    end
  end
end

bs_81016.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_81016

