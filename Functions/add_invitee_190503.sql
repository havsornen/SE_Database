# Parameters: the ID of the invitee, title of activity, ID of activity owner
# Returns: 3 if activity does not exist OR if non-activity owner tries to inv, 2 invitee is already invited, 1 if success.
DROP FUNCTION IF EXISTS add_invitee;
DELIMITER //
CREATE FUNCTION add_invitee (invitee INT(11), title VARCHAR(50), act_owner INT(11))
RETURNS INT
NOT DETERMINISTIC
BEGIN
	DECLARE created INT;
	DECLARE act_ID INT(11);
    SET created = 3;
    SET act_ID = (SELECT ac.activity_ID FROM activity ac WHERE ac.activity_owner = act_owner AND ac.activity_title = title);
    
    IF NOT (act_ID IS NULL)
    THEN
		SET created = 2;
		IF NOT EXISTS (SELECT * FROM activity_invitees inv WHERE inv.activity_ID = act_ID AND inv.usr_ID = invitee)
        THEN
			SET created = 1;
			INSERT INTO activity_invitees (activity_ID, usr_ID) VALUES (act_ID, invitee); 
        END IF;
    END IF;
  RETURN created;
END// DELIMITER ;