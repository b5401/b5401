DROP TABLE IF EXISTS superstore.people;
CREATE TABLE IF NOT EXISTS superstore.people(
   Person VARCHAR(17) NOT NULL PRIMARY KEY
  ,Region VARCHAR(7) NOT NULL
);
INSERT INTO superstore.orders(Person,Region) VALUES ('Anna Andreadi','West');
INSERT INTO superstore.orders(Person,Region) VALUES ('Chuck Magee','East');
INSERT INTO superstore.orders(Person,Region) VALUES ('Kelly Williams','Central');
INSERT INTO superstore.orders(Person,Region) VALUES ('Cassandra Brandow','South');
