/*CLEANING THE DATA*/
select * from nachville_housing;

select PropertyAddress from nachville_housing
where PropertyAddress not like '%_%';

update nachville_housing
set PropertyAddress =null
where PropertyAddress='';

select PropertyAddress from nachville_housing
where PropertyAddress is null;



/*POPULATING PROPERTY ADDRESS DATA*/

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,coalesce(a.PropertyAddress,b.PropertyAddress)
from nachville_housing as a
join nachville_housing as b
on a.ParcelID=b.ParcelID
and a.UniqueID<>b.UniqueID
where a.PropertyAddress is null;

UPDATE nachville_housing AS a
JOIN nachville_housing AS b
 ON a.ParcelID = b.ParcelID 
 AND a.UniqueID <> b.UniqueID
SET a.PropertyAddress = COALESCE(a.PropertyAddress, b.PropertyAddress)
WHERE a.PropertyAddress IS NULL;



/*BREAKING  Property ADDRESS INTO A INDIVIDUAL COLUMNS(ADDRESS,CITY,STATE)*/

select PropertyAddress from nachville_housing;

SELECT
    SUBSTRING_INDEX(PropertyAddress, ',', 1) AS first_part,
    SUBSTRING_INDEX(PropertyAddress, ',', -1) AS second_part
FROM nachville_housing;

alter table nachville_housing
add PropertySplitAddress nvarchar(255);

update nachville_housing
set PropertySplitAddress = SUBSTRING_INDEX(PropertyAddress, ',', 1); 

alter table nachville_housing
add PropertySplitCity nvarchar(255);

update nachville_housing
set PropertySplitCity= SUBSTRING_INDEX(PropertyAddress, ',', -1); 



/*BREAKING  OWNER ADDRESS INTO A INDIVIDUAL COLUMNS(ADDRESS,CITY,STATE)*/

SELECT
  OwnerAddress,
  SUBSTRING_INDEX(OwnerAddress, ',', 1) AS Part1,
  TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', -2), ',', 1)) AS Part2,
  TRIM(SUBSTRING_INDEX(OwnerAddress, ',', -1)) AS Part3
FROM nachville_housing;

alter table nachville_housing
add OwnerSplitAddress nvarchar(255);

update nachville_housing
set OwnerSplitAddress = SUBSTRING_INDEX(OwnerAddress, ',', 1); 

alter table nachville_housing
add OwnerSplitCity nvarchar(255);

update nachville_housing
set OwnerSplitCity= TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', -2), ',', 1));

alter table nachville_housing
add OwnerSplitState nvarchar(255);

update nachville_housing
set OwnerSplitState= TRIM(SUBSTRING_INDEX(OwnerAddress, ',', -1));


/*DROP COLUMNS*/
select * from nachville_housing;
alter table nachville_housing
drop column PropertyAplitAddress;







