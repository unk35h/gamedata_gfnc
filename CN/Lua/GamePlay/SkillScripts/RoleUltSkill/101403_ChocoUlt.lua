-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_101403 = class("bs_101403", LuaSkillBase)
local base = LuaSkillBase
bs_101403.config = {effectId_start = 10859, effectId_cookie = 1014031, effectId_cookiebreak = 1014032, effectId_speed = 1, actionId_start = 1005, movieEndRoleAction = 1006, audioStart = 101406, audioIdMovie = 101407, audioIdEnd = 101408, skilltime = 30, buffId_cookie = 1014031, select_id = 6, select_range = 20}
bs_101403.ctor = function(self)
  -- function num : 0_0
end

bs_101403.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSetHurtTrigger("bs_101403_1", 99, self.OnSetHurt, nil, nil, nil, nil, nil)
  self.ulttarget = 0
end

bs_101403.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBreakAllSkill(self.caster)
  self:CallCasterWait((self.config).skilltime)
  LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_start, self, nil, nil, 1, true)
  LuaSkillCtrl:CallBattleCamShake()
  self:CallSelectExecute()
end

bs_101403.CallSelectExecute = function(self)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:CallRoleAction(self.caster, 1006, 1)
  local targetList = LuaSkillCtrl:CallTargetSelect(self, (self.config).select_id, (self.config).select_range)
  if targetList.Count > 0 then
    for i = 0, targetList.Count - 1 do
      local role = (targetList[i]).targetRole
      if role ~= nil and role.belongNum == (self.caster).belongNum and role.roleType == 1 then
        self:CallCookieBuff(role)
      end
    end
  end
end

bs_101403.CallCookieBuff = function(self, role)
  -- function num : 0_4 , upvalues : _ENV
  if role == nil or role.hp <= 0 then
    return 
  else
    local cookieTier = (self.arglist)[1]
    LuaSkillCtrl:CallBuff(self, role, (self.config).buffId_cookie, cookieTier, (self.arglist)[4])
  end
end

bs_101403.OnSetHurt = function(self, context)
  -- function num : 0_5 , upvalues : _ENV
  local limit_hurt = (context.target).maxHp * (self.arglist)[2] // 1000
  local cookie = (context.target):GetBuffTier((self.config).buffId_cookie)
  if cookie > 0 and limit_hurt <= context.hurt then
    LuaSkillCtrl:DispelBuff(context.target, (self.config).buffId_cookie, 1, true)
    context.hurt = 1
    LuaSkillCtrl:CallEffect(context.target, (self.config).effectId_cookiebreak, self, nil, nil, 1, true)
  end
end

bs_101403.PlayUltEffect = function(self)
  -- function num : 0_6 , upvalues : base, _ENV
  (base.PlayUltEffect)(self)
  LuaSkillCtrl:CallBuff(self, self.caster, 196, 1, 15, true)
  LuaSkillCtrl:CallFocusTimeLine(self.caster)
end

bs_101403.OnUltRoleAction = function(self)
  -- function num : 0_7 , upvalues : base, _ENV
  (base.OnUltRoleAction)(self)
  LuaSkillCtrl:StartTimerInUlt(self, 7, self.PlayUltMovie, self)
  LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId_start)
end

bs_101403.OnSkipUltView = function(self)
  -- function num : 0_8 , upvalues : base
  (base.OnSkipUltView)(self)
end

bs_101403.OnMovieFadeOut = function(self)
  -- function num : 0_9 , upvalues : base
  (base.OnMovieFadeOut)(self)
end

bs_101403.OnCasterDie = function(self)
  -- function num : 0_10 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_101403

