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
-- SELECT * FROM users INNER JOIN pwd ON users.usr_ID = pwd.FK_usr_ID;
-- SELECT change_password(10, 'newpwd', 'Wakanda_4ever', 'Wakanda_4ever');

CALL add_friend(1, 3); # Bob Marley(1) requests Janne Svensson(3)
CALL add_friend(1, 4); # Bob Marley(1) requests Erik Svensson(3)
CALL add_friend(5, 6); # Bruce Banner(1) requests Tony Stark(3)
CALL add_friend(8, 6); # Peter Parker(1) requests Tony Stark(3)
CALL add_friend(6, 10); # Tony Stark(1) requests T'Challa(3)
-- SELECT * FROM friend_request;
CALL accept_friend_request(3, 1); # Janne(3) accepts Bob(1)
CALL accept_friend_request(6, 5); # Tony Stark(6) requests Bruce Banner(5)
CALL accept_friend_request(6, 8); # Tony Stark(6) requests Peter Parker(8) 
CALL accept_friend_request(10, 6); #  T'Challa(10) requests Tony Stark(6)
-- SELECT * FROM usr_relations;
