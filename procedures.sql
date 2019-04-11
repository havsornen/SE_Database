# Disables "must name PK" to delete object
#SET SQL_SAFE_UPDATES = 0;

# Checks if the email string exists in users table. Returns 1 for created and 0 for error.
# NOTE: Only checks if the email string is empty.
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

SELECT create_user('bob@mail.com', 'ThisAPasswordYoCheckItOutBro', 'Bob', 'Marley', '1337101');
SELECT create_user('janne@mail.com', 'ThisIsNotAGoodPwd', 'Janne', 'Svensson', 'lol');

SELECT * FROM users, pwd;
#DELETE FROM users WHERE 1;


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

SELECT login('bob@mail.com', 'ThisAPasswordYoCheckItOutBro');



