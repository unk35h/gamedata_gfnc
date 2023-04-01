-- params : ...
-- function num : 0 , upvalues : _ENV
local UIHandBookSkin = class("UIHandBookSkin", UIBaseWindow)
local base = UIBaseWindow
local UINHBSkinSingle = require("Game.HandBook.UI.Skin.UINHBSkinSingle")
local UINHandBookSkinTag = require("Game.HandBook.UI.Skin.UINHandBookSkinTag")
local CS_Resloader = CS.ResLoader
local cs_Tweening = (CS.DG).Tweening
local SkinConditionSortOrder = {[proto_csmsg_SystemFunctionID.SystemFunctionID_Store] = 1, [proto_csmsg_SystemFunctionID.SystemFunctionID_Gift] = 2, [proto_csmsg_SystemFunctionID.SystemFunctionID_Operate_Active] = 3, [proto_csmsg_SystemFunctionID.SystemFunctionID_HeroRank] = 4}
UIHandBookSkin.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, CS_Resloader, UINHBSkinSingle, UINHandBookSkinTag
  (UIUtil.SetTopStatus)(self, self.OnClickCloseSingle)
  self.__SelectSkinCallback = BindCallback(self, self.__SelectSkin)
  self._resloder = (CS_Resloader.Create)()
  self._itemPool = (UIItemPool.New)(UINHBSkinSingle, (self.ui).skinItem)
  ;
  ((self.ui).skinItem):SetActive(false)
  self._tagPool = (UIItemPool.New)(UINHandBookSkinTag, ((self.ui).hot).gameObject)
  ;
  (((self.ui).hot).gameObject):SetActive(false)
  self.__OnActivityShowChangeCallback = BindCallback(self, self.__OnActivityShowChange)
  MsgCenter:AddListener(eMsgEventId.ActivityShowChange, self.__OnActivityShowChangeCallback)
end

UIHandBookSkin.InitHBSkinThemeSingle = function(self, themeId, isInSell, callback)
  -- function num : 0_1 , upvalues : _ENV
  self._isInSell = isInSell
  self._themeId = themeId
  self._callback = callback
  local themeCfg = (ConfigData.skinTheme)[themeId]
  self._hbCtrl = ControllerManager:GetController(ControllerTypeId.HandBook)
  ;
  (self._hbCtrl):SetHBViewSetLayer(2, (LanguageUtil.GetLocaleText)(themeCfg.name))
  ;
  (((self.ui).img_SkinBg).gameObject):SetActive(false)
  ;
  (self._resloder):LoadABAssetAsync(PathConsts:GetHeroSkinThemePicPath(themeCfg.pic), function(Texture)
    -- function num : 0_1_0 , upvalues : _ENV, self
    if Texture == nil or IsNull(self.transform) then
      return 
    end
    -- DECOMPILER ERROR at PC10: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_SkinBg).texture = Texture
    ;
    (((self.ui).img_SkinBg).gameObject):SetActive(true)
  end
)
  -- DECOMPILER ERROR at PC40: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_SkinGroupName).text = (LanguageUtil.GetLocaleText)(themeCfg.name)
  -- DECOMPILER ERROR at PC47: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_Des).text = (LanguageUtil.GetLocaleText)(themeCfg.theme_info)
  local skinIdList = ((ConfigData.skin).themeDic)[self._themeId]
  local totalCount = 0
  self._skinCfgList = {}
  for i,skinId in ipairs(skinIdList) do
    if (PlayerDataCenter.skinData):IsSkinUnlocked(skinId) then
      local skinCfg = (ConfigData.skin)[skinId]
      if skinCfg == nil then
        error("skin is nil id is " .. tostring(skinId))
      else
        if not skinCfg.skin_locked then
          (table.insert)(self._skinCfgList, skinCfg)
          totalCount = totalCount + 1
        end
      end
    end
  end
  self._totalCount = totalCount
  self:RefreshHBSkinItems()
  self:RefreshHBSkinCollect(isInSell)
end

UIHandBookSkin.PlayeHBSkinAni = function(self, startWorldPos)
  -- function num : 0_2 , upvalues : _ENV, cs_Tweening
  self:__StopAni()
  ;
  (((self.ui).skinGroupItem):DOScale((Vector2.New)(1.26, 1.26), 0.2)):From()
  ;
  ((((self.ui).skinGroupItem):DOMove(startWorldPos, 0.2)):From()):SetEase((cs_Tweening.Ease).OutQuad)
  ;
  ((((self.ui).slider):DOValue(0, 0.5)):From()):SetEase((cs_Tweening.Ease).OutQuad)
  for index,item in ipairs((self._itemPool).listItem) do
    item:PlayHBSkinSingleAni(index * 0.066)
  end
end

UIHandBookSkin.__StopAni = function(self)
  -- function num : 0_3
  ((self.ui).skinGroupItem):DOComplete()
  ;
  ((self.ui).skinGroupItem):DOComplete()
  ;
  ((self.ui).slider):DOComplete()
end

UIHandBookSkin.RefreshHBSkinItems = function(self)
  -- function num : 0_4 , upvalues : _ENV, SkinConditionSortOrder
  local skinCtrl = ControllerManager:GetController(ControllerTypeId.Skin, true)
  ;
  (table.sort)(self._skinCfgList, function(a, b)
    -- function num : 0_4_0 , upvalues : skinCtrl, SkinConditionSortOrder, _ENV
    local aConditionList = skinCtrl:GetAllSourceValid(a.id)
    local bConditionList = skinCtrl:GetAllSourceValid(b.id)
    local aCount = #aConditionList
    local bCount = #bConditionList
    if bCount >= aCount then
      do return aCount == bCount end
      if aCount > 0 then
        local aCondition = aConditionList[1]
        local bCondition = bConditionList[1]
        if not SkinConditionSortOrder[aCondition] then
          local aOrder = math.maxinteger
        end
        if not SkinConditionSortOrder[bCondition] then
          local bOrder = math.maxinteger
        end
        if aOrder >= bOrder then
          do
            do return aOrder == bOrder end
            do return b.id < a.id end
            -- DECOMPILER ERROR: 7 unprocessed JMP targets
          end
        end
      end
    end
  end
)
  ;
  (self._itemPool):HideAll()
  for index,skinCfg in ipairs(self._skinCfgList) do
    local item = (self._itemPool):GetOne()
    item:InitHBSkinSingle(skinCfg, self._resloder, self.__SelectSkinCallback)
  end
end

UIHandBookSkin.RefreshHBSkinCollect = function(self, isInSell)
  -- function num : 0_5 , upvalues : _ENV
  if self._isInSell ~= isInSell then
    self:RefreshHBSkinItems()
  end
  self._isInSell = isInSell
  local count = (self._hbCtrl):GetSkinThemeCollectNum(self._themeId)
  ;
  ((self.ui).tex_Progress):SetIndex(0, tostring(count), tostring(self._totalCount))
  -- DECOMPILER ERROR at PC26: Confused about usage of register: R3 in 'UnsetPending'

  if self._totalCount == 0 then
    ((self.ui).slider).value = 1
  else
    -- DECOMPILER ERROR at PC32: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).slider).value = count / self._totalCount
  end
  ;
  (self._tagPool):HideAll()
  do
    if isInSell then
      local tag = (self._tagPool):GetOne()
      tag:InitBookSkinTag(1)
    end
    if ((ConfigData.skin).themeActivityDic)[self._themeId] ~= nil then
      local activityCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
      local flag = false
      for actFrameId,_ in pairs(((ConfigData.skin).themeActivityDic)[self._themeId]) do
        local activityData = activityCtrl:GetActivityFrameData(R12_PC67)
        if activityData ~= nil and activityData:IsActivityOpen() then
          flag = true
          break
        end
      end
      do
        if flag then
          local tag = (self._tagPool):GetOne()
          tag:InitBookSkinTag(2)
        end
      end
    end
  end
end

UIHandBookSkin.__OnActivityShowChange = function(self, ids)
  -- function num : 0_6 , upvalues : _ENV
  local activityIdDic = ((ConfigData.skin).themeActivityDic)[self._themeId]
  if activityIdDic == nil then
    return 
  end
  local flag = false
  for _,activityId in ipairs(ids) do
    if activityIdDic[activityId] then
      flag = true
      break
    end
  end
  do
    if not flag then
      return 
    end
    self:RefreshHBSkinCollect(self._isInSell)
    self:RefreshHBSkinItems()
  end
end

UIHandBookSkin.__SelectSkin = function(self, skinId)
  -- function num : 0_7 , upvalues : _ENV
  local skinSortList = {}
  for i,v in ipairs(self._skinCfgList) do
    (table.insert)(skinSortList, v.id)
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.HeroSkin, function(win)
    -- function num : 0_7_0 , upvalues : _ENV, skinId, skinSortList
    if IsNull(win) then
      return 
    end
    win:InitSkinBySkinList(skinId, skinSortList)
  end
)
end

UIHandBookSkin.GetHBSkinThemeId = function(self)
  -- function num : 0_8
  return self._themeId
end

UIHandBookSkin.OnClickCloseSingle = function(self)
  -- function num : 0_9
  self:Delete()
  if self._callback ~= nil then
    (self._callback)()
  end
end

UIHandBookSkin.OnDelete = function(self)
  -- function num : 0_10 , upvalues : _ENV, base
  (self._resloder):Put2Pool()
  self._resloder = nil
  self:__StopAni()
  ;
  (self._itemPool):DeleteAll()
  MsgCenter:RemoveListener(eMsgEventId.ActivityShowChange, self.__OnActivityShowChangeCallback)
  ;
  (base.OnDelete)(self)
end

return UIHandBookSkin

