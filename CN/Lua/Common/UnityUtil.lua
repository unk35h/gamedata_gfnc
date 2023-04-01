-- params : ...
-- function num : 0 , upvalues : _ENV
local cs_unity_object = (CS.UnityEngine).Object
IsNull = function(unity_object)
  -- function num : 0_0 , upvalues : _ENV
  if unity_object == nil then
    return true
  end
  if type(unity_object) == "userdata" and unity_object.IsNull ~= nil then
    return unity_object:IsNull()
  end
  return false
end

DestroyUnityObject = function(obj, immediate)
  -- function num : 0_1 , upvalues : _ENV, cs_unity_object
  if IsNull(obj) then
    return 
  end
  if not immediate then
    immediate = false
  end
  if immediate then
    (cs_unity_object.DestroyImmediate)(obj)
  else
    ;
    (cs_unity_object.Destroy)(obj)
  end
end

GetTrWidthScaleCompareStandardScreeSize = function(transform)
  -- function num : 0_2 , upvalues : _ENV
  local width = ((UIManager.csUIManager).BackgroundStretchSize).x * (1 - (UIManager.csUIManager).CurNotchValue / 100 * 2)
  local oriWidth = 1920 - (transform.offsetMin).x + (transform.offsetMax).x
  local nowWidth = width - (transform.offsetMin).x + (transform.offsetMax).x
  return nowWidth / oriWidth
end

GetL2dBorderVec = function(gameobject)
  -- function num : 0_3 , upvalues : _ENV
  if IsNull(gameobject) then
    return nil, nil, nil
  end
  local model = gameobject:GetComponent(typeof((((CS.Live2D).Cubism).Core).CubismModel))
  if model == nil then
    return nil, nil, nil
  end
  local information = model.CanvasInformation
  local up = information.CanvasOriginY / information.PixelsPerUnit
  local bottom = -(information.CanvasHeight - information.CanvasOriginY) / information.PixelsPerUnit
  local left = -information.CanvasOriginX / information.PixelsPerUnit
  local right = (information.CanvasWidth - information.CanvasOriginX) / information.PixelsPerUnit
  return (Vector3.New)(left, up, 0), (Vector3.New)(right, bottom, 0)
end

TransitionScreenPoint = function(camera, obj, screenPoint)
  -- function num : 0_4 , upvalues : _ENV
  local cameraRelativePos = (camera.transform):InverseTransformPoint((obj.transform).position)
  local screenVec3 = (Vector3.New)(screenPoint.x, screenPoint.y, cameraRelativePos.z)
  local pos = camera:ScreenToWorldPoint(screenVec3)
  local pos = ((obj.transform).parent):InverseTransformPoint(pos)
  pos.z = ((obj.transform).localPosition).z
  return pos
end


