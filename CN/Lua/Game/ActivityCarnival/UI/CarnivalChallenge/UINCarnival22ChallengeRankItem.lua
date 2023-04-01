-- params : ...
-- function num : 0 , upvalues : _ENV
local UINCarnival22ChallengeRankItem = class("UINCarnival22ChallengeRankItem", UIBaseNode)
local base = UIBaseNode
local UINUserHead = require("Game.CommonUI.Head.UINUserHead")
UINCarnival22ChallengeRankItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINUserHead
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.userHead = (UINUserHead.New)()
  ;
  (self.userHead):Init((self.ui).uINUserHead)
end

UINCarnival22ChallengeRankItem.InitCarnivalChallengeRankItem = function(self, rankElemData, resloader)
  -- function num : 0_1 , upvalues : _ENV
  local rankAvatar = (rankElemData.entry).avatar
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Rank).text = tostring(rankElemData.rankIdx)
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_PlayerName).text = rankAvatar.name
  ;
  ((self.ui).myRank):SetActive((rankElemData.entry).uid == (PlayerDataCenter.inforData):GetUserUID())
  ;
  (self.userHead):InitUserHeadUI(rankAvatar.avatarId, rankAvatar.avatarFrame, resloader)
  local min = (math.floor)(rankElemData.second / 60)
  local sec = rankElemData.second % 60
  ;
  ((self.ui).tex_Time):SetIndex(0, (string.format)("%02d", min), (string.format)("%.03f", sec))
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

return UINCarnival22ChallengeRankItem

