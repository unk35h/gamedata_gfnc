-- params : ...
-- function num : 0 , upvalues : _ENV
local UIHandBookActBookEx = class("UIHandBookActBookEx", UIBaseWindow)
local base = UIBaseWindow
local UINHandBookActYearTag = require("Game.HandBook.UI.Activity.UINHandBookActYearTag")
local UINHandBookActBookExItem = require("Game.HandBook.UI.Activity.UINHandBookActBookExItem")
local JumpManager = require("Game.Jump.JumpManager")
local CS_Resloader = CS.ResLoader
UIHandBookActBookEx.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINHandBookActYearTag, UINHandBookActBookExItem, CS_Resloader
  (UIUtil.SetTopStatus)(self, self.OnClickBookEx)
  self._yearTagPool = (UIItemPool.New)(UINHandBookActYearTag, (self.ui).yearItem)
  ;
  ((self.ui).yearItem):SetActive(false)
  self._itemPool = (UIItemPool.New)(UINHandBookActBookExItem, (self.ui).item)
  ;
  ((self.ui).item):SetActive(false)
  self.__OnSelectYearCallback = BindCallback(self, self.__OnSelectYear)
  self.__OnSelectItemCallback = BindCallback(self, self.__OnSelectItem)
  self.__OnSelectRewardCallback = BindCallback(self, self.__OnSelectReward)
  self._resloder = (CS_Resloader.Create)()
end

UIHandBookActBookEx.InitActBookEx = function(self, activityClassId, callback)
  -- function num : 0_1 , upvalues : _ENV
  self._callback = callback
  self._cfg = (ConfigData.handbook_activity)[activityClassId]
  ;
  (self._yearTagPool):HideAll()
  local yearList = {}
  for year,activityIds in pairs((self._cfg).yearDic) do
    local actFrameId = activityIds[#activityIds]
    local activityCfg = (ConfigData.activity)[actFrameId]
    local destroyTm = activityCfg.rewardEnd_time
    if destroyTm <= PlayerDataCenter.timestamp then
      (table.insert)(yearList, year)
    end
  end
  local totalCount = #yearList
  if totalCount == 0 then
    return 
  end
  ;
  (table.sort)(yearList, function(a, b)
    -- function num : 0_1_0
    do return b < a end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
  for _,year in ipairs(yearList) do
    local item = (self._yearTagPool):GetOne()
    item:InitHandBookActYearTag(year, self.__OnSelectYearCallback)
  end
  self:__OnSelectYear(yearList[1])
end

UIHandBookActBookEx.__OnSelectYear = function(self, year)
  -- function num : 0_2 , upvalues : _ENV
  if self._selectYear == year then
    return 
  end
  for i,v in ipairs((self._yearTagPool).listItem) do
    v:RefreshActYearTag(year)
  end
  self._selectYear = year
  local activityIds = ((self._cfg).yearDic)[year]
  ;
  (self._itemPool):HideAll()
  for i,actFrameId in ipairs(activityIds) do
    local activityCfg = (ConfigData.activity)[actFrameId]
    local destroyTm = activityCfg.rewardEnd_time
    if destroyTm <= PlayerDataCenter.timestamp then
      local item = (self._itemPool):GetOne()
      item:InitActBookExItem((self._cfg).id, actFrameId, self.__OnSelectItemCallback, self.__OnSelectRewardCallback, self._resloder)
      item:PlayBookExAni((i - 1) * 0.066)
    end
  end
end

UIHandBookActBookEx.__OnSelectItem = function(self, actFrameId)
  -- function num : 0_3 , upvalues : _ENV, JumpManager
  if not FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_HeroActivity) then
    return 
  end
  local activityCfg = (ConfigData.activity)[actFrameId]
  local actId = activityCfg.activity_id
  local heroGrowCfg = (ConfigData.activity_hero)[actId]
  if not (PlayerDataCenter.sectorEntranceHandler):CheckSectorValid(heroGrowCfg.main_stage) then
    return 
  end
  JumpManager:Jump((JumpManager.eJumpTarget).DynSectorLevel, nil, nil, {heroGrowCfg.main_stage})
end

UIHandBookActBookEx.__OnSelectReward = function(self, actFrameId, worldPos)
  -- function num : 0_4 , upvalues : _ENV
  local activityCfg = (ConfigData.activity)[actFrameId]
  local handbookAct = ((self._cfg).content)[actFrameId]
  local actName = ((ConfigData.activity_name)[activityCfg.name_id]).name
  UIManager:ShowWindowAsync(UIWindowTypeID.HandBookRewardWindow, function(win)
    -- function num : 0_4_0 , upvalues : _ENV, actName, handbookAct, worldPos
    if IsNull(win) then
      return 
    end
    win:InitHandBookRewardWindow((LanguageUtil.GetLocaleText)(actName), handbookAct.reward_list)
    win:PlayBookRewardAni(worldPos)
  end
)
end

UIHandBookActBookEx.OnClickBookEx = function(self)
  -- function num : 0_5
  if self._callback ~= nil then
    (self._callback)()
  end
  self:Delete()
end

UIHandBookActBookEx.OnDelete = function(self)
  -- function num : 0_6 , upvalues : base
  (self._itemPool):DeleteAll()
  ;
  (base.OnDelete)(self)
  if self._resloder ~= nil then
    (self._resloder):Put2Pool()
    self._resloder = nil
  end
end

return UIHandBookActBookEx

