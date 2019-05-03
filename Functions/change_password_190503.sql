# Parameters: user ID, old password, new password, new password (again).
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