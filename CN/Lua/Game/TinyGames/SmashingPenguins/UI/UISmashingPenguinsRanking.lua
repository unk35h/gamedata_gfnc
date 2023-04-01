-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.TinyGames.FlappyBird.UI.UIFlappyRanking")
local UISmashingPenguinsRanking = class("UISmashingPenguinsRanking", base)
local RankingItem = require("Game.TinyGames.FlappyBird.UI.UINRankingItem")
local cs_DoTween = ((CS.DG).Tweening).DOTween
UISmashingPenguinsRanking.RefreshRankingData = function(self, allFriendData, mineGrade)
  -- function num : 0_0 , upvalues : _ENV
  ((self.ui).obj_top):SetActive(true)
  ;
  ((self.ui).maxBydProgress):SetIndex(0, tostring(mineGrade.bydProgress / 100))
  if allFriendData == nil or mineGrade == nil then
    return 
  end
  -- DECOMPILER ERROR at PC24: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Score).text = tostring(mineGrade.score)
  -- DECOMPILER ERROR at PC28: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_UserName).text = mineGrade.name
  self.allFriendDataList = allFriendData
  if #self.allFriendDataList <= 1 then
    (((self.ui).tips).gameObject):SetActive(true)
    -- DECOMPILER ERROR at PC46: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).tips).text = ConfigData:GetTipContent(7106)
  else
    ;
    (((self.ui).tips).gameObject):SetActive(false)
  end
  -- DECOMPILER ERROR at PC61: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).scroll).onChangeItem = BindCallback(self, self.__OnChangeItem, mineGrade)
  -- DECOMPILER ERROR at PC68: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).scroll).onInstantiateItem = BindCallback(self, self.__OnInstantiateItem)
  -- DECOMPILER ERROR at PC73: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).scroll).totalCount = #self.allFriendDataList
  ;
  ((self.ui).scroll):RefillCells()
end

UISmashingPenguinsRanking.__InitFlappyRankingTween = function(self)
  -- function num : 0_1
end

UISmashingPenguinsRanking.HideAndBack = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local mainWin = UIManager:GetWindow(UIWindowTypeID.SmashingPenguins)
  if mainWin ~= nil then
    mainWin:ShowMainWindow()
  end
  self:Delete()
end

return UISmashingPenguinsRanking

