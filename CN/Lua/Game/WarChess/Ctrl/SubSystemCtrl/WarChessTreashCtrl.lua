-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.WarChess.Ctrl.SubSystemCtrl.Base.WarChessSubSystemCtrlBase")
local WarChessTreashCtrl = class("WarChessTreashCtrl", base)
local ChipData = require("Game.PlayerData.Item.ChipData")
local WarChessBuffData = require("Game.WarChess.Data.WarChessBuffData")
WarChessTreashCtrl.ctor = function(self, wcCtrl)
  -- function num : 0_0 , upvalues : _ENV
  self.__boxSystemData = nil
  self.__identify = nil
  self.__treasureChipDataList = nil
  self.__WCSSTreasureChipSelectAlg = BindCallback(self, self.WCSSTreasureChipSelectAlg)
  self.__WCSSTreasureRefreshChip = BindCallback(self, self.WCSSTreasureRefreshChip)
  self.__WCSSTreasureChipExitWithOutPic = BindCallback(self, self.WCSSTreasureChipExitWithOutPick)
end

WarChessTreashCtrl.__GetWCSubSystemCat = function(self)
  -- function num : 0_1 , upvalues : _ENV
  local eWarChessEnum = require("Game.WarChess.eWarChessEnum")
  return (eWarChessEnum.eSystemCat).treash
end

WarChessTreashCtrl.OpenWCSubSystem = function(self, systemState, identify)
  -- function num : 0_2 , upvalues : _ENV
  if systemState == nil or systemState.boxSystemData == nil then
    error("not have data")
    return 
  end
  self.__boxSystemData = systemState.boxSystemData
  self.__identify = identify
  self.__curTeamData = ((self.wcCtrl).teamCtrl):GetTeamDataByTeamUid(identify.tid)
  self:__DealTreasureData((self.__boxSystemData).algList)
  local teamDataDic = ((self.wcCtrl).teamCtrl):GetWCTeams()
  UIManager:ShowWindowAsync(UIWindowTypeID.WarChessSelectChip, function(wcChipWindow)
    -- function num : 0_2_0 , upvalues : self, teamDataDic
    wcChipWindow:InitWCSelectChip(self.__treasureChipDataList, teamDataDic, self.__WCSSTreasureChipSelectAlg)
    wcChipWindow:InitWCSelectChipRefresh(self.__WCSSTreasureRefreshChip, (self.__boxSystemData).refreshTime)
    wcChipWindow:InitWCSelectChipSkip(self.__WCSSTreasureChipExitWithOutPic)
  end
)
end

WarChessTreashCtrl.__DealTreasureData = function(self, algList)
  -- function num : 0_3 , upvalues : _ENV, ChipData
  self.__treasureChipDataList = {}
  if algList ~= nil then
    for index,algId in ipairs(algList) do
      local data = (ChipData.NewChipForServer)(algId)
      ;
      (table.insert)(self.__treasureChipDataList, data)
    end
  end
end

WarChessTreashCtrl.WCSSTreasureChipSelectAlg = function(self, index, teamData)
  -- function num : 0_4 , upvalues : _ENV
  local tid = teamData:GetWCTeamId()
  ;
  ((self.wcCtrl).wcNetworkCtrl):CS_WarChess_BoxSystem_SelectAlg(self.__identify, index - 1, tid, function()
    -- function num : 0_4_0 , upvalues : self, _ENV
    self:_WCSTTryShowBuff()
    UIManager:DeleteWindow(UIWindowTypeID.WarChessSelectChip)
  end
)
end

WarChessTreashCtrl.WCSSTreasureRefreshChip = function(self)
  -- function num : 0_5 , upvalues : _ENV
  ((self.wcCtrl).wcNetworkCtrl):CS_WarChess_BoxSystem_RefreshAlg(self.__identify, function(args)
    -- function num : 0_5_0 , upvalues : self, _ENV
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

WarChessTreashCtrl.WCSSTreasureChipExitWithOutPick = function(self, callback)
  -- function num : 0_6
  ((self.wcCtrl).wcNetworkCtrl):CS_WarChess_BoxSystem_DropAlg(self.__identify, function()
    -- function num : 0_6_0 , upvalues : callback, self
    if callback ~= nil then
      callback()
    end
    self:_WCSTTryShowBuff()
  end
)
end

WarChessTreashCtrl._WCSTTryShowBuff = function(self)
  -- function num : 0_7 , upvalues : _ENV, WarChessBuffData
  if #(self.__boxSystemData).propChips <= 0 then
    return 
  end
  local buffList = {}
  for k,id in pairs((self.__boxSystemData).propChips) do
    local wcsBuffData = (WarChessBuffData.CrearteBuffById)(id)
    ;
    (table.insert)(buffList, wcsBuffData)
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.EpBuffDesc, function(win)
    -- function num : 0_7_0 , upvalues : buffList
    win:InitWCBuffDesc(buffList, nil, 3)
  end
)
end

WarChessTreashCtrl.CloseWCSubSystem = function(self, isSwitchClose)
  -- function num : 0_8 , upvalues : base, _ENV
  (base.CloseWCSubSystem)()
  if isSwitchClose then
    UIManager:DeleteWindow(UIWindowTypeID.WarChessSelectChip)
  end
  self.__treasureChipDataList = nil
  self.__boxSystemData = nil
  self.__identify = nil
end

WarChessTreashCtrl.Delete = function(self)
  -- function num : 0_9
end

return WarChessTreashCtrl

