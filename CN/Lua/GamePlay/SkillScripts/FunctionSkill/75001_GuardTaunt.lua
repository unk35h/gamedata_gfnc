-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_75001 = class("bs_75001", LuaSkillBase)
local base = LuaSkillBase
bs_75001.config = {buffId = 3002, buffTier = 1, a = 0}
bs_75001.ctor = function(self)
  -- function num : 0_0
end

bs_75001.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_75001_1", 1, self.OnAfterHurt)
end

bs_75001.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if target.intensity == 99 and target.hp < target.maxHp * (self.arglist)[1] // 1000 and (self.config).a == 0 then
    local targetListMax = LuaSkillCtrl:CallTargetSelect(self, 76, 10)
    if targetListMax.Count > 0 then
      for i = 0, targetListMax.Count - 1 do
        if ((targetListMax[i]).targetRole).intensity ~= 99 then
          self.highHpTarget = (targetListMax[0]).targetRole
          break
        else
          i = i + 1
        end
      end
      do
        local targetListEnemy = LuaSkillCtrl:CallTargetSelect(self, 9, 10)
        for i = 0, targetListEnemy.Count - 1 do
          LuaSkillCtrl:CallBuff(self, (targetListEnemy[i]).targetRole, (self.config).buffId, 1, (self.arglist)[2])
        end
      end
    end
  end
end

bs_75001.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

bs_75001.LuaDispose = function(self)
  -- function num : 0_4 , upvalues : base
  (base.LuaDispose)(self)
end

return bs_75001

