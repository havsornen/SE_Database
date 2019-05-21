# Paramter: users ID.
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