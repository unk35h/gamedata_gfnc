-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_70022 = class("bs_70022", LuaSkillBase)
local base = LuaSkillBase
bs_70022.config = {timeDuration = 15, formula1 = 10153, formula2 = 10154, formula3 = 10155, siglePoint = 100}
bs_70022.ctor = function(self)
  -- function num : 0_0
end

bs_70022.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.RoleDie, "bs_70022_10", 1, self.OnRoleDie)
  self.score = 0
  self.totalTime = (self.arglist)[1]
  self.timeValue = self.totalTime
  LuaSkillCtrl:SetGameScoreAcitve(2, true)
  LuaSkillCtrl:SetGameScoreValue(2, self.timeValue // 15)
  LuaSkillCtrl:SetGameScoreAcitve(3, true)
  LuaSkillCtrl:SetGameScoreValue(3, 0)
  local arriveCallBack = BindCallback(self, self.OnArriveAction)
  LuaSkillCtrl:StartTimer(nil, (self.config).timeDuration, arriveCallBack, self, -1)
  local timeCallBack = BindCallback(self, self.TimeUp)
  LuaSkillCtrl:StartTimer(nil, self.totalTime, timeCallBack)
end

bs_70022.OnRoleDie = function(self, killer, role)
  -- function num : 0_2 , upvalues : _ENV
  if role.belongNum ~= (self.caster).belongNum and role.roleDataId == 115 then
    self.score = self.score + (self.config).siglePoint
    local score = self.score
    local showScore = score
    if score > 600 then
      showScore = LuaSkillCtrl:CallFormulaNumber((self.config).formula1, self.caster, self.caster, score)
    else
      if score > 200 then
        showScore = LuaSkillCtrl:CallFormulaNumber((self.config).formula2, self.caster, self.caster, score)
      else
        showScore = LuaSkillCtrl:CallFormulaNumber((self.config).formula3, self.caster, self.caster, score)
      end
    end
    LuaSkillCtrl:SetGameScoreValue(3, showScore)
    LuaSkillCtrl:SetFinalScoreValue(2, score)
  end
end

bs_70022.OnArriveAction = function(self)
  -- function num : 0_3 , upvalues : _ENV
  self.timeValue = self.timeValue - (self.config).timeDuration
  local showTime = self.timeValue // 15
  LuaSkillCtrl:SetGameScoreValue(2, showTime)
end

bs_70022.TimeUp = function(self)
  -- function num : 0_4 , upvalues : _ENV
  LuaSkillCtrl:ForceEndBattle(true)
end

bs_70022.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_70022

