-- params : ...
-- function num : 0 , upvalues : _ENV
local UINSmashingPenguinsResult = class("UINSmashingPenguinsResult", UIBaseNode)
local base = UIBaseNode
local RankingItem = require("Game.TinyGames.FlappyBird.UI.UINRankingItem")
UINSmashingPenguinsResult.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, RankingItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Restart, self, self.OnRestartGameBtnClick)
  self.rankingItemPool = (UIItemPool.New)(RankingItem, (self.ui).rankingItem)
end

UINSmashingPenguinsResult.InitSmashingPenguinsResult = function(self, mainController)
  -- function num : 0_1 , upvalues : _ENV
  self.mainController = mainController
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_Score).text = tostring(mainController.currentScore)
end

UINSmashingPenguinsResult.OnRestartGameBtnClick = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local mainUI = UIManager:GetWindow(UIWindowTypeID.SmashingPenguins)
  if IsNull(mainUI) then
    return 
  end
  mainUI:InitSmashingPenguinsMain()
end

UINSmashingPenguinsResult.RefreshScore = function(self, score, bydRatio, isHide)
  -- function num : 0_3 , upvalues : _ENV
  if not score then
    score = 0
  end
  if not bydRatio then
    bydRatio = 0
  end
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Score).text = tostring(score)
  if isHide then
    ((self.ui).barGroup):SetActive(false)
  else
    ;
    ((self.ui).barGroup):SetActive(true)
    ;
    ((self.ui).tex_Result):SetIndex(0, tostring(bydRatio / 100))
    -- DECOMPILER ERROR at PC36: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.ui).bar).value = bydRatio / 10000
  end
end

UINSmashingPenguinsResult.RefreshResultRank = function(self, resultRankData, mineGrade)
  -- function num : 0_4 , upvalues : _ENV
  (self.rankingItemPool):HideAll()
  if resultRankData == nil then
    return 
  end
  for index,v in ipairs(resultRankData) do
    local item = (self.rankingItemPool):GetOne()
    local isMine = mineGrade == v
    item:InitWithRankData(v, v.grade_index, isMine)
  end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

return UINSmashingPenguinsResult

