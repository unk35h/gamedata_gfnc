-- params : ...
-- function num : 0 , upvalues : _ENV
local FmtHeroEntity = class("FmtHeroEntity")
local CS_ResLoader = CS.ResLoader
local infoPosOffset = (Vector3.New)(0, 1.1, 0)
local ExplorationEnum = require("Game.Exploration.ExplorationEnum")
local FmtHeroEntityState = {Init = 1, Loading = 2, Loaded = 3, Delete = 4}
FmtHeroEntity.ctor = function(self, fmtCtrl, enterFmtData)
  -- function num : 0_0
  self.fmtCtrl = fmtCtrl
  self.enterFmtData = enterFmtData
end

FmtHeroEntity.InitFmtHeroEntity = function(self, go, heroData, camera)
  -- function num : 0_1 , upvalues : CS_ResLoader, FmtHeroEntityState
  self.gameObject = go
  self.transform = go.transform
  self.heroData = heroData
  self.camera = camera
  self.modelPath = nil
  self.resloader = (CS_ResLoader.Create)()
  self.__entityState = FmtHeroEntityState.Init
  return self:LoadModel()
end

FmtHeroEntity.LoadModel = function(self)
  -- function num : 0_2 , upvalues : _ENV, FmtHeroEntityState, ExplorationEnum
  local modelPath = PathConsts:GetCharacterModelPathEx((self.heroData):GetResModelName())
  local coroutineFunc = function()
    -- function num : 0_2_0 , upvalues : self, modelPath, FmtHeroEntityState, _ENV, ExplorationEnum
    if self.modelPath == modelPath then
      return 
    end
    if self.__entityState == FmtHeroEntityState.Delete then
      return 
    end
    self.__entityState = FmtHeroEntityState.Loading
    local modelWait = (self.resloader):LoadABAssetAsyncAwait(modelPath)
    while not modelWait.IsDone do
      if self.__entityState == FmtHeroEntityState.Delete then
        return 
      end
      ;
      (coroutine.yield)(nil)
    end
    if self.__entityState == FmtHeroEntityState.Delete then
      return 
    end
    if self.heroGo ~= nil then
      DestroyUnityObject(self.heroGo)
    end
    self.modelPath = modelPath
    self.heroGo = (modelWait.Result):Instantiate(self.transform)
    -- DECOMPILER ERROR at PC55: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.heroGo).transform).localEulerAngles = (Vector3.New)(0, 180, 0)
    self.animator = (self.heroGo):FindComponent(eUnityComponentID.Animator)
    if (self.animator).isActiveAndEnabled then
      (self.animator):SetBool("InFormation", true)
    end
    self:FmtHeroOnDrag(self.__inDrag)
    local gameTypeAdapter = (ExplorationEnum.SpecGameTypeAdapter).None
    local heroId = (self.heroData).dataId
    if (self.enterFmtData):IsFmtTdSpecHero(heroId) then
      gameTypeAdapter = (ExplorationEnum.SpecGameTypeAdapter).TD
    else
      if (self.heroData).isOfficialSupport then
        gameTypeAdapter = (ExplorationEnum.SpecGameTypeAdapter).OfficialSupport
      else
        if (self.enterFmtData):IsFmtHeroRecommend(heroId) then
          gameTypeAdapter = (ExplorationEnum.SpecGameTypeAdapter).Recommend
        end
      end
    end
    self.fmtWindow = UIManager:GetWindow(UIWindowTypeID.Formation)
    do
      if self.fmtWindow ~= nil then
        local heroInfoItem = (self.fmtWindow):CreatFmtHeroInfo(self.heroData, self:__GetInfoPos())
        if heroInfoItem ~= nil then
          heroInfoItem:SetFmtSpecialGameHeroActive(gameTypeAdapter)
        end
      end
      self.__entityState = FmtHeroEntityState.Loaded
      return self
    end
  end

  return coroutineFunc
end

FmtHeroEntity.GetHeroEntityLoadedResloader = function(self)
  -- function num : 0_3 , upvalues : FmtHeroEntityState
  local resloader = self.resloader
  if self.__entityState == FmtHeroEntityState.Loaded and resloader ~= nil then
    self.resloader = nil
    return resloader
  end
  return nil
end

FmtHeroEntity.FmtHeroOnDrag = function(self, drag)
  -- function num : 0_4 , upvalues : _ENV
  self.__inDrag = drag or false
  if IsNull(self.animator) or not (self.animator).isActiveAndEnabled then
    return 
  end
  ;
  (self.animator):SetBool("DeployFloat", self.__inDrag)
  if self.fmtWindow ~= nil then
    (self.fmtWindow):ShowFmtHeroInfo((self.heroData).dataId, not self.__inDrag)
  end
end

FmtHeroEntity.__GetInfoPos = function(self)
  -- function num : 0_5 , upvalues : _ENV, infoPosOffset
  local pos = UIManager:World2UIPosition((self.transform).position + infoPosOffset, nil, nil, self.camera)
  return pos
end

FmtHeroEntity.UpdateInfoPos = function(self)
  -- function num : 0_6
  if self.fmtWindow ~= nil then
    (self.fmtWindow):UpdateFmtHeroInfo(self.heroData, self:__GetInfoPos(), true)
  end
end

FmtHeroEntity.UpdateFmtHeroEntityHeadInfo = function(self)
  -- function num : 0_7
  if self.fmtWindow ~= nil then
    (self.fmtWindow):UpdateFmtHeroInfo(self.heroData, self:__GetInfoPos())
  end
end

FmtHeroEntity.DragHeroEndTweenHeroDetailItem = function(self, position)
  -- function num : 0_8 , upvalues : _ENV
  if self.__updateInfoPosFunc == nil then
    self.__updateInfoPosFunc = BindCallback(self, self.UpdateInfoPos)
  end
  self:__ClearDragHeroEndTween()
  self.__dragEndTween = ((self.transform):DOMove(position, 0.1)):OnUpdate(self.__updateInfoPosFunc)
end

FmtHeroEntity.SetFmtHeroEntityPos = function(self, position)
  -- function num : 0_9
  self:__ClearDragHeroEndTween()
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (self.transform).position = position
  self:UpdateInfoPos()
end

FmtHeroEntity.__ClearDragHeroEndTween = function(self)
  -- function num : 0_10
  if self.__dragEndTween ~= nil then
    (self.__dragEndTween):Kill()
    self.__dragEndTween = nil
  end
end

FmtHeroEntity.GetFmtHeroEntityData = function(self)
  -- function num : 0_11
  return self.heroData
end

FmtHeroEntity.OnDelete = function(self)
  -- function num : 0_12 , upvalues : FmtHeroEntityState, _ENV
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  self.__entityState = FmtHeroEntityState.Delete
  local fmtWindow = UIManager:GetWindow(UIWindowTypeID.Formation)
  if fmtWindow ~= nil then
    fmtWindow:ReturnFmtHeroInfo((self.heroData).dataId)
  end
  self:__ClearDragHeroEndTween()
  DestroyUnityObject(self.gameObject)
end

return FmtHeroEntity

