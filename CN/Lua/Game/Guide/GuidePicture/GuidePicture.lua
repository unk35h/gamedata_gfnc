-- params : ...
-- function num : 0 , upvalues : _ENV
local GuidePicture = {}
local eDynConfigData = require("Game.ConfigData.eDynConfigData")
GuidePicture.OpenGuidePicture = function(guideType, completeAction, finishShowClose)
  -- function num : 0_0 , upvalues : _ENV, eDynConfigData
  local userDataCache = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  if not finishShowClose then
    finishShowClose = not userDataCache:IsGuidPicLooked(guideType)
  end
  userDataCache:RecordGuidPicLooked(guideType)
  ConfigData:LoadDynCfg(eDynConfigData.guide_describe)
  local tipsDesCfg = (ConfigData.guide_describe)[guideType]
  if tipsDesCfg ~= nil then
    UIManager:ShowWindowAsync(UIWindowTypeID.GuidePicture_0623New, function(win)
    -- function num : 0_0_0 , upvalues : guideType, completeAction, finishShowClose
    if win == nil then
      return 
    end
    win:InitGuidePicture_New(guideType, completeAction, finishShowClose)
  end
)
  else
    UIManager:ShowWindowAsync(UIWindowTypeID.GuidePicture, function(window)
    -- function num : 0_0_1 , upvalues : guideType, completeAction, finishShowClose
    window:InitGuidePicture(guideType, completeAction, finishShowClose)
  end
)
  end
  ConfigData:ReleaseDynCfg(eDynConfigData.guide_describe)
end

return GuidePicture

