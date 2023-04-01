-- params : ...
-- function num : 0 , upvalues : _ENV
local UINCommonPlotReviewCharpt = class("UINCommonPlotReviewCharpt", UIBaseNode)
local base = UIBaseNode
local UINCommonPlotReviewAvg = require("Game.CommonUI.PlotReview.UINCommonPlotReviewAvg")
local vector3One_ReverseY = (Vector3.New)(1, -1, 1)
UINCommonPlotReviewCharpt.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINCommonPlotReviewAvg
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_DropDown, self, self.OnClickSwitch)
  self._avgPool = (UIItemPool.New)(UINCommonPlotReviewAvg, (self.ui).plotItem)
  ;
  ((self.ui).plotItem):SetActive(false)
  self.__RefreshBlueDot = BindCallback(self, self.__RefreshBlueDot)
end

UINCommonPlotReviewCharpt.InitPlotReviewCharpt = function(self, AvgGroupData)
  -- function num : 0_1 , upvalues : _ENV
  self.AvgGroupData = AvgGroupData
  local groupENName, groupName, groupDes = AvgGroupData:GetAvgGroupName()
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_EN).text = groupENName
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_Type).text = groupName
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_Desc).text = groupDes
  ;
  (self._avgPool):HideAll()
  for _,avgId in ipairs(AvgGroupData:GetAvgGroupAvgIdList()) do
    local item = (self._avgPool):GetOne()
    item:InitHeroPlotReviewAvg(avgId, AvgGroupData, self.__RefreshBlueDot)
  end
  ;
  ((self.ui).dropDown):SetActive(false)
  self:__RefreshBlueDot()
  -- DECOMPILER ERROR at PC42: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (((self.ui).img_Tri).transform).localScale = Vector3.one
end

UINCommonPlotReviewCharpt.OnClickSwitch = function(self)
  -- function num : 0_2 , upvalues : vector3One_ReverseY, _ENV
  local active = not ((self.ui).dropDown).activeSelf
  ;
  ((self.ui).dropDown):SetActive(active)
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R2 in 'UnsetPending'

  if active then
    (((self.ui).img_Tri).transform).localScale = vector3One_ReverseY
  else
    -- DECOMPILER ERROR at PC22: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (((self.ui).img_Tri).transform).localScale = Vector3.one
  end
  if active and ((self.ui).blueDot).activeSelf then
    local unfoldCallback = (self.AvgGroupData):GetAvgGroupDataUnfoldCallback()
    if unfoldCallback ~= nil then
      unfoldCallback()
    end
    self:__RefreshBlueDot()
  end
end

UINCommonPlotReviewCharpt.SetAvgJustClientPlay = function(self)
  -- function num : 0_3 , upvalues : _ENV
  for i,v in ipairs((self._avgPool).listItem) do
    v:SetAvgJustClientPlay()
  end
end

UINCommonPlotReviewCharpt.__RefreshBlueDot = function(self)
  -- function num : 0_4 , upvalues : _ENV
  if IsNull((self.ui).blueDot) then
    return 
  end
  ;
  ((self.ui).blueDot):SetActive((self.AvgGroupData):IsAvgGroupDataCouldBlueDot())
end

return UINCommonPlotReviewCharpt

