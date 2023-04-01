-- params : ...
-- function num : 0 , upvalues : _ENV
local UIWinterActivityTech = class("UIWinterActivityTech", UIBaseWindow)
local base = UIBaseWindow
local cs_ResLoader = CS.ResLoader
local UINUnlockedTechLine = require("Game.ActivitySectorII.Tech.UI.UINUnlockedTechLine")
local UINTechItem = require("Game.ActivitySectorII.Tech.UI.UINTechItem")
local UINWATechLine = require("Game.ActivitySectorII.Tech.UI.UINWATechLine")
local UINWATechSide = require("Game.ActivitySectorII.Tech.UI.UINWATechSide")
UIWinterActivityTech.OnInit = function(self)
  -- function num : 0_0 , upvalues : cs_ResLoader, _ENV, UINUnlockedTechLine, UINTechItem, UINWATechLine, UINWATechSide
  self.actId = nil
  self.resloader = (cs_ResLoader.Create)()
  self.techItemDic = {}
  self.techItemIdDic = {}
  self.unlockRowPool = (UIItemPool.New)(UINUnlockedTechLine, (self.ui).obj_unlock)
  ;
  ((self.ui).obj_unlock):SetActive(false)
  self.techItemPool = (UIItemPool.New)(UINTechItem, (self.ui).obj_techItem)
  ;
  ((self.ui).obj_techItem):SetActive(false)
  self.techLinePool = (UIItemPool.New)(UINWATechLine, (self.ui).obj_Line)
  ;
  ((self.ui).obj_Line):SetActive(false)
  self.techSideNode = (UINWATechSide.New)()
  ;
  (self.techSideNode):Init((self.ui).obj_side)
  ;
  (self.techSideNode):InitTechSideNode(self)
  ;
  ((self.ui).obj_OnSelelct):SetActive(false)
  ;
  ((self.ui).obj_IsLock):SetActive(false)
  self.__OnClickTechItem = BindCallback(self, self.OnClickTechItem)
  self.__RefreshAllItem = BindCallback(self, self.RefreshAllItem)
  MsgCenter:AddListener(eMsgEventId.ActivityTechChange, self.__RefreshAllItem)
  self.__showIntroduce = BindCallback(self, self.__ShowIntroduce)
  ;
  (UIUtil.SetTopStatus)(self, self.OnReturnClick, nil, self.__showIntroduce)
end

UIWinterActivityTech.InitWATech = function(self, actId)
  -- function num : 0_1 , upvalues : _ENV
  self.actId = actId
  ;
  (self.unlockRowPool):HideAll()
  ;
  (self.techItemPool):HideAll()
  ;
  (self.techLinePool):HideAll()
  local sectorIICtrl = ControllerManager:GetController(ControllerTypeId.SectorII)
  local SectorIIData = sectorIICtrl:GetSectorIIDataByActId(actId)
  local rowDataList = SectorIIData:GetSectorIITechRowDataList()
  self:GenTechRows(rowDataList, SectorIIData)
  self:GenWATechItem(rowDataList)
  self:GenLineBetweenTechItem()
  self:SelectDefaultTechItem()
  ;
  (UIUtil.RefreshTopResId)({SectorIIData:GetSectorIIDunPointId()})
  local firstTechItem = (rowDataList[1]):GetTechDataDic()
  for techId,techData in pairs(firstTechItem) do
    if not techData.level or techData.level == 0 then
      GuideManager:StartNewTriggerGuide(31001)
      break
    end
  end
end

UIWinterActivityTech.GenTechRows = function(self, rowDataList, SectorIIData)
  -- function num : 0_2 , upvalues : _ENV
  for index,lineData in ipairs(rowDataList) do
    lineData:RefreshTechAvgState()
    local isUnlock = lineData:GetIsUnlock()
    if isUnlock then
      local unlockRowItem = (self.unlockRowPool):GetOne()
      unlockRowItem:RefreshRowItem(SectorIIData, lineData, self.resloader)
    else
      do
        do
          local lockedRowItem = (self.unlockRowPool):GetOne()
          lockedRowItem:RefreshRowItem(SectorIIData, lineData, self.resloader)
          -- DECOMPILER ERROR at PC27: LeaveBlock: unexpected jumping out DO_STMT

          -- DECOMPILER ERROR at PC27: LeaveBlock: unexpected jumping out IF_ELSE_STMT

          -- DECOMPILER ERROR at PC27: LeaveBlock: unexpected jumping out IF_STMT

        end
      end
    end
  end
end

UIWinterActivityTech.GenWATechItem = function(self, rowDataList)
  -- function num : 0_3 , upvalues : _ENV
  self.techItemDic = {}
  self.techItemIdDic = {}
  for row,lineData in ipairs(rowDataList) do
    -- DECOMPILER ERROR at PC10: Confused about usage of register: R7 in 'UnsetPending'

    (self.techItemDic)[row] = {}
    for techId,techData in pairs(lineData:GetTechDataDic()) do
      local col = techData:GetTechCol()
      local techItem = (self.techItemPool):GetOne()
      techItem:InitWATechItem(techData, self.resloader, self.__OnClickTechItem)
      ;
      (techItem.transform):SetParent((self.ui).trans_chessLayout)
      -- DECOMPILER ERROR at PC40: Confused about usage of register: R14 in 'UnsetPending'

      ;
      (techItem.gameObject).name = tostring(row) .. "_" .. tostring(col)
      -- DECOMPILER ERROR at PC46: Confused about usage of register: R14 in 'UnsetPending'

      ;
      (techItem.transform).anchoredPosition = self:_CalTechItemPos(row, col)
      -- DECOMPILER ERROR at PC49: Confused about usage of register: R14 in 'UnsetPending'

      ;
      ((self.techItemDic)[row])[col] = techItem
      -- DECOMPILER ERROR at PC53: Confused about usage of register: R14 in 'UnsetPending'

      ;
      (self.techItemIdDic)[techData:GetTechId()] = techItem
    end
  end
end

UIWinterActivityTech._CalTechItemPos = function(self, row, col)
  -- function num : 0_4 , upvalues : _ENV
  local padding = ((self.ui).chessLayout).padding
  local cellSize = ((self.ui).chessLayout).cellSize
  local spacing = ((self.ui).chessLayout).spacing
  local x = padding.left + (col - 0.5) * cellSize.x + spacing.x * (col - 1)
  local y = (padding.top + (row - 0.5) * cellSize.y + spacing.y * (row - 1)) * -1
  return (Vector2.New)(x, y)
end

UIWinterActivityTech.GenLineBetweenTechItem = function(self)
  -- function num : 0_5 , upvalues : _ENV
  for row,colDic in pairs(self.techItemDic) do
    for col,techItem in pairs(colDic) do
      local techData = techItem.techData
      local preTechId = techData:GetPreTechId()
      if preTechId ~= nil then
        local preTechItem = (self.techItemIdDic)[preTechId]
        if preTechItem ~= nil then
          local techLine = (self.techLinePool):GetOne()
          ;
          (techLine.transform):SetParent((self.ui).trans_chessLayout)
          -- DECOMPILER ERROR at PC32: Confused about usage of register: R15 in 'UnsetPending'

          ;
          (techLine.gameObject).name = (preTechItem.gameObject).name .. " to " .. (techItem.gameObject).name
          techLine:InitWALineItem(preTechItem, techItem)
        end
      end
    end
  end
end

UIWinterActivityTech.OnClickTechItem = function(self, techItem)
  -- function num : 0_6 , upvalues : _ENV
  if not ((self.ui).obj_OnSelelct).activeSelf then
    ((self.ui).obj_OnSelelct):SetActive(true)
  end
  ;
  (((self.ui).obj_OnSelelct).transform):SetParent(techItem.transform)
  -- DECOMPILER ERROR at PC21: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (((self.ui).obj_OnSelelct).transform).anchoredPosition = Vector2.zero
  ;
  (self.techSideNode):RefreshWATechSide(techItem.techData)
end

UIWinterActivityTech.SelectDefaultTechItem = function(self)
  -- function num : 0_7 , upvalues : _ENV
  for row,colDic in ipairs(self.techItemDic) do
    for col,techItem in pairs(colDic) do
      self:OnClickTechItem(techItem)
      do return  end
    end
  end
end

UIWinterActivityTech.OnTechItemLevelUp = function(self, techData)
  -- function num : 0_8 , upvalues : _ENV
  local techId = techData:GetTechId()
  local techItem = (self.techItemIdDic)[techId]
  if techItem ~= nil then
    local fX_LevelUp = (self.ui).obj_fX_LevelUp
    ;
    (fX_LevelUp.transform):SetParent(techItem.transform)
    -- DECOMPILER ERROR at PC15: Confused about usage of register: R5 in 'UnsetPending'

    ;
    (fX_LevelUp.transform).anchoredPosition = Vector2.zero
    fX_LevelUp:SetActive(false)
    fX_LevelUp:SetActive(true)
    if techData:IsMaxLvel() then
      AudioManager:PlayAudioById(1158)
    end
  end
end

UIWinterActivityTech.RefreshAllItem = function(self)
  -- function num : 0_9 , upvalues : _ENV
  for _,techItem in pairs(self.techItemIdDic) do
    techItem:RefreshTechItem()
  end
end

UIWinterActivityTech.__ShowIntroduce = function(self)
  -- function num : 0_10 , upvalues : _ENV
  local GuidePicture = require("Game.Guide.GuidePicture.GuidePicture")
  ;
  (GuidePicture.OpenGuidePicture)((ConfigData.game_config).win21GuideNum, nil)
end

UIWinterActivityTech.OnReturnClick = function(self)
  -- function num : 0_11
  self:Delete()
end

UIWinterActivityTech.OnDelete = function(self)
  -- function num : 0_12 , upvalues : _ENV, base
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  MsgCenter:RemoveListener(eMsgEventId.ActivityTechChange, self.__RefreshAllItem)
  ;
  (base.OnDelete)(self)
end

return UIWinterActivityTech

