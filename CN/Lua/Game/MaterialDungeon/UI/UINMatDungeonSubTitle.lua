-- params : ...
-- function num : 0 , upvalues : _ENV
local UINMatDungeonSubTitle = class("UINMatDungeonSubTitle", UIBaseNode)
local base = UIBaseNode
local cs_MessageCommon = CS.MessageCommon
UINMatDungeonSubTitle.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_tile, self, self.OnClickTitle)
end

UINMatDungeonSubTitle.SetSubTitleInfo = function(self, dungeonSubInfoCfg, resLoader, isShowOpen, onClickFunc)
  -- function num : 0_1 , upvalues : _ENV
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R5 in 'UnsetPending'

  ((self.ui).img_Icon).sprite = (AtlasUtil.GetSpriteFromAtlas)("CommonDungeon", dungeonSubInfoCfg.icon, resLoader)
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).text = (LanguageUtil.GetLocaleText)(dungeonSubInfoCfg.text)
  self.isShowOpen = isShowOpen or false
  self.stage_type = dungeonSubInfoCfg.stage_type
  self.onClickFunc = onClickFunc
  if not IsNull((self.ui).img_SelectBG) then
    ((self.ui).img_SelectBG):SetIndex(dungeonSubInfoCfg.img_bottom_idx)
  end
  self:RefreshState()
end

UINMatDungeonSubTitle.RefreshIsMultReward = function(self, dungeonItemDic)
  -- function num : 0_2 , upvalues : _ENV
  local isHaveMultReward = false
  local isOnlyDouble = true
  for dungeonData,item in pairs(dungeonItemDic) do
    if dungeonData:GetSubTitleId() == self.stage_type and dungeonData:GetIsHaveMultReward() then
      isHaveMultReward = true
      local multAddRate = dungeonData:GetActivityMultRewardRate()
      if multAddRate ~= 1 then
        isOnlyDouble = false
      end
    end
  end
  if isHaveMultReward then
    ((self.ui).obj_dropUp):SetActive(true)
    if isOnlyDouble then
      ((self.ui).tex_multType):SetIndex(1)
    else
      ;
      ((self.ui).tex_multType):SetIndex(0)
    end
  else
    ;
    ((self.ui).obj_dropUp):SetActive(false)
  end
end

UINMatDungeonSubTitle.RefreshState = function(self)
  -- function num : 0_3
  (((self.ui).obj_CloseList).gameObject):SetActive(self.isShowOpen)
  ;
  (((self.ui).obj_OpenList).gameObject):SetActive(not self.isShowOpen)
end

UINMatDungeonSubTitle.SetMatDgSubTitleLock = function(self, firstDgData)
  -- function num : 0_4
  self._firstDgData = firstDgData
  ;
  (((self.ui).state_lock).gameObject):SetActive(not firstDgData:GetIsUnlock())
end

UINMatDungeonSubTitle.OnClickTitle = function(self)
  -- function num : 0_5 , upvalues : cs_MessageCommon, _ENV
  if self._firstDgData ~= nil and not self.isShowOpen and not (self._firstDgData):GetIsUnlock() then
    (cs_MessageCommon.ShowMessageTipsWithErrorSound)((self._firstDgData):GetDungeonUnlockDes())
  end
  self.isShowOpen = not self.isShowOpen
  self:RefreshState()
  if self.onClickFunc ~= nil then
    (self.onClickFunc)(self.stage_type, self.isShowOpen)
  end
  AudioManager:PlayAudioById(1060)
end

UINMatDungeonSubTitle.SetDungeonSubTitleState = function(self, isOpen)
  -- function num : 0_6
  self.isShowOpen = isOpen
  self:RefreshState()
end

UINMatDungeonSubTitle.OnDelete = function(self)
  -- function num : 0_7 , upvalues : base
  (base.OnDelete)(self)
end

return UINMatDungeonSubTitle

