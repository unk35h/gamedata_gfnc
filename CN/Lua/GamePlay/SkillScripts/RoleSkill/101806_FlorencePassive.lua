-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_101804 = require("GamePlay.SkillScripts.RoleSkill.101804_FlorencePassive")
local bs_101806 = class("bs_101806", bs_101804)
local base = bs_101804
bs_101806.config = {weaponLv = 3}
bs_101806.config = setmetatable(bs_101806.config, {__index = base.config})
bs_101806.ctor = function(self)
  -- function num : 0_0
end

bs_101806.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : _ENV
  (LuaSkillBase.InitSkill)(self, isMidwaySkill)
  if LuaSkillCtrl.IsInTDBattle and LuaSkillCtrl.cluaSkillCtrl ~= nil then
    return 
  end
  self:AddAfterHurtTrigger("bs_101806_3", 1, self.OnAfterHurt)
  self:AddBuffDieTrigger("bs_101806_2", 1, self.OnBuffDie, nil, nil, (self.config).buffId_love)
  self.time = 0
end

bs_101806.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : base, _ENV
  (base.OnAfterHurt)(self, sender, target, skill, hurt, isMiss)
  if target ~= nil and target.hp > 0 and target.belongNum == (self.caster).belongNum and target:GetBuffTier((self.config).buffId_passive) <= 0 then
    local limit = target.maxHp * (self.arglist)[8] // 1000
    if target.hp < limit then
      LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_passive, 1, 99999999)
      LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_wd, 1, (self.arglist)[9])
    end
  end
end

bs_101806.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_101806

