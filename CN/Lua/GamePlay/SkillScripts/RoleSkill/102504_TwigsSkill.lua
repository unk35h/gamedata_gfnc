-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_102502 = require("GamePlay.SkillScripts.RoleSkill.102502_TwigsSkill")
local bs_102504 = class("bs_102504", bs_102502)
local base = bs_102502
bs_102504.config = {buffId_CH2 = 102505, weaponLv = 1}
bs_102504.config = setmetatable(bs_102504.config, {__index = base.config})
bs_102504.ctor = function(self)
  -- function num : 0_0
end

bs_102504.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_102504.OnBuffDie = function(self, buff, target, removeType)
  -- function num : 0_2 , upvalues : _ENV
  if buff.dataId == (self.config).buffId_Hua and removeType == eBuffRemoveType.Timeout then
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, self.caster, (self.config).Aoe)
    if (skillResult.roleList).Count > 0 then
      for i = 0, (skillResult.roleList).Count - 1 do
        local role = (skillResult.roleList)[i]
        if role:GetBuffTier((self.config).buffId_CH) > 0 then
          LuaSkillCtrl:DispelBuff(role, (self.config).buffId_CH, 0)
          if role:GetBuffTier((self.config).buffId_CH2) > 0 then
            LuaSkillCtrl:DispelBuff(role, (self.config).buffId_CH2, 0)
          end
        end
      end
    end
    do
      do
        skillResult:EndResult()
        self:OnSkillDamageEnd()
      end
    end
  end
end

bs_102504.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_102504

