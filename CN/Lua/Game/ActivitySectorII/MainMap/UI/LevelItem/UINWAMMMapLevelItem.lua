-- params : ...
-- function num : 0 , upvalues : _ENV
local UINWAMMMapLevelItem = class("UINWAMMMapLevelItem", UIBaseNode)
local base = UIBaseNode
UINWAMMMapLevelItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self.levelData = nil
  self.pointItem = nil
  ;
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_baseItem, self, self.OnClickLevelItem)
end

UINWAMMMapLevelItem.InitLevelItem = function(self, sectorIIData, levelData, resloader, clickEvent)
  -- function num : 0_1
  self.sectorIIData = sectorIIData
  self.levelData = levelData
  self.resloader = resloader
  self.clickEvent = clickEvent
  self.parentLines = {}
  self:__RefreshEpAndAvg()
  self:__RefreshPos()
  self:__RefreshIsUnlock()
  self:__RefreshIsClear()
  self:RefreshRedOrBlueDot()
  self:__RefreshChallengeTask()
end

UINWAMMMapLevelItem.RefreshSIILevel = function(self)
  -- function num : 0_2
  self:__RefreshEpAndAvg()
  self:__RefreshPos()
  self:__RefreshIsUnlock()
  self:__RefreshIsClear()
  self:RefreshRedOrBlueDot()
  self:__RefreshChallengeTask()
end

UINWAMMMapLevelItem.__RefreshPos = function(self)
  -- function num : 0_3
  -- DECOMPILER ERROR at PC4: Confused about usage of register: R1 in 'UnsetPending'

  (self.transform).anchoredPosition = (self.levelData):GetIsLevelPos()
end

UINWAMMMapLevelItem.__RefreshEpAndAvg = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local isEp = (self.levelData):GetIsBattle()
  if isEp then
    ((self.ui).img_Buttom_Info):SetIndex(0)
    -- DECOMPILER ERROR at PC14: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).img_Icon).color = (self.ui).color_orange
  else
    ;
    ((self.ui).img_Buttom_Info):SetIndex(1)
    -- DECOMPILER ERROR at PC25: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).img_Icon).color = (self.ui).color_blue
  end
  local iconName = (self.levelData):GetSectroIILevelIconName()
  if not (string.IsNullOrEmpty)(iconName) then
    (self.resloader):LoadABAssetAsync(PathConsts:GetAtlasAssetPath("SectorLevelIcon"), function(spriteAtlas)
    -- function num : 0_4_0 , upvalues : _ENV, iconName, self
    if spriteAtlas == nil then
      return 
    end
    local stageIcon = (AtlasUtil.GetResldSprite)(spriteAtlas, iconName)
    -- DECOMPILER ERROR at PC10: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).img_Icon).sprite = stageIcon
  end
)
  end
end

UINWAMMMapLevelItem.__RefreshIsClear = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local isClear = (self.levelData):GetIsLevelClaer()
  local isHard = (self.levelData):GetSectroIILevelIsHard()
  ;
  ((self.ui).obj_complete):SetActive(isClear)
  -- DECOMPILER ERROR at PC19: Confused about usage of register: R3 in 'UnsetPending'

  if not isClear then
    if isHard then
      ((self.ui).img_Icon).color = (self.ui).color_red
      ;
      ((self.ui).img_Buttom_Info):SetIndex(3)
    else
      -- DECOMPILER ERROR at PC30: Confused about usage of register: R3 in 'UnsetPending'

      ;
      ((self.ui).img_Icon).color = Color.white
      ;
      ((self.ui).img_Buttom_Info):SetIndex(2)
    end
  end
  if self.pointItem ~= nil then
    (self.pointItem):SetArrowSprites(isClear, isHard)
  end
end

UINWAMMMapLevelItem.__RefreshIsUnlock = function(self)
  -- function num : 0_6
end

UINWAMMMapLevelItem.__RefreshChallengeTask = function(self)
  -- function num : 0_7
  if ((self.ui).obj_challenge).activeSelf then
    ((self.ui).obj_challenge):SetActive(false)
  end
  self.hasChallenge = (self.levelData):HasSectorIILevelChallengeTask()
  if not self.hasChallenge then
    return 
  end
  local totalNum, passedNum = (self.levelData):GetSectorIILevelChallengeTaskNum()
  if totalNum == nil or passedNum == nil then
    return 
  end
  self.totalNum = totalNum
  self.passedNum = passedNum
  ;
  ((self.ui).obj_challenge):SetActive(true)
  local size = ((self.ui).rect_challengeBg).sizeDelta
  size.x = 40 * totalNum
  -- DECOMPILER ERROR at PC40: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).rect_challengeBg).sizeDelta = size
  size = ((self.ui).rect_ChallengeCur).sizeDelta
  size.x = 40 * passedNum
  -- DECOMPILER ERROR at PC48: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).rect_ChallengeCur).sizeDelta = size
end

UINWAMMMapLevelItem.RefreshRedOrBlueDot = function(self)
  -- function num : 0_8
  if (self.levelData):GetIsBattle() then
    ((self.ui).obj_blueDot):SetActive(false)
    return 
  end
  if (self.sectorIIData):IsActivityRunning() and (self.levelData):GetIsLevelUnlock() and not (self.levelData):GetIsLevelClaer() then
    ((self.ui).obj_blueDot):SetActive(true)
  else
    ;
    ((self.ui).obj_blueDot):SetActive(false)
  end
end

UINWAMMMapLevelItem.AddLine2SectorIILevel = function(self, lineItem)
  -- function num : 0_9 , upvalues : _ENV
  (table.insert)(self.parentLines, lineItem)
end

UINWAMMMapLevelItem.SetPointItem2Level = function(self, pointItem)
  -- function num : 0_10 , upvalues : _ENV
  (pointItem.transform):SetParent(((self.ui).obj_pointHolder).transform)
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (pointItem.transform).anchoredPosition = Vector2.zero
  self.pointItem = pointItem
end

UINWAMMMapLevelItem.SetcurItem2Level = function(self, curItem)
  -- function num : 0_11 , upvalues : _ENV
  (curItem.transform):SetParent(((self.ui).obj_curLevelHolder).transform)
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (curItem.transform).anchoredPosition = Vector2.zero
  ;
  (curItem.gameObject):SetActive(true)
  self.curItem = curItem
end

UINWAMMMapLevelItem.SelectWALevel = function(self, selectItem)
  -- function num : 0_12 , upvalues : _ENV
  local isBattle = (self.levelData):GetIsBattle()
  selectItem:InitSelectItem(self.levelData)
  ;
  (selectItem.transform):SetParent(((self.ui).obj_pointHolder).transform)
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (selectItem.transform).anchoredPosition = Vector2.zero
  ;
  (selectItem.gameObject):SetActive(true)
  selectItem:PlayOnSelectTween(isBattle)
  if isBattle then
    ((self.ui).tween_baseItem):DOPlayForward()
  end
  if self.pointItem ~= nil then
    (self.pointItem):PlayOnSelectTween(isBattle)
  end
  if self.curItem ~= nil then
    ((self.curItem).gameObject):SetActive(false)
  end
  selectItem:RefreshSelectItemChallenge(self.hasChallenge, self.totalNum, self.passedNum)
  if self.hasChallenge then
    ((self.ui).obj_challenge):SetActive(false)
  end
end

UINWAMMMapLevelItem.CancleSelectWALevel = function(self, selectItem)
  -- function num : 0_13
  local isBattle = (self.levelData):GetIsBattle()
  ;
  (selectItem.gameObject):SetActive(false)
  selectItem:PlayOnCancleSelectTween()
  if isBattle then
    ((self.ui).tween_baseItem):DOPlayBackwards()
  end
  if self.pointItem ~= nil then
    (self.pointItem):PlayOnCancleSelectTween()
  end
  if self.curItem ~= nil then
    ((self.curItem).gameObject):SetActive(true)
  end
  if self.hasChallenge then
    ((self.ui).obj_challenge):SetActive(true)
  end
end

UINWAMMMapLevelItem.OnClickLevelItem = function(self)
  -- function num : 0_14
  (self.transform):SetAsLastSibling()
  if self.clickEvent ~= nil then
    (self.clickEvent)(self, self.levelData)
  end
end

UINWAMMMapLevelItem.TryChangeLine2DotedLine = function(self)
  -- function num : 0_15 , upvalues : _ENV
  if (self.levelData):GetIsLevelClaer() then
    return 
  end
  for _,line in pairs(self.parentLines) do
    line:SwitchLine2DottedLine()
  end
end

UINWAMMMapLevelItem.GetComplete = function(self)
  -- function num : 0_16
  return ((self.ui).obj_complete).transform
end

UINWAMMMapLevelItem.OnDelete = function(self)
  -- function num : 0_17 , upvalues : base
  (base.OnDelete)(self)
end

return UINWAMMMapLevelItem

