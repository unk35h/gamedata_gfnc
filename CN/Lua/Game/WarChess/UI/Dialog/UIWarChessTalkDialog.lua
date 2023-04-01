-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseWindow
local UIWarChessTalkDialog = class("UIWarChessTalkDialog", base)
local cs_ResLoader = CS.ResLoader
UIWarChessTalkDialog.OnInit = function(self)
  -- function num : 0_0 , upvalues : cs_ResLoader, _ENV
  self.resLoader = (cs_ResLoader.Create)()
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_backGround, self, self.__OnClickNext)
end

UIWarChessTalkDialog.InitWCMiniTV = function(self, tipCfgs, playOverCallback)
  -- function num : 0_1 , upvalues : _ENV
  self.__tipCfgs = tipCfgs
  self.playOverCallback = playOverCallback
  self.__curPlayIndex = 0
  self:__PlayNext()
  local wcMain = UIManager:GetWindow(UIWindowTypeID.WarChessMain)
  if wcMain ~= nil then
    wcMain:WcMainFadeBttomUI(true)
  end
end

UIWarChessTalkDialog.__PlayNext = function(self)
  -- function num : 0_2 , upvalues : _ENV
  self.__curPlayIndex = self.__curPlayIndex + 1
  local tipCfg = (self.__tipCfgs)[self.__curPlayIndex]
  if tipCfg ~= nil then
    local context = (LanguageUtil.GetLocaleText)(tipCfg.context)
    -- DECOMPILER ERROR at PC14: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).tex_TalkDialog).text = context
    if tipCfg.heroId ~= nil and tipCfg.heroId ~= 0 then
      (((self.ui).img_TalkHeroPic).gameObject):SetActive(true)
      ;
      (((self.ui).img_monsterHeadImg).gameObject):SetActive(false)
      local heroCfg = (ConfigData.hero_data)[tipCfg.heroId]
      if heroCfg ~= nil then
        local itemCfg = (ConfigData.item)[heroCfg.fragment]
        -- DECOMPILER ERROR at PC49: Confused about usage of register: R5 in 'UnsetPending'

        ;
        ((self.ui).img_TalkHeroPic).sprite = CRH:GetSpriteByItemConfig(itemCfg)
      end
    else
      do
        if tipCfg.monsterid ~= nil and tipCfg.monsterid ~= 0 then
          (((self.ui).img_TalkHeroPic).gameObject):SetActive(false)
          ;
          (((self.ui).img_monsterHeadImg).gameObject):SetActive(true)
          local monsterCfg = (ConfigData.monster)[tipCfg.monsterid]
          if monsterCfg ~= nil then
            local resId = monsterCfg.src_id
            local resCfg = (ConfigData.resource_model)[resId]
            if resCfg ~= nil then
              local path = PathConsts:GetCharacterSmallPicPath(resCfg.res_Name)
              ;
              (self.resLoader):LoadABAssetAsync(path, function(texture)
    -- function num : 0_2_0 , upvalues : _ENV, self
    -- DECOMPILER ERROR at PC9: Confused about usage of register: R1 in 'UnsetPending'

    if texture ~= nil and not IsNull(self.gameObject) then
      ((self.ui).img_monsterHeadImg).texture = texture
    end
  end
)
            end
          end
        else
          do
            ;
            (((self.ui).img_TalkHeroPic).gameObject):SetActive(true)
            ;
            (((self.ui).img_monsterHeadImg).gameObject):SetActive(false)
            local isGirl = ((PlayerDataCenter.inforData):GetSex())
            local headId = nil
            if isGirl then
              headId = ConstGlobalItem.ProfessorGridHead
            else
              headId = ConstGlobalItem.ProfessorBodyHead
            end
            local cfg = (ConfigData.portrait)[headId]
            if cfg == nil then
              return 
            end
            do
              local icon = cfg.icon
              -- DECOMPILER ERROR at PC136: Confused about usage of register: R7 in 'UnsetPending'

              if not (string.IsNullOrEmpty)(icon) then
                ((self.ui).img_TalkHeroPic).sprite = CRH:GetSprite(icon, CommonAtlasType.HeroHeadIcon)
              end
              if tipCfg.is_need_focus then
                local wcCtrl = WarChessManager:GetWarChessCtrl()
                local x = tipCfg.x
                local y = tipCfg.y
                local showPos = (Vector3.New)(x, 0, y)
                ;
                (wcCtrl.wcCamCtrl):SetWcCamFollowPos(showPos)
              end
              do
                self:__PlayOver()
              end
            end
          end
        end
      end
    end
  end
end

UIWarChessTalkDialog.__PlayOver = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local wcMain = UIManager:GetWindow(UIWindowTypeID.WarChessMain)
  if wcMain ~= nil then
    wcMain:WcMainFadeBttomUI(false)
  end
  if self.playOverCallback ~= nil then
    (self.playOverCallback)()
  end
  self:Delete()
end

UIWarChessTalkDialog.__OnClickNext = function(self)
  -- function num : 0_4
  self:__PlayNext()
end

UIWarChessTalkDialog.OnDelete = function(self)
  -- function num : 0_5
  if self.resLoader ~= nil then
    (self.resLoader):Put2Pool()
    self.resLoader = nil
  end
end

return UIWarChessTalkDialog

