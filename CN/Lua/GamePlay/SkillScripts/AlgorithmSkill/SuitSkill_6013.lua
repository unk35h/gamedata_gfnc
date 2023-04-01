-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_6013 = class("bs_6013", LuaSkillBase)
local base = LuaSkillBase
bs_6013.config = {buff_yishang = 601301}
bs_6013.ctor = function(self)
  -- function num : 0_0
end

bs_6013.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterAddBuffTrigger("bs_6013_7", 1, self.OnAfterAddBuff, self.caster)
end

bs_6013.OnAfterAddBuff = function(self, buff, target)
  -- function num : 0_2 , upvalues : _ENV
  if (buff.buffCfg).IsControl then
    LuaSkillCtrl:CallBuff(self, target, (self.config).buff_yishang, 1, (self.arglist)[2])
  end
end

bs_6013.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

bs_6013.LuaDispose = function(self)
  -- function num : 0_4 , upvalues : base
  (base.LuaDispose)(self)
  self.Ismove = nil
end

return bs_6013

