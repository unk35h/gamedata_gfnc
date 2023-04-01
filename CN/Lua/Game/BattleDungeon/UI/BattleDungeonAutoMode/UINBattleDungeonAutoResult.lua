-- params : ...
-- function num : 0 , upvalues : _ENV
local UINBattleDungeonAutoResult = class("UINBattleDungeonAutoResult", UIBaseNode)
local base = UIBaseNode
local UICommonRewardItem = require("Game.CommonUI.Item.UICommonRewardItem")
local ItemData = require("Game.PlayerData.Item.ItemData")
local DungeonLevelEnum = require("Game.DungeonCenter.DungeonLevelEnum")
UINBattleDungeonAutoResult.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Confirm, self, self.OnClickConfirm)
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).loopScrollRect).onInstantiateItem = BindCallback(self, self.__OnInstantiateItem)
  -- DECOMPILER ERROR at PC25: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).loopScrollRect).onChangeItem = BindCallback(self, self.__OnChangeItem)
end

UINBattleDungeonAutoResult.InitAutoResultTitle = function(self, dungeonLevelData, dungeonStageData)
  -- function num : 0_1 , upvalues : DungeonLevelEnum, _ENV
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R3 in 'UnsetPending'

  if dungeonLevelData ~= nil and dungeonLevelData:GetDungeonLevelType() == (DungeonLevelEnum.DunLevelType).Tower then
    (((self.ui).tex_DungeonName).text).text = dungeonLevelData:GetTowerTypeName()
    return 
  end
  do
    if dungeonStageData ~= nil then
      local name = nil
      if (dungeonStageData.dungeonData):IsFrageDungeon() then
        ((self.ui).tex_DungeonName):SetIndex(1, (dungeonStageData.dungeonData):GetDungeonName())
      else
        ;
        ((self.ui).tex_DungeonName):SetIndex(0, (LanguageUtil.GetLocaleText)((dungeonStageData:GetDungeonStageCfg()).name))
      end
      return 
    end
    -- DECOMPILER ERROR at PC47: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (((self.ui).tex_DungeonName).text).text = ""
  end
end

UINBattleDungeonAutoResult.InitAutoResult = function(self, count, rewardDic, athDic, callback)
  -- function num : 0_2 , upvalues : _ENV
  self.callback = callback
  ;
  ((self.ui).tex_Times):SetIndex(0, tostring(count))
  local itemDataList = {}
  for rewardId,rewardCount in pairs(rewardDic) do
    local itemCfg = (ConfigData.item)[rewardId]
    if itemCfg.type ~= eItemType.Arithmetic and ((ConfigData.item).athGiftDic)[rewardId] == nil then
      do
        local isAthItem = itemCfg == nil
        if not isAthItem then
          (table.insert)(itemDataList, {id = rewardId, itemCfg = itemCfg, count = rewardCount})
        end
        -- DECOMPILER ERROR at PC42: LeaveBlock: unexpected jumping out IF_THEN_STMT

        -- DECOMPILER ERROR at PC42: LeaveBlock: unexpected jumping out IF_STMT

      end
    end
  end
  for uid,_ in pairs(athDic) do
    local athData = ((PlayerDataCenter.allAthData).athDic)[uid]
    if athData ~= nil then
      (table.insert)(itemDataList, {id = athData.id, count = 1, itemCfg = athData.itemCfg, isAth = true, athData = athData})
    end
  end
  ExplorationManager:RewardSort(itemDataList)
  self.itemDic = {}
  self.itemDataList = itemDataList
  self._heroIdSnapShoot = PlayerDataCenter:TakeHeroIdSnapShoot()
  -- DECOMPILER ERROR at PC83: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).loopScrollRect).totalCount = #self.itemDataList
  ;
  ((self.ui).loopScrollRect):RefillCells()
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

UINBattleDungeonAutoResult.__OnInstantiateItem = function(self, go)
  -- function num : 0_3 , upvalues : UICommonRewardItem
  local item = (UICommonRewardItem.New)()
  item:Init(go)
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.itemDic)[go] = item
end

UINBattleDungeonAutoResult.__OnChangeItem = function(self, go, index)
  -- function num : 0_4 , upvalues : _ENV
  local item = (self.itemDic)[go]
  if item == nil then
    error("UINBattleDungeonAutoResult error:Can\'t find item")
  end
  local data = (self.itemDataList)[index + 1]
  if data == nil then
    error("UINBattleDungeonAutoResult error:Can\'t find data")
  end
  item:InitCommonRewardItem(data.itemCfg, data.count, self._heroIdSnapShoot, function()
    -- function num : 0_4_0 , upvalues : _ENV, self, index
    UIManager:ShowWindowAsync(UIWindowTypeID.GlobalItemDetail, function(win)
      -- function num : 0_4_0_0 , upvalues : self, index
      if win ~= nil then
        win:InitListDetail(self.itemDataList, index + 1, true)
      end
    end
)
  end
)
end

UINBattleDungeonAutoResult.OnClickConfirm = function(self)
  -- function num : 0_5
  if self.callback == nil then
    return 
  end
  ;
  (self.callback)()
end

return UINBattleDungeonAutoResult

