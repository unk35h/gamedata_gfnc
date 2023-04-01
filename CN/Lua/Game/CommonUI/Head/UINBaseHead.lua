-- params : ...
-- function num : 0 , upvalues : _ENV
local UINBaseHead = class("UINBaseHead", UIBaseNode)
local base = UIBaseNode
UINBaseHead.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINBaseHead.InitBaseHead = function(self, headId, resloader, frameEffectPool)
  -- function num : 0_1
  (((self.ui).img_Frame).gameObject):SetActive(false)
  self:__RecycleFrameEffect(frameEffectPool)
  self:__InitBaseHead(headId, resloader)
end

UINBaseHead.SetLoadHeadSync = function(self)
  -- function num : 0_2
  self._isLoadSync = true
end

UINBaseHead.__InitBaseHead = function(self, headId, resloader)
  -- function num : 0_3 , upvalues : _ENV
  (((self.ui).img_UserHead).gameObject):SetActive(false)
  ;
  (((self.ui).img_DynHead).gameObject):SetActive(false)
  if headId == nil then
    return 
  end
  local cfg = (ConfigData.portrait)[headId]
  if cfg == nil then
    return 
  end
  if not (string.IsNullOrEmpty)(cfg.dyn_head) and resloader ~= nil then
    (((self.ui).img_DynHead).gameObject):SetActive(true)
    -- DECOMPILER ERROR at PC43: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.ui).img_DynHead).texture = resloader:LoadABAsset(PathConsts:GetDynHeadPath(cfg.dyn_head))
    return 
  end
  local icon = cfg.icon
  if not (string.IsNullOrEmpty)(icon) then
    (((self.ui).img_UserHead).gameObject):SetActive(true)
    -- DECOMPILER ERROR at PC66: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self.ui).img_UserHead).sprite = CRH:GetSprite(icon, CommonAtlasType.HeroHeadIcon)
  end
end

UINBaseHead.InitBaseHeadFrame = function(self, frameId, resloader, frameEffectPool)
  -- function num : 0_4
  (((self.ui).img_UserHead).gameObject):SetActive(false)
  ;
  (((self.ui).img_DynHead).gameObject):SetActive(false)
  self:__InitBaseHeadFrame(frameId, resloader, frameEffectPool)
end

UINBaseHead.__InitBaseHeadFrame = function(self, frameId, resloader, frameEffectPool)
  -- function num : 0_5 , upvalues : _ENV
  (((self.ui).img_Frame).gameObject):SetActive(true)
  if frameId == nil then
    self:__RecycleFrameEffect(frameEffectPool)
    return 
  end
  self:__RecycleFrameEffect(frameEffectPool)
  self.__frameId = frameId
  local cfg = (ConfigData.portrait_frame)[frameId]
  if cfg == nil then
    return 
  end
  if cfg.fx_type > 0 and resloader ~= nil then
    local go = nil
    if frameEffectPool ~= nil then
      go = frameEffectPool:PoolGet(frameId)
    end
    if go == nil then
      local path = PathConsts:GetDynHeadFramePath(cfg.dyn_frame)
      if self._isLoadSync then
        local prefab = resloader:LoadABAsset(path)
        self:_OnFrameLoaded(prefab, frameId, frameEffectPool)
      else
        do
          do
            do
              resloader:LoadABAssetAsync(path, function(prefab)
    -- function num : 0_5_0 , upvalues : self, frameId, frameEffectPool
    self:_OnFrameLoaded(prefab, frameId, frameEffectPool)
  end
)
              self:_SetFrameEffectGo(go, frameId)
              -- DECOMPILER ERROR at PC68: Confused about usage of register: R6 in 'UnsetPending'

              if cfg.fx_type == eHeadFrameFxType.Sequence then
                ((self.ui).img_Frame).enabled = false
                return 
              end
              -- DECOMPILER ERROR at PC72: Confused about usage of register: R5 in 'UnsetPending'

              ;
              ((self.ui).img_Frame).enabled = true
              -- DECOMPILER ERROR at PC81: Confused about usage of register: R5 in 'UnsetPending'

              ;
              ((self.ui).img_Frame).sprite = CRH:GetSprite(cfg.icon, CommonAtlasType.HeroHeadIcon)
            end
          end
        end
      end
    end
  end
end

UINBaseHead._OnFrameLoaded = function(self, prefab, frameId, frameEffectPool)
  -- function num : 0_6 , upvalues : _ENV
  if IsNull(prefab) or self.__frameId ~= frameId then
    if self.__frameId ~= self.__effectFrameId then
      self:__RecycleFrameEffect(frameEffectPool)
    end
    return 
  end
  self:__RecycleFrameEffect(frameEffectPool)
  local go = prefab:Instantiate(((self.ui).img_Frame).transform)
  self:_SetFrameEffectGo(go, frameId)
end

UINBaseHead._SetFrameEffectGo = function(self, go, frameId)
  -- function num : 0_7 , upvalues : _ENV
  self.__frameEffect = go
  ;
  ((self.__frameEffect).transform):SetParent(((self.ui).img_Frame).transform)
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.__frameEffect).transform).localPosition = Vector3.zero
  self.__effectFrameId = frameId
end

UINBaseHead.__RecycleFrameEffect = function(self, frameEffectPool)
  -- function num : 0_8 , upvalues : _ENV
  if self.__frameEffect == nil then
    return 
  end
  if frameEffectPool == nil then
    DestroyUnityObject(self.__frameEffect)
    self.__frameEffect = nil
    self.__effectFrameId = nil
    return 
  end
  if self.__effectFrameId ~= nil then
    frameEffectPool:PoolPut(self.__effectFrameId, self.__frameEffect)
    self.__frameEffect = nil
    self.__effectFrameId = nil
  else
    DestroyUnityObject(self.__frameEffect)
    self.__frameEffect = nil
  end
end

UINBaseHead.InitBaseHeadFull = function(self, headId, frameId, resloader, frameEffectPool)
  -- function num : 0_9
  self:__InitBaseHead(headId, resloader)
  self:__InitBaseHeadFrame(frameId, resloader, frameEffectPool)
end

UINBaseHead.OnDelete = function(self)
  -- function num : 0_10 , upvalues : base
  (base.OnDelete)(self)
end

return UINBaseHead

