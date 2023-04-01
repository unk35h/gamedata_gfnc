-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_60007 = class("bs_60007", LuaSkillBase)
local base = LuaSkillBase
bs_60007.config = {buffIds1 = 302901, buffIds2 = 302902, buffIdjx = 302903, buffIdjxR = 302904, effectId_Ult = 302905, effectId = 302907, buffIdjs1 = 302905, buffIdjs2 = 302906}
bs_60007.ctor = function(self)
  -- function num : 0_0
end

bs_60007.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self.MapBorder = LuaSkillCtrl:GetMapBorder()
  self:AddAfterAddBuffTrigger("bs_60007_7", 1, self.OnAfterAddBuff, self.caster, nil, nil, nil, (self.config).buffIds1)
  self.num1 = 0
  self.num2 = 0
  -- DECOMPILER ERROR at PC21: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).cando = 0
end

bs_60007.OnAfterAddBuff = function(self, buff, target)
  -- function num : 0_2 , upvalues : _ENV
  local num_sd = (self.arglist)[1]
  if buff.dataId == (self.config).buffIds1 then
    if target.belongNum == eBattleRoleBelong.player then
      self.num1 = self.num1 + 1
      LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffIdjs1, 1, 9999999)
    else
      if target.belongNum == eBattleRoleBelong.enemy then
        self.num2 = self.num2 + 1
        LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffIdjs2, 1, 9999999)
      end
    end
    if num_sd <= self.num1 and ((self.caster).recordTable).cando == 0 then
      LuaSkillCtrl:BreakCurrentAction(self.caster)
      LuaSkillCtrl:DispelBuff(self.caster, 302907)
      LuaSkillCtrl:RemoveLife((self.caster).maxHp * 10, self, self.caster, false, nil, false, true, 1, true)
      -- DECOMPILER ERROR at PC75: Confused about usage of register: R4 in 'UnsetPending'

      ;
      ((self.caster).recordTable).cando = 1
      LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId, self)
      local effectGrid = nil
      do
        if (self.MapBorder).x > 7 then
          effectGrid = LuaSkillCtrl:GetTargetWithGrid(5, 3)
        else
          effectGrid = LuaSkillCtrl:GetTargetWithGrid(3, 2)
        end
        LuaSkillCtrl:CallEffect(effectGrid, (self.config).effectId_Ult, self)
        local num_BF = (self.caster):GetBuffTier((self.config).buffIdjx)
        do
          local targetList = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.player)
          if targetList.Count > 0 then
            for i = 0, targetList.Count - 1 do
              LuaSkillCtrl:CallBuff(self, targetList[i], (self.config).buffIds2, 1, 9999999)
              LuaSkillCtrl:CallBuff(self, targetList[i], (self.config).buffIdjxR, num_BF, 9999999)
            end
          end
          do
            LuaSkillCtrl:StartTimer(nil, 30, function()
    -- function num : 0_2_0 , upvalues : _ENV, self, num_BF
    local targetList = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.player)
    if targetList.Count > 0 then
      for i = 0, targetList.Count - 1 do
        if (targetList[i]):GetBuffTier((self.config).buffIds2) == 0 then
          LuaSkillCtrl:CallBuff(self, targetList[i], (self.config).buffIds2, 1, 9999999)
          LuaSkillCtrl:CallBuff(self, targetList[i], (self.config).buffIdjxR, num_BF, 9999999)
        end
      end
    end
  end
, nil, -1)
          end
          if num_sd <= self.num2 and ((self.caster).recordTable).cando == 0 then
            LuaSkillCtrl:BreakCurrentAction(self.caster)
            LuaSkillCtrl:DispelBuff(self.caster, 302907)
            LuaSkillCtrl:RemoveLife((self.caster).maxHp * 10, self, self.caster, false, nil, false, true, 1, true)
            -- DECOMPILER ERROR at PC187: Confused about usage of register: R4 in 'UnsetPending'

            ;
            ((self.caster).recordTable).cando = 1
            LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId, self)
            local effectGrid = nil
            if (self.MapBorder).x > 7 then
              effectGrid = LuaSkillCtrl:GetTargetWithGrid(5, 3)
            else
              effectGrid = LuaSkillCtrl:GetTargetWithGrid(3, 2)
            end
            LuaSkillCtrl:CallEffect(effectGrid, (self.config).effectId_Ult, self)
            local num_BF = (self.caster):GetBuffTier((self.config).buffIdjx)
            local targetList = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.enemy)
            if targetList.Count > 0 then
              for i = 0, targetList.Count - 1 do
                LuaSkillCtrl:CallBuff(self, targetList[i], (self.config).buffIds2, 1, 9999999)
                LuaSkillCtrl:CallBuff(self, targetList[i], (self.config).buffIdjxR, num_BF, 9999999)
              end
            end
            do
              LuaSkillCtrl:StartTimer(nil, 30, function()
    -- function num : 0_2_1 , upvalues : _ENV, self, num_BF
    local targetList = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.enemy)
    if targetList.Count > 0 then
      for i = 0, targetList.Count - 1 do
        if (targetList[i]):GetBuffTier((self.config).buffIds2) == 0 then
          LuaSkillCtrl:CallBuff(self, targetList[i], (self.config).buffIds2, 1, 9999999)
          LuaSkillCtrl:CallBuff(self, targetList[i], (self.config).buffIdjxR, num_BF, 9999999)
        end
      end
    end
  end
, nil, -1)
            end
          end
        end
      end
    end
  end
end

bs_60007.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_60007

