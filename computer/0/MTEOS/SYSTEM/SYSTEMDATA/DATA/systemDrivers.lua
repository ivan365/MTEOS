local drivers = {
    driverList = {
        mokey = {
            path = "/MTEOS/SYSTEM/SYSTEMDRIVERS/mokey/mokey.lua", 
            flags = '-s -p 1 -wh',
            args = ''
        },
        origEvent = {
            path = "/MTEOS/SYSTEM/SYSTEMDRIVERS/origEvent/origEvent.lua", 
            flags = '-s -p 2 -wh',
            args = ''
        },
    }
}
return drivers