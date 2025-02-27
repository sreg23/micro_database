-- =========================================================
-- Database Schema: CS340 Microorganism Management Database
-- =========================================================
-- Author: Reggie Smith, Grant Hopkin
-- Purpose: This database is designed to store information about bacterial strains, 
--          their species, strain types, growth conditions, and storage locations.
-- =========================================================

SET FOREIGN_KEY_CHECKS=0;
SET AUTOCOMMIT = 0;

-- Drop existing tables to avoid conflicts
DROP TABLE IF EXISTS StrainGrowthConditions;
DROP TABLE IF EXISTS StorageDetails;
DROP TABLE IF EXISTS Strains;
DROP TABLE IF EXISTS Species;
DROP TABLE IF EXISTS StrainTypes;
DROP TABLE IF EXISTS FreezerLocations;
DROP TABLE IF EXISTS GrowthConditions;

-- =============================================
-- 1. Species Table (Parent Table)
-- =============================================
-- Stores information about bacterial species.
-- Each species has a unique speciesId as the Primary Key.
-- The speciesName is unique and required.
CREATE TABLE IF NOT EXISTS Species (
    speciesId INT AUTO_INCREMENT PRIMARY KEY,
    speciesName VARCHAR(100) UNIQUE NOT NULL,
    description TEXT
);

-- =============================================
-- 2. StrainTypes Table (Category Table)
-- =============================================
-- Defines the different categories of strains.
-- Each strain type has a unique strainTypeId as the Primary Key.

CREATE TABLE IF NOT EXISTS StrainTypes (
    strainTypeId INT AUTO_INCREMENT PRIMARY KEY,
    typeName VARCHAR(50) UNIQUE NOT NULL,
    description TEXT
);

-- =============================================
-- 3. Strains Table (Child Table)
-- =============================================
-- Stores details of bacterial strains.
-- Each strain is associated with a species and a strain type.
-- Foreign keys:
--   - speciesId references Species(speciesId)
--   - strainTypeId references StrainTypes(strainTypeId)
CREATE TABLE IF NOT EXISTS Strains (
    strainId INT AUTO_INCREMENT PRIMARY KEY,
    strainName VARCHAR(100) UNIQUE NOT NULL,
    speciesId INT NOT NULL,
    strainTypeId INT NULL, -- Now allows NULL values----------------------
    dateAdded TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    description TEXT,
    FOREIGN KEY (speciesId) REFERENCES Species(speciesId) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (strainTypeId) REFERENCES StrainTypes(strainTypeId) 
        ON DELETE SET NULL ON UPDATE CASCADE -- Set to NULL on delete----------------
);

-- =============================================
-- 4. FreezerLocations Table (Storage Locations)
-- =============================================
-- Stores information about different freezer locations.
CREATE TABLE IF NOT EXISTS FreezerLocations (
    locationId INT AUTO_INCREMENT PRIMARY KEY,
    freezerName VARCHAR(50) NOT NULL,
    section VARCHAR(50),
    shelfNumber INT NULL, -- Made nullable-------------------
    notes TEXT
);

-- =============================================
-- 5. GrowthConditions Table (Growth Requirements)
-- =============================================
-- Stores environmental conditions required for strain growth.
CREATE TABLE IF NOT EXISTS GrowthConditions (
    conditionId INT AUTO_INCREMENT PRIMARY KEY,
    temperature DECIMAL(5,2) NOT NULL,
    medium VARCHAR(100) NOT NULL,
    humidity DECIMAL(5,2),
    notes TEXT
);

-- =============================================
-- 6. StrainGrowthConditions Table (M:N Relationship)
-- =============================================
-- Represents a many-to-many relationship between Strains and GrowthConditions.
-- Each row links a strain with a specific growth condition.
CREATE TABLE IF NOT EXISTS StrainGrowthConditions (
    strainId INT NOT NULL,
    conditionId INT NOT NULL,
    PRIMARY KEY (strainId, conditionId),
    FOREIGN KEY (strainId) REFERENCES Strains(strainId) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (conditionId) REFERENCES GrowthConditions(conditionId) 
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- =============================================
-- 7. StorageDetails Table (M:N Relationship)
-- =============================================
-- Represents a many-to-many relationship between Strains and FreezerLocations.
-- Each row links a strain with a storage location and specifies the quantity stored.
CREATE TABLE IF NOT EXISTS StorageDetails (
    storageId INT AUTO_INCREMENT PRIMARY KEY,
    strainId INT NOT NULL,
    locationId INT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    dateStored TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    notes TEXT,
    FOREIGN KEY (strainId) REFERENCES Strains(strainId) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (locationId) REFERENCES FreezerLocations(locationId) 
        ON DELETE SET NULL ON UPDATE CASCADE -- Set to NULL on delete--------------------------
);

SET FOREIGN_KEY_CHECKS=1;

-- =============================================
-- Inserting Sample Data
-- =============================================


-- Inserting data for Species
INSERT INTO Species (speciesName, description) VALUES
('Staphylococcus aureus', 'Gram-positive bacterium, common human pathogen'),
('Escherichia coli', 'Gram-negative, found in intestines of humans and animals'),
('Bacillus subtilis', 'Gram-positive, soil bacterium used in research');

-- Inserting data for StrainTypes
INSERT INTO StrainTypes (typeName, description) VALUES
('Wild Type', 'Unmodified naturally occurring strain'),
('Genetically Modified', 'Strain with intentional modifications'),
('Mutant', 'Strain with spontaneous or induced mutations');

-- Inserting data for Strains
INSERT INTO Strains (strainName, speciesId, strainTypeId, description) VALUES
('USA300', 1, 1, 'Highly virulent MRSA strain'),
('K-12', 2, 2, 'Common laboratory E. coli strain'),
('NewStrain', 2, NULL, 'No strain type assigned.'),
('168', 3, 1, 'Widely used B. subtilis strain');

-- Inserting data for FreezerLocations
INSERT INTO FreezerLocations (freezerName, section, shelfNumber, notes) VALUES
('Main Lab Freezer', 'Top', 1, 'Primary storage for common strains'),
('Backup Freezer', 'Middle', 3, 'Redundant storage location'),
('Cold Room', NULL, NULL, 'For long-term preservation');

-- Inserting data for GrowthConditions
INSERT INTO GrowthConditions (temperature, medium, humidity, notes) VALUES
(37.00, 'LB Broth', 60.00, 'Optimal for bacterial growth'),
(30.00, 'Nutrient Agar', NULL, 'Used for sporulation studies'),
(25.00, 'M9 Minimal Medium', 50.00, 'For selective pressure experiments');

-- Insert sample strain-growth condition relationships
-- Shows which strains grow under which conditions
INSERT INTO StrainGrowthConditions (strainId, conditionId) VALUES
(1, 1), -- USA300 grows at 37°C in LB Broth
(2, 3), -- K-12 grows at 25°C in M9 Minimal Medium
(3, 2); -- 168 grows at 30°C in Nutrient Agar

-- Insert sample storage details
-- Shows where each strain is stored and in what quantity
INSERT INTO StorageDetails (strainId, locationId, quantity, notes) VALUES
(1, 1, 10, 'Stored in cryovials'), -- USA300 stored in Main Lab Freezer
(2, 2, 5, 'Backup stock'),         -- K-12 stored in Backup Freezer
(1, NULL, 10, 'Awaiting location assignment'), -- Example of location with null value
(3, 3, 20, 'Long-term storage');   -- 168 stored in Cold Room

-- Enable foreign key checks and commit transactions

COMMIT;