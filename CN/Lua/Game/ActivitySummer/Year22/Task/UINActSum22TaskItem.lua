-- params : ...
-- function num : 0 , upvalues : _ENV
local UINActSum22TaskItem = class("UINActSum22TaskItem", UIBaseNode)
local base = UIBaseNode
local UINBaseItemWithCount = require("Game.CommonUI.Item.UINBaseItemWithCount")
local JumpManager = require("Game.Jump.JumpManager")
local CommonRewardData = require("Game.CommonUI.CommonRewardData")
UINActSum22TaskItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithCount
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Refresh, self, self.OnClickRefresh)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Receive, self, self.OnClickReward)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Jump, self, self.OnClickJump)
  self._rewardPool = (UIItemPool.New)(UINBaseItemWithCount, (self.ui).uINBaseItemWithCount)
  ;
  ((self.ui).uINBaseItemWithCount):SetActive(false)
end

UINActSum22TaskItem.InitSum22TaskItem = function(self, index, sum22Data, rewardCallback, refreshCallback)
  -- function num : 0_1 , upvalues : _ENV
  self._index = index
  self._rewardCallback = rewardCallback
  self._refreshCallback = refreshCallback
  self._sum22Data = sum22Data
  ;
  ((self.ui).tex_TaskNo):SetIndex(0, tostring(self._index))
end

UINActSum22TaskItem.Refresh22TaskItem = function(self, taskData)
  -- function num : 0_2
  self._taskData = taskData
  if self._taskData == nil then
    self:__RefreshUnlock()
  else
    self:__RefreshTask()
  end
end

UINActSum22TaskItem.__RefreshUnlock = function(self)
  -- function num : 0_3 , upvalues : _ENV
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R1 in 'UnsetPending'

  ((self.ui).titleBg).color = ((self.ui).color_titles)[3]
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).bottom).color = ((self.ui).color_bottoms)[3]
  -- DECOMPILER ERROR at PC21: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tex_Des).text = (LanguageUtil.GetLocaleText)(ConfigData:GetTipContent(7128))
  -- DECOMPILER ERROR at PC27: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).dot5).color = ((self.ui).color_titles)[3]
  -- DECOMPILER ERROR at PC34: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (((self.ui).tex_TaskNo).text).color = ((self.ui).color_titles)[3]
  -- DECOMPILER ERROR at PC40: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tex_Des).color = ((self.ui).color_titles)[3]
  do
    if self._color_3_extra == nil then
      local color = ((self.ui).color_titles)[3]
      self._color_3_extra = (Color.New)(color.r, color.g, color.b, 0.5)
    end
    -- DECOMPILER ERROR at PC58: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).icon1).color = self._color_3_extra
    -- DECOMPILER ERROR at PC62: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).icon2).color = self._color_3_extra
    ;
    (((self.ui).btn_Refresh).gameObject):SetActive(false)
    ;
    (((self.ui).slider).gameObject):SetActive(false)
    ;
    (((self.ui).tex_Progress).gameObject):SetActive(false)
    ;
    (self._rewardPool):HideAll()
    ;
    (((self.ui).btn_Receive).gameObject):SetActive(false)
    ;
    (((self.ui).btn_Jump).gameObject):SetActive(false)
    ;
    ((self.ui).unLock):SetActive(true)
  end
end

UINActSum22TaskItem.__RefreshTask = function(self)
  -- function num : 0_4 , upvalues : _ENV
  -- DECOMPILER ERROR at PC4: Confused about usage of register: R1 in 'UnsetPending'

  ((self.ui).dot5).color = Color.white
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (((self.ui).tex_TaskNo).text).color = Color.white
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tex_Des).color = Color.white
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).icon1).color = Color.white
  -- DECOMPILER ERROR at PC25: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).icon2).color = Color.white
  ;
  ((self.ui).unLock):SetActive(false)
  -- DECOMPILER ERROR at PC36: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tex_Des).text = (self._taskData):GetTaskFirstStepIntro()
  ;
  (self._rewardPool):HideAll()
  local rewardIds, rewardCounts = (self._taskData):GetTaskCfgRewards()
  for index,itemId in ipairs(rewardIds) do
    local count = rewardCounts[index]
    local item = (self._rewardPool):GetOne()
    item:InitItemWithCount((ConfigData.item)[itemId], count)
  end
  local refreshTimes, maxTimes = (self._sum22Data):GetSectorIIITaskRefTimes()
  ;
  (((self.ui).slider).gameObject):SetActive(true)
  ;
  (((self.ui).tex_Progress).gameObject):SetActive(true)
  local isComplete = (self._taskData):CheckComplete()
  if isComplete then
    local schedule, aim = (self._taskData):GetTaskProcess()
    -- DECOMPILER ERROR at PC84: Confused about usage of register: R8 in 'UnsetPending'

    ;
    ((self.ui).slider).value = 1
    ;
    ((self.ui).tex_Progress):SetIndex(0, tostring(aim), tostring(aim))
    ;
    (((self.ui).btn_Jump).gameObject):SetActive(false)
    ;
    (((self.ui).btn_Receive).gameObject):SetActive(true)
    -- DECOMPILER ERROR at PC113: Confused about usage of register: R8 in 'UnsetPending'

    ;
    ((self.ui).titleBg).color = ((self.ui).color_titles)[1]
    -- DECOMPILER ERROR at PC119: Confused about usage of register: R8 in 'UnsetPending'

    ;
    ((self.ui).bottom).color = ((self.ui).color_bottoms)[1]
    ;
    (((self.ui).btn_Refresh).gameObject):SetActive(false)
  else
    do
      do
        local schedule, aim = (self._taskData):GetTaskProcess()
        -- DECOMPILER ERROR at PC133: Confused about usage of register: R8 in 'UnsetPending'

        ;
        ((self.ui).slider).value = schedule / aim
        ;
        ((self.ui).tex_Progress):SetIndex(0, tostring(schedule), tostring(aim))
        ;
        (((self.ui).btn_Jump).gameObject):SetActive(((self._taskData).stcData).jump_id > 0)
        ;
        (((self.ui).btn_Receive).gameObject):SetActive(false)
        -- DECOMPILER ERROR at PC168: Confused about usage of register: R8 in 'UnsetPending'

        ;
        ((self.ui).titleBg).color = ((self.ui).color_titles)[2]
        -- DECOMPILER ERROR at PC174: Confused about usage of register: R8 in 'UnsetPending'

        ;
        ((self.ui).bottom).color = ((self.ui).color_bottoms)[2]
        ;
        (((self.ui).btn_Refresh).gameObject):SetActive(refreshTimes < maxTimes)
        -- DECOMPILER ERROR: 3 unprocessed JMP targets
      end
    end
  end
end

UINActSum22TaskItem.OnClickRefresh = function(self)
  -- function num : 0_5
  if self._refreshCallback ~= nil then
    (self._refreshCallback)(self._taskData)
  end
end

UINActSum22TaskItem.OnClickReward = function(self)
  -- function num : 0_6 , upvalues : CommonRewardData, _ENV
  if self._rewardCallback ~= nil then
    local rewardIds, rewardCounts = (self._taskData):GetTaskCfgRewards()
    do
      local CRData = (CommonRewardData.CreateCRDataUseList)(rewardIds, rewardCounts)
      local window = UIManager:GetWindow(UIWindowTypeID.CommonReward)
      if window ~= nil then
        window:Hide()
        window:Show()
        window:AddAndTryShowReward(CRData)
      else
        UIManager:ShowWindowAsync(UIWindowTypeID.CommonReward, function(window)
    -- function num : 0_6_0 , upvalues : CRData
    if window == nil then
      return 
    end
    window:AddAndTryShowReward(CRData)
  end
)
      end
      ;
      (self._rewardCallback)(self._taskData)
    end
  end
end

UINActSum22TaskItem.OnClickJump = function(self)
  -- function num : 0_7 , upvalues : JumpManager
  local stcData = (self._taskData).stcData
  if stcData.jump_id > 0 then
    JumpManager:Jump(stcData.jump_id, nil, nil, stcData.jumpArgs)
  end
end

return UINActSum22TaskItem

