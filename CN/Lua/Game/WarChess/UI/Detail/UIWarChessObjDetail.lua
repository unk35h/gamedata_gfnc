-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseWindow
local UIWarChessObjDetail = class("UIWarChessObjDetail", base)
local UINEnemyTagItem = require("Game.Battle.UI.UINEnemyTagItem")
UIWarChessObjDetail.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINEnemyTagItem
  (UIUtil.AddButtonListener)((self.ui).btn_bg, self, self.OnClickBG)
  ;
  ((self.ui).obj_tag):SetActive(false)
  self.tagItemPool = (UIItemPool.New)(UINEnemyTagItem, (self.ui).obj_tag)
  self.resloader = ((CS.ResLoader).Create)()
end

UIWarChessObjDetail.InitWCIntro = function(self, desId, pos, closeCallback)
  -- function num : 0_1 , upvalues : _ENV
  if desId ~= nil and desId ~= self.__cacheDes then
    local desCfg = (ConfigData.warchess_des)[desId]
    if desCfg == nil then
      desCfg = (ConfigData.warchess_des)[1000]
    end
    -- DECOMPILER ERROR at PC19: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self.ui).tex_Title).text = (LanguageUtil.GetLocaleText)(desCfg.name)
    -- DECOMPILER ERROR at PC26: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self.ui).tex_Contex).text = (LanguageUtil.GetLocaleText)(desCfg.info)
    -- DECOMPILER ERROR at PC35: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self.ui).img_ObjIcon).sprite = (AtlasUtil.GetSpriteFromAtlas)("WarChess", desCfg.icon, self.resloader)
    ;
    (self.tagItemPool):HideAll()
    local tag_des = desCfg.tag_des
    if tag_des ~= nil then
      local tagEnd = #tag_des
      local tagStart = 1
      for i = tagStart, tagEnd do
        local tag = tag_des[i]
        local item = (self.tagItemPool):GetOne()
        item:InitEnemyTagItem((LanguageUtil.GetLocaleText)(tag))
      end
    end
    do
      do
        self.__cacheDes = desId
        self.__closeCallback = closeCallback
        self:UpdDetailPanelPos(pos)
      end
    end
  end
end

UIWarChessObjDetail.UpdDetailPanelPos = function(self, worldPos)
  -- function num : 0_2 , upvalues : _ENV
  local rolePosX = (UIManager:World2UIPosition(worldPos, self.transform)).x
  local targetPosX = rolePosX - (((self.ui).uINWCObjDetail).sizeDelta).x / 2 - 150
  if targetPosX <= (self.ui).panelPosRangeX - ((self.transform).rect).width / 2 then
    targetPosX = rolePosX + (((self.ui).uINWCObjDetail).sizeDelta).x / 2 + 150
  end
  local anchoredPos = ((self.ui).uINWCObjDetail).anchoredPosition
  anchoredPos.x = targetPosX
  -- DECOMPILER ERROR at PC35: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).uINWCObjDetail).anchoredPosition = anchoredPos
end

UIWarChessObjDetail.OnClickBG = function(self)
  -- function num : 0_3
  if self.__closeCallback ~= nil then
    (self.__closeCallback)()
  end
  self:Hide()
end

UIWarChessObjDetail.OnDelete = function(self)
  -- function num : 0_4
  (self.tagItemPool):DeleteAll()
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
end

return UIWarChessObjDetail

