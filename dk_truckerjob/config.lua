Config = {}

----------------------------------------------------------------
-- JOB SETTINGS
----------------------------------------------------------------
-- The name of the job required in the database to perform deliveries.
Config.RequiredJob = 'trucker'


----------------------------------------------------------------
-- PAYMENT & PENALTY SETTINGS
----------------------------------------------------------------
-- The fee charged to the player if they die or destroy the truck during a delivery.
Config.PenaltyFee = 500

Config.ShortHaul = {
    Name = "Short Delivery",
    Payment = {
        Min = 250,
        Max = 400
    },
    -- Locations primarily within Los Santos
    PickupLocations = {
        { Pos = vector3(100.5, -2400.1, 6.0), Name = "LS Docks Pickup" },
        { Pos = vector3(720.8, -1800.3, 25.0), Name = "Cypress Flats Industrial" },
        { Pos = vector3(-600.1, -1600.7, 26.0), Name = "LSIA Cargo Depot" },
        { Pos = vector3(900.0, -1400.0, 30.0), Name = "La Mesa Warehouses" },
        { Pos = vector3(-750.0, -150.0, 37.0), Name = "Rockford Hills Luxury Goods" }
    },
    DropoffLocations = {
        { Pos = vector3(-150.2, -2500.7, 6.0), Name = "Elysian Island Drop-off" },
        { Pos = vector3(500.6, -1500.9, 29.0), Name = "Rancho Warehouses" },
        { Pos = vector3(-50.5, -1700.1, 28.0), Name = "La Puerta Vehicle Storage" },
        { Pos = vector3(-1300.0, -1000.0, 10.0), Name = "Vespucci Construction Site" },
        { Pos = vector3(-1650.0, -1100.0, 13.0), Name = "Del Perro Pier Supplies" }
    }
}

Config.LongHaul = {
    Name = "Long Delivery",
    Payment = {
        Min = 900,
        Max = 1500
    },
    -- Locations that require travel between the city and the county
    PickupLocations = {
        { Pos = vector3(100.5, -2400.1, 6.0), Name = "LS Docks Pickup" },
        { Pos = vector3(1100.2, -2000.5, 30.0), Name = "Murrieta Oil Fields" },
        { Pos = vector3(150.7, 6300.9, 31.5), Name = "Paleto Bay Sawmill" }
    },
    DropoffLocations = {
        { Pos = vector3(150.7, 6300.9, 31.5), Name = "Paleto Bay Sawmill" },
        { Pos = vector3(2700.8, 1500.3, 24.5), Name = "Sandy Shores Airfield" },
        { Pos = vector3(-300.9, 6200.5, 31.0), Name = "Procopio Beach" },
        { Pos = vector3(3615.0, 3740.0, 28.0), Name = "Humane Labs" },
        { Pos = vector3(1700.0, 4800.0, 42.0), Name = "Grapeseed Main Street" },
        { Pos = vector3(-3200.0, 1000.0, 12.0), Name = "Chumash Plaza" }
    }
}


----------------------------------------------------------------
-- VEHICLE SETTINGS
----------------------------------------------------------------
-- The truck and trailer models to be used for the job.
Config.TruckModel = `phantom`
Config.TrailerModel = `trailers3`


----------------------------------------------------------------
-- BLIP SETTINGS
----------------------------------------------------------------
-- The blip settings for the job starting point on the map.
Config.JobBlip = {
    Sprite = 477,
    Display = 4,
    Scale = 0.8,
    Colour = 2,
    Name = "Trucker Job"
}


----------------------------------------------------------------
-- LOCATIONS
----------------------------------------------------------------
-- The location where players go to start a delivery.
Config.JobStartPoint = {
    Pos = vector3(836.5, -2992.8, 6.0),
    Name = "Trucker Job Center"
}

-- The location where players can change their clothes.
Config.CloakroomPoint = {
    Pos = vector3(838.5, -2985.8, 6.0),
    Name = "Trucker Cloakroom"
}

-- The location where the truck will spawn when a delivery starts.
Config.VehicleSpawnPoint = {
    Pos = vector4(816.1, -3002.2, 5.9, 178.5),
    Name = "Vehicle Spawn"
}