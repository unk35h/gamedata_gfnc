-- params : ...
-- function num : 0 , upvalues : _ENV
local UINActWinter23LvSwitchList = class("UINActWinter23LvSwitchList", UIBaseNode)
local base = UIBaseNode
local cs_DoTween = ((CS.DG).Tweening).DOTween
local ActivityWinter23Enum = require("Game.ActivityWinter23.Data.ActivityWinter23Enum")
local UINActWInter23ChapterListItem = require("Game.ActivityWinter23.UI.Sector.UINActWinter23ChapterListItem")
UINActWinter23LvSwitchList.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINActWInter23ChapterListItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Confirm, self, self.OnClickWinter23LvConfirm)
  self.chapterItemPool = (UIItemPool.New)(UINActWInter23ChapterListItem, (self.ui).obj_chapterItem)
  ;
  ((self.ui).obj_chapterItem):SetActive(false)
  self.__ChapterViewCallback = BindCallback(self, self.__ChapterView)
  ;
  ((self.ui).pageViewChapterList):onPageIndexChanged("+", self.__ChapterViewCallback)
end

UINActWinter23LvSwitchList.InitWinter23ChapterList = function(self, chapterCfgList, nowIndex, callback)
  -- function num : 0_1 , upvalues : _ENV
  (self.chapterItemPool):DeleteAll()
  self.chapterCfgList = chapterCfgList
  for i,v in pairs(chapterCfgList) do
    local item = (self.chapterItemPool):GetOne()
    item:InitUINActWinter23ChapterListItem(i)
  end
  self.callback = callback
  self.index = nowIndex
  ;
  ((self.ui).pageViewChapterList):InitPosList(#self.chapterCfgList)
  self:SetPageViewIndex(nowIndex)
end

UINActWinter23LvSwitchList.SetPageViewIndex = function(self, index)
  -- function num : 0_2 , upvalues : _ENV
  for i,v in pairs((self.chapterItemPool).listItem) do
    if v.index == index then
      v:SetMainChapter()
    else
      v:SetSideChapter()
    end
  end
  ;
  ((self.ui).pageViewChapterList):SetPageIndexImmediate(index - 1, true)
end

UINActWinter23LvSwitchList.SetRedDotStart = function(self, bool, redIndex)
  -- function num : 0_3 , upvalues : _ENV
  if not redIndex or redIndex == 0 then
    return 
  end
  for i,v in pairs((self.chapterItemPool).listItem) do
    if v.index == redIndex then
      v:SetChapterListItemRedDotOpen(bool)
      break
    end
  end
end

UINActWinter23LvSwitchList.OnClickWinter23LvConfirm = function(self)
  -- function num : 0_4
  if self.callback ~= nil then
    (self.callback)(self.index)
  end
end

UINActWinter23LvSwitchList.__ChapterView = function(self, index)
  -- function num : 0_5 , upvalues : _ENV
  self.index = index + 1
  for i,v in pairs((self.chapterItemPool).listItem) do
    if v.index == self.index then
      v:SetMainChapter()
    else
      v:SetSideChapter()
    end
  end
  -- DECOMPILER ERROR at PC27: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_ChapterName).text = (LanguageUtil.GetLocaleText)(((self.chapterCfgList)[self.index]).chapter_name)
end

UINActWinter23LvSwitchList.OnShow = function(self)
  -- function num : 0_6 , upvalues : _ENV
  (UIUtil.HideTopStatus)()
end

UINActWinter23LvSwitchList.OnHide = function(self)
  -- function num : 0_7 , upvalues : _ENV
  (UIUtil.ReShowTopStatus)()
end

UINActWinter23LvSwitchList.OnDelete = function(self)
  -- function num : 0_8 , upvalues : base
  (base.OnDelete)(self)
end

return UINActWinter23LvSwitchList

