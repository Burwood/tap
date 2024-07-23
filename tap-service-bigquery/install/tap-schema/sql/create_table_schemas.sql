CREATE DATABASE tap_schema;

CREATE SCHEMA tap_schema;

CREATE TABLE columns11
(
  table_name VARCHAR NOT NULL,
  column_name VARCHAR NOT NULL,
  utype VARCHAR,
  ucd VARCHAR,
  unit VARCHAR,
  description VARCHAR,
  datatype VARCHAR NOT NULL,
  arraysize VARCHAR,
  xtype VARCHAR,
  size BIGINT,
  principal BIGINT NOT NULL,
  indexed BIGINT NOT NULL,
  std BIGINT NOT NULL,
  column_index BIGINT,
  id VARCHAR,
  owner_id VARCHAR,
  read_anon BIGINT,
  read_only_group VARCHAR,
  read_write_group VARCHAR
);

ALTER TABLE columns11 SET SCHEMA tap_schema;

CREATE TABLE KeyValue
(
  name VARCHAR NOT NULL,
  value VARCHAR NOT NULL,
  lastModified TIMESTAMP NOT NULL
);

ALTER TABLE KeyValue SET SCHEMA tap_schema;

CREATE TABLE Modelversion
(
  model VARCHAR NOT NULL,
  version VARCHAR NOT NULL,
  lastModified TIMESTAMP NOT NULL
);

ALTER TABLE Modelversion SET SCHEMA tap_schema;

CREATE TABLE schemas11
(
  schema_name VARCHAR,
  utype VARCHAR,
  description VARCHAR,
  schema_index BIGINT,
  owner_id VARCHAR,
  read_anon BIGINT,
  read_only_group VARCHAR,
  read_write_group VARCHAR
);

ALTER TABLE schemas11 SET SCHEMA tap_schema;

	
CREATE TABLE keys11
(
  key_id VARCHAR NOT NULL,
  from_table VARCHAR NOT NULL,
  target_table VARCHAR NOT NULL,
  utype VARCHAR,
  description VARCHAR
);

ALTER TABLE keys11 SET SCHEMA tap_schema;

CREATE TABLE key_columns11
(
  key_id VARCHAR NOT NULL,
  from_column VARCHAR NOT NULL,
  target_column VARCHAR NOT NULL
);

ALTER TABLE key_columns11 SET SCHEMA tap_schema;

CREATE TABLE tables11
(
  schema_name VARCHAR NOT NULL,
  table_name VARCHAR NOT NULL,
  table_type VARCHAR NOT NULL,
  utype VARCHAR,
  description VARCHAR,
  table_index BIGINT,
  owner_id VARCHAR,
  read_anon BIGINT,
  read_only_group VARCHAR,
  read_write_group VARCHAR
);


ALTER TABLE tables11 SET SCHEMA tap_schema;