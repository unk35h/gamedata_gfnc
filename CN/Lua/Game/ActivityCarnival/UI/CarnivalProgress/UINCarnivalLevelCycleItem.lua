-- params : ...
-- function num : 0 , upvalues : _ENV
local UINCarnivalLevelCycleItem = class("Game.ActivityCarnival.UI.CarnivalProgress.UINCarnivalLevelCycleItem", UIBaseNode)
local base = UIBaseNode
UINCarnivalLevelCycleItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).image, self, self.OnClickReward)
end

UINCarnivalLevelCycleItem.InitCarnivalLevelCycleItem = function(self, carnivalData, pickRewardFunc)
  -- function num : 0_1 , upvalues : _ENV
  self._pickRewardFunc = pickRewardFunc
  local mainCfg = carnivalData:GetCarnivalMainCfg()
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Des).text = ConfigData:GetTipContent(mainCfg.cir_reward_tip)
  local expCfgs = carnivalData:GetCarnivalExpCfg()
  local unit = (expCfgs[#expCfgs]).need_exp
  local curlevel, exp = carnivalData:GetCarnivalLevelExp()
  local maxLevel = carnivalData:GetCarnivalMaxLevel()
  -- DECOMPILER ERROR at PC23: Confused about usage of register: R9 in 'UnsetPending'

  if curlevel < maxLevel then
    ((self.ui).canvasGroup).alpha = 0.5
    -- DECOMPILER ERROR at PC26: Confused about usage of register: R9 in 'UnsetPending'

    ;
    ((self.ui).tex_Num).text = "0"
    -- DECOMPILER ERROR at PC29: Confused about usage of register: R9 in 'UnsetPending'

    ;
    ((self.ui).img_ExpProgress).fillAmount = 0
    ;
    ((self.ui).tex_ExpProgress):SetIndex(0, "0", tostring(unit))
    return 
  end
  -- DECOMPILER ERROR at PC42: Confused about usage of register: R9 in 'UnsetPending'

  ;
  ((self.ui).canvasGroup).alpha = 1
  local rewardCount = exp // unit
  local remainExp = exp % unit
  -- DECOMPILER ERROR at PC50: Confused about usage of register: R11 in 'UnsetPending'

  ;
  ((self.ui).tex_Num).text = tostring(rewardCount)
  -- DECOMPILER ERROR at PC54: Confused about usage of register: R11 in 'UnsetPending'

  ;
  ((self.ui).img_ExpProgress).fillAmount = remainExp / unit
  ;
  ((self.ui).tex_ExpProgress):SetIndex(0, tostring(remainExp), tostring(unit))
end

UINCarnivalLevelCycleItem.OnClickReward = function(self)
  -- function num : 0_2
  if self._pickRewardFunc ~= nil then
    (self._pickRewardFunc)()
  end
end

return UINCarnivalLevelCycleItem

