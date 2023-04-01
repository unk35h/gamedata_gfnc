-- params : ...
-- function num : 0 , upvalues : _ENV
local UINMiniGameGroupItem = class("UINMiniGameGroupItem", UIBaseNode)
local base = UIBaseNode
UINMiniGameGroupItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).gameItem, self, self.OnClickMiniGameItem)
end

UINMiniGameGroupItem.InitMiniGameGroupItem = function(self, miniGameData, resloader, callback)
  -- function num : 0_1 , upvalues : _ENV
  self._miniGameData = miniGameData
  self._callback = callback
  local tinygameType = (self._miniGameData):GetTinyGameType()
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (self.gameObject).name = tinygameType
  local resName = "UI_MiniGameGroupListBg" .. tostring(tinygameType)
  resloader:LoadABAssetAsync(PathConsts:GetMiniGameItemPic(resName), function(texture)
    -- function num : 0_1_0 , upvalues : _ENV, self
    -- DECOMPILER ERROR at PC7: Confused about usage of register: R1 in 'UnsetPending'

    if not IsNull(self.transform) then
      ((self.ui).bottom).texture = texture
    end
  end
)
  local gameTypeCfg = (ConfigData.tiny_game_type)[tinygameType]
  -- DECOMPILER ERROR at PC30: Confused about usage of register: R7 in 'UnsetPending'

  if gameTypeCfg ~= nil then
    ((self.ui).tex_GameName).text = (LanguageUtil.GetLocaleText)(gameTypeCfg.game_name)
  else
    error("小游戏类型不存在")
  end
  self:RefreshHTGMiniGameRank()
end

UINMiniGameGroupItem.RefreshHTGMiniGameRank = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local rank = (self._miniGameData):GetHTGMineRank()
  if rank > 0 then
    ((self.ui).tex_Rank):SetIndex(0, tostring(rank))
  else
    ;
    ((self.ui).tex_Rank):SetIndex(1)
  end
end

UINMiniGameGroupItem.SetHTGMiniGameLocked = function(self, flag)
  -- function num : 0_3
  ((self.ui).obj_Locked):SetActive(flag)
end

UINMiniGameGroupItem.PlayMiniGroupItemAni = function(self, delayTime)
  -- function num : 0_4
  self:__StopAni()
  ;
  ((((self.ui).canvasGroup):DOFade(0, 0.2)):From()):SetDelay(delayTime)
  ;
  (((((self.ui).bottom).transform):DOLocalMoveY(-20, 0.2)):From()):SetDelay(delayTime)
end

UINMiniGameGroupItem.__StopAni = function(self)
  -- function num : 0_5
  ((self.ui).canvasGroup):DOComplete()
  ;
  (((self.ui).bottom).transform):DOComplete()
end

UINMiniGameGroupItem.OnClickMiniGameItem = function(self)
  -- function num : 0_6
  if self._callback ~= nil then
    (self._callback)(self._miniGameData)
  end
end

return UINMiniGameGroupItem

