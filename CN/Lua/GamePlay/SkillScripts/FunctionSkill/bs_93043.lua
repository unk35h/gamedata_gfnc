-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_93043 = class("bs_93043", LuaSkillBase)
local base = LuaSkillBase
bs_93043.config = {summonId = 1022}
bs_93043.ctor = function(self)
  -- function num : 0_0
end

bs_93043.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1
  self:AddOnRoleDieTrigger("bs_93043_1", 10, self.OnRoleDie, nil, nil, nil, (self.caster).belongNum)
end

bs_93043.OnRoleDie = function(self, killer, role)
  -- function num : 0_2 , upvalues : _ENV
  if role.roleType ~= eBattleRoleType.character or role.dataId == (self.config).summonId then
    return 
  end
  local x, y = role.x, role.y
  LuaSkillCtrl:StartTimer(self, 3, function()
    -- function num : 0_2_0 , upvalues : _ENV, self, x, y, role
    local summoner = LuaSkillCtrl:CreateSummoner(self, (self.config).summonId, x, y, eBattleRoleBelong.player)
    do
      if summoner == nil then
        local grid = LuaSkillCtrl:FindEmptyGridsWithinRange(x, y, 2)
        x = grid.x
        y = grid.y
        summoner = LuaSkillCtrl:CreateSummoner(self, (self.config).summonId, x, y, eBattleRoleBelong.player)
      end
      summoner:SetAttr(eHeroAttr.maxHp, role.maxHp)
      summoner:SetAttr(eHeroAttr.skill_intensity, role.skill_intensity)
      summoner:SetAttr(eHeroAttr.pow, role.pow)
      summoner:SetAttr(eHeroAttr.speed, role.speed)
      summoner:SetAttr(eHeroAttr.moveSpeed, role.movespeed)
      summoner:SetAttr(eHeroAttr.def, 0)
      summoner:SetAttr(eHeroAttr.dodge, 0)
      summoner:SetAsRealEntity(1)
      local summonerEntity = LuaSkillCtrl:AddSummonerRole(summoner)
    end
  end
)
end

bs_93043.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_93043

