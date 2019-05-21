# Parameter: users ID
# A list of users friends will be shown
DROP PROCEDURE IF EXISTS view_friends;
DELIMITER //
CREATE PROCEDURE view_friends (whoAmI VARCHAR(255))
  BEGIN
	SELECT CONCAT(usr_firstname, " ",usr_lastname) AS Friends 
    FROM users 
    WHERE usr_ID IN 
		(SELECT REPLACE(CONCAT(usr_1, usr_2), whoAmI, '') AS Friends 
		FROM usr_relations 
        WHERE usr_1 = whoAmI OR usr_2 = whoAmI);
  END //
DELIMITER ;