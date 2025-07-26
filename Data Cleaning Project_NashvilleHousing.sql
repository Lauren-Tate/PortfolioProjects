-- Cleaning Data in SQL Queries
SELECT *
FROM db_portfolio.NashvilleHousing;

-- Standardize Date Format
-- Disable safe updates so full table UPDATE works
SET SQL_SAFE_UPDATES = 0;

-- Convert the text dates to ISO date string format (YYYY-MM-DD) inside SaleDate
UPDATE db_portfolio.NashvilleHousing
SET SaleDate = DATE_FORMAT(STR_TO_DATE(SaleDate, '%M %e, %Y'), '%Y-%m-%d')
WHERE SaleDate IS NOT NULL;

-- Change SaleDate column type from TEXT (or VARCHAR) to DATE
ALTER TABLE db_portfolio.NashvilleHousing
MODIFY COLUMN SaleDate DATE;

-- Verify the conversion
SELECT SaleDate
FROM db_portfolio.NashvilleHousing
LIMIT 10;

-- Populate Property Address Data
SELECT *
FROM db_portfolio.NashvilleHousing
-- WHERE TRIM(PropertyAddress) = '';
ORDER BY ParcelID;

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
FROM db_portfolio.NashvilleHousing a
JOIN db_portfolio.NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.UniqueID <> b.UniqueID
WHERE TRIM(a.PropertyAddress) = '';

UPDATE db_portfolio.NashvilleHousing a
JOIN (
    SELECT UniqueID, ParcelID, PropertyAddress
    FROM db_portfolio.NashvilleHousing
    WHERE TRIM(PropertyAddress) <> ''
) b ON a.ParcelID = b.ParcelID
   AND a.UniqueID <> b.UniqueID
SET a.PropertyAddress = b.PropertyAddress
WHERE TRIM(a.PropertyAddress) = '';

-- Breaking Out Address Into Individual Columns (Address, City, State)
SELECT PropertyAddress
FROM db_portfolio.NashvilleHousing;
-- WHERE TRIM(PropertyAddress) = '';
-- ORDER BY ParcelID;

SELECT
  SUBSTRING(PropertyAddress, 1, INSTR(PropertyAddress, ',') - 1) AS Address,
  SUBSTRING(PropertyAddress, INSTR(PropertyAddress, ',') + 1, LENGTH(PropertyAddress)) AS Address
FROM db_portfolio.NashvilleHousing;


-- Add new columns for split address
ALTER TABLE db_portfolio.NashvilleHousing
ADD COLUMN PropertySplitAddress VARCHAR(255),
ADD COLUMN PropertySplitCity VARCHAR(255);

-- Update PropertySplitAddress (street address before comma)
UPDATE db_portfolio.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, INSTR(PropertyAddress, ',') - 1);

-- Update PropertySplitCity (city name after comma)
UPDATE db_portfolio.NashvilleHousing
SET PropertySplitCity = TRIM(SUBSTRING(PropertyAddress, INSTR(PropertyAddress, ',') + 1));

SELECT *
FROM db_portfolio.NashvilleHousing;

SELECT OwnerAddress
FROM db_portfolio.NashvilleHousing;

-- Add new columns to hold the split data
ALTER TABLE db_portfolio.NashvilleHousing
ADD COLUMN OwnerSplitAddress VARCHAR(255),
ADD COLUMN OwnerSplitCity VARCHAR(255),
ADD COLUMN OwnerSplitState VARCHAR(255);

-- Update OwnerSplitAddress
UPDATE db_portfolio.NashvilleHousing
SET OwnerSplitAddress = TRIM(SUBSTRING_INDEX(OwnerAddress, ',', 1));

-- Update OwnerSplitCity 
UPDATE db_portfolio.NashvilleHousing
SET OwnerSplitCity = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1));

-- Update OwnerSplitState
UPDATE db_portfolio.NashvilleHousing
SET OwnerSplitState = TRIM(SUBSTRING_INDEX(OwnerAddress, ',', -1));

-- View the results
SELECT *
FROM db_portfolio.NashvilleHousing;

-- Change Y and N to Yean and No in "Sold as Vacant" Field
SELECT SoldAsVacant, COUNT(SoldAsVacant)
FROM db_portfolio.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2;

SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END
FROM db_portfolio.NashvilleHousing;

UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END;

-- Remove Duplicates
-- Check for Duplicates 
SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY ParcelID,
                            PropertyAddress,
                            SalePrice,
                            SaleDate,
                            LegalReference
               ORDER BY UniqueID
           ) AS row_num
    FROM db_portfolio.NashvilleHousing
) AS RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress;

-- Delete Duplicates
DELETE nh
FROM db_portfolio.NashvilleHousing nh
JOIN (
    SELECT UniqueID
    FROM (
        SELECT UniqueID,
               ROW_NUMBER() OVER (
                   PARTITION BY ParcelID,
                                PropertyAddress,
                                SalePrice,
                                SaleDate,
                                LegalReference
                   ORDER BY UniqueID
               ) AS row_num
        FROM db_portfolio.NashvilleHousing
    ) AS numbered
    WHERE row_num > 1
) AS duplicates
ON nh.UniqueID = duplicates.UniqueID;

SELECT *
FROM db_portfolio.NashvilleHousing;

-- Delete Unused Columns
SELECT *
FROM db_portfolio.NashvilleHousing;

ALTER TABLE db_portfolio.NashvilleHousing
DROP COLUMN OwnerAddress,
DROP COLUMN TaxDistrict,
DROP COLUMN PropertyAddress,
DROP COLUMN PropertyCity;

ALTER TABLE db_portfolio.NashvilleHousing
DROP COLUMN SaleDate;

SHOW COLUMNS FROM db_portfolio.NashvilleHousing;