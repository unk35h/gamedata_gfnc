-- params : ...
-- function num : 0 , upvalues : _ENV
local UINActSum22StrategySelectItem = class("UINActSum22StrategySelectItem", UIBaseNode)
local base = UIBaseNode
local cs_WaitForSeconds = (CS.UnityEngine).WaitForSeconds
UINActSum22StrategySelectItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Get, self, self._OnClickSelect)
  ;
  ((self.ui).fxRoot):SetParent(((self.transform).parent).parent)
end

UINActSum22StrategySelectItem.InitTechSelectItem = function(self, idx, techData, resloader, callback)
  -- function num : 0_1 , upvalues : _ENV
  self._callback = callback
  self._techData = techData
  -- DECOMPILER ERROR at PC4: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).img_Icon).enabled = false
  resloader:LoadABAssetAsync(PathConsts:GetAtlasAssetPath("SectorBuilding"), function(spriteAtlas)
    -- function num : 0_1_0 , upvalues : self, _ENV, techData
    if spriteAtlas == nil then
      return 
    end
    -- DECOMPILER ERROR at PC12: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_Icon).sprite = (AtlasUtil.GetResldSprite)(spriteAtlas, techData:GetWATechIcon())
    -- DECOMPILER ERROR at PC15: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_Icon).enabled = true
  end
)
  ;
  ((self.ui).tex_NO):SetIndex(0, tostring(idx))
  ;
  ((self.ui).img_Frame):SetIndex(techData:GetActTechUIFrameId())
  local curLv = techData:GetCurLevel()
  local nextLevel = curLv + 1
  local loopLevel = techData:IsActTechLevelLoop()
  -- DECOMPILER ERROR at PC39: Confused about usage of register: R8 in 'UnsetPending'

  if loopLevel then
    (((self.ui).tex_Lvl).text).text = tostring(nextLevel)
  else
    local maxLv = techData:GetMaxLevel()
    if maxLv < nextLevel then
      error((string.format)("nextLevel(%s) > maxLv(%s),techId:%s", nextLevel, maxLv, techData:GetTechId()))
      return 
    end
    ;
    ((self.ui).tex_Lvl):SetIndex(0, tostring(nextLevel), tostring(maxLv))
  end
  do
    local costDic = techData:GetLevelCost(nextLevel)
    for costId,costNum in pairs(costDic) do
      -- DECOMPILER ERROR at PC81: Confused about usage of register: R14 in 'UnsetPending'

      ((self.ui).img_Coin).sprite = CRH:GetSpriteByItemId(costId, true)
      -- DECOMPILER ERROR at PC87: Confused about usage of register: R14 in 'UnsetPending'

      ;
      ((self.ui).tex_Cost).text = tostring(costNum)
      do break end
    end
    do
      -- DECOMPILER ERROR at PC95: Confused about usage of register: R9 in 'UnsetPending'

      ;
      ((self.ui).tex_TechName).text = techData:GetAWTechName()
      local longDes, shortDes, valueDes = techData:GetTechDescriptionFirst(nextLevel, eLogicDesType.Warchess)
      -- DECOMPILER ERROR at PC108: Confused about usage of register: R12 in 'UnsetPending'

      ;
      ((self.ui).tex_Des).text = techData:GetTechDescription(nextLevel, eLogicDesType.Warchess)
      -- DECOMPILER ERROR at PC111: Confused about usage of register: R12 in 'UnsetPending'

      ;
      ((self.ui).tex_ValueName).text = shortDes
      local isNew = curLv == 0
      local showBuffChange = not isNew
      local logicArray, para1Array, para2Array, para3Array = techData:GetTechLogic(nextLevel)
      if logicArray[1] == eLogicType.Activity_UnlockBuff then
        showBuffChange = false
      end
      ;
      ((self.ui).buffChangeBg):SetActive(showBuffChange)
      if curLv == 0 then
        do
          local _, _, curValueDes = techData:GetTechDescriptionFirst(curLv, eLogicDesType.Warchess)
          ;
          ((self.ui).tex_Change):SetIndex(0, curValueDes, valueDes)
          local branchCfg = techData:GetActTechBranchCfg()
          -- DECOMPILER ERROR at PC154: Confused about usage of register: R19 in 'UnsetPending'

          ;
          ((self.ui).tex_Branch).text = (LanguageUtil.GetLocaleText)(branchCfg.branch_name)
          ;
          ((self.ui).tagBg):SetActive(isNew)
          ;
          ((self.ui).img_Get):SetIndex(isNew and 0 or 1)
          ;
          ((self.ui).tex_Get):SetIndex(isNew and 0 or 1)
          -- DECOMPILER ERROR at PC190: Confused about usage of register: R19 in 'UnsetPending'

          if not isNew or not (self.ui).color_title_new then
            ((self.ui).img_Title).color = (self.ui).color_title_level
            -- DECOMPILER ERROR at PC201: Confused about usage of register: R19 in 'UnsetPending'

            if not isNew or not (self.ui).color_bottom_new then
              ((self.ui).img_Bottom).color = (self.ui).color_bottom_level
              -- DECOMPILER ERROR at PC212: Confused about usage of register: R19 in 'UnsetPending'

              if not isNew or not (self.ui).color_namebg_new then
                ((self.ui).img_StrategyNameBg).color = (self.ui).color_namebg_level
                -- DECOMPILER ERROR: 14 unprocessed JMP targets
              end
            end
          end
        end
      end
    end
  end
end

UINActSum22StrategySelectItem.PlaySelectAnimActSum22TechSelectItem = function(self, idx, techData, resloader, callback, isSelected)
  -- function num : 0_2 , upvalues : _ENV
  if not self._posY then
    self._posY = ((self.transform).anchoredPosition).y
    TimerManager:StopTimer(self._selectTimer)
    local animState = ((self.ui).anim):get_Item("UI_ActSum22StrategySelectItem_after")
    animState.time = animState.length
    self._IsInAnimation = true
    if isSelected then
      ((self.ui).dtAnim):DORestartById("outro")
    end
    self._selectTimer = TimerManager:StartTimer(0.3, function()
    -- function num : 0_2_0 , upvalues : isSelected, self, _ENV, idx, techData, resloader, callback
    -- DECOMPILER ERROR at PC11: Confused about usage of register: R0 in 'UnsetPending'

    if isSelected then
      (self.transform).anchoredPosition = (Vector2.Temp)(((self.transform).anchoredPosition).x, self._posY)
      ;
      ((((self.transform):DOAnchorPosY(self._posY - 200, 0.3)):From()):SetLink(self.gameObject)):SetDelay(0.1)
      ;
      ((((self.ui).canvasGroup):DOFade(1, 0.15)):SetLink(self.gameObject)):SetDelay(0.1)
      self:InitTechSelectItem(idx, techData, resloader, callback)
    end
    self:PlayRefreshAnimActSum22TechSelectItem(idx, techData, resloader, callback, isSelected)
  end
, self, true)
  end
end

UINActSum22StrategySelectItem.PlayRefreshAnimActSum22TechSelectItem = function(self, idx, techData, resloader, callback, fromSelectAnim)
  -- function num : 0_3 , upvalues : _ENV
  ((self.ui).fx_LvUp):SetActive(false)
  ;
  ((self.ui).fx_New):SetActive(false)
  ;
  ((self.ui).fx_SpecailLvup):SetActive(false)
  ;
  ((self.ui).fx_SpecailNew):SetActive(false)
  TimerManager:StopTimer(self._refreshTimer)
  local isNew = techData:GetCurLevel() == 0
  local isSpecial = techData:IsActTechSpecial()
  if isNew then
    if isSpecial then
      ((self.ui).fx_SpecailNew):SetActive(true)
    else
      ((self.ui).fx_New):SetActive(true)
    end
  elseif isSpecial then
    ((self.ui).fx_SpecailLvup):SetActive(true)
  else
    ((self.ui).fx_LvUp):SetActive(true)
  end
  if not fromSelectAnim then
    ((self.ui).anim):Play("UI_ActSum22StrategySelectItem_before")
  end
  self._IsInAnimation = true
  self._refreshTimer = TimerManager:StartTimer(0.5, function()
    -- function num : 0_3_0 , upvalues : fromSelectAnim, self, idx, techData, resloader, callback
    if not fromSelectAnim then
      ((self.ui).anim):Play("UI_ActSum22StrategySelectItem_after")
      self:InitTechSelectItem(idx, techData, resloader, callback)
    end
    self._IsInAnimation = false
  end
, self, true)
  -- DECOMPILER ERROR: 6 unprocessed JMP targets
end

UINActSum22StrategySelectItem._OnClickSelect = function(self)
  -- function num : 0_4
  if self._IsInAnimation then
    return 
  end
  if self._callback then
    (self._callback)(self._techData, self)
  end
end

UINActSum22StrategySelectItem.OnDelete = function(self)
  -- function num : 0_5 , upvalues : _ENV
  TimerManager:StopTimer(self._refreshTimer)
  TimerManager:StopTimer(self._selectTimer)
end

return UINActSum22StrategySelectItem

