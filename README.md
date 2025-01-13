# Market-Basket-Analysis

Four key metrics were used to uncover relationships between products:
1.	Frequency: This determines the number of transactions where two products (Product1 and Product2) are purchased together. For instance, "whole milk" and "other vegetables" appeared together in 1,458 transactions.
2.	Support: The percentage of total transactions that include both Product1 and Product2. Calculated as:
Support = (Frequency of products 1 & 2 / Total number of transactions) * 100
Example: The support for "whole milk" and "other vegetables" is 3.76%, indicating that they appear together in 3.76% of all transactions.
3.	Confidence: Measures the likelihood that Product2 is purchased when Product1 has already been bought. Calculated as:
Confidence = (Frequency of both products / Frequency of the product on the LHS) * 100
Example: The confidence for "whole milk" and "other vegetables" is 58.27%, meaning customers who bought "whole milk" are 58.27% likely to also buy "other vegetables."
4.	Lift: Indicates how much more likely customers are to buy Product2 when Product1 is purchased compared to buying Product2 independently. Calculated as:
Lift = Support (Both Products) / (Support(Product1) * Support(Product2))
Example: The lift of 2.85 for "whole milk" and "other vegetables" suggests that buying "whole milk" increases the likelihood of buying "other vegetables" by 2.85 times compared to buying "other vegetables" independently.
