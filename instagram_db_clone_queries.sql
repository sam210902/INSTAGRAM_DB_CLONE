-- A)Questions asked by marketing team

/*1.Rewarding Most Loyal Users: People who have been using the platform for the longest time.
Your Task: Find the 5 oldest users of the Instagram from the database provided*/

SELECT 
    username
FROM
    users
ORDER BY created_at
LIMIT 5;

/*2.Remind Inactive Users to Start Posting: By sending them promotional emails to post their 1st photo.
Your Task: Find the users who have never posted a single photo on Instagram*/

SELECT 
    u.username, u.id
FROM
    users u
        LEFT JOIN
    photos p ON u.id = p.user_id
WHERE
    p.image_url IS NULL; 
    
    
/*3.Declaring Contest Winner: The team started a contest and the user who gets the most likes on a single photo will win the contest 
now they wish to declare the winner.
Your Task: Identify the winner of the contest and provide their details to the team*/

with total_like as(
SELECT 
    p.user_id, p.id,p.image_url, COUNT(p.id) AS total_likes
FROM
    photos p
        JOIN
    likes l ON p.id = l.photo_id
GROUP BY p.id
ORDER BY total_likes DESC)

select u.username,u.id as user_id,tl.image_url,tl.id as photo_id,tl.total_likes from users u 
inner join total_like tl on tl.user_id=u.id order by total_likes desc limit 1;


/*4.Hashtag Researching: A partner brand wants to know, which hashtags to use in the post to reach the most people on the platform.
Your Task: Identify and suggest the top 5 most commonly used hashtags on the platform*/

SELECT 
    t.tag_name,
    COUNT(t.tag_name) AS total_number_of_uses,
    t.id AS tag_id
FROM
    tags t
        JOIN
    photo_tags pt ON t.id = pt.tag_id
GROUP BY t.tag_name
ORDER BY total_number_of_uses DESC
LIMIT 5;

/*5.Launch AD Campaign: The team wants to know, which day would be the best day to launch ADs.
Your Task: What day of the week do most users register on? Provide insights on when to schedule an ad campaign*/

SELECT 
    DAYNAME(DATE(created_at)) AS day_name,
    COUNT(DAYNAME(DATE(created_at))) AS day_count
FROM
    users
GROUP BY DAYNAME(DATE(created_at))
ORDER BY day_count DESC; 


-- B)Questioins asked by investor metrics team.

/*1.User Engagement: Are users still as active and post on Instagram or they are making fewer posts
Your Task: Provide how many times does average user posts on Instagram. Also, provide the total number of photos on 
Instagram/total number of users*/

SELECT 
    FLOOR((COUNT(id) / (SELECT 
                    COUNT(id) AS total_user
                FROM
                    users))) AS number_of_posts_by_an_average_user,
    COUNT(id) / (SELECT 
            COUNT(id) AS total_user
        FROM
            users) AS total_photos_per_user
FROM
    photos;
    
    
/*2.Bots & Fake Accounts: The investors want to know if the platform is crowded with fake and dummy accounts
Your Task: Provide data on users (bots) who have liked every single photo on the site (since any normal user would not be able 
to do this).*/

SELECT 
    u.id AS user_id,
    u.username,
    COUNT(l.photo_id) AS liked_photos
FROM
    users u
        JOIN
    likes l ON u.id = l.user_id
GROUP BY u.id
HAVING liked_photos = (SELECT 
        COUNT(*)
    FROM
        photos)
ORDER BY u.id;

