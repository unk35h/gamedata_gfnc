-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_20120 = class("bs_20120", LuaSkillBase)
local base = LuaSkillBase
bs_20120.config = {monsterId = 29, totalTime = 150, maxHp = 20000, pow = 800, intensity = 1600, speed = 150}
bs_20120.ctor = function(self)
  -- function num : 0_0
end

bs_20120.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_20120_1", 1, self.OnAfterBattleStart)
end

bs_20120.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local arriveCallBack = BindCallback(self, self.Chuxian)
  LuaSkillCtrl:StartTimer(nil, (self.config).totalTime, arriveCallBack)
end

bs_20120.Chuxian = function(self)
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
  end
end

bs_20120.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_20120

