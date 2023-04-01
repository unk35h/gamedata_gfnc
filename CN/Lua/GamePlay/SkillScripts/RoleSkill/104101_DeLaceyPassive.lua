-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_104101 = class("bs_104101", LuaSkillBase)
local base = LuaSkillBase
bs_104101.config = {
heal_config = {baseheal_formula = 3021}
, buffId_pow = 104101, buffId_skill = 104102, buffId_pow_weapon = 104103, buffId_skill_weapon = 104104, effectId_start = 104104, effectId_line = 104105, effectId_healLine = 104106, effectId_healLine_Love = 104122, effectId_line_go = 104118, effectId_line_come = 104117, effectId_quan = 104116, effectId_line_weapon = 104125, effectId_line_go_weapon = 104126, weaponLv = 0}
bs_104101.ctor = function(self)
  -- function num : 0_0
end

bs_104101.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_104101_1", 1, self.OnAfterBattleStart)
  self:AddTrigger(eSkillTriggerType.RoleDie, "bs_104101_2", 10, self.OnRoleDie)
end

bs_104101.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R1 in 'UnsetPending'

  ((self.caster).recordTable).pass_target = nil
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.caster).recordTable).weapon_target = nil
  local targetList = LuaSkillCtrl:CallTargetSelect(self, 6, 20)
  local attack_int = 0
  local up_type = 0
  local up_type_weapon = 0
  local num_dis = 100
  local casterx = (self.caster).x
  if targetList ~= nil and targetList.Count > 0 then
    for i = 0, targetList.Count - 1 do
      local role = (targetList[i]).targetRole
      local rolex = role.x
      -- DECOMPILER ERROR at PC61: Confused about usage of register: R13 in 'UnsetPending'

      if role.y == (self.caster).y and role.belongNum == (self.caster).belongNum and role ~= self.caster and (attack_int <= role.pow or attack_int <= role.skill_intensity) and role.roleDataId ~= 103 then
        if attack_int < role.pow or attack_int < role.skill_intensity then
          ((self.caster).recordTable).pass_target = role
          num_dis = LuaSkillCtrl:GetRoleGridsDistance(role, self.caster)
          if role.skill_intensity <= role.pow then
            attack_int = role.pow
            up_type = 1
          else
            attack_int = role.skill_intensity
            up_type = 2
          end
        else
          if role.pow == attack_int or role.skill_intensity == attack_int then
            local num_dis_ex = LuaSkillCtrl:GetRoleGridsDistance(role, self.caster)
            if num_dis_ex < num_dis then
              num_dis = num_dis_ex
              -- DECOMPILER ERROR at PC94: Confused about usage of register: R14 in 'UnsetPending'

              ;
              ((self.caster).recordTable).pass_target = role
              if role.skill_intensity <= role.pow then
                attack_int = role.pow
                up_type = 1
              else
                attack_int = role.skill_intensity
                up_type = 2
              end
            else
              -- DECOMPILER ERROR at PC111: Confused about usage of register: R14 in 'UnsetPending'

              if num_dis_ex == num_dis and casterx < rolex then
                ((self.caster).recordTable).pass_target = role
                num_dis = num_dis_ex
                if role.skill_intensity <= role.pow then
                  attack_int = role.pow
                  up_type = 1
                else
                  attack_int = role.skill_intensity
                  up_type = 2
                end
              end
            end
          end
        end
      end
    end
    if (self.config).weaponLv >= 1 and targetList.Count > 1 then
      local attack_int_weapon = 0
      local num_dis_weapon = 100
      for i = 0, targetList.Count - 1 do
        local role = (targetList[i]).targetRole
        local rolex = role.x
        -- DECOMPILER ERROR at PC170: Confused about usage of register: R15 in 'UnsetPending'

        if role.belongNum == (self.caster).belongNum and role ~= self.caster and role ~= ((self.caster).recordTable).pass_target and (attack_int_weapon <= role.pow or attack_int_weapon <= role.skill_intensity) and role.roleDataId ~= 103 then
          if attack_int_weapon < role.pow or attack_int_weapon < role.skill_intensity then
            ((self.caster).recordTable).weapon_target = role
            num_dis_weapon = LuaSkillCtrl:GetRoleGridsDistance(role, self.caster)
            if role.skill_intensity <= role.pow then
              attack_int_weapon = role.pow
              up_type_weapon = 1
            else
              attack_int_weapon = role.skill_intensity
              up_type_weapon = 2
            end
          else
            if role.pow == attack_int_weapon or role.skill_intensity == attack_int_weapon then
              local num_dis_ex_weapon = LuaSkillCtrl:GetRoleGridsDistance(role, self.caster)
              if num_dis_ex_weapon < num_dis_weapon then
                num_dis_weapon = num_dis_ex_weapon
                -- DECOMPILER ERROR at PC203: Confused about usage of register: R16 in 'UnsetPending'

                ;
                ((self.caster).recordTable).weapon_target = role
                if role.skill_intensity <= role.pow then
                  attack_int_weapon = role.pow
                  up_type_weapon = 1
                else
                  attack_int_weapon = role.skill_intensity
                  up_type_weapon = 2
                end
              else
                -- DECOMPILER ERROR at PC220: Confused about usage of register: R16 in 'UnsetPending'

                if num_dis_ex_weapon == num_dis_weapon and casterx < rolex then
                  ((self.caster).recordTable).weapon_target = role
                  num_dis_weapon = num_dis_ex_weapon
                  if role.skill_intensity <= role.pow then
                    attack_int_weapon = role.pow
                    up_type_weapon = 1
                  else
                    attack_int_weapon = role.skill_intensity
                    up_type_weapon = 2
                  end
                end
              end
            end
          end
        end
      end
    end
  end
  do
    do
      if ((self.caster).recordTable).pass_target ~= nil then
        local onPassiveHeal = BindCallback(self, self.OnPassiveHeal, ((self.caster).recordTable).pass_target)
        self.passive_time = LuaSkillCtrl:StartTimer(nil, (self.arglist)[1], onPassiveHeal, self, -1, 6)
        if up_type == 1 then
          LuaSkillCtrl:CallBuff(self, ((self.caster).recordTable).pass_target, (self.config).buffId_pow, 1, nil, true)
        else
          LuaSkillCtrl:CallBuff(self, ((self.caster).recordTable).pass_target, (self.config).buffId_skill, 1, nil, true)
        end
        LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_start, self)
        LuaSkillCtrl:CallEffect(((self.caster).recordTable).pass_target, (self.config).effectId_start, self)
        self.loop_effect = LuaSkillCtrl:CallEffect(((self.caster).recordTable).pass_target, (self.config).effectId_line, self)
        self.loop_effect2 = LuaSkillCtrl:CallEffect(((self.caster).recordTable).pass_target, (self.config).effectId_line_go, self)
        self.loop_effect3 = LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_line_go, self, nil, ((self.caster).recordTable).pass_target)
        self.loop_target_quan = LuaSkillCtrl:CallEffect(((self.caster).recordTable).pass_target, (self.config).effectId_quan, self)
        self.loop_caster_quan = LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_quan, self)
      end
      if ((self.caster).recordTable).weapon_target ~= nil then
        if up_type_weapon == 1 then
          LuaSkillCtrl:CallBuff(self, ((self.caster).recordTable).weapon_target, (self.config).buffId_pow_weapon, 1, nil, true)
        else
          LuaSkillCtrl:CallBuff(self, ((self.caster).recordTable).weapon_target, (self.config).buffId_skill_weapon, 1, nil, true)
        end
        self.loop_effect_weapon = LuaSkillCtrl:CallEffect(((self.caster).recordTable).weapon_target, (self.config).effectId_line_weapon, self)
        self.loop_effect2_weapon = LuaSkillCtrl:CallEffect(((self.caster).recordTable).weapon_target, (self.config).effectId_line_go_weapon, self)
        self.loop_effect3_weapon = LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_line_go_weapon, self, nil, ((self.caster).recordTable).weapon_target)
        self.loop_target_quan_weapon = LuaSkillCtrl:CallEffect(((self.caster).recordTable).weapon_target, (self.config).effectId_quan, self)
        if self.loop_caster_quan == nil then
          self.loop_caster_quan = LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_quan, self)
        end
      end
    end
  end
end

bs_104101.OnPassiveHeal = function(self, target)
  -- function num : 0_3 , upvalues : _ENV
  if self.passive_time ~= nil and (self.passive_time):IsOver() then
    self.passive_time = nil
  end
  LuaSkillCtrl:StartTimer(nil, 6, function()
    -- function num : 0_3_0 , upvalues : _ENV, target, self
    if LuaSkillCtrl.IsInTDBattle and target.x == (ConfigData.buildinConfig).BenchX then
      self:OnRoleDie(nil, target)
      return 
    end
    if (self.config).weaponLv >= 2 then
      local role1 = self.caster
      local role2 = ((self.caster).recordTable).pass_target
      local role3 = ((self.caster).recordTable).weapon_target
      local healRole = role1
      local rolehp = role1.hp * 1000 // role1.maxHp
      if role2 ~= nil and role2.hp * 1000 // role2.maxHp <= rolehp then
        healRole = role2
        rolehp = role2.hp * 1000 // role2.maxHp
      end
      if role3 ~= nil and role3.hp * 1000 // role3.maxHp < rolehp then
        healRole = role3
        rolehp = role3.hp * 1000 // role3.maxHp
      end
      if healRole ~= nil and healRole.hp > 0 then
        local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, healRole)
        local healValue = (self.arglist)[2] * (1000 + ((self.caster).recordTable)["skill_arglist[1]"] + (self.arglist)[5]) // 1000
        LuaSkillCtrl:HealResult(skillResult, (self.config).heal_config, {healValue})
        skillResult:EndResult()
        if LuaSkillCtrl:GetCasterSkinId(self.caster) == 304103 or LuaSkillCtrl:GetCasterSkinId(self.caster) == 304105 then
          LuaSkillCtrl:CallEffect(healRole, (self.config).effectId_healLine_Love, self)
        else
          LuaSkillCtrl:CallEffect(healRole, (self.config).effectId_healLine, self)
        end
      end
    else
      do
        if target ~= nil and target.hp > 0 then
          local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
          local healValue = (self.arglist)[2] * (1000 + ((self.caster).recordTable)["skill_arglist[1]"]) // 1000
          LuaSkillCtrl:HealResult(skillResult, (self.config).heal_config, {healValue})
          skillResult:EndResult()
          if LuaSkillCtrl:GetCasterSkinId(self.caster) == 304103 or LuaSkillCtrl:GetCasterSkinId(self.caster) == 304105 then
            LuaSkillCtrl:CallEffect(target, (self.config).effectId_healLine_Love, self)
          else
            LuaSkillCtrl:CallEffect(target, (self.config).effectId_healLine, self)
          end
        end
      end
    end
  end
)
end

bs_104101.OnRoleDie = function(self, killer, role)
  -- function num : 0_4
  if role == ((self.caster).recordTable).pass_target then
    if (self.config).weaponLv < 2 and self.passive_time ~= nil then
      (self.passive_time):Stop()
      self.passive_time = nil
    end
    if self.loop_effect ~= nil then
      (self.loop_effect):Die()
      self.loop_effect = nil
    end
    if self.loop_effect2 ~= nil then
      (self.loop_effect2):Die()
      self.loop_effect2 = nil
    end
    if self.loop_effect3 ~= nil then
      (self.loop_effect3):Die()
      self.loop_effect3 = nil
    end
    if self.loop_caster_quan ~= nil then
      (self.loop_caster_quan):Die()
      self.loop_caster_quan = nil
    end
    if self.loop_target_quan ~= nil then
      (self.loop_target_quan):Die()
      self.loop_target_quan = nil
    end
    -- DECOMPILER ERROR at PC53: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.caster).recordTable).pass_target = nil
  end
  if role == ((self.caster).recordTable).weapon_target then
    if self.loop_effect_weapon ~= nil then
      (self.loop_effect_weapon):Die()
      self.loop_effect_weapon = nil
    end
    if self.loop_effect2_weapon ~= nil then
      (self.loop_effect2_weapon):Die()
      self.loop_effect2_weapon = nil
    end
    if self.loop_effect3_weapon ~= nil then
      (self.loop_effect3_weapon):Die()
      self.loop_effect3_weapon = nil
    end
    if self.loop_caster_quan ~= nil then
      (self.loop_caster_quan):Die()
      self.loop_caster_quan = nil
    end
    if self.loop_target_quan_weapon ~= nil then
      (self.loop_target_quan_weapon):Die()
      self.loop_target_quan_weapon = nil
    end
    -- DECOMPILER ERROR at PC96: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.caster).recordTable).weapon_target = nil
  end
end

bs_104101.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base, _ENV
  (base.OnCasterDie)(self)
  local role = ((self.caster).recordTable).pass_target
  if role ~= nil and role.hp > 0 then
    LuaSkillCtrl:DispelBuff(role, (self.config).buffId_pow, 0, true)
    LuaSkillCtrl:DispelBuff(role, (self.config).buffId_skill, 0, true)
  end
  local role_ex = ((self.caster).recordTable).weapon_target
  if role_ex ~= nil and role_ex.hp > 0 then
    LuaSkillCtrl:DispelBuff(role_ex, (self.config).buffId_pow_weapon, 0, true)
    LuaSkillCtrl:DispelBuff(role_ex, (self.config).buffId_skill_weapon, 0, true)
  end
  if self.passive_time ~= nil then
    (self.passive_time):Stop()
    self.passive_time = nil
  end
  if self.loop_effect ~= nil then
    (self.loop_effect):Die()
    self.loop_effect = nil
  end
  if self.loop_effect2 ~= nil then
    (self.loop_effect2):Die()
    self.loop_effect2 = nil
  end
  if self.loop_effect3 ~= nil then
    (self.loop_effect3):Die()
    self.loop_effect3 = nil
  end
  if self.loop_caster_quan ~= nil then
    (self.loop_caster_quan):Die()
    self.loop_caster_quan = nil
  end
  if self.loop_target_quan ~= nil then
    (self.loop_target_quan):Die()
    self.loop_target_quan = nil
  end
  if self.loop_effect_weapon ~= nil then
    (self.loop_effect_weapon):Die()
    self.loop_effect_weapon = nil
  end
  if self.loop_effect2_weapon ~= nil then
    (self.loop_effect2_weapon):Die()
    self.loop_effect2_weapon = nil
  end
  if self.loop_effect3_weapon ~= nil then
    (self.loop_effect3_weapon):Die()
    self.loop_effect3_weapon = nil
  end
  if self.loop_caster_quan_weapon ~= nil then
    (self.loop_caster_quan_weapon):Die()
    self.loop_caster_quan_weapon = nil
  end
  if self.loop_target_quan_weapon ~= nil then
    (self.loop_target_quan_weapon):Die()
    self.loop_target_quan_weapon = nil
  end
end

bs_104101.LuaDispose = function(self)
  -- function num : 0_6 , upvalues : base
  (base.LuaDispose)(self)
  if self.passive_time ~= nil then
    (self.passive_time):Stop()
    self.passive_time = nil
  end
  if self.loop_effect ~= nil then
    (self.loop_effect):Die()
    self.loop_effect = nil
  end
  if self.loop_effect2 ~= nil then
    (self.loop_effect2):Die()
    self.loop_effect2 = nil
  end
  if self.loop_effect3 ~= nil then
    (self.loop_effect3):Die()
    self.loop_effect3 = nil
  end
  if self.loop_caster_quan ~= nil then
    (self.loop_caster_quan):Die()
    self.loop_caster_quan = nil
  end
  if self.loop_target_quan ~= nil then
    (self.loop_target_quan):Die()
    self.loop_target_quan = nil
  end
  if self.loop_effect_weapon ~= nil then
    (self.loop_effect_weapon):Die()
    self.loop_effect_weapon = nil
  end
  if self.loop_effect2_weapon ~= nil then
    (self.loop_effect2_weapon):Die()
    self.loop_effect2_weapon = nil
  end
  if self.loop_effect3_weapon ~= nil then
    (self.loop_effect3_weapon):Die()
    self.loop_effect3_weapon = nil
  end
  if self.loop_caster_quan_weapon ~= nil then
    (self.loop_caster_quan_weapon):Die()
    self.loop_caster_quan_weapon = nil
  end
  if self.loop_target_quan_weapon ~= nil then
    (self.loop_target_quan_weapon):Die()
    self.loop_target_quan_weapon = nil
  end
end

return bs_104101

