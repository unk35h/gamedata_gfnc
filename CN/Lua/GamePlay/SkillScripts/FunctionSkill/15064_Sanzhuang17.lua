-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_15064 = class("bs_15064", LuaSkillBase)
local base = LuaSkillBase
bs_15064.config = {effectIdLoop = 10956, effectIdHit = 10957, effectIdEnd = 10958, buffId = 1253}
bs_15064.ctor = function(self)
  -- function num : 0_0
end

bs_15064.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddBeforeAddBuffTrigger("bs_15064_2", 1, self.OnBeforeAddBuff, self.caster)
end

bs_15064.OnBeforeAddBuff = function(self, target, context)
  -- function num : 0_2 , upvalues : _ENV
  if target ~= self.caster and ((context.buff).buffCfg).IsControl then
    local arriveCallBack = BindCallback(self, self.OnArriveAction, target)
    local damageTime = (context.buff).durationTime // 15
    LuaSkillCtrl:StartTimer(nil, 15, arriveCallBack, nil, damageTime, 15)
    LuaSkillCtrl:CallBuff(self, target, (self.config).buffId, 1, (context.buff).durationTime, true)
    local arriveCallBack2 = BindCallback(self, self.OnArriveAction2, target)
    LuaSkillCtrl:StartTimer(nil, (context.buff).durationTime, arriveCallBack2)
  end
end

bs_15064.OnArriveAction2 = function(self, role)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:CallEffect(role, (self.config).effectIdEnd, self)
end

bs_15064.OnArriveAction = function(self, role)
  -- function num : 0_4 , upvalues : _ENV
  local damageValue = (self.caster).maxHp * (self.arglist)[1] // 1000
  LuaSkillCtrl:RemoveLife(damageValue, self, role, true, nil, true, false, eHurtType.RealDmg)
  LuaSkillCtrl:CallEffect(role, (self.config).effectIdHit, self)
end

bs_15064.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_15064

