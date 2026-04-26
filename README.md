Olist E-Commerce Customer Analytics and Segmentation

Overview

This project presents a comprehensive SQL-based analytical framework built on the Olist e-commerce dataset. It focuses on extracting actionable customer insights through advanced segmentation techniques, including RFM analysis and customer lifecycle modeling.

The goal is to transform transactional data into meaningful business intelligence that supports customer retention strategies, segmentation, and long-term value analysis.

Project Objectives

1. Segment customers based on behavioral and monetary patterns
2. Analyze customer lifecycle stages and engagement levels
3. Identify high-value, loyal, and at-risk customers
4. Measure customer activity and retention trends over time
5. Build reusable SQL pipelines for customer analytics

Analytical Components

RFM Segmentation

RFM (Recency, Frequency, Monetary) analysis is implemented to evaluate customer value.

1. Recency is calculated as the number of days since the last purchase relative to a reference date
2. Frequency is defined as the number of distinct orders
3. Monetary value is computed as total customer spend including freight

Customers are scored on a scale of 1 to 5 for each dimension and combined into an RFM score.

Customer segments include:

1. Champion
2. Loyal
3. Recent Customer
4. Frequent but At-Risk
5. At-Risk
6. Others

This segmentation enables targeted marketing and prioritization of high-value customers.

2. Customer Lifecycle Segmentation

Customer lifecycle is modeled using purchase history and inactivity duration.

Key metrics:

1. First purchase date
2. Last purchase date
3. Total number of orders
4. Lifecycle duration (days between first and last purchase)
5. Days since last purchase

Customers are categorized into:

Customer Status

1. Active (recent engagement)
2. At Risk (moderate inactivity)
3. Churned (high inactivity)

Purchase Stage

1. New Customer (single purchase)
2. Early-Stage Customer (2–3 purchases)
3. Repeated Customer (multiple purchases)

This dual segmentation provides insight into both engagement level and maturity stage.

3. Aggregated Lifecycle Insights

The lifecycle segmentation is further aggregated to compute:

1. Customer distribution across lifecycle stages
2. Percentage composition within each stage
3. Average lifecycle duration
4. Average inactivity period

This allows for a structured understanding of customer retention and drop-off patterns.

4. Relational Schema and Sample Data

A supporting SQL script defines a normalized relational schema with:

1. Customer entities
2. Orders and order positions
3. Product catalog
4. Payment-related structures

It includes:

1. Primary and foreign key constraints
2. Sample transactional data
3. Referential integrity design

This demonstrates foundational database design and schema modeling skills.

Technical Implementation

The project is implemented entirely in SQL and demonstrates:

1. Multi-table joins across transactional datasets
2. Use of Common Table Expressions (CTEs) for modular query design
3. Windowing logic and aggregations
4. Time-based calculations using date functions
5. Conditional segmentation using CASE statements
6. Data transformation pipelines for analytics

File Structure

* `RFM.sql`
  Implements RFM metric calculation, scoring logic, and customer segmentation.

* `customer_lifecycle_cohort_segmentation.sql`
  Performs lifecycle analysis, inactivity tracking, and stage-based segmentation.

* `relational_schema_and_sample_data.sql`
  Defines a normalized schema with sample data and relational constraints.

Key Outcomes

1. Identification of high-value and loyal customer segments
2. Detection of churn risk based on inactivity thresholds
3. Structured lifecycle modeling for customer behavior analysis
4. Scalable SQL framework for customer analytics

Business Relevance

This project demonstrates how SQL can be used to derive actionable insights from raw data:

1. Enables targeted marketing strategies based on segmentation
2. Supports retention planning using lifecycle analysis
3. Identifies revenue-driving customer groups
4. Provides a foundation for customer lifetime value modeling

Tools and Technologies

1. SQL
2. Relational database systems (MySQL)
3. Analytical querying techniques

How to Use

1. Load the Olist dataset into a relational database system

2. Execute the SQL scripts in sequence:

   1. relational_schema_and_sample_data.sql
   2. RFM.sql
   3. customer_lifecycle_cohort_segmentation.sql

3. Review query outputs to analyze segmentation and lifecycle insights

Conclusion

This project highlights the application of SQL for advanced customer analytics in an e-commerce environment. It demonstrates how structured querying and segmentation techniques can provide meaningful insights into customer behavior, retention, and value.

