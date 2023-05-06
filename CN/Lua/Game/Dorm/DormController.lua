-- params : ...
-- function num : 0 , upvalues : _ENV
local DormController = class("DormController", ControllerBase)
local DormUtil = require("Game.Dorm.DormUtil")
local util = require("XLua.Common.xlua_util")
local AllDormData = require("Game.Dorm.Data.AllDormData")
local DormEnum = require("Game.Dorm.DormEnum")
local DormHouseCtrl = require("Game.Dorm.Ctrl.DormHouseCtrl")
local DormRoomCtrl = require("Game.Dorm.Ctrl.DormRoomCtrl")
local DormShopCtrl = require("Game.Dorm.Ctrl.DormShopCtrl")
local DormCheckInCtrl = require("Game.Dorm.Ctrl.DormCheckInCtrl")
local DormCharacterCtrl = require("Game.Dorm.Ctrl.DormCharacterCtrl")
local DormCmderCtrl = require("Game.Dorm.Ctrl.DormCmderCtrl")
local DormAStarPathCtrl = require("Game.Dorm.Ctrl.DormAStarPathCtrl")
local DormCameraCtrl = require("Game.Dorm.Ctrl.DormCameraCtrl")
local ShopEnum = require("Game.Shop.ShopEnum")
local CS_LeanTouch = ((CS.Lean).Touch).LeanTouch
local cs_MessageCommon = CS.MessageCommon
local cs_QualitySettings = (CS.UnityEngine).QualitySettings
DormController.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self.dormNetwork = NetworkManager:GetNetwork(NetworkTypeID.Dorm)
  self.__onChangeDormBindComplete = BindCallback(self, self.OnChangeDormBindComplete)
end

DormController.PreInitDorm = function(self)
  -- function num : 0_1 , upvalues : DormEnum, _ENV, DormHouseCtrl, DormRoomCtrl, DormShopCtrl, DormAStarPathCtrl, DormCharacterCtrl, DormCmderCtrl, DormCheckInCtrl, DormCameraCtrl
  self.state = (DormEnum.eDormState).None
  self.__onDormTouchTap = BindCallback(self, self.OnDormTouchTap)
  self.__onDormTouchGesture = BindCallback(self, self.OnDormTouchGesture)
  self.ctrls = {}
  self.houseCtrl = (DormHouseCtrl.New)(self)
  self.roomCtrl = (DormRoomCtrl.New)(self)
  self.shopCtrl = (DormShopCtrl.New)(self)
  self.astarPathCtrl = (DormAStarPathCtrl.New)(self)
  self.characterCtrl = (DormCharacterCtrl.New)(self)
  self.cmderCtrl = (DormCmderCtrl.New)(self)
  self.dmCheckInCtrl = (DormCheckInCtrl.New)(self)
  self.cameraCtrl = (DormCameraCtrl.New)(self)
end

DormController.EnterDorm = function(self)
  -- function num : 0_2
  (self.dormNetwork):CS_DORM_GlobalDetail()
end

DormController.RecvDormDetailData = function(self, msg)
  -- function num : 0_3 , upvalues : AllDormData, _ENV, DormUtil, cs_QualitySettings, DormEnum, util
  self:PreInitDorm()
  self.allDormData = (AllDormData.New)()
  ;
  (self.allDormData):InitDormData(msg)
  UIManager:DeleteAllWindow()
  local defaultHouseId = 0
  if #(self.allDormData).houseIdList > 0 then
    defaultHouseId = ((self.allDormData).houseIdList)[1]
  end
  local showUnlockFx = false
  for i = #(ConfigData.dorm_house).id_sort_list, 1, -1 do
    local houseId = ((ConfigData.dorm_house).id_sort_list)[i]
    local houseData = ((self.allDormData).houseDic)[houseId]
    local saveUserData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
    local readedNew = saveUserData:GetNewDormHouseReaded(houseId)
    if houseData ~= nil and not houseData:IsDmHouseLock() and not readedNew and not houseData:IsDefaultUnlockDmHouse() then
      defaultHouseId = houseId
      showUnlockFx = true
      break
    end
  end
  do
    self.comResloader = ((CS.ResLoader).Create)()
    self.comRes = {}
    local preLoadFunc = function()
    -- function num : 0_3_0 , upvalues : self, defaultHouseId, _ENV, DormUtil
    self:LoadDormHouseNeedRes(defaultHouseId)
    local effectWait = (self.comResloader):LoadABAssetAsyncAwait("Res/Effect/Prefabs/FX_Pick.prefab")
    local fntBottomWait = (self.comResloader):LoadABAssetAsyncAwait(PathConsts:GetDormFntPath("FntBottom"))
    local gridWallWait = (self.comResloader):LoadABAssetAsyncAwait(PathConsts:GetDormRoomPath("DormWallGrid"))
    local gridFloorWait = (self.comResloader):LoadABAssetAsyncAwait(PathConsts:GetDormRoomPath("DormFloorGrid"))
    local selectRoleWait = (self.comResloader):LoadABAssetAsyncAwait(PathConsts:GetDormFntPath("SelectCharacter"))
    local greetRoleWait = (self.comResloader):LoadABAssetAsyncAwait("FX/Common/FX_Talk/FXP_Talk1-new.prefab")
    local cmderPrefabWait = (self.comResloader):LoadABAssetAsyncAwait(PathConsts:GetCharacterDormModelPath((DormUtil.GetDormCmderResName)()))
    local cmderHeadFxWait = (self.comResloader):LoadABAssetAsyncAwait(PathConsts:GetDormPath("CommonPrefab/Fx_CmdHeadGem"))
    local dormConfigAssetWait = (self.comResloader):LoadABAssetAsyncAwait("Res/ScriptableConfig/DormConfigAsset.asset")
    local moveRoomGoEffectWait = (self.comResloader):LoadABAssetAsyncAwait("FX/UI_effct/DormitoryEffcet/FXP_Shelter_go.prefab")
    local moveRoomInEffectWait = (self.comResloader):LoadABAssetAsyncAwait("FX/UI_effct/DormitoryEffcet/FXP_Shelter_in.prefab")
    ;
    (coroutine.yield)(effectWait)
    -- DECOMPILER ERROR at PC73: Confused about usage of register: R11 in 'UnsetPending'

    ;
    (self.comRes).selectRoomEffectPrefab = effectWait.Result
    ;
    (coroutine.yield)(fntBottomWait)
    -- DECOMPILER ERROR at PC80: Confused about usage of register: R11 in 'UnsetPending'

    ;
    (self.comRes).fntBottomPrefab = fntBottomWait.Result
    ;
    (coroutine.yield)(gridWallWait)
    -- DECOMPILER ERROR at PC87: Confused about usage of register: R11 in 'UnsetPending'

    ;
    (self.comRes).gridWallPrefab = gridWallWait.Result
    ;
    (coroutine.yield)(gridFloorWait)
    -- DECOMPILER ERROR at PC94: Confused about usage of register: R11 in 'UnsetPending'

    ;
    (self.comRes).gridFloorPrefab = gridFloorWait.Result
    ;
    (coroutine.yield)(selectRoleWait)
    -- DECOMPILER ERROR at PC101: Confused about usage of register: R11 in 'UnsetPending'

    ;
    (self.comRes).selectRolePrefab = selectRoleWait.Result
    ;
    (coroutine.yield)(greetRoleWait)
    -- DECOMPILER ERROR at PC108: Confused about usage of register: R11 in 'UnsetPending'

    ;
    (self.comRes).greetRolePrefab = greetRoleWait.Result
    ;
    (coroutine.yield)(cmderPrefabWait)
    -- DECOMPILER ERROR at PC115: Confused about usage of register: R11 in 'UnsetPending'

    ;
    (self.comRes).cmderPrefab = cmderPrefabWait.Result
    ;
    (coroutine.yield)(cmderHeadFxWait)
    -- DECOMPILER ERROR at PC122: Confused about usage of register: R11 in 'UnsetPending'

    ;
    (self.comRes).cmderHeadFxPrefab = cmderHeadFxWait.Result
    ;
    (coroutine.yield)(dormConfigAssetWait)
    -- DECOMPILER ERROR at PC129: Confused about usage of register: R11 in 'UnsetPending'

    ;
    (self.comRes).dormConfigAsset = dormConfigAssetWait.Result
    ;
    ((self.comRes).dormConfigAsset):FirstLoadDormConfig()
    ;
    (coroutine.yield)(moveRoomGoEffectWait)
    -- DECOMPILER ERROR at PC140: Confused about usage of register: R11 in 'UnsetPending'

    ;
    (self.comRes).moveRoomGoEffectPrefab = moveRoomGoEffectWait.Result
    ;
    (coroutine.yield)(moveRoomInEffectWait)
    -- DECOMPILER ERROR at PC147: Confused about usage of register: R11 in 'UnsetPending'

    ;
    (self.comRes).moveRoomInEffectPrefab = moveRoomInEffectWait.Result
    UIManager:ShowWindowAsync(UIWindowTypeID.DormMain)
    repeat
      (coroutine.yield)(nil)
      self.dormWindow = UIManager:GetWindow(UIWindowTypeID.DormMain)
    until self.dormWindow
  end

    ;
    (UIManager:GetWindow(UIWindowTypeID.Loading)):SetLoadingTipsSystemId(3)
    ;
    ((CS.GSceneManager).Instance):LoadSceneAsyncByAB((Consts.SceneName).Dorm, function(ok)
    -- function num : 0_3_1 , upvalues : _ENV, self, cs_QualitySettings, DormEnum, defaultHouseId, showUnlockFx
    AudioManager:PlayAudioById(3001)
    AudioManager:PlayAudioById(1088)
    ;
    ((CS.RenderManager).Instance):SetUnityShadow(true)
    self.__oldShadowDistance = cs_QualitySettings.shadowDistance
    cs_QualitySettings.shadowDistance = DormEnum.DormShadowDistance
    self.__oldLoadBias = cs_QualitySettings.lodBias
    cs_QualitySettings.lodBias = DormEnum.DormLodBias
    self:InitDorm()
    self:EnterNewDormHouse(defaultHouseId, showUnlockFx)
    ;
    (self.houseCtrl):TryPlayDmAllRoomUnlockFx()
  end
, (util.cs_generator)(preLoadFunc))
  end
end

DormController.ExitDorm = function(self)
  -- function num : 0_4 , upvalues : _ENV
  self:Delete()
  UIManager:DeleteAllWindow()
  ;
  (UIManager:GetWindow(UIWindowTypeID.Loading)):SetLoadingTipsSystemId(3)
  ;
  ((CS.GSceneManager).Instance):LoadSceneAsyncByAB((Consts.SceneName).Main, function(ok)
    -- function num : 0_4_0 , upvalues : _ENV
    (ControllerManager:GetController(ControllerTypeId.HomeController, true)):OnEnterHome()
    UIManager:ShowWindowAsync(UIWindowTypeID.Home, function(window)
      -- function num : 0_4_0_0 , upvalues : _ENV
      if window == nil then
        return 
      end
      window:SetFrom2Home(AreaConst.Sector, true)
    end
)
  end
)
end

DormController.GetDormState = function(self)
  -- function num : 0_5
  return self.state
end

DormController.IsDormState = function(self, state)
  -- function num : 0_6
  do return self.state == state end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

DormController.GetDormConfigAsset = function(self)
  -- function num : 0_7
  return (self.comRes).dormConfigAsset
end

DormController.InitDorm = function(self)
  -- function num : 0_8 , upvalues : _ENV, CS_LeanTouch
  self.bind = {}
  ;
  (UIUtil.LuaUIBindingTable)((((CS.DormCameraController).Instance).transform).parent, self.bind)
  ;
  (CS_LeanTouch.OnFingerTap)("+", self.__onDormTouchTap)
  ;
  (CS_LeanTouch.OnGesture)("+", self.__onDormTouchGesture)
  for _,v in pairs(self.ctrls) do
    v:OnEnterDormScene()
  end
end

DormController.LoadDormHouseNeedRes = function(self, houseId)
  -- function num : 0_9 , upvalues : _ENV
  if self.houseResloader ~= nil then
    (self.houseResloader):Put2Pool()
  end
  self.houseResloader = ((CS.ResLoader).Create)()
  self.houseComRes = {}
  local curHouse = ((self.allDormData).houseDic)[houseId]
  if curHouse == nil then
    error("can\'t not find house id:" .. tostring(houseId))
    return 
  end
  local defaultRoomId = curHouse:GetHouseDefaultRoom()
  local roomCfg = (ConfigData.dorm_room)[defaultRoomId]
  -- DECOMPILER ERROR at PC32: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (self.houseComRes).defaultDmRoomCfg = roomCfg
  local roomUnlockFxWait = nil
  do
    if not (string.IsNullOrEmpty)(roomCfg.unlock_fx) then
      local path = roomCfg.unlock_fx .. PathConsts.PrefabExtension
      roomUnlockFxWait = (self.houseResloader):LoadABAssetAsyncAwait(path)
    end
    local hasBgEffect = not (string.IsNullOrEmpty)(curHouse:GetDormEffectResPath())
    local bgEffectWait = nil
    if hasBgEffect then
      bgEffectWait = (self.houseResloader):LoadABAssetAsyncAwait(PathConsts:GetFullPrefabPath(curHouse:GetDormEffectResPath()))
    end
    local roomWait = (self.houseResloader):LoadABAssetAsyncAwait(PathConsts:GetDormPath("CommonPrefab/Room"))
    local lockRoomWait = (self.houseResloader):LoadABAssetAsyncAwait(PathConsts:GetDormPath(roomCfg.lock_prefab))
    local defaultFloorWait = (self.houseResloader):LoadABAssetAsyncAwait(PathConsts:GetDormPath(roomCfg.default_floor))
    local defaultWallWait = (self.houseResloader):LoadABAssetAsyncAwait(PathConsts:GetDormPath(roomCfg.default_wall))
    if roomUnlockFxWait ~= nil then
      (coroutine.yield)(roomUnlockFxWait)
      -- DECOMPILER ERROR at PC103: Confused about usage of register: R12 in 'UnsetPending'

      ;
      (self.houseComRes).roomUnlockFxPrefab = roomUnlockFxWait.Result
    end
    if hasBgEffect then
      (coroutine.yield)(bgEffectWait)
      -- DECOMPILER ERROR at PC112: Confused about usage of register: R12 in 'UnsetPending'

      ;
      (self.houseComRes).bgEffectPrefab = bgEffectWait.Result
    end
    ;
    (coroutine.yield)(roomWait)
    -- DECOMPILER ERROR at PC119: Confused about usage of register: R12 in 'UnsetPending'

    ;
    (self.houseComRes).roomPrefab = roomWait.Result
    ;
    (coroutine.yield)(lockRoomWait)
    -- DECOMPILER ERROR at PC126: Confused about usage of register: R12 in 'UnsetPending'

    ;
    (self.houseComRes).lockRoomPrefab = lockRoomWait.Result
    ;
    (coroutine.yield)(defaultFloorWait)
    -- DECOMPILER ERROR at PC133: Confused about usage of register: R12 in 'UnsetPending'

    ;
    (self.houseComRes).defaultFloorPrefab = defaultFloorWait.Result
    ;
    (coroutine.yield)(defaultWallWait)
    -- DECOMPILER ERROR at PC140: Confused about usage of register: R12 in 'UnsetPending'

    ;
    (self.houseComRes).defaultWallPrefab = defaultWallWait.Result
  end
end

DormController.EnterNewDormHouse = function(self, houseId, showUnlockFx)
  -- function num : 0_10
  (self.houseCtrl):EnterDormHouse(houseId, showUnlockFx)
end

DormController.ChangedDormHouse = function(self, houseId, afterEnterFunc)
  -- function num : 0_11 , upvalues : DormEnum, _ENV, util
  local houseData = ((self.allDormData).houseDic)[houseId]
  if houseData == nil then
    return 
  end
  if self.state == (DormEnum.eDormState).HouseEdit then
    (UIUtil.OnClickBackByUiTab)(self)
  end
  local saveUserData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  local readed = saveUserData:GetNewDormHouseReaded(houseId)
  local showUnlockHouseFx = (not houseData:IsDmHouseLock() and not readed and not houseData:IsDefaultUnlockDmHouse())
  if not houseData:IsDmHouseLock() then
    (PlayerDataCenter.dormBriefData):SetDormHouseNewReaded(houseId)
  end
  if not houseData:IsDmHouseUnlockableReaded() then
    (PlayerDataCenter.dormBriefData):SetDmHouseUnlockableReaded(houseId)
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.SceneChangesMask, function(win)
    -- function num : 0_11_0 , upvalues : self, houseId, _ENV, showUnlockHouseFx, util, afterEnterFunc
    win:InitSceneChangesMask(function()
      -- function num : 0_11_0_0 , upvalues : self, houseId, _ENV, showUnlockHouseFx, util
      local asyncLoadFunc = function()
        -- function num : 0_11_0_0_0 , upvalues : self, houseId, _ENV, showUnlockHouseFx
        self:LoadDormHouseNeedRes(houseId)
        UIManager:HideWindow(UIWindowTypeID.ClickContinue)
        self:EnterNewDormHouse(houseId, showUnlockHouseFx)
        self.__changeDormHouseCo = nil
      end

      ;
      (UIManager:ShowWindow(UIWindowTypeID.ClickContinue)):InitContinue(nil, nil, nil, Color.black, false)
      self.__changeDormHouseCo = (GR.StartCoroutine)((util.cs_generator)(asyncLoadFunc))
    end
, function()
      -- function num : 0_11_0_1 , upvalues : afterEnterFunc, showUnlockHouseFx, self
      if afterEnterFunc ~= nil then
        afterEnterFunc()
      end
      if showUnlockHouseFx then
        (self.houseCtrl):TryPlayDmAllRoomUnlockFx()
      end
    end
)
  end
)
  -- DECOMPILER ERROR: 4 unprocessed JMP targets
end

DormController.TryBuyNewHouse = function(self, houseId)
  -- function num : 0_12 , upvalues : _ENV, ShopEnum, cs_MessageCommon
  local houseData = ((self.allDormData).houseDic)[houseId]
  if houseData == nil or not houseData:IsDmHouseLock() then
    return 
  end
  local costItemId, costItemNum = houseData:GetDmHouseBuyCost()
  if costItemId ~= ConstGlobalItem.DmHouseTicket then
    error("Unsurported house Unlock")
    return 
  end
  local quickBuyData = (ShopEnum.eQuickBuy).DmHouse
  local shopId = quickBuyData.shopId
  local needItemNum = costItemNum - PlayerDataCenter:GetItemCount(costItemId)
  local shopCtrl = ControllerManager:GetController(ControllerTypeId.Shop, true)
  local isUnlcok, unlockNotice = shopCtrl:ShopIsUnlock(shopId)
  if not isUnlcok then
    (cs_MessageCommon.ShowMessageTips)(unlockNotice)
    return 
  end
  shopCtrl:GetShopData(shopId, function(shopData)
    -- function num : 0_12_0 , upvalues : costItemId, _ENV, needItemNum, shopCtrl
    local goodData = shopData:GetNormalShopGoodByItemId(costItemId)
    if goodData == nil then
      error("Cant get goodData from normalShop, itemId = " .. costItemId)
      return 
    end
    local needCurrencyNum = goodData.newCurrencyNum * needItemNum
    local fomatMsg = ConfigData:GetTipContent(335)
    local payCtrl = ControllerManager:GetController(ControllerTypeId.Pay, true)
    payCtrl:PaidCurrencyExecute(goodData.currencyId, needCurrencyNum, costItemId, needItemNum, function()
      -- function num : 0_12_0_0 , upvalues : shopCtrl, goodData, needItemNum
      shopCtrl:ReqBuyGoods(goodData.shopId, goodData.shelfId, needItemNum)
    end
, nil, fomatMsg)
  end
)
end

DormController.GetCurHouse = function(self)
  -- function num : 0_13
  return (self.houseCtrl).curHouse
end

DormController.GetCurRoomEntity = function(self)
  -- function num : 0_14
  return (self.roomCtrl).roomEntity
end

DormController.GetCurRoom = function(self)
  -- function num : 0_15
  local roomEntity = self:GetCurRoomEntity()
  if roomEntity == nil then
    return nil
  end
  return roomEntity.roomData
end

DormController.GetBindFntDataList = function(self)
  -- function num : 0_16 , upvalues : DormEnum
  if self.state == (DormEnum.eDormState).House or self.state == (DormEnum.eDormState).HouseEdit then
    local houseData = self:GetCurHouse()
    local bindFntDataList = houseData:GetHouseBindFntDataList()
    return bindFntDataList
  else
    do
      if self.state == (DormEnum.eDormState).Room or self.state == (DormEnum.eDormState).RoomEdit then
        local roomData = self:GetCurRoom()
        return roomData:GetRoomCanBindList()
      end
    end
  end
end

DormController.GetAllBindFntData = function(self)
  -- function num : 0_17
  return (self.allDormData):GetAllBindFntData()
end

DormController.SetAllBindFntDataDirty = function(self)
  -- function num : 0_18
  (self.allDormData):SetAllBindFntDataDirty()
end

DormController.ChangeDormBind = function(self, fntData, newHeroId)
  -- function num : 0_19
  local oldHeroId = fntData:GetFntParam()
  if oldHeroId == newHeroId then
    return 
  end
  local curRoomData = fntData:GetFntRoom()
  self._dormBindDatas = {newHeroId = newHeroId, fntData = fntData}
  local houseId = ((self.houseCtrl).curHouse).id
  local roomPos = curRoomData.spos
  local bind = newHeroId ~= 0
  local heroId = bind and newHeroId or oldHeroId
  local index = curRoomData:GetFntDataIndex(fntData) - 1
  ;
  (self.dormNetwork):CS_DORM_BindUnbindHero(heroId, bind, houseId, roomPos, index, self.__onChangeDormBindComplete)
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

DormController.OnChangeDormBindComplete = function(self, dataList)
  -- function num : 0_20
  local success = dataList[0]
  if success then
    local oldBindId = ((self._dormBindDatas).fntData):GetFntParam()
    ;
    ((self._dormBindDatas).fntData):SetFntParam((self._dormBindDatas).newHeroId)
    local curRoomData = ((self._dormBindDatas).fntData):GetFntRoom()
    local allBindFntData = self:GetAllBindFntData()
    local newHeroBindFntData = (allBindFntData.boundDic)[(self._dormBindDatas).newHeroId]
    if newHeroBindFntData ~= nil then
      newHeroBindFntData:SetFntParam(0)
      local newheroRoomData = nil
      newheroRoomData = newHeroBindFntData:GetFntRoom()
      if newheroRoomData ~= curRoomData then
        local fntDatas = newheroRoomData:GetFntDatas()
        newheroRoomData:UpdateRoomFntData(fntDatas, false)
      end
    end
    do
      do
        local newfntDatas = curRoomData:GetFntDatas()
        curRoomData:UpdateRoomFntData(newfntDatas, false)
        self:SetAllBindFntDataDirty()
        ;
        (self.characterCtrl):SetBindCharacterChange((self._dormBindDatas).fntData, oldBindId, (self._dormBindDatas).newHeroId)
        if self.dormWindow ~= nil then
          (self.dormWindow):RefreshDormHeroList()
        end
        self._dormBindDatas = nil
      end
    end
  end
end

DormController.EnterDormOverview = function(self)
  -- function num : 0_21 , upvalues : _ENV
  print("UIWindowTypeID.DormOverview: the prefab is Delete")
end

DormController.RecvPurchaseHouse = function(self, houseId)
  -- function num : 0_22 , upvalues : _ENV
  (self.allDormData):AddNewHouse(houseId)
  if (self.houseCtrl):GetCurHouseId() == houseId then
    (PlayerDataCenter.dormBriefData):SetDormHouseNewReaded(houseId)
  end
  if self.dormWindow ~= nil then
    (self.dormWindow):RefreshDormWindow()
  end
end

DormController.EmitEnterDormHouse = function(self)
  -- function num : 0_23 , upvalues : DormEnum, _ENV
  self.state = (DormEnum.eDormState).House
  for _,v in pairs(self.ctrls) do
    v:OnEnterDormHouse()
  end
end

DormController.EmitEnterDormHouseEditMode = function(self)
  -- function num : 0_24 , upvalues : DormEnum, _ENV
  self.state = (DormEnum.eDormState).HouseEdit
  for _,v in pairs(self.ctrls) do
    v:OnEnterDormHouseEditMode()
  end
end

DormController.EmitExitDormHouseEditMode = function(self, success)
  -- function num : 0_25 , upvalues : DormEnum, _ENV
  self.state = (DormEnum.eDormState).House
  for _,v in pairs(self.ctrls) do
    v:OnExitDormHouseEditMode(success)
  end
end

DormController.EmitEnterDormRoomEditMode = function(self, roomEntity)
  -- function num : 0_26 , upvalues : DormEnum, _ENV
  self.state = (DormEnum.eDormState).RoomEdit
  for _,v in pairs(self.ctrls) do
    v:OnEnterDormRoomEditMode(roomEntity)
  end
end

DormController.EmitExitDormRoomEditMode = function(self, roomEntity, success)
  -- function num : 0_27 , upvalues : DormEnum, _ENV
  self.state = (DormEnum.eDormState).Room
  for _,v in pairs(self.ctrls) do
    v:OnExitDormRoomEditMode(roomEntity, success)
  end
end

DormController.EmitEnterDormRoomStart = function(self, roomEntity)
  -- function num : 0_28 , upvalues : DormEnum, _ENV
  self.state = (DormEnum.eDormState).House2Room
  UIManager:HideWindow(UIWindowTypeID.DormMain)
  for _,v in pairs(self.ctrls) do
    v:OnEnterDormRoomStart(roomEntity)
  end
end

DormController.EmitEnterDormRoomEnd = function(self)
  -- function num : 0_29 , upvalues : DormEnum, _ENV
  self.state = (DormEnum.eDormState).Room
  local roomEntity = self:GetCurRoomEntity()
  if roomEntity == nil then
    return 
  end
  for _,v in pairs(self.ctrls) do
    v:OnEnterDormRoomEnd(roomEntity)
  end
end

DormController.EmitExitDormRoomStart = function(self, toOtherRoom)
  -- function num : 0_30 , upvalues : DormEnum, _ENV
  self.state = (DormEnum.eDormState).Room2House
  local roomEntity = self:GetCurRoomEntity()
  if roomEntity == nil then
    return 
  end
  for _,v in pairs(self.ctrls) do
    v:OnExitDormRoomStart(roomEntity, toOtherRoom)
  end
end

DormController.EmitExitDormRoomEnd = function(self)
  -- function num : 0_31 , upvalues : DormEnum, _ENV
  self.state = (DormEnum.eDormState).House
  UIManager:ShowWindowOnly(UIWindowTypeID.DormMain)
  for _,v in pairs(self.ctrls) do
    v:OnExitDormRoomEnd()
  end
end

DormController.EnterDormEditor = function(self, callback)
  -- function num : 0_32 , upvalues : DormEnum
  if not self:IsDormState((DormEnum.eDormState).House) then
    return 
  end
  self:EmitEnterDormHouseEditMode()
  ;
  (self.dormWindow):ShowDormEditMode(true)
end

DormController.OpenDormShop = function(self)
  -- function num : 0_33
  (self.shopCtrl):EnterDormShop()
end

DormController.OpenDormWarehouse = function(self)
  -- function num : 0_34 , upvalues : DormEnum
  if (self.state == (DormEnum.eDormState).HouseEdit and self.state == (DormEnum.eDormState).Room) or self.state == (DormEnum.eDormState).RoomEdit then
    (self.roomCtrl):ShowFntWarehouse(true)
  end
end

DormController.OnDormTouchTap = function(self, finger)
  -- function num : 0_35 , upvalues : DormEnum, _ENV
  if finger.StartedOverGui then
    return 
  end
  if self:IsDormState((DormEnum.eDormState).House) then
    if self.dormWindow ~= nil then
      (self.dormWindow):Show()
    end
    UIManager:ShowWindowOnly(UIWindowTypeID.TopStatus)
    return 
  end
  if self:IsDormState((DormEnum.eDormState).Room) then
    local roomWindow = UIManager:GetWindow(UIWindowTypeID.DormRoom)
    if roomWindow ~= nil and roomWindow:IsRoomUIHideState() then
      UIManager:ShowWindowOnly(UIWindowTypeID.DormRoom)
      UIManager:ShowWindowOnly(UIWindowTypeID.TopStatus)
      UIManager:ShowWindowOnly(UIWindowTypeID.DormInput)
      UIManager:ShowWindowOnly(UIWindowTypeID.DormInteract)
    end
    return 
  end
end

DormController.OnDormTouchGesture = function(self, fingerList)
  -- function num : 0_36
end

DormController.ReqDormTimingProductPick = function(self, tmProductData, callback)
  -- function num : 0_37 , upvalues : _ENV
  if not tmProductData:CanTmProductRes(true) then
    return 
  end
  self._reqTmProductPickCallback = callback
  if not self._OnDormTimingProductPickFunc then
    self._OnDormTimingProductPickFunc = BindCallback(self, self.OnDormTimingProductPick)
    ;
    (NetworkManager:GetNetwork(NetworkTypeID.TimingProduct)):CS_TimingProduct_Pick(proto_csmsg_SystemFunctionID.SystemFunctionID_Dorm, tmProductData.id, self._OnDormTimingProductPickFunc)
  end
end

DormController.OnDormTimingProductPick = function(self, objList)
  -- function num : 0_38 , upvalues : _ENV
  if self._reqTmProductPickCallback ~= nil then
    (self._reqTmProductPickCallback)()
  end
  if objList.Count == 0 then
    error("objList.Count == 0")
    return 
  end
  local addItemDic = objList[0]
  self:_OnGetRes(addItemDic)
end

DormController.ReqDormTimingProductPickAll = function(self, callback)
  -- function num : 0_39 , upvalues : _ENV, cs_MessageCommon
  local tmProductGroupDic = (PlayerDataCenter.allTimingProduct):GetTimingProductDataGroupItemId(proto_csmsg_SystemFunctionID.SystemFunctionID_Dorm)
  local fullWareHouseItemDic = {}
  local cantGetOne = false
  for k,tmProductDic in pairs(tmProductGroupDic) do
    for k2,tmProductData in pairs(tmProductDic) do
      local cantGet = tmProductData:CanTmProductRes(false, fullWareHouseItemDic)
      if cantGet then
        cantGetOne = true
      end
    end
  end
  for name,_ in pairs(fullWareHouseItemDic) do
    (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(TipContent.ItemInWarehouseFull, name), true)
  end
  if not cantGetOne then
    return 
  end
  self._reqTmProductPickAllCallback = callback
  if not self._OnDormTimingProductPickAllFunc then
    self._OnDormTimingProductPickAllFunc = BindCallback(self, self.OnDormTimingProductPickAll)
    ;
    (NetworkManager:GetNetwork(NetworkTypeID.TimingProduct)):CS_TimingProduct_PickAll(proto_csmsg_SystemFunctionID.SystemFunctionID_Dorm, self._OnDormTimingProductPickAllFunc)
  end
end

DormController.OnDormTimingProductPickAll = function(self, objList)
  -- function num : 0_40 , upvalues : _ENV
  if self._reqTmProductPickAllCallback ~= nil then
    (self._reqTmProductPickAllCallback)()
  end
  if objList.Count == 0 then
    error("objList.Count == 0")
    return 
  end
  local addItemDic = objList[0]
  self:_OnGetRes(addItemDic)
end

DormController._OnGetRes = function(self, addItemDic)
  -- function num : 0_41 , upvalues : _ENV, cs_MessageCommon
  for resId,resNum in pairs(addItemDic) do
    local itemCfg = (ConfigData.item)[resId]
    if itemCfg ~= nil then
      local msg = ConfigData:GetTipContent(TipContent.Building_GainReward, (LanguageUtil.GetLocaleText)(itemCfg.name), resNum)
      ;
      (cs_MessageCommon.ShowMessageTips)(msg, true)
    end
  end
  AudioManager:PlayAudioById(1090)
end

DormController.__ClearData = function(self)
  -- function num : 0_42 , upvalues : DormEnum, CS_LeanTouch, _ENV, cs_QualitySettings
  self.state = (DormEnum.eDormState).None
  self.bind = nil
  self.allDormData = nil
  if self.__onDormTouchTap ~= nil then
    (CS_LeanTouch.OnFingerTap)("-", self.__onDormTouchTap)
    self.__onDormTouchTap = nil
  end
  if self.__onDormTouchGesture ~= nil then
    (CS_LeanTouch.OnGesture)("-", self.__onDormTouchGesture)
    self.__onDormTouchGesture = nil
  end
  if self.comResloader ~= nil then
    (self.comResloader):Put2Pool()
    self.comResloader = nil
  end
  self.comRes = nil
  if self.houseResloader ~= nil then
    (self.houseResloader):Put2Pool()
    self.houseResloader = nil
  end
  self.houseComRes = nil
  if self.__changeDormHouseCo ~= nil then
    (GR.StopCoroutine)(self.__changeDormHouseCo)
    self.__changeDormHouseCo = nil
  end
  if self.ctrls ~= nil then
    for _,v in pairs(self.ctrls) do
      v:OnDelete()
    end
    self.ctrls = nil
  end
  ;
  ((CS.RenderManager).Instance):SetUnityShadow(false)
  if self.__oldShadowDistance ~= nil then
    cs_QualitySettings.shadowDistance = self.__oldShadowDistance
    self.__oldShadowDistance = nil
  end
  if self.__oldLoadBias ~= nil then
    cs_QualitySettings.lodBias = self.__oldLoadBias
    self.__oldLoadBias = nil
  end
  AudioManager:RemoveCueSheet(eAuCueSheet.DormFurniture)
end

DormController.OnDelete = function(self)
  -- function num : 0_43
  self:__ClearData()
end

return DormController

