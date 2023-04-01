-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_206701 = class("bs_206701", LuaSkillBase)
local base = LuaSkillBase
bs_206701.config = {buffId_superArmor = 2067011, buffId_curse = 2067012, buffId_curseLabel1 = 2067013, buffId_curseLabel2 = 2067014, buffId_curseLabel3 = 2067015, effectId_curse = 2067011}
bs_206701.ctor = function(self)
  -- function num : 0_0
end

bs_206701.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_206701_1", 1, self.OnAfterBattleStart)
  self:AddAfterHurtTrigger("bs_206701_2", 99, self.OnAfterHurt, self.caster, nil, nil, nil, nil, nil, 206700)
  -- DECOMPILER ERROR at PC23: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).curse = (self.arglist)[1]
end

bs_206701.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_superArmor, 1, nil)
  ;
  (self.caster):AddRoleProperty(eHeroAttr.cd_reduce, 1000, eHeroAttrType.Extra)
end

bs_206701.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_3 , upvalues : _ENV
  if sender == self.caster and skill.isCommonAttack == true and isMiss == false then
    if target == nil or target.hp <= 0 then
      return 
    end
    local frontTarget = ((self.caster).recordTable).frontTarget
    if frontTarget ~= nil and frontTarget ~= target then
      local falseGodEnermy = eBattleRoleBelong.player
      if (self.caster).belongNum == eBattleRoleBelong.player then
        falseGodEnermy = eBattleRoleBelong.enemy
      end
      local targetList = LuaSkillCtrl:GetSelectTeamRoles(falseGodEnermy)
      if targetList.Count > 0 then
        for i = 0, targetList.Count - 1 do
          frontTarget = targetList[i]
          LuaSkillCtrl:DispelBuff(frontTarget, (self.config).buffId_curse, 0, true)
          LuaSkillCtrl:DispelBuff(frontTarget, (self.config).buffId_curseLabel1, 0, true)
          LuaSkillCtrl:DispelBuff(frontTarget, (self.config).buffId_curseLabel3, 0, true)
        end
      end
    end
    do
      -- DECOMPILER ERROR at PC71: Confused about usage of register: R10 in 'UnsetPending'

      ;
      ((self.caster).recordTable).frontTarget = target
      LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_curse, 1)
      self:CurseLabel(target)
      if ((self.caster).recordTable).RootCurseUp ~= nil then
        local extraCurse = LuaSkillCtrl:CallRange(1, 1000)
        if extraCurse <= ((self.caster).recordTable).RootCurseUp then
          LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_curse, 1)
          self:CurseLabel(target)
        end
      end
    end
  end
end

bs_206701.CurseLabel = function(self, target)
  -- function num : 0_4 , upvalues : _ENV
  local labelTier = target:GetBuffTier((self.config).buffId_curse)
  if labelTier <= 6 then
    LuaSkillCtrl:DispelBuff(target, (self.config).buffId_curseLabel3, 0, true)
    LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_curseLabel1, 1)
  else
    LuaSkillCtrl:DispelBuff(target, (self.config).buffId_curseLabel1, 0, true)
    LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_curseLabel3, 1)
  end
end

bs_206701.OnCasterDie = function(self)
  -- function num : 0_5
end

return bs_206701

