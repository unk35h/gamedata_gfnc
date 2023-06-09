-- params : ...
-- function num : 0 , upvalues : _ENV
local AvgCfg_cpt_clotho_01_03 = {
[1] = {bgColor = 2, content = 10, contentType = 1, 
images = {
{imgId = 1, imgType = 2, alpha = 0, imgPath = "cpt00/cpt00_e_bg048", fullScreen = true}
, 
{imgId = 2, imgType = 2, alpha = 0, imgPath = "cpt00/cpt00_e_bg047", fullScreen = true}
, 
{imgId = 151, imgType = 3, alpha = 0, imgPath = "soldier_hurt_avg"}
, 
{imgId = 167, imgType = 3, alpha = 0, imgPath = "clotho2_avg"}
, 
{imgId = 143, imgType = 3, alpha = 0, imgPath = "hel_avg"}
}
, 
audio = {
bgm = {stop = true}
}
}
, 
[2] = {content = 20, contentType = 3, speakerHeroId = 143, speakerHeroPosId = 3, contentShake = true, 
imgTween = {
{imgId = 1, delay = 0, duration = 0.6, alpha = 1}
, 
{imgId = 143, delay = 0, duration = 0, posId = 4, alpha = 0, isDark = false}
, 
{imgId = 143, delay = 0.6, duration = 0.2, posId = 4, alpha = 1, isDark = false}
, 
{imgId = 167, delay = 0, duration = 0, posId = 2, alpha = 0, isDark = true}
, 
{imgId = 167, delay = 0.6, duration = 0.2, posId = 2, alpha = 1, isDark = true}
}
, 
audio = {
bgm = {stop = false, cue = "Mus_Story_Dark", sheet = "Mus_Story_Dark", fadeIn = 3, fadeOut = 3}
}
, 
heroFace = {
{imgId = 143, faceId = 3}
}
}
, 
[3] = {content = 30, contentType = 3, speakerHeroId = 1067, speakerHeroPosId = 1, 
imgTween = {
{imgId = 167, delay = 0, duration = 0.2, posId = 2, alpha = 1, isDark = false}
, 
{imgId = 143, delay = 0, duration = 0.2, posId = 4, alpha = 1, isDark = true}
}
, 
heroFace = {
{imgId = 167, faceId = 5}
}
}
, 
[4] = {content = 40, contentType = 3, speakerHeroId = 143, speakerHeroPosId = 3, contentShake = true, 
imgTween = {
{imgId = 167, delay = 0, duration = 0.2, posId = 2, alpha = 1, isDark = true}
, 
{imgId = 143, delay = 0, duration = 0.2, posId = 4, alpha = 1, isDark = false}
}
}
, 
[5] = {content = 50, contentType = 3, speakerHeroId = 143, speakerHeroPosId = 3}
, 
[6] = {content = 60, contentType = 3, speakerHeroId = 143, speakerHeroPosId = 3}
, 
[7] = {content = 70, contentType = 3, speakerHeroId = 143, speakerHeroPosId = 3, 
heroFace = {
{imgId = 143, faceId = 2}
}
}
, 
[8] = {content = 80, contentType = 3, speakerHeroId = 1067, speakerHeroPosId = 1, 
imgTween = {
{imgId = 167, delay = 0, duration = 0.2, posId = 2, alpha = 1, isDark = false}
, 
{imgId = 143, delay = 0, duration = 0.2, posId = 4, alpha = 1, isDark = true}
}
, 
heroFace = {
{imgId = 167, faceId = 2}
}
}
, 
[9] = {content = 90, contentType = 3, speakerHeroId = 1067, speakerHeroPosId = 1, 
heroFace = {
{imgId = 167, faceId = 3}
}
}
, 
[10] = {content = 100, contentType = 3, speakerHeroId = 143, speakerHeroPosId = 3, contentShake = true, 
imgTween = {
{imgId = 167, delay = 0, duration = 0.2, posId = 2, alpha = 1, isDark = true}
, 
{imgId = 143, delay = 0, duration = 0.2, posId = 4, alpha = 1, isDark = false}
}
, 
heroFace = {
{imgId = 143, faceId = 0}
}
}
, 
[11] = {autoContinue = true, 
imgTween = {
{imgId = 167, delay = 0, duration = 0.2, posId = 2, alpha = 0, isDark = true}
, 
{imgId = 143, delay = 0, duration = 0.2, posId = 4, alpha = 0, isDark = false}
, 
{imgId = 1, delay = 0, duration = 0.6, alpha = 0}
}
}
, 
[12] = {content = 120, contentType = 1}
, 
[13] = {content = 130, contentType = 2, 
imgTween = {
{imgId = 2, delay = 0, duration = 0.6, alpha = 1}
}
}
, 
[14] = {content = 140, contentType = 2}
, 
[15] = {content = 150, contentType = 3, speakerHeroId = 143, 
imgTween = {
{imgId = 143, delay = 0, duration = 0, posId = 3, alpha = 0, isDark = false}
, 
{imgId = 143, delay = 0, duration = 0.2, posId = 3, alpha = 1, isDark = false}
}
}
, 
[16] = {content = 160, contentType = 3, speakerHeroId = 143, contentShake = true}
, 
[17] = {content = 170, contentType = 2, 
imgTween = {
{imgId = 143, delay = 0, duration = 0.2, posId = 3, alpha = 0, isDark = false}
}
}
, 
[18] = {content = 180, contentType = 3, speakerHeroId = 1067, 
imgTween = {
{imgId = 167, delay = 0, duration = 0, posId = 3, alpha = 0, isDark = false}
, 
{imgId = 167, delay = 0, duration = 0.2, posId = 3, alpha = 1, isDark = false}
}
, 
audio = {
bgm = {stop = true}
}
}
, 
[19] = {content = 190, contentType = 3, speakerHeroId = 1067, 
heroFace = {
{imgId = 167, faceId = 5}
}
}
, 
[20] = {content = 200, contentType = 3, speakerHeroId = 143, speakerHeroPosId = 3, 
imgTween = {
{imgId = 167, delay = 0, duration = 0.6, posId = 2, alpha = 1, isDark = true}
, 
{imgId = 143, delay = 0, duration = 0, posId = 4, alpha = 0, isDark = false}
, 
{imgId = 143, delay = 0, duration = 0.2, posId = 4, alpha = 1, isDark = false}
}
, 
heroFace = {
{imgId = 143, faceId = 1}
}
}
, 
[21] = {content = 210, contentType = 3, speakerHeroId = 1067, speakerHeroPosId = 1, 
imgTween = {
{imgId = 167, delay = 0, duration = 0.2, posId = 2, alpha = 1, isDark = false}
, 
{imgId = 143, delay = 0, duration = 0.2, posId = 4, alpha = 1, isDark = true}
}
, 
heroFace = {
{imgId = 167, faceId = 3}
}
}
, 
[22] = {content = 220, contentType = 3, speakerHeroId = 1067, speakerHeroPosId = 1, 
heroFace = {
{imgId = 167, faceId = 2}
}
}
, 
[23] = {content = 230, contentType = 2, 
imgTween = {
{imgId = 167, delay = 0, duration = 0.2, posId = 2, alpha = 0, isDark = false}
, 
{imgId = 143, delay = 0, duration = 0.2, posId = 4, alpha = 0, isDark = true}
}
}
, 
[24] = {content = 240, contentType = 2}
, 
[25] = {content = 250, contentType = 3, speakerHeroId = 151, 
imgTween = {
{imgId = 151, delay = 0, duration = 0, posId = 3, alpha = 0, isDark = false}
, 
{imgId = 151, delay = 0, duration = 0.2, posId = 3, alpha = 1, shake = true, isDark = false}
, 
{imgId = 151, delay = 0.6, duration = 0.2, posId = 3, alpha = 1, shake = true, isDark = false}
}
, 
audio = {
bgm = {stop = false, cue = "Mus_Story_Depressed", sheet = "Mus_Story_Depressed", fadeIn = 3, fadeOut = 1}
}
}
, 
[26] = {content = 260, contentType = 3, speakerHeroId = 151, 
imgTween = {
{imgId = 151, delay = 0, duration = 0.2, posId = 3, alpha = 1, shake = true, isDark = false}
}
}
, 
[27] = {content = 270, contentType = 3, speakerHeroId = 1067, 
imgTween = {
{imgId = 151, delay = 0, duration = 0.2, posId = 3, alpha = 0, isDark = false}
, 
{imgId = 167, delay = 0, duration = 0, posId = 3, alpha = 0, isDark = false}
, 
{imgId = 167, delay = 0, duration = 0.2, posId = 3, alpha = 1, isDark = false}
}
}
, 
[28] = {content = 280, contentType = 2, 
imgTween = {
{imgId = 167, delay = 0, duration = 0.2, posId = 3, alpha = 0, isDark = false}
}
}
, 
[29] = {content = 290, contentType = 3, speakerHeroId = 151, contentShake = true, 
imgTween = {
{imgId = 151, delay = 0, duration = 0.2, posId = 3, alpha = 1, shake = true, isDark = false}
}
}
, 
[30] = {content = 300, contentType = 3, speakerHeroId = 1067, 
imgTween = {
{imgId = 151, delay = 0, duration = 0.2, posId = 3, alpha = 0, isDark = false}
, 
{imgId = 167, delay = 0, duration = 0.2, posId = 3, alpha = 1, isDark = false}
}
}
, 
[31] = {content = 310, contentType = 3, speakerHeroId = 151, contentShake = true, 
imgTween = {
{imgId = 167, delay = 0, duration = 0.2, posId = 3, alpha = 0, isDark = false}
, 
{imgId = 151, delay = 0, duration = 0, posId = 3, alpha = 0, isDark = false}
, 
{imgId = 151, delay = 0, duration = 0.2, posId = 3, alpha = 1, shake = true, isDark = false}
, 
{imgId = 151, delay = 0.6, duration = 0.2, posId = 3, alpha = 1, shake = true, isDark = false}
}
}
, 
[32] = {content = 320, contentType = 3, speakerHeroId = 1067, 
imgTween = {
{imgId = 151, delay = 0, duration = 0.2, posId = 3, alpha = 0, isDark = false}
, 
{imgId = 167, delay = 0, duration = 0.2, posId = 3, alpha = 1, isDark = false}
}
}
, 
[33] = {content = 330, contentType = 2, 
imgTween = {
{imgId = 167, delay = 0, duration = 0.2, posId = 3, alpha = 0, isDark = false}
}
}
, 
[34] = {content = 340, contentType = 3, speakerHeroId = 151, contentShake = true, 
imgTween = {
{imgId = 151, delay = 0, duration = 0.2, posId = 3, alpha = 1, shake = true, isDark = false}
}
}
, 
[35] = {content = 350, contentType = 3, speakerHeroId = 151, contentShake = true, 
imgTween = {
{imgId = 151, delay = 0, duration = 0.2, posId = 3, alpha = 1, shake = true, isDark = false}
}
}
, 
[36] = {content = 360, contentType = 3, speakerHeroId = 1067, 
imgTween = {
{imgId = 151, delay = 0, duration = 0.2, posId = 3, alpha = 0, isDark = false}
, 
{imgId = 167, delay = 0, duration = 0.2, posId = 3, alpha = 1, isDark = false}
}
}
, 
[37] = {content = 370, contentType = 2, 
imgTween = {
{imgId = 167, delay = 0, duration = 0.2, posId = 3, alpha = 0, isDark = false}
}
}
, 
[38] = {content = 380, contentType = 3, speakerHeroId = 151, 
imgTween = {
{imgId = 151, delay = 0, duration = 0.2, posId = 3, alpha = 1, shake = true, isDark = false}
, 
{imgId = 151, delay = 0.6, duration = 0.2, posId = 3, alpha = 1, shake = true, isDark = false}
}
}
, 
[39] = {content = 390, contentType = 3, speakerHeroId = 1067, 
imgTween = {
{imgId = 151, delay = 0, duration = 0.2, posId = 3, alpha = 0, isDark = false}
, 
{imgId = 167, delay = 0, duration = 0.2, posId = 3, alpha = 1, isDark = false}
}
, 
heroFace = {
{imgId = 167, faceId = 6}
}
}
, 
[40] = {content = 400, contentType = 3, speakerHeroId = 151, 
imgTween = {
{imgId = 167, delay = 0, duration = 0.2, posId = 3, alpha = 0, isDark = false}
, 
{imgId = 151, delay = 0, duration = 0.2, posId = 3, alpha = 1, shake = true, isDark = false}
, 
{imgId = 151, delay = 0.6, duration = 0.2, posId = 3, alpha = 1, shake = true, isDark = false}
}
}
, 
[41] = {content = 410, contentType = 3, speakerHeroId = 151, 
imgTween = {
{imgId = 151, delay = 0, duration = 0.2, posId = 3, alpha = 1, shake = true, isDark = false}
}
}
, 
[42] = {content = 420, contentType = 2, 
imgTween = {
{imgId = 151, delay = 0, duration = 0.2, posId = 3, alpha = 0, isDark = false}
}
}
, 
[43] = {content = 430, contentType = 2}
, 
[44] = {content = 440, contentType = 3, speakerHeroId = 143, 
imgTween = {
{imgId = 143, delay = 0, duration = 0, posId = 3, alpha = 0, isDark = false}
, 
{imgId = 143, delay = 0, duration = 0.2, posId = 3, alpha = 1, shake = true, isDark = false}
}
, 
heroFace = {
{imgId = 143, faceId = 0}
}
}
, 
[45] = {content = 450, contentType = 2, 
imgTween = {
{imgId = 143, delay = 0, duration = 0.2, posId = 3, alpha = 0, isDark = false}
}
}
, 
[46] = {content = 460, contentType = 3, speakerHeroId = 151, 
imgTween = {
{imgId = 151, delay = 0, duration = 0.2, posId = 3, alpha = 1, shake = true, isDark = false}
, 
{imgId = 151, delay = 0.6, duration = 0.2, posId = 3, alpha = 1, shake = true, isDark = false}
}
, 
audio = {
bgm = {stop = false, cue = "Mus_Story_Sad", sheet = "Mus_Story_Sad", fadeIn = 3, fadeOut = 1}
}
}
, 
[47] = {content = 470, contentType = 3, speakerHeroId = 151}
, 
[48] = {content = 480, contentType = 3, speakerHeroId = 151}
, 
[49] = {content = 490, contentType = 3, speakerHeroId = 151}
, 
[50] = {content = 500, contentType = 3, speakerHeroId = 151}
, 
[51] = {content = 510, contentType = 3, speakerHeroId = 151, 
imgTween = {
{imgId = 151, delay = 0, duration = 0.2, posId = 3, alpha = 1, shake = true, isDark = false}
}
}
, 
[52] = {content = 520, contentType = 2, 
imgTween = {
{imgId = 151, delay = 0, duration = 0.2, posId = 3, alpha = 0, isDark = false}
}
}
, 
[53] = {content = 530, contentType = 4, speakerName = 11}
, 
[54] = {content = 540, contentType = 3, speakerHeroId = 143, contentShake = true, 
imgTween = {
{imgId = 143, delay = 0, duration = 0.2, posId = 3, alpha = 1, isDark = false}
}
}
, 
[55] = {content = 550, contentType = 2, 
imgTween = {
{imgId = 143, delay = 0, duration = 0.2, posId = 3, alpha = 0, isDark = false}
}
}
, 
[56] = {content = 560, contentType = 3, speakerHeroId = 143, speakerHeroPosId = 3, 
imgTween = {
{imgId = 143, delay = 0, duration = 0, posId = 4, alpha = 0, isDark = false}
, 
{imgId = 143, delay = 0, duration = 0.2, posId = 4, alpha = 1, isDark = false}
, 
{imgId = 167, delay = 0, duration = 0, posId = 2, alpha = 0, isDark = true}
, 
{imgId = 167, delay = 0, duration = 0.2, posId = 2, alpha = 1, isDark = true}
}
, 
heroFace = {
{imgId = 143, faceId = 2}
}
}
, 
[57] = {content = 570, contentType = 3, speakerHeroId = 1067, speakerHeroPosId = 1, 
imgTween = {
{imgId = 167, delay = 0, duration = 0.2, posId = 2, alpha = 1, isDark = false}
, 
{imgId = 143, delay = 0, duration = 0.2, posId = 4, alpha = 1, isDark = true}
}
, 
heroFace = {
{imgId = 167, faceId = 6}
}
}
, 
[58] = {content = 580, contentType = 4, speakerName = 11, contentShake = true, 
imgTween = {
{imgId = 167, delay = 0, duration = 0.2, posId = 2, alpha = 0, isDark = false}
, 
{imgId = 143, delay = 0, duration = 0.2, posId = 4, alpha = 0, isDark = true}
}
}
, 
[59] = {content = 590, contentType = 4, speakerName = 11, contentShake = true}
, 
[60] = {content = 600, contentType = 3, speakerHeroId = 143, contentShake = true, 
imgTween = {
{imgId = 143, delay = 0, duration = 0, posId = 3, alpha = 0, isDark = false}
, 
{imgId = 143, delay = 0, duration = 0.2, posId = 3, alpha = 1, isDark = false}
}
}
, 
[61] = {content = 610, contentType = 2, 
imgTween = {
{imgId = 143, delay = 0, duration = 0.2, posId = 3, alpha = 0, isDark = false}
}
, 
audio = {
sfx = {cue = "AVG_Battlefield", sheet = "AVG_gf"}
}
}
, 
[62] = {bgColor = 3, content = 620, contentType = 2, contentShake = true, 
imgTween = {
{imgId = 2, delay = 0, duration = 0.6, alpha = 0}
, 
{imgId = 2, delay = 0, duration = 0.6, shake = true, shakeIntensity = 4}
}
, 
audio = {
bgm = {stop = true}
, 
sfx = {cue = "AVG_Explode", sheet = "AVG_gf"}
}
}
, 
[63] = {content = 630, contentType = 4, speakerName = 11}
, 
[64] = {content = 640, contentType = 2, 
imgTween = {
{imgId = 2, delay = 0, duration = 0.6, alpha = 1, isDark = true}
}
}
, 
[65] = {bgColor = 2, content = 650, contentType = 2, 
audio = {
sfx = {cue = "AVG_quake", sheet = "AVG"}
}
}
, 
[66] = {autoContinue = true, isEnd = true, 
imgTween = {
{imgId = 2, delay = 0, duration = 1, alpha = 0}
}
}
}
return AvgCfg_cpt_clotho_01_03

