/*
	Database structure for SE webapp and app.
    Created by Casper (cabbex @ github).
    
    -- User password table will be created in a separate file and not get commited to github.

*/

USE test; -- ## Change before execution ## --

-- Drops all existing tables so the database structure get resteted. --
drop table if exists user_relations;
drop table if exists activity_members;
drop table if exists activity_invitees;
drop table if exists public_feed;
drop table if exists private_feed;
drop table if exists friend_request;
drop table if exists activity;
drop table if exists user;




create table user(
	user_email varchar(150) UNIQUE,
    user_ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY, -- Auto kan bara vara på Keys. alltså Primary key.
    user_firstname varchar(50),
    user_lastname varchar(50),
    user_telnumber varchar(15)
    -- FUTURE TODO: Create a table for pictue handling -- 
);

create table user_relations(
	relation_id INT AUTO_INCREMENT PRIMARY KEY,
    user_1 INT NOT NULL,
    user_2 INT NOT NULL,
    relations_type ENUM('Vänner','Blockerad'),
    
    FOREIGN KEY (user_1) REFERENCES user(user_ID),
    FOREIGN KEY (user_2) REFERENCES user(user_ID)

);

create table activity(
	activity_ID INT AUTO_INCREMENT PRIMARY KEY,
    activity_owner INT NOT NULL,
    activity_desciption varchar(240),
    activity_title varchar(50) NOT NULL,
    activity_start DATETIME NOT NULL,
    activity_end DATETIME,
    activity_type varchar(50),
    activity_permission ENUM('Inbjudna enbart', 'Vänner enbart', 'Alla välkommna') NOT NULL,
    
    FOREIGN KEY (activity_owner) REFERENCES user(user_ID)

);

create table activity_members(
	activity_ID INT,
    user_ID INT,
    activity_member_type ENUM('Deltar', 'Deltar inte') NOT NULL,
    
    FOREIGN KEY (activity_ID) REFERENCES activity(activity_ID),
    FOREIGN KEY (user_ID) REFERENCES user(user_ID)
);

create table activity_invitees(
	invite_ID INT AUTO_INCREMENT PRIMARY KEY,
    activity_ID INT,
    user_ID INT,
    
    FOREIGN KEY (activity_ID) REFERENCES activity(activity_ID),
    FOREIGN KEY (user_ID) REFERENCES user(user_ID)
    
);

create table private_feed(
	private_feed_ID INT AUTO_INCREMENT PRIMARY KEY,
    private_feed_contentID INT,
    private_feed_invitee INT,
    
    FOREIGN KEY (private_feed_invitee) REFERENCES user(user_ID),
    FOREIGN KEY (private_feed_contentID) REFERENCES activity(activity_ID) -- Future TODO: Change when Status is implemented. -- 
);

create table public_feed(
	public_feed_ID INT AUTO_INCREMENT PRIMARY KEY,
    public_feed_contentID INT,
    public_feed_contentOwner INT,
    
    FOREIGN KEY (public_feed_contentID) REFERENCES activity(activity_ID), -- Future TODO: Change when Status is implemented. -- 
    FOREIGN KEY (public_feed_contentOwner) REFERENCES user(user_ID)
);

create table friend_request(
	request_nr INT AUTO_INCREMENT PRIMARY KEY,
	requester INT NOT NULL,
	requestie INT NOT NULL,
    
    FOREIGN KEY (requester) REFERENCES user(user_ID),
    FOREIGN KEY (requestie) REFERENCES user(user_ID)
);