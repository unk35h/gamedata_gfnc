-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINWarChessInfoInfoRoot = class("UINWarChessInfoInfoRoot", base)
local eWCInteractType = require("Game.WarChess.Interact.Base.eWCInteractType")
local WarChessHelper = require("Game.WarChess.WarChessHelper")
UINWarChessInfoInfoRoot.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.__showPos = nil
  self.__showOrgPos = nil
  self.__showOffset = Vector3.zero
  self.__preHpRate = nil
end

UINWarChessInfoInfoRoot.WCIRSetShowPos = function(self, showPos)
  -- function num : 0_1
  self.__showOrgPos = showPos
  self.__showPos = self.__showOrgPos + self.__showOffset
  self:WCIRUpdatPos()
end

UINWarChessInfoInfoRoot.WCIRSetShowPosOffset = function(self, offsetY)
  -- function num : 0_2 , upvalues : _ENV
  self.__showOffset = (Vector3.New)(0, offsetY, 0)
  self.__showPos = self.__showOrgPos + self.__showOffset
  self:WCIRUpdatPos()
end

UINWarChessInfoInfoRoot.WCIRIsInView = function(self, xMin, yMin, xMax, yMax)
  -- function num : 0_3
  if xMin == nil or yMin == nil or xMax == nil or yMax == nil then
    return true
  end
  local x = (self.__showPos).x
  local y = (self.__showPos).z
  do return xMin <= x and x <= xMax and yMin <= y and y <= yMax end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UINWarChessInfoInfoRoot.WCIRUpdatPos = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local uiPos = UIManager:World2UIPosition(self.__showPos, (self.transform).parent)
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (self.transform).anchoredPosition = uiPos
end

UINWarChessInfoInfoRoot.SetResloader = function(self, resloader)
  -- function num : 0_5 , upvalues : _ENV
  self.resloader = resloader
  self.iconAtlas = resloader:LoadABAsset(PathConsts:GetAtlasAssetPath("WarChess"))
end

UINWarChessInfoInfoRoot.PopInfoRoot4Entity = function(self, entityData, winInfo)
  -- function num : 0_6 , upvalues : _ENV, WarChessHelper
  self.entityData = entityData
  self.winInfo = winInfo
  ;
  ((self.gameObject).transform):SetAsLastSibling()
  local showPos = entityData:GetEntityShowPos()
  self:WCIRSetShowPos(showPos)
  local offsetY = entityData:GetInteractShowOffset()
  self:WCIRSetShowPosOffset(offsetY)
  local isMonster = entityData:GetEntityIsMonster()
  local iconRes = (self.entityData):GetWCUnitInterActIcon()
  self.__opIconItem = ((self.winInfo).opIconPool):GetOne()
  ;
  (self.__opIconItem):SetWCIIOpIcon(self.iconAtlas, iconRes)
  ;
  (self.__opIconItem):PlayWCIIIOpIconntoTween()
  ;
  ((self.__opIconItem).transform):SetParent((self.ui).iconHolder)
  -- DECOMPILER ERROR at PC44: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.__opIconItem).transform).localPosition = Vector3.one
  if isMonster then
    local hpRate = entityData:GetWCMonsterHP()
    if hpRate < 1 then
      self.__hpBarItem = ((self.winInfo).hpBarPool):GetOne()
      ;
      (self.__hpBarItem):SetWCIIHPBar(true, hpRate)
      ;
      ((self.__hpBarItem).transform):SetParent((self.ui).hpBarHolder)
      -- DECOMPILER ERROR at PC71: Confused about usage of register: R8 in 'UnsetPending'

      ;
      ((self.__hpBarItem).transform).localPosition = Vector3.one
    end
    if self.__enemyMoveItem == nil then
      local isOK, maxPathLength = (WarChessHelper.CheckEnemyCanMove)(entityData)
      if isOK then
        self.__enemyMoveItem = ((self.winInfo).enemyMovePool):GetOne()
        ;
        (self.__enemyMoveItem):SetCouldMoveDistance(maxPathLength)
        ;
        ((self.__enemyMoveItem).transform):SetParent((self.ui).enemyMoveHolder)
        -- DECOMPILER ERROR at PC99: Confused about usage of register: R10 in 'UnsetPending'

        ;
        ((self.__enemyMoveItem).transform).localPosition = Vector3.zero
      end
    end
  end
  do
    self:UpdateAllInfo()
  end
end

UINWarChessInfoInfoRoot.PopInfoRoot4Grid = function(self, gridData, winInfo)
  -- function num : 0_7 , upvalues : eWCInteractType, _ENV
  self.gridData = gridData
  self.winInfo = winInfo
  ;
  ((self.gameObject).transform):SetAsLastSibling()
  local showPos = gridData:GetGridShowPos()
  self:WCIRSetShowPos(showPos)
  local offsetY = gridData:GetInteractShowOffset()
  self:WCIRSetShowPosOffset(offsetY)
  if gridData:GetFirstGridInertactWithCat(eWCInteractType.born) ~= nil then
    if gridData:GetCouldShowBornFX() then
      self.__deployMarkItem = ((self.winInfo).deployPool):GetOne()
      ;
      ((self.__deployMarkItem).transform):SetParent((self.ui).iconHolder)
      -- DECOMPILER ERROR at PC40: Confused about usage of register: R5 in 'UnsetPending'

      ;
      ((self.__deployMarkItem).transform).localPosition = Vector3.one
    end
    return 
  end
  local iconRes = (self.gridData):GetWCUnitInterActIcon()
  self.__opIconItem = ((self.winInfo).opIconPool):GetOne()
  ;
  (self.__opIconItem):SetWCIIOpIcon(self.iconAtlas, iconRes)
  ;
  (self.__opIconItem):PlayWCIIIOpIconntoTween()
  ;
  ((self.__opIconItem).transform):SetParent((self.ui).iconHolder)
  -- DECOMPILER ERROR at PC68: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.__opIconItem).transform).localPosition = Vector3.one
  self:UpdateAllInfo()
end

UINWarChessInfoInfoRoot.PopInfoRoot4Team = function(self, teamData, winInfo)
  -- function num : 0_8 , upvalues : _ENV
  self.teamData = teamData
  self.winInfo = winInfo
  ;
  ((self.gameObject).transform):SetAsFirstSibling()
  local index = teamData:GetWCTeamIndex()
  local heroEntity = (((self.winInfo).wcCtrl).teamCtrl):GetWCHeroEntity(index, nil, nil)
  local showPos = heroEntity:WCHeroEntityGetShowPos()
  self:WCIRSetShowPos(showPos)
  self:WCIRSetShowPosOffset(0.5)
  local hpRate = teamData:GetWCTeamHP()
  self.__hpBarItem = ((self.winInfo).hpBarPool):GetOne()
  if self.__TeamHpLerpTimer then
    TimerManager:StopTimer(self.__TeamHpLerpTimer)
    self.__TeamHpLerpTimer = nil
  end
  ;
  (self.__hpBarItem):SetWCIIHPBar(false, hpRate)
  self.__preHpRate = hpRate
  ;
  ((self.__hpBarItem).transform):SetParent((self.ui).hpBarHolder)
  -- DECOMPILER ERROR at PC54: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.__hpBarItem).transform).localPosition = Vector3.one
  local ap = teamData:GetTeamActionPoint()
  local maxAp = (((self.winInfo).wcCtrl).teamCtrl):GetWCAPMaxNum()
  self.__teamInfoItem = ((self.winInfo).teamInfoPool):GetOne()
  ;
  (self.__teamInfoItem):SetWCIITeamInfo(teamData, ap, maxAp)
  ;
  ((self.__teamInfoItem).transform):SetParent((self.ui).teamHolder)
  -- DECOMPILER ERROR at PC83: Confused about usage of register: R9 in 'UnsetPending'

  ;
  ((self.__teamInfoItem).transform).localPosition = Vector3.one
  self:UpdateAllInfo()
end

UINWarChessInfoInfoRoot.UpdateAllInfo = function(self)
  -- function num : 0_9 , upvalues : _ENV
  if (self.winInfo).selectedTeamData ~= self.teamData then
    local isSelected = self.teamData == nil
    ;
    (self.__teamInfoItem):SetWCIITeamInfoIsSelected(isSelected)
    local ap = (self.teamData):GetTeamActionPoint()
    local maxAp = (((self.winInfo).wcCtrl).teamCtrl):GetWCAPMaxNum()
    ;
    (self.__teamInfoItem):SetWCIITeamInfo(self.teamData, ap, maxAp)
    do
      local teamHeadIconId = (self.teamData):GetTeamHeadIcon()
      ;
      (self.__teamInfoItem):SetWCIITeamInfoOverraHeadIconId(self.iconAtlas, teamHeadIconId)
      if self.gridData ~= nil then
        if (self.winInfo).curInterActData == self.gridData then
          (((self.winInfo).OPNode).transform):SetParent(((self.ui).opHolder).transform)
          -- DECOMPILER ERROR at PC58: Confused about usage of register: R1 in 'UnsetPending'

          ;
          (((self.winInfo).OPNode).transform).localPosition = Vector3.one
          ;
          ((self.winInfo).OPNode):Show()
        end
        local couldShowDeployFX = (self.gridData):GetCouldShowBornFX()
        if couldShowDeployFX and self.__deployMarkItem == nil then
          self.__deployMarkItem = ((self.winInfo).deployPool):GetOne()
          ;
          ((self.__deployMarkItem).transform):SetParent((self.ui).iconHolder)
          -- DECOMPILER ERROR at PC86: Confused about usage of register: R2 in 'UnsetPending'

          ;
          ((self.__deployMarkItem).transform).localPosition = Vector3.one
        end
        if not couldShowDeployFX and self.__deployMarkItem ~= nil then
          ((self.__deployMarkItem).transform):SetParent((((self.winInfo).ui).infoItems).transform)
          ;
          ((self.winInfo).deployPool):HideOne(self.__deployMarkItem)
          self.__deployMarkItem = nil
        end
        if self.__opIconItem ~= nil then
          local iconRes = (self.gridData):GetWCUnitInterActIcon()
          ;
          (self.__opIconItem):SetWCIIOpIcon(self.iconAtlas, iconRes)
        end
      elseif self.entityData ~= nil then
        if (self.winInfo).curInterActData == self.entityData then
          (((self.winInfo).OPNode).transform):SetParent(((self.ui).opHolder).transform)
          -- DECOMPILER ERROR at PC139: Confused about usage of register: R1 in 'UnsetPending'

          ;
          (((self.winInfo).OPNode).transform).localPosition = Vector3.one
          ;
          ((self.winInfo).OPNode):Show()
        end
        do
          if self.__opIconItem ~= nil then
            local iconRes = (self.entityData):GetWCUnitInterActIcon()
            ;
            (self.__opIconItem):SetWCIIOpIcon(self.iconAtlas, iconRes)
          end
          do
            local headIconOverraidId = (self.entityData):GetEntityHeadIcon()
            if headIconOverraidId ~= nil then
              if self.__entityHeadIconItem == nil then
                self.__entityHeadIconItem = ((self.winInfo).entityHeadIconPool):GetOne()
                ;
                ((self.__entityHeadIconItem).transform):SetParent((self.ui).entityHeadIconHolder)
                -- DECOMPILER ERROR at PC178: Confused about usage of register: R2 in 'UnsetPending'

                ;
                ((self.__entityHeadIconItem).transform).localPosition = Vector3.one
              end
              ;
              (self.__entityHeadIconItem):RefreshEntityHeadIcon(self.iconAtlas, headIconOverraidId)
            elseif self.__entityHeadIconItem ~= nil then
              ((self.__entityHeadIconItem).transform):SetParent((((self.winInfo).ui).infoItems).transform)
              ;
              ((self.winInfo).entityHeadIconPool):HideOne(self.__entityHeadIconItem)
              self.__entityHeadIconItem = nil
            end
            self:WCIRSetInteractInfoActive((self.winInfo).selectedTeamData ~= nil, (self.winInfo).selectedTeamData)
            -- DECOMPILER ERROR: 12 unprocessed JMP targets
          end
        end
      end
    end
  end
end

UINWarChessInfoInfoRoot.ShowTeamApReduceTip = function(self, changeTeam, diffAp)
  -- function num : 0_10
  (self.__teamInfoItem):ShowWCIITeamInfoApReduceTip(changeTeam, diffAp)
end

UINWarChessInfoInfoRoot.CheckEntityCanMove = function(self)
  -- function num : 0_11 , upvalues : WarChessHelper, _ENV
  local entityData = self.entityData
  if entityData ~= nil and entityData:GetEntityIsMonster() and self.__enemyMoveItem == nil then
    local isOK, maxPathLength = (WarChessHelper.CheckEnemyCanMove)(entityData)
    if isOK then
      self.__enemyMoveItem = ((self.winInfo).enemyMovePool):GetOne()
      ;
      (self.__enemyMoveItem):SetCouldMoveDistance(maxPathLength)
      ;
      ((self.__enemyMoveItem).transform):SetParent((self.ui).enemyMoveHolder)
      -- DECOMPILER ERROR at PC34: Confused about usage of register: R4 in 'UnsetPending'

      ;
      ((self.__enemyMoveItem).transform).localPosition = Vector3.zero
    end
  end
end

UINWarChessInfoInfoRoot.WCInfoGetData = function(self)
  -- function num : 0_12
  if self.entityData ~= nil then
    return self.entityData
  end
  if self.gridData ~= nil then
    return self.gridData
  end
  if self.teamData ~= nil then
    return self.teamData
  end
  if self.winInfo ~= nil then
    return self.winInfo
  end
  return nil
end

UINWarChessInfoInfoRoot.WCIRSetInteractInfoActive = function(self, bool, teamData)
  -- function num : 0_13 , upvalues : WarChessHelper
  local isInInteractableRange = false
  if teamData ~= nil then
    local couldInetactDic = (teamData:GetWCTeamInteractablePosDic())
    local coordination = nil
    if self.gridData ~= nil then
      coordination = (WarChessHelper.Pos2Coordination)((self.gridData):GetGridLogicPos())
    else
      if self.entityData ~= nil then
        coordination = (WarChessHelper.Pos2Coordination)((self.entityData):GetEntityLogicPos())
      end
    end
    isInInteractableRange = couldInetactDic[coordination]
  end
  do
    self:SetIsShowselfOpIconItem(not bool or isInInteractableRange)
  end
end

UINWarChessInfoInfoRoot.RefreshWCTeamHpBar = function(self)
  -- function num : 0_14 , upvalues : _ENV
  if self.teamData == nil or self.__hpBarItem == nil then
    return 
  end
  local hpRate = (self.teamData):GetWCTeamHP()
  local distance = (Mathf.Abs)(self.__preHpRate - hpRate)
  if distance >= 0.01 then
    local lerpSeconds = 0.5
    do
      local lerpSpeed = distance / lerpSeconds
      local curRate = self.__preHpRate
      if self.__TeamHpLerpTimer then
        TimerManager:StopTimer(self.__TeamHpLerpTimer)
        self.__TeamHpLerpTimer = nil
      end
      self.__TeamHpLerpTimer = TimerManager:StartTimer(0, function()
    -- function num : 0_14_0 , upvalues : _ENV, curRate, hpRate, self, lerpSpeed
    if (Mathf.Abs)(curRate - hpRate) < 0.05 or not self.__hpBarItem then
      if self.__hpBarItem then
        (self.__hpBarItem):SetWCIIHPBar(false, hpRate)
      end
      TimerManager:StopTimer(self.__TeamHpLerpTimer)
      self.__TeamHpLerpTimer = nil
      return 
    end
    curRate = (Mathf.Lerp)(curRate, hpRate, lerpSpeed * Time.unscaledDeltaTime)
    ;
    (self.__hpBarItem):SetWCIIHPBar(false, curRate)
  end
, self, false, true, true)
    end
  else
    do
      ;
      (self.__hpBarItem):SetWCIIHPBar(false, hpRate)
      self.__preHpRate = hpRate
    end
  end
end

UINWarChessInfoInfoRoot.RefreshWCMonsterHpBar = function(self)
  -- function num : 0_15 , upvalues : _ENV
  if self.entityData == nil then
    return 
  end
  local isMonster = (self.entityData):GetEntityIsMonster()
  if isMonster then
    local hpRate = (self.entityData):GetWCMonsterHP()
    if hpRate >= 1 then
      if self.__hpBarItem ~= nil then
        ((self.winInfo).hpBarPool):HideOne(self.__hpBarItem)
        self.__hpBarItem = nil
      end
      return 
    end
    if self.__hpBarItem == nil then
      self.__hpBarItem = ((self.winInfo).hpBarPool):GetOne()
      ;
      ((self.__hpBarItem).transform):SetParent((self.ui).hpBarHolder)
      -- DECOMPILER ERROR at PC42: Confused about usage of register: R3 in 'UnsetPending'

      ;
      ((self.__hpBarItem).transform).localPosition = Vector3.one
    end
    ;
    (self.__hpBarItem):SetWCIIHPBar(true, hpRate)
  end
end

UINWarChessInfoInfoRoot.SetIsShowselfOpIconItem = function(self, bool)
  -- function num : 0_16
  if self.__opIconItem ~= nil then
    if bool then
      (self.__opIconItem):Show()
    else
      ;
      (self.__opIconItem):Hide()
    end
  end
end

UINWarChessInfoInfoRoot.SetIsShowHeadIcon = function(self, bool)
  -- function num : 0_17
  if self.__entityHeadIconItem ~= nil then
    if bool then
      (self.__entityHeadIconItem):Show()
    else
      ;
      (self.__entityHeadIconItem):Hide()
    end
  end
end

UINWarChessInfoInfoRoot.OnHide = function(self)
  -- function num : 0_18 , upvalues : _ENV
  if self.__opIconItem ~= nil then
    ((self.__opIconItem).transform):SetParent((((self.winInfo).ui).infoItems).transform)
    ;
    ((self.winInfo).opIconPool):HideOne(self.__opIconItem)
    self.__opIconItem = nil
  end
  if self.__hpBarItem ~= nil then
    ((self.__hpBarItem).transform):SetParent((((self.winInfo).ui).infoItems).transform)
    ;
    ((self.winInfo).hpBarPool):HideOne(self.__hpBarItem)
    self.__hpBarItem = nil
  end
  if self.__teamInfoItem ~= nil then
    ((self.__teamInfoItem).transform):SetParent((((self.winInfo).ui).infoItems).transform)
    ;
    ((self.winInfo).teamInfoPool):HideOne(self.__teamInfoItem)
    self.__teamInfoItem = nil
  end
  if self.__deployMarkItem ~= nil then
    ((self.__deployMarkItem).transform):SetParent((((self.winInfo).ui).infoItems).transform)
    ;
    ((self.winInfo).deployPool):HideOne(self.__deployMarkItem)
    self.__deployMarkItem = nil
  end
  if self.__enemyMoveItem ~= nil then
    ((self.__enemyMoveItem).transform):SetParent((((self.winInfo).ui).infoItems).transform)
    ;
    ((self.winInfo).enemyMovePool):HideOne(self.__enemyMoveItem)
    self.__enemyMoveItem = nil
  end
  if self.__entityHeadIconItem ~= nil then
    ((self.__entityHeadIconItem).transform):SetParent((((self.winInfo).ui).infoItems).transform)
    ;
    ((self.winInfo).entityHeadIconPool):HideOne(self.__entityHeadIconItem)
    self.__entityHeadIconItem = nil
  end
  self.entityData = nil
  self.gridData = nil
  self.teamData = nil
  self.winInfo = nil
  self.__showOrgPos = Vector3.zero
  self.__showOffset = Vector3.zero
end

UINWarChessInfoInfoRoot.OnDelete = function(self)
  -- function num : 0_19 , upvalues : _ENV, base
  self.iconAtlas = nil
  if self.__TeamHpLerpTimer then
    TimerManager:StopTimer(self.__TeamHpLerpTimer)
    self.__TeamHpLerpTimer = nil
  end
  ;
  (base.OnDelete)(self)
end

return UINWarChessInfoInfoRoot

