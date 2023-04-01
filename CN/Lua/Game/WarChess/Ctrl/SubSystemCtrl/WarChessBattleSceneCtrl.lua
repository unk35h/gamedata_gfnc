-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.Common.CommonGameCtrl.DungeonSceneBaseCtrl")
local WarChessBattleSceneCtrl = class("WarChessBattleSceneCtrl", base)
local util = require("XLua.Common.xlua_util")
WarChessBattleSceneCtrl.ctor = function(self, wcCtrl)
  -- function num : 0_0
  self.wcCtrl = wcCtrl
end

WarChessBattleSceneCtrl.WCLoadBattleScene = function(self, sceneId, heroDic, monsters, loadOverCallback)
  -- function num : 0_1 , upvalues : _ENV, util
  self.curSceneId = sceneId
  local sceneCfg = (ConfigData.scene)[sceneId]
  if sceneCfg == nil then
    error("scene config is null,id:" .. tostring(sceneId))
    return 
  end
  self.heroPrefabs = {}
  self.heroObjectDic = {}
  local afterLoadFunc = function(result)
    -- function num : 0_1_0 , upvalues : _ENV, self, sceneCfg, util, heroDic, loadOverCallback
    local roomRoot = (((CS.UnityEngine).GameObject).Find)("RoomMap")
    if not IsNull(roomRoot) then
      self.bind = {}
      ;
      (UIUtil.LuaUIBindingTable)(roomRoot.transform, self.bind)
      -- DECOMPILER ERROR at PC20: Confused about usage of register: R2 in 'UnsetPending'

      ;
      ((self.bind).canvasGroup).alpha = 0
    end
    self.bind = {}
    ;
    (UIUtil.LuaUIBindingTable)((((CS.CameraController).Instance).transform).parent, self.bind)
    self:SetWCBattleCameraCullMask(LayerMask.UI3D)
    local loadingWindow = UIManager:GetWindow(UIWindowTypeID.WarChessLoading)
    if loadingWindow ~= nil then
      loadingWindow:PlayHideEffect()
    end
    self:CheckAndOpenSepcialMode(sceneCfg)
    local noticeWindow = UIManager:GetWindow(UIWindowTypeID.WarChessNotice)
    if noticeWindow ~= nil then
      noticeWindow:ForceHideWindow()
    end
    self._afterLoadCo = (GR.StartCoroutine)((util.cs_generator)(function()
      -- function num : 0_1_0_0 , upvalues : self, heroDic, loadOverCallback, result
      self:__InitDungeonSceneEffect()
      self:__PreLoadCharacterAndSkill({heroDic = heroDic}, self.heroPrefabs, self.heroObjectDic)
      if loadOverCallback ~= nil then
        loadOverCallback(result)
      end
      self._afterLoadCo = nil
    end
))
  end

  ;
  ((CS.GSceneManager).Instance):LoadSceneAsyncByABEx(sceneCfg.scene_name, true, true, afterLoadFunc, nil)
end

WarChessBattleSceneCtrl.GetBattleFieldSizeBySceneId = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local sceneCfg = (ConfigData.scene)[self.curSceneId]
  if sceneCfg == nil then
    error("scene cfg is null,scene_id:" .. tostring(self.curSceneId))
    return 
  end
  return sceneCfg.size_row, sceneCfg.size_col, sceneCfg.deploy_rows, sceneCfg.grid_scale_factor
end

WarChessBattleSceneCtrl.SetWCBattleCameraCullMask = function(self, LayerMaskEnum)
  -- function num : 0_3 , upvalues : _ENV
  local epMapCamera = ((CS.CameraController).Instance).EpMapCamera
  if epMapCamera then
    epMapCamera.cullingMask = 1 << LayerMaskEnum
  end
end

WarChessBattleSceneCtrl.OnWCBattleOver = function(self)
  -- function num : 0_4
  self:BattleSceneDisposeMember()
  self.heroResLoaderDic = {}
  self.heroPrefabs = {}
end

WarChessBattleSceneCtrl.OnDelete = function(self)
  -- function num : 0_5 , upvalues : _ENV, base
  if self._afterLoadCo ~= nil then
    (GR.StopCoroutine)(self._afterLoadCo)
    self._afterLoadCo = nil
  end
  ;
  (base.OnDelete)(self)
end

return WarChessBattleSceneCtrl

