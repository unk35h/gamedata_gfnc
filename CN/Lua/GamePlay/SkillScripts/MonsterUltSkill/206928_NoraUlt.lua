-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("GamePlay.SkillScripts.RoleUltSkill.104803_NoraUlt")
local bs_206928 = class("bs_206928", base)
bs_206928.config = {delayInvoke = 20, actionId_start = 1001}
bs_206928.config = setmetatable(bs_206928.config, {__index = base.config})
bs_206928.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_0 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).EnemyBuffTime = 45
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).BaseMissChance = 15
  self.NoEnemy = false
end

bs_206928.PlaySkill = function(self, data, selectTargetCoord, selectRoles)
  -- function num : 0_1 , upvalues : _ENV
  local buffDown = LuaSkillCtrl:GetRoleBuffById(self.caster, (self.config).buffId_down)
  if buffDown ~= nil then
    LuaSkillCtrl:CallRoleAction(self.caster, 1042, 1)
    LuaSkillCtrl:CallRoleAction(self.caster, 102, 1)
    LuaSkillCtrl:CallRoleAction(self.caster, 1040, 3)
  else
    LuaSkillCtrl:CallRoleAction(self.caster, 1008, 1)
  end
  self.invokeTimer = self:PlayMonsterUltSkill(40, self.config)
end

bs_206928.InternalInvoke = function(self, data, role)
  -- function num : 0_2 , upvalues : base
  (base.PlaySkill)(self, data)
end

bs_206928.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  if self.invokeTimer ~= nil then
    (self.invokeTimer):Stop()
    self.invokeTimer = nil
  end
  ;
  (base.OnCasterDie)(self)
end

return bs_206928

