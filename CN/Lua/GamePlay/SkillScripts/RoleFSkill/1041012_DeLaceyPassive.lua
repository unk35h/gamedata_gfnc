-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("GamePlay.SkillScripts.RoleFSkill.FakeCommonPassive")
local bs_1041012 = class("bs_1041012", base)
bs_1041012.config = {
heal_config = {baseheal_formula = 3021}
, buffId_pow = 10410101, buffId_skill = 10410201, effectId_start = 104104, effectId_line = 104105, effectId_healLine = 104106, effectId_line_go = 104118, effectId_line_come = 104117, effectId_quan = 104116}
bs_1041012.ctor = function(self)
  -- function num : 0_0
end

bs_1041012.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_1041012_1", 1, self.OnAfterBattleStart)
end

bs_1041012.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R1 in 'UnsetPending'

  ((self.caster).recordTable).pass_target = nil
  local targetList = LuaSkillCtrl:CallTargetSelect(self, 6, 20)
  local attack_int = 0
  local up_type = 0
  local num_dis = 100
  local casterx = (self.caster).x
  if targetList ~= nil and targetList.Count > 0 then
    for i = 0, targetList.Count - 1 do
      local role = (targetList[i]).targetRole
      local rolex = role.x
      -- DECOMPILER ERROR at PC57: Confused about usage of register: R12 in 'UnsetPending'

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
              -- DECOMPILER ERROR at PC90: Confused about usage of register: R13 in 'UnsetPending'

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
              -- DECOMPILER ERROR at PC107: Confused about usage of register: R13 in 'UnsetPending'

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
  end
  do
    if ((self.caster).recordTable).pass_target ~= nil then
      self:AddTrigger(eSkillTriggerType.RoleDie, "bs_1041012_2", 10, self.OnRoleDie)
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
      self.loop_caster_quan = LuaSkillCtrl:CallEffect(((self.caster).recordTable).pass_target, (self.config).effectId_quan, self)
      self.loop_target_quan = LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_quan, self)
    end
  end
end

bs_1041012.OnPassiveHeal = function(self, target)
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
    if target ~= nil and target.hp > 0 then
      local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
      local healValue = (self.arglist)[2] * (1000 + ((self.caster).recordTable)["skill_arglist[1]"]) // 1000
      LuaSkillCtrl:HealResult(skillResult, (self.config).heal_config, {healValue})
      skillResult:EndResult()
      LuaSkillCtrl:CallEffect(target, (self.config).effectId_healLine, self)
    end
  end
)
end

bs_1041012.OnRoleDie = function(self, killer, role)
  -- function num : 0_4
  if role == ((self.caster).recordTable).pass_target then
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
    -- DECOMPILER ERROR at PC49: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.caster).recordTable).pass_target = nil
  end
end

bs_1041012.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base, _ENV
  (base.OnCasterDie)(self)
  local role = ((self.caster).recordTable).pass_target
  if role ~= nil and role.hp > 0 then
    LuaSkillCtrl:DispelBuff(role, (self.config).buffId_pow, 0, true)
    LuaSkillCtrl:DispelBuff(role, (self.config).buffId_skill, 0, true)
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
end

bs_1041012.LuaDispose = function(self)
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
end

return bs_1041012

