-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_4010404 = class("bs_4010404", LuaSkillBase)
local base = LuaSkillBase
bs_4010404.config = {}
bs_4010404.ctor = function(self)
  -- function num : 0_0
end

bs_4010404.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSelfTrigger(eSkillTriggerType.AfterBattleStart, "bs_4010404_1", 1, self.OnAfterBattleStart)
  self.time = nil
end

bs_4010404.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if self.time ~= nil then
    (self.timer):Stop()
    self.time = nil
  end
  self.time = LuaSkillCtrl:StartTimer(nil, (self.arglist)[1], BindCallback(self.OnAction), self, -1, (self.arglist)[1])
end

bs_4010404.OnAction = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local targetlist = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.enemy)
  if targetlist.Count > 0 then
    for i = 0, targetlist.Count - 1 do
      local targetRole = targetlist[i]
      local skilllist = targetRole:GetBattleSkillList()
      if skilllist ~= nil then
        local skillCount = skilllist.Count
        if skillCount > 0 then
          for j = 0, skillCount - 1 do
            local curTotalCd = -(skilllist[j]).totalCDTime * (self.arglist)[2] // 1000
            LuaSkillCtrl:CallResetCDForSingleSkill(skilllist[j], curTotalCd)
          end
        end
      end
    end
  end
end

bs_4010404.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_4010404

