-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_204802 = class("bs_204802", LuaSkillBase)
local base = LuaSkillBase
bs_204802.config = {maxHpPer = 100, powPer = 500, buffFeature_ignoreDie = 6, effect_hudun = 204806, effect_killSummoner = 204807, effect_zd = 204809, effect_heal = 204810, effect_summon = 204814, actionId = 1008, action_speed = 1, start_time = 15, actionId_end = 1009, buffId_170 = 3008, buff_SummonerSign = 2048011, buff_invincible = 2048021, buffId_attack1 = 2048022, buffId_int1 = 2048023, buffId_defense1 = 2048024, buffId_attack2 = 2048025, buffId_int2 = 2048026, buffId_defense2 = 2048027, buffId_skillfast = 2048028, SetStage2Hp = 700, SetStage3Hp = 400}
bs_204802.ctor = function(self)
  -- function num : 0_0
end

bs_204802.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddLuaTrigger(eSkillLuaTrigger.OnSummonerDieForDemiurge, self.RoleDie)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_204802_2", 1, self.AfterBattleStart)
  self.heal = 0
  self.SummonerAliveCount = 0
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).stage = 1
end

bs_204802.AfterBattleStart = function(self)
  -- function num : 0_2
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R1 in 'UnsetPending'

  if (self.caster).hp < (self.caster).maxHp * (self.arglist)[5] // 1000 then
    ((self.caster).recordTable).stage = 3
  else
    -- DECOMPILER ERROR at PC26: Confused about usage of register: R1 in 'UnsetPending'

    if (self.caster).hp < (self.caster).maxHp * (self.arglist)[4] // 1000 then
      ((self.caster).recordTable).stage = 2
    else
      -- DECOMPILER ERROR at PC30: Confused about usage of register: R1 in 'UnsetPending'

      ;
      ((self.caster).recordTable).stage = 1
    end
  end
  self:AddSetHurtTrigger("bs_204802_2", 99, self.OnSetHurt, nil, self.caster)
end

bs_204802.OnSetHurt = function(self, context)
  -- function num : 0_3 , upvalues : _ENV
  local ShieldNormal = LuaSkillCtrl:GetShield(self.caster, eShieldType.Normal)
  local num1 = (self.caster).hp + ShieldNormal - (self.caster).maxHp * (self.arglist)[4] // 1000
  if context.target == self.caster and num1 <= context.hurt and ((self.caster).recordTable).stage == 1 and LuaSkillCtrl:GetRoleBuffById(self.caster, (self.config).buff_invincible) == nil then
    context.hurt = num1
    LuaSkillCtrl:RemoveLife(num1, self, self.caster, true, nil, false, true, eHurtType.RealDmg, true)
    -- DECOMPILER ERROR at PC52: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.caster).recordTable).stage = 2
    self:PlaySkill()
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_attack1, 1, nil, true)
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_int1, 1, nil, true)
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_defense1, 1, nil, true)
    return 
  end
  local num2 = (self.caster).hp + ShieldNormal - (self.caster).maxHp * (self.arglist)[5] // 1000
  if context.target == self.caster and num2 <= context.hurt and ((self.caster).recordTable).stage == 2 and LuaSkillCtrl:GetRoleBuffById(self.caster, (self.config).buff_invincible) == nil then
    context.hurt = num2
    LuaSkillCtrl:RemoveLife(num2, self, self.caster, true, nil, false, true, eHurtType.RealDmg, true)
    -- DECOMPILER ERROR at PC132: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self.caster).recordTable).stage = 3
    self:PlaySkill()
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_attack1, 1, true)
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_int1, 1, true)
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_defense1, 1, true)
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_attack2, 1, nil, true)
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_int2, 1, nil, true)
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_defense2, 1, nil, true)
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_skillfast, 1, nil, true)
  end
end

bs_204802.PlaySkill = function(self, data)
  -- function num : 0_4 , upvalues : _ENV
  self:CallCasterWait((self.arglist)[1])
  LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).actionId, (self.config).action_speed, (self.arglist)[1])
  self:InvincibleSummon()
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_170, 1, (self.arglist)[1], true)
  LuaSkillCtrl:StartShowSkillDurationTime(self, (self.arglist)[1])
end

bs_204802.InvincibleSummon = function(self)
  -- function num : 0_5 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buff_invincible, 1, (self.arglist)[1], true)
  LuaSkillCtrl:StartTimer(self, (self.arglist)[1], function()
    -- function num : 0_5_0 , upvalues : _ENV, self
    LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId_end, 1)
  end
)
  LuaSkillCtrl:StartTimer(self, (self.arglist)[1] + 15, function()
    -- function num : 0_5_1 , upvalues : self, _ENV
    if self.heal > 0 then
      LuaSkillCtrl:CallHeal(self.heal, self, self.caster)
      LuaSkillCtrl:CallEffect(self.caster, (self.config).effect_heal, self)
      self.heal = 0
    end
  end
)
  LuaSkillCtrl:StartTimer(nil, 2, function()
    -- function num : 0_5_2 , upvalues : self
    self:CallSummoner()
  end
, nil, (self.arglist)[3], 2)
end

bs_204802.CallSummoner = function(self)
  -- function num : 0_6 , upvalues : _ENV
  local EmptyGrids = LuaSkillCtrl:FindEmptyGrid(nil)
  local x = EmptyGrids.x
  local y = EmptyGrids.y
  local effectGrid = LuaSkillCtrl:GetTargetWithGrid(x, y)
  LuaSkillCtrl:CallEffect(effectGrid, (self.config).effect_summon, self)
  local num = LuaSkillCtrl:CallRange(25, 28)
  local summoner = LuaSkillCtrl:CreateSummoner(self, num, x, y)
  summoner:SetAttr(eHeroAttr.maxHp, (self.caster).maxHp * (self.config).maxHpPer // 1000)
  summoner:SetAttr(eHeroAttr.pow, (self.caster).pow * (self.config).powPer // 1000)
  summoner:SetAttr(eHeroAttr.intensity, (self.caster).intensity * (self.config).powPer // 1000)
  summoner:SetAttr(eHeroAttr.speed, (self.caster).speed)
  summoner:SetAsRealEntity(1)
  local summonerEntity = LuaSkillCtrl:AddSummonerRole(summoner)
  LuaSkillCtrl:CallBuff(self, summonerEntity, 2048040, 1, nil, true)
  -- DECOMPILER ERROR at PC83: Confused about usage of register: R8 in 'UnsetPending'

  ;
  (summonerEntity.recordTable).IsSummoner = true
  self.SummonerAliveCount = self.SummonerAliveCount + 1
  LuaSkillCtrl:StartTimer(self, (self.arglist)[1], function()
    -- function num : 0_6_0 , upvalues : _ENV, summonerEntity, self
    local IfRoleCotainsIgnoreDieBuff = LuaSkillCtrl:RoleContainsBuffFeature(summonerEntity, (self.config).buffFeature_ignoreDie)
    if IfRoleCotainsIgnoreDieBuff == true then
      local buff_ignoreDie = LuaSkillCtrl:GetRoleAllBuffsByFeature(summonerEntity, (self.config).buffFeature_ignoreDie)
      if buff_ignoreDie.Count > 0 then
        for i = 0, buff_ignoreDie.Count - 1 do
          LuaSkillCtrl:DispelBuff(summonerEntity, (buff_ignoreDie[i]).dataId, 0)
          IfRoleCotainsIgnoreDieBuff = false
        end
      end
    end
    do
      if summonerEntity.hp > 0 and IfRoleCotainsIgnoreDieBuff == false then
        self.heal = summonerEntity.hp * (self.arglist)[2] // 1000 + self.heal
        LuaSkillCtrl:RemoveLife(summonerEntity.hp, self, summonerEntity, true, nil, false, true, eHurtType.RealDmg, true)
        LuaSkillCtrl:CallEffect(summonerEntity, (self.config).effect_killSummoner, self)
        LuaSkillCtrl:CallEffect(summonerEntity, (self.config).effect_zd, self, nil, self.caster, 1, true)
        self.SummonerAliveCount = 0
      end
    end
  end
)
end

bs_204802.RoleDie = function(self, role)
  -- function num : 0_7 , upvalues : _ENV
  local camp = role.camp
  if role.roleType == eBattleRoleType.realSummoner then
    camp = LuaSkillCtrl:GetSummonerCamp(role)
  end
  if camp == 2 and role ~= self.caster and (role.recordTable).IsSummoner == true then
    self.SummonerAliveCount = self.SummonerAliveCount - 1
  end
  local InvincibleBuff = LuaSkillCtrl:GetRoleBuffById(self.caster, (self.config).buff_invincible)
  if self.SummonerAliveCount == 0 and InvincibleBuff ~= nil then
    LuaSkillCtrl:DispelBuffByMaker(self.caster, self.caster, (self.config).buffId_170, 1, true)
    LuaSkillCtrl:DispelBuffByMaker(self.caster, self.caster, (self.config).buff_invincible, 1, true)
    self:CancleCasterWait()
    LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId_end, 1)
    LuaSkillCtrl:StopShowSkillDurationTime(self)
  end
end

bs_204802.OnCasterDie = function(self)
  -- function num : 0_8 , upvalues : base
  (base.OnCasterDie)(self)
end

bs_204802.LuaDispose = function(self)
  -- function num : 0_9 , upvalues : base
  (base.LuaDispose)(self)
end

return bs_204802

