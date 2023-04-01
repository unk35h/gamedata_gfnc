-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_210901 = class("bs_210901", LuaSkillBase)
local base = LuaSkillBase
bs_210901.config = {
heal_config = {baseheal_formula = 3022}
, skilltime = 37, actionId = 1002, action_speed = 1, actionId_start_time = 20, effectId2 = 210907, monsterId = 63}
bs_210901.ctor = function(self)
  -- function num : 0_0
end

bs_210901.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_210901.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_2 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_210901_1", 1, self.OnAfterBattleStart)
  self:AddOnRoleDieTrigger("bs_210901_2", 1, self.OnRoleDie, nil, nil, nil, (self.caster).belongNum)
  self.maxCount = 3
  self.table = {}
  -- DECOMPILER ERROR at PC24: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).Count = 0
  -- DECOMPILER ERROR at PC27: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).changeCount = 3
  -- DECOMPILER ERROR at PC32: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).AtkDam = (self.arglist)[4]
  -- DECOMPILER ERROR at PC37: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).AtkDamAdd = (self.arglist)[5]
  -- DECOMPILER ERROR at PC40: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).onskill = false
  -- DECOMPILER ERROR at PC43: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).ptolomaea = true
end

bs_210901.OnAfterBattleStart = function(self)
  -- function num : 0_3 , upvalues : _ENV
  self.timer = LuaSkillCtrl:StartTimer(nil, (self.arglist)[6], (BindCallback(self, self.doskill)), nil, -1, 0)
end

bs_210901.doSummon = function(self)
  -- function num : 0_4 , upvalues : _ENV
  if ((self.caster).recordTable).Count < self.maxCount then
    local num = self.maxCount - ((self.caster).recordTable).Count
    for i = 1, num do
      self:Summon()
    end
  else
    do
      for i = 1, self.maxCount do
        if (self.table)[i] ~= nil then
          local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, (self.table)[i])
          LuaSkillCtrl:HealResult(skillResult, (self.config).heal_config, {10000})
          skillResult:EndResult()
        end
      end
    end
  end
end

bs_210901.doskill = function(self)
  -- function num : 0_5 , upvalues : _ENV
  if ((self.caster).recordTable).onskill ~= true and not LuaSkillCtrl:RoleContainsCtrlBuff(self.caster) and #self.table < self.maxCount then
    LuaSkillCtrl:CallBreakAllSkill(self.caster)
    local time = (self.config).skilltime
    self:CallCasterWait(time)
    LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId, (self.config).action_speed)
    LuaSkillCtrl:StartTimer(nil, (self.config).actionId_start_time, (BindCallback(self, self.doSummon)), nil)
  else
    do
      LuaSkillCtrl:StartTimer(nil, (self.config).actionId_start_time, (BindCallback(self, self.doSummon)), nil)
    end
  end
end

bs_210901.Summon = function(self)
  -- function num : 0_6 , upvalues : _ENV
  local Grid = LuaSkillCtrl:CallFindEmptyGridNearest(self.caster)
  if Grid == nil then
    Grid = LuaSkillCtrl:FindRoleRightEmptyGrid(self.caster, 10)
  end
  local summonerEntity = nil
  if Grid ~= nil then
    local target = LuaSkillCtrl:GetTargetWithGrid(Grid.x, Grid.y)
    LuaSkillCtrl:CallEffect(target, (self.config).effectId2, self)
    local summoner = LuaSkillCtrl:CreateSummoner(self, (self.config).monsterId, Grid.x, Grid.y)
    summoner:SetAttr(eHeroAttr.maxHp, (self.caster).maxHp * (self.arglist)[1] // 1000)
    summoner:SetAttr(eHeroAttr.skill_intensity, (self.caster).skill_intensity * (self.arglist)[2] // 1000)
    summoner:SetAttr(eHeroAttr.pow, (self.caster).pow * (self.arglist)[2] // 1000)
    summoner:SetAttr(eHeroAttr.speed, (self.caster).speed)
    summoner:SetAttr(eHeroAttr.moveSpeed, (self.caster).moveSpeed)
    summoner:SetAttr(eHeroAttr.def, (self.caster).def * (self.arglist)[3] // 1000)
    summoner:SetAttr(eHeroAttr.magic_res, (self.caster).magic_res * (self.arglist)[3] // 1000)
    summoner:SetAttr(eHeroAttr.lucky, self.lucky)
    summoner:SetAsRealEntity(1)
    summonerEntity = LuaSkillCtrl:AddSummonerRole(summoner)
    ;
    (table.insert)(self.table, summonerEntity)
    -- DECOMPILER ERROR at PC121: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self.caster).recordTable).Count = ((self.caster).recordTable).Count + 1
  end
end

bs_210901.OnBreakSkill = function(self, role)
  -- function num : 0_7 , upvalues : base
  (base.OnBreakSkill)(self, role)
end

bs_210901.OnRoleDie = function(self, killer, role)
  -- function num : 0_8 , upvalues : _ENV
  for i,v in ipairs(self.table) do
    if role == v then
      (table.remove)(self.table, i)
      -- DECOMPILER ERROR at PC17: Confused about usage of register: R8 in 'UnsetPending'

      ;
      ((self.caster).recordTable).Count = ((self.caster).recordTable).Count - 1
      break
    end
  end
end

bs_210901.OnCasterDie = function(self)
  -- function num : 0_9 , upvalues : base
  (base.OnCasterDie)(self)
  if self.timer ~= nil then
    (self.timer):Stop()
    self.timer = nil
  end
end

bs_210901.LuaDispose = function(self)
  -- function num : 0_10 , upvalues : base
  self.table = nil
  ;
  (base.LuaDispose)(self)
end

return bs_210901

