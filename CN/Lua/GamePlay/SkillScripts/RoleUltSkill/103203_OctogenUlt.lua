-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_103203 = class("bs_103203", LuaSkillBase)
local base = LuaSkillBase
bs_103203.config = {
hurt_config = {hit_formula = 10010, basehurt_formula = 10076, crit_formula = 0}
, effect_Hit = 103208, effect_Zibao = 103209, effect_ZD = 103212, buff_unselected = 69, buffFeature_ignoreDie = 6, buff_die = 103201, buff_invincible = 103202, audioIdStart = 103207, audioIdMovie = 103208, audioIdEnd = 103209, movieEndRoleActionId = 1006}
bs_103203.ctor = function(self)
  -- function num : 0_0
end

bs_103203.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_103203.PlaySkill = function(self, data, selectTargetCoord, selectRoles)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallRoleAction(self.caster, 1006, 1)
  LuaSkillCtrl:CallBreakAllSkill(self.caster)
  self:CancleCasterWait()
  self:CallCasterWait(999)
  self:Boom()
  if selectTargetCoord ~= nil then
    local targetGrid = LuaSkillCtrl:GetTargetWithGrid(selectTargetCoord.x, selectTargetCoord.y)
    do
      (self.caster):LookAtTarget(targetGrid)
      local targetlist_enemy = LuaSkillCtrl:FindAllRolesWithinRange(targetGrid, 1, true)
      LuaSkillCtrl:CallEffect(targetGrid, (self.config).effect_ZD, self)
      LuaSkillCtrl:StartTimer(self, 10, function()
    -- function num : 0_2_0 , upvalues : targetlist_enemy, _ENV, self
    if targetlist_enemy ~= nil and targetlist_enemy.Count > 0 then
      for i = 0, targetlist_enemy.Count - 1 do
        local targetlist_hit_enemy = targetlist_enemy[i]
        if targetlist_hit_enemy.belongNum ~= eBattleRoleBelong.player and not targetlist_hit_enemy:IsUnSelect(self.caster) then
          local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, targetlist_hit_enemy)
          LuaSkillCtrl:HurtResult(self, skillResult, (self.config).hurt_config, nil, false)
          skillResult:EndResult()
        end
      end
    end
  end
)
    end
  end
end

bs_103203.Boom = function(self)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buff_invincible, 1, 100, true)
  LuaSkillCtrl:StartTimer(self, 15, function()
    -- function num : 0_3_0 , upvalues : _ENV, self
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buff_die, 1, 45, true)
  end
)
  LuaSkillCtrl:StartTimer(self, 30, function()
    -- function num : 0_3_1 , upvalues : _ENV, self
    local IfRoleCotainsIgnoreDieBuff = LuaSkillCtrl:RoleContainsBuffFeature(self.caster, (self.config).buffFeature_ignoreDie)
    if IfRoleCotainsIgnoreDieBuff == true then
      local buff_ignoreDie = LuaSkillCtrl:GetRoleAllBuffsByFeature(self.caster, (self.config).buffFeature_ignoreDie)
      if buff_ignoreDie.Count > 0 then
        for i = 0, buff_ignoreDie.Count - 1 do
          LuaSkillCtrl:DispelBuff(self.caster, (buff_ignoreDie[i]).dataId, 0)
          IfRoleCotainsIgnoreDieBuff = false
        end
      end
    end
    do
      if (self.caster).hp > 0 and IfRoleCotainsIgnoreDieBuff == false then
        if not LuaSkillCtrl.IsInVerify then
          (((self.caster).lsObject).gameObject):SetActive(false)
        end
        LuaSkillCtrl:RemoveLife((self.caster).hp, self, self.caster, true, nil, false, true, eHurtType.RealDmg, true)
      end
    end
  end
)
end

bs_103203.PlayUltEffect = function(self)
  -- function num : 0_4 , upvalues : base, _ENV
  (base.PlayUltEffect)(self)
  LuaSkillCtrl:CallBuff(self, self.caster, 196, 1, 10, true)
  LuaSkillCtrl:CallFocusTimeLine(self.caster)
end

bs_103203.OnUltRoleAction = function(self)
  -- function num : 0_5 , upvalues : base, _ENV
  (base.OnUltRoleAction)(self)
  LuaSkillCtrl:StartTimerInUlt(self, 7, self.PlayUltMovie)
  LuaSkillCtrl:CallRoleAction(self.caster, 1005, 1)
end

bs_103203.OnCasterDie = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnCasterDie)(self)
end

bs_103203.LuaDispose = function(self)
  -- function num : 0_7 , upvalues : _ENV, base
  if not LuaSkillCtrl.IsInVerify and self.caster ~= nil and not IsNull(((self.caster).lsObject).gameObject) then
    (((self.caster).lsObject).gameObject):SetActive(true)
  end
  ;
  (base.LuaDispose)(self)
end

return bs_103203

