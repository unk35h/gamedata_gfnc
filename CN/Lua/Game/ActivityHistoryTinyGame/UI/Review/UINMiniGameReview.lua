-- params : ...
-- function num : 0 , upvalues : _ENV
local UINMiniGameReview = class("UINMiniGameReview", UIBaseNode)
local base = UIBaseNode
local UINCommonPlotReviewCharpt = require("Game.CommonUI.PlotReview.UINCommonPlotReviewCharpt")
local UINCommonPlotReviewLockCharpt = require("Game.CommonUI.PlotReview.UINCommonPlotReviewLockCharpt")
UINMiniGameReview.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINCommonPlotReviewCharpt, UINCommonPlotReviewLockCharpt
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.unlockedCharptPool = (UIItemPool.New)(UINCommonPlotReviewCharpt, (self.ui).obj_plotGroup)
  ;
  ((self.ui).obj_plotGroup):SetActive(false)
  self.lockedCharptPool = (UIItemPool.New)(UINCommonPlotReviewLockCharpt, (self.ui).obj_btn_DropDown)
  ;
  ((self.ui).obj_btn_DropDown):SetActive(false)
  self.__AvgPlayedCallBack = BindCallback(self, self.RefreshMGRAVGList)
  MsgCenter:AddListener(eMsgEventId.AVGLogicPlayed, self.__AvgPlayedCallBack)
end

UINMiniGameReview.InitMiniGameReview = function(self, actTinyData)
  -- function num : 0_1
  self.actTinyData = actTinyData
  self:RefreshMGRAVGList()
end

UINMiniGameReview.OnShow = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnShow)(self)
  if self.actTinyData ~= nil then
    self:RefreshMGRAVGList()
  end
end

UINMiniGameReview.RefreshMGRAVGList = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local CPRData = (self.actTinyData):GetHTGAVGReviewData()
  ;
  (self.unlockedCharptPool):HideAll()
  ;
  (self.lockedCharptPool):HideAll()
  for index,AvgGroupData in ipairs(CPRData:GetCPRAvgGroupList()) do
    local isUnlock = AvgGroupData:GetAvgGroupIsUnlock()
    if isUnlock then
      local item = (self.unlockedCharptPool):GetOne()
      item:InitPlotReviewCharpt(AvgGroupData)
    else
      do
        do
          local item = (self.lockedCharptPool):GetOne()
          item:InitLockedCPRCharpt(AvgGroupData)
          -- DECOMPILER ERROR at PC31: LeaveBlock: unexpected jumping out DO_STMT

          -- DECOMPILER ERROR at PC31: LeaveBlock: unexpected jumping out IF_ELSE_STMT

          -- DECOMPILER ERROR at PC31: LeaveBlock: unexpected jumping out IF_STMT

        end
      end
    end
  end
  local totalCount, unLockCount = CPRData:GetCPRAvgGroupUnlockNum()
  ;
  ((self.ui).tex_IsUnlock):SetIndex(0, tostring(unLockCount), tostring(totalCount))
end

UINMiniGameReview.OnDelete = function(self)
  -- function num : 0_4 , upvalues : base, _ENV
  (base.OnDelete)(self)
  MsgCenter:RemoveListener(eMsgEventId.AVGLogicPlayed, self.__AvgPlayedCallBack)
end

return UINMiniGameReview

