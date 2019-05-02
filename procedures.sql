# Disables "must name PK" to delete object
SET SQL_SAFE_UPDATES = 0;
USE grp_pro; 

# Checks if the email string exists in users table. Returns 1 for created and 0 for error.
# NOTE: Only checks if the email and pwd string is empty.
DROP FUNCTION IF EXISTS create_user;
DELIMITER //
CREATE FUNCTION create_user (mail VARCHAR(250), pwd VARCHAR(255), fName varchar(50), lName varchar(50), telNumber varchar(15))
RETURNS INT
NOT DETERMINISTIC
BEGIN
  DECLARE created INT;
  DECLARE get_usr_ID INT;
  SET created = 0;
  IF (mail IS NOT NULL AND pwd IS NOT NULL) 
    THEN
    IF NOT EXISTS(SELECT users.usr_email FROM users WHERE users.usr_email = mail)
    THEN
		INSERT INTO users (users.usr_email, users.usr_firstname, users.usr_lastname, users.usr_telnumber) VALUES (mail, fName, lName, telNumber);
		SET created = 1;
    END IF;
    IF (created = 1) 
    THEN
		SET get_usr_ID = (SELECT users.usr_ID FROM users WHERE users.usr_email = mail);
		INSERT INTO pwd(pwd.FK_usr_ID, pwd.usr_secret) VALUES (get_usr_ID, pwd);
    END IF;
  END IF;    
  RETURN created;
END// DELIMITER ;




# There are three different return values which are represented accordingly
# 1 = login OK, 2 = email does not exists, 3 = wrong password
DROP FUNCTION IF EXISTS login;
DELIMITER //
CREATE FUNCTION login (mail VARCHAR(250), pwd VARCHAR(255))
RETURNS INT
NOT DETERMINISTIC
BEGIN
	DECLARE return_message INT;
    DECLARE identifier INT;
    SET return_message = 2;
    IF EXISTS(SELECT users.usr_email FROM users WHERE usr_email = mail)
    THEN
		SET identifier = (SELECT users.usr_ID FROM users WHERE users.usr_email = mail);
        SET return_message = 3;
		IF (pwd = (SELECT pwd.usr_secret FROM pwd WHERE pwd.FK_usr_ID = identifier))
        THEN
			SET return_message = 1;
        END IF;
	END IF;
	RETURN return_message;
END// DELIMITER ;



# returns query with columns firstname and lastname
DROP PROCEDURE IF EXISTS search;
DELIMITER //
CREATE PROCEDURE search (toFind VARCHAR(255))
  BEGIN
    SELECT users.usr_firstname, users.usr_lastname FROM users WHERE users.usr_firstname = toFind OR users.usr_lastname = toFind;
  END //
DELIMITER ;



# whoAmI/Janne(1) requests toAdd/Bob(3)
# Checks if relations already exists (if it does they are either friends or someone have blocked the other)
# Checks if request already exists.
DROP PROCEDURE IF EXISTS add_friend;
DELIMITER //
CREATE PROCEDURE add_friend (whoAmI INT, toAdd INT)
  BEGIN
	IF NOT EXISTS (SELECT usr_relations.usr_1, usr_relations.usr_2
	FROM usr_relations WHERE usr_1 = whoAmI AND usr_2 = toAdd OR usr_2 = whoAmI AND usr_1 = toAdd)
	THEN
		IF NOT EXISTS(SELECT friend_request.requester, friend_request.requestie  
		FROM friend_request WHERE requestie = whoAmI AND requester = toAdd OR requestie = toAdd AND requester = whoAmI)
		THEN
			INSERT INTO friend_request (requester, requestie) VALUES (whoAmI, toAdd);
		END IF;
	END IF;    
  END //
DELIMITER ;


# Requestie (Bob/whoAmI) will accept requester (Janne/toAdd). ONLY Bob can accept!
# Then adds to usr_relations and removes from friend_request
DROP PROCEDURE IF EXISTS accept_friend_request;
DELIMITER //
CREATE PROCEDURE accept_friend_request (whoAmI VARCHAR(255), toAdd VARCHAR(255))
  BEGIN
  IF EXISTS(SELECT friend_request.requester, friend_request.requestie FROM friend_request 
  WHERE requestie = whoAmI AND requester = toAdd)
	THEN
		IF NOT EXISTS(SELECT * FROM usr_relations 
        WHERE usr_1 = whoAmI AND usr_2 = toAdd OR usr_1 = toAdd AND usr_2 = whoAmI)
			THEN
				INSERT INTO usr_relations (usr_1, usr_2, relations_type) VALUES (whoAmI, toAdd, 1);
				DELETE FROM friend_request WHERE friend_request.requestie = whoAmI AND friend_request.requester = toAdd;
        END IF;
   END IF;
  END //
DELIMITER ;



# Returns 1 if pwd changed, 2 if old password was not correct and 3 if new passwordcheck fails.
DROP FUNCTION IF EXISTS change_password;
DELIMITER //
CREATE FUNCTION change_password (whoAmI VARCHAR(255), old_pwd VARCHAR(255), new_pwd VARCHAR(255), new_pwd_check VARCHAR(255))
RETURNS INT
NOT DETERMINISTIC
BEGIN
	DECLARE return_message INT;
    SET return_message = 2;
    
	IF EXISTS (SELECT pwd.usr_secret FROM pwd WHERE pwd.FK_usr_ID = whoAmI AND pwd.usr_secret = old_pwd)
    THEN
		SET return_message = 3;
		IF (new_pwd = new_pwd_check)
        THEN
			UPDATE pwd SET usr_secret = new_pwd WHERE pwd.FK_usr_ID = whoAmI AND pwd.usr_secret = old_pwd;
            SET return_message = 1;
		END IF;
    END IF;
    
	RETURN return_message;
END// DELIMITER ;


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



# Returns: 3 if minimum parameters are not filled, 2 if owner already has an activity namend X, 1 if created.
# Title, owner, start and end date and activity permission must not be empty.  
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



# Returns: 3 if activity does not exist OR if non-activity owner tries to inv, 2 invitee is already invited, 1 if success.
# invitee == ID.
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


# Help function. Gets users friends emailaddress (can be used eg. for inviting to events)
DROP PROCEDURE IF EXISTS get_friend_mail;
DELIMITER //
CREATE PROCEDURE get_friend_mail (whoAmI VARCHAR(255))
  BEGIN
	 	SELECT usr_email AS FriendsMail 
    FROM users 
    WHERE usr_ID IN 
		(SELECT REPLACE(CONCAT(usr_1, usr_2), whoAmI, '') AS Friends 
		FROM usr_relations 
        WHERE usr_1 = whoAmI OR usr_2 = whoAmI);
  END //
DELIMITER ;


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


# Returns: 0 if Error, 1 if relations_type has changed, 2 if relation have been removed.
DROP FUNCTION IF EXISTS remove_friend;
DELIMITER //
CREATE FUNCTION remove_friend (whoAmI VARCHAR(255), to_remove VARCHAR(255), choice INT(11))
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



-- USE grp_pro; 