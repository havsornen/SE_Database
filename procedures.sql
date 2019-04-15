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

