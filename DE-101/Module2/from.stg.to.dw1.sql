--create schema
CREATE SCHEMA IF NOT EXISTS dw;


--calendar
DROP TABLE IF EXISTS dw.calendar;
CREATE TABLE IF NOT EXISTS dw.calendar
(
  'order_date' DATE       NOT NULL,
  'ship_date'  DATE       NOT NULL,
  'year'       DATE      ,
  'quarter'    VARCHAR(5),
  'month'      INT       ,
  'week'       INT       ,
  'day'        INT       ,
  PRIMARY KEY ('order_date', 'ship_date')
);


--deleting rows
TRUNCATE TABLE dw.calendar;


--generating geo_id and insert from stg.orders
insert into dw.calendar 
select order_date, ship_date, 'year', 'quarter', 'month', 'week', 'day' from (select distinct order_date, ship_date, 'year', 'quarter', 'month', 'week', 'day' from stg.orders);


--data check quality
select * from dw.calendar c 


--geography
DROP TABLE IF EXISTS dw.geography;
CREATE TABLE IF NOT EXISTS  dw.geography
(
  "geo_id"      INT         NOT NULL,
  "country"     VARCHAR(13),
  "city"        VARCHAR(17),
  "state"       VARCHAR(11),
  "region"      VARCHAR(7) ,
  "postal_code" INT        ,
  PRIMARY KEY ("geo_id")
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
CREATE TABLE IF NOT EXISTS dw.product
(
  "product_id"   INT          NOT NULL,
  "category"     VARCHAR(15) ,
  "subcategory"  VARCHAR(11) ,
  "segment"      VARCHAR(11) ,
  "product_name" VARCHAR(127),
  PRIMARY KEY ("product_id")
);


--deleting rows
TRUNCATE TABLE dw.product;


--shipping
DROP TABLE IF EXISTS dw.shipping;
CREATE TABLE IF NOT EXISTS dw.shipping
(
  "ship_id"   INT         NOT NULL,
  "ship_mode" VARCHAR(14),
  PRIMARY KEY ("ship_id")
);


--deleting rows
TRUNCATE TABLE dw.shipping;


--metrics
DROP TABLE IF EXISTS dw.sales;
CREATE TABLE IF NOT EXISTS dw.sales
(
  "row_id"     INT             NOT NULL,
  "order_id"   VARCHAR(14)    ,
  "quantity"   INT            ,
  "disount"    NUMERIC(4, 2)  ,
  "profit"     NUMERIC(21, 16),
  "sales"      NUMERIC(9, 4)  ,
  "geo_id"     INT             NOT NULL,
  "order_date" DATE            NOT NULL,
  "ship_date"  DATE            NOT NULL,
  "ship_id"    INT             NOT NULL,
  "product_id" INT             NOT NULL,
  PRIMARY KEY ("row_id")
);


--deleting rows
TRUNCATE TABLE dw.sales;


--add foreign keys
ALTER TABLE sales
  ADD CONSTRAINT FK_geography_TO_sales
    FOREIGN KEY (geo_id)
    REFERENCES geography (geo_id);

ALTER TABLE sales
  ADD CONSTRAINT FK_shipping_TO_sales
    FOREIGN KEY (ship_id)
    REFERENCES shipping (ship_id);

ALTER TABLE sales
  ADD CONSTRAINT FK_product_TO_sales
    FOREIGN KEY (product_id)
    REFERENCES product (product_id);

ALTER TABLE sales
  ADD CONSTRAINT FK_calendar_TO_sales
    FOREIGN KEY (order_date, ship_date)
    REFERENCES calendar (order_date, ship_date);


















