
-- 1. Ilu unikalnych klient�w znajduje si� w bazie danych? - 18 484

select count(distinct CustomerKey) 
from [AdventureWorksDW2019].[dbo].[DimCustomer]

select FirstName, LastName, BirthDate, count(*) 
from [AdventureWorksDW2019].[dbo].[DimCustomer] 
group by FirstName, LastName, BirthDate 
having count(*) > 1 -- to zapytanie sprawdzajace wskazuje ze wszyscy klienci sa rozni



-- 2. Wypisz klient�w z Niemiec, kt�rych imi� zawiera liter� �a�

select a.CustomerKey, 
a.FirstName, 
a.LastName 
from [AdventureWorksDW2019].[dbo].[DimCustomer]  a
join [AdventureWorksDW2019].[dbo].[DimGeography] b on b.GeographyKey = a.GeographyKey 
												      and b.EnglishCountryRegionName = 'Germany'
where a.FirstName like '%a%'

-- 3. Ilu klient�w pochodzi z ka�dego kraju? Posortuj malej�co po liczbie klient�w.

select b.EnglishCountryRegionName, 
count(a.CustomerKey) ilosc_klientow
from [AdventureWorksDW2019].[dbo].[DimCustomer]  a
join [AdventureWorksDW2019].[dbo].[DimGeography] b on b.GeographyKey = a.GeographyKey
group by b.EnglishCountryRegionName
order by 2 desc

-- 4. Wypisz produkty, kt�re nigdy nie zosta�y zam�wione.

select a.ProductKey, 
a.EnglishProductName 
from [AdventureWorksDW2019].[dbo].[DimProduct]			   a
left join [AdventureWorksDW2019].[dbo].[FactInternetSales] b on b.ProductKey = a.ProductKey
left join [AdventureWorksDW2019].[dbo].[FactResellerSales] c on c.ProductKey = a.ProductKey
where b.ProductKey is null and c.ProductKey is null 


-- 5. Kt�ry klient wyda� najwi�cej pieni�dzy w roku 2013? 

select top 1 a.CustomerKey, 
sum(b.salesamount) salesamount
from [AdventureWorksDW2019].[dbo].[DimCustomer]		  a
join [AdventureWorksDW2019].[dbo].[FactInternetSales] b on b.CustomerKey = a.CustomerKey 
join [AdventureWorksDW2019].[dbo].[DimDate]			  c on c.DateKey = b.OrderDateKey
where c.CalendarYear = 2013
group by a.CustomerKey
order by 2 desc


-- 6. Zoptymalizuj poni�sze zapytanie pod k�tem wydajno�ci i czytelno�ci

-- Moim g��wnym celem by�o dodanie dw�ch join�w zamiast warunk�w w where.

SELECT 
c.CustomerKey,
c.FirstName,
c.LastName,
COUNT(DISTINCT s.SalesOrderNumber) AS OrderCount,
SUM(s.SalesAmount) AS TotalSpent

FROM [AdventureWorksDW2019].[dbo].DimCustomer		c
JOIN [AdventureWorksDW2019].[dbo].FactInternetSales s on s.CustomerKey = c.CustomerKey
JOIN [AdventureWorksDW2019].[dbo].DimProduct		p on p.ProductKey  = s.ProductKey 
														and p.EnglishProductName LIKE '%Mountain%' 
														and p.Color IN ('Red', 'Silver', 'Black')
JOIN [AdventureWorksDW2019].[dbo].DimDate			d on d.DateKey     = s.OrderDateKey 
														and d.CalendarYear BETWEEN 2012 AND 2014 
														and d.DayNumberOfWeek IN (1, 7)
GROUP BY c.CustomerKey, c.FirstName, c.LastName
HAVING SUM(s.SalesAmount) > 5000
ORDER BY TotalSpent DESC;







