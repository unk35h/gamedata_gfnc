-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_206710 = require("GamePlay.SkillScripts.MonsterSkill.206710_JohnDoeHuashui")
local bs_206711 = class("bs_206711", bs_206710)
local base = bs_206710
bs_206711.config = {buffId1 = 175, deathTime = 220}
bs_206711.config = setmetatable(bs_206711.config, {__index = base.config})
bs_206711.ctor = function(self)
  -- function num : 0_0
end

bs_206711.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  LuaSkillCtrl:StartTimer(nil, (self.config).deathTime, self.Death, self)
end

bs_206711.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId1, 1, (self.config).deathTime, true)
  self.damTimer = LuaSkillCtrl:StartTimer(nil, 30, self.CallBack, self, -1, 30)
  self.canSummon = true
end

bs_206711.CallBack1 = function(self)
  -- function num : 0_3 , upvalues : _ENV
  if self.damTimer2 ~= nil and (self.damTimer2):IsOver() then
    self.damTimer2 = nil
  end
  local gridData = LuaSkillCtrl:CallFindEmptyGridNearest(self.caster)
  local targetlist = LuaSkillCtrl:CallTargetSelect(self, 9, 10)
  if targetlist.Count < 1 then
    return 
  end
  for i = 0, targetlist.Count - 1 do
    local gridDataTemp = LuaSkillCtrl:FindEmptyGridWithinRange((targetlist[i]).targetRole, 1)
    if gridDataTemp ~= nil then
      gridData = gridDataTemp
    end
  end
  local x = gridData.x
  local y = gridData.y
  local target = LuaSkillCtrl:GetTargetWithGrid(gridData.x, gridData.y)
  LuaSkillCtrl:CallEffect(target, (self.config).effectId, self)
  local summoner = LuaSkillCtrl:CreateSummoner(self, (self.config).monsterId, x, y)
  summoner:SetAttr(eHeroAttr.maxHp, (self.caster).maxHp * (self.config).maxHpPer // 1000)
  summoner:SetAttr(eHeroAttr.pow, (self.caster).pow * (self.config).powPer // 1000)
  summoner:SetAttr(eHeroAttr.intensity, (self.caster).intensity * (self.config).powPer // 1000)
  summoner:SetAttr(eHeroAttr.speed, (self.caster).speed)
  summoner:SetAsRealEntity(1)
  local summonerEntity = LuaSkillCtrl:AddSummonerRole(summoner)
  self.summoner = summonerEntity
end

bs_206711.Death = function(self)
  -- function num : 0_4 , upvalues : _ENV
  LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId1, 0)
  LuaSkillCtrl:RemoveLife((self.caster).hp + 1, self, self.caster, true, nil, false, true)
end

bs_206711.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_206711

