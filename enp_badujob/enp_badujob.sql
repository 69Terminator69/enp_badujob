INSERT INTO `addon_account` (name, label, shared) VALUES
	('society_badu', 'Tendero', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES
	('society_badu', 'Tendero', 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
	('society_badu', 'Tendero', 1)
;

INSERT INTO `jobs` (name, label) VALUES
	('badu','Tendero')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('badu',0,'empleado','Reponedor',20,'{}','{}'),
	('badu',1,'empleado','Cajero',40,'{}','{}'),
	('badu',2,'empleado','Encargado',60,'{}','{}'),
	('badu',3,'boss','Dueño',85,'{}','{}')
;
