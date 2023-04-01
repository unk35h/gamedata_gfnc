-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseWindow
local UISnakeGameRank = class("UISnakeGameRank", base)
local UINSnakeGameRankItem = require("Game.TinyGames.Snake.UI.UINSnakeGameRankItem")
UISnakeGameRank.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.SetTopStatus)(self, self._OnClickReturn, nil, nil, nil, true)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_BackPause, self, self._HideAndBack)
  self.itemDic = {}
  -- DECOMPILER ERROR at PC23: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).rankList).onChangeItem = BindCallback(self, self.__OnChangeItem, mineGrade)
  -- DECOMPILER ERROR at PC30: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).rankList).onInstantiateItem = BindCallback(self, self.__OnInstantiateItem)
  self.resloader = ((CS.ResLoader).Create)()
end

UISnakeGameRank.RefreshSnakeGameRank = function(self, allFriendData, mineGrade, rankIndex)
  -- function num : 0_1 , upvalues : _ENV
  self.allFriendDataList = allFriendData
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_UID).text = tostring((PlayerDataCenter.inforData):GetUserUID())
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_PlayerName).text = (PlayerDataCenter.inforData):GetUserName()
  ;
  ((self.ui).tex_Rank):SetIndex(0, tostring(rankIndex))
  -- DECOMPILER ERROR at PC30: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Score).text = tostring(mineGrade.score)
  -- DECOMPILER ERROR at PC35: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).rankList).totalCount = #self.allFriendDataList
  ;
  ((self.ui).rankList):RefillCells()
  local picPath = nil
  if (PlayerDataCenter.inforData):GetSex() then
    picPath = PathConsts:GetResImagePath("Activity/ActSummer2022/UI_ActSum22DollF.png")
  else
    picPath = PathConsts:GetResImagePath("Activity/ActSummer2022/UI_ActSum22DollM.png")
  end
  ;
  (((self.ui).img_CmderPic).gameObject):SetActive(false)
  ;
  (self.resloader):LoadABAssetAsync(picPath, function(texture)
    -- function num : 0_1_0 , upvalues : _ENV, self
    if IsNull(texture) then
      return 
    end
    ;
    (((self.ui).img_CmderPic).gameObject):SetActive(true)
    -- DECOMPILER ERROR at PC14: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_CmderPic).texture = texture
  end
)
end

UISnakeGameRank.__OnChangeItem = function(self, mineGrade, go, index)
  -- function num : 0_2
  local item = (self.itemDic)[go]
  local itemData = (self.allFriendDataList)[index + 1]
  local isMine = mineGrade == itemData
  item:InitSnakeRankItem(itemData, index + 1, isMine)
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UISnakeGameRank.__OnInstantiateItem = function(self, go)
  -- function num : 0_3 , upvalues : UINSnakeGameRankItem
  local item = (UINSnakeGameRankItem.New)()
  item:Init(go)
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.itemDic)[go] = item
end

UISnakeGameRank._OnClickReturn = function(self)
  -- function num : 0_4
  self:Delete()
end

UISnakeGameRank._HideAndBack = function(self)
  -- function num : 0_5 , upvalues : _ENV
  (UIUtil.OnClickBack)()
end

UISnakeGameRank.OnDelete = function(self)
  -- function num : 0_6 , upvalues : base
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  ;
  (base.OnDelete)(self)
end

return UISnakeGameRank

