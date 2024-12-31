# French Bakery Sales Analysis  

**Project Title:** Retail Sales Analysis  
**Tools:** MS SQL Server, Microsoft SQL Server Management Studio (SSMS)  
**Database:** Bakery_db  
**Dataset Source:** [French Bakery Daily Sales](https://www.kaggle.com/datasets/matthieugimbert/french-bakery-daily-sales)

## Project Description  
This project focuses on analyzing the daily sales of a French bakery to uncover actionable business insights. By leveraging SQL, the project includes setting up a database, cleaning and preparing the dataset, and conducting exploratory data analysis (EDA) to evaluate the bakery's sales performance. It aims to identify customer preferences, sales trends, and areas for improvement, providing data-driven recommendations to optimize business operations and support the bakery's growth.  

---

## Objectives  
1. **Database Setup**  
   - Establish a structured environment for the bakery's sales data.  
   - Set up the database and tables for efficient data storage and retrieval.  

2. **Data Cleaning**  
   - Ensure data quality and consistency by removing errors and irrelevant information.  

3. **Exploratory Data Analysis (EDA)**  
   - Analyze sales performance to uncover patterns, trends, and areas for optimization.  

4. **Business Insights & Recommendations**  
   - Provide actionable strategies to improve sales and enhance operational efficiency.  

---

## Project Structure  

### 1. Database Setup  
- **Database Creation:** Created a database named `Bakery_db`.  
- **Table Creation:** Set up a table named `Bakery_Sales` to store the dataset.  
- **Data Import:** Imported the dataset from a `.csv` file into the database for analysis.  

---

### 2. Data Preparation  
- **Remove Unnecessary Columns:** Excluded irrelevant columns like `Column 1` for streamlined analysis.  
- **Rename Columns:** Renamed columns such as `Quantity` and `Article` for clarity and uniformity.  
- **Remove Null Values:** Verified that the dataset contained no null values.  
- **Eliminate Duplicates:** Removed duplicate records to ensure data accuracy.  
- **Filter Irrelevant Records:** Excluded non-bakery-related items to maintain dataset relevance.  
- **Handle Negative Values:** Removed records with invalid negative values.  
- **Clean Characters:** Addressed unnecessary characters in text fields.  
- **Standardize Text Cases:** Ensured consistency in text format (e.g., uppercase/lowercase).  
- **Adjust Data Types:** Updated column data types as required for analysis.  
- **Create New Columns:** Added columns to enhance insights, such as revenue calculations.  

---

### 3. Exploratory Data Analysis  

#### A. Sales Performance  
1. **Top-Performing Products (Revenue):**  
   - Identified products generating the highest revenue.  
   - Insight: The traditional baguette leads revenue with 4x more than the second-ranked item.  

2. **Top-Performing Products (Quantity):**  
   - Highlighted the most purchased items.  
   - Insight: Traditional baguette also leads in sales volume, with nearly 3x the second-ranked product.  

3. **Least-Performing Products (Revenue):**  
   - Highlighted items contributing the least revenue.  
   - Insight: Products like Pain Noir and Trois Chocolat underperform significantly.  

4. **Sales by Category:**  
   - Analyzed contributions by product categories (e.g., bread, pastries, beverages).  
   - Insight: Bread and pastries dominate, while beverages contribute the least.  

5. **Sales by Year:**  
   - Tracked revenue growth year-over-year.  
   - Insight: A 2.62% sales increase from 2021 to 2022 (January to September) suggests strong growth.  

6. **Peak Category Performance (Time of Day):**  
   - Evaluated top-performing categories during morning, afternoon, and evening.  
   - Insight: Bread dominates mornings and evenings; pastries excel in the afternoon.  

7. **Seasonal Performance:**  
   - Assessed sales trends across different seasons.  
   - Insight: Bread and pastries consistently perform well throughout the year.  

---

#### B. Time-Based Trends  
1. **Customer Traffic by Day of the Week:**  
   - Insight: Weekends, especially Sunday, experience peak traffic.  

2. **Customer Traffic by Time of Day:**  
   - Insight: Mornings (8 AM–12 PM) have the highest traffic, with a significant drop in the evening.  

3. **Customer Traffic by Hour:**  
   - Insight: Peak hours are 10 AM–11 AM, aligning with the morning rush.  

---

#### C. Cross-Selling Opportunities  
- **High Co-occurrence Products:**  
   - Croissants and Pain au Chocolat frequently bought together.  
   - Insight: Bundling these products can increase average order value.  

- **Product Pairings:**  
   - Traditional baguette often paired with coupe and croissants.  

---

#### D. Customer Behavior  
- **Average Purchase Per Customer:**  
   - Insight: Customers purchase an average of 2 items per transaction, indicating potential for upselling.  

---

## Recommendations  

1. **Promote Best-Selling Products:**  
   - Focus on the traditional baguette with bundle deals and increased visibility.  

2. **Address Underperforming Products:**  
   - Reassess or rebrand low-performing items like Pain Noir and Trois Chocolat.  

3. **Enhance Product Categories:**  
   - Expand bread and pastry offerings with seasonal or limited-edition items.  

4. **Boost Beverage Sales:**  
   - Introduce complementary beverage options and promotions.  

5. **Leverage Seasonal Trends:**  
   - Create seasonal promotions to capitalize on customer interest.  

6. **Optimize Staffing:**  
   - Adjust schedules to align with peak traffic patterns (e.g., weekends and mornings).  

7. **Encourage Additional Purchases:**  
   - Offer bundle deals, loyalty programs, and upselling strategies at checkout.  

---

## Tools Used  
- **Database Management:** Microsoft SQL Server (MSSQL)  
- **Data Analysis:** SQL  

---

## Key Insights  
- Bread and pastries dominate sales performance.  
- Traditional baguette leads in revenue and sales volume.  
- Weekends and mornings see the highest customer traffic.  
- Cross-selling opportunities exist among commonly paired items.  

---

## Conclusion  
This project demonstrates the practical application of SQL for analyzing retail data in a real-world context. By combining database setup, data cleaning, and EDA, it provides valuable insights into bakery operations. These findings enable data-driven decision-making to enhance business performance and support sustainable growth.  
