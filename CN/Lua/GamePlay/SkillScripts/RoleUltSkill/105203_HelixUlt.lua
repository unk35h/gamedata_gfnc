-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_105203 = class("bs_105203", LuaSkillBase)
local base = LuaSkillBase
bs_105203.config = {actionId_start = 1005, buffId_Super = 196, buff_abandonUlt = 105205, buff_efc = 105204, effectId_line = 105215, speical_ultHeroEffect = "helix/skill/FXP_UltimateSkill_helix", audioIdStart = 105212, audioIdMovie = 105213, audioIdEnd = 105214}
bs_105203.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_0 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddLuaTrigger(eSkillLuaTrigger.OnUltSkillPlayed, self.OnUltSkillPlayed)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_105203_start", 1, self.OnAfterBattleStart)
  self:AddTrigger(eSkillTriggerType.RoleDie, "bs_105203_start_02", 1, self.OnRoleDie)
  self.lastUltRole = nil
end

bs_105203.OnAfterBattleStart = function(self)
  -- function num : 0_1 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buff_abandonUlt, 1, nil)
  MsgCenter:Broadcast(eMsgEventId.OnCreatSpecialUltHearoEffect, (self.cskill).dataId, (self.config).speical_ultHeroEffect, true, (self.caster).roleDataId)
end

bs_105203.OnRoleDie = function(self, killer, role)
  -- function num : 0_2 , upvalues : _ENV
  if role == self.lastUltRole then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buff_abandonUlt, 1, nil)
  end
end

bs_105203.OnUltSkillPlayed = function(self, role)
  -- function num : 0_3 , upvalues : _ENV
  local isLastUltRoleUltTaked = role == self.lastUltRole
  if role.belongNum == (self.caster).belongNum and role ~= self.caster and role.roleType ~= eBattleRoleType.skillCaster then
    self.lastUltRole = role
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buff_abandonUlt, 1)
    if not LuaSkillCtrl.IsInVerify then
      (LuaSkillCtrl.cUltSkillCtrl):UpdateUIForce()
    end
    if self.lastUltMp ~= nil then
      local curValue = LuaSkillCtrl:GetUltHMp()
      self.cost = self.cost + self.lastUltMp - curValue
      self.lastUltMp = curValue
      if (isLastUltRoleUltTaked or curValue < (ConfigData.game_config).ultMpCost) and self.isShowActiveEff then
        MsgCenter:Broadcast(eMsgEventId.OnHideSpeicalUltHearoEffect, (self.cskill).dataId, (self.lastUltRole).roleDataId)
        self.isShowActiveEff = false
      end
    end
  end
  -- DECOMPILER ERROR: 4 unprocessed JMP targets
end

bs_105203.PlaySkill = function(self)
  -- function num : 0_4 , upvalues : _ENV
  if self.lastUltRole == nil or (self.lastUltRole).hp <= 0 then
    return 
  end
  local ultSkill = ((self.lastUltRole):GetSkillComponent()).ultSkill
  if ultSkill == nil then
    return 
  end
  ultSkill:ResetCDTimeRatio(100)
  LuaSkillCtrl:CallEffect(self.lastUltRole, (self.config).effectId_line, self)
  LuaSkillCtrl:CallBuff(self, self.lastUltRole, (self.config).buff_efc, 1, (self.arglist)[1])
  MsgCenter:Broadcast(eMsgEventId.OnShowSpeicalUltHearoEffect, (self.cskill).dataId, (self.lastUltRole).roleDataId)
  self.isShowActiveEff = true
  LuaSkillCtrl:CallAddPlayerHmp((ConfigData.game_config).ultMpCost)
  self.lastUltMp = LuaSkillCtrl:GetUltHMp()
  self.cost = self.cost or 0
  if self.returnHmpTimer ~= nil then
    (self.returnHmpTimer):Stop()
    self.returnHmpTimer = nil
  end
  self.returnHmpTimer = LuaSkillCtrl:StartTimer(nil, (self.arglist)[1], function()
    -- function num : 0_4_0 , upvalues : self, _ENV
    do
      if self.cost < (ConfigData.game_config).ultMpCost then
        local subValue = (ConfigData.game_config).ultMpCost - self.cost
        self.lastUltMp = nil
        self.cost = nil
        LuaSkillCtrl:CallAddPlayerHmp(-subValue)
      end
      if self.isShowActiveEff then
        MsgCenter:Broadcast(eMsgEventId.OnHideSpeicalUltHearoEffect, (self.cskill).dataId, (self.lastUltRole).roleDataId)
        self.isShowActiveEff = false
      end
    end
  end
)
end

bs_105203.PlayUltEffect = function(self)
  -- function num : 0_5 , upvalues : base, _ENV
  (base.PlayUltEffect)(self)
  LuaSkillCtrl:CallFocusTimeLine(self.caster)
end

bs_105203.OnUltRoleAction = function(self)
  -- function num : 0_6 , upvalues : base, _ENV
  (base.OnUltRoleAction)(self)
  LuaSkillCtrl:StartTimerInUlt(self, 15, self.PlayUltMovie)
  LuaSkillCtrl:CallRoleAction(self.caster, 1005)
end

bs_105203.OnMovieFadeOut = function(self)
  -- function num : 0_7 , upvalues : _ENV, base
  LuaSkillCtrl:CallBackViewTimeLine(self.caster, true)
  ;
  (base.OnMovieFadeOut)(self)
end

bs_105203.OnCasterDie = function(self)
  -- function num : 0_8 , upvalues : base
  (base.OnCasterDie)(self)
  self.lastUltRole = nil
  self.cost = nil
  if self.returnHmpTimer ~= nil then
    (self.returnHmpTimer):Stop()
    self.returnHmpTimer = nil
  end
end

bs_105203.LuaDispose = function(self)
  -- function num : 0_9 , upvalues : base
  (base.LuaDispose)(self)
  self.lastUltRole = nil
  self.lastUltMp = nil
end

return bs_105203

