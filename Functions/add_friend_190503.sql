# Parameters: users ID and the person to add users ID
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