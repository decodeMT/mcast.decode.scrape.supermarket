create table labels (
	labelId serial primary key,
	labelText varchar(100) not null unique
);

insert into labels (labelText)
select "GROUP_1" as group_value from greens_raw where "GROUP_1" is not null
union
select "GROUP_2" from greens_raw where "GROUP_2" is not null
union
select "GROUP_3" from greens_raw where "GROUP_3" is not null
union
select "GROUP_4" from greens_raw where "GROUP_4" is not null
union
select "GROUP_5" from greens_raw where "GROUP_5" is not null;

create table size_uom (
	sizeId serial primary key,
	sizeUom varchar(100) not null unique
);

insert into size_uom (sizeUom)
select distinct "SIZE_UOM" from greens_raw where "SIZE_UOM" is not null;


create table country (
	countryId serial primary key,
	country varchar(100) not null unique
);

insert into country (country)
select distinct "COUNTRY_OF_ORIGIN" from greens_raw where "COUNTRY_OF_ORIGIN" is not null;


create table product (
	productId serial primary key,
	partNumber varchar(100),
	product varchar(300) not null,
	salesPrice numeric(10,2),
	salesPriceRRP numeric(10,2),
	sizeValue numeric(10,2),
	sizeId integer references size_uom(sizeId),
	isWeighted boolean, -- ITEM_TYPE
	customWeight varchar(200),
	countryId integer references country(countryId),
	bcrs boolean,
	image varchar(500),
	scrapeTag varchar(100)
	
);


insert into product 
 (partnumber, product, salesprice, salespricerrp, sizevalue, sizeid, isweighted,
 customweight, countryid, bcrs, image, scrapetag)
select distinct
	"PART_NUMBER", "PART_DESCRIPTION", "SALES_PRICE", "SALES_PRICE_RRP",
	"SIZE_VALUE", si.sizeid, 
	CASE
		WHEN LOWER("ITEM_TYPE") = 'weighted' THEN TRUE
	ELSE FALSE END, 
	"CUSTOM_WEIGHT", 
	co.countryid, 
	CASE
		WHEN LOWER("BCRS") = 'yes' THEN TRUE
	ELSE FALSE END,
	"Image", 'greens_' || "scrape_tag"
from greens_raw
gr left join size_uom si
on gr."SIZE_UOM" = si."sizeuom"
left join country co
on gr."COUNTRY_OF_ORIGIN" = co."country"

create table product_label (
	productId integer references product(productid),
	labelId integer references labels(labelID),
	primary key(productid, labelid)
)


insert into product_label
(productId, labelId)
select pr.productid, l.labelId
from greens_raw gr 
join product pr
on gr."PART_NUMBER" = pr.partnumber
join labels l
on labelText = gr."GROUP_1"
union
select pr.productid, l.labelId
from greens_raw gr 
join product pr
on gr."PART_NUMBER" = pr.partnumber
join labels l
on labelText = gr."GROUP_2"
union
select pr.productid, l.labelId
from greens_raw gr 
join product pr
on gr."PART_NUMBER" = pr.partnumber
join labels l
on labelText = gr."GROUP_3"
union
select pr.productid, l.labelId
from greens_raw gr 
join product pr
on gr."PART_NUMBER" = pr.partnumber
join labels l
on labelText = gr."GROUP_4"
union
select pr.productid, l.labelId
from greens_raw gr 
join product pr
on gr."PART_NUMBER" = pr.partnumber
join labels l
on labelText = gr."GROUP_5";

select * 
from product pr join size_uom si
on pr.sizeid = si.sizeId
join country co
on pr.countryid = co.countryid
where product = 'Danish Salami';


