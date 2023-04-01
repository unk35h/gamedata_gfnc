-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_21093 = class("bs_21093", LuaSkillBase)
local base = LuaSkillBase
bs_21093.config = {}
bs_21093.ctor = function(self)
  -- function num : 0_0
end

bs_21093.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddLuaTrigger(eSkillLuaTrigger.OnRoleSplash, self.OnAfterMove)
end

bs_21093.OnAfterMove = function(self, role, grid)
  -- function num : 0_2 , upvalues : _ENV
  local value = (self.arglist)[1] * 100 // 1
  local skills = role:GetBattleSkillList()
  if skills ~= nil then
    local skillCount = skills.Count
    if skillCount > 0 then
      for j = 0, skillCount - 1 do
        local curTotalCd = (skills[j]).totalCDTime * (self.arglist)[1] // 1000
        if not (skills[j]).isCommonAttack then
          LuaSkillCtrl:CallResetCDForSingleSkill(skills[j], curTotalCd)
        end
      end
    end
  end
end

bs_21093.OnAfterPlaySkill = function(self, skill, role)
  -- function num : 0_3 , upvalues : _ENV
  local value = (self.arglist)[1] // 10
  if skill.dataId == 5011 or not 5012 then
    LuaSkillCtrl:CallResetCDRatioForRole(role, value)
  end
end

bs_21093.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_21093

