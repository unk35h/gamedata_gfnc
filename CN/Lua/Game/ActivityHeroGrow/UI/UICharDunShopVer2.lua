-- params : ...
-- function num : 0 , upvalues : _ENV
local UICharDunShopVer2 = class("UICharDunShopVer2", UIBaseWindow)
local base = UIBaseWindow
local UINCharDunShopVer2Line = require("Game.ActivityHeroGrow.UI.UINCharDunShopVer2Line")
local UINCharDunShopVer2Item = require("Game.ActivityHeroGrow.UI.UINCharDunShopVer2Item")
local cs_ResLoader = CS.ResLoader
UICharDunShopVer2.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINCharDunShopVer2Line, cs_ResLoader
  (UIUtil.SetTopStatus)(self, self.OnClickCloseShopVer2)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_GetAll, self, self.OnClickRewardAll)
  self.__OnRewardOneCallback = BindCallback(self, self.__OnRewardOne)
  self._lineHorizePool = (UIItemPool.New)(UINCharDunShopVer2Line, (self.ui).lineHri)
  ;
  ((self.ui).lineHri):SetActive(false)
  self._lineVerticalPool = (UIItemPool.New)(UINCharDunShopVer2Line, (self.ui).lineVer)
  ;
  ((self.ui).lineVer):SetActive(false)
  -- DECOMPILER ERROR at PC47: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).shopList).onInstantiateItem = BindCallback(self, self.__OnInstantiateItem)
  -- DECOMPILER ERROR at PC54: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).shopList).onChangeItem = BindCallback(self, self.__OnChangeItem)
  -- DECOMPILER ERROR at PC61: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).shopList).onReturnItem = BindCallback(self, self.__OnReturnItem)
  self.__ItemUpdateCallback = BindCallback(self, self.__ItemUpdate)
  MsgCenter:AddListener(eMsgEventId.UpdateItem, self.__ItemUpdateCallback)
  self._resloader = (cs_ResLoader.Create)()
  self._itemDic = {}
end

UICharDunShopVer2.InitCharDunShopVer2 = function(self, heroGrowData, callback)
  -- function num : 0_1
  self._heroGrowData = heroGrowData
  self._callback = callback
  self:__ReplaceByUICfg()
  self:__InitUI()
  self:RefreshCharDunShopVer2()
end

UICharDunShopVer2.__InitUI = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local uiCfg = (ConfigData.activity_hero_ui_config)[(self._heroGrowData):GetActId()]
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_TileName).text = (LanguageUtil.GetLocaleText)(uiCfg.reward_panel_name)
  local itemId = (self._heroGrowData):GetHeroGrowCostId()
  -- DECOMPILER ERROR at PC22: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).imgToken).sprite = CRH:GetSpriteByItemId(itemId)
  local itemName = ConfigData:GetItemName(itemId)
  -- DECOMPILER ERROR at PC29: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_HeadName).text = itemName
  ;
  ((self.ui).tex_DateType):SetIndex(0)
  local date = TimeUtil:TimestampToDate((self._heroGrowData):GetActivityDestroyTime(), false, true)
  -- DECOMPILER ERROR at PC54: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_Time).text = (string.format)("%02d/%02d/%02d %02d:%02d", date.year, date.month, date.day, date.hour, date.min)
  local tip = ConfigData:GetTipContent(7045)
  local taskName = (LanguageUtil.GetLocaleText)(uiCfg.mission_panel_name)
  -- DECOMPILER ERROR at PC71: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.ui).tex_Tip).text = (string.format)(tip, taskName, itemName)
  self:__CreateItem()
  self:__CountDown()
  self._timerId = TimerManager:StartTimer(1, self.__CountDown, self)
  -- DECOMPILER ERROR at PC97: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.ui).tex_TileName).color = (Color.New)((uiCfg.shop_title_color)[1] / 255, (uiCfg.shop_title_color)[2] / 255, (uiCfg.shop_title_color)[3] / 255)
end

UICharDunShopVer2.__ReplaceByUICfg = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local uiCfg = (ConfigData.activity_hero_ui_config)[(self._heroGrowData):GetActId()]
  local bgPath = PathConsts:GetCharDunVer2Bg(uiCfg.background_res)
  ;
  (((self.ui).background).gameObject):SetActive(false)
  ;
  (self._resloader):LoadABAssetAsync(bgPath, function(texture)
    -- function num : 0_3_0 , upvalues : _ENV, self
    if texture == nil or IsNull(self.transform) then
      return 
    end
    ;
    (((self.ui).background).gameObject):SetActive(true)
    -- DECOMPILER ERROR at PC16: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).background).texture = texture
  end
)
  local frameColors = uiCfg.frame_color
  local color = (Color.New)(frameColors[1] / 255, frameColors[2] / 255, frameColors[3] / 255)
  for i,v in ipairs((self.ui).array_colorRep) do
    v.color = color
  end
  if #uiCfg.main_top_res == 0 then
    (((self.ui).Img_Up).gameObject):SetActive(false)
  else
    local nameResPath = PathConsts:GetCharDunVer2Bg(uiCfg.main_top_res)
    ;
    (self._resloader):LoadABAssetAsync(nameResPath, function(texture)
    -- function num : 0_3_1 , upvalues : _ENV, self
    if texture == nil or IsNull(self.transform) then
      return 
    end
    ;
    (((self.ui).Img_Up).gameObject):SetActive(true)
    -- DECOMPILER ERROR at PC16: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).Img_Up).texture = texture
  end
)
    -- DECOMPILER ERROR at PC69: Confused about usage of register: R6 in 'UnsetPending'

    ;
    (((self.ui).Img_Up).transform).sizeDelta = (Vector2.Temp)((uiCfg.main_top_size)[1], (uiCfg.main_top_size)[2])
  end
  do
    if #uiCfg.main_down_res == 0 then
      (((self.ui).Img_Down).gameObject):SetActive(false)
    else
      local nameResPath = PathConsts:GetCharDunVer2Bg(uiCfg.main_down_res)
      ;
      (self._resloader):LoadABAssetAsync(nameResPath, function(texture)
    -- function num : 0_3_2 , upvalues : _ENV, self
    if texture == nil or IsNull(self.transform) then
      return 
    end
    ;
    (((self.ui).Img_Down).gameObject):SetActive(true)
    -- DECOMPILER ERROR at PC16: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).Img_Down).texture = texture
  end
)
      -- DECOMPILER ERROR at PC100: Confused about usage of register: R6 in 'UnsetPending'

      ;
      (((self.ui).Img_Down).transform).sizeDelta = (Vector2.Temp)((uiCfg.main_down_size)[1], (uiCfg.main_down_size)[2])
    end
  end
end

UICharDunShopVer2.__CreateItem = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local allCfg = (ConfigData.activity_hero_token_reward)[(self._heroGrowData):GetActId()]
  local count = #allCfg
  local itemCount = PlayerDataCenter:GetItemCount((self._heroGrowData):GetHeroGrowCostId())
  self._lvSort = {}
  local oneLineLinit = ((self.ui).rect).constraintCount
  local unRewardLv = 0
  local targetRewardLv = 0
  for i = 1, count do
    local reverse = (i - 1) // oneLineLinit % 2 == 1
    if reverse then
      local oriIndex = (i - 1) // oneLineLinit * oneLineLinit
      local diff = (i - 1) % oneLineLinit
      -- DECOMPILER ERROR at PC41: Confused about usage of register: R14 in 'UnsetPending'

      ;
      (self._lvSort)[i] = oriIndex + oneLineLinit - diff
    else
      -- DECOMPILER ERROR at PC44: Confused about usage of register: R12 in 'UnsetPending'

      (self._lvSort)[i] = i
    end
    if (allCfg[i]).need_token <= itemCount then
      targetRewardLv = i
      if not (self._heroGrowData):IsHeroGrowLvReceived(i) then
        unRewardLv = i
      end
    end
  end
  if isGameDev and #self._lvSort ~= count then
    error("排序大错")
  end
  -- DECOMPILER ERROR at PC70: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.ui).shopList).totalCount = count
  if unRewardLv > 0 then
    ((self.ui).shopList):SrollToCell(unRewardLv - 1, 999)
  elseif targetRewardLv > 0 then
    ((self.ui).shopList):SrollToCell(targetRewardLv - 1, 999)
  else
    ((self.ui).shopList):RefillCells(0)
  end
  -- DECOMPILER ERROR: 8 unprocessed JMP targets
end

UICharDunShopVer2.__CreateItemLine = function(self, item)
  -- function num : 0_5 , upvalues : _ENV
  self:__CycleItemLine(item)
  local allCfg = (ConfigData.activity_hero_token_reward)[(self._heroGrowData):GetActId()]
  local lv = item:GetCharDunShopVer2Lv()
  if lv == #allCfg then
    return 
  end
  local itemCount = PlayerDataCenter:GetItemCount((self._heroGrowData):GetHeroGrowCostId())
  if self._horizeLineDic == nil then
    self._horizeLineDic = {}
    self._vertlineDic = {}
    self._tempLines = {}
    local cellSize = ((self.ui).rect).cellSize
    local spacing = ((self.ui).rect).spacing
    self._horizeUnit = cellSize.x + spacing.x
    self._point2LeftUnit = cellSize.x / 2 + (self.ui).leftOffset
    self._point2RightUnit = cellSize.x / 2 + (self.ui).rightOffset
    self._verUnit = cellSize.y + spacing.y
    self._lineLimit = ((self.ui).rect).constraintCount
    self._startOffset = (self.ui).pointOffset
  end
  do
    -- DECOMPILER ERROR at PC69: Confused about usage of register: R5 in 'UnsetPending'

    if (self._horizeLineDic)[item] == nil then
      (self._horizeLineDic)[item] = {}
      -- DECOMPILER ERROR at PC72: Confused about usage of register: R5 in 'UnsetPending'

      ;
      (self._vertlineDic)[item] = {}
    end
    local line = (lv - 1) // self._lineLimit
    local reverse = line % 2 == 1
    if lv % self._lineLimit ~= 0 then
      local line = (self._lineHorizePool):GetOne()
      ;
      (line.transform):SetParent(item.transform)
      ;
      (table.insert)((self._horizeLineDic)[item], line)
      local length = self._horizeUnit - self._startOffset * 2
      local startScore = (allCfg[lv]).need_token
      local endScore = (allCfg[lv + 1]).need_token
      line:InitCharDunShopVer2LineHorize(length, reverse, startScore, endScore)
      line:RefreshCharDunShopVer2Line(itemCount)
      if not reverse or not -self._startOffset then
        local startoffset = self._startOffset
      end
      item:SetChildHeroVer2HorizePointLine(line, startoffset)
    else
      local firstLine = (self._lineHorizePool):GetOne()
      ;
      (table.insert)((self._horizeLineDic)[item], firstLine)
      ;
      (table.insert)(self._tempLines, firstLine)
      if not reverse or not self._point2LeftUnit then
        local firstLenght = self._point2RightUnit - self._startOffset
        local secondLine = (self._lineVerticalPool):GetOne()
        ;
        (table.insert)((self._vertlineDic)[item], secondLine)
        ;
        (table.insert)(self._tempLines, secondLine)
        local secondLenght = self._verUnit
        local thridLine = (self._lineHorizePool):GetOne()
        ;
        (table.insert)((self._horizeLineDic)[item], thridLine)
        ;
        (table.insert)(self._tempLines, thridLine)
        if not reverse or not self._point2LeftUnit then
          local thridLenght = self._point2RightUnit - self._startOffset
          local startScore = (allCfg[lv]).need_token
          local endScore = (allCfg[lv + 1]).need_token
          local allLenght = firstLenght + secondLenght + thridLenght
          local scoreTemp1 = startScore + (endScore - startScore) / allLenght * firstLenght
          local scoreTemp2 = scoreTemp1 + (endScore - startScore) / allLenght * secondLenght
          firstLine:InitCharDunShopVer2LineHorize(firstLenght, reverse, startScore, scoreTemp1)
          firstLine:RefreshCharDunShopVer2Line(itemCount)
          secondLine:InitCharDunShopVer2LineVertial(secondLenght, false, scoreTemp1, scoreTemp2)
          secondLine:RefreshCharDunShopVer2Line(itemCount)
          thridLine:InitCharDunShopVer2LineHorize(thridLenght, not reverse, scoreTemp2, endScore)
          thridLine:RefreshCharDunShopVer2Line(itemCount)
          do
            if not reverse or not -self._startOffset then
              local startoffset = self._startOffset
            end
            item:SetChildHeroVer2NewLinePointLine(self._tempLines, startoffset)
            ;
            (table.removeall)(self._tempLines)
            -- DECOMPILER ERROR: 11 unprocessed JMP targets
          end
        end
      end
    end
  end
end

UICharDunShopVer2.__CycleItemLine = function(self, item)
  -- function num : 0_6 , upvalues : _ENV
  if self._horizeLineDic == nil then
    return 
  end
  local horizeLines = (self._horizeLineDic)[item]
  if horizeLines ~= nil then
    for i,line in ipairs(horizeLines) do
      (self._lineHorizePool):HideOne(line)
      line.parent = ((self.ui).lineHri).parent
    end
    ;
    (table.removeall)(horizeLines)
  end
  local vertLines = (self._vertlineDic)[item]
  if vertLines ~= nil then
    for i,line in ipairs(vertLines) do
      (self._lineVerticalPool):HideOne(line)
      line.parent = ((self.ui).lineVer).parent
    end
    ;
    (table.removeall)(vertLines)
  end
end

UICharDunShopVer2.RefreshCharDunShopVer2 = function(self)
  -- function num : 0_7 , upvalues : _ENV
  local itemCount = PlayerDataCenter:GetItemCount((self._heroGrowData):GetHeroGrowCostId())
  for k,v in pairs(self._itemDic) do
    v:RefreshCharDunShopVer2Item()
  end
  for i,v in ipairs((self._lineHorizePool).listItem) do
    v:RefreshCharDunShopVer2Line(itemCount)
  end
  for i,v in ipairs((self._lineVerticalPool).listItem) do
    v:RefreshCharDunShopVer2Line(itemCount)
  end
  -- DECOMPILER ERROR at PC39: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_TokenNum).text = tostring(itemCount)
  local allCfg = (ConfigData.activity_hero_token_reward)[(self._heroGrowData):GetActId()]
  local curLevel = 0
  local nextLvScore = 0
  for i,v in ipairs(allCfg) do
    if itemCount < v.need_token then
      nextLvScore = v.need_token
      break
    end
    curLevel = i
  end
  do
    -- DECOMPILER ERROR at PC65: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self.ui).tex_Lvl).text = tostring(curLevel)
    if nextLvScore == 0 then
      ((self.ui).text):SetIndex(1)
      -- DECOMPILER ERROR at PC75: Confused about usage of register: R5 in 'UnsetPending'

      ;
      ((self.ui).tex_Exp).text = "MAX"
    else
      ;
      ((self.ui).text):SetIndex(0)
      -- DECOMPILER ERROR at PC87: Confused about usage of register: R5 in 'UnsetPending'

      ;
      ((self.ui).tex_Exp).text = tostring(nextLvScore - itemCount)
    end
    ;
    (((self.ui).btn_GetAll).gameObject):SetActive((self._heroGrowData):IsHeroGrowExistLvReward())
  end
end

UICharDunShopVer2.__CountDown = function(self)
  -- function num : 0_8 , upvalues : _ENV
  local diff = (self._heroGrowData):GetActivityDestroyTime() - PlayerDataCenter.timestamp
  if diff < 0 then
    ((self.ui).tex_Day):SetIndex(3, "0")
    return 
  end
  local d, h, m, s = TimeUtil:TimestampToTimeInter(diff, false, true)
  if d > 0 then
    ((self.ui).tex_Day):SetIndex(1, tostring(d))
  else
    if h > 0 then
      ((self.ui).tex_Day):SetIndex(2, tostring(h))
    else
      if m > 0 then
        ((self.ui).tex_Day):SetIndex(3, tostring(m))
      else
        ;
        ((self.ui).tex_Day):SetIndex(3, "0")
      end
    end
  end
end

UICharDunShopVer2.__OnInstantiateItem = function(self, go)
  -- function num : 0_9 , upvalues : UINCharDunShopVer2Item
  local item = (UINCharDunShopVer2Item.New)()
  item:Init(go)
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self._itemDic)[go] = item
end

UICharDunShopVer2.__OnChangeItem = function(self, go, index)
  -- function num : 0_10 , upvalues : _ENV
  local item = (self._itemDic)[go]
  if item == nil then
    if isGameDev then
      error("scoreItem is nil " .. tostring(index))
    end
    return 
  end
  local lv = (self._lvSort)[index + 1]
  item:InitCharDunShopVer2Item(self._heroGrowData, lv, self.__OnRewardOneCallback)
  self:__CreateItemLine(item)
end

UICharDunShopVer2.__OnReturnItem = function(self, go)
  -- function num : 0_11
  local item = (self._itemDic)[go]
  self:__CycleItemLine(item)
end

UICharDunShopVer2.__ItemUpdate = function(self, updateItem)
  -- function num : 0_12
  if updateItem[(self._heroGrowData):GetHeroGrowCostId()] == nil then
    return 
  end
  self:RefreshCharDunShopVer2()
end

UICharDunShopVer2.__OnRewardOne = function(self, lv, item)
  -- function num : 0_13 , upvalues : _ENV
  if (self._heroGrowData):IsHeroGrowLvReceived(lv) then
    return 
  end
  local allCfg = (ConfigData.activity_hero_token_reward)[(self._heroGrowData):GetActId()]
  if allCfg[lv] == nil or PlayerDataCenter:GetItemCount((self._heroGrowData):GetHeroGrowCostId()) < (allCfg[lv]).need_token then
    return 
  end
  ;
  (self._heroGrowData):ReqHeroGrowSingleTokenReward(lv, function()
    -- function num : 0_13_0 , upvalues : _ENV, self
    if IsNull(self.transform) then
      return 
    end
    self:RefreshCharDunShopVer2()
  end
)
end

UICharDunShopVer2.OnClickRewardAll = function(self)
  -- function num : 0_14 , upvalues : _ENV
  if not (self._heroGrowData):IsHeroGrowExistLvReward() then
    return 
  end
  ;
  (self._heroGrowData):ReqHeroGrowAllTokenReward(function()
    -- function num : 0_14_0 , upvalues : _ENV, self
    if IsNull(self.transform) then
      return 
    end
    self:RefreshCharDunShopVer2()
  end
)
end

UICharDunShopVer2.OnClickCloseShopVer2 = function(self)
  -- function num : 0_15
  self:Delete()
  if self._callback then
    (self._callback)()
  end
end

UICharDunShopVer2.OnDelete = function(self)
  -- function num : 0_16 , upvalues : _ENV, base
  (self._resloader):Put2Pool()
  self._resloader = nil
  MsgCenter:RemoveListener(eMsgEventId.UpdateItem, self.__ItemUpdateCallback)
  TimerManager:StopTimer(self._timerId)
  self._timerId = nil
  ;
  (base.OnDelete)(self)
end

return UICharDunShopVer2

