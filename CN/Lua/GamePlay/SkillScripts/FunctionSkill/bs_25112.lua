-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_25112 = class("bs_25112", LuaSkillBase)
local base = LuaSkillBase
bs_25112.config = {buffId = 110094}
bs_25112.ctor = function(self)
  -- function num : 0_0
end

bs_25112.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterAddBuffTrigger("bs_25112_2", 1, self.OnAfterAddBuff, nil, nil, eBattleRoleBelong.player, eBattleRoleBelong.enemy, nil, nil, eBuffFeatureType.Stun)
end

bs_25112.OnAfterAddBuff = function(self, buff, target)
  -- function num : 0_2 , upvalues : _ENV
  if target.belongNum == eBattleRoleBelong.enemy then
    local targetList = LuaSkillCtrl:CallTargetSelect(self, 6, 10)
    if targetList.Count > 0 then
      for i = 0, targetList.Count - 1 do
        local targetRole = (targetList[i]).targetRole
        LuaSkillCtrl:DispelBuff(targetRole, (self.config).buffId, 0, true)
        LuaSkillCtrl:CallBuff(self, targetRole, (self.config).buffId, 1, (self.arglist)[2])
      end
    end
  end
end

bs_25112.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_25112

