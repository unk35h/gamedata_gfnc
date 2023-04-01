-- params : ...
-- function num : 0 , upvalues : _ENV
local UICommonPlotReview = class("UICommonPlotReview", UIBaseWindow)
local base = UIBaseWindow
local UINCommonPlotReviewCharpt = require("Game.CommonUI.PlotReview.UINCommonPlotReviewCharpt")
local UINCommonPlotReviewLockCharpt = require("Game.CommonUI.PlotReview.UINCommonPlotReviewLockCharpt")
UICommonPlotReview.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINCommonPlotReviewCharpt, UINCommonPlotReviewLockCharpt
  (UIUtil.SetTopStatus)(self, self.OnClickCloseReview)
  self.unlockedCharptPool = (UIItemPool.New)(UINCommonPlotReviewCharpt, (self.ui).plotGroup)
  ;
  ((self.ui).plotGroup):SetActive(false)
  self.lockedCharptPool = (UIItemPool.New)(UINCommonPlotReviewLockCharpt, (self.ui).btn_DropDown)
  ;
  ((self.ui).btn_DropDown):SetActive(false)
end

UICommonPlotReview.InitCommonPlotReview = function(self, CPRData, callback)
  -- function num : 0_1
  self._callback = callback
  self.CPRData = CPRData
  do
    if (self.CPRData):GetCPRBgIsAllScreen() then
      local rawImgTr = ((self.ui).hero_RawImage).transform
      rawImgTr.position = (self.transform).position
      rawImgTr.sizeDelta = ((self.transform).rect).size
    end
    self:__RefreshTitleName()
    self:__LoadBg()
    self:RefreshHeroPlotReview()
  end
end

UICommonPlotReview.SetPlotAvgJustClientPlay = function(self)
  -- function num : 0_2 , upvalues : _ENV
  for i,v in ipairs((self.unlockedCharptPool).listItem) do
    v:SetAvgJustClientPlay()
  end
end

UICommonPlotReview.__RefreshTitleName = function(self)
  -- function num : 0_3
  local titleName = (self.CPRData):GetCPRTitleName()
  if titleName ~= nil then
    ((self.ui).tex_title):SetIndex(1, titleName)
  else
    ;
    ((self.ui).tex_title):SetIndex(0)
  end
end

UICommonPlotReview.__LoadBg = function(self)
  -- function num : 0_4 , upvalues : _ENV
  if self.bigImgResloader ~= nil then
    (self.bigImgResloader):Put2Pool()
    self.bigImgResloader = nil
  end
  self.bigImgResloader = ((CS.ResLoader).Create)()
  local bgResName, isHeroSkin = (self.CPRData):GetCPRBgResName()
  ;
  (((self.ui).hero_RawImage).gameObject):SetActive(false)
  if isHeroSkin then
    local path = PathConsts:GetCharacterBigImgPrefabPath(bgResName)
    ;
    (self.bigImgResloader):LoadABAssetAsync(path, function(prefab)
    -- function num : 0_4_0 , upvalues : _ENV, self
    if IsNull(prefab) or IsNull(self.transform) then
      return 
    end
    self.bigImgGameObject = prefab:Instantiate(((self.ui).heroHolder).transform)
    local commonPicCtrl = (self.bigImgGameObject):FindComponent(eUnityComponentID.CommonPicController)
    commonPicCtrl:SetPosType("HeroSkin")
  end
)
  else
    do
      if bgResName == nil then
        bgResName = "Res/Images/SectorLevel/ActSum21_0.png"
      end
      ;
      (self.bigImgResloader):LoadABAssetAsync(bgResName, function(texture)
    -- function num : 0_4_1 , upvalues : _ENV, self
    if IsNull(texture) or IsNull(self.transform) then
      return 
    end
    ;
    (((self.ui).hero_RawImage).gameObject):SetActive(true)
    -- DECOMPILER ERROR at PC19: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).hero_RawImage).texture = texture
  end
)
    end
  end
end

UICommonPlotReview.RefreshHeroPlotReview = function(self)
  -- function num : 0_5 , upvalues : _ENV
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
  -- DECOMPILER ERROR at PC44: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_IsUnlock).text = tostring(unLockCount) .. "/" .. tostring(totalCount)
end

UICommonPlotReview.OnClickCloseReview = function(self)
  -- function num : 0_6
  self:Delete()
  if self._callback ~= nil then
    (self._callback)()
  end
end

UICommonPlotReview.OnDelete = function(self)
  -- function num : 0_7 , upvalues : base
  if self.bigImgResloader ~= nil then
    (self.bigImgResloader):Put2Pool()
    self.bigImgResloader = nil
  end
  ;
  (base.OnDelete)(self)
end

return UICommonPlotReview

