-- Удаляем старые схемы, если они есть, чтобы избежать конфликтов (CASCADE удалит и таблицы внутри)
DROP SCHEMA IF EXISTS native CASCADE;
DROP SCHEMA IF EXISTS cdm CASCADE;

-- Создаем схемы заново
CREATE SCHEMA native;
CREATE SCHEMA cdm;

COMMENT ON SCHEMA native IS 'Raw synthetic data from Synthea generator';
COMMENT ON SCHEMA cdm IS 'Standardized clinical data in OMOP CDM v5.4';