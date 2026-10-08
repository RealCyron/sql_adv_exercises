# Intermediate SQL Queries

This repository builds on the basics of SQL with techniques for writing more complex, more readable queries. You connect to a PostgreSQL database with DBeaver and practice `CASE WHEN`, subqueries, common table expressions, and window functions through worked examples and a set of hands-on exercises. The lessons query the `gapminder` schema, and the exercises query the `northwind` schema.

## Learning Objectives

By the end of this repository, you should be able to:

- Build new result columns from row-level conditions with `CASE WHEN`.
- Use subqueries in the `SELECT`, `FROM`, `WHERE`, and `HAVING` clauses.
- Refactor complex queries into readable Common Table Expressions (CTEs) with `WITH`.
- Apply window functions (aggregate, ranking, and value) using `PARTITION BY`, `ORDER BY`, and frame clauses.
- Choose between subqueries, CTEs, and window functions for a given problem.
- Analyze a real relational dataset (Northwind) end to end using these techniques.

## Learning Path

Work through the lessons in order. Each one builds on the previous.

| File / Folder                                                               | Description                                                                           |
| --------------------------------------------------------------------------- | ------------------------------------------------------------------------------------- |
| [**1 - CASE WHEN**](1_case_when.md)                                      | Conditional expressions that build new columns from row-level conditions.             |
| [**2 - Subqueries**](2_subqueries.md)                                    | Nested queries in the `SELECT`, `FROM`, `WHERE`, and `HAVING` clauses.        |
| [**3 - Common Table Expressions (CTEs)**](3_common_table_expressions.md) | Named temporary result sets with `WITH` for readable, reusable, multi-step queries. |
| [**4 - Window Functions**](4_window_functions.md)                        | Aggregate, ranking, and value functions over partitions and frames with `OVER()`.   |
| [**5 - Northwind Exercises**](5_northwind_exercises.md)                  | Hands-on practice: analysis questions to answer against the `northwind` schema.     |
| [**5 - Northwind Query Outputs**](5_northwind_exercises_query_outputs.md) | Expected outputs for the Northwind exercises to compare against your results.        |

### Additional Folders and Files

| File / Folder                                        | Description                                                               |
| ---------------------------------------------------- | ------------------------------------------------------------------------- |
| [**Database Connection**](database_connection.md) | How to connect DBeaver to the shared PostgreSQL database.                 |
| [**Assets**](assets/)                             | ER diagrams and example query-output screenshots used across the lessons. |
| [**Solutions**](solutions/)                       | Worked solutions to the Northwind exercises.                              |

## Setup

> [!NOTE]
> Throughout these steps, text in angle brackets like `<repo-name>` is a **placeholder**. Replace it, including the `< >` brackets, with your own value. For example, `cd <repo-name>` becomes `cd ds-sql-intermediate`.

### 1. Create the Repository from the Template

Click **Use this template** on GitHub.

When creating the repository:

- Set yourself as the **Owner**
- Choose a repository name
- Disable **Include all branches**
- Click **Create repository**

> [!IMPORTANT]
> If you are working in pairs or groups, only **one person** should complete this step.

---

### 2. Add Collaborators (Pairs/Groups Only)

If working with teammates:

1. Open the repository on GitHub
2. Go to **Settings → Collaborators**
3. Add your teammates as collaborators
4. Share the repository link with your team

Teammates should accept the invitation before continuing.

---

### 3. Clone the Repository

Copy the SSH URL from the **Code** button on GitHub, then run:

```bash
git clone <copied-ssh-url>
cd <repo-name>
```

The copied SSH URL will look like `git@github.com:<your-username>/<repo-name>.git`.

---

### 4. Connect to the Database

All queries run against a shared, AWS-hosted PostgreSQL database through DBeaver. Follow the [Database Connection guide](database_connection.md) to set up the connection and open your first SQL editor, then start with [1 - CASE WHEN](1_case_when.md).

## How to use this repo

1. Complete lessons 1-4 in order.
2. For each lesson, review the content and run the example queries against the database before moving on.
   3.After completing the lessons, workthrough the exercises by writing your own SQL queries for each question. Save your solutions in a `.sql` file, and compare your results against the expected outputs in [Northwind Query Outputs](5_northwind_exercises_query_outputs.md).

## References & Further Reading

- [PostgreSQL: Conditional Expressions](https://www.postgresql.org/docs/17/functions-conditional.html): Official reference for `CASE`, `COALESCE`, and `NULLIF`.
- [W3Schools: SQL CASE](https://www.w3schools.com/sql/sql_case.asp): Short, example-driven introduction to `CASE WHEN`.
- [PostgreSQL: Subquery Expressions](https://www.postgresql.org/docs/current/functions-subquery.html): Official reference for `EXISTS`, `IN`, `ANY`, and `ALL`.
- [w3resource: SQL Subqueries](https://www.w3resource.com/sql/subqueries/understanding-sql-subqueries.php): Walkthrough of subqueries with worked examples.
- [PostgreSQL: WITH Queries (CTEs)](https://www.postgresql.org/docs/17/queries-with.html): Official reference for common table expressions, including recursion.
- [Mastering Recursive CTEs in SQL](https://sqlpad.io/tutorial/mastering-recursive-ctes-in-sql-a-comprehensive-guide/): A deeper guide to recursive CTEs for hierarchical data.
- [PostgreSQL: Window Functions Tutorial](https://www.postgresql.org/docs/current/tutorial-window.html): Official introduction to the `OVER()` clause and partitions.
- [GeeksforGeeks: Window Functions in SQL](https://www.geeksforgeeks.org/window-functions-in-sql/): Examples of ranking and aggregate window functions.
- [PostgreSQL: Date/Time Functions](https://www.postgresql.org/docs/current/functions-datetime.html): Reference for `EXTRACT()` and related functions, useful for the exercises.
- [Gapminder: Download the Data](https://www.gapminder.org/data/): The public source of the life-expectancy and fertility data used in the lessons.
- [Kaggle: Advanced SQL](https://www.kaggle.com/learn/advanced-sql): A free, hands-on course covering joins and analytic (window) functions on real datasets.
- [ThoughtSpot: SQL Window Functions](https://www.thoughtspot.com/sql-tutorial/sql-window-functions): Window functions explained on a real bikeshare dataset.
