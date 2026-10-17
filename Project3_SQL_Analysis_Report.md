# Project 3: SQL Data Analysis — Report
**DecodeLabs | Data Analytics | Batch 2026**
**Dataset:** `Dataset_for_Data_Analytics.xlsx` — 1,200 e-commerce orders (Jan 2023 – mid 2025), loaded as table `orders` (SQLite).
**Script:** `queries.sql` (16 queries; every result below was produced by running it).

## 1. Skills demonstrated
SELECT · WHERE (=, >=, IN, LIKE, AND) · ORDER BY · GROUP BY · HAVING · COUNT / SUM / AVG · aliases · CASE WHEN · COALESCE (NULL handling) · subquery for % contribution.

## 2. Results

**Q2 – Overall KPIs:** 1,200 orders · revenue **$1,264,761.96** · average order value **$1,053.97**

**Q4 – Orders by status:** Cancelled 250 (20.8%) · Returned 247 (20.6%) · Pending 237 (19.8%) · Shipped 235 (19.6%) · Delivered 231 (19.3%)

**Q5/Q6 – Product revenue and share**
| Product | Orders | Units | Revenue | % of revenue |
|---|---|---|---|---|
| Chair | 178 | 562 | 195,620.11 | 15.47 |
| Printer | 181 | 542 | 195,612.61 | 15.47 |
| Laptop | 173 | 535 | 192,126.56 | 15.19 |
| Tablet | 179 | 497 | 186,568.95 | 14.75 |
| Monitor | 163 | 480 | 175,651.41 | 13.89 |
| Desk | 170 | 508 | 167,459.93 | 13.24 |
| Phone | 156 | 411 | 151,722.39 | 12.00 |

**Q7 – Payment method:** Credit Card leads on revenue ($263.8K) and AOV ($1,127.55); Debit Card is lowest ($232.4K, AOV $1,001.56).

**Q8 – Yearly revenue:** 2023 $552.6K (510 orders) · 2024 $480.2K (459) · 2025 $231.9K (231; partial year).

**Q9 – Referral source:** Instagram is the top channel ($275.3K, 259 orders); Facebook has the highest AOV ($1,098.29); Referral is lowest ($226.8K).

**Q10 – Coupons:** 309 orders (25.75%) used no coupon. FREESHIP is most used (313). Average order value is similar across all coupons ($1,036–$1,070).

**Q11 – Lost-order rate (HAVING > 40%):** Monitor 43.6%, Tablet 43.0%, Laptop 42.8%, Chair 41.0%, Printer 40.3%.

**Q12 – Repeat customers:** Only a handful of customers ordered twice (max 2 orders); top repeat spender C38840 at $5,723.23.

**Q14 – Revenue at risk:** Cancelled $276,396.21 + Returned $243,277.70 = **$519,673.91 (≈41% of all revenue)**.

**Q15/Q16 – Data quality:** 0 rows where TotalPrice ≠ Quantity × UnitPrice; 0 duplicate OrderIDs. The only NULLs are in `CouponCode` (309 rows = "no coupon").

## 3. Business insights
1. **~41% of orders are Cancelled or Returned.** This is the biggest finding — $519.7K of revenue is at risk, and every product sits between 39% and 44%, so the problem is systemic (fulfilment, checkout, or policy), not product-specific.
2. **Revenue is spread evenly** across products (12%–15.5% each); no single product dependency. Phone is the weakest on volume and revenue.
3. **Revenue fell 2023 → 2024** (−13%). 2025 is only a partial year, so it can't be compared directly.
4. **Coupons don't change basket value.** AOV is nearly identical with or without a coupon, so discounts may not be driving larger orders.
5. **Instagram is the strongest acquisition channel** by revenue; Facebook brings the highest-value orders.
6. **Status mix looks uniform** (≈20% each), which is unusual for real data and suggests the dataset is synthetic.

## 4. Notes and limitations
- Status is evenly split, so "Delivered" revenue is not a reliable measure of realised sales — only 231 orders were delivered.
- Q8 uses SQLite's `strftime`; for MySQL use `YEAR(Date)`, for PostgreSQL `EXTRACT(YEAR FROM Date)`.
- Q11 uses a 40% threshold because all products exceed 20%, which would make HAVING pointless.
