-- params : ...
-- function num : 0 , upvalues : _ENV
local UICommonRank = class("UICommonRank", UIBaseWindow)
local base = UIBaseWindow
local UINCommonRankPanel = require("Game.CommonUI.Rank.UINCommonRankPanel")
UICommonRank.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINCommonRankPanel
  (UIUtil.SetTopStatus)(self, self._OnClickBack)
  self.__rankPanel = (UINCommonRankPanel.New)()
  ;
  (self.__rankPanel):Init((self.ui).obj_rankNode)
end

UICommonRank.InitCommonRank = function(self, rankId)
  -- function num : 0_1 , upvalues : _ENV
  local rankCfg = (ConfigData.common_ranklist)[rankId]
  if rankCfg == nil then
    error("common rank cfg is null,id:" .. tostring(rankId))
  end
  self.__rankCfg = rankCfg
  self:InitCommonRankBaseInfo()
  self:ShowCommonRankPanel()
end

UICommonRank.InitCommonRankBaseInfo = function(self)
  -- function num : 0_2 , upvalues : _ENV
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R1 in 'UnsetPending'

  ((self.ui).tex_CNTitle).text = (LanguageUtil.GetLocaleText)((self.__rankCfg).rank_title)
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tex_ENTitle).text = (LanguageUtil.GetLocaleText)((self.__rankCfg).rank_title_en)
end

UICommonRank.ShowCommonRankPanel = function(self)
  -- function num : 0_3
  (self.__rankPanel):InitCommonRankPanel(self.__rankCfg)
end

UICommonRank.ReceiveRankFromServer = function(self, msg)
  -- function num : 0_4
  if msg.rankId ~= (self.__rankCfg).id then
    return 
  end
  if self.__rankPanel == nil then
    return 
  end
  ;
  (self.__rankPanel):GetCommonRankPageMsg(msg, (self.__rankCfg).time_switch, (self.__rankCfg).hero_show_type == 1)
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UICommonRank._OnClickBack = function(self, toHome)
  -- function num : 0_5
  self:Delete()
end

UICommonRank.OnDelete = function(self)
  -- function num : 0_6 , upvalues : base
  if self.__rankPanel ~= nil then
    (self.__rankPanel):Delete()
    self.__rankPanel = nil
  end
  ;
  (base.OnDelete)(self)
end

return UICommonRank

