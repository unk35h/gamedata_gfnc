-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_100601 = class("bs_100601", LuaSkillBase)
local base = LuaSkillBase
bs_100601.config = {effectId_up = 100606, effectId_down = 100607, buffId_invisible = 3004}
bs_100601.ctor = function(self)
  -- function num : 0_0
end

bs_100601.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1
  self:AddSetHurtTrigger("bs_100601_2", 1, self.OnSetHurt, nil, self.caster)
end

bs_100601.OnSetHurt = function(self, context)
  -- function num : 0_2 , upvalues : _ENV
  if context.target == self.caster and self:IsReadyToTake() and context.hurt ~= 0 and (self.caster):GetBuffTier(1214) == 0 then
    context.hurt = context.hurt * (1000 - (self.arglist)[1]) // 1000
    if context.hurt < 0 then
      context.hurt = 0
    end
    local debuffs = LuaSkillCtrl:GetRoleBuffs(self.caster)
    if debuffs.Count > 0 then
      for i = 0, debuffs.Count - 1 do
        if (debuffs[i]).buffType == 2 then
          LuaSkillCtrl:DispelBuff(self.caster, (debuffs[i]).dataId, 0)
        end
      end
    end
    do
      local grid = nil
      if (context.sender).belongNum ~= (self.caster).belongNum and LuaSkillCtrl:GetRoleGridsDistance(self.caster, context.sender) == 1 then
        grid = self:findGrid(self.caster, context.sender)
      end
      LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_up, self)
      LuaSkillCtrl:CallBreakAllSkill(self.caster)
      if grid ~= nil then
        LuaSkillCtrl:SetRolePos(grid, self.caster)
      end
      LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_invisible, 1, (self.arglist)[2])
      LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_down, self)
      self:OnSkillTake()
    end
  end
end

bs_100601.findGrid = function(self, caster, sender)
  -- function num : 0_3 , upvalues : _ENV
  local grid = nil
  if caster.x ~= 0 then
    grid = LuaSkillCtrl:FindEmptyGrid(function(x, y)
    -- function num : 0_3_0 , upvalues : caster
    do return y == caster.y and x == caster.x - 1 end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
    if grid ~= nil then
      return grid
    end
  end
  if grid == nil and caster.x == 0 then
    grid = LuaSkillCtrl:FindEmptyGrid(function(x, y)
    -- function num : 0_3_1 , upvalues : caster
    do return x == caster.x and y == caster.y - 1 or y == caster.y + 1 end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
    return grid
  end
  if caster.y & 1 == 0 then
    grid = LuaSkillCtrl:FindEmptyGrid(function(x, y)
    -- function num : 0_3_2 , upvalues : caster
    do return x == caster.x - 1 and y == caster.y - 1 or y == caster.y + 1 end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
  else
    if caster.y & 1 == 1 then
      grid = LuaSkillCtrl:FindEmptyGrid(function(x, y)
    -- function num : 0_3_3 , upvalues : caster
    do return x == caster.x and y == caster.y - 1 or y == caster.y + 1 end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
    end
  end
  return grid
end

bs_100601.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_100601

