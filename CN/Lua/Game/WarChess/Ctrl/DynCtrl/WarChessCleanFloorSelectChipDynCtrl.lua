-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.WarChess.Ctrl.Base.WarChessCtrlBase")
local WarChessCleanFloorSelectChipDynCtrl = class("WarChessCleanFloorSelectChipDynCtrl", base)
local ChipData = require("Game.PlayerData.Item.ChipData")
WarChessCleanFloorSelectChipDynCtrl.ctor = function(self, wcCtrl)
  -- function num : 0_0 , upvalues : _ENV
  self.__boxSystemData = nil
  self.__identify = nil
  self.__treasureChipDataList = nil
  self.__WCSSTreasureChipSelectAlg = BindCallback(self, self.WCSSTreasureChipSelectAlg)
  self.__WCSSTreasureRefreshChip = BindCallback(self, self.WCSSTreasureRefreshChip)
  self.__WCSSTreasureChipExitWithOutPic = BindCallback(self, self.WCSSTreasureChipExitWithOutPick)
end

WarChessCleanFloorSelectChipDynCtrl.OpenCleanFloorRewardSelect = function(self, boxSystemData, closeCallback)
  -- function num : 0_1 , upvalues : _ENV
  self.__boxSystemData = boxSystemData
  self.__closeCallback = closeCallback
  self:__DealTreasureData((self.__boxSystemData).algList)
  local teamDataDic = ((self.wcCtrl).teamCtrl):GetWCTeams()
  for _,teamData in pairs(teamDataDic) do
    local wid, tid = ((self.wcCtrl).teamCtrl):GetWCTeamIdentify(teamData)
    self.__identify = {wid = wid, tid = tid}
    do break end
  end
  do
    UIManager:ShowWindowAsync(UIWindowTypeID.WarChessSelectChip, function(wcChipWindow)
    -- function num : 0_1_0 , upvalues : self, teamDataDic
    wcChipWindow:InitWCSelectChip(self.__treasureChipDataList, teamDataDic, self.__WCSSTreasureChipSelectAlg)
    wcChipWindow:InitWCSelectChipRefresh(self.__WCSSTreasureRefreshChip, (self.__boxSystemData).refreshTime)
    wcChipWindow:InitWCSelectChipSkip(self.__WCSSTreasureChipExitWithOutPic)
  end
)
  end
end

WarChessCleanFloorSelectChipDynCtrl.__DealTreasureData = function(self, algList)
  -- function num : 0_2 , upvalues : _ENV, ChipData
  self.__treasureChipDataList = {}
  if algList ~= nil then
    for index,algId in ipairs(algList) do
      local data = (ChipData.NewChipForServer)(algId)
      ;
      (table.insert)(self.__treasureChipDataList, data)
    end
  end
end

WarChessCleanFloorSelectChipDynCtrl.WCSSTreasureChipSelectAlg = function(self, index, teamData)
  -- function num : 0_3
  local tid = teamData:GetWCTeamId()
  ;
  ((self.wcCtrl).wcNetworkCtrl):CS_WarChess_OverReward_SelectAlg(self.__identify, index - 1, tid, function()
    -- function num : 0_3_0 , upvalues : self
    self:CloseWCDynCtrl()
  end
)
end

WarChessCleanFloorSelectChipDynCtrl.WCSSTreasureRefreshChip = function(self)
  -- function num : 0_4 , upvalues : _ENV
  ((self.wcCtrl).wcNetworkCtrl):CS_WarChess_OverReward_RefreshAlg(self.__identify, function(args)
    -- function num : 0_4_0 , upvalues : self, _ENV
    if args.Count <= 0 then
      return 
    end
    local msg = args[0]
    local algList = msg.algList
    local refeshTime = msg.refeshTime
    self:__DealTreasureData(algList)
    local wcChipWindow = UIManager:GetWindow(UIWindowTypeID.WarChessSelectChip)
    if wcChipWindow ~= nil then
      local teamDataDic = ((self.wcCtrl).teamCtrl):GetWCTeams()
      wcChipWindow:InitWCSelectChip(self.__treasureChipDataList, teamDataDic, self.__WCSSTreasureChipSelectAlg)
      wcChipWindow:UpdateWCSelectChipRefreshInfo()
      wcChipWindow:UpdateWCSelectChipSkipInfo()
    end
  end
)
end

WarChessCleanFloorSelectChipDynCtrl.WCSSTreasureChipExitWithOutPick = function(self, callback)
  -- function num : 0_5
  ((self.wcCtrl).wcNetworkCtrl):CS_WarChess_OverReward_DropAlg(self.__identify, function()
    -- function num : 0_5_0 , upvalues : callback, self
    if callback ~= nil then
      callback()
    end
    self:CloseWCDynCtrl()
  end
)
end

WarChessCleanFloorSelectChipDynCtrl.CloseWCDynCtrl = function(self)
  -- function num : 0_6 , upvalues : _ENV
  UIManager:DeleteWindow(UIWindowTypeID.WarChessSelectChip)
  ;
  (UIUtil.CloseOneCover)("UISelectChip")
  self.__treasureChipDataList = nil
  self.__boxSystemData = nil
  self.__identify = nil
  if self.__closeCallback ~= nil then
    (self.__closeCallback)()
  end
end

WarChessCleanFloorSelectChipDynCtrl.Delete = function(self)
  -- function num : 0_7
end

return WarChessCleanFloorSelectChipDynCtrl

