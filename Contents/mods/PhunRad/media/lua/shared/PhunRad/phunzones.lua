require "PhunZones/core"
require "PhunRad/core"
local Core = PhunRad
local PZ = PhunZones

-- Add a setting for radiation level to the PhunZones mod
PZ.fields.rads = {
    label = "IGUI_PhunRad_Rads",
    type = "int",
    tooltip = "IGUI_PhunRad_Rads_tooltip"
}

local toMerge = {
    Louisville = {
        rads = 60
    },
    Taylorsville = {
        rads = 10
    },
    Romero = {
        rads = 20
    },
    Coryerdon = {
        rads = 30
    },
    VSTOWN = {
        rads = 10
    },
    Dirkerdam = {
        rads = 20,
        subzones = {
            Shipyard = {
                rads = 30
            }
        }
    },
    LCv2 = {
        rads = 20
    },
    TeraMartEast = {
        rads = 10
    },
    UncleReds = {
        rads = 40
    },
    militaryfueldepot = {
        rads = 70
    },
    Militaryairport = {
        rads = 60
    },
    NewEkron = {
        rads = 10
    },
    BearLake = {
        rads = 10
    },
    Chinatown = {
        rads = 10
    },
    RavenCreek = {
        rads = 30
    },
    NuclearReactor = {
        rads = 25,
        subzones = {
            approach = {
                rads = 50
            },
            grounds = {
                rads = 75
            },
            core = {
                rads = 100
            }
        }
    }
}

PZ:addExtendedData(toMerge)
