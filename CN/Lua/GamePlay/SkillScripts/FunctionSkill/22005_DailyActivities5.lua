-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_22005 = class("bs_22005", LuaSkillBase)
local base = LuaSkillBase
bs_22005.config = {effectId = 10254}
bs_22005.ctor = function(self)
  -- function num : 0_0
end

bs_22005.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_22005_1", 1, self.OnAfterBattleStart)
  self:AddSelfTrigger(eSkillTriggerType.AfterPlaySkill, "bs_22005_2", 1, self.OnAfterPlaySkill)
  self.Num = 0
end

bs_22005.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local table = {1002, 1004, 1010, 1013, 1021, 1024, 1026, 1027, 1029, 1041, 1044, 1047}
  local selfRole = (self.caster).roleDataId
  local listNum = #table
  if listNum ~= 0 then
    for i = 1, listNum do
      local roleIdNow = table[i]
      if roleIdNow == selfRole then
        LuaSkillCtrl:CallStartLocalScale(self.caster, (Vector3.New)(1.3, 1.3, 1.3), 0.2)
        self.Num = 1
        break
      end
    end
  end
end

bs_22005.OnAfterPlaySkill = function(self, skill, role)
  -- function num : 0_3 , upvalues : _ENV
  if skill.maker == self.caster and not skill.isCommonAttack and self.Num == 1 then
    local targetlist = LuaSkillCtrl:CallTargetSelect(self, 60, 10)
    if targetlist.Count ~= 0 then
      for i = 0, targetlist.Count - 1 do
        local value = ((targetlist[i]).targetRole).hp * (self.arglist)[1] // 1000
        if (self.caster).skill_intensity * (self.arglist)[2] // 1000 <= value then
          value = (self.caster).skill_intensity * (self.arglist)[2] // 1000
        end
        LuaSkillCtrl:RemoveLife(value, self, (targetlist[i]).targetRole, true, nil, true, true, eHurtType.RealDmg)
        LuaSkillCtrl:CallEffect((targetlist[i]).targetRole, (self.config).effectId, self)
      end
    end
  end
end

bs_22005.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_22005

