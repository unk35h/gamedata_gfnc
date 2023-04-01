-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_15065 = class("bs_15065", LuaSkillBase)
local base = LuaSkillBase
bs_15065.config = {buffId = 1258}
bs_15065.ctor = function(self)
  -- function num : 0_0
end

bs_15065.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_15065_14", 90, self.OnAfterHurt, nil, nil, (self.caster).belongNum)
  self.times = 0
end

bs_15065.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if isCrit and self:IsReadyToTake() and not isTriggerSet then
    self.times = self.times + 1
    if (self.arglist)[1] <= self.times then
      local targetlist = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.player)
      if targetlist.Count < 1 then
        return 
      end
      for i = 0, targetlist.Count - 1 do
        local targetRole = targetlist[i]
        local skills = targetRole:GetBattleSkillList()
        if skills ~= nil then
          local skillCount = skills.Count
          if skillCount > 0 then
            for j = 0, skillCount - 1 do
              local curTotalCd = (skills[j]).totalCDTime
              LuaSkillCtrl:CallResetCDForSingleSkill(skills[j], curTotalCd)
            end
          end
        end
      end
      self.times = 0
    end
  end
end

bs_15065.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_15065

