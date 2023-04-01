-- params : ...
-- function num : 0 , upvalues : _ENV
local UINAchievementLevelItem = class("UINAchievementLevelItem", UIBaseNode)
local base = UIBaseNode
local UINBaseItemWithReceived = require("Game.CommonUI.Item.UINBaseItemWithReceived")
local CommonLogicUtil = require("Game.Common.CommonLogicUtil.CommonLogicUtil")
UINAchievementLevelItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithReceived
  self.isPicked = nil
  ;
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Get, self, self.OnClickGetReward)
  self.rewardItemPool = (UIItemPool.New)(UINBaseItemWithReceived, (self.ui).obj_rewardItem)
  ;
  (((self.ui).obj_rewardItem).gameObject):SetActive(false)
end

UINAchievementLevelItem.InitLevelItem = function(self, eLevelState, getRewardCallback)
  -- function num : 0_1
  self.eLevelState = eLevelState
  self.getRewardCallback = getRewardCallback
end

UINAchievementLevelItem.RefreshLevelItem = function(self, levelData)
  -- function num : 0_2 , upvalues : _ENV, CommonLogicUtil
  self.levelData = levelData
  if levelData.state == (self.eLevelState).Picked then
    ((self.ui).obj_Complete):SetActive(true)
    ;
    ((self.ui).obj_UnComplete):SetActive(false)
    ;
    (((self.ui).btn_Get).gameObject):SetActive(false)
  else
    if levelData.state == (self.eLevelState).Completed then
      ((self.ui).obj_Complete):SetActive(false)
      ;
      ((self.ui).obj_UnComplete):SetActive(false)
      ;
      (((self.ui).btn_Get).gameObject):SetActive(true)
    else
      ;
      ((self.ui).obj_Complete):SetActive(false)
      ;
      ((self.ui).obj_UnComplete):SetActive(true)
      ;
      (((self.ui).btn_Get).gameObject):SetActive(false)
    end
  end
  ;
  ((self.ui).tex_Level):SetIndex(0, tostring(levelData.level))
  ;
  ((self.ui).obj_Effective):SetActive(levelData.level <= (PlayerDataCenter.playerLevel).level)
  local des = ""
  local logic_list, para1_list, para2_List, para3_list = (PlayerDataCenter.achivLevelData):GetLevelLogics(levelData.level)
  for index,logic in pairs(logic_list) do
    local para1 = para1_list[index]
    local para2 = para2_List[index]
    local para3 = para3_list[index]
    if (string.IsNullOrEmpty)(des) then
      des = (CommonLogicUtil.GetDesString)(logic, para1, para2, para3)
    else
      des = des .. "\n" .. (CommonLogicUtil.GetDesString)(logic, para1, para2, para3)
    end
  end
  local sid = ((ConfigData.system_open).playerLevelUnlock)[levelData.level]
  if sid ~= nil then
    if not (string.IsNullOrEmpty)(des) then
      des = des .. "\n"
    end
    des = des .. (LanguageUtil.GetLocaleText)(((ConfigData.system_open)[sid]).name)
  end
  -- DECOMPILER ERROR at PC146: Confused about usage of register: R8 in 'UnsetPending'

  ;
  ((self.ui).tex_Content).text = des
  ;
  (self.rewardItemPool):HideAll()
  local rewardNum = #(levelData.levelCfg).rewardIds
  if rewardNum < 3 then
    for i = 1, 3 - rewardNum do
      local item = (self.rewardItemPool):GetOne()
      item:InitItemWithCount(nil)
    end
  end
  for index,itemId in ipairs((levelData.levelCfg).rewardIds) do
    local item = (self.rewardItemPool):GetOne()
    local itemCfg = (ConfigData.item)[itemId]
    local count = ((levelData.levelCfg).rewardNums)[index]
    item:InitItemWithCount(itemCfg, count)
    item:SetPickedUIActive(levelData.state == (self.eLevelState).Picked)
  end
  if index < 3 then
    -- DECOMPILER ERROR: 9 unprocessed JMP targets
  end
end

UINAchievementLevelItem.OnClickGetReward = function(self)
  -- function num : 0_3
  if self.getRewardCallback ~= nil then
    (self.getRewardCallback)((self.levelData).level)
  end
end

UINAchievementLevelItem.OnDelete = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnDelete)(self)
end

return UINAchievementLevelItem

