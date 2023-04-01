-- params : ...
-- function num : 0 , upvalues : _ENV
local SmashingPenguinsMapBlock = class("SmashingPenguinsMapBlock", UIBaseNode)
local base = UIBaseNode
SmashingPenguinsMapBlock.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.cannonEntities = {}
  self.bombEntities = {}
  self.windEntities = {}
  self.upWallEntities = {}
  self.midWallEntities = {}
  self.downWallEntities = {}
end

SmashingPenguinsMapBlock.InitSmashingPenguinsMapBlock = function(self, characterEntity, controller, pos)
  -- function num : 0_1
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R4 in 'UnsetPending'

  (self.transform).localPosition = pos
  self.characterEntity = characterEntity
  self.mainController = controller
  self:ShowMapBlock(characterEntity, controller)
end

SmashingPenguinsMapBlock.ShowMapBlock = function(self, characterEntity, controller)
  -- function num : 0_2 , upvalues : _ENV, base
  local mainUI = UIManager:GetWindow(UIWindowTypeID.SmashingPenguins)
  for iCannonIndex = 1, #(self.ui).array_cannons do
    local cannon = (mainUI.cannonPool):GetOne()
    local fakePos = (((self.ui).array_cannons)[iCannonIndex]).position
    cannon:InitEntityData(characterEntity, controller)
    -- DECOMPILER ERROR at PC23: Confused about usage of register: R10 in 'UnsetPending'

    ;
    (cannon.transform).position = fakePos
    cannon:LookAtDir(Vector3.left)
    -- DECOMPILER ERROR at PC29: Confused about usage of register: R10 in 'UnsetPending'

    ;
    (self.cannonEntities)[iCannonIndex] = cannon
  end
  for iBombIndex = 1, #(self.ui).array_bombs do
    local bomb = (mainUI.bombPool):GetOne()
    local fakePos = (((self.ui).array_bombs)[iBombIndex]).position
    bomb:InitEntityData(characterEntity, controller)
    -- DECOMPILER ERROR at PC49: Confused about usage of register: R10 in 'UnsetPending'

    ;
    (bomb.transform).position = fakePos
    -- DECOMPILER ERROR at PC51: Confused about usage of register: R10 in 'UnsetPending'

    ;
    (self.bombEntities)[iBombIndex] = bomb
  end
  for iWindIndex = 1, #(self.ui).array_winds do
    local wind = (mainUI.windPool):GetOne()
    local fakePos = (((self.ui).array_winds)[iWindIndex]).position
    wind:InitEntityData(characterEntity, controller)
    -- DECOMPILER ERROR at PC71: Confused about usage of register: R10 in 'UnsetPending'

    ;
    (wind.transform).position = fakePos
    -- DECOMPILER ERROR at PC73: Confused about usage of register: R10 in 'UnsetPending'

    ;
    (self.windEntities)[iWindIndex] = wind
  end
  for iUpWallIndex = 1, #(self.ui).array_upWall do
    local upWall = (mainUI.upWallPool):GetOne()
    local fakePos = (((self.ui).array_upWall)[iUpWallIndex]).position
    upWall:InitEntityData(characterEntity, controller)
    -- DECOMPILER ERROR at PC93: Confused about usage of register: R10 in 'UnsetPending'

    ;
    (upWall.transform).position = fakePos
    -- DECOMPILER ERROR at PC95: Confused about usage of register: R10 in 'UnsetPending'

    ;
    (self.upWallEntities)[iUpWallIndex] = upWall
  end
  for iMidWallIndex = 1, #(self.ui).array_midWall do
    local midWall = (mainUI.midWallPool):GetOne()
    local fakePos = (((self.ui).array_midWall)[iMidWallIndex]).position
    midWall:InitEntityData(characterEntity, controller)
    -- DECOMPILER ERROR at PC115: Confused about usage of register: R10 in 'UnsetPending'

    ;
    (midWall.transform).position = fakePos
    -- DECOMPILER ERROR at PC117: Confused about usage of register: R10 in 'UnsetPending'

    ;
    (self.midWallEntities)[iMidWallIndex] = midWall
  end
  for iDownWallIndex = 1, #(self.ui).array_downWall do
    local downWall = (mainUI.downWallPool):GetOne()
    local fakePos = (((self.ui).array_downWall)[iDownWallIndex]).position
    downWall:InitEntityData(characterEntity, controller)
    -- DECOMPILER ERROR at PC137: Confused about usage of register: R10 in 'UnsetPending'

    ;
    (downWall.transform).position = fakePos
    -- DECOMPILER ERROR at PC139: Confused about usage of register: R10 in 'UnsetPending'

    ;
    (self.downWallEntities)[iDownWallIndex] = downWall
  end
  ;
  (base.Show)(self)
end

SmashingPenguinsMapBlock.HideMapBlock = function(self)
  -- function num : 0_3 , upvalues : _ENV, base
  local mainUI = UIManager:GetWindow(UIWindowTypeID.SmashingPenguins)
  for iCannonIndex = 1, #self.cannonEntities do
    (mainUI.cannonPool):HideOne((self.cannonEntities)[iCannonIndex])
  end
  for iBombIndex = 1, #(self.ui).array_bombs do
    (mainUI.bombPool):HideOne((self.bombEntities)[iBombIndex])
  end
  for iWindIndex = 1, #(self.ui).array_winds do
    (mainUI.windPool):HideOne((self.windEntities)[iWindIndex])
  end
  for iUpWallIndex = 1, #(self.ui).array_upWall do
    (mainUI.upWallPool):HideOne((self.upWallEntities)[iUpWallIndex])
  end
  for iMidWallIndex = 1, #(self.ui).array_midWall do
    (mainUI.midWallPool):HideOne((self.midWallEntities)[iMidWallIndex])
  end
  for iDownWallIndex = 1, #(self.ui).array_downWall do
    (mainUI.downWallPool):HideOne((self.downWallEntities)[iDownWallIndex])
  end
  ;
  (base.Hide)(self)
end

return SmashingPenguinsMapBlock

