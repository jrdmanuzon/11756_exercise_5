-- Create the child table if it doesn't exist
CREATE TABLE IF NOT EXISTS child(
	child_id INT AUTO_INCREMENT PRIMARY KEY,
	child_name VARCHAR(100), 
	child_surname1 VARCHAR(100),
	child_surname2 VARCHAR(100),
	parent_id INT,
	FOREIGN KEY (parent_id) REFERENCES parent(parent_id)    
);
-- Create the parent table if it doesn't exist
CREATE TABLE IF NOT EXISTS parent(
	parent_id INT AUTO_INCREMENT PRIMARY KEY,
	father_name VARCHAR(100), 
	father_surname1 VARCHAR(100),
	father_surname2 VARCHAR(100),
	mother_name VARCHAR(100), 
	mother_surname1 VARCHAR(100),
	mother_surname2 VARCHAR(100)
);

DELIMITER //
CREATE PROCEDURE SplitTableParentChild()
BEGIN
	DECLARE locid INT;
	DECLARE locname, localter, locsurname1, locsurname2 VARCHAR(100);
	DECLARE locfathername, locfathersurname1, locfathersurname2 VARCHAR(100);
	DECLARE locmothername, locmothersurname1, locmothersurname2 VARCHAR(100);
	DECLARE locfather_grandfather, locfather_grandmother VARCHAR(100);
	DECLARE locmother_grandfather, locmother_grandmother VARCHAR(100);
	
	DECLARE parent_id INT;
	DECLARE grandparent_father_id INT;
	DECLARE grandparent_mother_id INT;

	DECLARE curr CURSOR FOR SELECT * FROM people;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
	
	OPEN curr;
	
	read_loop: LOOP
		FETCH curr INTO
			locid, locgender, locname, localter, locsurnamel, locsurname2, locbirth,
			locfathername, locfathersurname1, locfathersurname2, 
			locmothername, locmothersurname1, locmothersurname2, 
			locfather_grandfather, locfather_grandmother,
			locmother_grandfather, locmother_grandmother, locfullname;

		IF done THEN
			LEAVE read_loop;
		END IF;

		--CHILD
		-- Insert rows into parent table
		INSERT INTO parent(
			father_name, father_surname1, father_surname2,
			mother_name, mother_surname1, mother_surname2
		)
		VALUES(
			locfathername, locfathersurname1, locfathersurname2, 
			locmothername, locmothersurname1, locmothersurname2 
		);  
		SET parent_id = LAST_INSERT_ID();

		-- Insert rows into child table
		INSERT INTO child(
			child_name, child_surname1, child_surname2,
			parent_id
		)
		VALUES(
			locname, Locsurnamel, locsurname2, parent_id
		);  



		-- PARENT table for grandparents
		-- Insert father's parent
		INSERT INTO parent(
			father_name, mother_name
		)
		VALUES(
			locfather_grandfather, locfather_grandmother
		);  
		SET grandparent_father_id = LAST_INSERT_ID();

		-- Insert mother's parent
		INSERT INTO parent(
			father_name, mother_name
		)
		VALUES(
			locmother_grandfather, locmother_grandmother
		);  
		SET grandparent_mother_id = LAST_INSERT_ID();


		-- CHILD table for parents
		-- Insert father into child table
		INSERT INTO child(
			child_name, child_surname1, child_surname2,
			parent_id
		)
		VALUES(
			locfathername, Locfathersurnamel, locfathersurname2, grandparent_father_id
		); 

		-- Insert mother into child table
		INSERT INTO child(
			child_name, child_surname1, child_surname2,
			parent_id
		)
		VALUES(
			locmothername, Locmothersurnamel, locmothersurname2, grandparent_mother_id
		); 
	END LOOP;

	CLOSE curr;
END //

DELIMITER ;

-- Call the procedure for splitting parent and children
CALL SplitTableParentChild()