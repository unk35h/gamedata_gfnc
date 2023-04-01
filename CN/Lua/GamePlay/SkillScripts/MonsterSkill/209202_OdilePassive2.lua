-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_209202 = class("bs_209202", LuaSkillBase)
local base = LuaSkillBase
bs_209202.config = {effectId_Grid = 209203, effectId_Grid_s = 209218, HurtConfigID = 16, audioId = 209203}
bs_209202.ctor = function(self)
  -- function num : 0_0
end

bs_209202.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self.MapBorder = LuaSkillCtrl:GetMapBorder()
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_209202_2", 1, self.OnAfterBattleStart)
end

bs_209202.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local FirstSecond = self:getbattleCurSecond()
  LuaSkillCtrl:StartTimer(nil, 15, (BindCallback(self, self.OnLoopDamage, FirstSecond)), nil, -1, 0)
  if (self.MapBorder).x > 6 then
    local effectGrid = LuaSkillCtrl:GetTargetWithGrid(3, 2)
    LuaSkillCtrl:CallEffect(effectGrid, (self.config).effectId_Grid, self)
  else
    do
      do
        local effectGrid = LuaSkillCtrl:GetTargetWithGrid(2, 2)
        LuaSkillCtrl:CallEffect(effectGrid, (self.config).effectId_Grid_s, self)
        LuaSkillCtrl:PlayAuSource(self.caster, (self.config).audioId)
      end
    end
  end
end

bs_209202.OnLoopDamage = function(self, FirstSecond)
  -- function num : 0_3 , upvalues : _ENV
  local CurSecond = self:getbattleCurSecond()
  local extraDamage = (CurSecond - FirstSecond) // ((self.arglist)[2] // 15)
  local targetList = LuaSkillCtrl:CallTargetSelect(self, 9, 10)
  if targetList.Count > 0 then
    for i = 0, targetList.Count - 1 do
      local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, targetList[i])
      LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).HurtConfigID, {(self.arglist)[1] + extraDamage * (self.arglist)[3]})
      skillResult:EndResult()
    end
  end
end

bs_209202.getbattleCurSecond = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local battleCtrl = ((CS.BattleManager).Instance).CurBattleController
  local battleFrame = battleCtrl.frame
  local battleCurSecond = (BattleUtil.FrameToTime)(battleFrame)
  return battleCurSecond
end

bs_209202.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_209202

