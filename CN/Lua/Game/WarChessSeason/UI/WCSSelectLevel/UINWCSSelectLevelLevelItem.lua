-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINWCSSelectLevelLevelItem = class("UINWCSSelectLevelLevelItem", base)
local WarChessBuffData = require("Game.WarChess.Data.WarChessBuffData")
local UINBaseItemWithCount = require("Game.CommonUI.Item.UINBaseItemWithCount")
UINWCSSelectLevelLevelItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithCount
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.uiColorEnviroName = {}
  ;
  (UIUtil.LuaUIBindingTable)(((self.ui).tex_EnviroName).transform, self.uiColorEnviroName)
  self.uiColorEnviroBg = {}
  ;
  (UIUtil.LuaUIBindingTable)(((self.ui).img_EnviroBg).transform, self.uiColorEnviroBg)
  self.uiColorImgModeColor = {}
  ;
  (UIUtil.LuaUIBindingTable)(((self.ui).img_ModeColor).transform, self.uiColorImgModeColor)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_levelItem, self, self.__OnClick)
  self.levelRewardItemPool = (UIItemPool.New)(UINBaseItemWithCount, (self.ui).uINBaseItemWithCount)
  ;
  (((self.ui).uINBaseItemWithCount).gameObject):SetActive(false)
end

UINWCSSelectLevelLevelItem.InitWCSLevelItem = function(self, RoomId, BuffId, onclickCallback, resloader, serverRewardDic)
  -- function num : 0_1 , upvalues : _ENV, WarChessBuffData
  self.roomId = RoomId
  self.__onclickCallback = onclickCallback
  local seasonLevelCfg = (ConfigData.warchess_season_level)[RoomId]
  if seasonLevelCfg == nil then
    error("seasonLevelCfg not exist id:" .. tostring(RoomId))
    return 
  end
  self.seasonLevelCfg = seasonLevelCfg
  -- DECOMPILER ERROR at PC22: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.ui).tex_levelName).text = (LanguageUtil.GetLocaleText)(seasonLevelCfg.warchess_level_name)
  -- DECOMPILER ERROR at PC29: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.ui).img_Icon).sprite = CRH:GetSprite(seasonLevelCfg.warchess_level_icon)
  local difficulty = (math.clamp)(seasonLevelCfg.level_show_difficulty or 1, 1, 3) - 1
  local level_type = (math.clamp)(seasonLevelCfg.level_type or 1, 1, 4)
  ;
  ((self.ui).tex_SideDiff):SetIndex(difficulty)
  ;
  ((self.ui).tex_ModeDiff):SetIndex(difficulty)
  -- DECOMPILER ERROR at PC64: Confused about usage of register: R9 in 'UnsetPending'

  ;
  ((self.ui).img_Farme).color = ((self.ui).color_diff)[level_type]
  local pressType = (math.clamp)(seasonLevelCfg.level_stress_show, 1, 3) - 1
  local pressAddNum = seasonLevelCfg.level_stress_add
  ;
  ((self.ui).tex_Pressure):SetIndex(pressType, tostring(pressAddNum))
  local difficultySwitch = {[0] = function()
    -- function num : 0_1_0 , upvalues : self
    -- DECOMPILER ERROR at PC4: Confused about usage of register: R0 in 'UnsetPending'

    ((self.ui).img_ModeColor).color = (self.uiColorImgModeColor).color_normal
  end
, [1] = function()
    -- function num : 0_1_1 , upvalues : self
    -- DECOMPILER ERROR at PC4: Confused about usage of register: R0 in 'UnsetPending'

    ((self.ui).img_ModeColor).color = (self.uiColorImgModeColor).color_hard
  end
, [2] = function()
    -- function num : 0_1_2 , upvalues : self
    -- DECOMPILER ERROR at PC4: Confused about usage of register: R0 in 'UnsetPending'

    ((self.ui).img_ModeColor).color = (self.uiColorImgModeColor).color_challenge
  end
}
  if difficultySwitch[difficulty] then
    (difficultySwitch[difficulty])()
  end
  local levelPicResName = seasonLevelCfg.level_title_bg
  resloader:LoadABAssetAsync(PathConsts:GetWarChessSeasonPic(levelPicResName), function(texture)
    -- function num : 0_1_3 , upvalues : _ENV, self
    -- DECOMPILER ERROR at PC7: Confused about usage of register: R1 in 'UnsetPending'

    if not IsNull(self.transform) then
      ((self.ui).img_BGModePic).texture = texture
    end
  end
)
  if BuffId ~= nil and BuffId ~= 0 then
    (((self.ui).img_EnviroBg).gameObject):SetActive(true)
    ;
    (((self.ui).tex_EnviroDes).gameObject):SetActive(true)
    ;
    ((self.ui).obj_noBuff):SetActive(false)
    local levelBuffData = (WarChessBuffData.CrearteBuffById)(BuffId)
    self:__RefreshBuffEnv(levelBuffData)
  else
    do
      ;
      (((self.ui).img_EnviroBg).gameObject):SetActive(false)
      ;
      (((self.ui).tex_EnviroDes).gameObject):SetActive(false)
      ;
      ((self.ui).obj_noBuff):SetActive(true)
      self:__RefreshRewardShow(serverRewardDic)
    end
  end
end

UINWCSSelectLevelLevelItem.__RefreshBuffEnv = function(self, levelBuffData)
  -- function num : 0_2 , upvalues : _ENV
  if levelBuffData == nil then
    return 
  end
  self.__levelBuffData = levelBuffData
  local buffIcon = levelBuffData:GetWCBuffIcon()
  local buffColorType = levelBuffData:GetWCBuffColorType()
  if (string.IsNullOrEmpty)(buffIcon) then
    return 
  end
  -- DECOMPILER ERROR at PC23: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).img_EnvIcon).sprite = CRH:GetSprite(buffIcon, CommonAtlasType.ExplorationIcon)
  -- DECOMPILER ERROR at PC28: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_EnviroName).text = levelBuffData:GetWCBuffName()
  -- DECOMPILER ERROR at PC35: Confused about usage of register: R4 in 'UnsetPending'

  if buffColorType == 1 then
    ((self.ui).tex_EnviroName).color = (self.uiColorEnviroName).color_normal
    -- DECOMPILER ERROR at PC40: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.ui).img_EnviroBg).color = (self.uiColorEnviroBg).color_normal
  else
    -- DECOMPILER ERROR at PC48: Confused about usage of register: R4 in 'UnsetPending'

    if buffColorType == 2 then
      ((self.ui).tex_EnviroName).color = (self.uiColorEnviroName).color_mid
      -- DECOMPILER ERROR at PC53: Confused about usage of register: R4 in 'UnsetPending'

      ;
      ((self.ui).img_EnviroBg).color = (self.uiColorEnviroBg).color_mid
    else
      -- DECOMPILER ERROR at PC59: Confused about usage of register: R4 in 'UnsetPending'

      ;
      ((self.ui).tex_EnviroName).color = (self.uiColorEnviroName).color_hard
      -- DECOMPILER ERROR at PC64: Confused about usage of register: R4 in 'UnsetPending'

      ;
      ((self.ui).img_EnviroBg).color = (self.uiColorEnviroBg).color_hard
    end
  end
  -- DECOMPILER ERROR at PC69: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_EnviroDes).text = levelBuffData:GetWCBuffDes()
end

UINWCSSelectLevelLevelItem.__RefreshRewardShow = function(self, serverRewardDic)
  -- function num : 0_3 , upvalues : _ENV
  local itemList = (self.seasonLevelCfg).level_reward_show
  ;
  (self.levelRewardItemPool):HideAll()
  for itemId,itemNum in pairs(serverRewardDic) do
    local item = (self.levelRewardItemPool):GetOne()
    local itemCfg = (ConfigData.item)[itemId]
    item:InitItemWithCount(itemCfg, itemNum)
  end
  for _,itemId in ipairs(itemList) do
    local item = (self.levelRewardItemPool):GetOne()
    local itemCfg = (ConfigData.item)[itemId]
    item:InitItemWithCount(itemCfg, nil)
  end
end

UINWCSSelectLevelLevelItem.WCSSLIPlayFadeTween = function(self, index)
  -- function num : 0_4 , upvalues : _ENV
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R2 in 'UnsetPending'

  (((self.ui).canvas).transform).localPosition = (Vector2.New)(-200, 0)
  ;
  ((((self.ui).canvas):DOFade(0, 0.5)):From()):SetDelay(0.1 * index)
  ;
  ((((self.ui).canvas).transform):DOLocalMoveX(0, 0.5)):SetDelay(0.1 * index)
end

UINWCSSelectLevelLevelItem.__OnClick = function(self)
  -- function num : 0_5
  if self.__onclickCallback ~= nil then
    (self.__onclickCallback)(self)
  end
end

UINWCSSelectLevelLevelItem.SetClickEnable = function(self, enable)
  -- function num : 0_6 , upvalues : _ENV
  if enable then
    (UIUtil.AddButtonListener)((self.ui).btn_levelItem, self, self.__OnClick)
  else
    ;
    (UIUtil.RemoveButtonListener)((self.ui).btn_levelItem)
  end
end

UINWCSSelectLevelLevelItem.GetWCSRougeBuffData = function(self)
  -- function num : 0_7
  return self.__levelBuffData
end

UINWCSSelectLevelLevelItem.GetWCSPressAddNum = function(self)
  -- function num : 0_8
  return (self.seasonLevelCfg).level_stress_add
end

UINWCSSelectLevelLevelItem.GetRougeDoorId = function(self)
  -- function num : 0_9
  return (self.seasonLevelCfg).warchess_level_id
end

UINWCSSelectLevelLevelItem.OnDelete = function(self)
  -- function num : 0_10
  (((self.ui).canvas).transform):DOKill()
  ;
  ((self.ui).canvas):DOKill()
end

return UINWCSSelectLevelLevelItem

