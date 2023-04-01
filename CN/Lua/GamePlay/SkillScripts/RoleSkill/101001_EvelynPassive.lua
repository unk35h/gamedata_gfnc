-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_101001 = class("bs_101001", LuaSkillBase)
local base = LuaSkillBase
bs_101001.config = {buffId_Reduce = 101001, buffId_Back = 3007, buffId_Stun = 3006, buffId_3022 = 3022, buffId_weapon1 = 101004, audioId1 = 101004, 
heal_config = {baseheal_formula = 3021}
, selectId = 9, selectrange = 10, weaponLv = 0, 
Aoe = {effect_shape = 3, aoe_select_code = 4, aoe_range = 10}
}
bs_101001.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_0 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_101001_btlStart", 1, self.OnAfterBattleStart)
  self:AddSetHurtTrigger("bs_101001_setHurt", 1, self.OnSetHurt, nil, self.caster)
  self:AddAfterHurtTrigger("bs_101001_afterhurt", 1, self.OnAfterHurt, nil, self.caster)
  self:AddAfterAddBuffTrigger("bs_101001_8", 1, self.OnAfterAddBuff, self.caster)
  self.weapon1 = false
  self.weapon3 = false
end

bs_101001.OnAfterBattleStart = function(self)
  -- function num : 0_1 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_Reduce, 1, nil, true)
  if (self.config).weaponLv >= 3 then
    self.weapon3 = true
  end
end

bs_101001.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if target == self.caster and (self.config).weaponLv >= 1 then
    local hp = target.hp * 1000 // target.maxHp
    if hp <= (self.arglist)[9] then
      LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_weapon1, 1, nil, true)
      self.weapon1 = true
    else
      if self.weapon1 == true and (self.arglist)[9] < hp then
        LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_weapon1, 0, true)
      end
    end
  end
end

bs_101001.OnSetHurt = function(self, context)
  -- function num : 0_3 , upvalues : _ENV
  if context.target == self.caster and (context.sender).hp > 0 and self:IsReadyToTake() and context.sender ~= self.caster and LuaSkillCtrl:GetGridsDistance((context.sender).x, (context.sender).y, (self.caster).x, (self.caster).y) <= 1 and LuaSkillCtrl:CallRange(1, 1000) <= (self.arglist)[2] and (context.sender):IsUnSelect(self.caster) ~= true and LuaSkillCtrl:RoleContainsBuffFeature(context.sender, eBuffFeatureType.Exiled) ~= true then
    LuaSkillCtrl:PlayAuSource(self.caster, (self.config).audioId1)
    local targetX = (context.sender).x
    local targetY = (context.sender).y
    local buff = nil
    if (context.sender).belongNum ~= eBattleRoleBelong.neutral then
      buff = LuaSkillCtrl:CallBuff(self, context.sender, (self.config).buffId_Back, 1, 3)
    end
    if buff ~= nil and (context.sender).x == targetX and (context.sender).y == targetY then
      LuaSkillCtrl:CallBuff(self, context.sender, (self.config).buffId_Stun, 1, (self.arglist)[4])
      if self.weapon3 == true then
        LuaSkillCtrl:CallBuff(self, context.sender, (self.config).buffId_3022, 1, (self.arglist)[7])
      end
    else
      LuaSkillCtrl:StartTimer(nil, 3, function()
    -- function num : 0_3_0 , upvalues : _ENV, self, context
    LuaSkillCtrl:CallBuff(self, context.sender, (self.config).buffId_Stun, 1, (self.arglist)[3])
  end
)
    end
    self:OnSkillTake()
  end
end

bs_101001.OnAfterAddBuff = function(self, buff, target)
  -- function num : 0_4 , upvalues : _ENV
  if LuaSkillCtrl:RoleContainsBuffFeature(target, eBuffFeatureType.Stun) and target.belongNum ~= (self.caster).belongNum then
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, self.caster)
    LuaSkillCtrl:HealResult(skillResult, (self.config).heal_config, {(self.arglist)[5]}, true)
    skillResult:EndResult()
  end
end

bs_101001.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_101001

