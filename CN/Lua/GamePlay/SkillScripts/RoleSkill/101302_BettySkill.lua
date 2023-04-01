-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_101302 = class("bs_101302", LuaSkillBase)
local base = LuaSkillBase
bs_101302.config = {buffId_Wild = 101301, buffId_Wild_year = 101302, buffId_170 = 170}
bs_101302.ctor = function(self)
  -- function num : 0_0
end

bs_101302.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_101302.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  if LuaSkillCtrl:GetCasterSkinId(self.caster) == 301303 then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_Wild_year, 1, (self.arglist)[1], true)
  else
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_Wild, 1, (self.arglist)[1], true)
  end
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_170, 1, (self.arglist)[1], true)
  LuaSkillCtrl:StartShowSkillDurationTime(self, (self.arglist)[1])
  -- DECOMPILER ERROR at PC48: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).curStartShowDurationSkill = self
end

bs_101302.OnBreakSkill = function(self, role)
  -- function num : 0_3 , upvalues : _ENV
  if role ~= self.caster then
    return 
  end
  if self.timers ~= nil then
    local leng = (table.length)(self.timers)
    if leng > 0 then
      for i = 1, leng do
        if (self.timers)[i] ~= nil then
          ((self.timers)[i]):Stop()
          -- DECOMPILER ERROR at PC26: Confused about usage of register: R7 in 'UnsetPending'

          ;
          (self.timers)[i] = nil
        end
      end
    end
    do
      do
        self.timers = {}
        self:RemoveAllBreakKillEffects()
        if self.isSkillUncompleted then
          (self.caster):RemoveSkillWaitBuff()
          ;
          (self.cskill):ReturnCDTimeFromBreak()
          self.isSkillUncompleted = false
        end
        self:OnSkillDamageEnd()
      end
    end
  end
end

bs_101302.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_101302

