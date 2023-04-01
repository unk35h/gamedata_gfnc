-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseWindow
local UIWCSSettle = class("UIWCSSettle", UIBaseWindow)
UIWCSSettle.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.AddButtonListener)((self.ui).btn_button, self, self.__OnClickClose)
end

UIWCSSettle.InitSettle = function(self, isWin)
  -- function num : 0_1
  self.__isWin = isWin
  self:__RefreshLevelAndScore()
  self:__ShowChipNum()
end

UIWCSSettle.__RefreshLevelAndScore = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local wcsCtrl = WarChessSeasonManager:GetWCSCtrl()
  local level = wcsCtrl:WCSGetFloor()
  local score = wcsCtrl:WCSGetTotalScore()
  ;
  ((self.ui).text_totalScore):SetIndex(0, tostring(score))
  ;
  ((self.ui).text_totalLevel):SetIndex(0, tostring(level))
end

UIWCSSettle.__ShowChipNum = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local wcCtrl = WarChessManager:GetWarChessCtrl()
  local teamDic = (wcCtrl.teamCtrl):GetWCTeams()
  local allChipLevel = 0
  for _,teamData in pairs(teamDic) do
    local dynPlayer = teamData:GetTeamDynPlayer()
    local chipList = dynPlayer:GetChipList()
    for _,chipData in pairs(chipList) do
      allChipLevel = allChipLevel + chipData:GetCount()
    end
  end
  ;
  ((self.ui).text_totalChipLevel):SetIndex(0, tostring(allChipLevel))
end

UIWCSSettle.__OnClickClose = function(self)
  -- function num : 0_4 , upvalues : _ENV
  WarChessManager:ExitWarChess((Consts.SceneName).Sector, self.__isWin, nil, function()
    -- function num : 0_4_0
  end
)
end

UIWCSSettle.OnDelete = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnDelete)(self)
end

return UIWCSSettle

