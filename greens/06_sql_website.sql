select *
from product pr join country co
on pr.countryId = co.countryId
join size_uom su
on pr.sizeid = su.sizeid
join product_label pl
on pl.productId = pr.productId
join labels la
on pl.labelId = la.labelId


select pr.productId, product, salesprice, salespricerrp, sizevalue, 
	sizeuom, isWeighted, bcrs, country, replace(scrapeTag, 'greens_', '') as category,
	string_agg(labelText, '; ') as labels
from product pr left join country co
on pr.countryId = co.countryId
left join size_uom su
on pr.sizeid = su.sizeid
left join product_label pl
on pl.productId = pr.productId
left join labels la
on pl.labelId = la.labelId
where labelText not in ('Green''S', 'Greens (Brand)', 'Greens Products', 'Greens Salads')
group by pr.productId, product, salesprice, salespricerrp, sizevalue, 
	sizeuom, isWeighted, bcrs, country;
	

select json_agg (
		json_build_object (
			'product_id', productid, 
			'product', product, 
			'salesprice', salesprice, 
			'salespricerrp', salespricerrp, 
			'sizevalue', sizevalue, 
			'sizeunit', sizeuom, 
			'isWeighted', isWeighted, 
			'bcrs', bcrs, 
			'country', country, 
			'category', category,
			'labels', labels
		)
	) as products
from (
	select pr.productId as productid, product, salesprice, salespricerrp, sizevalue, 
		sizeuom, isWeighted, bcrs, country, replace(scrapeTag, 'greens_', '') as category,
		string_agg(labelText, '; ') as labels
	from product pr left join country co
	on pr.countryId = co.countryId
	left join size_uom su
	on pr.sizeid = su.sizeid
	left join product_label pl
	on pl.productId = pr.productId
	left join labels la
	on pl.labelId = la.labelId
	where labelText not in ('Green''S', 'Greens (Brand)', 'Greens Products', 'Greens Salads')
	group by pr.productId, product, salesprice, salespricerrp, sizevalue, 
		sizeuom, isWeighted, bcrs, country
) as prod

