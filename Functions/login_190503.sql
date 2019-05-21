# Parameters: mail, password.
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