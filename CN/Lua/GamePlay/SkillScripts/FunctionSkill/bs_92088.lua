-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_92088 = class("bs_92088", LuaSkillBase)
local base = LuaSkillBase
bs_92088.config = {}
bs_92088.ctor = function(self)
  -- function num : 0_0
end

bs_92088.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSetDeadHurtTrigger("bs_92088_1", 900, self.OnSetDeadHurt, nil, nil, nil, eBattleRoleBelong.enemy)
  self.killer = nil
end

bs_92088.OnSetDeadHurt = function(self, context)
  -- function num : 0_2 , upvalues : _ENV
  if (context.target).belongNum == eBattleRoleBelong.enemy and context.sender == self.caster then
    local buffs = LuaSkillCtrl:GetRoleBuffs(context.target)
    self.killer = context.sender
    self:DebuffSpread(context.target, buffs)
  end
end

bs_92088.DebuffSpread = function(self, target, buffs)
  -- function num : 0_3 , upvalues : _ENV
  local targetList = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.enemy)
  local addBuff = buffs
  for i = 0, targetList.Count - 1 do
    if not ((targetList[i]).recordTable).equipSummoner then
      do
        self:AddDebuff(targetList[i], addBuff)
        -- DECOMPILER ERROR at PC20: LeaveBlock: unexpected jumping out IF_THEN_STMT

        -- DECOMPILER ERROR at PC20: LeaveBlock: unexpected jumping out IF_STMT

      end
    end
  end
end

bs_92088.AddDebuff = function(self, target, buffs)
  -- function num : 0_4 , upvalues : _ENV
  if target == nil or target.hp <= 0 then
    return 
  end
  if buffs == nil or buffs.Count < 1 then
    return 
  end
  for i = 0, buffs.Count - 1 do
    if (buffs[i]).buffType == 2 then
      local skill = (buffs[i]).battleSkill
      local sender = (buffs[i]).maker
      local buffID = (buffs[i]).dataId
      local tier = (buffs[i]).tier
      local decade = (buffs[i]).totalTime
      if buffID == (self.config).buffId_taunt2 or buffID == (self.config).buffId_taunt then
        local setBuff = LuaSkillCtrl:CallBuff(self, target, buffID, tier, decade, false, sender)
      else
        do
          do
            local setBuff = LuaSkillCtrl:CallBuffWithOriginSkill(skill, target, buffID, tier, decade, false, self.killer)
            -- DECOMPILER ERROR at PC60: LeaveBlock: unexpected jumping out DO_STMT

            -- DECOMPILER ERROR at PC60: LeaveBlock: unexpected jumping out IF_ELSE_STMT

            -- DECOMPILER ERROR at PC60: LeaveBlock: unexpected jumping out IF_STMT

            -- DECOMPILER ERROR at PC60: LeaveBlock: unexpected jumping out IF_THEN_STMT

            -- DECOMPILER ERROR at PC60: LeaveBlock: unexpected jumping out IF_STMT

          end
        end
      end
    end
  end
end

bs_92088.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_92088

