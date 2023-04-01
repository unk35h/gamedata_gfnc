-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_6019 = class("bs_6019", LuaSkillBase)
local base = LuaSkillBase
bs_6019.config = {buffid = 601901}
bs_6019.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_0 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_6019_3", -1, self.OnAfterHurt, self.caster)
  self:AddAfterAddBuffTrigger("bs_601901_13", 1, self.OnAfterAddBuff, self.caster)
  self:AddSelfTrigger(eSkillTriggerType.HurtResultStart, "bs_6019_15", 1, self.OnHurtResultStart)
  self.buffs3 = {}
end

bs_6019.OnAfterAddBuff = function(self, buff, target)
  -- function num : 0_1 , upvalues : _ENV
  if buff.dataId == (self.config).buffid then
    return 
  end
  -- DECOMPILER ERROR at PC29: Confused about usage of register: R3 in 'UnsetPending'

  if target.belongNum ~= (self.caster).belongNum and buff.buffType == 2 and (table.count)(self.buffs3) < (self.arglist)[2] and (self.buffs3)[buff.dataId] == nil then
    (self.buffs3)[buff.dataId] = buff
    local buffMger = (self.caster):GetBuffComponent()
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffid, 1, nil)
  end
end

bs_6019.OnHurtResultStart = function(self, skill, context)
  -- function num : 0_2 , upvalues : _ENV
  if skill.isCommonAttack and (context.sender):GetBuffTier((self.config).buffid) >= 1 then
    context.new_config = {}
    -- DECOMPILER ERROR at PC15: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (context.new_config).extra_arg = (self.config).buffid
    setmetatable(context.new_config, {__index = context.config})
  end
end

bs_6019.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet, extraArg)
  -- function num : 0_3 , upvalues : _ENV
  if extraArg == nil or extraArg ~= (self.config).buffid then
    return 
  end
  if sender == self.caster and skill.isCommonAttack then
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffid, 0, true)
    self.buffs3 = {}
  end
end

bs_6019.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_6019

