-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseWindow
local UIWarChessInheritChip = class("UIWarChessInheritChip", base)
local UINWarChessInheritTeamItem = require("Game.WarChess.UI.InheritChip.UINWarChessInheritTeamItem")
local UINWarChessInheritChipItem = require("Game.WarChess.UI.InheritChip.UINWarChessInheritChipItem")
local cs_ResLoader = CS.ResLoader
UIWarChessInheritChip.OnInit = function(self)
  -- function num : 0_0 , upvalues : cs_ResLoader, _ENV, UINWarChessInheritTeamItem, UINWarChessInheritChipItem
  self.resloader = (cs_ResLoader.Create)()
  self.wcCtrl = WarChessManager:GetWarChessCtrl()
  self.teamNode = (UINWarChessInheritTeamItem.New)()
  ;
  (self.teamNode):Init((self.ui).obj_teamItem)
  self.chipNodePool = (UIItemPool.New)(UINWarChessInheritChipItem, (self.ui).obj_chipNode)
  ;
  ((self.ui).obj_chipNode):SetActive(false)
end

UIWarChessInheritChip.InitSelectCouldInheritChip = function(self, dTeamDataDic, deadIndexList, finishCallback)
  -- function num : 0_1 , upvalues : _ENV
  self.__dTeamDataList = {}
  self.__deadIndexList = (table.copy)(deadIndexList)
  self.__finishCallback = finishCallback
  for _,dTeamData in pairs(dTeamDataDic) do
    (table.insert)(self.__dTeamDataList, dTeamData)
  end
  ;
  (table.sort)(self.__dTeamDataList, function(a, b)
    -- function num : 0_1_0
    do return b:GetDTeamIndex() < a:GetDTeamIndex() end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
  ;
  (table.sort)(self.__deadIndexList)
  self:__TryInheritNextTeam()
end

UIWarChessInheritChip.__TryInheritNextTeam = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if #self.__dTeamDataList <= 0 or #self.__deadIndexList <= 0 then
    self:Delete()
    if self.__finishCallback ~= nil then
      (self.__finishCallback)()
    end
  else
    local dTeamData = (table.remove)(self.__dTeamDataList, 1)
    self:__RefreshInheritChip(dTeamData)
  end
end

UIWarChessInheritChip.__RefreshInheritChip = function(self, dTeamData)
  -- function num : 0_3 , upvalues : _ENV
  (self.teamNode):InitWCDeployTeamItem(dTeamData, self.resloader)
  ;
  (self.chipNodePool):HideAll()
  for index,realTeamIndex in ipairs(self.__deadIndexList) do
    do
      local teamData = ((self.wcCtrl).teamCtrl):GetDeadTeamDataByTeamIndex(realTeamIndex)
      if teamData ~= nil then
        local chipNodeItem = (self.chipNodePool):GetOne()
        chipNodeItem:InitWCInheritChipItem(teamData, self.resloader, function()
    -- function num : 0_3_0 , upvalues : dTeamData, realTeamIndex, _ENV, self, index
    dTeamData:SetInheritTeamIndex(realTeamIndex)
    ;
    (table.remove)(self.__deadIndexList, index)
    self:__TryInheritNextTeam()
  end
)
      end
    end
  end
end

UIWarChessInheritChip.OnDelete = function(self)
  -- function num : 0_4
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
end

return UIWarChessInheritChip

