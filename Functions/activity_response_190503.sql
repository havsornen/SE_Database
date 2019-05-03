# Parameters: users ID, activity ID, response --> (1 for antending and 2 for not attending)
# Inserts or updates (depending on if a response has been made earlier) activity_members with the response that is given.
# If reponse is "Deltar inte" (enum 2) that row/usr will be removed in activity_invitees.
DROP PROCEDURE IF EXISTS activity_response;
DELIMITER //
CREATE PROCEDURE activity_response (whoAmI VARCHAR(255), activity INT(11), response INT(11))
  BEGIN
	IF NOT EXISTS (SELECT * FROM activity_members am WHERE am.usr_ID = whoAmI AND am.activity_ID = activity)
    THEN
		INSERT INTO activity_members (activity_ID, usr_ID, activity_member_type)
        VALUES (activity, whoAmI, response);
	ELSE
		UPDATE activity_members 
			SET  activity_member_type = response 
			WHERE activity_ID = activity AND usr_ID = whoAmI;
    END IF;
    
    IF (response = 2)
	THEN
		DELETE FROM activity_invitees WHERE activity_ID = activity AND usr_ID = whoAmI;
	END IF;    
  END //
DELIMITER ;