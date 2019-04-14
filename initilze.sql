/*
	Database structure for SE webapp and app.
    Created by Casper (cabbex @ github).
    
    -- User password table will be created in a separate file and not get commited to github.

*/

USE grp_pro; -- ## Change before execution ## --

-- Drops all existing tables so the database structure get resteted. --
drop table if exists usr_relations;
drop table if exists activity_members;
drop table if exists activity_invitees;
drop table if exists public_feed;
drop table if exists private_feed;
drop table if exists friend_request;
drop table if exists activity;

drop table if exists users;




create table users(
    usr_email varchar(150) UNIQUE,
    usr_ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY, -- Auto kan bara vara pÃ¥ Keys. alltsÃ¥ Primary key.
    usr_firstname varchar(50),
    usr_lastname varchar(50),
    usr_telnumber varchar(15)
    -- FUTURE TODO: Create a table for pictue handling -- 
);

create table usr_relations(
    relation_id INT AUTO_INCREMENT PRIMARY KEY,
    usr_1 INT NOT NULL,
    usr_2 INT NOT NULL,
    relations_type ENUM('Vänner','Blockerad'),
    FOREIGN KEY (usr_1) REFERENCES users(usr_ID),
    FOREIGN KEY (usr_2) REFERENCES users(usr_ID)
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
    
    FOREIGN KEY (activity_owner) REFERENCES users(usr_ID)

);

create table activity_members(
    activity_ID INT,
    usr_ID INT,
    activity_member_type ENUM('Deltar', 'Deltar inte') NOT NULL,
    
    FOREIGN KEY (activity_ID) REFERENCES activity(activity_ID),
    FOREIGN KEY (usr_ID) REFERENCES users(usr_ID)
);

create table activity_invitees(
    invite_ID INT AUTO_INCREMENT PRIMARY KEY,
    activity_ID INT,
    usr_ID INT,
    
    FOREIGN KEY (activity_ID) REFERENCES activity(activity_ID),
    FOREIGN KEY (usr_ID) REFERENCES users(usr_ID)
    
);

create table private_feed(
    private_feed_ID INT AUTO_INCREMENT PRIMARY KEY,
    private_feed_contentID INT,
    private_feed_invitee INT,
    
    FOREIGN KEY (private_feed_invitee) REFERENCES users(usr_ID),
    FOREIGN KEY (private_feed_contentID) REFERENCES activity(activity_ID) -- Future TODO: Change when Status is implemented. -- 
);

create table public_feed(
    public_feed_ID INT AUTO_INCREMENT PRIMARY KEY,
    public_feed_contentID INT,
    public_feed_contentOwner INT,
    
    FOREIGN KEY (public_feed_contentID) REFERENCES activity(activity_ID), -- Future TODO: Change when Status is implemented. -- 
    FOREIGN KEY (public_feed_contentOwner) REFERENCES users(usr_ID)
);

create table friend_request(
    request_nr INT AUTO_INCREMENT PRIMARY KEY,
    requester INT NOT NULL,
    requestie INT NOT NULL,
    
    FOREIGN KEY (requester) REFERENCES users(usr_ID),
    FOREIGN KEY (requestie) REFERENCES users(usr_ID)
);