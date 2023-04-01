-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINWarChessMainTop_PressBar = class("UINWarChessMainTop_PressBar", UIBaseNode)
local UINWarChessMainTop_PressBarItem = require("Game.WarChess.UI.Main.Top.UINWarChessMainTop_PressBarItem")
local CS_DOTween = ((CS.DG).Tweening).DOTween
local aniTime = 1
local STRESS_MAX_LENGTH = 10
UINWarChessMainTop_PressBar.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self._totalWith = (((self.ui).trans_Group).sizeDelta).x
  ;
  ((self.ui).obj_smallItem):SetActive(false)
  ;
  ((self.ui).obj_bigItem):SetActive(false)
  self._bigDic = {}
  self._bigRecycleList = {}
  self._smallDic = {}
  self._smallRecycleList = {}
  self._isInit = false
  self._lastLevel = nil
  self._lastPoint = nil
end

UINWarChessMainTop_PressBar.BindPressResloader = function(self, resloader)
  -- function num : 0_1 , upvalues : _ENV
  self._resloader = resloader
  self._iconAtlas = (AtlasUtil.GetSpirteAtlas)(UIAtlasConsts.Atlas_WarChess, resloader)
end

UINWarChessMainTop_PressBar.__RefreshPressBar = function(self, wcStressCfgs, stressLevel, stressPoint, isInit)
  -- function num : 0_2 , upvalues : _ENV, STRESS_MAX_LENGTH, CS_DOTween, aniTime
  local stressId = WarChessManager:GetWCLevelStressId()
  local stress_level_cfg = ((ConfigData.warchess_stress).stree_level)[stressId]
  if stress_level_cfg == nil then
    error("stress_level_cfg not exist wcid:" .. tostring(stressId))
    return 
  end
  for _,stressItem in pairs(self._bigDic) do
    self:__RecyclePressItem(stressItem)
  end
  for _,stressItem in pairs(self._smallDic) do
    self:__RecyclePressItem(stressItem)
  end
  local startLevel, endLevel, isNeedEmpty = nil, nil, nil
  if STRESS_MAX_LENGTH < stress_level_cfg.max_level then
    local backNum = STRESS_MAX_LENGTH // 2
    do
      startLevel = stressLevel - backNum + 1
      startLevel = (math.clamp)(startLevel, 0, stress_level_cfg.max_level)
      endLevel = startLevel + STRESS_MAX_LENGTH - 1
      endLevel = (math.clamp)(endLevel, 1, stress_level_cfg.max_level)
      if endLevel - startLevel < STRESS_MAX_LENGTH then
        startLevel = endLevel - STRESS_MAX_LENGTH + 1
      end
      isNeedEmpty = stress_level_cfg.max_level <= endLevel
    end
  else
    startLevel = 0
    endLevel = stress_level_cfg.max_level
    isNeedEmpty = true
  end
  local unit = nil
  if isNeedEmpty then
    unit = 1 / (endLevel - startLevel)
    -- DECOMPILER ERROR at PC84: Confused about usage of register: R11 in 'UnsetPending'

    ;
    ((self.ui).mask_bar).enabled = false
  else
    unit = 1 / (endLevel - startLevel)
    -- DECOMPILER ERROR at PC90: Confused about usage of register: R11 in 'UnsetPending'

    ;
    ((self.ui).mask_bar).enabled = true
  end
  for level = startLevel, endLevel do
    if level > 0 then
      local stressCfg = wcStressCfgs[level]
      local stressItem = self:__GetPressItem(stressCfg, level)
      local pos_x = (level - startLevel) * (unit) * self._totalWith
      -- DECOMPILER ERROR at PC112: Confused about usage of register: R18 in 'UnsetPending'

      ;
      (stressItem.transform).anchoredPosition = (Vector2.New)(pos_x, 0)
      stressItem:RefreshPressBarItem(level <= stressLevel)
    end
  end
  local curLevelPoint = 0
  local nextLevelPoint = (wcStressCfgs[stress_level_cfg.max_level]).stresspoint
  if stressLevel > 0 then
    curLevelPoint = (wcStressCfgs[stressLevel]).stresspoint
  end
  if stressLevel + 1 < stress_level_cfg.max_level then
    nextLevelPoint = (wcStressCfgs[stressLevel + 1]).stresspoint
  end
  local curLevelRatio = nil
  if nextLevelPoint == curLevelPoint then
    curLevelRatio = 0
  else
    curLevelRatio = (stressPoint - curLevelPoint) / (nextLevelPoint - curLevelPoint)
  end
  local showRatio = unit * (stressLevel - startLevel + curLevelRatio)
  if stressLevel > 0 and self._lastLevel ~= stressLevel then
    if (self._bigDic)[stressLevel] ~= nil then
      AudioManager:PlayAudioById(1240)
    else
      AudioManager:PlayAudioById(1239)
    end
  end
  ;
  ((self.ui).tex_Lv):SetIndex(0, tostring(stressLevel))
  local nextLevelCfg = wcStressCfgs[stressLevel + 1]
  if nextLevelCfg == nil then
    nextLevelCfg = wcStressCfgs[stressLevel]
  end
  -- DECOMPILER ERROR at PC187: Confused about usage of register: R16 in 'UnsetPending'

  ;
  ((self.ui).tex_Progress).text = tostring(stressPoint) .. "/" .. tostring(nextLevelCfg.stresspoint)
  if self._sequence ~= nil then
    (self._sequence):Kill(true)
  end
  self._sequence = (CS_DOTween.Sequence)()
  for i = self._lastLevel + 1, stressLevel do
    if not (self._bigDic)[i] then
      local stressItem = (self._smallDic)[i]
    end
    if stressItem ~= nil then
      local time = (stressLevel - self._lastLevel) * aniTime
      ;
      (self._sequence):InsertCallback(time, function()
    -- function num : 0_2_0 , upvalues : stressItem
    stressItem:PlayBarItemOver()
  end
)
    end
  end
  ;
  (self._sequence):OnComplete(function()
    -- function num : 0_2_1 , upvalues : self
    self._sequence = nil
  end
)
  -- DECOMPILER ERROR at PC230: Confused about usage of register: R16 in 'UnsetPending'

  if isInit then
    ((self.ui).silder_Value).value = showRatio
    -- DECOMPILER ERROR at PC239: Confused about usage of register: R16 in 'UnsetPending'

    ;
    ((self.ui).trans_Progress).anchoredPosition = (Vector2.New)(self._totalWith * showRatio, 0)
  else
    if self._startLevel ~= startLevel then
      ((self.ui).silder_Value):DOKill()
      ;
      ((self.ui).trans_Progress):DOKill()
      local lastRelativeRation = ((self.ui).silder_Value).value - unit * (startLevel - self._startLevel)
      -- DECOMPILER ERROR at PC261: Confused about usage of register: R17 in 'UnsetPending'

      ;
      ((self.ui).silder_Value).value = lastRelativeRation
      -- DECOMPILER ERROR at PC270: Confused about usage of register: R17 in 'UnsetPending'

      ;
      ((self.ui).trans_Progress).anchoredPosition = (Vector2.New)(self._totalWith * lastRelativeRation, 0)
    end
    ;
    ((self.ui).silder_Value):DOValue(showRatio, aniTime)
    ;
    ((self.ui).trans_Progress):DOAnchorPosX(self._totalWith * showRatio, aniTime)
  end
  self._startLevel = startLevel
  self._endLevel = endLevel
  self._lastLevel = stressLevel
  self._lastPoint = stressPoint
  -- DECOMPILER ERROR: 20 unprocessed JMP targets
end

UINWarChessMainTop_PressBar.__GetPressItem = function(self, stressCfg, level)
  -- function num : 0_3 , upvalues : _ENV, UINWarChessMainTop_PressBarItem
  local stressItem = nil
  local isBig = not (string.IsNullOrEmpty)(stressCfg.stressicon)
  if isBig then
    if #self._bigRecycleList > 0 then
      stressItem = (table.remove)(self._bigRecycleList, 1)
    else
      stressItem = (UINWarChessMainTop_PressBarItem.New)()
      local go = ((self.ui).obj_bigItem):Instantiate()
      go:SetActive(true)
      stressItem:Init(go)
    end
    do
      do
        local iconSprite = (AtlasUtil.GetResldSprite)(self._iconAtlas, stressCfg.stressicon)
        stressItem:WCInitPressItem(true, level, iconSprite)
        -- DECOMPILER ERROR at PC43: Confused about usage of register: R6 in 'UnsetPending'

        ;
        (self._bigDic)[level] = stressItem
        if #self._smallRecycleList > 0 then
          stressItem = (table.remove)(self._smallRecycleList, 1)
        else
          stressItem = (UINWarChessMainTop_PressBarItem.New)()
          local go = ((self.ui).obj_smallItem):Instantiate()
          go:SetActive(true)
          stressItem:Init(go)
        end
        do
          stressItem:WCInitPressItem(false, level, nil)
          -- DECOMPILER ERROR at PC75: Confused about usage of register: R5 in 'UnsetPending'

          ;
          (self._smallDic)[level] = stressItem
          stressItem:Show()
          return stressItem
        end
      end
    end
  end
end

UINWarChessMainTop_PressBar.__RecyclePressItem = function(self, stressItem)
  -- function num : 0_4 , upvalues : _ENV
  local isBig = stressItem:WCPressBarGetIsBigItem()
  local level = stressItem:WCPressBarGetLevel()
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R4 in 'UnsetPending'

  if isBig then
    (self._bigDic)[level] = nil
    ;
    (table.insert)(self._bigRecycleList, stressItem)
  else
    -- DECOMPILER ERROR at PC15: Confused about usage of register: R4 in 'UnsetPending'

    ;
    (self._smallDic)[level] = nil
    ;
    (table.insert)(self._smallRecycleList, stressItem)
  end
  stressItem:Hide()
end

UINWarChessMainTop_PressBar.RefreshWCPress = function(self, forceReinitial)
  -- function num : 0_5 , upvalues : _ENV
  local wcCtrl = WarChessManager:GetWarChessCtrl()
  local wcStressCfgs = (wcCtrl.turnCtrl):GetWCStressCfgs()
  local stressLevel, stressPoint = (wcCtrl.turnCtrl):GetWCStressLevelAndPoint()
  local isInit = false
  if not self._isInit or forceReinitial then
    self._lastLevel = stressLevel
    self._lastPoint = stressPoint
    self._isInit = true
    isInit = true
  end
  self:__RefreshPressBar(wcStressCfgs, stressLevel, stressPoint, isInit)
end

UINWarChessMainTop_PressBar.OnDelete = function(self)
  -- function num : 0_6 , upvalues : base
  ((self.ui).silder_Value):DOKill()
  ;
  ((self.ui).trans_Progress):DOKill()
  if self._sequence ~= nil then
    (self._sequence):Kill()
  end
  ;
  (base.OnDelete)(self)
end

return UINWarChessMainTop_PressBar

