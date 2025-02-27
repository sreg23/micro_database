-- MICROORGANISMS Data manipulation SQL Queries


-- Inserting data for Strains
INSERT INTO Strains (strainName, speciesId, strainTypeId, description) VALUES
(:strainName, :speciesId, :strainTypeId, :descriptionInput);


INSERT INTO Species (speciesName, description) VALUES
(:speciesName, :descriptionInput);


INSERT INTO StrainTypes (typeName, description) VALUES
(:typeName, :descriptionInput);


-- Inserting data for FreezerLocations (selfNumber is nullable)
INSERT INTO FreezerLocations (freezerName, section, shelfNumber, notes) VALUES
(:freezerName, :section, :shelfNumber, :notes);


-- Inserting data for GrowthConditions
INSERT INTO GrowthConditions (temperature, medium, humidity, notes) VALUES
(:temperature, :medium, :humidity, :notes);


-- Insert sample strain-growth condition relationships
-- Shows which strains grow under which conditions
INSERT INTO StrainGrowthConditions (strainId, conditionId) VALUES
(:strainId, :conditionId);


-- Insert sample storage details (locationId is nullable)
-- Shows where each strain is stored and in what quantity
INSERT INTO StorageDetails (strainId, locationId, quantity, notes) VALUES
(:strainId, :locationId, :quantity, :notes);


--  UPDATE --
UPDATE Strains
SET strainName = :strainName,
speciesId = :speciesId,
strainTypeId = :strainTypeId,
description = :descriptionInput
WHERE strainId = :strainIdInput;


UPDATE Species
SET speciesName = :speciesName,
description = :descriptionInput,
WHERE speciesId = :speciesIdInput;


UPDATE StrainTypes
SET typeName = :typeName,
description = :descriptionInput
WHERE strainId = :strainIdInput;

UPDATE FreezerLocations
SET freezerName = :freezerName,
section = :section,
shelfNumber = :shelfNumber,
notes = :notes
WHERE locationId = :locationIdInput;


UPDATE GrowthConditions
SET temperature = :temperature,
medium = :medium,
humidity = :humidity,
notes = :notes
WHERE conditionId = :conditionIdInput;



-- DELETE
DELETE FROM Strains
WHERE strainId = :strainIdInput;

DELETE FROM Species
WHERE speciesId = :SpeciesIdInput;

DELETE FROM StrainTypes
WHERE strainTypeId = :strainTypeIdInput;

DELETE FROM FreezerLocations
WHERE locationId = :locationIdInput;

DELETE FROM GrowthConditions
WHERE conditionId = :conditionIdInput;

DELETE FROM StorageDetails
WHERE storageId = :storageIdInput;

DELETE FROM StrainGrowthConditions
WHERE strainId = :strainIdInput AND conditionId = :conditionIdInput;



-- SELECT queries --
SELECT Strains.strainId, Strains.strainName, Species.speciesName, StrainTypes.typeName, Strains.description 
FROM Strains
INNER JOIN Species ON Strains.speciesId = Species.speciesId
INNER JOIN StrainTypes ON Strains.speciesId = StrainTypes.strainTypeId;

SELECT * FROM Species;

SELECT * FROM StrainTypes;

SELECT * FROM FreezerLocations;

SELECT StorageDetails.storageId, Strains.strainName, FreezerLocations.freezerName,
StorageDetails.quantity, StorageDetails.dateStored, StorageDetails.notes
FROM StorageDetails
INNER JOIN Strains ON StorageDetails.strainId = Strains.strainId
INNER JOIN FreezerLocations ON StorageDetails.locationId = FreezerLocations.locationId;

SELECT * FROM GrowthConditions;



SELECT Strains.strainName, GrowthConditions.conditionId
FROM StrainGrowthConditions
INNER JOIN Strains ON StrainGrowthConditions.strainId = Strains.strainId
INNER JOIN GrowthConditions ON StrainGrowthConditions.conditionId = GrowthConditions.conditionId;



-- For drop down menus

SELECT DISTINCT strainName FROM Strains;
SELECT DISTINCT speciesName FROM Species;
SELECT DISTINCT typeName FROM StrainTypes;
SELECT DISTINCT freezerName FROM FreezerLocations;
SELECT DISTINCT notes FROM GrowthConditions;