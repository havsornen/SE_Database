# Parameters: users ID and the person to add users ID
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