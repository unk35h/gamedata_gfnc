-- params : ...
-- function num : 0 , upvalues : _ENV
local UINSelectChipSuitListItem = class("UINSelectChipSuitListItem", UIBaseNode)
local base = UIBaseNode
local ChipData = require("Game.PlayerData.Item.ChipData")
local UINChipItemPress = require("Game.CommonUI.Item.UINChipItemPress")
local UINSltChipSuitItemIntro = require("Game.DailyDungeon.UI.SelectChipSuit.List.UINSltChipSuitItemIntro")
local FloatAlignEnum = require("Game.CommonUI.FloatWin.FloatAlignEnum")
local HAType = FloatAlignEnum.HAType
local VAType = FloatAlignEnum.VAType
local UINRichIntroButtom = require("Game.CommonUI.RichIntro.UINRichIntroButtom")
UINSelectChipSuitListItem.ctor = function(self, seChipSuitList)
  -- function num : 0_0
  self.seChipSuitList = seChipSuitList
end

UINSelectChipSuitListItem.OnInit = function(self)
  -- function num : 0_1 , upvalues : _ENV, UINChipItemPress, UINRichIntroButtom
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_root, self, self._OnClickRoot)
  ;
  (((self.ui).uINChipItem).gameObject):SetActive(false)
  self.chipItemPool = (UIItemPool.New)(UINChipItemPress, (self.ui).uINChipItem)
  self.__ShowChipDesc = BindCallback(self, self._ShowChipDesc)
  self.__HideChipDesc = BindCallback(self, self._HideChipDesc)
  self.btnRichIntro = (UINRichIntroButtom.New)()
  ;
  (self.btnRichIntro):Init((self.ui).obj_RichIntro)
  ;
  (self.btnRichIntro):InitRichIntroButtom(BindCallback(self, self._OnClickShowIntro), true)
end

UINSelectChipSuitListItem.InitSelectChipSuitListItem = function(self, seChipSuitData, showIntro, selected)
  -- function num : 0_2 , upvalues : _ENV, ChipData
  self.seChipSuitData = seChipSuitData
  local dynChipSuitData = seChipSuitData.dynChipSuitData
  self.chipTagId = dynChipSuitData.tagId
  self._selected = selected
  self._showIntro = showIntro
  self:_ShowIntroNode(showIntro)
  self:_ShowSelect(selected)
  local influenceId = dynChipSuitData:GetSuitChipInfluence()
  local career = (ConfigData.career)[influenceId]
  if career == nil then
    ((self.ui).tex_Apply):SetIndex(1)
    -- DECOMPILER ERROR at PC26: Confused about usage of register: R7 in 'UnsetPending'

    ;
    ((self.ui).img_Career).enabled = false
  else
    ;
    ((self.ui).tex_Apply):SetIndex(0, (LanguageUtil.GetLocaleText)(career.name))
    -- DECOMPILER ERROR at PC45: Confused about usage of register: R7 in 'UnsetPending'

    ;
    ((self.ui).img_Career).sprite = CRH:GetSprite(career.icon, CommonAtlasType.CareerCamp)
    -- DECOMPILER ERROR at PC48: Confused about usage of register: R7 in 'UnsetPending'

    ;
    ((self.ui).img_Career).enabled = true
  end
  -- DECOMPILER ERROR at PC58: Confused about usage of register: R7 in 'UnsetPending'

  if not ((self.ui).highlightColors)[influenceId] then
    ((self.ui).img_Light).color = Color.white
    -- DECOMPILER ERROR at PC63: Confused about usage of register: R7 in 'UnsetPending'

    ;
    ((self.ui).img_Icon).sprite = dynChipSuitData:GetChipSuitIconSprite()
    -- DECOMPILER ERROR at PC68: Confused about usage of register: R7 in 'UnsetPending'

    ;
    ((self.ui).tex_Name).text = dynChipSuitData:GetChipSuitName()
    local notShowCouldUseTime = seChipSuitData.notShowCouldUseTime
    ;
    (((self.ui).tex_Count).gameObject):SetActive(not notShowCouldUseTime)
    do
      if not notShowCouldUseTime then
        local canUseNum = (math.max)(seChipSuitData.selectNumMax - seChipSuitData.selectNumCur, 0)
        ;
        ((self.ui).tex_Count):SetIndex(0, tostring(canUseNum), tostring(seChipSuitData.selectNumMax))
      end
      local useUp = seChipSuitData.selectNumMax <= seChipSuitData.selectNumCur
      ;
      ((self.ui).obj_NoCount):SetActive(useUp)
      -- DECOMPILER ERROR at PC110: Confused about usage of register: R9 in 'UnsetPending'

      ;
      ((self.ui).btn_root).interactable = not useUp
      ;
      ((self.ui).obj_wait2UnlockNode):SetActive(false)
      ;
      (self.chipItemPool):HideAll()
      local chipIdList = dynChipSuitData:GetSuitChipList()
      for k,chipId in ipairs(chipIdList) do
        local chipData = (ChipData.NewChipForLocal)(R16_PC128, seChipSuitData.chipQuality)
        R16_PC128 = self.chipItemPool
        R16_PC128 = R16_PC128(R16_PC128)
        local chipItem = nil
        chipItem:InitChipItemWithPress(chipData, false, self.__ShowChipDesc, self.__HideChipDesc)
      end
      -- DECOMPILER ERROR: 2 unprocessed JMP targets
    end
  end
end

UINSelectChipSuitListItem.InitLockedState = function(self, chipPoolId, unlockInfo)
  -- function num : 0_3 , upvalues : _ENV, ChipData
  local chipTagCfg = (ConfigData.chip_tag)[chipPoolId]
  local tagSuitCfg = ((ConfigData.chip_tag).tag_suits)[chipPoolId]
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).img_Icon).sprite = CRH:GetSprite(chipTagCfg.tag_icon, CommonAtlasType.ExplorationIcon)
  -- DECOMPILER ERROR at PC22: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).text = (LanguageUtil.GetLocaleText)(chipTagCfg.tag_name)
  local influenceId = chipTagCfg.influence
  local career = (ConfigData.career)[influenceId]
  if career == nil then
    ((self.ui).tex_Apply):SetIndex(1)
    -- DECOMPILER ERROR at PC36: Confused about usage of register: R7 in 'UnsetPending'

    ;
    ((self.ui).img_Career).enabled = false
  else
    ;
    ((self.ui).tex_Apply):SetIndex(0, (LanguageUtil.GetLocaleText)(career.name))
    -- DECOMPILER ERROR at PC55: Confused about usage of register: R7 in 'UnsetPending'

    ;
    ((self.ui).img_Career).sprite = CRH:GetSprite(career.icon, CommonAtlasType.CareerCamp)
    -- DECOMPILER ERROR at PC58: Confused about usage of register: R7 in 'UnsetPending'

    ;
    ((self.ui).img_Career).enabled = true
  end
  -- DECOMPILER ERROR at PC68: Confused about usage of register: R7 in 'UnsetPending'

  if not ((self.ui).highlightColors)[influenceId] then
    ((self.ui).img_Light).color = Color.white
    ;
    (((self.ui).tex_Count).gameObject):SetActive(false)
    ;
    ((self.ui).obj_NoCount):SetActive(false)
    -- DECOMPILER ERROR at PC82: Confused about usage of register: R7 in 'UnsetPending'

    ;
    ((self.ui).btn_root).interactable = false
    ;
    ((self.ui).obj_wait2UnlockNode):SetActive(true)
    if unlockInfo ~= nil then
      ((self.ui).text_unlockWay):SetIndex(unlockInfo.index, unlockInfo.str)
    end
    ;
    (self.chipItemPool):HideAll()
    local chipTagCfg = (ConfigData.chip_tag)[chipPoolId]
    local chipIdList = chipTagCfg.chip_list
    for k,chipId in ipairs(chipIdList) do
      local chipData = (ChipData.NewChipForLocal)(chipId, 1)
      local chipItem = (self.chipItemPool):GetOne()
      chipItem:InitChipItemWithPress(chipData, false, nil, nil)
    end
  end
end

UINSelectChipSuitListItem._ShowChipDesc = function(self, chipData, chipItem)
  -- function num : 0_4 , upvalues : _ENV, HAType, VAType
  local win = UIManager:ShowWindow(UIWindowTypeID.FloatingFrame)
  local showDesc = (CommonUtil.GetDetailDescribeSetting)(eGameSetDescType.chip)
  win:SetTitleAndContext(chipData:GetName(), chipData:GetChipDescription(showDesc))
  win:FloatTo(chipItem.transform, HAType.left, VAType.up)
end

UINSelectChipSuitListItem._HideChipDesc = function(self, chipData, chipItem)
  -- function num : 0_5 , upvalues : _ENV
  local win = UIManager:GetWindow(UIWindowTypeID.FloatingFrame)
  if win ~= nil then
    win:Hide()
    win:Clean3DModifier()
  end
end

UINSelectChipSuitListItem._OnClickRoot = function(self)
  -- function num : 0_6 , upvalues : _ENV
  local selected = not self._selected
  if not (self.seChipSuitList):TrySelectChipSuitItem(self.chipTagId, selected) then
    return 
  end
  self._selected = selected
  self:_ShowSelect(self._selected)
  if self._selected then
    AudioManager:PlayAudioById(1058)
  end
end

UINSelectChipSuitListItem._ShowSelect = function(self, show)
  -- function num : 0_7 , upvalues : _ENV
  if show then
    if IsNull(self.selectObj) then
      self.selectObj = ((self.ui).obj_IsSelect):Instantiate(self.transform)
      -- DECOMPILER ERROR at PC17: Confused about usage of register: R2 in 'UnsetPending'

      ;
      ((self.selectObj).transform).anchoredPosition = Vector2.zero
    end
    ;
    (self.selectObj):SetActive(true)
  else
    if not IsNull(self.selectObj) then
      (self.selectObj):SetActive(false)
    end
  end
  ;
  ((self.ui).img_IsSel):SetIndex(show and 1 or 0)
end

UINSelectChipSuitListItem._OnClickShowIntro = function(self)
  -- function num : 0_8 , upvalues : _ENV
  self._showIntro = not self._showIntro
  self:_ShowIntroNode(self._showIntro)
  ;
  (self.seChipSuitList):RecordSeChipSuitListItemIntroState(self.chipTagId, self._showIntro)
  if self._showIntro then
    AudioManager:PlayAudioById(1072)
  end
end

UINSelectChipSuitListItem._ShowIntroNode = function(self, show)
  -- function num : 0_9 , upvalues : UINSltChipSuitItemIntro
  (self.btnRichIntro):SwitchUIState(show)
  if show then
    do
      if self.introNode == nil then
        local go = ((self.ui).introItem):Instantiate((self.ui).richIntroHolder)
        self.introNode = (UINSltChipSuitItemIntro.New)()
        ;
        (self.introNode):Init(go)
      end
      ;
      (self.introNode):Show()
      ;
      (self.introNode):InitSltChipSuitItemIntro(self.chipTagId)
      ;
      ((self.ui).obj_normal):SetActive(false)
      if self.introNode ~= nil then
        (self.introNode):Hide()
        ;
        ((self.ui).obj_normal):SetActive(true)
      end
    end
  end
end

UINSelectChipSuitListItem.OnDelete = function(self)
  -- function num : 0_10 , upvalues : base
  (self.chipItemPool):DeleteAll()
  if self.introNode ~= nil then
    (self.introNode):Delete()
  end
  ;
  (self.btnRichIntro):Delete()
  ;
  (base.OnDelete)(self)
end

return UINSelectChipSuitListItem

