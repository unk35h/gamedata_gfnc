-- params : ...
-- function num : 0 , upvalues : _ENV
local AvgCfg_dorm_haze_01 = {
[1] = {content = 10, contentType = 3, speakerHeroId = 1058, speakerHeroPosId = 2, 
images = {
{imgId = 1, imgType = 3, alpha = 0, imgPath = "haze_avg"}
}
, 
imgTween = {
{imgId = 1, delay = 0, duration = 0, posId = 3, alpha = 0, isDark = false}
, 
{imgId = 1, delay = 1, duration = 0.6, posId = 3, alpha = 1, isDark = false}
}
, 
audio = {
voice = {heroId = 1046, voiceId = 112}
}
}
, 
[2] = {content = 20, contentType = 3, speakerHeroId = 1058, speakerHeroPosId = 2}
}
return AvgCfg_dorm_haze_01

