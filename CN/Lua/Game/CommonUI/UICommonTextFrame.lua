-- params : ...
-- function num : 0 , upvalues : _ENV
local UICommonTextFrame = class("UICommonTextFrame", UIBaseWindow)
local base = UIBaseWindow
UICommonTextFrame.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.AddButtonListener)((self.ui).btn_background, self, self.OnClickClose)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self.OnClickClose)
end

UICommonTextFrame.SetWCScoreText = function(self, curScore, predictScore)
  -- function num : 0_1 , upvalues : _ENV
  if predictScore == nil then
    local str = ((self.ui).tex_Info):GetIndex(1, tostring(curScore))
    str = (string.gsub)(str, "\\n", "\n")
    -- DECOMPILER ERROR at PC19: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.ui).tex).text = str
  else
    do
      local str = ((self.ui).tex_Info):GetIndex(0, tostring(curScore), tostring(predictScore))
      str = (string.gsub)(str, "\\n", "\n")
      -- DECOMPILER ERROR at PC41: Confused about usage of register: R4 in 'UnsetPending'

      ;
      ((self.ui).tex).text = str
    end
  end
end

UICommonTextFrame.OnClickClose = function(self)
  -- function num : 0_2
  self:Delete()
end

UICommonTextFrame.OnDelete = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnDelete)(self)
end

return UICommonTextFrame

