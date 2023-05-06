-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_92085 = class("bs_92085", LuaSkillBase)
local base = LuaSkillBase
bs_92085.config = {buffId_fire = 1227, buffId_blood = 195, buffId_mindMagicDef = 2076, buffId_mindPhyDef = 2077}
bs_92085.ctor = function(self)
  -- function num : 0_0
end

bs_92085.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddBeforeAddBuffTrigger("bs_92085_1", 1, self.OnBeforeAddBuff, nil, nil, nil, eBattleRoleBelong.enemy)
  self:AddBuffDieTrigger("bs_92085_3", 1, self.OnBuffDie, nil, eBattleRoleBelong.enemy, (self.config).buffId)
end

bs_92085.OnBeforeAddBuff = function(self, target, context)
  -- function num : 0_2 , upvalues : _ENV
  if (context.buff).dataId ~= (self.config).buff_fire or (context.buff).dataId ~= (self.config).buff_blood then
    return 
  end
  local buffTier_fire = target:GetBuffTier((self.config).buffId_fire)
  local buffTier_blood = target:GetBuffTier((self.config).buffId_blood)
  -- DECOMPILER ERROR at PC26: Confused about usage of register: R5 in 'UnsetPending'

  if (target.recordTable).buffTier_fire == nil then
    (target.recordTable).buffTier_fire = 0
  end
  -- DECOMPILER ERROR at PC32: Confused about usage of register: R5 in 'UnsetPending'

  if (target.recordTable).buffTier_blood == nil then
    (target.recordTable).buffTier_blood = 0
  end
  if buffTier_fire ~= (target.recordTable).buffTier_fire then
    LuaSkillCtrl:DispelBuff(target, (self.config).buffId_mindMagicDef, 0, true, true)
    LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_mindMagicDef, buffTier_fire, nil, true)
    -- DECOMPILER ERROR at PC57: Confused about usage of register: R5 in 'UnsetPending'

    ;
    (target.recordTable).buffTier_fire = buffTier_fire
  end
  if buffTier_blood ~= (target.recordTable).buffTier_blood then
    LuaSkillCtrl:DispelBuff(target, (self.config).buffId_mindPhyDef, 0, true, true)
    LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_mindPhyDef, buffTier_blood, nil, true)
    -- DECOMPILER ERROR at PC82: Confused about usage of register: R5 in 'UnsetPending'

    ;
    (target.recordTable).buffTier_blood = buffTier_blood
  end
end

bs_92085.OnBuffDie = function(self, buff, target, removeType)
  -- function num : 0_3 , upvalues : _ENV
  if buff.dataId ~= (self.config).buff_fire or buff.dataId ~= (self.config).buff_blood then
    return 
  end
  local buffTier_fire = target:GetBuffTier((self.config).buffId_fire)
  local buffTier_blood = target:GetBuffTier((self.config).buffId_blood)
  -- DECOMPILER ERROR at PC24: Confused about usage of register: R6 in 'UnsetPending'

  if (target.recordTable).buffTier_fire == nil then
    (target.recordTable).buffTier_fire = 0
  end
  -- DECOMPILER ERROR at PC30: Confused about usage of register: R6 in 'UnsetPending'

  if (target.recordTable).buffTier_blood == nil then
    (target.recordTable).buffTier_blood = 0
  end
  if buffTier_fire ~= (target.recordTable).buffTier_fire then
    LuaSkillCtrl:DispelBuff(target, (self.config).buffId_mindMagicDef, 0, true, true)
    LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_mindMagicDef, buffTier_fire, nil, true)
    -- DECOMPILER ERROR at PC55: Confused about usage of register: R6 in 'UnsetPending'

    ;
    (target.recordTable).buffTier_fire = buffTier_fire
  end
  if buffTier_blood ~= (target.recordTable).buffTier_blood then
    LuaSkillCtrl:DispelBuff(target, (self.config).buffId_mindPhyDef, 0, true, true)
    LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_mindPhyDef, buffTier_blood, nil, true)
    -- DECOMPILER ERROR at PC80: Confused about usage of register: R6 in 'UnsetPending'

    ;
    (target.recordTable).buffTier_blood = buffTier_blood
  end
end

bs_92085.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_92085

