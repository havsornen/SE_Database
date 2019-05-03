# Parameters: users ID, ID of person to remove, action to take (1,2 or 3).
# Returns: 0 if Error, 1 if relations_type has changed, 2 if relation have been removed.
DROP FUNCTION IF EXISTS change_relation_status;
DELIMITER //
CREATE FUNCTION change_relation_status (whoAmI VARCHAR(255), to_remove VARCHAR(255), choice INT(11))
RETURNS INT
NOT DETERMINISTIC
  BEGIN
	DECLARE result INT(11);
    SET result = 0;
    
	  IF (choice = 2 OR choice = 1)
	  THEN
		SET result = 1;
		UPDATE usr_relations SET usr_relations.relations_type = choice 
			WHERE usr_relations.usr_1 = whoAmI AND usr_relations.usr_2 = to_remove 
            OR usr_relations.usr_2 = whoAmI AND usr_relations.usr_2 = to_remove;
	  ELSEIF (choice = 3)
	  THEN
		SET result = 2;
		DELETE FROM usr_relations 
        WHERE usr_relations.usr_1 = whoAmI AND usr_relations.usr_2 = to_remove 
        OR usr_relations.usr_2 = whoAmI AND usr_relations.usr_2 = to_remove; 
	  END IF;
      
	RETURN result;
  END //
DELIMITER ;