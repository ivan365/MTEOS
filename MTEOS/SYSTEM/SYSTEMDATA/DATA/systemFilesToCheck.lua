local FilesToCheck = {}

FilesToCheck.files = {

    "/MTEOS/SYSTEM/CORE/MTEOSCore.lua",
    "/MTEOS/SYSTEM/LIBRARIES/loadingGUI/simpleLoadSlash.lua",
    "/MTEOS/SYSTEM/SYSTEMDATA/DATA/systemFilesToCheck.lua", 
    "/MTEOS/SYSTEM/LIBRARIES/math/centerForText.lua",
    "/MTEOS/SYSTEM/LIBRARIES/text/printText.lua", 
    "/MTEOS/SYSTEM/LIBRARIES/loadingGUI/progressBarSimple.lua",
    "/MTEOS/SYSTEM/LIBRARIES/loadingGUI/progressBarAdvanced.lua",
    "/MTEOS/SYSTEM/LIBRARIES/pic/easyPic.lua",
    "/MTEOS/SYSTEM/LIBRARIES/objects/objects.lua",
    
}

FilesToCheck.getFilesToCheck = function()
    return FilesToCheck.files
end

return FilesToCheck