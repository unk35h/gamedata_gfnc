-- params : ...
-- function num : 0 , upvalues : _ENV
local UIDailyDungeonMain = class("UIDailyDungeonMain", UIBaseWindow)
local base = UIBaseWindow
local UINDailyLevelDifItem = require("Game.DailyDungeon.UI.LevelSelect.UINDailyLevelDifItem")
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
local eDungeonEnum = require("Game.Dungeon.eDungeonEnum")
local UINDailyDungeonQuickBattle = require("Game.DailyDungeon.UI.LevelSelect.UINDailyDungeonQuickBattle")
local cs_MessageCommon = CS.MessageCommon
UIDailyDungeonMain.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINDailyLevelDifItem
  self.lvDifItemList = {}
  for k,holder in ipairs((self.ui).lvDifItemPosList) do
    local lvDifItem = (UINDailyLevelDifItem.New)()
    local go = ((self.ui).lvDifItem):Instantiate(holder)
    -- DECOMPILER ERROR at PC17: Confused about usage of register: R8 in 'UnsetPending'

    ;
    (go.transform).anchoredPosition = Vector2.zero
    lvDifItem:Init(go)
    ;
    (table.insert)(self.lvDifItemList, lvDifItem)
  end
  ;
  ((self.ui).lvDifItem):SetActive(false)
  self._OnSelectDiffFunc = BindCallback(self, self._OnSelectDiff)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Shop, self, self.__OnClickDailyShop)
  ;
  (((self.ui).tex_RefreshTime).gameObject):SetActive(false)
  ;
  (UIUtil.SetTopStatus)(self, self._OnClickBack)
  self._UpdateActivityDoubleRewardFunc = BindCallback(self, self._UpdateActivityDoubleReward)
  MsgCenter:AddListener(eMsgEventId.ActivityShowChange, self._UpdateActivityDoubleRewardFunc)
end

UIDailyDungeonMain.InitDailyDungeonMain = function(self, dailyDgCtrl, openCurDiff)
  -- function num : 0_1 , upvalues : _ENV
  self.dailyDgCtrl = dailyDgCtrl
  local dungeonDyncElem = (PlayerDataCenter.dungeonDyncData):GetDailyDungeonDyncData()
  self.dungeonDyncElem = dungeonDyncElem
  local isNew = dungeonDyncElem.isDailyDungeonNew
  self._isNewStart = isNew
  ;
  ((self.ui).tex_Count):SetIndex(isNew and 1 or 0)
  self:_UpdItem(openCurDiff)
  self:_UpdateActivityDoubleReward()
end

UIDailyDungeonMain._UpdateActivityDoubleReward = function(self)
  -- function num : 0_2 , upvalues : _ENV, ActivityFrameEnum
  local isDouble = (self.dungeonDyncElem):DgDyncIsHaveMultReward()
  ;
  ((self.ui).obj_double):SetActive(isDouble)
  self.__activityDestoryTime = nil
  ;
  (((self.ui).tex_DoubleTimeLeft).gameObject):SetActive(false)
  if isDouble then
    local curActivityDic = ((PlayerDataCenter.playerBonus):GetDungeonMultRewardCurActivityIdDic(proto_csmsg_DungeonType.DungeonType_Daily))
    -- DECOMPILER ERROR at PC23: Overwrote pending register: R3 in 'AssignReg'

    local activityId = .end
    for id,_ in pairs(curActivityDic) do
      activityId = id
      do break end
    end
    do
      if activityId == nil then
        error("activityId == nil")
        return 
      end
      local activivityCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
      local actData = activivityCtrl:GetActivityFrameDataByTypeAndId((ActivityFrameEnum.eActivityType).DungeonDouble, activityId)
      if actData == nil then
        error("actData == nil")
        return 
      end
      self.__activityDestoryTime = actData:GetActivityDestroyTime()
    end
  end
end

UIDailyDungeonMain._UpdItem = function(self, openCurDiff)
  -- function num : 0_3 , upvalues : _ENV, eDungeonEnum
  local dungeonUITypeDic = (ConfigData.material_dungeon).dungeonUITypeDic
  local dungeonIdList = dungeonUITypeDic[(eDungeonEnum.eDungeonType).DailyDungeon]
  if dungeonIdList == nil then
    error("Cant get dungeonUITypeDic, eDungeonEnum.eDungeonType.DailyDungeon")
    return 
  end
  for index,lvDifItem in pairs(self.lvDifItemList) do
    lvDifItem:Hide()
  end
  local OnClickQuickDungeonBind = BindCallback(self, self.OnClickQuickDungeon)
  for k,dungeonId in ipairs(dungeonIdList) do
    local matDungeonCfg = (ConfigData.material_dungeon)[dungeonId]
    local dungeonDyncElem = nil
    if not self._isNewStart and (self.dungeonDyncElem).moduleId == dungeonId then
      dungeonDyncElem = self.dungeonDyncElem
      if openCurDiff then
        self:_OnSelectDiff(matDungeonCfg)
      end
    end
    local lvDifItem = (self.lvDifItemList)[k]
    if lvDifItem ~= nil then
      lvDifItem:Show()
      lvDifItem:InitDailyLevelDifItem(k, matDungeonCfg, self._OnSelectDiffFunc, dungeonDyncElem)
      lvDifItem:BindQuickBattleFunc(OnClickQuickDungeonBind)
    end
  end
end

UIDailyDungeonMain.UpdDailyDgMainTime = function(self, dInt, hStr, mStr, sStr)
  -- function num : 0_4 , upvalues : _ENV
  (((self.ui).tex_RefreshTime).gameObject):SetActive(true)
  if dInt > 0 then
    ((self.ui).tex_RefreshTime):SetIndex(0, tostring(dInt), hStr, mStr, sStr)
  else
    ;
    ((self.ui).tex_RefreshTime):SetIndex(1, hStr, mStr, sStr)
  end
  if self.__activityDestoryTime ~= nil then
    local remaindTime = self.__activityDestoryTime - PlayerDataCenter.timestamp
    local d, h, m, s = TimeUtil:TimestampToTimeInter(remaindTime, false, true)
    ;
    (((self.ui).tex_DoubleTimeLeft).gameObject):SetActive(true)
    if d > 0 then
      ((self.ui).tex_DoubleTimeLeft):SetIndex(0, tostring(d), (string.format)("%02d:%02d:%02d", tostring(h), tostring(m), tostring(s)))
    else
      ;
      ((self.ui).tex_DoubleTimeLeft):SetIndex(1, (string.format)("%02d:%02d:%02d", tostring(h), tostring(m), tostring(s)))
    end
  end
end

UIDailyDungeonMain._OnSelectDiff = function(self, matDungeonCfg)
  -- function num : 0_5 , upvalues : cs_MessageCommon, _ENV
  if not self._isNewStart and matDungeonCfg.id ~= (self.dungeonDyncElem).moduleId then
    (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(2901))
    return 
  end
  local unlock = FunctionUnlockMgr:ValidateUnlock(matDungeonCfg.id)
  do
    if not unlock then
      local tips = FunctionUnlockMgr:GetFuncUnlockDecription(matDungeonCfg.id)
      ;
      (cs_MessageCommon.ShowMessageTipsWithErrorSound)(tips)
      return 
    end
    UIManager:ShowWindowAsync(UIWindowTypeID.DailyDungeonLevel, function(win)
    -- function num : 0_5_0 , upvalues : self, matDungeonCfg
    if win == nil then
      return 
    end
    win:InitDailyDungeonLevel(self.dailyDgCtrl, matDungeonCfg, self._isNewStart, self.dungeonDyncElem)
  end
)
  end
end

UIDailyDungeonMain.OnClickQuickDungeon = function(self, matDungeonCfg)
  -- function num : 0_6 , upvalues : _ENV, cs_MessageCommon, UINDailyDungeonQuickBattle
  if not PlayerDataCenter:IsDungeonModuleOpenQuick(matDungeonCfg.id) then
    (cs_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(9309))
    return 
  end
  local battleDyncElem = (PlayerDataCenter.dungeonDyncData):GetDailyDungeonDyncData()
  local canQuick = battleDyncElem:IsDailyModuleCanQuick(matDungeonCfg.id)
  if not canQuick then
    (cs_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(2901))
    return 
  end
  local applyFunc = function()
    -- function num : 0_6_0 , upvalues : battleDyncElem, _ENV, matDungeonCfg, self, UINDailyDungeonQuickBattle
    local index = battleDyncElem.isDailyDungeonNew and 0 or battleDyncElem.idx
    ;
    (NetworkManager:GetNetwork(NetworkTypeID.BattleDungeon)):CS_DailyDungeon_Quick(matDungeonCfg.id, function(args)
      -- function num : 0_6_0_0 , upvalues : _ENV, self, UINDailyDungeonQuickBattle, matDungeonCfg, index
      if args == nil or args.Count == 0 then
        if isGameDev then
          error("args.Count == 0")
        end
        return 
      end
      local msg = args[0]
      local dungeonElems = msg.dungeonElem
      if self._quickResNode == nil then
        ((self.ui).quickWindowNode):SetActive(true)
        self._quickResNode = (UINDailyDungeonQuickBattle.New)()
        ;
        (self._quickResNode):Init((self.ui).quickWindowNode)
      else
        ;
        (self._quickResNode):Show()
      end
      ;
      (self._quickResNode):InitDailyQuickBattle(matDungeonCfg, index + 1, dungeonElems)
    end
)
  end

  if not battleDyncElem.isDailyDungeonNew then
    applyFunc()
  else
    local tip = ConfigData:GetTipContent(2900, (LanguageUtil.GetLocaleText)(matDungeonCfg.name))
    ;
    (cs_MessageCommon.ShowMessageBox)(tip, applyFunc, nil)
  end
end

UIDailyDungeonMain._OnClickBack = function(self, toHome)
  -- function num : 0_7
  (self.dailyDgCtrl):ExitDailyDungeon(toHome)
end

UIDailyDungeonMain.__OnClickDailyShop = function(self)
  -- function num : 0_8
  (self.dailyDgCtrl):OpenDailyDungeonShop()
end

UIDailyDungeonMain.OnDelete = function(self)
  -- function num : 0_9 , upvalues : _ENV, base
  for k,v in ipairs(self.lvDifItemList) do
    v:Delete()
  end
  if self._quickResNode ~= nil then
    (self._quickResNode):Delete()
  end
  UIManager:DeleteWindow(UIWindowTypeID.DailyDungeonLevel)
  MsgCenter:RemoveListener(eMsgEventId.ActivityShowChange, self._UpdateActivityDoubleRewardFunc)
  ;
  (base.OnDelete)(self)
end

return UIDailyDungeonMain

