require 'Items/SuburbsDistributions'
require 'Vehicles/VehicleDistributions'
require "Items/ProceduralDistributions"
require 'Items/Distributions'
require 'Items/ItemPicker'

-- LivingRoomShelf
table.insert(ProceduralDistributions.list["LivingRoomShelf"].items, "PhunRad.BrokenGeigerCounter");
table.insert(ProceduralDistributions.list["LivingRoomShelf"].items, 0.5);

table.insert(ProceduralDistributions.list["ArmySurplusTools"].items, "PhunRad.GeigerCounter");
table.insert(ProceduralDistributions.list["ArmySurplusTools"].items, 1);

-- ArmyStorageMedical
table.insert(ProceduralDistributions.list["ArmyStorageMedical"].items, "PhunRad.BrokenGeigerCounter");
table.insert(ProceduralDistributions.list["ArmyStorageMedical"].items, 1);
table.insert(ProceduralDistributions.list["ArmyStorageMedical"].items, "PhunRad.Iodine");
table.insert(ProceduralDistributions.list["ArmyStorageMedical"].items, 2);

-- ArmySurplusOutfit
table.insert(ProceduralDistributions.list["ArmySurplusOutfit"].items, "PhunRad.GeigerCounter");
table.insert(ProceduralDistributions.list["ArmySurplusOutfit"].items, 1);

-- ArmyStorageElectronics
table.insert(ProceduralDistributions.list["ArmyStorageElectronics"].items, "PhunRad.GeigerCounter");
table.insert(ProceduralDistributions.list["ArmyStorageElectronics"].items, .05);
table.insert(ProceduralDistributions.list["ArmyStorageElectronics"].items, "PhunRad.BrokenGeigerCounter");
table.insert(ProceduralDistributions.list["ArmyStorageElectronics"].items, 4);

-- ArmySurplusMisc
table.insert(ProceduralDistributions.list["ArmySurplusMisc"].items, "PhunRad.BrokenGeigerCounter");
table.insert(ProceduralDistributions.list["ArmySurplusMisc"].items, 1);

-- DrugLabSupplies
table.insert(ProceduralDistributions.list["DrugLabSupplies"].items, "PhunRad.Iodine");
table.insert(ProceduralDistributions.list["DrugLabSupplies"].items, 2);

-- DrugShackDrugs
table.insert(ProceduralDistributions.list["DrugShackDrugs"].items, "PhunRad.Iodine");
table.insert(ProceduralDistributions.list["DrugShackDrugs"].items, 2);

-- ElectronicStoreAppliances
table.insert(ProceduralDistributions.list["ElectronicStoreAppliances"].items, "PhunRad.BrokenGeigerCounter");
table.insert(ProceduralDistributions.list["ElectronicStoreAppliances"].items, 2);

-- ElectronicStoreMisc
table.insert(ProceduralDistributions.list["ElectronicStoreMisc"].items, "PhunRad.GeigerCounter");
table.insert(ProceduralDistributions.list["ElectronicStoreMisc"].items, 2);

-- FireDeptLockers
table.insert(ProceduralDistributions.list["FireDeptLockers"].items, "PhunRad.BrokenGeigerCounter");
table.insert(ProceduralDistributions.list["FireDeptLockers"].items, 1);
table.insert(ProceduralDistributions.list["FireDeptLockers"].items, "PhunRad.Iodine");
table.insert(ProceduralDistributions.list["FireDeptLockers"].items, 0.5);

-- LockerArmyBedroom
table.insert(ProceduralDistributions.list["LockerArmyBedroom"].items, "PhunRad.GeigerCounter");
table.insert(ProceduralDistributions.list["LockerArmyBedroom"].items, 1);
table.insert(ProceduralDistributions.list["LockerArmyBedroom"].items, "PhunRad.Iodine");
table.insert(ProceduralDistributions.list["LockerArmyBedroom"].items, 1.5);

-- MedicalStorageDrugs
table.insert(ProceduralDistributions.list["MedicalStorageDrugs"].items, "PhunRad.Iodine");
table.insert(ProceduralDistributions.list["MedicalStorageDrugs"].items, 2);

-- MedicalClinicDrugs
table.insert(ProceduralDistributions.list["MedicalClinicDrugs"].items, "PhunRad.Iodine");
table.insert(ProceduralDistributions.list["MedicalClinicDrugs"].items, 2);

-- MedicalStorageTools
table.insert(ProceduralDistributions.list["MedicalStorageTools"].items, "PhunRad.GeigerCounter");
table.insert(ProceduralDistributions.list["MedicalStorageTools"].items, 1);
table.insert(ProceduralDistributions.list["MedicalStorageTools"].items, "PhunRad.Iodine");
table.insert(ProceduralDistributions.list["MedicalStorageTools"].items, 5);

-- PharmacyCosmetics
table.insert(ProceduralDistributions.list["PharmacyCosmetics"].items, "PhunRad.Iodine");
table.insert(ProceduralDistributions.list["PharmacyCosmetics"].items, 1);

-- SafehouseMedical
table.insert(ProceduralDistributions.list["SafehouseMedical"].items, "PhunRad.Iodine");
table.insert(ProceduralDistributions.list["SafehouseMedical"].items, 2);

-- SecurityLockers
table.insert(ProceduralDistributions.list["SecurityLockers"].items, "PhunRad.GeigerCounter");
table.insert(ProceduralDistributions.list["SecurityLockers"].items, 0.5);

-- PoliceEvidence
table.insert(ProceduralDistributions.list["PoliceEvidence"].items, "PhunRad.Iodine");
table.insert(ProceduralDistributions.list["PoliceEvidence"].items, 0.5);

-- PoliceLockers
table.insert(ProceduralDistributions.list["PoliceLockers"].items, "PhunRad.Iodine");
table.insert(ProceduralDistributions.list["PoliceLockers"].items, 5);
table.insert(ProceduralDistributions.list["PoliceLockers"].items, "PhunRad.GeigerCounter");
table.insert(ProceduralDistributions.list["PoliceLockers"].items, 1);

-- PoolLockers
table.insert(ProceduralDistributions.list["PoolLockers"].items, "PhunRad.Iodine");
table.insert(ProceduralDistributions.list["PoolLockers"].items, 0.25);

-- PrisonGuardLockers
table.insert(ProceduralDistributions.list["PrisonGuardLockers"].items, "PhunRad.Iodine");
table.insert(ProceduralDistributions.list["PrisonGuardLockers"].items, 2);

-- StoreShelfMedical
table.insert(ProceduralDistributions.list["StoreShelfMedical"].items, "PhunRad.Iodine");
table.insert(ProceduralDistributions.list["StoreShelfMedical"].items, 5);
table.insert(ProceduralDistributions.list["StoreShelfMedical"].items, "PhunRad.BrokenGeigerCounter");
table.insert(ProceduralDistributions.list["StoreShelfMedical"].items, 5);

-- TestingLab
table.insert(ProceduralDistributions.list["TestingLab"].items, "PhunRad.Iodine");
table.insert(ProceduralDistributions.list["TestingLab"].items, 5);
table.insert(ProceduralDistributions.list["TestingLab"].items, "PhunRad.GeigerCounter");
table.insert(ProceduralDistributions.list["TestingLab"].items, 1);

-- ToolStoreTools
table.insert(ProceduralDistributions.list["ToolStoreTools"].items, "PhunRad.BrokenGeigerCounter");
table.insert(ProceduralDistributions.list["ToolStoreTools"].items, 0.25);

-- SurvivalGear
table.insert(ProceduralDistributions.list["SurvivalGear"].items, "PhunRad.GeigerCounter");
table.insert(ProceduralDistributions.list["SurvivalGear"].items, 0.25);
table.insert(ProceduralDistributions.list["SurvivalGear"].items, "PhunRad.Iodine");
table.insert(ProceduralDistributions.list["SurvivalGear"].items, 5);

-- CrateCarpentry
table.insert(ProceduralDistributions.list["CrateCarpentry"].items, "PhunRad.BrokenGeigerCounter");
table.insert(ProceduralDistributions.list["CrateCarpentry"].items, 1);

-- BathroomCabinet
table.insert(ProceduralDistributions.list["BathroomCabinet"].items, "PhunRad.Iodine");
table.insert(ProceduralDistributions.list["BathroomCabinet"].items, 0.5);

-- BathroomCounter
table.insert(ProceduralDistributions.list["BathroomCounter"].items, "PhunRad.Iodine");
table.insert(ProceduralDistributions.list["BathroomCounter"].items, 0.5);

-- CrateElectronics
table.insert(ProceduralDistributions.list["CrateCarpentry"].items, "PhunRad.GeigerCounter");
table.insert(ProceduralDistributions.list["CrateCarpentry"].items, 1);

-- GarageTools
table.insert(ProceduralDistributions.list["GarageTools"].items, "PhunRad.BrokenGeigerCounter");
table.insert(ProceduralDistributions.list["GarageTools"].items, 3);

-- MedicalClinicTools
table.insert(ProceduralDistributions.list["MedicalClinicTools"].items, "PhunRad.BrokenGeigerCounter");
table.insert(ProceduralDistributions.list["MedicalClinicTools"].items, 3);

-- ToolStoreAccessories
table.insert(ProceduralDistributions.list["ToolStoreAccessories"].items, "PhunRad.BrokenGeigerCounter");
table.insert(ProceduralDistributions.list["ToolStoreAccessories"].items, 3);

-- ArmyHangarTools
table.insert(ProceduralDistributions.list["ArmyHangarTools"].items, "PhunRad.BrokenGeigerCounter");
table.insert(ProceduralDistributions.list["ArmyHangarTools"].items, 3);

-- CrateTools
table.insert(ProceduralDistributions.list["CrateTools"].items, "PhunRad.BrokenGeigerCounter");
table.insert(ProceduralDistributions.list["CrateTools"].items, 3);

-- GymLockers
table.insert(ProceduralDistributions.list["GymLockers"].items, "PhunRad.BrokenGeigerCounter");
table.insert(ProceduralDistributions.list["GymLockers"].items, 1);

-- GunStoreShelf
table.insert(ProceduralDistributions.list["GunStoreShelf"].items, "PhunRad.BrokenGeigerCounter");
table.insert(ProceduralDistributions.list["GunStoreShelf"].items, 1);

-- BedroomSideTable
table.insert(ProceduralDistributions.list["BedroomSideTable"].items, "PhunRad.BrokenGeigerCounter");
table.insert(ProceduralDistributions.list["BedroomSideTable"].items, 0.25);
table.insert(ProceduralDistributions.list["BedroomSideTable"].items, "PhunRad.Iodine");
table.insert(ProceduralDistributions.list["BedroomSideTable"].items, 1);

-- OfficeDrawers
table.insert(ProceduralDistributions.list["OfficeDrawers"].items, "PhunRad.BrokenGeigerCounter");
table.insert(ProceduralDistributions.list["OfficeDrawers"].items, 0.5);
table.insert(ProceduralDistributions.list["OfficeDrawers"].items, "PhunRad.Iodine");
table.insert(ProceduralDistributions.list["OfficeDrawers"].items, 1);

-- glovebox
table.insert(VehicleDistributions["GloveBox"].items, "PhunRad.GeigerCounter");
table.insert(VehicleDistributions["GloveBox"].items, 0.1);
table.insert(VehicleDistributions["GloveBox"].items, "PhunRad.Iodine");
table.insert(VehicleDistributions["GloveBox"].items, 0.5);

-- Suburbs
table.insert(SuburbsDistributions["all"]["inventorymale"].items, "PhunRad.BrokenGeigerCounter");
table.insert(SuburbsDistributions["all"]["inventorymale"].items, 0.05);
table.insert(SuburbsDistributions["all"]["inventorymale"].items, "PhunRad.Iodine");
table.insert(SuburbsDistributions["all"]["inventorymale"].items, 0.1);

table.insert(SuburbsDistributions["all"]["inventoryfemale"].items, "PhunRad.BrokenGeigerCounter");
table.insert(SuburbsDistributions["all"]["inventoryfemale"].items, 0.05);
table.insert(SuburbsDistributions["all"]["inventoryfemale"].items, "PhunRad.Iodine");
table.insert(SuburbsDistributions["all"]["inventoryfemale"].items, 0.1);

