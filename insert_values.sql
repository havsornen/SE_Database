SELECT create_user('bob@mail.com', 'ThisAPasswordYoCheckItOutBro', 'Bob', 'Marley', '1337101');
SELECT create_user('Robby@mail.com', 'password', 'Bobby', 'Snobb', '34733');
SELECT create_user('janne@mail.com', 'ThisIsNotAGoodPwd', 'Janne', 'Svensson', 'lol');
SELECT create_user('erik@mail.com', 'watDisIs?', 'erik', 'Svensson', '21229');

SELECT create_user('hulk@mail.com', 'HulkSmash', 'Bruce', 'Banner', '');
SELECT create_user('ironman@mail.com', 'Pepper<3', 'Tony', 'Stark', '101');
SELECT create_user('lordofthunder@mail.com', 'DoINeedThis?', 'Thor', 'Son of Odin', '');
SELECT create_user('spiderman@mail.com', '!Sup3rS3cr3t!', 'Peter', 'Parker', '291535');
SELECT create_user('antman@mail.com', 'itsMrAntToYou', 'Scott', 'Lang', '477');
SELECT create_user('blackpanter@mail.com', 'Wakanda_4ever', 'T', 'Challa', '21229');

SELECT create_user('headmaster@mail.com', 'Chocolatefrogs', 'Albus', 'Dumbledore', '1');
SELECT create_user('gryffindor@mail.com', 'Quidditch', 'Minerva', 'McGonagall', '2');
SELECT create_user('voldemort@mail.com', 'Horcruxes', 'Tom', 'Riddle', '7');
SELECT create_user('theboywholived@mail.com', 'Open_at_the_close', 'Harry', 'Potter', '2');
SELECT create_user('gamekeeper@mail.com', 'Fang', 'Rufus', 'Hagrid', '');
SELECT create_user('houseelf@mail.com', 'atyouservice', 'Dobby', '', '7');




SELECT * FROM users INNER JOIN pwd ON users.usr_ID = pwd.FK_usr_ID;

CALL add_friend(1, 3); # Bob Marley(1) requests Janne Svensson(3)
CALL add_friend(1, 4); # Bob Marley(1) requests Erik Svensson(3)
CALL add_friend(5, 6); # Bruce Banner(1) requests Tony Stark(3)
CALL add_friend(8, 6); # Peter Parker(1) requests Tony Stark(3)
CALL add_friend(6, 10); # Tony Stark(1) requests T'Challa(3)
CALL add_friend(11, 14); # Albus(11) requests Harry(14)
CALL add_friend(11, 12); # Albus(11) requests Minerva(12)
CALL add_friend(11, 15); # Albus(11) requests Dobby(15)
CALL add_friend(14, 12); # Harry(14) requests Minerva(12)
CALL add_friend(14, 15); # Harry(14) requests Dobby(15)
CALL add_friend(13, 14); # Tom(13) requests Harry(14)
-- SELECT * FROM friend_request;
CALL accept_friend_request(3, 1); # Janne(3) accepts Bob(1)
CALL accept_friend_request(6, 5); # Tony Stark(6) requests Bruce Banner(5)
CALL accept_friend_request(6, 8); # Tony Stark(6) requests Peter Parker(8) 
CALL accept_friend_request(10, 6); #  T'Challa(10) requests Tony Stark(6)
CALL accept_friend_request(14, 11); # Harry(14) accepts Albus(11)
CALL accept_friend_request(12, 11); # Minerva(12) accepts Albus(11)
CALL accept_friend_request(15, 11); # Dobby(15) accepts Albus(11)
CALL accept_friend_request(12, 14); # Minerva(12) accepts Harry(14)
CALL accept_friend_request(15, 14); # Dobby(15) accepts Harry(14)
SELECT * FROM usr_relations;
CALL view_friends(6);




SELECT create_activity(11, 'Hogsmeade', '2019-05-03 15:13:37', '2019-05-03 18:26:14', '1', '', '');
SELECT create_activity(11, 'Diagonally', '2019-05-03 15:13:37', '2019-05-03 18:26:14', '1', '', '');
SELECT * FROM activity;



SELECT add_invitee(12, 'Hogsmeade', 11);
SELECT add_invitee(14, 'Hogsmeade', 11);
SELECT add_invitee(15, 'Hogsmeade', 11);
SELECT add_invitee(15, 'Diagonally', 11);
