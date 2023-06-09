-- params : ...
-- function num : 0 , upvalues : _ENV
local AvgCfg_cpt_nora_03_02 = {
[1] = {bgColor = 2, content = 10, contentType = 4, speakerName = 11, 
images = {
{imgId = 1, imgType = 2, alpha = 0, imgPath = "cpt00/cpt00_e_bg010_2", fullScreen = true}
, 
{imgId = 2, imgType = 2, alpha = 0, imgPath = "cpt00/cpt00_e_bg023_2", fullScreen = true}
, 
{imgId = 147, imgType = 3, alpha = 0, imgPath = "willow_avg"}
, 
{imgId = 159, imgType = 3, alpha = 0, imgPath = "nora_avg"}
, 
{imgId = 160, imgType = 3, alpha = 0, imgPath = "crypter_avg"}
}
, 
imgTween = {
{imgId = 1, delay = 0, duration = 1, alpha = 1}
}
, 
audio = {
bgm = {stop = true}
}
}
, 
[2] = {content = 20, contentType = 4, speakerName = 11}
, 
[3] = {content = 30, contentType = 4, speakerName = 11, 
audio = {
bgm = {stop = false, cue = "Mus_Story_General", sheet = "Mus_Story_General", fadeIn = 3, fadeOut = 3}
}
}
, 
[4] = {content = 40, contentType = 3, speakerHeroId = 1059, speakerHeroPosId = 2, 
imgTween = {
{imgId = 159, delay = 0, duration = 0, posId = 3, alpha = 0, isDark = false}
, 
{imgId = 159, delay = 0, duration = 0.6, posId = 3, alpha = 1, isDark = false}
}
, 
heroFace = {
{imgId = 159, faceId = 5}
}
}
, 
[5] = {content = 50, contentType = 3, speakerHeroId = 1047, speakerHeroPosId = 2, 
imgTween = {
{imgId = 159, delay = 0, duration = 0.2, posId = 3, alpha = 0, isDark = false}
, 
{imgId = 147, delay = 0, duration = 0, 
pos = {0, -600, 0}
, alpha = 0, isDark = false}
, 
{imgId = 147, delay = 0, duration = 0.6, 
pos = {0, -330, 0}
, alpha = 1, isDark = false}
}
, 
audio = {
sfx = {cue = "AVG_slip_away", sheet = "AVG"}
}
}
, 
[6] = {content = 60, contentType = 4, speakerName = 11, contentShake = true, 
imgTween = {
{imgId = 147, delay = 0, duration = 0.2, posId = 3, alpha = 1, isDark = true}
}
}
, 
[7] = {content = 70, contentType = 3, speakerHeroId = 1047, speakerHeroPosId = 2, contentShake = true, 
imgTween = {
{imgId = 147, delay = 0, duration = 0.2, posId = 3, alpha = 1, isDark = false}
}
}
, 
[8] = {content = 80, contentType = 3, speakerHeroId = 1047, speakerHeroPosId = 2}
, 
[9] = {content = 90, contentType = 4, speakerName = 11, 
imgTween = {
{imgId = 147, delay = 0, duration = 0.2, posId = 3, alpha = 1, isDark = true}
}
}
, 
[10] = {content = 100, contentType = 3, speakerHeroId = 1047, speakerHeroPosId = 2, 
imgTween = {
{imgId = 147, delay = 0, duration = 0.2, posId = 3, alpha = 1, isDark = false}
}
, 
heroFace = {
{imgId = 147, faceId = 1}
}
}
, 
[11] = {content = 110, contentType = 3, speakerHeroId = 1059, speakerHeroPosId = 1, 
imgTween = {
{imgId = 147, delay = 0, duration = 0.6, posId = 4, alpha = 1, isDark = true}
, 
{imgId = 159, delay = 0, duration = 0, posId = 2, alpha = 0, isDark = false}
, 
{imgId = 159, delay = 0, duration = 0.2, posId = 2, alpha = 1, isDark = false}
}
, 
heroFace = {
{imgId = 159, faceId = 5}
}
}
, 
[12] = {content = 120, contentType = 3, speakerHeroId = 1047, speakerHeroPosId = 3, 
imgTween = {
{imgId = 159, delay = 0, duration = 0.2, posId = 2, alpha = 1, isDark = true}
, 
{imgId = 147, delay = 0, duration = 0.2, posId = 4, alpha = 1, isDark = false}
}
, 
heroFace = {
{imgId = 147, faceId = 0}
}
}
, 
[13] = {content = 130, contentType = 3, speakerHeroId = 1059, speakerHeroPosId = 1, 
imgTween = {
{imgId = 159, delay = 0, duration = 0.2, posId = 2, alpha = 1, isDark = false}
, 
{imgId = 147, delay = 0, duration = 0.2, posId = 4, alpha = 1, isDark = true}
}
, 
heroFace = {
{imgId = 159, faceId = 1}
}
}
, 
[14] = {content = 140, contentType = 3, speakerHeroId = 1059, speakerHeroPosId = 1}
, 
[15] = {autoContinue = true, 
imgTween = {
{imgId = 159, delay = 0, duration = 0.2, posId = 2, alpha = 0, isDark = false}
, 
{imgId = 147, delay = 0, duration = 0.2, posId = 4, alpha = 0, isDark = true}
, 
{imgId = 1, delay = 0, duration = 1, alpha = 0}
}
, 
audio = {
bgm = {stop = true}
}
}
, 
[16] = {content = 160, contentType = 2, 
imgTween = {
{imgId = 2, delay = 0, duration = 1, alpha = 1}
}
, 
audio = {
bgm = {stop = false, cue = "Mus_Story_Serious", sheet = "Mus_Story_Serious", fadeIn = 3, fadeOut = 3}
, 
sfx = {cue = "AVG_wind_grass", sheet = "AVG_gf", audioId = 1}
}
}
, 
[17] = {content = 170, contentType = 2}
, 
[18] = {content = 180, contentType = 3, speakerHeroId = 1059, speakerHeroPosId = 2, 
imgTween = {
{imgId = 159, delay = 0, duration = 0, posId = 3, alpha = 0, isDark = false}
, 
{imgId = 159, delay = 0, duration = 0.2, posId = 3, alpha = 1, isDark = false}
}
, 
heroFace = {
{imgId = 159, faceId = 0}
}
}
, 
[19] = {content = 190, contentType = 3, speakerHeroId = 1059, speakerHeroPosId = 2, 
heroFace = {
{imgId = 159, faceId = 1}
}
}
, 
[20] = {content = 200, contentType = 3, speakerHeroId = 1059, speakerHeroPosId = 2, 
heroFace = {
{imgId = 159, faceId = 8}
}
}
, 
[21] = {content = 210, contentType = 3, speakerHeroId = 1060, speakerHeroPosId = 2, 
imgTween = {
{imgId = 159, delay = 0, duration = 0.2, posId = 3, alpha = 0, isDark = false}
, 
{imgId = 160, delay = 0, duration = 0, posId = 3, alpha = 0, isDark = false}
, 
{imgId = 160, delay = 0, duration = 0.2, posId = 3, alpha = 1, isDark = false}
}
, 
heroFace = {
{imgId = 160, faceId = 4}
}
}
, 
[22] = {content = 220, contentType = 3, speakerHeroId = 1059, speakerHeroPosId = 2, 
imgTween = {
{imgId = 160, delay = 0, duration = 0.2, posId = 3, alpha = 0, isDark = false}
, 
{imgId = 159, delay = 0, duration = 0, posId = 3, alpha = 0, isDark = false}
, 
{imgId = 159, delay = 0, duration = 0.2, posId = 3, alpha = 1, isDark = false}
}
}
, 
[23] = {content = 230, contentType = 2, 
imgTween = {
{imgId = 159, delay = 0, duration = 0.2, posId = 3, alpha = 0, isDark = false}
}
}
, 
[24] = {content = 240, contentType = 3, speakerHeroId = 1060, speakerHeroPosId = 2, 
imgTween = {
{imgId = 160, delay = 0, duration = 0, posId = 3, alpha = 0, isDark = false}
, 
{imgId = 160, delay = 0, duration = 0.2, posId = 3, alpha = 1, isDark = false}
}
, 
heroFace = {
{imgId = 160, faceId = 5}
}
}
, 
[25] = {content = 250, contentType = 2, 
imgTween = {
{imgId = 160, delay = 0, duration = 0.2, posId = 3, alpha = 0, isDark = false}
}
}
, 
[26] = {content = 260, contentType = 3, speakerHeroId = 1059, speakerHeroPosId = 2, 
imgTween = {
{imgId = 159, delay = 0, duration = 0, posId = 3, alpha = 0, isDark = false}
, 
{imgId = 159, delay = 0, duration = 0.2, posId = 3, alpha = 1, isDark = false}
}
, 
heroFace = {
{imgId = 159, faceId = 1}
}
}
, 
[27] = {content = 270, contentType = 2, 
imgTween = {
{imgId = 159, delay = 0, duration = 0.2, posId = 3, alpha = 0, isDark = false}
}
}
, 
[28] = {content = 280, contentType = 2}
, 
[29] = {content = 290, contentType = 3, speakerHeroId = 1060, speakerHeroPosId = 3, 
imgTween = {
{imgId = 160, delay = 0, duration = 0, posId = 4, alpha = 0, isDark = false}
, 
{imgId = 160, delay = 0, duration = 0.2, posId = 4, alpha = 1, isDark = false}
, 
{imgId = 159, delay = 0, duration = 0, posId = 2, alpha = 0, isDark = true}
, 
{imgId = 159, delay = 0, duration = 0.2, posId = 2, alpha = 1, isDark = true}
}
, 
heroFace = {
{imgId = 160, faceId = 6}
}
}
, 
[30] = {content = 300, contentType = 3, speakerHeroId = 1059, speakerHeroPosId = 1, 
imgTween = {
{imgId = 159, delay = 0, duration = 0.2, posId = 2, alpha = 1, isDark = false}
, 
{imgId = 160, delay = 0, duration = 0.2, posId = 4, alpha = 1, isDark = true}
}
, 
heroFace = {
{imgId = 159, faceId = 8}
}
}
, 
[31] = {content = 310, contentType = 3, speakerHeroId = 1060, speakerHeroPosId = 3, 
imgTween = {
{imgId = 159, delay = 0, duration = 0.2, posId = 2, alpha = 1, isDark = true}
, 
{imgId = 160, delay = 0, duration = 0.2, posId = 4, alpha = 1, isDark = false}
}
}
, 
[32] = {content = 320, contentType = 2, 
imgTween = {
{imgId = 159, delay = 0, duration = 0.2, posId = 2, alpha = 0, isDark = true}
, 
{imgId = 160, delay = 0, duration = 0.2, posId = 4, alpha = 0, isDark = false}
}
}
, 
[33] = {content = 330, contentType = 3, speakerHeroId = 1059, speakerHeroPosId = 1, 
imgTween = {
{imgId = 159, delay = 0, duration = 0, posId = 2, alpha = 0, isDark = false}
, 
{imgId = 159, delay = 0, duration = 0.2, posId = 2, alpha = 1, isDark = false}
, 
{imgId = 160, delay = 0, duration = 0, posId = 4, alpha = 0, isDark = true}
, 
{imgId = 160, delay = 0, duration = 0.2, posId = 4, alpha = 1, isDark = true}
}
, 
heroFace = {
{imgId = 159, faceId = 3}
}
}
, 
[34] = {content = 340, contentType = 3, speakerHeroId = 1060, speakerHeroPosId = 3, 
imgTween = {
{imgId = 160, delay = 0, duration = 0.2, posId = 4, alpha = 1, isDark = false}
, 
{imgId = 159, delay = 0, duration = 0.2, posId = 2, alpha = 1, isDark = true}
}
, 
heroFace = {
{imgId = 160, faceId = 0}
}
}
, 
[35] = {content = 350, contentType = 3, speakerHeroId = 1059, speakerHeroPosId = 1, 
imgTween = {
{imgId = 160, delay = 0, duration = 0.2, posId = 4, alpha = 1, isDark = true}
, 
{imgId = 159, delay = 0, duration = 0.2, posId = 2, alpha = 1, isDark = false}
}
, 
heroFace = {
{imgId = 159, faceId = 3}
}
}
, 
[36] = {content = 360, contentType = 3, speakerHeroId = 1060, speakerHeroPosId = 3, 
imgTween = {
{imgId = 160, delay = 0, duration = 0.2, posId = 4, alpha = 1, isDark = false}
, 
{imgId = 159, delay = 0, duration = 0.2, posId = 2, alpha = 1, isDark = true}
}
, 
heroFace = {
{imgId = 160, faceId = 5}
}
}
, 
[37] = {content = 370, contentType = 3, speakerHeroId = 1059, speakerHeroPosId = 1, 
imgTween = {
{imgId = 160, delay = 0, duration = 0.2, posId = 4, alpha = 1, isDark = true}
, 
{imgId = 159, delay = 0, duration = 0.2, posId = 2, alpha = 1, isDark = false}
}
}
, 
[38] = {content = 380, contentType = 3, speakerHeroId = 1060, speakerHeroPosId = 3, 
imgTween = {
{imgId = 160, delay = 0, duration = 0.2, posId = 4, alpha = 1, isDark = false}
, 
{imgId = 159, delay = 0, duration = 0.2, posId = 2, alpha = 1, isDark = true}
}
, 
audio = {
sfx = {cue = "AVG_footsteps_cave", sheet = "AVG_gf"}
}
, 
heroFace = {
{imgId = 160, faceId = 6}
}
}
, 
[39] = {content = 390, contentType = 3, speakerHeroId = 1059, speakerHeroPosId = 1, 
imgTween = {
{imgId = 160, delay = 0, duration = 0.2, posId = 4, alpha = 1, isDark = true}
, 
{imgId = 159, delay = 0, duration = 0.2, posId = 2, alpha = 1, isDark = false}
}
, 
heroFace = {
{imgId = 159, faceId = 3}
}
}
, 
[40] = {content = 400, contentType = 3, speakerHeroId = 1059, speakerHeroPosId = 1, contentShake = true}
, 
[41] = {content = 410, contentType = 3, speakerHeroId = 1060, speakerHeroPosId = 3, 
imgTween = {
{imgId = 160, delay = 0, duration = 0.2, posId = 4, alpha = 1, isDark = false}
, 
{imgId = 159, delay = 0, duration = 0.2, posId = 2, alpha = 1, isDark = true}
}
, 
heroFace = {
{imgId = 160, faceId = 7}
}
}
, 
[42] = {content = 420, contentType = 3, speakerHeroId = 1060, speakerHeroPosId = 3}
, 
[43] = {content = 430, contentType = 2, contentShake = true, 
imgTween = {
{imgId = 160, delay = 0, duration = 0.2, posId = 4, alpha = 0, isDark = false}
, 
{imgId = 159, delay = 0, duration = 0.2, posId = 2, alpha = 0, isDark = true}
}
, 
audio = {
bgm = {stop = true}
}
}
, 
[44] = {content = 440, contentType = 2, 
audio = {
bgm = {stop = false, cue = "Mus_Story_Creepy", sheet = "Mus_Story_Creepy", fadeIn = 3, fadeOut = 3}
, 
stopAudioId = {1}
}
}
, 
[45] = {content = 450, contentType = 2, 
audio = {
sfx = {cue = "AVG_footsteps_cave", sheet = "AVG_gf"}
}
}
, 
[46] = {content = 460, contentType = 2}
, 
[47] = {content = 470, contentType = 2}
, 
[48] = {content = 480, contentType = 2}
, 
[49] = {content = 490, contentType = 2}
, 
[50] = {content = 500, contentType = 2, 
audio = {
sfx = {cue = "AVG_footsteps_cave", sheet = "AVG_gf"}
}
}
, 
[51] = {content = 510, contentType = 2}
, 
[52] = {content = 520, contentType = 2}
, 
[53] = {content = 530, contentType = 3, speakerHeroId = 1059, speakerHeroPosId = 2, 
imgTween = {
{imgId = 159, delay = 0, duration = 0, posId = 3, alpha = 0, isDark = false}
, 
{imgId = 159, delay = 0, duration = 0.2, posId = 3, alpha = 1, isDark = false}
}
, 
heroFace = {
{imgId = 159, faceId = 6}
}
}
, 
[54] = {content = 540, contentType = 2, 
imgTween = {
{imgId = 159, delay = 0, duration = 0.2, posId = 3, alpha = 0, isDark = false}
}
}
, 
[55] = {content = 550, contentType = 2}
, 
[56] = {content = 560, contentType = 2}
, 
[57] = {content = 570, contentType = 3, speakerHeroId = 1059, speakerHeroPosId = 2, 
imgTween = {
{imgId = 159, delay = 0, duration = 0, posId = 3, alpha = 0, isDark = false}
, 
{imgId = 159, delay = 0, duration = 0.2, posId = 3, alpha = 1, isDark = false}
}
}
, 
[58] = {content = 580, contentType = 3, speakerHeroId = 1059, speakerHeroPosId = 2}
, 
[59] = {content = 590, contentType = 3, speakerHeroId = 1059, speakerHeroPosId = 2, 
heroFace = {
{imgId = 159, faceId = 7}
}
}
, 
[60] = {content = 600, contentType = 2, 
imgTween = {
{imgId = 159, delay = 0, duration = 0.2, posId = 3, alpha = 0, isDark = false}
, 
{imgId = 160, delay = 0, duration = 0, posId = 3, alpha = 0, isDark = true}
, 
{imgId = 160, delay = 0, duration = 0.2, posId = 3, alpha = 1, isDark = true}
}
}
, 
[61] = {content = 610, contentType = 3, speakerHeroId = 1059, speakerHeroPosId = 2, 
imgTween = {
{imgId = 160, delay = 0, duration = 0.2, posId = 3, alpha = 0, isDark = true}
, 
{imgId = 159, delay = 0, duration = 0, posId = 3, alpha = 0, isDark = false}
, 
{imgId = 159, delay = 0, duration = 0.2, posId = 3, alpha = 1, isDark = false}
}
}
, 
[62] = {content = 620, contentType = 2, 
imgTween = {
{imgId = 159, delay = 0, duration = 0.2, posId = 3, alpha = 0, shake = true, isDark = false}
}
, 
audio = {
bgm = {stop = true}
}
}
, 
[63] = {content = 630, contentType = 4, speakerName = 12, contentShake = true}
, 
[64] = {content = 640, contentType = 4, speakerName = 13, contentShake = true, 
imgTween = {
{imgId = 2, delay = 0, duration = 1, alpha = 0}
}
}
}
return AvgCfg_cpt_nora_03_02

