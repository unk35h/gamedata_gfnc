-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_207802 = class("bs_207802", LuaSkillBase)
local base = LuaSkillBase
bs_207802.config = {effectId_trail = 207800, buffIdBJ = 207801, buffIdHD = 207802, effectId_start = 207801, effectId_trail2 = 207803, effectId_bd = 207805, start_time = 9}
bs_207802.ctor = function(self)
  -- function num : 0_0
end

bs_207802.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSelfTrigger(eSkillTriggerType.AfterPlaySkill, "bs_207802_1", 1, self.OnAfterPlaySkill)
  self:AddTrigger(eSkillTriggerType.OnBreakShield, "bs_207802_2", 1, self.OnBreakShield)
  -- DECOMPILER ERROR at PC22: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).skill_intensity_up = (self.arglist)[1]
  -- DECOMPILER ERROR at PC27: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).maxHp = (self.arglist)[2]
end

bs_207802.OnAfterPlaySkill = function(self, skill, role)
  -- function num : 0_2 , upvalues : _ENV
  if skill.isCommonAttack and skill.maker == self.caster then
    local targetList = LuaSkillCtrl:CallTargetSelect(self, 14, 6)
    if targetList.Count ~= 0 then
      local target = (targetList[0]).targetRole
      do
        (self.caster):LookAtTarget(target)
        LuaSkillCtrl:StartTimer(nil, (self.config).start_time, function()
    -- function num : 0_2_0 , upvalues : target, self, _ENV
    if target ~= self.caster then
      LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_bd, self)
      LuaSkillCtrl:CallEffect(target, (self.config).effectId_trail, self)
    end
    local value1 = (self.caster).skill_intensity * (self.arglist)[1] // 1000
    local value2 = (self.caster).maxHp * (self.arglist)[2] // 1000
    local value3 = value1 + value2
    LuaSkillCtrl:StartTimer(nil, 3, function()
      -- function num : 0_2_0_0 , upvalues : value3, _ENV, target, self
      if value3 > 0 then
        LuaSkillCtrl:AddRoleShield(target, eShieldType.normal, value3)
        local buff = LuaSkillCtrl:GetRoleBuffById(target, (self.config).buffIdHD)
        if buff == nil then
          LuaSkillCtrl:CallBuff(self, target, (self.config).buffIdHD, 1, nil, true)
        end
      end
    end
)
  end
)
      end
    end
  end
end

bs_207802.OnBreakShield = function(self, shieldType, sender, target)
  -- function num : 0_3 , upvalues : _ENV
  if target.belongNum == (self.caster).belongNum then
    local buff = LuaSkillCtrl:GetRoleBuffById(target, (self.config).buffIdHD)
    if buff ~= nil then
      LuaSkillCtrl:DispelBuff(target, (self.config).buffIdHD, 1)
    end
  end
end

bs_207802.OnCasterDie = function(self)
  -- function num : 0_4
  self:KillEquipmentSummoner()
  self:RemoveAllTimers()
  self:RemoveAllBreakKillEffects()
  self:RemoveAllLuaTrigger()
  self:RemoveAllHaleEmission()
end

return bs_207802

