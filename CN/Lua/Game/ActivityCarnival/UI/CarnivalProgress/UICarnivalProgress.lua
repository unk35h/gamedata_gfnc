-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseWindow
local UICarnivalProgress = class("UICarnivalProgress", base)
local UINCarnivalEmptyItem = require("Game.ActivityCarnival.UI.CarnivalProgress.UINCarnivalEmptyItem")
local cs_MessageCommon = CS.MessageCommon
local SectorStageDetailHelper = require("Game.Sector.SectorStageDetailHelper")
local cs_MessageCommon = CS.MessageCommon
UICarnivalProgress.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.SetTopStatus)(self, self._OnClickBack)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_ReceiveAll, self, self._OnClickGetAll)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Info, self, self._OnClickInfo)
  self._OnPickRewardLevelFunc = BindCallback(self, self._OnPickRewardLevel)
  self._OnPickCycleRewardFunc = BindCallback(self, self._OnPickCycleReward)
  -- DECOMPILER ERROR at PC35: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).scrollRect).onInstantiateItem = BindCallback(self, self.__OnNewItem)
  -- DECOMPILER ERROR at PC42: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).scrollRect).onChangeItem = BindCallback(self, self.__OnChangeItem)
  self._ItemDic = {}
  self._OnExpLevelChnageFunc = BindCallback(self, self._OnExpLevelChnage)
  MsgCenter:AddListener(eMsgEventId.ActivityCarnivalExpLevelChange, self._OnExpLevelChnageFunc)
  self._OnJumpItemCallback = BindCallback(self, self._OnJumpItem)
end

UICarnivalProgress.BindCarnivalJumpEnvFunc = function(self, func)
  -- function num : 0_1
  self._jumpEnvFunc = func
end

UICarnivalProgress.BindCarnivalJumpSectorStageFunc = function(self, func)
  -- function num : 0_2
  self._jumpSectorStageFunc = func
end

UICarnivalProgress.InitCarnivalProgress = function(self, carnivalData, callback)
  -- function num : 0_3
  self._carnivalData = carnivalData
  self:_UpdExpLevel(carnivalData)
  self:_RefillScrollRect()
  self._callback = callback
end

UICarnivalProgress._UpdExpLevel = function(self, carnivalData)
  -- function num : 0_4 , upvalues : _ENV
  local curlevel, exp = carnivalData:GetCarnivalLevelExp()
  self._curlevel = curlevel
  ;
  ((self.ui).tex_Level):SetIndex(0, tostring(curlevel))
  local cnvExpCfg = carnivalData:GetCarnivalExpCfg()
  local maxLv = carnivalData:GetCarnivalMaxLevel()
  local levelDataList = {}
  for i = 1, maxLv do
    local expCfg = cnvExpCfg[i]
    if expCfg == nil then
      error("Cant get CarnivalExpCfg, level = " .. tostring(i))
    else
      ;
      (table.insert)(levelDataList, {level = i, carnivalExpCfg = expCfg, curLevel = curlevel, curExp = exp, maxLevel = maxLv})
    end
  end
  self.levelDataList = levelDataList
  self:_UpdPickAll()
end

UICarnivalProgress._RefillScrollRect = function(self)
  -- function num : 0_5 , upvalues : _ENV
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R1 in 'UnsetPending'

  ((self.ui).scrollRect).totalCount = #self.levelDataList + 1
  if ((self.ui).scrollRect).totalCount - 4 < self._curlevel then
    ((self.ui).scrollRect):RefillCellsFromEnd()
  else
    local offsetIndex = (math.max)(self._curlevel - 4, 0)
    ;
    ((self.ui).scrollRect):RefillCells(offsetIndex)
  end
  do
    ;
    ((self.ui).scrollRect):RefreshCells()
  end
end

UICarnivalProgress._UpdateScrollRect = function(self)
  -- function num : 0_6
  ((self.ui).scrollRect):RefreshCells()
end

UICarnivalProgress._UpdPickAll = function(self)
  -- function num : 0_7 , upvalues : _ENV
  local pickableAll = false
  for i = 1, self._curlevel do
    if not (self._carnivalData):IsReceivedLevelReward(i) then
      pickableAll = true
      break
    end
  end
  do
    if not pickableAll then
      pickableAll = (self._carnivalData):IsCanCarnivalCycleReward()
    end
    -- DECOMPILER ERROR at PC31: Confused about usage of register: R2 in 'UnsetPending'

    if not pickableAll or not Color.white then
      (((self.ui).btn_ReceiveAll).targetGraphic).color = Color.gray
      self._pickableAll = pickableAll
    end
  end
end

UICarnivalProgress.__OnNewItem = function(self, go)
  -- function num : 0_8 , upvalues : UINCarnivalEmptyItem
  local item = (UINCarnivalEmptyItem.New)()
  item:Init(go)
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self._ItemDic)[go] = item
end

UICarnivalProgress.__OnChangeItem = function(self, go, index)
  -- function num : 0_9 , upvalues : _ENV
  local item = (self._ItemDic)[go]
  if item == nil then
    error("Can\'t find item by gameObject")
    return 
  end
  if index + 1 <= #self.levelDataList then
    local levelData = (self.levelDataList)[index + 1]
    if levelData == nil then
      error("Can\'t find levelData by index, index = " .. tonumber(index))
    end
    local isGetReward = (self._carnivalData):IsReceivedLevelReward(levelData.level)
    item:InitCarnivalNormalItem(self._carnivalData, levelData, isGetReward, self._OnPickRewardLevelFunc, self._OnJumpItemCallback)
  else
    do
      item:InitCarnivalCycleItem(self._carnivalData, self._OnPickCycleRewardFunc)
    end
  end
end

UICarnivalProgress._OnPickRewardLevel = function(self, level)
  -- function num : 0_10 , upvalues : _ENV
  (self._carnivalData):ReqCarnivalLevelReward(level, function()
    -- function num : 0_10_0 , upvalues : _ENV, self
    if not IsNull(self.transform) then
      self:_OnPickReward()
    end
  end
)
end

UICarnivalProgress._OnPickCycleReward = function(self)
  -- function num : 0_11 , upvalues : _ENV
  (self._carnivalData):ReqCarnivalCycleReward(function()
    -- function num : 0_11_0 , upvalues : _ENV, self
    if not IsNull(self.transform) then
      self:_OnPickReward()
    end
  end
)
end

UICarnivalProgress._OnClickGetAll = function(self)
  -- function num : 0_12 , upvalues : cs_MessageCommon, _ENV
  if not self._pickableAll then
    (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(7117))
    return 
  end
  ;
  (self._carnivalData):ReqCarnivalAllReward(function()
    -- function num : 0_12_0 , upvalues : _ENV, self
    if not IsNull(self.transform) then
      self:_OnPickReward()
    end
  end
)
end

UICarnivalProgress._OnJumpItem = function(self, levelData)
  -- function num : 0_13 , upvalues : cs_MessageCommon, _ENV, SectorStageDetailHelper
  if levelData.curLevel < levelData.level then
    (cs_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(7122, tostring(levelData.level)))
    return 
  end
  local envId = (((ConfigData.activity_carnival_env).levelEnvDic)[(self._carnivalData):GetActId()])[levelData.level]
  if envId or 0 > 0 then
    if not (self._carnivalData):IsActivityRunning() then
      return 
    end
    local sectorId = ((self._carnivalData):GetCarnivalMainCfg()).main_stage
    do
      do
        if (SectorStageDetailHelper.IsSectorHasUnComplete)(sectorId) or not (SectorStageDetailHelper.IsSectorNoCollide)(sectorId) then
          local playerModule = (SectorStageDetailHelper.SectorPlayMoudle)(sectorId)
          ;
          (SectorStageDetailHelper.TryToShowCurrentLevelTips)(playerModule)
          return 
        end
        if self._jumpEnvFunc ~= nil then
          (self._jumpEnvFunc)(envId)
        end
        -- DECOMPILER ERROR at PC73: Unhandled construct in 'MakeBoolean' P1

        if (levelData.carnivalExpCfg).unlock_story > 0 and self._jumpSectorStageFunc ~= nil then
          (self._jumpSectorStageFunc)((levelData.carnivalExpCfg).unlock_story, true)
        end
        if (levelData.carnivalExpCfg).unlock_sector_stage > 0 and self._jumpSectorStageFunc ~= nil then
          (self._jumpSectorStageFunc)((levelData.carnivalExpCfg).unlock_sector_stage, false)
        end
      end
    end
  end
end

UICarnivalProgress._OnPickReward = function(self)
  -- function num : 0_14
  self:_UpdPickAll()
  self:_UpdateScrollRect()
end

UICarnivalProgress._OnClickInfo = function(self)
  -- function num : 0_15 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.Carnival22InfoWindow, function(win)
    -- function num : 0_15_0 , upvalues : self
    if win == nil then
      return 
    end
    win:InitCarnivalInfoWindow(((self._carnivalData):GetCarnivalMainCfg()).exp_rule_id)
  end
)
end

UICarnivalProgress._OnExpLevelChnage = function(self)
  -- function num : 0_16
  self:_UpdExpLevel(self._carnivalData)
  self:_UpdateScrollRect()
end

UICarnivalProgress._OnClickBack = function(self)
  -- function num : 0_17
  self:Delete()
  if self._callback then
    (self._callback)()
  end
end

UICarnivalProgress.OnDelete = function(self)
  -- function num : 0_18 , upvalues : _ENV, base
  for k,v in pairs(self._ItemDic) do
    v:Delete()
  end
  MsgCenter:RemoveListener(eMsgEventId.ActivityCarnivalExpLevelChange, self._OnExpLevelChnageFunc)
  ;
  (base.OnDelete)(self)
end

return UICarnivalProgress

