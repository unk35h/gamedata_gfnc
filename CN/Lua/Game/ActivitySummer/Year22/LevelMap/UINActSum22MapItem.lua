-- params : ...
-- function num : 0 , upvalues : _ENV
local UINActSum22MapItem = class("UINActSum22MapItem", UIBaseNode)
local base = UIBaseNode
UINActSum22MapItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).baseItem, self, self.OnClickSelected)
  self._starDefaultWidth = (((self.ui).challenge).rect).width
end

UINActSum22MapItem.InitSum22MapItem = function(self, sectorLevelData, index, callback)
  -- function num : 0_1
  self._sectorLevelData = sectorLevelData
  self._callback = callback
  if (self._sectorLevelData):GetIsBattle() then
    self:__RefreshSectorStage()
  else
    self:__RefreshSectorAvg()
  end
  self:RefreshSum22MapItemCompleteState()
  self:SetSum22MapItemSelectState(false)
end

UINActSum22MapItem.__RefreshSectorStage = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local isSideStage = (self._sectorLevelData):GetSectroIILevelIsSide()
  local isHardStage = (self._sectorLevelData):GetSectroIILevelIsHard()
  if isSideStage then
    ((self.ui).img_Buttom):SetIndex(3)
    ;
    ((self.ui).img_Icon):SetIndex(3)
    ;
    ((self.ui).img_Dis):SetIndex(3)
  else
    if isHardStage then
      ((self.ui).img_Buttom):SetIndex(2)
      ;
      ((self.ui).img_Icon):SetIndex(2)
      ;
      ((self.ui).img_Dis):SetIndex(2)
    else
      ;
      ((self.ui).img_Buttom):SetIndex(0)
      ;
      ((self.ui).img_Icon):SetIndex(0)
      ;
      ((self.ui).img_Dis):SetIndex(0)
    end
  end
  for i,v in ipairs((self.ui).array_point_imgs) do
    v:SetIndex(0)
  end
  local stageCfg = (self._sectorLevelData):GetLevelEpStageCfg()
  if isSideStage then
    ((self.ui).tex_Point):SetIndex(2, tostring(stageCfg.num))
  else
    ;
    ((self.ui).tex_Point):SetIndex(0, tostring(stageCfg.num))
  end
  local hasChallengeTask = (self._sectorLevelData):HasSectorIILevelChallengeTask()
  if not hasChallengeTask then
    ((self.ui).challengeHolder):SetActive(false)
  else
    ;
    ((self.ui).challengeHolder):SetActive(true)
    local total, count = (self._sectorLevelData):GetSectorIILevelChallengeTaskNum()
    local vec = ((self.ui).challenge).sizeDelta
    vec.x = self._starDefaultWidth * total
    -- DECOMPILER ERROR at PC116: Confused about usage of register: R8 in 'UnsetPending'

    ;
    ((self.ui).challenge).sizeDelta = vec
    vec = ((self.ui).img_ChallengeCur).sizeDelta
    vec.x = self._starDefaultWidth * count
    -- DECOMPILER ERROR at PC125: Confused about usage of register: R8 in 'UnsetPending'

    ;
    ((self.ui).img_ChallengeCur).sizeDelta = vec
  end
end

UINActSum22MapItem.__RefreshSectorAvg = function(self)
  -- function num : 0_3 , upvalues : _ENV
  ((self.ui).img_Buttom):SetIndex(1)
  ;
  ((self.ui).img_Icon):SetIndex(1)
  ;
  ((self.ui).img_Dis):SetIndex(1)
  for i,v in ipairs((self.ui).array_point_imgs) do
    v:SetIndex(1)
  end
  local avgCfg = (self._sectorLevelData):GetLevelAvgCfg()
  ;
  ((self.ui).tex_Point):SetIndex(1, tostring(avgCfg.number))
  ;
  ((self.ui).challengeHolder):SetActive(false)
end

UINActSum22MapItem.SetSum22MapItemSelectState = function(self, flag)
  -- function num : 0_4
  (((self.ui).ani_LatestPoint).gameObject):SetActive(flag)
  if flag then
    ((self.ui).ani_LatestPoint):Play()
  end
end

UINActSum22MapItem.RefreshSum22MapItemCompleteState = function(self)
  -- function num : 0_5
  ((self.ui).img_Complete):SetActive((self._sectorLevelData):GetIsLevelClaer())
  ;
  ((self.ui).go_Next):SetActive(not (self._sectorLevelData):GetIsLevelClaer())
  if (self._sectorLevelData):GetIsBattle() then
    ((self.ui).blueDot):SetActive(false)
  else
    ;
    ((self.ui).blueDot):SetActive(not (self._sectorLevelData):GetIsLevelClaer())
  end
end

UINActSum22MapItem.OnClickSelected = function(self)
  -- function num : 0_6
  if self._callback ~= nil then
    (self._callback)(self._sectorLevelData, self)
  end
end

UINActSum22MapItem.GetSum22SectorLevelData = function(self)
  -- function num : 0_7
  return self._sectorLevelData
end

return UINActSum22MapItem

