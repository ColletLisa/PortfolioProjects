---DATA CLEANING IN SQL
---previewing the data
Select*
From PortfolioProjects..NashvilleHousing

--Changing date formate
---The SaleDate is in date time format,we want to change it to date format.
---We therefore,do this by excluding the time using CONVERT,update,set


Select saleDateConverted, CONVERT(Date,SaleDate)
From PortfolioProjects..NashvilleHousing

---We first use the ALTER TABLE to create a new column where our new date will be stored
ALTER TABLE PortfolioProjects..NashvilleHousing

Add Date_Converted Date;

---we then update our table
Update PortfolioProjects..NashvilleHousing

SET Date_Converted = CONVERT(Date,SaleDate)

---checking to see if the change has been effected
Select saleDateConverted, CONVERT(Date,SaleDate)
From PortfolioProjects..NashvilleHousing

--- POPULTING THE PROPERTY ADDRESS
--From the table, the property address 

Select *
From PortfolioProjects..NashvilleHousing

order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProjects..NashvilleHousing a
JOIN PortfolioProjects..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


---CHANGE Y TO YES AND N TO NO
Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProjects..NashvilleHousing
Group by SoldAsVacant
order by 2

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PortfolioProjects..NashvilleHousing


Update PortfolioProjects..NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

---DELETING UNUSED DATA
Select *
From PortfolioProjects..NashvilleHousing


ALTER TABLE PortfolioProjects..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

---CHECKING FOR DUPLICATES

SELECT 
    ParcelID,
    LandUse,
    SalePrice,
	LegalReference,
	SoldAsVacant,
	OwnerName,
	Acreage,
	LandValue,
	BuildingValue,
	TotalValue,
	YearBuilt,
	Bedrooms,
	FullBath,
	HalfBath,
	SaleDateConverted,
	City,
	


   COUNT(*) AS "Count"
FROM PortfolioProjects..NashvilleHousing
GROUP BY 
     ParcelID,
    LandUse,
    SalePrice,
	LegalReference,
	SoldAsVacant,
	OwnerName,
	Acreage,
	LandValue,
	BuildingValue,
	TotalValue,
	YearBuilt,
	Bedrooms,
	FullBath,
	HalfBath,
	SaleDateConverted,
	City
HAVING COUNT(*) > 1
ORDER BY ParcelID;

--Removing the duplicates
WITH CTE AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY  ParcelID,
    LandUse,
    SalePrice,
	LegalReference,
	SoldAsVacant,
	OwnerName,
	Acreage,
	LandValue,
	BuildingValue,
	TotalValue,
	YearBuilt,
	Bedrooms,
	FullBath,
	HalfBath,
	SaleDateConverted,
	City
               ORDER BY (SELECT 0) -- Use a constant value to ensure deterministic order
           ) AS RowNum
    FROM PortfolioProjects..NashvilleHousing
)
DELETE FROM CTE WHERE RowNum > 1;
