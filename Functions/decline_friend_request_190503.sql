# Parameters: users ID, ID of user to decline.
# users (whoAmI) will decline friend request from requester (toDecline).
DROP PROCEDURE IF EXISTS decline_friend_request;
DELIMITER //
CREATE PROCEDURE decline_friend_request (whoAmI VARCHAR(255), toDecline VARCHAR(255))
  BEGIN
  IF EXISTS(SELECT friend_request.requester, friend_request.requestie FROM friend_request 
  WHERE requestie = whoAmI AND requester = toDecline)
	THEN
		DELETE FROM friend_request WHERE friend_request.requestie = whoAmI AND friend_request.requester = toDecline;
   END IF;
  END //
DELIMITER ;