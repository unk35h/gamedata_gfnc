-- params : ...
-- function num : 0 , upvalues : _ENV
local UICommonActivityRepeatDungeon = class("UICommonActivityRepeatDungeon", UIBaseWindow)
local base = UIBaseWindow
local UINCommonActivityBG = require("Game.ActivityFrame.UI.UINCommonActivityBG")
local UINCommonActRepeatDunItem = require("Game.ActivityFrame.UI.UINCommonActRepeatDunItem")
local cs_ResLoader = CS.ResLoader
UICommonActivityRepeatDungeon.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINCommonActivityBG, cs_ResLoader, UINCommonActRepeatDunItem
  (UIUtil.SetTopStatus)(self, self.CloseRepeatDungeon)
  self._bgNode = (UINCommonActivityBG.New)()
  ;
  (self._bgNode):Init((self.ui).uI_CommonActivityBG)
  self._resloader = (cs_ResLoader.Create)()
  self._itemPool = (UIItemPool.New)(UINCommonActRepeatDunItem, (self.ui).item)
  ;
  ((self.ui).item):SetActive(false)
  ;
  ((self.ui).obj_OnSelect):SetActive(false)
  self.__OnSelectDungeon = BindCallback(self, self.OnSelectDungeon)
end

UICommonActivityRepeatDungeon.InitActivityRepeatDungeon = function(self, actDungeonLevelCollect, callback)
  -- function num : 0_1
  self._actDungeonLevelCollect = actDungeonLevelCollect
  self._callback = callback
  local actBase = (self._actDungeonLevelCollect):GetActDungeonActBase()
  ;
  (self._bgNode):InitActivityBG(actBase:GetActFrameId(), self._resloader)
  local cnName, enName = (self._actDungeonLevelCollect):GetActDungeonTitle()
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).tex_CNTitleName).text = cnName
  -- DECOMPILER ERROR at PC19: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).tex_ENTitleName).text = enName
  self:__CreateDungeonItemNode()
end

UICommonActivityRepeatDungeon.__CreateDungeonItemNode = function(self)
  -- function num : 0_2 , upvalues : _ENV
  (self._itemPool):HideAll()
  ;
  ((self.ui).obj_OnSelect):SetActive(false)
  local dungeonlist = (self._actDungeonLevelCollect):GetActDungeonSortList()
  local posTrIndexDic = {}
  for i,posObj in ipairs((self.ui).posObjs) do
    local dungeonLevelData = dungeonlist[i]
    if dungeonLevelData == nil then
      posObj:SetActive(false)
    else
      posObj:SetActive(true)
      posTrIndexDic[posObj.transform] = i
      local item = (self._itemPool):GetOne(true)
      item:InitActRepeatDunItem(dungeonLevelData, i, self.__OnSelectDungeon, self._resloader)
      ;
      (item.transform):SetParent(posObj.transform)
      -- DECOMPILER ERROR at PC46: Confused about usage of register: R10 in 'UnsetPending'

      ;
      (item.transform).anchoredPosition = Vector2.zero
    end
  end
  for _,img in ipairs((self.ui).lineImgArray) do
    local index = posTrIndexDic[(img.transform).parent]
    if index ~= nil then
      local unlock = (dungeonlist[index]):GetIsLevelUnlock()
      if not unlock or not (self.ui).color_unlock then
        do
          img.color = (self.ui).color_locked
          -- DECOMPILER ERROR at PC71: LeaveBlock: unexpected jumping out IF_THEN_STMT

          -- DECOMPILER ERROR at PC71: LeaveBlock: unexpected jumping out IF_STMT

          -- DECOMPILER ERROR at PC71: LeaveBlock: unexpected jumping out IF_THEN_STMT

          -- DECOMPILER ERROR at PC71: LeaveBlock: unexpected jumping out IF_STMT

        end
      end
    end
  end
end

UICommonActivityRepeatDungeon.OnSelectDungeon = function(self, dungeonLevelData, item)
  -- function num : 0_3 , upvalues : _ENV
  if self._selectDungeon == dungeonLevelData then
    return 
  end
  self._selectDungeon = dungeonLevelData
  ;
  ((self.ui).obj_OnSelect):SetActive(true)
  ;
  (((self.ui).obj_OnSelect).transform):SetParent(item.transform)
  -- DECOMPILER ERROR at PC21: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (((self.ui).obj_OnSelect).transform).anchoredPosition = Vector2.zero
  UIManager:ShowWindowAsync(UIWindowTypeID.DungeonLevelDetail, function(window)
    -- function num : 0_3_0 , upvalues : self, item
    window:SetDunLevelDetaiHideStartEvent(function()
      -- function num : 0_3_0_0 , upvalues : self
      self:__PlayMoveLeftTween(false)
      self._selectDungeon = nil
      ;
      ((self.ui).obj_OnSelect):SetActive(false)
    end
)
    local width, duration = window:GetDLevelDetailWidthAndDuration()
    self:__PlayMoveLeftTween(true, width, (((item.transform).parent).localPosition).x, duration)
    window:InitDungeonLevelDetail(self._selectDungeon, not (self._selectDungeon):GetIsLevelUnlock())
    window:SetDungeonLevelBgClose(true)
  end
)
end

local BgX = (UIManager.BackgroundStretchSize).x
local n = BgX * (((CS.UIManager).Instance).CurNotchValue / 100)
UICommonActivityRepeatDungeon.__PlayMoveLeftTween = function(self, isLeft, offset, pointX, duration)
  -- function num : 0_4 , upvalues : BgX, _ENV
  ((self.ui).moveTarget):DOKill()
  if not isLeft then
    ((self.ui).moveTarget):DOLocalMoveX(0, self.duration)
    self.duration = 0
    return 
  end
  local target = -(BgX - offset) / 2
  local move = target - pointX
  move = (math.clamp)(move, -offset, 0)
  ;
  ((self.ui).moveTarget):DOLocalMoveX(move, duration)
  self.duration = duration
end

UICommonActivityRepeatDungeon.CloseRepeatDungeon = function(self, toHome)
  -- function num : 0_5
  self:Delete()
  if self._callback ~= nil then
    (self._callback)()
  end
end

UICommonActivityRepeatDungeon.OnDelete = function(self)
  -- function num : 0_6 , upvalues : base
  if self._resLoader ~= nil then
    (self._resLoader):Put2Pool()
    self._resLoader = nil
  end
  ;
  (base.OnDelete)(self)
end

return UICommonActivityRepeatDungeon

