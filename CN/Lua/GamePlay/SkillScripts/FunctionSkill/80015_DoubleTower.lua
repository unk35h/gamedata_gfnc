-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_80015 = class("bs_80015", LuaSkillBase)
local base = LuaSkillBase
bs_80015.config = {curCd = 15}
bs_80015.ctor = function(self)
  -- function num : 0_0
end

bs_80015.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterAddBuffTrigger("bs_80015_1", 1, self.OnAfterAddBuff, self.caster, nil, nil, nil, nil, nil, eBuffFeatureType.Stun)
end

bs_80015.OnAfterAddBuff = function(self, buff, target)
  -- function num : 0_2 , upvalues : _ENV
  if target.belongNum == eBattleRoleBelong.enemy then
    local skills = target:GetBattleSkillList()
    if skills ~= nil then
      local count = skills.Count
      if count > 0 then
        for i = 0, count - 1 do
          local curCd = -(self.config).curCd
          if not (skills[i]).isCommonAttack then
            LuaSkillCtrl:CallResetCDForSingleSkill(skills[i], curCd)
          end
        end
      end
    end
  end
end

bs_80015.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_80015

