-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_4020003 = class("bs_4020003", LuaSkillBase)
local base = LuaSkillBase
bs_4020003.config = {effectId = 12075, buffId = 2092}
bs_4020003.ctor = function(self)
  -- function num : 0_0
end

bs_4020003.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_4020003_1", 1, self.OnBattleStart)
  self:AddAfterPlaySkillTrigger("bs_4020003_2", 1, self.OnAfterPlaySkill, nil, nil, eBattleRoleBelong.player, nil, nil, nil, nil, eSkillTag.normalSkill)
end

bs_4020003.OnBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local targetList = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.player)
  for i = 0, targetList.Count - 1 do
    local role = targetList[i]
    if role ~= nil and role.roleType == eBattleRoleType.character then
      LuaSkillCtrl:CallBuff(self, role, (self.config).buffId, 1)
      LuaSkillCtrl:CallEffect(role, (self.config).effectId, self)
    end
  end
end

bs_4020003.OnAfterPlaySkill = function(self, skill, role)
  -- function num : 0_3 , upvalues : _ENV
  if role.roleType ~= eBattleRoleType.character then
    return 
  end
  if (role.recordTable).bs_4020003 == true then
    LuaSkillCtrl:CallEffect(role, (self.config).effectId, self)
    -- DECOMPILER ERROR at PC18: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (role.recordTable).bs_4020003 = false
    return 
  end
  local range = LuaSkillCtrl:CallRange(1, 1000)
  if range <= (self.arglist)[1] then
    local callback = BindCallback(self, self.eventFunc, role)
    LuaSkillCtrl:StartTimer(self, 4, callback)
  end
end

bs_4020003.eventFunc = function(self, role)
  -- function num : 0_4 , upvalues : _ENV
  local skills = role:GetBattleSkillList()
  LuaSkillCtrl:CallReFillMainSkillCdForRole(role)
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (role.recordTable).bs_4020003 = true
end

bs_4020003.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_4020003

