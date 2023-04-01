-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_20255 = class("bs_20255", LuaSkillBase)
local base = LuaSkillBase
bs_20255.config = {buffId = 2013, buffId2 = 105}
bs_20255.ctor = function(self)
  -- function num : 0_0
end

bs_20255.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_20255_2", 1, self.OnAfterHurt, self.caster, nil, eBattleRoleBelong.enemy, eBattleRoleBelong.player, nil, nil, nil, eSkillTag.commonAttack)
  self:AddBuffDieTrigger("bs_20255_3", 1, self.OnBuffDie, nil, eBattleRoleBelong.enemy, (self.config).buffId)
end

bs_20255.OnBuffDie = function(self, buff, target, removeType)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallStartLocalScale(target, (Vector3.New)(1, 1, 1))
end

bs_20255.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_3 , upvalues : _ENV
  if sender == self.caster and skill.isCommonAttack and not isTriggerSet and not isMiss then
    local buffTier = sender:GetBuffTier((self.config).buffId)
    if (self.arglist)[2] <= buffTier then
      LuaSkillCtrl:CallBuff(self, sender, (self.config).buffId, 1, (self.arglist)[3])
      return 
    end
    LuaSkillCtrl:CallBuff(self, sender, (self.config).buffId, 1, (self.arglist)[3])
    local scale = buffTier * 0.1 + 1
    LuaSkillCtrl:CallStartLocalScale(self.caster, (Vector3.New)(scale, scale, scale))
  end
end

bs_20255.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_20255

