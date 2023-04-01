-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_105601 = class("bs_105601", LuaSkillBase)
local base = LuaSkillBase
bs_105601.config = {buffId_tr = 105602, buffId_gs = 3021, selectId_pass = 5}
bs_105601.ctor = function(self)
  -- function num : 0_0
end

bs_105601.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterAddBuffTrigger("bs_105601_13", 1, self.OnAfterAddBuff, nil, nil, nil, nil, (self.config).buffId_tr)
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable)["105601_Roll"] = (self.arglist)[1]
  -- DECOMPILER ERROR at PC21: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable)["105601_arg2"] = (self.arglist)[2]
end

bs_105601.OnAfterAddBuff = function(self, buff, target)
  -- function num : 0_2 , upvalues : _ENV
  if buff.dataId == (self.config).buffId_tr and target ~= nil and target.hp > 0 and target.belongNum == eBattleRoleBelong.enemy then
    LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_gs, 1, (self.arglist)[4])
    LuaSkillCtrl:DispelBuff(target, (self.config).buffId_tr, 0, true)
  end
end

bs_105601.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_105601

