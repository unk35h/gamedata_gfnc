-- params : ...
-- function num : 0 , upvalues : _ENV
local UINHeroTalentMap = class("UINHeroTalentMap", UIBaseNode)
local base = UIBaseNode
local UINHeroTalentNode = require("Game.HeroTalent.UI.UINHeroTalentNode")
local UINHeroTalentLine = require("Game.HeroTalent.UI.UINHeroTalentLine")
local eHeroTalentNodeType = {SmallNode = 1, BigNode = 2}
local eHeroTalentNodeSelectScale = {[eHeroTalentNodeType.SmallNode] = (Vector3.New)(0.7, 0.7, 0.7)}
UINHeroTalentMap.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINHeroTalentNode, UINHeroTalentLine, eHeroTalentNodeType, eHeroTalentNodeSelectScale
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).touchArea, self, self.OnClickCancleSelect)
  ;
  (UIUtil.AddButtonListener)((self.ui).talentMainEntityItem, self, self.OnSelectHeroTalentMain)
  self._smallNodePool = (UIItemPool.New)(UINHeroTalentNode, (self.ui).talentSmallEntityItem)
  self._bigNodePool = (UIItemPool.New)(UINHeroTalentNode, (self.ui).talentBigEntityItem)
  ;
  ((self.ui).talentSmallEntityItem):SetActive(false)
  ;
  ((self.ui).talentBigEntityItem):SetActive(false)
  self._linePool = (UIItemPool.New)(UINHeroTalentLine, (self.ui).obj_Line)
  ;
  ((self.ui).obj_Line):SetActive(false)
  self.__OnSelectHeroTalentNode = BindCallback(self, self.OnSelectHeroTalentNode)
  self._nodePoolDic = {[eHeroTalentNodeType.SmallNode] = self._smallNodePool, [eHeroTalentNodeType.BigNode] = self._bigNodePool}
  -- DECOMPILER ERROR at PC73: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).lvParticlePrimary).scale = (eHeroTalentNodeSelectScale[eHeroTalentNodeType.SmallNode]).x
  self._particleDic = {}
  self._particlePool = {}
end

UINHeroTalentMap.InitHeroTalentMap = function(self, selectAct, rightOffset, selectMainAct, selectCancle)
  -- function num : 0_1
  self._selectAct = selectAct
  self._rightOffset = rightOffset or 0
  self._selectMainAct = selectMainAct
  self._selectCancle = selectCancle
end

UINHeroTalentMap.SetCampColor = function(self, color)
  -- function num : 0_2
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).center).color = color
end

UINHeroTalentMap.SetNodeMaxColor = function(self, color)
  -- function num : 0_3
  self._maxLevelColor = color
end

UINHeroTalentMap.SetTouchAreaScale = function(self, localScale)
  -- function num : 0_4
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R2 in 'UnsetPending'

  (((self.ui).touchArea).transform).localScale = localScale
end

UINHeroTalentMap.GetTouchAreaScaleX = function(self)
  -- function num : 0_5
  return ((((self.ui).touchArea).transform).localScale).x
end

UINHeroTalentMap.UpdateHeroTalentMap = function(self, talentInfo)
  -- function num : 0_6 , upvalues : _ENV
  self._talentInfo = talentInfo
  local modelId = (self._talentInfo):GetHeroTalentModelId()
  local modelCfg = (PlayerDataCenter.allHeroTalentData):GetHeroTalentModelCfg(modelId)
  if modelCfg == nil then
    return 
  end
  ;
  ((self.ui).obj_itemSelect):SetActive(false)
  local width = (modelCfg.size)[3] + self._rightOffset
  local height = (modelCfg.size)[4]
  -- DECOMPILER ERROR at PC31: Confused about usage of register: R6 in 'UnsetPending'

  ;
  (((self.ui).touchArea).transform).sizeDelta = (Vector2.New)(width, height)
  local offsetOri = (Vector3.New)(self._rightOffset / 2, 0, 0)
  -- DECOMPILER ERROR at PC42: Confused about usage of register: R7 in 'UnsetPending'

  ;
  (((self.ui).touchArea).transform).anchoredPosition = offsetOri
  local holderOri = (Vector3.New)(-self._rightOffset / 2, 0, 0)
  for _,subNode in ipairs((self.ui).touAreaSubNodes) do
    -- DECOMPILER ERROR at PC57: Confused about usage of register: R13 in 'UnsetPending'

    (subNode.transform).anchoredPosition = holderOri
  end
  self:__GenMap(modelCfg)
  ;
  (PlayerDataCenter.allHeroTalentData):RemoveHeroTalentModelCfg(modelId)
  self:__RefreshMainState()
  ;
  (((self.ui).lvParticlePrimary).gameObject):SetActive(false)
  ;
  (((self.ui).lvParticleSenior).gameObject):SetActive(false)
  for k,particleItem in pairs(self._particleDic) do
    (particleItem.gameObject):SetActive(false)
    ;
    (table.insert)(self._particlePool, particleItem)
    -- DECOMPILER ERROR at PC96: Confused about usage of register: R13 in 'UnsetPending'

    ;
    (self._particleDic)[k] = nil
  end
  self:UpdateItemTalentMap()
end

UINHeroTalentMap.UpdateItemTalentMap = function(self)
  -- function num : 0_7 , upvalues : _ENV, eHeroTalentNodeSelectScale
  for pointId,talentUINode in pairs(self._nodeDic) do
    local nodeInfo = talentUINode:GetHeroTalentNode()
    -- DECOMPILER ERROR at PC16: Unhandled construct in 'MakeBoolean' P1

    if nodeInfo:IsHeroTalentNodeCanLeveUp() and (self._particleDic)[pointId] == nil then
      local nodeType = (nodeInfo:GetHeroTalentNodeType())
      local particleItem = nil
      local poolCount = #self._particlePool
      if poolCount > 0 then
        particleItem = (table.remove)(self._particlePool, poolCount)
      else
        particleItem = ((((self.ui).uI_TalentMain_loop).gameObject):Instantiate()).transform
        particleItem:SetParent(((self.ui).particleHolder).transform)
      end
      -- DECOMPILER ERROR at PC40: Confused about usage of register: R10 in 'UnsetPending'

      ;
      (self._particleDic)[pointId] = particleItem
      particleItem.localPosition = (talentUINode.transform).localPosition
      if not eHeroTalentNodeSelectScale[nodeType] then
        do
          particleItem.localScale = Vector3.one
          ;
          (particleItem.gameObject):SetActive(true)
          do
            local particleItem = (self._particleDic)[pointId]
            if particleItem ~= nil then
              (particleItem.gameObject):SetActive(false)
              -- DECOMPILER ERROR at PC64: Confused about usage of register: R8 in 'UnsetPending'

              ;
              (self._particleDic)[pointId] = nil
              ;
              (table.insert)(self._particlePool, particleItem)
            end
            -- DECOMPILER ERROR at PC70: LeaveBlock: unexpected jumping out DO_STMT

            -- DECOMPILER ERROR at PC70: LeaveBlock: unexpected jumping out IF_THEN_STMT

            -- DECOMPILER ERROR at PC70: LeaveBlock: unexpected jumping out IF_STMT

            -- DECOMPILER ERROR at PC70: LeaveBlock: unexpected jumping out IF_THEN_STMT

            -- DECOMPILER ERROR at PC70: LeaveBlock: unexpected jumping out IF_STMT

          end
        end
      end
    end
  end
end

UINHeroTalentMap.LvUpHeroTalentMap = function(self, heroId, nodeId)
  -- function num : 0_8 , upvalues : _ENV
  if heroId ~= (self._talentInfo):GetHeroTalentHeroId() then
    return 
  end
  if (self._nodeDic)[nodeId] == nil then
    return 
  end
  local item = (self._nodeDic)[nodeId]
  item:RefreshHeroTalentNodeUI()
  local curNodeData = item:GetHeroTalentNode()
  local curLevel = curNodeData:GetHeroTalentNodeCurLevel()
  local lines = (self._reverseLineDic)[nodeId]
  if lines ~= nil then
    for toNodeId,line in pairs(lines) do
      local toNodeItem = (self._nodeDic)[toNodeId]
      local toNode = toNodeItem:GetHeroTalentNode()
      if toNodeItem ~= nil then
        local vaild = toNode:IsHeroTalentNodeUnlock()
        local isDottedLine = not vaild or toNode:GetHeroTalentNodeCurLevel() == 0
        line:RefreshHeroTalentLine(vaild, isDottedLine)
        toNodeItem:RefreshHeroTalentNodeUI()
      end
    end
  end
  local lines = (self._lineDic)[nodeId]
  if lines ~= nil then
    for preNodeId,line in pairs(lines) do
      local preNodeItem = (self._nodeDic)[preNodeId]
      if preNodeItem ~= nil and (preNodeItem:GetHeroTalentNode()):IsHeroTalentNodeUnlock() then
        line:RefreshHeroTalentLine(true, false)
      end
    end
  end
  self:__RefreshMainState()
  self:UpdateItemTalentMap()
  -- DECOMPILER ERROR: 6 unprocessed JMP targets
end

UINHeroTalentMap.ShowHeroTalentMapLvupEffect = function(self, nodeId)
  -- function num : 0_9 , upvalues : eHeroTalentNodeType
  if (self._nodeDic)[nodeId] == nil then
    return 
  end
  local item = (self._nodeDic)[nodeId]
  if (item:GetHeroTalentNode()):GetHeroTalentNodeType() == eHeroTalentNodeType.SmallNode then
    (((self.ui).lvParticlePrimary).gameObject):SetActive(false)
    ;
    (((self.ui).lvParticlePrimary).gameObject):SetActive(true)
    -- DECOMPILER ERROR at PC31: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (((self.ui).lvParticlePrimary).transform).localPosition = (item.transform).localPosition
  else
    ;
    (((self.ui).lvParticleSenior).gameObject):SetActive(false)
    ;
    (((self.ui).lvParticleSenior).gameObject):SetActive(true)
    -- DECOMPILER ERROR at PC50: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (((self.ui).lvParticleSenior).transform).localPosition = (item.transform).localPosition
  end
end

UINHeroTalentMap.__GenMap = function(self, modelCfg)
  -- function num : 0_10 , upvalues : _ENV
  for _,pool in pairs(self._nodePoolDic) do
    pool:HideAll()
  end
  ;
  (self._linePool):HideAll()
  self._nodeDic = {}
  self._lineDic = {}
  self._reverseLineDic = {}
  local oriPos = (Vector3.New)((modelCfg.oriPos)[1], (modelCfg.oriPos)[2], 0)
  -- DECOMPILER ERROR at PC28: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (((self.ui).talentMainEntityItem).transform).localPosition = oriPos
  for pointId,vec in pairs(modelCfg.pos) do
    local nodeInfo = (self._talentInfo):GetHeroTalentNodeById(pointId)
    if nodeInfo == nil then
      error(" nodeInfo is NIL,  heroId is " .. tostring((self._talentInfo):GetHeroTalentHeroId()) .. " ,point is " .. tostring(pointId))
      return 
    end
    local itemPool = (self._nodePoolDic)[nodeInfo:GetHeroTalentNodeType()]
    if itemPool == nil then
      error(" point nodeType ERROR,  heroId is " .. tostring((self._talentInfo):GetHeroTalentHeroId()) .. " ,point is " .. tostring(pointId))
      return 
    end
    local item = itemPool:GetOne()
    -- DECOMPILER ERROR at PC76: Confused about usage of register: R11 in 'UnsetPending'

    ;
    (self._nodeDic)[pointId] = item
    if self._maxLevelColor ~= nil then
      item:SetTalentMaxColor(self._maxLevelColor)
    end
    item:InitHeroTalentNode(nodeInfo, self.__OnSelectHeroTalentNode)
    ;
    ((item.gameObject).transform):SetParent(((self.ui).itemHolder).transform)
    -- DECOMPILER ERROR at PC101: Confused about usage of register: R11 in 'UnsetPending'

    ;
    ((item.gameObject).transform).localPosition = (Vector2.New)(vec[1], vec[2])
  end
  for nodeId,nodeItem in pairs(self._nodeDic) do
    local nodeInfo = nodeItem:GetHeroTalentNode()
    local preIdLevelDic = nodeInfo:GetHeroTalentNodePreIdLvDic()
    local toNodePos = (nodeItem.transform).anchoredPosition
    -- DECOMPILER ERROR at PC122: Confused about usage of register: R11 in 'UnsetPending'

    if (table.count)(preIdLevelDic) ~= 0 then
      (self._lineDic)[nodeId] = {}
      for preId,preLeve in pairs(preIdLevelDic) do
        local preItem = (self._nodeDic)[preId]
        if preItem ~= nil then
          local formNodePos = (preItem.transform).anchoredPosition
          local diffDir = formNodePos - toNodePos
          local fromPos = preItem:GetLineTargetPoint(-diffDir.x, -diffDir.y)
          fromPos = formNodePos + fromPos
          fromPos = (Vector3.New)(fromPos.x, fromPos.y, 0)
          local toPos = nodeItem:GetLineTargetPoint(diffDir.x, diffDir.y)
          toPos = toNodePos + toPos
          toPos = (Vector3.New)(toPos.x, toPos.y, 0)
          local lineItem = (self._linePool):GetOne()
          -- DECOMPILER ERROR at PC165: Confused about usage of register: R22 in 'UnsetPending'

          ;
          ((self._lineDic)[nodeId])[preId] = lineItem
          lineItem:SetHeroTalentLine(fromPos, toPos)
          local preNodeData = preItem:GetHeroTalentNode()
          if preNodeData:IsHeroTalentNodeUnlock() then
            local vaild = nodeInfo:IsHeroTalentNodeUnlock()
          end
          local isDottedLine = not vaild or nodeInfo:GetHeroTalentNodeCurLevel() == 0
          lineItem:RefreshHeroTalentLine(vaild, isDottedLine)
          -- DECOMPILER ERROR at PC196: Confused about usage of register: R25 in 'UnsetPending'

          if (self._reverseLineDic)[preId] == nil then
            (self._reverseLineDic)[preId] = {}
          end
          -- DECOMPILER ERROR at PC199: Confused about usage of register: R25 in 'UnsetPending'

          ;
          ((self._reverseLineDic)[preId])[nodeId] = lineItem
        end
      end
    end
  end
  -- DECOMPILER ERROR: 5 unprocessed JMP targets
end

UINHeroTalentMap.__RefreshMainState = function(self)
  -- function num : 0_11 , upvalues : _ENV
  local totalLv, maxLv = (self._talentInfo):GetHeroTalentTotalLevel()
  local stage = ConfigData:GetTalentStage(totalLv)
  ;
  ((self.ui).img_Icon):SetIndex(stage - 1)
end

UINHeroTalentMap.OnSelectHeroTalentNode = function(self, talentNodeItem)
  -- function num : 0_12 , upvalues : _ENV, eHeroTalentNodeSelectScale
  if talentNodeItem == nil then
    return 
  end
  local talentNodeData = talentNodeItem:GetHeroTalentNode()
  if self._selectAct ~= nil then
    (self._selectAct)(talentNodeData)
  end
  ;
  ((self.ui).obj_itemSelect):SetActive(true)
  ;
  (((self.ui).obj_itemSelect).transform):SetParent(talentNodeItem.transform)
  -- DECOMPILER ERROR at PC27: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (((self.ui).obj_itemSelect).transform).localPosition = Vector3.zero
  -- DECOMPILER ERROR at PC38: Confused about usage of register: R3 in 'UnsetPending'

  if not eHeroTalentNodeSelectScale[talentNodeData:GetHeroTalentNodeType()] then
    (((self.ui).obj_itemSelect).transform).localScale = Vector3.one
  end
end

UINHeroTalentMap.OnSelectHeroTalentMain = function(self)
  -- function num : 0_13
  ((self.ui).obj_itemSelect):SetActive(false)
  if self._selectMainAct ~= nil then
    (self._selectMainAct)(true)
  end
end

UINHeroTalentMap.OnClickCancleSelect = function(self)
  -- function num : 0_14
  if self._selectCancle ~= nil then
    ((self.ui).obj_itemSelect):SetActive(false)
    ;
    (self._selectCancle)()
  end
end

return UINHeroTalentMap

