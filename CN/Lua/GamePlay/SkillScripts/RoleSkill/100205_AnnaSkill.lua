-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_100202 = require("GamePlay.SkillScripts.RoleSkill.100202_AnnaSkill")
local bs_100205 = class("bs_100205", bs_100202)
local base = bs_100202
bs_100205.config = {weaponLv = 2, effectId_trail = 100208, effectId_line = 100207, effectId_trail3 = 100219, buffId_cockhourse2 = 100203, time = nil, tier = 1, tier_skill = 1, selectId_skill = 9, select_range = 10, 
hurt_config_extra = {hit_formula = 0, def_formula = 0, basehurt_formula = 100201, crit_formula = 0, returndamage_formula = 0, lifesteal_formula = 0, spell_lifesteal_formula = 0, returndamage_formula = 0}
}
bs_100205.config = setmetatable(bs_100205.config, {__index = base.config})
bs_100205.ctor = function(self)
  -- function num : 0_0
end

bs_100205.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self.targetlist = {}
  self:AddLuaTrigger(eSkillLuaTrigger.OnAnnaStun, self.OnAnnaStun)
end

bs_100205.OnAnnaStun = function(self, target)
  -- function num : 0_2 , upvalues : _ENV
  local maker = self.caster
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  if (self.targetlist)[target] == nil then
    (self.targetlist)[target] = 1
  end
  -- DECOMPILER ERROR at PC22: Confused about usage of register: R3 in 'UnsetPending'

  if target.belongNum ~= maker.belongNum and target ~= self.caster and self.cando == true and (self.targetlist)[target] <= 1 then
    (self.targetlist)[target] = 2
    LuaSkillCtrl:StartTimer(self, 2, function()
    -- function num : 0_2_0 , upvalues : _ENV, self, target
    local transferList = LuaSkillCtrl:CallTargetSelect(self, (self.config).selectId_skill, (self.config).select_range)
    if transferList.Count == 0 then
      return 
    end
    local num1 = 0
    for i = 0, transferList.Count - 1 do
      local role = (transferList[i]).targetRole
      if role ~= target and role.intensity ~= 0 then
        num1 = num1 + 1
        if num1 <= 2 then
          LuaSkillCtrl:CallEffect(role, (self.config).effectId_trail3, self, self.SkillEventFunc_extra2, target)
        else
          break
        end
      end
    end
  end
)
  end
end

bs_100205.SkillEventFunc_extra2 = function(self, effect, eventId, target)
  -- function num : 0_3 , upvalues : _ENV
  if eventId == eBattleEffectEvent.Trigger then
    local skillResult = LuaSkillCtrl:CallSkillResult(effect, target)
    LuaSkillCtrl:HurtResult(self, skillResult, (self.config).hurt_config_extra, nil, true)
    skillResult:EndResult()
    LuaSkillCtrl:CallBuff(self, target.targetRole, (self.config).buffId_cockhourse2, 1, nil, true)
  end
end

bs_100205.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
  self.targetlist = {}
end

return bs_100205

