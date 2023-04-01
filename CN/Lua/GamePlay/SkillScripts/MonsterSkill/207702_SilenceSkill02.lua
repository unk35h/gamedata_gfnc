-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_207702 = class("bs_207702", LuaSkillBase)
local base = LuaSkillBase
bs_207702.config = {monsterId = 43, effectId1 = 207703, effectId2 = 207704, skill_time = 20, start_time = 12, actionId = 1002, action_speed = 1}
bs_207702.ctor = function(self)
  -- function num : 0_0
end

bs_207702.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self.moveTimer = LuaSkillCtrl:StartTimer(nil, (self.arglist)[1], self.DoSkill, self, -1)
end

bs_207702.DoSkill = function(self)
  -- function num : 0_2 , upvalues : _ENV
  self:CallCasterWait((self.config).skill_time)
  LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId, (self.config).action_speed)
  LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId1, self)
  LuaSkillCtrl:StartTimer(nil, (self.config).start_time, (BindCallback(self, self.Summon)), nil)
end

bs_207702.Summon = function(self)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:StartTimer(nil, 7, function()
    -- function num : 0_3_0 , upvalues : _ENV, self
    local Grid = LuaSkillCtrl:FindRoleRightEmptyGrid(self.caster, 10)
    if Grid == nil then
      Grid = LuaSkillCtrl:CallFindEmptyGridNearest(self.caster)
    end
    if Grid ~= nil then
      local target = LuaSkillCtrl:GetTargetWithGrid(Grid.x, Grid.y)
      LuaSkillCtrl:CallEffect(target, (self.config).effectId2, self)
      local summoner = LuaSkillCtrl:CreateSummoner(self, (self.config).monsterId, Grid.x, Grid.y)
      summoner:SetAttr(eHeroAttr.maxHp, (self.caster).maxHp * (self.arglist)[2] // 1000)
      summoner:SetAttr(eHeroAttr.skill_intensity, (self.caster).skill_intensity * (self.arglist)[3] // 1000)
      summoner:SetAttr(eHeroAttr.speed, (self.caster).speed)
      summoner:SetAttr(eHeroAttr.moveSpeed, (self.caster).moveSpeed)
      summoner:SetAttr(eHeroAttr.def, (self.caster).def)
      summoner:SetAttr(eHeroAttr.magic_res, (self.caster).magic_res)
      summoner:SetAttr(eHeroAttr.lucky, self.lucky)
      summoner:SetAsRealEntity(1)
      local arg1 = (self.arglist)[4]
      local arg2 = (self.arglist)[5]
      local arg3 = (self.arglist)[6]
      local tab = {arg_1 = arg1, arg_2 = arg2, arg_3 = arg3}
      summoner:SetRecordTable(tab)
      self.summonerEntity = LuaSkillCtrl:AddSummonerRole(summoner)
    end
  end
, nil)
end

bs_207702.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  if self.moveTimer ~= nil then
    (self.moveTimer):Stop()
    self.moveTimer = nil
  end
  ;
  (base.OnCasterDie)(self)
end

bs_207702.LuaDispose = function(self)
  -- function num : 0_5 , upvalues : base
  self.moveTimer = nil
  self.summonerEntity = nil
  ;
  (base.LuaDispose)(self)
end

return bs_207702

