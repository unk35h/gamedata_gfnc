-- params : ...
-- function num : 0 , upvalues : _ENV
local CommonUIUtil = {}
CommonUIUtil.CreateHeroSkinTags = function(skinCfg, tagPool)
  -- function num : 0_0 , upvalues : _ENV
  if skinCfg == nil then
    return 0, false
  end
  local live2dLevel = skinCfg.live2d_level
  local isL2DRectify = (PlayerDataCenter.skinData):IsL2dRectify(skinCfg.id)
  local haveModel = not (string.IsNullOrEmpty)(skinCfg.src_id_model)
  do
    if haveModel then
      local item = tagPool:GetOne(true)
      item:InitSkinTag(0)
    end
    do
      if live2dLevel > 0 and not isL2DRectify then
        local item = tagPool:GetOne(true)
        item:InitSkinTagLive2dLevel(live2dLevel)
      end
      do
        if skinCfg.has_skill_movie then
          local item = tagPool:GetOne(true)
          item:InitSkinTag(3)
        end
        do
          if skinCfg.has_voice then
            local item = tagPool:GetOne(true)
            item:InitSkinTag(4)
          end
          return live2dLevel, haveModel
        end
      end
    end
  end
end

CommonUIUtil.CreateFntThemeTags = function(themeItem, tagPool)
  -- function num : 0_1
  local item = tagPool:GetOne(true)
  item:SetIndex(0)
  if themeItem.only_big then
    item = tagPool:GetOne(true)
    item:SetIndex(1)
  end
end

return CommonUIUtil

