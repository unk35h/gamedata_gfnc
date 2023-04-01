-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.WarChess.Ctrl.SubSystemCtrl.Base.WarChessSubSystemCtrlBase")
local WarChessSelectChipCtrl = class("WarChessSelectChipCtrl", base)
local ChipData = require("Game.PlayerData.Item.ChipData")
WarChessSelectChipCtrl.ctor = function(self, wcCtrl)
  -- function num : 0_0 , upvalues : _ENV
  self.__selectTeamForAlgSystemData = nil
  self.__identify = nil
  self.__WCSSSelectChipSelectAlg = BindCallback(self, self.WCSSSelectChipSelectAlg)
end

WarChessSelectChipCtrl.__GetWCSubSystemCat = function(self)
  -- function num : 0_1 , upvalues : _ENV
  local eWarChessEnum = require("Game.WarChess.eWarChessEnum")
  return (eWarChessEnum.eSystemCat).selectAlg
end

WarChessSelectChipCtrl.OpenWCSubSystem = function(self, systemState, identify)
  -- function num : 0_2 , upvalues : _ENV, ChipData
  if systemState == nil or systemState.selectTeamForAlgSystemData == nil then
    error("not have data")
    return 
  end
  self.__selectTeamForAlgSystemData = systemState.selectTeamForAlgSystemData
  self.__identify = identify
  local chipList = {}
  for _,v in ipairs((self.__selectTeamForAlgSystemData).algList) do
    local chipData = (ChipData.NewChipForServer)(v)
    ;
    (table.insert)(chipList, chipData)
  end
  local teamDataDic = ((self.wcCtrl).teamCtrl):GetWCTeams()
  UIManager:ShowWindowAsync(UIWindowTypeID.WarChessSelectChip, function(wcChipWindow)
    -- function num : 0_2_0 , upvalues : chipList, teamDataDic, self
    wcChipWindow:InitWCSelectChip(chipList, teamDataDic, self.__WCSSSelectChipSelectAlg)
  end
)
end

WarChessSelectChipCtrl.WCSSSelectChipSelectAlg = function(self, index, teamData)
  -- function num : 0_3 , upvalues : _ENV, ChipData
  local tid = teamData:GetWCTeamId()
  ;
  ((self.wcCtrl).wcNetworkCtrl):CS_WarChess_SelectTeamForAlgSystem_Select(self.__identify, tid, index - 1, function(args)
    -- function num : 0_3_0 , upvalues : _ENV, ChipData, self
    if args.Count == 0 then
      error("args.Count == 0")
      return 
    end
    local remainAlgList = args[0]
    if #remainAlgList > 0 then
      local chipList = {}
      do
        for _,v in ipairs(remainAlgList) do
          local chipData = (ChipData.NewChipForServer)(v)
          ;
          (table.insert)(chipList, chipData)
        end
        local teamDataDic = ((self.wcCtrl).teamCtrl):GetWCTeams()
        UIManager:ShowWindowAsync(UIWindowTypeID.WarChessSelectChip, function(wcChipWindow)
      -- function num : 0_3_0_0 , upvalues : chipList, teamDataDic, self
      wcChipWindow:InitWCSelectChip(chipList, teamDataDic, self.__WCSSSelectChipSelectAlg)
    end
)
      end
    else
      do
        self:WCSSQuitSelect()
      end
    end
  end
)
end

WarChessSelectChipCtrl.WCSSQuitSelect = function(self)
  -- function num : 0_4
  ((self.wcCtrl).wcNetworkCtrl):CS_WarChess_SelectTeamForAlgSystem_Quit(self.__identify, function()
    -- function num : 0_4_0 , upvalues : self
    self:CloseWCSubSystem()
  end
)
end

WarChessSelectChipCtrl.CloseWCSubSystem = function(self, isSwitchClose)
  -- function num : 0_5 , upvalues : base, _ENV
  (base.CloseWCSubSystem)()
  UIManager:DeleteWindow(UIWindowTypeID.WarChessSelectChip)
  self.__selectTeamForAlgSystemData = nil
  self.__identify = nil
end

WarChessSelectChipCtrl.Delete = function(self)
  -- function num : 0_6
end

return WarChessSelectChipCtrl

