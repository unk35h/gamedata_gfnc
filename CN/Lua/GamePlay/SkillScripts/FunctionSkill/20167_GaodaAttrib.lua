-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_20167 = class("bs_20167", LuaSkillBase)
local base = LuaSkillBase
bs_20167.config = {}
bs_20167.ctor = function(self)
  -- function num : 0_0
end

bs_20167.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_20167_1", 1, self.OnAfterBattleStart)
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).totalHp = 0
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).totalAtk = 0
  -- DECOMPILER ERROR at PC19: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).totalIntensity = 0
  -- DECOMPILER ERROR at PC22: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).totalDef = 0
  -- DECOMPILER ERROR at PC25: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).totalMagicRes = 0
  -- DECOMPILER ERROR at PC28: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).roleNum = 0
end

bs_20167.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local targetlist = LuaSkillCtrl:CallTargetSelect(self, 6, 10)
  if targetlist.Count < 1 then
    return 
  end
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).roleNum = targetlist.Count
  for i = 0, targetlist.Count - 1 do
    local targetRole = (targetlist[i]).targetRole
    -- DECOMPILER ERROR at PC28: Confused about usage of register: R7 in 'UnsetPending'

    ;
    ((self.caster).recordTable).totalHp = ((self.caster).recordTable).totalHp + targetRole.maxHp
    -- DECOMPILER ERROR at PC36: Confused about usage of register: R7 in 'UnsetPending'

    ;
    ((self.caster).recordTable).totalAtk = ((self.caster).recordTable).totalAtk + targetRole.pow
    -- DECOMPILER ERROR at PC44: Confused about usage of register: R7 in 'UnsetPending'

    ;
    ((self.caster).recordTable).totalIntensity = ((self.caster).recordTable).totalIntensity + targetRole.skill_intensity
    -- DECOMPILER ERROR at PC52: Confused about usage of register: R7 in 'UnsetPending'

    ;
    ((self.caster).recordTable).totalDef = ((self.caster).recordTable).totalDef + targetRole.def
    -- DECOMPILER ERROR at PC60: Confused about usage of register: R7 in 'UnsetPending'

    ;
    ((self.caster).recordTable).totalMagicRes = ((self.caster).recordTable).totalMagicRes + targetRole.magic_res
  end
end

bs_20167.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_20167

