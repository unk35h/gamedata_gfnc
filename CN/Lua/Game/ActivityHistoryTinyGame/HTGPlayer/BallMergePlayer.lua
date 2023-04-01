-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.ActivityHistoryTinyGame.HTGPlayer.Base.HTGPlayerBase")
local BallMergeTinyGameData = class("BallMergeTinyGameData", base)
local GameWatermelonData = require("Game.ActivityCarnival.GameWatermelonData")
BallMergeTinyGameData.ctor = function(self)
  -- function num : 0_0
end

BallMergeTinyGameData.InitTinyGameData = function(self)
  -- function num : 0_1 , upvalues : GameWatermelonData, base
  self.gameWatermelonData = (GameWatermelonData.New)(self.__tinyGameUID, self.__tinyGameInstanceId)
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self.gameWatermelonData).UploadWatermelonScore = function(gameWatermelonData, score, callback)
    -- function num : 0_1_0 , upvalues : self
    self:HTGCommonSettle(score, callback)
  end

  ;
  (base.InitTinyGameData)(self)
end

BallMergeTinyGameData.EnterTinyGame = function(self)
  -- function num : 0_2 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.Carnival22MiniGame, function(win)
    -- function num : 0_2_0 , upvalues : self
    if win ~= nil then
      win:InitCarnivalMiniGame(self, true, self)
    end
  end
)
end

BallMergeTinyGameData.GetCarnivalTinyGame = function(self)
  -- function num : 0_3
  return self.gameWatermelonData
end

return BallMergeTinyGameData

