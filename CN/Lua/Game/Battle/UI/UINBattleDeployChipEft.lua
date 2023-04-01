-- params : ...
-- function num : 0 , upvalues : _ENV
local UINBattleDeployChipEft = class("UINBattleDeployChipEft", UIBaseNode)
local base = UIBaseNode
local CS_DOTween = ((CS.DG).Tweening).DOTween
local CS_Object = (CS.UnityEngine).Object
local CS_WaitForSeconds = (CS.UnityEngine).WaitForSeconds
local util = require("XLua.Common.xlua_util")
UINBattleDeployChipEft.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINBattleDeployChipEft.StartEft = function(self, skills, startPos, targetObj, resloader)
  -- function num : 0_1
  self:ResetEftState(skills, targetObj, resloader)
  self:PlayLineEftShow(startPos)
  self:PlayHeroChipShow()
end

UINBattleDeployChipEft.ResetEftState = function(self, skills, targetObj, resloader)
  -- function num : 0_2 , upvalues : _ENV
  self._eftRuning = true
  self.resloader = resloader
  self.skills = skills
  self.targetTr = targetObj.transform
  self.oriTargetWorldPos = (self.targetTr).position
  self.timerId = TimerManager:StartTimer(0.1, self.CheckTargetMove, self)
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).lineRenderNor).enabled = true
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).lineRenderHigh).enabled = true
  local matLineNor = ((self.ui).lineRenderNor):GetMaterial()
  local matLineHigh = ((self.ui).lineRenderHigh):GetMaterial()
  matLineNor:SetFloat("_BFAlpha", 0)
  matLineHigh:SetFloat("_BFAlpha", 0)
  matLineHigh:SetFloat("_BFPanner01", 0)
  ;
  (((self.ui).eftUnitChipEft).gameObject):SetActive(false)
  ;
  (((self.ui).eftUnitChipEftShow).gameObject):SetActive(false)
  ;
  (((self.ui).eftUnitChipEft).transform):SetParent(self.targetTr)
  -- DECOMPILER ERROR at PC64: Confused about usage of register: R6 in 'UnsetPending'

  ;
  (((self.ui).eftUnitChipEft).transform).localPosition = Vector3.zero
  -- DECOMPILER ERROR at PC70: Confused about usage of register: R6 in 'UnsetPending'

  ;
  (((self.ui).eftUnitChipEft).transform).localScale = Vector3.one
  ;
  (((self.ui).eftUnitChipEftShow).transform):SetParent(self.targetTr)
  -- DECOMPILER ERROR at PC82: Confused about usage of register: R6 in 'UnsetPending'

  ;
  (((self.ui).eftUnitChipEftShow).transform).localPosition = Vector3.zero
  -- DECOMPILER ERROR at PC88: Confused about usage of register: R6 in 'UnsetPending'

  ;
  (((self.ui).eftUnitChipEftShow).transform).localScale = Vector3.one
end

UINBattleDeployChipEft.PlayLineEftShow = function(self, startPos)
  -- function num : 0_3 , upvalues : CS_DOTween, _ENV, util, CS_WaitForSeconds
  if self.eftTween ~= nil then
    (self.eftTween):Kill()
    self.eftTween = nil
  end
  startPos.z = 0
  local matLineNor = ((self.ui).lineRenderNor):GetMaterial()
  local matLineHigh = ((self.ui).lineRenderHigh):GetMaterial()
  self.eftTween = (CS_DOTween.Sequence)()
  ;
  (self.eftTween):Insert((self.ui).lineAppearDelayTime, matLineNor:DOFloat(1, "_BFAlpha", (self.ui).lineAppearTime))
  ;
  (self.eftTween):Insert((self.ui).lineAppearDelayTime, matLineHigh:DOFloat(1, "_BFAlpha", (self.ui).lineAppearTime))
  ;
  (self.eftTween):Insert((self.ui).lineLightDelayTime, matLineHigh:DOFloat(1, "_BFPanner01", (self.ui).lineLightTime))
  ;
  (self.eftTween):Insert((self.ui).lineMissDelayTime, matLineNor:DOFloat(0, "_BFAlpha", (self.ui).lineMissTime))
  ;
  (self.eftTween):Insert((self.ui).lineMissDelayTime, matLineHigh:DOFloat(0, "_BFAlpha", (self.ui).lineMissTime))
  if self._eftCo ~= nil then
    (GR.StopCoroutine)(self._eftCo)
    self._eftCo = nil
  end
  self._eftCo = (GR.StartCoroutine)((util.cs_generator)(function()
    -- function num : 0_3_0 , upvalues : _ENV, CS_WaitForSeconds, self, startPos
    (coroutine.yield)(CS_WaitForSeconds((self.ui).buttonEftDelayTime))
    ;
    (((self.ui).eftUnitChipEft).gameObject):SetActive(true)
    ;
    (coroutine.yield)(CS_WaitForSeconds((self.ui).eftStarDelayTime))
    local x, y = UIManager:World2UIPositionOut(self.targetTr, (self.ui).chipEft, UIManager:GetUICamera(), UIManager:GetMainCamera())
    ;
    ((self.ui).lineRenderNor):SetPosition(0, startPos)
    ;
    ((self.ui).lineRenderNor):SetPosition(1, (Vector3.Temp)(startPos.x, y, 0))
    ;
    ((self.ui).lineRenderNor):SetPosition(2, (Vector3.Temp)(x, y, 0))
    ;
    ((self.ui).lineRenderHigh):SetPosition(0, startPos)
    ;
    ((self.ui).lineRenderHigh):SetPosition(1, (Vector3.Temp)(startPos.x, y, 0))
    ;
    ((self.ui).lineRenderHigh):SetPosition(2, (Vector3.Temp)(x, y, 0))
    self._eftCo = nil
  end
))
  ;
  (self.eftTween):SetAutoKill(false)
end

UINBattleDeployChipEft.PlayHeroChipShow = function(self)
  -- function num : 0_4 , upvalues : CS_Object, _ENV, util, CS_WaitForSeconds
  local maxEftCount = #(self.ui).arr_chipEft
  ;
  (((self.ui).eftUnitChipEftShow).gameObject):SetActive(true)
  ;
  ((self.ui).eftUnitChipEftShow):SetCountAllActive(false)
  if self.customMats == nil then
    self.customMats = {}
    for i = 1, maxEftCount do
      local newMat = (CS_Object.Instantiate)((((self.ui).arr_chipEft)[i]):GetMaterial())
      -- DECOMPILER ERROR at PC31: Confused about usage of register: R7 in 'UnsetPending'

      ;
      (self.customMats)[i] = newMat
      -- DECOMPILER ERROR at PC35: Confused about usage of register: R7 in 'UnsetPending'

      ;
      (((self.ui).arr_chipEft)[i]).material = newMat
    end
  end
  do
    local singleUnitTime = (self.ui).EftTime / (math.ceil)(#self.skills / (self.ui).maxShowOnceTime)
    if singleUnitTime <= 1 or not singleUnitTime then
      singleUnitTime = 1
    end
    for _,parSys in ipairs((self.ui).arr_allShowEft) do
      -- DECOMPILER ERROR at PC63: Confused about usage of register: R8 in 'UnsetPending'

      (parSys.main).duration = singleUnitTime - singleUnitTime / (self.ui).maxShowOnceTime
    end
    if self._eftChipShowCo ~= nil then
      (GR.StopCoroutine)(self._eftChipShowCo)
      self._eftChipShowCo = nil
    end
    self._eftChipShowCo = (GR.StartCoroutine)((util.cs_generator)(function()
    -- function num : 0_4_0 , upvalues : _ENV, CS_WaitForSeconds, self, maxEftCount, singleUnitTime
    while 1 do
      (coroutine.yield)(CS_WaitForSeconds((self.ui).chipEftDelayTime + (self.ui).eftStarDelayTime))
      self.eftObjIdOrders = {}
      local oriTable = nil
      for i = 1, #self.skills do
        if i % (self.ui).maxShowOnceTime == 1 then
          oriTable = {}
          for i = 1, maxEftCount do
            if (self.eftObjIdOrders)[#self.eftObjIdOrders] ~= i then
              (table.insert)(oriTable, i)
            end
          end
        end
        do
          do
            local index = (math.random)(#oriTable)
            ;
            (table.insert)(self.eftObjIdOrders, oriTable[index])
            ;
            (table.remove)(oriTable, index)
            -- DECOMPILER ERROR at PC55: LeaveBlock: unexpected jumping out DO_STMT

          end
        end
      end
      for i = 1, #self.skills do
        local skillData = (self.skills)[i]
        local index = (self.eftObjIdOrders)[i]
        ;
        ((self.ui).eftUnitChipEftShow):SetCountActive(index - 1, false)
        ;
        ((self.ui).eftUnitChipEftShow):SetCountActive(index - 1, true)
        local mat = (self.customMats)[index]
        local itemCfg = (ConfigData.item)[skillData.itemId]
        if itemCfg ~= nil then
          local sprite = CRH:GetSpriteByItemConfig(itemCfg)
          local newTexture = sprite.texture
          local size = (Vector2.New)((sprite.rect).width / newTexture.width, (sprite.rect).height / newTexture.height)
          local diffWidth = ((sprite.rect).width - (sprite.textureRect).width) / 2
          local diffHeight = ((sprite.rect).height - (sprite.textureRect).height) / 2
          local offset = (Vector2.New)((((sprite.textureRect).position).x - diffWidth) / newTexture.width, (((sprite.textureRect).position).y - diffHeight) / newTexture.height)
          mat:SetTexture("_Maintex", newTexture)
          mat:SetTextureOffset("_Maintex", offset)
          mat:SetTextureScale("_Maintex", size)
          local color = (ChipDetailColor[eChipLevelToQaulity[skillData.level]]).light
          mat:SetColor("_LevelColor", color)
        end
        do
          do
            if i % (self.ui).maxShowOnceTime == 0 or i == #self.skills then
              (coroutine.yield)(CS_WaitForSeconds(singleUnitTime))
            else
              ;
              (coroutine.yield)(CS_WaitForSeconds(singleUnitTime / (self.ui).maxShowOnceTime))
            end
            -- DECOMPILER ERROR at PC175: LeaveBlock: unexpected jumping out DO_STMT

          end
        end
      end
    end
    self._eftChipShowCo = nil
  end
))
  end
end

UINBattleDeployChipEft.ResetSkillsEft = function(self, skills)
  -- function num : 0_5
  self.skills = skills
  self:PlayHeroChipShow()
end

UINBattleDeployChipEft.EndEft = function(self)
  -- function num : 0_6 , upvalues : _ENV
  if not self._eftRuning then
    return 
  end
  self._eftRuning = false
  if self.timerId ~= nil then
    TimerManager:StopTimer(self.timerId)
    self.timerId = nil
  end
  if self.eftTween ~= nil then
    (self.eftTween):Kill()
    self.eftTween = nil
  end
  if self._eftCo ~= nil then
    (GR.StopCoroutine)(self._eftCo)
    self._eftCo = nil
  end
  if self._eftChipShowCo ~= nil then
    (GR.StopCoroutine)(self._eftChipShowCo)
    self._eftChipShowCo = nil
  end
  -- DECOMPILER ERROR at PC38: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).lineRenderNor).enabled = false
  -- DECOMPILER ERROR at PC41: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).lineRenderHigh).enabled = false
  ;
  (((self.ui).eftUnitChipEft).transform):SetParent(self.transform)
  ;
  (((self.ui).eftUnitChipEftShow).transform):SetParent(self.transform)
  ;
  (((self.ui).eftUnitChipEft).gameObject):SetActive(false)
  ;
  (((self.ui).eftUnitChipEftShow).gameObject):SetActive(false)
end

UINBattleDeployChipEft.CheckTargetMove = function(self)
  -- function num : 0_7 , upvalues : _ENV
  if not IsNull(self.targetTr) and self.oriTargetWorldPos == (self.targetTr).position then
    return 
  end
  if self.timerId ~= nil then
    TimerManager:StopTimer(self.timerId)
    self.timerId = nil
  end
  if self.eftTween ~= nil then
    (self.eftTween):Kill()
    self.eftTween = nil
  end
  if self._eftCo ~= nil then
    (GR.StopCoroutine)(self._eftCo)
    self._eftCo = nil
  end
  -- DECOMPILER ERROR at PC36: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).lineRenderNor).enabled = false
  -- DECOMPILER ERROR at PC39: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).lineRenderHigh).enabled = false
  ;
  (((self.ui).eftUnitChipEft).gameObject):SetActive(false)
end

UINBattleDeployChipEft.OnHide = function(self)
  -- function num : 0_8 , upvalues : base
  self:EndEft()
  ;
  (base.OnHide)(self)
end

UINBattleDeployChipEft.OnDelete = function(self)
  -- function num : 0_9 , upvalues : base, _ENV
  (base.OnDelete)(self)
  if self.customMats ~= nil then
    for _,mat in ipairs(self.customMats) do
      DestroyUnityObject(mat)
    end
    self.customMats = nil
  end
end

return UINBattleDeployChipEft

