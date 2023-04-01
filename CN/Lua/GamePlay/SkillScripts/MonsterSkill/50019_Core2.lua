-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("GamePlay.SkillScripts.MonsterSkill.50023_equipmentCommonSkill")
local bs_50019 = class("bs_50019", base)
bs_50019.config = {buffId_Core2 = 5001901}
bs_50019.ctor = function(self)
  -- function num : 0_0
end

bs_50019.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_50019.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local caster = LuaSkillCtrl:GetEquipmentSummonerOrHostEntity(self.caster)
  if caster ~= nil then
    LuaSkillCtrl:CallBuff(self, caster, (self.config).buffId_Core2, 1)
  else
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_Core2, 1)
  end
end

bs_50019.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_50019

