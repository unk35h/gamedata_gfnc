-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_25051 = class("bs_25051", LuaSkillBase)
local base = LuaSkillBase
bs_25051.config = {}
bs_25051.ctor = function(self)
  -- function num : 0_0
end

bs_25051.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSetHurtTrigger("bs_25051_2", 1, self.OnSetHurt, nil, nil, nil, eBattleRoleBelong.player)
  self.time = 0
end

bs_25051.OnSetHurt = function(self, context)
  -- function num : 0_2
  if (context.target).belongNum == (self.caster).belongNum and not context.isMiss and self.time < (self.arglist)[2] and (context.target).isRemote then
    local basehurt = (context.target).maxHp * (self.arglist)[1] // 1000
    if basehurt < context.hurt then
      context.hurt = basehurt
      self.time = self.time + 1
    end
  end
end

bs_25051.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_25051

