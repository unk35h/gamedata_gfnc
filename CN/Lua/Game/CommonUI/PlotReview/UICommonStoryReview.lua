-- params : ...
-- function num : 0 , upvalues : _ENV
local UICommonStoryReview = class("UICommonStoryReview", UIBaseWindow)
local base = UIBaseWindow
local UINCommonPlotReviewCharpt = require("Game.CommonUI.PlotReview.UINCommonPlotReviewCharpt")
local UINCommonPlotReviewLockCharpt = require("Game.CommonUI.PlotReview.UINCommonPlotReviewLockCharpt")
UICommonStoryReview.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINCommonPlotReviewCharpt, UINCommonPlotReviewLockCharpt
  (UIUtil.SetTopStatus)(self, self.OnClickCloseReview)
  self.unlockedCharptPool = (UIItemPool.New)(UINCommonPlotReviewCharpt, (self.ui).plotGroup)
  ;
  ((self.ui).plotGroup):SetActive(false)
  self.lockedCharptPool = (UIItemPool.New)(UINCommonPlotReviewLockCharpt, (self.ui).btn_DropDown)
  ;
  ((self.ui).btn_DropDown):SetActive(false)
end

UICommonStoryReview.InitStoryReview = function(self, CPRData, callback)
  -- function num : 0_1
  self._callback = callback
  self.CPRData = CPRData
  self:__RefreshTitleName()
  self:RefreshHeroPlotReview()
end

UICommonStoryReview.SetStoryAvgJustClientPlay = function(self)
  -- function num : 0_2 , upvalues : _ENV
  for i,v in ipairs((self.unlockedCharptPool).listItem) do
    v:SetAvgJustClientPlay()
  end
end

UICommonStoryReview.__RefreshTitleName = function(self)
  -- function num : 0_3
  local titleName = (self.CPRData):GetCPRTitleName()
  if titleName ~= nil then
    ((self.ui).tex_title):SetIndex(1, titleName)
  else
    ;
    ((self.ui).tex_title):SetIndex(0)
  end
end

UICommonStoryReview.RefreshHeroPlotReview = function(self)
  -- function num : 0_4 , upvalues : _ENV
  (self.unlockedCharptPool):HideAll()
  ;
  (self.lockedCharptPool):HideAll()
  for index,AvgGroupData in ipairs((self.CPRData):GetCPRAvgGroupList()) do
    local isUnlock = AvgGroupData:GetAvgGroupIsUnlock()
    if isUnlock then
      local item = (self.unlockedCharptPool):GetOne()
      item:InitPlotReviewCharpt(AvgGroupData)
    else
      do
        do
          local item = (self.lockedCharptPool):GetOne()
          item:InitLockedCPRCharpt(AvgGroupData)
          -- DECOMPILER ERROR at PC29: LeaveBlock: unexpected jumping out DO_STMT

          -- DECOMPILER ERROR at PC29: LeaveBlock: unexpected jumping out IF_ELSE_STMT

          -- DECOMPILER ERROR at PC29: LeaveBlock: unexpected jumping out IF_STMT

        end
      end
    end
  end
  local totalCount, unLockCount = (self.CPRData):GetCPRAvgGroupUnlockNum()
  ;
  ((self.ui).tex_IsUnlock):SetIndex(0, tostring(unLockCount), tostring(totalCount))
end

UICommonStoryReview.OnClickCloseReview = function(self)
  -- function num : 0_5
  self:Delete()
  if self._callback ~= nil then
    (self._callback)()
  end
end

return UICommonStoryReview

