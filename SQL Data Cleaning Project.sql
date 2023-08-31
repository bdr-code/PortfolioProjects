/*
Cleaning Data in SQL Querries
*/


Select * from PortfolioProject..NashvilleHousing


-- Standardised Date format

Select SaleDateConverted, CONVERT(date, SaleDate)
from PortfolioProject..NashvilleHousing


Update NashvilleHousing
Set SaleDate = CONVERT(date, SaleDate)

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;

Update NashvilleHousing
Set SaleDateConverted = CONVERT(date, SaleDate)


-- Populate Property Address Data

Select *
from PortfolioProject..NashvilleHousing 

--Where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNUll(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject..NashvilleHousing a
Join PortfolioProject..NashvilleHousing b
	on  a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]  
Where a.PropertyAddress is null


Update a
Set PropertyAddress =  ISNUll(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject..NashvilleHousing a
Join PortfolioProject..NashvilleHousing b
	on  a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]  
Where a.PropertyAddress is null


-- Breaking out Address into Individual Columns(Addres,City,State)


Select PropertyAddress
from PortfolioProject..NashvilleHousing 

--Where PropertyAddress is null
--order by ParcelID


Select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) As Address
,SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1, Len(PropertyAddress)) As Address

from PortfolioProject..NashvilleHousing 



ALTER TABLE NashvilleHousing
ADD PropertySplitAddress NVARCHAR(255);

Update NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)


ALTER TABLE NashvilleHousing
ADD PropertySplitCity Nvarchar(255);

Update NashvilleHousing
Set PropertySplitCity  = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1, Len(PropertyAddress))

Select *
from PortfolioProject..NashvilleHousing ;


Select OwnerAddress
from PortfolioProject..NashvilleHousing


Select 
PARSENAME(Replace(OwnerAddress,',','.'),3),
PARSENAME(Replace(OwnerAddress,',','.'),2),
PARSENAME(Replace(OwnerAddress,',','.'),1)
from PortfolioProject..NashvilleHousing


ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress,',','.'), 3)


ALTER TABLE NashvilleHousing
ADD OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitCity  = PARSENAME(Replace(OwnerAddress,',','.'),2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState NVARCHAR(255);

Update NashvilleHousing
Set OwnerSplitState = PARSENAME(Replace(OwnerAddress,',','.'),1)

Select *
from PortfolioProject..NashvilleHousing ;

-- We will change Y and N to Yes and No in "Sold as Vacant" Field


Select Distinct(SoldAsVacant),COUNT(SoldAsVacant)

from PortfolioProject..NashvilleHousing 
Group By SoldAsVacant
Order By 2;


Select SoldAsVacant
, Case When SoldAsVacant = 'Y' Then 'Yes'
	   When SoldAsVacant = 'N' Then 'No'
	   Else
	   SoldAsVacant 
	   End
from PortfolioProject..NashvilleHousing 


Update NashvilleHousing
Set SoldAsVacant = Case When SoldAsVacant = 'Y' Then 'Yes'
	   When SoldAsVacant = 'N' Then 'No'
	   Else
	   SoldAsVacant 
	   End

-- Removing Duplicates

With RowNUMCTE As(
Select *,
	Row_Number() OVER(
	Partition By ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 Order By
					UniqueId
					) row_num
from PortfolioProject..NashvilleHousing 
)

Select *
From RowNUMCTE
Where Row_num > 1
Order By PropertyAddress


-- deleting Unused Columns

Select *
from PortfolioProject..NashvilleHousing; 

Alter Table PortfolioProject..NashvilleHousing
Drop Column OwnerAddress,TaxDistrict,PropertyAddress


Alter Table PortfolioProject..NashvilleHousing
Drop Column SaleDate