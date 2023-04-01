-- params : ...
-- function num : 0 , upvalues : _ENV
local UINLvChallengeTaskItem = class("UINLvChallengeTaskItem", UIBaseNode)
local base = UIBaseNode
UINLvChallengeTaskItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINLvChallengeTaskItem.InitLvChallengeTaskItem = function(self, taskCfg, isComplete)
  -- function num : 0_1 , upvalues : _ENV
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ((self.ui).tex_Desc).text = (LanguageUtil.GetLocaleText)(taskCfg.name)
  ;
  ((self.ui).img_Complete):SetIndex(isComplete and 0 or 1)
  if (self.ui).obj_IsComplete ~= nil then
    ((self.ui).obj_IsComplete):SetActive(isComplete)
  end
  if (self.ui).obj_reward ~= nil then
    if not isComplete and #taskCfg.rewardIds > 0 then
      ((self.ui).obj_reward):SetActive(true)
    else
      ;
      ((self.ui).obj_reward):SetActive(false)
    end
  end
end

UINLvChallengeTaskItem.OnDelete = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnDelete)(self)
end

return UINLvChallengeTaskItem

