## Playstore Apps - SQL Data Analysis Case Study

# Overview

This case study explores the Playstore Apps data, derived from Kaggle, and cleaned using Python before loading into a MySQL Workbench. The data includes various details about apps on the Playstore, such as their category, rating, reviews, size, number of installs, type (free or paid), price, content rating, genres, last update, current version, and Android version.


# Key Insights
The case study attempts to answer several key questions using SQL queries, providing valuable insights for different roles such as a market analyst, a business strategist, a data analyst, a database administrator, and more.

# Schema
The database, named 'projects', contains a single table named 'playstore' with 9360 entries. The 'playstore' table includes the following columns:

. id (INT)

App (TEXT)

Category (TEXT)

Rating (DOUBLE)

Reviews (INT)

Size (TEXT)

Installs (INT)

Type (TEXT)

Price (DOUBLE)

Content Rating (TEXT)

Genres (TEXT)

Last Updated (TEXT)

Current Ver (TEXT)

Android Ver (TEXT)

Key Questions Answered
This study answers the following key questions:

Identify the top 5 categories for launching new free apps based on their average ratings.

Identify the three categories that generate the most revenue from paid apps.

Calculate the percentage of games within each category.

Recommend whether the company should develop paid or free apps for each category based on the ratings.

Implement a measure to record changes in app prices, useful in case of database hacks.

Restore correct data into the database after neutralizing the hacking threat.

Investigate the correlation between app ratings and the quantity of reviews.

Clean the genres column and split it into two genres for each row.

Create a tool that dynamically displays, for a given input category, the apps that have ratings lower than the average rating of that specific category.

Calculate the average adjusted rating for each category to adjust ratings based on the square root of the number of installations for apps in each category.

SQL Concepts Used
The project utilizes a variety of SQL concepts including:

CRUD operations: Used for data manipulation tasks such as creating a duplicate table, adding a new column, and updating data.

Joins: Used to combine rows from two or more intermediary tables.

CTEs (Common Table Expressions): Used to create temporary result sets that are referenced within another SQL statement.

Subqueries: Used to perform operations in a sequence or impose logic on a particular row of a table.

Stored Procedures: Used to encapsulate a series of SQL statements into a single procedure.

Triggers: Used to automatically record changes in the price of apps in a separate table when an update operation occurs in the playstore table.

User-defined functions: Created to calculate the adjusted rating of apps based on the square root of the number of installations, and to find the average adjusted rating for each category.

Requirements
SQL for data extraction and manipulation.

Python for initial data cleaning.

MySQL Workbench for data storage and manipulation.
