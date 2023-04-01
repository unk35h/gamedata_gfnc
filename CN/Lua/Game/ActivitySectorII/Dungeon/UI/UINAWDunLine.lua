-- params : ...
-- function num : 0 , upvalues : _ENV
local UINAWDunLine = class("UINAWDunLine", UIBaseNode)
local base = UIBaseNode
UINAWDunLine.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self:__ReSetUIState()
end

UINAWDunLine.RefreshAWDunLine = function(self, lastLevelPos, cueLevelPos, nextDunData)
  -- function num : 0_1
  self:__DrawLine(lastLevelPos, cueLevelPos)
  self:__SetLineState(nextDunData)
end

UINAWDunLine.__DrawLine = function(self, lastLevelPos, cueLevelPos)
  -- function num : 0_2 , upvalues : _ENV
  local length, angle, dirVector = nil, nil, nil
  length = (Vector2.Distance)(lastLevelPos, cueLevelPos)
  dirVector = cueLevelPos - lastLevelPos
  angle = (Vector2.Angle)(Vector2.right, dirVector)
  angle = angle * (((Vector3.Cross)(Vector3.right, (Vector3.New)(dirVector.x, dirVector.y, 0))).z > 0 and 1 or -1)
  -- DECOMPILER ERROR at PC35: Confused about usage of register: R6 in 'UnsetPending'

  ;
  (self.transform).anchoredPosition = lastLevelPos
  -- DECOMPILER ERROR at PC43: Confused about usage of register: R6 in 'UnsetPending'

  ;
  (self.transform).localEulerAngles = (Vector3.New)(0, 0, angle)
  -- DECOMPILER ERROR at PC52: Confused about usage of register: R6 in 'UnsetPending'

  ;
  (self.transform).sizeDelta = (Vector2.New)(length, ((self.transform).sizeDelta).y)
  self.length = length
end

UINAWDunLine.__SetLineState = function(self, nextDunData)
  -- function num : 0_3 , upvalues : _ENV
  self:__ReSetUIState()
  local isUnlock = nextDunData:GetIsLevelUnlock()
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R3 in 'UnsetPending'

  if not isUnlock then
    ((self.ui).img_PipeLine).enabled = true
    return 
  end
  local isComplete = nextDunData:GetIsLevelComplete()
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R4 in 'UnsetPending'

  if isUnlock and isComplete then
    ((self.ui).img_Line).enabled = true
    return 
  end
  local cs_Material = (CS.UnityEngine).Material
  self.__pipeMat = cs_Material((self.ui).mat_Pipe)
  -- DECOMPILER ERROR at PC31: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).lineRender).material = self.__pipeMat
  local tiling = self.length / 24
  ;
  (self.__pipeMat):SetTextureScale("_MainTex", (Vector2.New)(tiling, 1))
  -- DECOMPILER ERROR at PC45: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).lineRender).enabled = true
end

UINAWDunLine.__ReSetUIState = function(self)
  -- function num : 0_4
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R1 in 'UnsetPending'

  ((self.ui).img_Line).enabled = false
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).img_PipeLine).enabled = false
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).lineRender).enabled = false
end

UINAWDunLine.OnDelete = function(self)
  -- function num : 0_5 , upvalues : _ENV, base
  if self.__pipeMat ~= nil then
    DestroyUnityObject((self.self).__pipeMat)
  end
  ;
  (base.OnDelete)(self)
end

return UINAWDunLine

