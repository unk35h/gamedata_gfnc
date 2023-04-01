-- params : ...
-- function num : 0 , upvalues : _ENV
local UIActSum22StrategySelect = class("UIActSum22StrategySelect", UIBaseWindow)
local base = UIBaseWindow
local UINActSum22StrategySelectItem = require("Game.ActivitySummer.Year22.Tech.Select.UINActSum22StrategySelectItem")
local cs_ResLoader = CS.ResLoader
local cs_MessageCommon = CS.MessageCommon
UIActSum22StrategySelect.OnInit = function(self)
  -- function num : 0_0 , upvalues : cs_ResLoader, _ENV, UINActSum22StrategySelectItem
  self._resloder = (cs_ResLoader.Create)()
  ;
  (UIUtil.SetTopStatus)(self, self.OnClickCloseSlect)
  ;
  (UIUtil.SetTopStatusBtnShow)(false, false)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Refresh, self, self._OnClickReresh)
  self._selectItemPool = (UIItemPool.New)(UINActSum22StrategySelectItem, (self.ui).selectItem, false)
  self._OnClickSelectTechFunc = BindCallback(self, self._OnClickSelectTech)
  self.__RefreshFunc = BindCallback(self, self.__Refresh)
  MsgCenter:AddListener(eMsgEventId.ActivitySectorIIIDayTimeout, self.__RefreshFunc)
end

UIActSum22StrategySelect.InitTechSelect = function(self, sum22Data, closeFunc)
  -- function num : 0_1 , upvalues : _ENV
  self._sum22Data = sum22Data
  self._closeFunc = closeFunc
  local actCfg = sum22Data:GetSectorIIIMainCfg()
  self._actCfg = actCfg
  self._refreshCostId = actCfg.refresh_item
  local sprite = CRH:GetSpriteByItemId(actCfg.refresh_item, true)
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).img_Coin).sprite = sprite
  self:__Refresh()
  ;
  (UIUtil.RefreshTopResId)({actCfg.tech_item, actCfg.refresh_item})
  self._actSumCtrl = ControllerManager:GetController(ControllerTypeId.ActivitySectorIII)
  if self._actSumCtrl == nil then
    error("actSumCtrl == nil")
  end
  self:_UpdSelectList()
  sum22Data:SetActSum22TechSelectEntered()
end

UIActSum22StrategySelect._UpdSelectList = function(self, isRefresh, selectedTechItem)
  -- function num : 0_2 , upvalues : _ENV
  local selectIdList = (self._sum22Data):GetActSum22TechSelectIdList()
  local techDataDic = (self._sum22Data):GetSectorIIITechDic()
  for k,techId in ipairs(selectIdList) do
    local techData = techDataDic[techId]
    if techData == nil then
      error("techData == nil,id:%s", techId)
    else
      if not ((self._selectItemPool).listItem)[k] then
        local selectItem = (self._selectItemPool):GetOne()
      end
      if isRefresh then
        selectItem:PlayRefreshAnimActSum22TechSelectItem(k, techData, self._resloder, self._OnClickSelectTechFunc)
      else
        if selectItem ~= selectedTechItem then
          do
            do
              local isCurItem = selectedTechItem == nil
              selectItem:PlaySelectAnimActSum22TechSelectItem(k, techData, self._resloder, self._OnClickSelectTechFunc, isCurItem)
              selectItem:InitTechSelectItem(k, techData, self._resloder, self._OnClickSelectTechFunc)
              -- DECOMPILER ERROR at PC55: LeaveBlock: unexpected jumping out DO_STMT

              -- DECOMPILER ERROR at PC55: LeaveBlock: unexpected jumping out IF_THEN_STMT

              -- DECOMPILER ERROR at PC55: LeaveBlock: unexpected jumping out IF_STMT

              -- DECOMPILER ERROR at PC55: LeaveBlock: unexpected jumping out IF_ELSE_STMT

              -- DECOMPILER ERROR at PC55: LeaveBlock: unexpected jumping out IF_STMT

              -- DECOMPILER ERROR at PC55: LeaveBlock: unexpected jumping out IF_ELSE_STMT

              -- DECOMPILER ERROR at PC55: LeaveBlock: unexpected jumping out IF_STMT

            end
          end
        end
      end
    end
  end
  if #selectIdList < #(self._selectItemPool).listItem then
    for i = #selectIdList + 1, #(self._selectItemPool).listItem do
      (self._selectItemPool):HideOne(((self._selectItemPool).listItem)[i])
    end
  end
  -- DECOMPILER ERROR: 4 unprocessed JMP targets
end

UIActSum22StrategySelect._OnClickReresh = function(self)
  -- function num : 0_3 , upvalues : _ENV, cs_MessageCommon
  if self._remainRefreshNum <= 0 then
    return 
  end
  if PlayerDataCenter:GetItemCount(self._refreshCostId) < self._curRefreshCostNum then
    (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(8602))
    return 
  end
  ;
  (self._actSumCtrl):ReqSum22RefreshTechSelect((self._sum22Data):GetActFrameId(), function()
    -- function num : 0_3_0 , upvalues : self
    self:_UpdSelectList(true)
    self:__Refresh()
  end
)
end

UIActSum22StrategySelect._OnClickSelectTech = function(self, techData, techItem)
  -- function num : 0_4 , upvalues : cs_MessageCommon, _ENV
  if not techData:IsLeveUpResEnough() then
    (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(8601))
    return 
  end
  if not self._newTechIdDic then
    self._newTechIdDic = {}
    if not self._lvUpTechIdDic then
      self._lvUpTechIdDic = {}
      local isNew = techData:GetCurLevel() == 0
      ;
      (self._actSumCtrl):ReqSum22TechSelect(techData, function()
    -- function num : 0_4_0 , upvalues : techData, isNew, self, techItem
    local techId = techData:GetTechId()
    -- DECOMPILER ERROR at PC7: Confused about usage of register: R1 in 'UnsetPending'

    if isNew then
      (self._newTechIdDic)[techId] = true
    else
      -- DECOMPILER ERROR at PC14: Confused about usage of register: R1 in 'UnsetPending'

      if (self._newTechIdDic)[techId] == nil then
        (self._lvUpTechIdDic)[techId] = true
      end
    end
    self:_UpdSelectList(nil, techItem)
  end
)
      -- DECOMPILER ERROR: 1 unprocessed JMP targets
    end
  end
end

UIActSum22StrategySelect.__Refresh = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local maxNum = #(self._actCfg).refresh_price
  local curNum = (self._sum22Data):GetActSum22TechRefreshNum()
  local remainNum = (math.max)(maxNum - curNum, 0)
  self._remainRefreshNum = remainNum
  ;
  ((self.ui).tex_Refresh):SetIndex(0, tostring(remainNum), tostring(maxNum))
  local costNum = ((self._actCfg).refresh_price)[(math.min)(curNum + 1, maxNum)]
  -- DECOMPILER ERROR at PC36: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_Cost).text = tostring(costNum)
  self._curRefreshCostNum = costNum
  -- DECOMPILER ERROR at PC44: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).btn_Refresh).interactable = remainNum > 0
  -- DECOMPILER ERROR at PC51: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).ban_Btn_Refresh).enabled = remainNum <= 0
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UIActSum22StrategySelect.OnClickCloseSlect = function(self)
  -- function num : 0_6 , upvalues : _ENV
  (UIUtil.SetTopStatusBtnShow)(true, true)
  self:Delete()
  if self._closeFunc ~= nil then
    if self._newTechIdDic or not self._lvUpTechIdDic then
      (self._closeFunc)(table.emptytable, table.emptytable)
    end
  end
end

UIActSum22StrategySelect.OnDelete = function(self)
  -- function num : 0_7 , upvalues : _ENV, base
  MsgCenter:RemoveListener(eMsgEventId.ActivitySectorIIIDayTimeout, self.__RefreshFunc)
  ;
  (self._selectItemPool):DeleteAll()
  if self._resloder ~= nil then
    (self._resloder):Put2Pool()
    self._resloder = nil
  end
  ;
  (base.OnDelete)(self)
end

return UIActSum22StrategySelect

