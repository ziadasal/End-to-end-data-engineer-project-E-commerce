# Data Analysis README

## 1) Peak Season Analysis

### Seasons

```sql
-- Peak season analysis for seasons
WITH Seasons_Sales AS (
    SELECT Season, SUM(price*quantity) Sales, COUNT(FactOrder.order_id) Number_of_orders
    FROM FactOrder
    JOIN DimDate ON [Order_date (FK)] = DimDate.Date
    GROUP BY Season
)
SELECT *
FROM Seasons_Sales
ORDER BY Sales DESC;
```
| Season | Sales | Number_of_orders |
| --- | --- | --- |
| Spring | 4444291440 | 32394 |
| Summer | 3854436330 | 29730 |
| Winter | 3351528780 | 26269 |
| Fall | 2589286770 | 19703 |
| Unknown | 0 | 830 |

### Months

```sql
-- Peak season analysis for months
WITH Months_Sales AS (
    SELECT month, SUM(price*quantity) Sales, COUNT(FactOrder.order_id) Number_of_orders
    FROM FactOrder
    JOIN DimDate ON [Order_date (FK)] = DimDate.Date
    GROUP BY month
)
SELECT *
FROM Months_Sales
ORDER BY Sales DESC;
```

| month | Sales | Number_of_orders |
| --- | --- | --- |
|5 |1579696180 |11516
|8 |1488480540 |11738
|7 |1461364050 |11253
|3 |1424794090 |10706
|4 |1423211610 |10169
|6 |1364614860 |10248
|2 |1145619720 |9131
|1 |1117440820 |8798
|11 |1050601850 |8245
|12 |772257410 |6133
|10 |746515260 |5450
|9 |664946930 |4709
|0 |0 |830

The peak season is **Spring**.

The peak month is **May**.

## 2) Order Timing Analysis

```sql
-- Order timing analysis
WITH times_Sales AS (
    SELECT Hour, [Meridiem], [Time of Day], COUNT(FactOrder.order_id) Number_of_orders
    FROM FactOrder
    JOIN DimTime ON [Order_Time (FK)] = DimTime.TimeOnly
    GROUP BY Hour, [Meridiem], [Time of Day]
)
SELECT *
FROM times_Sales
ORDER BY Number_of_orders DESC;
```


| Hour | Meridiem | Time of Day | Number_of_orders |
| --- | --- | --- | --- |
| 16 | PM | Afternoon | 7247
|14 | PM | Afternoon | 7155
|11 | AM | Morning | 7127
|13 | PM | Afternoon | 7069
|15 | PM | Afternoon | 6965
|21 | PM | Evening | 6765
|20 | PM | Evening | 6748
|10 | AM | Morning | 6670
|17 | PM | Afternoon | 6661
|12 | PM | Afternoon | 6571
|19 | PM | Evening | 6474
|22 | PM | Evening | 6418
|18 | PM | Evening | 6316
|9 | AM | Morning | 5147
|23 | PM | Evening | 4524
|0 | AM | Morning | 3480
|8 | AM | Morning | 3188
|7 | AM | Morning | 1312
|1 | AM | Morning | 1266
|2 | AM | Morning | 565
|6 | AM | Morning | 537
|3 | AM | Morning | 293
|4 | AM | Morning | 227
|5 | AM | Morning | 201

We can SEE that the peak hours are 16 PM, 14 PM, 11 AM, 13 PM, 15 PM.

And the peak time of day is afternoon.

## 3) Preferred Payment Method

```sql
-- Preferred payment method analysis
SELECT payment_type, COUNT(payment_type) number_of_use
FROM DimPayment
WHERE payment_value != 0
GROUP BY payment_type
ORDER BY number_of_use DESC;
```
| payment_type | number_of_use |
| --- | --- |
| Credit Card | 76795 |
| Blipay | 19784 |
| Voucher | 5769 |
| Debit Card | 1529 |

Note : There are 830 orders with no payment value. (Unknown)

The most preferred payment method is **credit card**.

## 4) Average Installments

```sql
-- Average number of installments analysis
SELECT CEILING(AVG(number_of_installments*1.0)) Avg_of_installments
FROM (
    SELECT order_id, max(payment_installments) number_of_installments
    FROM DimPayment
    JOIN FactOrder
    ON DimPayment.[Payment_key (PK)] = FactOrder.[Payment_key (FK)]
    GROUP BY order_id
) AS NewTab
```

| Avg_of_installments |
| --- |
|3|

We can SEE that the average number of installments is 3. (2.93 -> 3)

## 5) Average Spending Time

_(To be implemented)_

## 6) Purchase Frequency by State

```sql
-- Purchase frequency analysis by state
------------------------------------------------------------
SELECT customer_state, COUNT(order_id) Frequency_of_purchase
FROM FactOrder
JOIN DimCustomer ON FactOrder.[Customer_key (FK)] = DimCustomer.[Customer_key (PK)]
GROUP BY customer_state
ORDER BY Frequency_of_purchase DESC;
```

| customer_state | Frequency_of_purchase |
| --- | --- |
| Banten | 23133 |
| Jawa Barat | 13976 |
| Dki Jakarta | 13613 |
| Jawa Tengah | 9285 |
| Jawa Timur | 9185 |
| Sumatera Utara | 4268 |
| Sulawesi Selatan | 2591 |
| Sumatera Selatan | 2298 |
| Sumatera Barat | 2048 |
| Papua | 1991 |
| Di Yogyakarta | 1944 |
| Kalimantan Timur | 1824 |
| Lampung | 1818 |
| Kalimantan Barat | 1736 |
| Riau | 1669 |
| Kalimantan Selatan | 1646 |
| Bali | 1509 |
| Nusa Tenggara Timur | 1375 |
| Sulawesi Utara | 1327 |
| Jambi | 1174 |
| Kalimantan Tengah | 1165 |
| Sulawesi Tengah | 1073 |
| Sulawesi Tenggara | 980 |
| Aceh | 898 |
| Kepulauan Riau | 796 |
| Papua Barat | 777 |
| Unknown | 775 |
| Bengkulu | 617 |
| Maluku Utara | 579 |
| Kalimantan Utara | 532 |
| Gorontalo | 526 |
| Maluku | 524 |
| Sulawesi Barat | 502 |
| Nusa Tenggara Barat | 413 |
| Kepulauan Bangka Belitung | 359 |


## 7) Heavy Traffic Logistic Route

```sql
-- Heavy traffic logistic route analysis
WITH routing AS (
    SELECT route, Avg([delay (min)]) Avg_delay 
    FROM FactOrder
    GROUP BY route
), number_of_orders AS (
    SELECT route, COUNT([delay (min)]) number_of_delayed_orders 
    FROM FactOrder
    WHERE [delay (min)] != 0
    GROUP BY route
)
SELECT routing.route, Avg_delay, number_of_delayed_orders
FROM routing
JOIN number_of_orders ON routing.route = number_of_orders.route
ORDER BY number_of_delayed_orders DESC;
```

| route | Avg_delay | number_of_delayed_orders |
| --- | --- | --- |
|Banten-Kota Tangerang->Dki Jakarta-Kota Jakarta Barat | 344 | 271|
|Banten-Kota Tangerang->Dki Jakarta-Kota Jakarta Selatan | 2292 | 189|
|Kalimantan Timur-Kabupaten Berau->Dki Jakarta-Kota Jakarta Barat | 2791 | 98|
|Kalimantan Timur-Kabupaten Berau->Banten-Kota Tangerang | 645 | 84|
|Banten-Kota Tangerang->Jawa Barat-Kota Depok | 2087 | 68|
|Sumatera Utara-Kabupaten Deli Serdang->Dki Jakarta-Kota Jakarta Barat | 4627 | 48|
|Banten-Kota Tangerang->Banten-Kabupaten Tangerang | 653 | 46|
|Banten-Kota Tangerang->Dki Jakarta-Kota Jakarta Utara | 1487 | 45|
|Banten-Kota Tangerang->Dki Jakarta-Kota Jakarta Timur | 906 | 42|
|Banten-Kota Tangerang->Jawa Timur-Kabupaten Sidoarjo | 2885 | 42|


## 8) Late Delivered Orders

```sql
-- Late delivered orders analysis
SELECT COUNT(DISTINCT order_id) number_of_delayed_orders
FROM FactOrder
WHERE [delay (min)] != 0;
```
| number_of_delayed_orders |
| --- |
|7826 |

## 9) Correlation Between Late Orders and Customer Satisfaction

```sql
-- Correlation analysis between late orders and customer satisfaction
DECLARE @N FLOAT, @SumX FLOAT, @SumY FLOAT, @SumXY FLOAT, @SumXSquare FLOAT, @SumYSquare FLOAT;

SELECT
    @N = COUNT(*),
    @SumX = SUM(feeback_score),
    @SumY = SUM([delay (min)]),
    @SumXY = SUM(feeback_score * [delay (min)]),
    @SumXSquare = SUM(feeback_score * feeback_score),
    @SumYSquare = SUM([delay (min)] * [delay (min)])
FROM FactOrder
JOIN DimFeedback ON [Feedback_key (PK)] = [Feedback_key (FK)]
WHERE [delay (min)] != 0;

SELECT
    CAST((@N * @SumXY - @SumX * @SumY) AS FLOAT) /
    SQRT((@N * @SumXSquare - POWER(@SumX, 2)) * (@N * @SumYSquare - POWER(@SumY, 2)))
    AS CorrelationCoefficient;
```

| CorrelationCoefficient |
| --- |
|-0.216616114787772 |


## 10) Delay Analysis by State

```sql
-- Delay analysis for delivery/shipping process in each state
SELECT route, AVG([shipping_time (min)]) 'Avg_shipping_time (min)', Count(DISTINCT order_id) Number_of_orders
FROM FactOrder
GROUP BY route
ORDER BY Number_of_orders DESC;
```

| route | Avg_shipping_time (min) | Number_of_orders |
| --- | --- | --- |
|Banten-Kota Tangerang->Banten-Kota Tangerang | 4002 | 4186|
|Banten-Kota Tangerang->Dki Jakarta-Kota Jakarta Barat | 16109 | 1433|
|Kalimantan Timur-Kabupaten Berau->Banten-Kota Tangerang | 10976 | 1116|
|Unknown | 0 | 776|
|Banten-Kota Tangerang->Banten-Kabupaten Tangerang | 10453 | 607|
|Kalimantan Timur-Kabupaten Berau->Dki Jakarta-Kota Jakarta Barat | 19606 | 504|
|Banten-Kota Tangerang->Jawa Barat-Kabupaten Bekasi | 12810 | 483|
|Jawa Barat-Kabupaten Bogor->Banten-Kota Tangerang | 3953 | 437|
|Banten-Kota Tangerang->Dki Jakarta-Kota Jakarta Selatan | 10790 | 387|
|Banten-Kota Tangerang->Dki Jakarta-Kota Jakarta Timur | 6922 | 378|

## 11) Delay Difference Analysis by State

```sql
-- Delay difference analysis between estimated delivery time and actual delivery time in each state
-- (Group by state -> delivered - estimated delivery time)
SELECT route, AVG([delay (min)]) 'Avg_delay_time (min)', Count(DISTINCT order_id) Number_of_orders
FROM FactOrder
GROUP BY route
ORDER BY Number_of_orders DESC;
```

| route | Avg_delay_time (min) | Number_of_orders |
| --- | --- | --- |
|Banten-Kota Tangerang->Banten-Kota Tangerang | 344 | 4186|
|Banten-Kota Tangerang->Dki Jakarta-Kota Jakarta Barat | 2292 | 1433|
|Kalimantan Timur-Kabupaten Berau->Banten-Kota Tangerang | 645 | 1116|
|Unknown | 0 | 776|
|Banten-Kota Tangerang->Banten-Kabupaten Tangerang | 653 | 607|
|Kalimantan Timur-Kabupaten Berau->Dki Jakarta-Kota Jakarta Barat | 2791 | 504|
|Banten-Kota Tangerang->Jawa Barat-Kabupaten Bekasi | 425 | 483|
|Jawa Barat-Kabupaten Bogor->Banten-Kota Tangerang | 233 | 437|
|Banten-Kota Tangerang->Dki Jakarta-Kota Jakarta Selatan | 450 | 387|
|Banten-Kota Tangerang->Dki Jakarta-Kota Jakarta Timur | 906 | 378|


This README provides an overview of the data analysis performed to answer specific questions about the ecommerce dataset. The SQL queries and their explanations are provided for each analysis.