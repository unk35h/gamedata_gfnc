-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_100701 = require("GamePlay.SkillScripts.RoleSkill.100701_ChelseaPassive")
local bs_100706 = class("bs_100706", bs_100701)
local base = bs_100701
bs_100706.config = {weaponLv = 3, buffId_Dj = 100701}
bs_100706.config = setmetatable(bs_100706.config, {__index = base.config})
bs_100706.ctor = function(self)
  -- function num : 0_0
end

bs_100706.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSetHurtTrigger("bs_100706_1", 1, self.OnSetHurt, nil, nil, (self.caster).belongNum, nil, eBattleRoleBelong.player, nil, nil, eSkillTag.commonAttack)
  -- DECOMPILER ERROR at PC22: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable)["100706_time"] = (self.arglist)[4]
  LuaSkillCtrl:AddChipChipConsumeSkill(100703, 1)
end

bs_100706.OnSetHurt = function(self, context)
  -- function num : 0_2 , upvalues : _ENV
  if (context.target):GetBuffTier((self.config).buffId_Dj) > 0 and (context.target).intensity > 0 then
    LuaSkillCtrl:BroadcastLuaTrigger(eSkillLuaTrigger.OnChelseaStun, context.target)
  end
end

bs_100706.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_100706

