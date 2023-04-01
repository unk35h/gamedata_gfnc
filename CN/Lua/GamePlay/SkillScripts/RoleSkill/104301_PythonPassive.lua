-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_104301 = class("bs_104301", LuaSkillBase)
local base = LuaSkillBase
bs_104301.config = {buff_ReduceDef = 104301, buff_IncreaseDef = 104302, buff_ReduceMagicRes = 104303, buff_IncreaseMagicRes = 104304, effectId_Suck = 104307}
bs_104301.ctor = function(self)
  -- function num : 0_0
end

bs_104301.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSetHurtTrigger("bs_104301_1", 1, self.OnSetHurt, self.caster, nil, nil, nil, nil, nil, nil, eSkillTag.commonAttack)
  self:AddSelfTrigger(eSkillTriggerType.AfterPlaySkill, "bs_104301_2", 1, self.OnAfterPlaySkill)
  self:AddBuffDieTrigger("bs_104301_2", 1, self.OnBuffDie)
  self.AttackCount = 0
end

bs_104301.OnSetHurt = function(self, context)
  -- function num : 0_2 , upvalues : _ENV
  local buffs = LuaSkillCtrl:GetRoleBuffById(context.target, (self.config).buff_ReduceDef)
  if buffs ~= nil then
    LuaSkillCtrl:DispelBuff(context.target, (self.config).buff_ReduceDef, 0)
    LuaSkillCtrl:DispelBuff(context.target, (self.config).buff_ReduceMagicRes, 0)
  end
  if context.sender == self.caster and (context.skill).isCommonAttack and (context.target).belongNum ~= (self.caster).belongNum and (context.target).intensity > 0 then
    local DefNum = (context.target).def * (self.arglist)[1] // 1000
    local MagicNum = (context.target).magic_res * (self.arglist)[1] // 1000
    LuaSkillCtrl:CallEffect(context.target, (self.config).effectId_Suck, self)
    LuaSkillCtrl:CallBuff(self, context.target, (self.config).buff_ReduceDef, DefNum, (self.arglist)[2], true)
    LuaSkillCtrl:CallBuff(self, context.target, (self.config).buff_ReduceMagicRes, MagicNum, (self.arglist)[2], true)
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buff_IncreaseDef, DefNum, nil, true)
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buff_IncreaseMagicRes, MagicNum, nil, true)
  end
end

bs_104301.OnBuffDie = function(self, buff, target, removeType)
  -- function num : 0_3 , upvalues : _ENV
  if buff.dataId == (self.config).buff_ReduceDef then
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buff_IncreaseDef, buff.tier)
  end
  if buff.dataId == (self.config).buff_ReduceMagicRes then
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buff_IncreaseMagicRes, buff.tier)
  end
end

bs_104301.OnAfterPlaySkill = function(self, skill, role)
  -- function num : 0_4
  if role == self.caster and skill.isCommonAttack then
    self.AttackCount = self.AttackCount + 1
    -- DECOMPILER ERROR at PC16: Confused about usage of register: R3 in 'UnsetPending'

    if self.AttackCount == (self.arglist)[3] then
      ((self.caster).recordTable).Aoe = true
      self.AttackCount = -1
    end
  end
end

bs_104301.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
end

bs_104301.LuaDispose = function(self)
  -- function num : 0_6 , upvalues : base
  (base.LuaDispose)(self)
end

return bs_104301

