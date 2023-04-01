-- params : ...
-- function num : 0 , upvalues : _ENV
local UINSectorActivityEntry = class("UINSectorActivityEntry", UIBaseNode)
local base = UIBaseNode
UINSectorActivityEntry.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Activity, self, self.OnSectorActivityClick)
end

UINSectorActivityEntry.RefreshSectorActivity = function(self, cfg, actFrameData, resloader, clickCallback)
  -- function num : 0_1 , upvalues : _ENV
  if self.__onActivityReddot ~= nil then
    RedDotController:RemoveListener((self.actNode).nodePath, self.__onActivityReddot)
    self.__onActivityReddot = nil
    self.actNode = nil
  end
  self._cfg = cfg
  if (self._cfg).red_dot ~= 1 or not (self.ui).obj_redDot then
    self._dotObj = (self.ui).blueDot
    self._clickCallback = clickCallback
    local imgPath = PathConsts:GetResImagePath("Activity/" .. (self._cfg).image_entrance .. ".png")
    -- DECOMPILER ERROR at PC37: Confused about usage of register: R6 in 'UnsetPending'

    ;
    ((self.ui).img_Activity).texture = resloader:LoadABAsset(imgPath)
    self.actNode = actFrameData:GetActivityReddotNode()
    self._actFrameData = actFrameData
    if self.actNode == nil then
      ((self.ui).obj_redDot):SetActive(false)
      ;
      ((self.ui).blueDot):SetActive(false)
      return 
    end
    self.__onActivityReddot = function(node)
    -- function num : 0_1_0 , upvalues : self
    local activityBaseData = (self._actFrameData):GetActivityData()
    if node:GetRedDotCount() <= 0 then
      (self._dotObj):SetActive(activityBaseData ~= nil)
      do return  end
      local isBlue, num = activityBaseData:GetActivityReddotNum()
      ;
      ((self.ui).obj_redDot):SetActive(not isBlue and num > 0)
      ;
      ((self.ui).blueDot):SetActive(not isBlue or num > 0)
      -- DECOMPILER ERROR: 6 unprocessed JMP targets
    end
  end

    RedDotController:AddListener((self.actNode).nodePath, self.__onActivityReddot)
    ;
    (self.__onActivityReddot)(self.actNode)
  end
end

UINSectorActivityEntry.RefreshNoActivityBanner = function(self, cfg, resloader, clickCallback)
  -- function num : 0_2 , upvalues : _ENV
  self._cfg = cfg
  self._clickCallback = clickCallback
  local imgPath = PathConsts:GetImagePath("Activity/" .. (self._cfg).image_entrance)
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).img_Activity).texture = resloader:LoadABAsset(imgPath)
  ;
  ((self.ui).obj_redDot):SetActive(false)
  ;
  ((self.ui).blueDot):SetActive(false)
end

UINSectorActivityEntry.OnSectorActivityClick = function(self)
  -- function num : 0_3
  if self._clickCallback ~= nil then
    (self._clickCallback)(self._cfg)
  end
end

UINSectorActivityEntry.OnHide = function(self)
  -- function num : 0_4 , upvalues : _ENV, base
  if self.__onActivityReddot ~= nil then
    RedDotController:RemoveListener((self.actNode).nodePath, self.__onActivityReddot)
    self.__onActivityReddot = nil
  end
  ;
  (base.OnHide)(self)
end

UINSectorActivityEntry.OnDelete = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnDelete)(self)
end

return UINSectorActivityEntry

