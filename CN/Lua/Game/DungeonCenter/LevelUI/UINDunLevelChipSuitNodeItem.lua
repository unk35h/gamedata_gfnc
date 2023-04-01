-- params : ...
-- function num : 0 , upvalues : _ENV
local UINDunLevelChipSuitNodeItem = class("UINDunLevelChipSuitNodeItem", UIBaseNode)
local base = UIBaseNode
local UINChipItemPress = require("Game.CommonUI.Item.UINChipItemPress")
local ChipData = require("Game.PlayerData.Item.ChipData")
local UINRichIntroButtom = require("Game.CommonUI.RichIntro.UINRichIntroButtom")
local UINSltChipSuitItemIntro = require("Game.DailyDungeon.UI.SelectChipSuit.List.UINSltChipSuitItemIntro")
local FloatAlignEnum = require("Game.CommonUI.FloatWin.FloatAlignEnum")
UINDunLevelChipSuitNodeItem.ctor = function(self, dunChipSuitNode)
  -- function num : 0_0
  self._dunChipSuitNode = dunChipSuitNode
end

UINDunLevelChipSuitNodeItem.OnInit = function(self)
  -- function num : 0_1 , upvalues : _ENV, UINChipItemPress, UINRichIntroButtom
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.chipItemPool = (UIItemPool.New)(UINChipItemPress, (self.ui).uINChipItem)
  ;
  (((self.ui).uINChipItem).gameObject):SetActive(false)
  self.__ShowChipDesc = BindCallback(self, self._ShowChipDesc)
  self.__HideChipDesc = BindCallback(self, self._HideChipDesc)
  self.btnRichIntro = (UINRichIntroButtom.New)()
  ;
  (self.btnRichIntro):Init((self.ui).obj_RichIntro)
  ;
  (self.btnRichIntro):InitRichIntroButtom(BindCallback(self, self._OnClickShowIntro), true)
end

UINDunLevelChipSuitNodeItem.RefreshIsUnlock = function(self, isUnlock, unlockInfo)
  -- function num : 0_2
  ((self.ui).obj_wait2UnlockNode):SetActive(not isUnlock)
  if not isUnlock and unlockInfo ~= nil then
    ((self.ui).text_unlockWay):SetIndex(unlockInfo.index, unlockInfo.str)
  end
end

UINDunLevelChipSuitNodeItem.RefreshChipSuitItem = function(self, chipSuitId, quality, showIntro)
  -- function num : 0_3 , upvalues : _ENV, ChipData
  self.chipTagId = chipSuitId
  self._showIntro = showIntro
  self:_ShowIntroNode(showIntro)
  local chipTagCfg = (ConfigData.chip_tag)[chipSuitId]
  local tagSuitCfg = ((ConfigData.chip_tag).tag_suits)[chipSuitId]
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).img_Icon).sprite = CRH:GetSprite(chipTagCfg.tag_icon, CommonAtlasType.ExplorationIcon)
  -- DECOMPILER ERROR at PC27: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).text = (LanguageUtil.GetLocaleText)(chipTagCfg.tag_name)
  local influenceId = chipTagCfg.influence
  local career = (ConfigData.career)[influenceId]
  if career == nil then
    ((self.ui).tex_Apply):SetIndex(1)
    -- DECOMPILER ERROR at PC41: Confused about usage of register: R8 in 'UnsetPending'

    ;
    ((self.ui).img_Career).enabled = false
  else
    ;
    ((self.ui).tex_Apply):SetIndex(0, (LanguageUtil.GetLocaleText)(career.name))
    -- DECOMPILER ERROR at PC60: Confused about usage of register: R8 in 'UnsetPending'

    ;
    ((self.ui).img_Career).sprite = CRH:GetSprite(career.icon, CommonAtlasType.CareerCamp)
    -- DECOMPILER ERROR at PC63: Confused about usage of register: R8 in 'UnsetPending'

    ;
    ((self.ui).img_Career).enabled = true
  end
  ;
  (self.chipItemPool):HideAll()
  for index,chipId in ipairs(chipTagCfg.chip_list) do
    local chipData = (ChipData.NewChipForLocal)(chipId, quality)
    local chipItem = (self.chipItemPool):GetOne()
    chipItem:InitChipItemWithPress(chipData, false, self.__ShowChipDesc, self.__HideChipDesc)
  end
end

UINDunLevelChipSuitNodeItem._ShowChipDesc = function(self, chipData, chipItem)
  -- function num : 0_4 , upvalues : _ENV, FloatAlignEnum
  local win = UIManager:ShowWindow(UIWindowTypeID.FloatingFrame)
  local showDesc = (CommonUtil.GetDetailDescribeSetting)(eGameSetDescType.chip)
  win:SetTitleAndContext(chipData:GetName(), chipData:GetChipDescription(showDesc))
  win:FloatTo(chipItem.transform, (FloatAlignEnum.HAType).right, (FloatAlignEnum.VAType).up)
end

UINDunLevelChipSuitNodeItem._HideChipDesc = function(self, chipData, chipItem)
  -- function num : 0_5 , upvalues : _ENV
  local win = UIManager:GetWindow(UIWindowTypeID.FloatingFrame)
  if win ~= nil then
    win:Hide()
    win:Clean3DModifier()
  end
end

UINDunLevelChipSuitNodeItem._OnClickShowIntro = function(self)
  -- function num : 0_6 , upvalues : _ENV
  self._showIntro = not self._showIntro
  self:_ShowIntroNode(self._showIntro)
  ;
  (self._dunChipSuitNode):RecordDunChipSuitItemIntroState(self.chipTagId, self._showIntro)
  if self._showIntro then
    AudioManager:PlayAudioById(1072)
  end
end

UINDunLevelChipSuitNodeItem._ShowIntroNode = function(self, show)
  -- function num : 0_7 , upvalues : UINSltChipSuitItemIntro
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

UINDunLevelChipSuitNodeItem.OnDelete = function(self)
  -- function num : 0_8 , upvalues : base
  if self.introNode ~= nil then
    (self.introNode):Delete()
  end
  ;
  (base.OnDelete)(self)
end

return UINDunLevelChipSuitNodeItem

