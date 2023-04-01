-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_207902 = class("bs_207902", LuaSkillBase)
local base = LuaSkillBase
bs_207902.config = {effectId_trail = 207800, buffIdBJ = 207901, buffIdHD = 207902, buffIdXY = 207903, buffIdHDBJ = 207904, effectId_start = 207801, effectId_trail2 = 207803, select_id = 9, select_range = 0, HurtConfig = 3, buffId_superArmor = 207905}
bs_207902.ctor = function(self)
  -- function num : 0_0
end

bs_207902.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_207902_3", 1, self.OnAfterHurt, self.caster)
  self:OnAfterBattleStart()
  self:AddTrigger(eSkillTriggerType.OnBreakShield, "bs_207902_2", 1, self.OnBreakShield)
end

bs_207902.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  self.timejnattack = 0
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_superArmor, 1, nil, true)
end

bs_207902.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_3 , upvalues : _ENV
  if sender == self.caster and skill.isNormalSkill and not isTriggerSet and target.hp >= 0 and not isMiss then
    self.timejnattack = self.timejnattack + 1
    local num = (self.arglist)[1]
    if num <= self.timejnattack then
      local value1 = (self.caster).skill_intensity * (self.arglist)[2] // 1000
      LuaSkillCtrl:AddRoleShield(self.caster, eShieldType.normal, value1)
      local SelfShieldValue = LuaSkillCtrl:GetShield(self.caster, 0)
      if SelfShieldValue ~= 0 then
        LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffIdHDBJ, 1)
      end
      self.timejnattack = 0
    end
  end
end

bs_207902.OnBreakShield = function(self, shieldType, sender, target)
  -- function num : 0_4 , upvalues : _ENV
  if target.belongNum == (self.caster).belongNum then
    local buff = LuaSkillCtrl:GetRoleBuffById(target, (self.config).buffIdHDBJ)
    if buff ~= nil then
      local targetlist = LuaSkillCtrl:CallTargetSelectWithRange(self, (self.config).select_id, 1)
      if targetlist.Count > 0 then
        for i = 0, targetlist.Count - 1 do
          if (targetlist[i]).targetRole ~= nil then
            local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, (targetlist[i]).targetRole)
            LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).HurtConfig, {(self.arglist)[3]})
            skillResult:EndResult()
            LuaSkillCtrl:CallBuff(self, (targetlist[i]).targetRole, (self.config).buffIdXY, 1, (self.arglist)[4])
          end
        end
      end
      do
        LuaSkillCtrl:DispelBuff(target, (self.config).buffIdHDBJ, 0)
      end
    end
  end
end

bs_207902.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_207902

