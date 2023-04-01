-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_70008 = class("bs_70008", LuaSkillBase)
local base = LuaSkillBase
bs_70008.config = {buffId1 = 198, effectId = 12021, timeDuration = 15}
bs_70008.ctor = function(self)
  -- function num : 0_0
end

bs_70008.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_70008_1", 1, self.OnAfterBattleStart)
  self:AddAfterHurtTrigger("bs_70008_2", 2, self.OnAfterHurt, nil, self.caster)
  self.lastHpPercent = 100
  self.totalTime = 525
  local timeCallBack = BindCallback(self, self.TimeUp)
  LuaSkillCtrl:StartTimer(nil, self.totalTime, timeCallBack)
end

bs_70008.OnArriveAction = function(self)
  -- function num : 0_2 , upvalues : _ENV
  self.timeValue = self.timeValue - (self.config).timeDuration
  local showTime = (math.max)(0, self.timeValue // 15)
  LuaSkillCtrl:SetGameScoreValue(2, showTime)
end

bs_70008.TimeUp = function(self)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:ForceEndBattle(true)
end

bs_70008.OnAfterBattleStart = function(self)
  -- function num : 0_4 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId1, 1, nil, true)
end

bs_70008.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, isRealDmg, isTriggerSet)
  -- function num : 0_5 , upvalues : _ENV
  if target == self.caster and not isMiss then
    local nowHpPercent = target.hp * 100 // target.maxHp
    local diff = self.lastHpPercent - nowHpPercent
    do
      if (self.arglist)[1] // 10 < diff then
        local diffBiLi = diff * 10 // (self.arglist)[1]
        LuaSkillCtrl:AddPlayerTowerMp(diffBiLi * (self.arglist)[2])
        self.lastHpPercent = self.lastHpPercent - diffBiLi * (self.arglist)[1] // 10
      end
      if (self.arglist)[1] // 50 < diff then
        LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId, self)
      end
    end
  end
end

bs_70008.OnCasterDie = function(self)
  -- function num : 0_6 , upvalues : base
  self.lastHpPercent = nil
  ;
  (base.OnCasterDie)(self)
end

return bs_70008

