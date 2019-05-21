# Parameters: ID of activity owner, activity title, start date, end date, activity permission, activity description, activity type (eg dinner, walk..)
# Returns: 3 if minimum parameters are not filled, 2 if owner already has an activity namend X, 1 if created.
# NOTE: Title, owner, start and end date and activity permission must not be empty.  
DROP FUNCTION IF EXISTS create_activity;
DELIMITER //
CREATE FUNCTION create_activity (act_owner INT(11), act_title VARCHAR(50), start_d VARCHAR(32), end_d VARCHAR(32),
									act_permis INT(11), act_desc VARCHAR(240), act_type VARCHAR(50))
RETURNS INT
NOT DETERMINISTIC
BEGIN
	DECLARE created INT;
    SET created = 3;
	IF (act_owner != '' AND act_title != '' AND start_d != '' AND end_d != '' AND act_permis != '')
    THEN
		 SET created = 2;
		IF NOT EXISTS(SELECT * FROM activity ac WHERE ac.activity_owner = act_owner AND ac.activity_title = act_title)
        THEN
			 SET created = 1;
			INSERT INTO activity (activity_owner, activity_desciption, activity_title, activity_start, activity_end, activity_created, activity_type, activity_permission) 
			VALUES (act_owner, act_desc, act_title, start_d, end_d, NOW(), act_type, act_permis);
		END IF;
    END IF;
  RETURN created;
END// DELIMITER ;