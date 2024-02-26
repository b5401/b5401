--create schema
CREATE SCHEMA IF NOT EXISTS dw;



--calendar
DROP TABLE IF EXISTS dw.calendar;
CREATE TABLE IF NOT EXISTS dw.calendar (
	date_id serial NOT NULL,
	"order_date" DATE NOT NULL,
	"ship_date" date NOT NULL,
	"year" int4range NOT NULL,
	"quarter" varchar(5) NOT NULL,
	"month" int4range NOT NULL,
	"week" int4range NOT NULL,
	"day" int4range NOT NULL,
	CONSTRAINT "order_date_pk" PRIMARY KEY ("order_date"),
	CONSTRAINT "ship_date" UNIQUE ("ship_date")
) WITH (
  OIDS=FALSE
);



--deleting rows
TRUNCATE TABLE dw.calendar;



--generating geo_id and insert from stg.orders
insert into dw.calendar 
select 100+row_number() over(), order_date, ship_date, "year", quarter, "month", week, "day" from (select distinct order_date, ship_date, "year", quarter, "month", week, "day" from stg.orders);



--data check quality
select * from dw.calendar c 



--geography
DROP TABLE IF EXISTS dw.geography;
CREATE TABLE IF NOT EXISTS  dw.geography (
	"geo_id" serial NOT NULL,
	"country" varchar(13) NOT NULL,
	"city" varchar(17) NOT NULL,
	"state" varchar(20) NOT NULL,
	"postal_code" varchar(20) NULL,
	CONSTRAINT "geography_pk" PRIMARY KEY ("geo_id")
) WITH (
  OIDS=FALSE
);



--deleting rows
TRUNCATE TABLE dw.geography;



--generating geo_id and insert from stg.orders
INSERT INTO dw.geography
SELECT 100+row_number() OVER(), country, city, state, postal_code FROM (SELECT DISTINCT country, city, state, postal_code FROM stg.orders);



--data quality check
SELECT * FROM dw.geography
WHERE country IS NULL OR city IS NULL OR state IS NULL OR postal_code IS NULL;



--set postal_code for Burlington
UPDATE dw.geography
SET postal_code = '05401' WHERE city = 'Burlington';
UPDATE stg.orders 
SET postal_code = '05401' WHERE city = 'Burlington';



--postal_code for Burlington check
SELECT * FROM dw.geography WHERE city = 'Burlington';
SELECT * FROM stg.orders WHERE city = 'Burlington';



--product
DROP TABLE IF EXISTS dw.product;
CREATE TABLE IF NOT EXISTS dw.product (
	"product_id" serial NOT NULL,
	"category" varchar(15) NOT NULL,
	"subcategory" varchar(11) NOT NULL,
	"segment" varchar(11) NOT NULL,
	"product_name" varchar(127) NOT NULL,
	CONSTRAINT "product_pk" PRIMARY KEY ("product_id")
) WITH (
  OIDS=FALSE
);



--deleting rows
TRUNCATE TABLE dw.product;



--shipping
DROP TABLE IF EXISTS dw.shipping_dim;
CREATE TABLE IF NOT EXISTS dw.shipping_dim (
	"ship_id" serial NOT NULL,
	"shipping_mode" varchar(14) NOT NULL,
	CONSTRAINT "shipping_dim_pk" PRIMARY KEY ("ship_id")
) WITH (
  OIDS=FALSE
);



--deleting rows
TRUNCATE TABLE dw.shipping_dim;



--metrics
DROP TABLE IF EXISTS dw.sales_fact;
CREATE TABLE IF NOT EXISTS dw.sales_fact (
	"row_id" int4range NOT NULL,
	"order_id" varchar(14) NOT NULL,
	"sales" numeric(9, 4) NOT NULL,
	"quantitiy" int4range NOT NULL,
	"discount" numeric(4, 2) NOT NULL,
	"profit" numeric(21, 16) NOT NULL,
	"order_date" date NOT NULL,
	"geo_id" int NOT NULL,
	"product_id" int NOT NULL,
	"ship_id" int NOT NULL,
	"ship_date" date NOT NULL,
	CONSTRAINT "sales_fact_pk" PRIMARY KEY ("row_id")
) WITH (
  OIDS=FALSE
);



--add foreign keys
ALTER TABLE dw.sales_fact ADD CONSTRAINT "sales_fact_fk0" FOREIGN KEY ("order_date") REFERENCES dw.calendar("order_date");
ALTER TABLE dw.sales_fact ADD CONSTRAINT "sales_fact_fk1" FOREIGN KEY ("geo_id") REFERENCES dw.geography("geo_id");
ALTER TABLE dw.sales_fact ADD CONSTRAINT "sales_fact_fk2" FOREIGN KEY ("product_id") REFERENCES dw.product("product_id");
ALTER TABLE dw.sales_fact ADD CONSTRAINT "sales_fact_fk3" FOREIGN KEY ("ship_id") REFERENCES dw.shipping_dim("ship_id");
ALTER TABLE dw.sales_fact ADD CONSTRAINT "sales_fact_fk4" FOREIGN KEY ("ship_date") REFERENCES dw.calendar("ship_date");



--deleting rows
TRUNCATE TABLE dw.sales_fact;













