-- params : ...
-- function num : 0 , upvalues : _ENV
require("Consts.PathConsts")
require("Consts.LayerMask")
require("Consts.TagConsts")
require("Consts.AreaConst")
require("Consts.UIAtlasConsts")
require("Consts.GameDefine")
require("Consts.ItemConsts")
require("Consts.LanguageConst")
require("Consts.HeroConsts")
require("Consts.TipConsts")
require("Consts.TipTagConsts")
require("Consts.ResConsts")
require("Consts.AnimationConst")
require("Consts.PicTipsConsts")
require("Consts.GameSettingConsts")
local cs_MicaSDKManager = CS.MicaSDKManager
Consts = {}
-- DECOMPILER ERROR at PC59: Confused about usage of register: R1 in 'UnsetPending'

Consts.SceneName = {Main = "003_Oasis_001", Sector = "002_Sector_001", Dorm = "004_Interior_001", Factory = "008_Factory_001", Empty = "Empty", Fight = "009_Fight_001", ShowCharacter = "006_Show_006", SnakeGame = "007_Arena_002"}
-- DECOMPILER ERROR at PC84: Confused about usage of register: R1 in 'UnsetPending'

Consts.GameChannelType = {Official = 0, Bilibili = 1, QATest = 2, BilibiliQATest = 3, BilibiliKol = 4, Kol = 5, Gray = 6, BilibiliGray = 7, InlandMax = 99, En = 100, EnQATest = 101, EnKol = 102, EnMax = 199, Jp = 200, JpQATest = 201, JpMax = 299, Kr = 300, KrQATest = 301, KrMax = 399, Tw = 400, TwQATest = 401, TwMax = 499}
-- DECOMPILER ERROR at PC88: Confused about usage of register: R1 in 'UnsetPending'

;
(Consts.GameChannelType).IsBilibili = function(channelType)
  -- function num : 0_0 , upvalues : cs_MicaSDKManager, _ENV
  if channelType == nil then
    channelType = (cs_MicaSDKManager.Instance).channelId
  end
  if channelType == (Consts.GameChannelType).Bilibili or channelType == (Consts.GameChannelType).BilibiliQATest or channelType == (Consts.GameChannelType).BilibiliKol or channelType == (Consts.GameChannelType).BilibiliGray then
    return true
  end
  return false
end

-- DECOMPILER ERROR at PC92: Confused about usage of register: R1 in 'UnsetPending'

;
(Consts.GameChannelType).IsPnSdk = function(channelType)
  -- function num : 0_1 , upvalues : cs_MicaSDKManager, _ENV
  if channelType == nil then
    channelType = (cs_MicaSDKManager.Instance).channelId
  end
  if channelType == (Consts.GameChannelType).Kr or channelType == (Consts.GameChannelType).KrQATest or channelType == (Consts.GameChannelType).Tw or channelType == (Consts.GameChannelType).TwQATest then
    return true
  end
  return false
end

-- DECOMPILER ERROR at PC96: Confused about usage of register: R1 in 'UnsetPending'

;
(Consts.GameChannelType).IsOversea = function(channelType)
  -- function num : 0_2 , upvalues : cs_MicaSDKManager, _ENV
  if channelType == nil then
    channelType = (cs_MicaSDKManager.Instance).channelId
  end
  if channelType == (Consts.GameChannelType).En or channelType == (Consts.GameChannelType).EnQATest or channelType == (Consts.GameChannelType).Jp or channelType == (Consts.GameChannelType).JpQATest then
    return true
  end
  return false
end

-- DECOMPILER ERROR at PC100: Confused about usage of register: R1 in 'UnsetPending'

;
(Consts.GameChannelType).IsInland = function(channelType)
  -- function num : 0_3 , upvalues : cs_MicaSDKManager, _ENV
  if channelType == nil then
    channelType = (cs_MicaSDKManager.Instance).channelId
  end
  if channelType < (Consts.GameChannelType).InlandMax and (Consts.GameChannelType).Official <= channelType then
    return true
  end
  return false
end

-- DECOMPILER ERROR at PC104: Confused about usage of register: R1 in 'UnsetPending'

;
(Consts.GameChannelType).IsJp = function(channelType)
  -- function num : 0_4 , upvalues : cs_MicaSDKManager, _ENV
  if channelType == nil then
    channelType = (cs_MicaSDKManager.Instance).channelId
  end
  if channelType < (Consts.GameChannelType).JpMax and (Consts.GameChannelType).Jp <= channelType then
    return true
  end
  return false
end

-- DECOMPILER ERROR at PC108: Confused about usage of register: R1 in 'UnsetPending'

;
(Consts.GameChannelType).IsEn = function(channelType)
  -- function num : 0_5 , upvalues : cs_MicaSDKManager, _ENV
  if channelType == nil then
    channelType = (cs_MicaSDKManager.Instance).channelId
  end
  if channelType < (Consts.GameChannelType).EnMax and (Consts.GameChannelType).En <= channelType then
    return true
  end
  return false
end

-- DECOMPILER ERROR at PC112: Confused about usage of register: R1 in 'UnsetPending'

;
(Consts.GameChannelType).IsTw = function(channelType)
  -- function num : 0_6 , upvalues : cs_MicaSDKManager, _ENV
  if channelType == nil then
    channelType = (cs_MicaSDKManager.Instance).channelId
  end
  if channelType < (Consts.GameChannelType).TwMax and (Consts.GameChannelType).Tw <= channelType then
    return true
  end
  return false
end

-- DECOMPILER ERROR at PC116: Confused about usage of register: R1 in 'UnsetPending'

;
(Consts.GameChannelType).IsKr = function(channelType)
  -- function num : 0_7 , upvalues : cs_MicaSDKManager, _ENV
  if channelType == nil then
    channelType = (cs_MicaSDKManager.Instance).channelId
  end
  if channelType < (Consts.GameChannelType).KrMax and (Consts.GameChannelType).Kr <= channelType then
    return true
  end
  return false
end


