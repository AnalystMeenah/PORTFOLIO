--Cleaning Data in SQL Queries

Select * 
from [dbo].[Nashvillehousingdata]



--Standardize the date format

select saledateconverted, convert(date,saledate)
from [dbo].[Nashvillehousingdata]

update [dbo].[Nashvillehousingdata]
Set Saledate = convert(date,saledate)

Alter table [dbo].[Nashvillehousingdata]
add saledateconverted Date

update [dbo].[Nashvillehousingdata]
Set Saledateconverted = convert(date,saledate)



--Populate Property Address data



select *
from [dbo].[Nashvillehousingdata]
where propertyaddress is NULL

select *
from [dbo].[Nashvillehousingdata]
--where propertyaddress is NULL
Order by ParcelID

--there are coulumn Parcelid with the same Address, making the property address the same,
--so we can say if the Parcelid has an address

select a.parcelID, a.propertyaddress, b.parcelID, b.propertyaddress
from [dbo].[Nashvillehousingdata] a
join [dbo].[Nashvillehousingdata] b
on a.parcelID = b.parcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.propertyaddress is null

--To populate the Null property address, use ISNULL 
select a.parcelID, a.propertyaddress, b.parcelID, b.propertyaddress, ISNULL(a.propertyaddress, b.propertyaddress)
from [dbo].[Nashvillehousingdata] a
join [dbo].[Nashvillehousingdata] b
on a.parcelID = b.parcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.propertyaddress is null

UPDATE a 
set propertyaddress = ISNULL(a.propertyaddress, b.propertyaddress)
from [dbo].[Nashvillehousingdata] a
join [dbo].[Nashvillehousingdata] b
on a.parcelID = b.parcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.propertyaddress is null

--Breaking out Property ADDRESS INTO individual columns (Address and city) using a substring and charindex

select PropertyAddress
from [dbo].[Nashvillehousingdata]

Select SUBSTRING(propertyaddress, 1, CHARINDEX(',',propertyaddress)) as Address
from [dbo].[Nashvillehousingdata]

--To Eliminate the ',' use -1

Select SUBSTRING(propertyaddress, 1, CHARINDEX(',',propertyaddress) -1 ) as Address
from [dbo].[Nashvillehousingdata]
--for the city
Select SUBSTRING(propertyaddress, CHARINDEX(',',propertyaddress) +1, Len(propertyaddress)) as Address
from [dbo].[Nashvillehousingdata]

Alter table [dbo].[Nashvillehousingdata]
add PropertySplitAddress nvarchar(255) 

update [dbo].[Nashvillehousingdata]
set PropertySplitAddress = SUBSTRING(propertyaddress, 1, CHARINDEX(',',propertyaddress) -1 ) 

Alter table [dbo].[Nashvillehousingdata]
add propertySpiltCity nvarchar(255)

update [dbo].[Nashvillehousingdata]
set propertySpiltCity = SUBSTRING(propertyaddress, CHARINDEX(',',propertyaddress) +1, Len(propertyaddress))

select * from [dbo].[Nashvillehousingdata]

----Breaking out Owner ADDRESS INTO individual columns (Address and city and state) using a Parsename)
select Owneraddress from [dbo].[Nashvillehousingdata]

select 
PARSENAME(REPLACE(OWNERADDRESS, ',','.'), 3),
PARSENAME(REPLACE(OWNERADDRESS, ',','.'), 2),
PARSENAME(REPLACE(OWNERADDRESS, ',','.'), 1)
FROM [dbo].[Nashvillehousingdata]

ALTER TABLE [dbo].[Nashvillehousingdata]
ADD OWNERSHIPSPLITADDRESS NVARCHAR(255)

UPDATE [dbo].[Nashvillehousingdata]
SET OWNERSHIPSPLITADDRESS = PARSENAME(REPLACE(OWNERADDRESS, ',','.'), 3)

ALTER TABLE [dbo].[Nashvillehousingdata]
ADD OWNERSHIPSPLITCITY NVARCHAR(255)

UPDATE [dbo].[Nashvillehousingdata]
SET OWNERSHIPSPLITCITY = PARSENAME(REPLACE(OWNERADDRESS, ',','.'), 2)

ALTER TABLE [dbo].[Nashvillehousingdata]
ADD OWNERSHIPSPLITSTATE NVARCHAR(255)

UPDATE [dbo].[Nashvillehousingdata]
SET OWNERSHIPSPLITSTATE = PARSENAME(REPLACE(OWNERADDRESS, ',','.'), 1)

SELECT * FROM [dbo].[Nashvillehousingdata]

--CHANGE Y AND N TO YES AND NO IN SOLD AS VACANT COLUMN USING CASE STATEMENT
SELECT SOLDASVACANT,
CASE WHEN SOLDASVACANT = 'Y' THEN 'YES'
WHEN SOLDASVACANT = 'N' THEN 'NO'
ELSE SOLDASVACANT
END
FROM [dbo].[Nashvillehousingdata]

UPDATE [dbo].[Nashvillehousingdata]
SET SOLDASVACANT = 
CASE WHEN SOLDASVACANT = 'Y' THEN 'YES'
WHEN SOLDASVACANT = 'N' THEN 'NO'
ELSE SOLDASVACANT
END

---REMOVE DUPLICATES
with RownumCTE as(
select *, 
Row_number() over (
partition by parcelid, 
			propertyaddress,
			saleprice,
			saledate,
			legalreference
			Order by
			uniqueid) Row_num
			from [dbo].[Nashvillehousingdata])
	select * from RownumCTE
	where row_num > 1
	Order by propertyAddress

--To remove the duplicates
with RownumCTE as(
select *, 
Row_number() over (
partition by parcelid, 
			propertyaddress,
			saleprice,
			saledate,
			legalreference
			Order by
			uniqueid) Row_num
			from [dbo].[Nashvillehousingdata])
	delete from RownumCTE
	where row_num > 1

--Delete Unused columns Owneraddress, TaxDISTRICT, propertyaddress, saledate, saledate

Alter Table [dbo].[Nashvillehousingdata]
drop column Owneraddress, TaxDISTRICT, propertyaddress, saledate

select * from [dbo].[Nashvillehousingdata]

Alter Table [dbo].[Nashvillehousingdata]
drop column saledate















