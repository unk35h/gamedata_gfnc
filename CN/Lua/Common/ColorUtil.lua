-- params : ...
-- function num : 0 , upvalues : _ENV
local strfmt = string.format
local strsub = string.sub
local channel_default = 255
local hex24_default = "#FFFFFF"
local hex32_default = "#FFFFFFFF"
local rgb_default = {r = channel_default, g = channel_default, b = channel_default}
local rgba_default = {r = rgb_default.r, g = rgb_default.g, b = rgb_default.b, a = channel_default}
local to_color_bit = function(color)
  -- function num : 0_0 , upvalues : _ENV, channel_default
  color = tonumber(color)
  if color and color <= channel_default and channel_default >= 0 then
    return color
  end
  return channel_default
end

local to_valid_color = function(color)
  -- function num : 0_1 , upvalues : _ENV, rgba_default, to_color_bit
  if type(color) ~= "table" then
    return rgba_default
  end
  color.r = to_color_bit(color.r)
  color.g = to_color_bit(color.g)
  color.b = to_color_bit(color.b)
  color.a = to_color_bit(color.a)
end

local str_to_hex_num = function(hex)
  -- function num : 0_2 , upvalues : _ENV, channel_default
  return tonumber(hex, 16) or channel_default
end

local num_to_hex_str = function(value)
  -- function num : 0_3 , upvalues : strfmt, to_color_bit
  return strfmt("%02X", to_color_bit(value))
end

local hex_to_color = function(hex)
  -- function num : 0_4 , upvalues : _ENV, rgb_default, strsub, to_color_bit, str_to_hex_num, channel_default
  local len = (string.len)(hex)
  if len < 7 then
    return rgb_default
  end
  if strsub(hex, 1, 1) ~= "#" then
    return rgb_default
  end
  local color = {r = to_color_bit(str_to_hex_num(strsub(hex, 2, 3))), g = to_color_bit(str_to_hex_num(strsub(hex, 4, 5))), b = to_color_bit(str_to_hex_num(strsub(hex, 6, 7))), a = channel_default}
  if len == 9 then
    color.a = to_color_bit(str_to_hex_num(strsub(hex, 8, 9)))
  end
  return color
end

local hex_to_color_unit = function(hex)
  -- function num : 0_5 , upvalues : hex_to_color, channel_default
  local color = hex_to_color(hex)
  local color_unit = {r = color.r / channel_default, g = color.g / channel_default, b = color.b / channel_default, a = color.a / channel_default}
  return color_unit
end

local tab_to_color = function(tbl)
  -- function num : 0_6 , upvalues : to_color_bit
  return {r = to_color_bit(tbl[1]), g = to_color_bit(tbl[2]), b = to_color_bit(tbl[3]), a = to_color_bit(tbl[4])}
end

local color_to_tab = function(color)
  -- function num : 0_7 , upvalues : to_valid_color
  to_valid_color(color)
  return {color.r, color.g, color.b, color.a}
end

local color_to_hex24 = function(color)
  -- function num : 0_8 , upvalues : _ENV, hex24_default, num_to_hex_str
  if type(color) ~= "table" then
    return hex24_default
  end
  if not color.r or not color.g or not color.b then
    return hex24_default
  end
  local hex = "#"
  hex = hex .. num_to_hex_str(color.r)
  hex = hex .. num_to_hex_str(color.g)
  hex = hex .. num_to_hex_str(color.b)
  return hex
end

local color_to_hex32 = function(color)
  -- function num : 0_9 , upvalues : color_to_hex24, num_to_hex_str
  return color_to_hex24(color) .. num_to_hex_str(color.a)
end

ColorUtil = {FromHex = hex_to_color, FromHexUnit = hex_to_color_unit, FromTab = tab_to_color, ToTab = color_to_tab, ToHex24 = color_to_hex24, ToHex32 = color_to_hex32, ToHex = color_to_hex24, 
Hex = {Red = "#FF0000", Green = "#00FF00", Blue = "#0000FF", White = "#FFFFFF", Yellow = "#FFFF00", Magenta = "#FF00FF", Aqua = "#00FFFF", Cyan = "#00FFFF", Black = "#000000"}
}

