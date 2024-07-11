# Online-Retail-Sales-Analysis
Online Retail Sales Analysis with Sql

## Project Description
The objective was to analyze the sales data of an online retail company to gain insights into sales performance, customer behavior, and product trends. This analysis aimed to help the company make informed business decisions to enhance revenue and customer satisfaction.

## Process to Discover and Present Meaningful Insights

### Data Extraction and Cleaning
- **Initial Data View**: Selected all data to understand its structure and content.
- **Total Sales Calculation**: Added and updated a TotalSales column to quantify total revenue.
- **Duplicate Removal**: Identified and removed duplicate records to ensure data accuracy.
- **Incorrect Values Removal**: Visualized and removed rows with non-positive quantities and unit prices.

### Data Analysis
- **Trends Analysis**: Analyzed yearly, monthly, daily, and hourly sales trends to identify patterns.
- **Customer Analysis**: Updated missing CustomerID values and identified top customers.
- **Product Analysis**: Identified best-selling products while excluding non-product descriptions.
- **Geographic Analysis**: Analyzed sales distribution by country.
- **Repeat Customer and RFM Analysis**: Conducted RFM analysis to understand customer purchase behavior and identify top repeat customers.
- **Product Association Analysis**: Identified product pairs and triplets frequently bought together, normalizing product descriptions to remove adjectives.

### Key Insights

#### Monthly Trends
- Analysis revealed that **November 2011** was the peak month in terms of revenue generation, indicating a significant increase in sales possibly due to holiday shopping.
- In contrast, **February 2011** recorded the lowest revenue, which could suggest a post-holiday sales slump or other seasonal factors affecting consumer spending.

#### Weekly Trends
- The data showed that **Thursdays** were the most profitable day of the week, suggesting that mid-week sales promotions or shopping patterns contributed to higher sales.
- **Sundays** generated the least revenue, which might indicate lower consumer activity on weekends.

#### Hourly Trends
- The highest revenue was observed between **9 AM and 4 PM**, highlighting the prime shopping hours. This information is crucial for staffing and operational decisions, ensuring adequate resources are available during peak times to maximize sales.

#### Customer Analysis
- **Customer ID 14646** was identified as the top revenue generator, showcasing high purchase activity and possibly loyalty to the business.
- Additionally, the top five repeat customers, identified as **Customer IDs 14911, 17841, 12748, 14606, and 15311**, demonstrated consistent purchasing behavior, which is valuable for targeted marketing and retention strategies.

#### Product Analysis
- The **"REGENCY CAKESTAND 3 TIER"** emerged as the best-selling product, indicating high consumer demand and popularity.
- On the other hand, the **"HEN HOUSE W CHICK IN NEST"** was the least popular, suggesting it may need marketing adjustments or potential discontinuation.
- Products frequently associated with top repeat customers included items such as the **"POPCORN HOLDER," "WHITE HANGING HEART T-LIGHT HOLDER," "JUMBO BAG RED RETROSPOT," "BROCADE RING PURSE,"** and **"PACK OF 72 RETROSPOT CAKE CASES."** These associations provide insights into the preferences of loyal customers, which can be leveraged for personalized marketing and inventory stocking.

#### Geographic Analysis
- The **United Kingdom** was the highest revenue-generating country, emphasizing its key role in the business's market. This highlights the importance of focusing marketing efforts and resources in this region.
- Conversely, **Sweden** generated the least revenue, suggesting potential areas for market expansion or reevaluation of marketing strategies in that region.
