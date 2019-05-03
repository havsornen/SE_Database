# Parameter:  firstname OR lastname.
# returns query with columns firstname and lastname
DROP PROCEDURE IF EXISTS search;
DELIMITER //
CREATE PROCEDURE search (toFind VARCHAR(255))
  BEGIN
    SELECT users.usr_firstname, users.usr_lastname FROM users WHERE users.usr_firstname = toFind OR users.usr_lastname = toFind;
  END //
DELIMITER ;