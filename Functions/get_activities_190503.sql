# Parameter: ID of user.
# put usr_ID in parameter and both non accepted and accepted events will be displayed.
DROP PROCEDURE IF EXISTS get_activities;
DELIMITER //
CREATE PROCEDURE get_activities (whoAmI VARCHAR(255))
  BEGIN
    SELECT * FROM activity ac 
    WHERE ac.activity_ID IN 
		(SELECT ai.activity_ID FROM activity_invitees ai 
		WHERE usr_ID = whoAmI);
  END //
DELIMITER ;