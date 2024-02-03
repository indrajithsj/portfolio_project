	/*
	
	Cleaning Data in SQL Queries
	
	*/
	
	
	select *
	from nashvilleHousing
	
	--standardize date
	
	select saleDateConverted, convert(date, SaleDate)
	from nashvilleHousing
	
	update nashvilleHousing
	set SaleDate = convert(date, SaleDate)
	
	alter table nashvilleHousing
	add saleDateConverted Date;
	
	update nashvilleHousing
	set saleDateConverted = convert(date, SaleDate)
	
	
	-- populate property address
	
	
	select *
	from nashvilleHousing
	--where PropertyAddress is null
	order by ParcelID
	
	
	select a.ParcelID, a.PropertyAddress, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
	from nashvilleHousing a
	join nashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
	--where a.PropertyAddress is null
	
	update a 
	set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
	from nashvilleHousing a
	join nashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
	where a.PropertyAddress is null
	
	-----------------------------------------------------------------------------------------------
	-- breaking out address into individual column
	
	select PropertyAddress
	from nashvilleHousing
	--where PropertyAddress is null
	--order by ParcelID
	
	Select
	SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress )-1) as address,
	SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress ) + 1, LEN(PropertyAddress)) as address
	from nashvilleHousing
	
	alter table nashvilleHousing
	add propertySplitAddress Nvarchar(255);
	
	update nashvilleHousing
	set  propertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress )-1)
	
	alter table nashvilleHousing
	add propertySplitCity Nvarchar(255);
	
	update nashvilleHousing
	set  propertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress ) + 1, LEN(PropertyAddress)) 
	
	select *
	from nashvilleHousing
	
	----------------------------------------------------------------------------------------------------
	-- separting owner address
	
	
	select OwnerAddress
	from nashvilleHousing
	
	select 
	PARSENAME(Replace(OwnerAddress,',', '.'), 3)
	,PARSENAME(Replace(OwnerAddress,',', '.'), 2)
	,PARSENAME(Replace(OwnerAddress,',', '.'), 1)
	from nashvilleHousing
	
	alter table nashvilleHousing
	add ownerSplitAddress Nvarchar(255);
	
	update nashvilleHousing
	set  ownerSplitAddress = PARSENAME(Replace(OwnerAddress,',', '.'), 3)
	
	alter table nashvilleHousing
	add ownerSplitCity Nvarchar(255);
	
	update nashvilleHousing
	set  ownerSplitCity = PARSENAME(Replace(OwnerAddress,',', '.'), 2)
	
	alter table nashvilleHousing
	add ownerSplitState Nvarchar(255);
	
	update nashvilleHousing
	set  ownerSplitState = PARSENAME(Replace(OwnerAddress,',', '.'), 1)
	
	
	select *
	from nashvilleHousing
	
	----------------------------------------------------------------------------------------------------------------
	-- Change Y and N to yes and no in "Sold as Vacant" field
	
	
	select distinct(SoldAsVacant), count(SoldAsVacant)
	from nashvilleHousing
	group by SoldAsVacant
	order by 2
	
	
	select SoldAsVacant
	, case when SoldAsVacant = 'Y' then 'Yes'
	       when SoldAsVacant = 'N' then 'No'
		   else SoldAsVacant
		   END
	from nashvilleHousing
	
	update nashvilleHousing
	set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
	       when SoldAsVacant = 'N' then 'No'
		   else SoldAsVacant
		   END
	
	----------------------------------------------------------------------------------------------------------------------
	
	--- remove duplicates
	with RowNumVTE as (
		select *,
		ROW_NUMBER() over (
		partition By parcelID,
		PropertyAddress,
		SalePrice,
		SaleDate,
		legalReference
		order by 
		UniqueID) row_num
		
		from nashvilleHousing
	)
	
	select * 
	from RowNumVTE
	where row_num > 1
	order by PropertyAddress
	
	
	-----------------------------------------------------------------------------------------------------------
	-- delete unused columns
	
	
	select *
	from nashvilleHousing
	
	alter Table nashvilleHousing
	drop column SaleDate
	
	
	
