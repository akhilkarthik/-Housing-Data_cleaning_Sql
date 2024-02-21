use project2


Select *
From NashvilleHousing


-- Standardize Date Format


Select saleDateConverted, CONVERT(Date,SaleDate)
From NashvilleHousing


Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

-- If it doesn't Update properly

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)



-- Populate Property Address data

Select *
From NashvilleHousing
--Where PropertyAddress is null
order by ParcelID



Select n1.ParcelID, n1.Propertyaddress, n2.ParcelID, n2.Propertyaddress, ISNULL(n1.Propertyaddress,n2.Propertyaddress)
From NashvilleHousing n1
JOIN NashvilleHousing n2
	on n1.ParcelID = n2.ParcelID
	and n1.[UniqueID ] <> n2.[UniqueID ]
Where n1.Propertyaddress is null


Update n1
SET Propertyaddress = ISNULL(n1.Propertyaddress,n2.Propertyaddress)
From NashvilleHousing n1
JOIN NashvilleHousing n2
	on n1.ParcelID = n2.ParcelID
	and n1.[UniqueID ] <> n2.[UniqueID ]
Where n1.Propertyaddress is null






-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From NashvilleHousing


ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




Select *
From NashvilleHousing





Select OwnerAddress
From NashvilleHousing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From NashvilleHousing



ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From NashvilleHousing







-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From NashvilleHousing
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From NashvilleHousing


Update NashvilleHousing
SET SoldAsVacant = CASE 
	   When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END








-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From NashvilleHousing
--order by ParcelID
)



Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From NashvilleHousing




 

-- Delete Unused Columns



Select *
From NashvilleHousing






--------------Remove Duplicates-----------





with rownum_cte as(
select *,
ROW_NUMBER() over (
partition by parcelId,propertyAddress,
saleprice,saledate,legalreference
order by uniqueid)
row_num
from NashvilleHousing
--order by parcelId
)
select *
from rownum_cte 
where row_num>1



--- to delete with cte 

with rownum_cte as(
select *,
ROW_NUMBER() over (
partition by parcelId,propertyAddress,
saleprice,saledate,legalreference
order by uniqueid)
row_num
from NashvilleHousing
--order by parcelId
)
delete 
from rownum_cte 
where row_num>1



----------- Delete unused columns-----------------------


select * from NashvilleHousing


alter table NashvilleHousing
drop column owneraddress,taxdistrict,propertyaddress

alter table NashvilleHousing
drop column saledate