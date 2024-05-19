-- Dataset: Yelp Datset
-- Source: Coursera.org
-- Queried using SQLite



-- Part 1: Yelp Dataset Profiling and Understanding

/* Profiling the data by finding the total number of records for each of the tables and compared it with the total 
number of distinct values of each table's primary key or foreign key. */
SELECT COUNT(DISTINCT(business_id)), COUNT(*)
FROM  Attribute;

SELECT COUNT(DISTINCT(id)), COUNT(*)
FROM  Business;

SELECT COUNT(DISTINCT(business_id)), COUNT(*)
FROM  Category;

SELECT COUNT(DISTINCT(business_id)), COUNT(*)
FROM  Checkin;

SELECT COUNT(DISTINCT(user_id)), COUNT(*)
FROM  Elite_years;

SELECT COUNT(DISTINCT(user_id)), COUNT(*)
FROM  Friend;

SELECT COUNT(DISTINCT(business_id)), COUNT(*)
FROM  Hours;

SELECT COUNT(DISTINCT(id)), COUNT(*)
FROM  Photo;

SELECT COUNT(DISTINCT(id)), COUNT(*)
FROM  Review;

SELECT COUNT(DISTINCT(user_id)), COUNT(*)
FROM  Tip;

SELECT COUNT(DISTINCT(id)), COUNT(*)
FROM  User;

/* Reviewing the User table to determine if there are any NULL values */
SELECT
    SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS Name_Null_Count,
    SUM(CASE WHEN review_count IS NULL THEN 1 ELSE 0 END) AS Review_Count_Null_Count,
    SUM(CASE WHEN yelping_since IS NULL THEN 1 ELSE 0 END) AS Yelping_Since_Null_Count,
    SUM(CASE WHEN useful IS NULL THEN 1 ELSE 0 END) AS Useful_Null_Count,
    SUM(CASE WHEN funny IS NULL THEN 1 ELSE 0 END) AS Funny_Null_Count,
    SUM(CASE WHEN cool IS NULL THEN 1 ELSE 0 END) AS Fans_Null_Count,
    SUM(CASE WHEN fans IS NULL THEN 1 ELSE 0 END) AS Name_Null_Count,
    SUM(CASE WHEN average_stars IS NULL THEN 1 ELSE 0 END) AS Average_Stars_Null_Count,
    SUM(CASE WHEN compliment_hot IS NULL THEN 1 ELSE 0 END) AS Compliment_Hot_Null_Count,
    SUM(CASE WHEN compliment_more IS NULL THEN 1 ELSE 0 END) AS Compliment_More_Null_Count,
    SUM(CASE WHEN compliment_profile IS NULL THEN 1 ELSE 0 END) AS Compliment_Profile_Null_Count,
    SUM(CASE WHEN compliment_cute IS NULL THEN 1 ELSE 0 END) AS Compliment_Cute_Null_Count,
    SUM(CASE WHEN compliment_list IS NULL THEN 1 ELSE 0 END) AS Compliment_List_Null_Count,
    SUM(CASE WHEN compliment_note IS NULL THEN 1 ELSE 0 END) AS Compliment_Note_Null_Count,
    SUM(CASE WHEN compliment_plain IS NULL THEN 1 ELSE 0 END) AS Compliment_Plain_Null_Count,
    SUM(CASE WHEN compliment_cool IS NULL THEN 1 ELSE 0 END) AS Compliment_Cool_Null_Count,
    SUM(CASE WHEN compliment_funny IS NULL THEN 1 ELSE 0 END) AS Compliment_Funny_Null_Count,
    SUM(CASE WHEN compliment_writer IS NULL THEN 1 ELSE 0 END) AS Compliment_Writer_Null_Count,
    SUM(CASE WHEN compliment_photos IS NULL THEN 1 ELSE 0 END) AS Compliment_Photos_Null_Count
FROM User;

/* Determining the minimum, maximum and the mean values of various fields*/ 
SELECT MIN(Stars), MAX(Stars), AVG(STARS)
FROM Review;

SELECT MIN(Stars), MAX(Stars), AVG(STARS)
FROM Business;

SELECT MIN(Likes), MAX(Likes), AVG(Likes)
FROM Tip;

SELECT MIN(Count), MAX(Count), AVG(Count)
FROM Checkin;

SELECT MIN(Review_count), MAX(Review_count), AVG(Review_count)
FROM User;

/* The cities with the most reviews in descending order */
SELECT City, SUM(Review_count) AS "Number of Reviews"
FROM Business
GROUP BY City
ORDER BY "Number of Reviews" DESC;

/* The distribution of star ratings in the Business table for the cities Avon and Beachwood */
SELECT Stars AS Star_Rating, SUM(Review_count) AS Count
FROM Business
WHERE City = 'Avon'
GROUP BY Star_Rating;

SELECT Stars AS Star_Rating, SUM(Review_count) AS Count
FROM Business
WHERE City = 'Beachwood'
GROUP BY Star_Rating;

/* Finding the top 3 users based on their total number of reviews */
SELECT Name, Review_count
FROM User
ORDER BY Review_count DESC
LIMIT 3;

/* Does posing more reviews correlate with more fans? */
SELECT 
    Name, 
    Review_count,
    Id,
    Fans
FROM User
ORDER BY Review_count DESC;

/* Are there more reviews with the word "love" or with the word "hate"? */
SELECT COUNT(Text)
FROM Review
WHERE Text like '%love%';

SELECT COUNT(Text)
FROM Review
WHERE Text like '%hate%';

/* The top 10 users with the most fans */
SELECT 
    Name, 
    Fans
FROM User
ORDER BY Fans DESC
LIMIT 10;

/* Analyzing restaurants in Las Vegas and grouping those restaurants by their overall star rating. How do the restaurants with 2-3
stars compare to the restaurants with 4-5 stars? */

SELECT 
    CASE
        WHEN (Stars >= 4 AND Stars <= 5) THEN '4-5 Star Rating'
        WHEN (Stars >= 2 AND Stars <= 3) THEN '2-3 Star Rating'
    END AS Star_Rating,
    B.Review_count,
    B.City,
    C.Category,
    B.Name,
    H.Hours
FROM Business AS B
    INNER JOIN Category AS C ON B.Id = C.Business_id
    INNER JOIN Hours AS H ON B.Id = H.Business_id
WHERE City = 'Las Vegas' AND Category ='Restaurants' AND (Stars >= 2)
GROUP BY B.Stars, B.Name 
ORDER BY Stars DESC, hours DESC;

/* What differences are there between restaurants that are open and the ones that are closed? */
SELECT 
    CASE
        WHEN Is_Open = 1 THEN 'Open'
        WHEN Is_Open = 0 THEN 'Closed'
    END AS Is_Open,
    COUNT(DISTINCT(id)) AS Number_of_Businesses,
    ROUND(AVG(Stars), 2) AS Average_Stars,
    ROUND(AVG(Review_count), 2) AS Average_Review_Count,
    SUM(Review_count) AS Total_Review_Count
FROM Business
GROUP BY Is_Open;

/* How are users categorized by the number of fans they have? What are the average review count and the average rating for users in 
each fan category? How many reviews are marked as useful, funny, and cool for each fan category? */
SELECT 
    CASE
        WHEN U.Fans >0 AND U.Fans <=20 THEN '0-20 Fans'
        WHEN U.Fans >20 AND U.Fans <=40 THEN '21-40 Fans'
        WHEN U.Fans >40 AND U.Fans <=60 THEN '41-60 Fans'
        WHEN U.Fans >60 AND U.Fans <=80 THEN '61-80 Fans'
    END AS 'Distribution of Fans',
    ROUND(AVG(U.Review_Count),2) AS Average_Review_Count,
    ROUND(AVG(U.Average_Stars), 2) AS Average_of_Average_Stars,
    SUM(CASE WHEN R.Useful = 1 THEN 1 ELSE 0 END) AS Number_of_Useful_Reviews,
    SUM(CASE WHEN R.Funny = 1 THEN 1 ELSE 0 END) AS Number_of_Funny_Reviews,
    SUM(CASE WHEN R.Cool = 1 THEN 1 ELSE 0 END) AS Number_of_Cool_Reviews
FROM User AS U
INNER JOIN Review AS R ON U.Id = R.User_Id
GROUP BY 
    CASE
        WHEN U.Fans >0 AND U.Fans <=20 THEN '0-20 Fans'
        WHEN U.Fans >20 AND U.Fans <=40 THEN '21-40 Fans'
        WHEN U.Fans >40 AND U.Fans <=60 THEN '41-60 Fans'
        WHEN U.Fans >60 AND U.Fans <=80 THEN '61-80 Fans'
    END
