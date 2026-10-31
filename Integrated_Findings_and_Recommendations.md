# Phase 5 --- Integrated Findings, Business Impact & Recommendations

**Project:** End-to-End Supply Chain Analytics & Late Delivery Prediction.\
**Prepared from:**  raw/cleaned CSVs, cleaning notebook, EDA
notebook, MySQL connection notebook, table-splitting SQL, validation
SQL, and business-insights SQL.\
**Purpose:** Consolidate completed work and add decision-oriented
interpretation without repeating the entire EDA/SQL process.

------------------------------------------------------------------------

## 1. Executive summary

The cleaned file contains **180,518 order-item records and 45 columns**.
These records represent 65,751 distinct orders, 20,651 customers, and
118 products. Delivery-status labels show 98,977 records marked **Late
delivery** (54.83% of all records). Excluding the 7,754 records marked
**Shipping canceled**, the late-delivery rate is **57.29%**.

Delivery performance differs sharply by shipping mode in the source
labels. First Class has 26,513 late records and a **100.00%** late rate
among non-canceled records. Second Class has 26,987 late records and a
**79.83%** non-canceled late rate. Standard Class has the largest
absolute number of late records (41,023), even though its late rate is
lower.

The results support prioritizing a **data-definition check for shipping
labels**, followed by a review of First Class and Second Class
performance, and a volume-focused investigation of Standard Class.
Regional differences are more modest than shipping-mode differences.
These are descriptive findings, not proof of causal drivers such as
warehouse performance, carrier failure, or weather.

**Important interpretation:** these are primarily
*order-item/record-level* counts, not distinct-order counts. A single
order may contain multiple items and therefore multiple records.

------------------------------------------------------------------------

## 2. Files reviewed and work performed

  --------------------------------------------------------------------------------
  Reference file                                How it was used
  -------------------------------------------- -----------------------------------
  `DataCoSupplyChainDataset.csv`            Compared raw dataset shape and
                                               columns with the cleaned export.

  `DataCoSupplyChainDataset_Cleaned.csv`       Main source for recomputing the
                                               reported counts, delivery rates,
                                               duration summaries,
                                               category/market/region/segment
                                               comparisons, and preliminary
                                               sales/profit totals.

  `data_cleaning.ipynb`                     Reviewed cleaning decisions, column
                                               drops, duplicate/missing-value
                                               checks, and export logic.

  `Supply_Chain_EDA.ipynb`                     Reviewed completed delivery-status,
                                               shipping-mode, cancellation,
                                               region, month, market, segment,
                                               category, and outlier analyses.

  `mysql connecion.ipynb`                      Reviewed how the cleaned CSV was
                                               loaded into MySQL.

  `Table_splitting.sql`                        Reviewed the Customers, Products,
                                               Orders, Order Items, and Shipping
                                               table design and mappings.

  `checking_data_before_table_splitting.sql`   Reviewed integrity checks for
                                               order/customer/product/item
                                               relationships.

  `some_business_insights.sql`                 Reviewed existing sales, profit,
                                               delivery, product, category, and
                                               customer SQL analyses.
  --------------------------------------------------------------------------------

### What I did in Phase 5

1.  Recomputed core counts and delivery-status rates from the cleaned
    CSV instead of relying on screenshots or earlier copied numbers.
2.  Compared all shipping modes using both all records and a denominator
    that excludes canceled records.
3.  Ranked regions, markets, and product categories using the same
    explicit late-rate definition.
4.  Compared customer-segment results to see whether segment differences
    were large enough to drive priorities.
5.  Calculated preliminary sales/profit totals using the columns already
    used in your SQL.
6.  Identified data-cleaning and SQL-definition issues that should be
    fixed or documented before publishing business conclusions.
7.  Converted the results into practical, evidence-linked
    recommendations and clearly labeled hypothetical improvement
    scenarios.

No new predictive model was trained, no causal relationship was
established, and no Power BI dashboard was created in this report.

------------------------------------------------------------------------

## 3. Dataset profile and validation

  Check                                                           Result
  ------------------------------------------ ---------------------------
  Raw CSV shape                                180,519 rows × 53 columns
  Cleaned CSV shape                            180,518 rows × 45 columns
  Distinct order-item IDs                                        180,518
  Distinct order IDs                                              65,751
  Distinct customer IDs                                           20,651
  Distinct product IDs (`Product_Card_Id`)                           118
  Distinct product categories                                         50
  Distinct order regions                                              23
  Distinct markets                                                     5
  Full-row duplicate count in cleaned file                             0
  Missing customer last names                                          8
  Missing customer ZIP codes                                           3
  Order-date range                              2015-01-01 to 2018-01-31

### Interpretation

-   `Order_Item_Id` is unique in the cleaned file, so it is an
    appropriate row-level identifier for the current order-item
    analysis.
-   There are no exact duplicate rows in the cleaned file.
-   Missing last names and ZIP codes remain. These may be acceptable for
    delivery-rate summaries, but should be disclosed for
    customer/address analyses.
-   The cleaned export has one fewer row than the raw CSV. The cleaning
    notebook should document exactly which row was removed and why,
    rather than leaving the difference unexplained.
-   `Product_Status` is still present in the cleaned export. In the
    cleaning notebook, `df.drop(df['Product Status'], inplace=True)`
    does not express a column drop; it should be
    `df.drop(columns=['Product Status'], inplace=True)` if dropping that
    column is intended. Recheck the row count after correcting the
    operation.

## 4. Delivery-status findings

### 4.1 Status distribution

  Delivery status           Records   Share of all records
  ------------------- ------------- ----------------------
  Late delivery              98,977                 54.83%
  Advance shipping           41,591                 23.04%
  Shipping on time           32,196                 17.84%
  Shipping canceled           7,754                  4.30%
  **Total**             **180,518**            **100.00%**

The overall rate of records labeled Late delivery is:

\[ `\frac{98,977}{180,518}`{=tex}`\times100`{=tex} = 54.83% \]

When canceled records are excluded, the denominator is 172,764 records:

\[ `\frac{98,977}{172,764}`{=tex}`\times100`{=tex} = 57.29% \]

Use the second measure only when the report explicitly defines
cancellations as excluded. Retain the first measure when reporting the
share of all records labeled late. Do not mix these denominators in the
same comparison.

### 4.2 Why the earlier 95.32% figure was misleading

First Class has 27,814 records, of which 26,513 are labeled late:

\[ `\frac{26,513}{27,814}`{=tex}`\times100`{=tex} = 95.32% \]

That is the **First Class rate across all its records**, not the overall
dataset rate. After excluding First Class cancellations, all remaining
First Class records are labeled Late delivery. This unusually strong
pattern should be checked against the source definitions and
status-generation logic before interpreting it as operational failure.

------------------------------------------------------------------------

## 5. Shipping-mode analysis

  -----------------------------------------------------------------------------------------
  Shipping     Records      Late   Canceled      Late      Late rate,       Avg         Avg
  mode                   records    records rate, all       excluding    actual   scheduled
                                              records   cancellations      days        days
  ---------- --------- --------- ---------- --------- --------------- --------- -----------
  First         27,814    26,513      1,301    95.32%         100.00%      2.00        1.00
  Class                                                                         

  Same Day       9,737     4,454        444    45.74%          47.93%      0.48        0.00

  Second        35,216    26,987      1,410    76.63%          79.83%      3.99        2.00
  Class                                                                         

  Standard     107,751    41,023      4,599    38.07%          39.77%      4.00        4.00
  Class                                                                         
  -----------------------------------------------------------------------------------------

### Findings

1.  **First Class is the strongest rate-based alert.** Its non-canceled
    records are all labeled Late delivery. This is a reason to inspect
    the status rules and service-level definitions as well as the
    operational process; it is not enough by itself to conclude the
    carrier failed.
2.  **Second Class is another high-priority segment.** It has 26,987
    late records and a 79.83% rate excluding cancellations. Its average
    actual shipping duration (3.99 days) is about 2.00 days scheduled.
3.  **Standard Class is the volume-based alert.** It contributes the
    largest number of late records (41,023). It also contains 41,591
    Advance shipping records across the full dataset; confirm how these
    status labels are assigned before interpreting the mode's lower late
    rate.
4.  **Same Day has a lower late rate than First or Second Class**, but
    it still contains 4,454 late-labeled records.

The actual-minus-scheduled duration is a useful additional measure. It
should be computed per record first, then averaged; subtracting two
averages gives the same arithmetic difference only when the two averages
use the same records.

------------------------------------------------------------------------

## 6. Regional and market findings

### 6.1 Regions with the highest non-canceled late-delivery rates

  ------------------------------------------------------------------------
  Region             Records   Late records       Canceled       Late rate
                                                   records       excluding
                                                             cancellations
  ----------- -------------- -------------- -------------- ---------------
  Central              1,677            972             61          60.15%
  Africa                                                   

  Western             27,109         15,140          1,242          58.53%
  Europe                                                   

  South of             4,045          2,256            190          58.52%
  USA                                                      

  South Asia           7,731          4,350            276          58.35%

  East Africa          1,852          1,036             71          58.17%
  ------------------------------------------------------------------------

### Regions with lower observed rates

  ------------------------------------------------------------------------
  Region             Records   Late records       Canceled       Late rate
                                                   records       excluding
                                                             cancellations
  ----------- -------------- -------------- -------------- ---------------
  Canada                 959            468             52          51.60%

  West Africa          3,696          1,953            125          54.69%

  Caribbean            8,318          4,415            367          55.53%
  ------------------------------------------------------------------------

### Interpretation

-   **Central Africa** has the highest observed rate in this dataset
    (60.15%), but it has 1,677 records. Review it as a targeted
    investigation rather than assuming it has the largest total business
    impact.
-   **Western Europe** has a high rate (58.53%) and 27,109 records,
    making it a more substantial operational priority by both rate and
    volume.
-   **Central America** has the largest regional record volume (28,341)
    and 57.11% late among non-canceled records. It should be considered
    in volume-based improvement planning.
-   Canada has the lowest observed rate (51.60%) but only 959 records;
    compare sample sizes before drawing strong conclusions.

These regional results describe association, not root cause. The dataset
does not by itself establish warehouse staffing, weather, carrier
capacity, or other unmeasured causes.

### 6.2 Market comparison

  Market           Records   Late rate excluding cancellations
  -------------- --------- -----------------------------------
  Europe            50,252                              57.69%
  USCA              25,799                              57.41%
  Pacific Asia      41,259                              57.38%
  LATAM             51,594                              56.87%
  Africa            11,614                              56.84%

The market rates fall within a relatively narrow range (56.84%--57.69%).
This suggests the first investigation should focus on more granular
region/shipping-mode combinations and status definitions rather than
attributing the issue to an entire market.

------------------------------------------------------------------------

## 7. Product-category findings

The table below includes categories with at least 1,000 records,
reducing the risk of ranking categories solely because of very small
sample sizes.

  --------------------------------------------------------------------------------------------------
  Category           Records Late records       Late rate      Sales sum          Profit sum (source
                                                excluding        (source   `Order_Profit_Per_Order`)
                                            cancellations       `Sales`) 
  ------------- ------------ ------------ --------------- -------------- ---------------------------
  Accessories          1,780        1,014          59.75%     133,671.51                   16,643.52

  Electronics          3,156        1,770          58.53%     371,034.64                   40,891.38

  Golf Gloves          1,070          602          58.50%     116,695.39                   12,975.49

  Girls'               1,201          664          58.40%     151,706.20                   17,288.57
  Apparel                                                                

  Shop By Sport       10,984        6,058          57.61%   1,309,522.04                  129,813.96

  Cleats              24,551       13,496          57.40%   4,431,942.78                  494,636.92
  --------------------------------------------------------------------------------------------------

### Interpretation

-   Accessories has a high observed rate (59.75%) among categories with
    at least 1,000 records, but it is not among the highest-volume
    categories.
-   Categories such as Cleats and Fishing combine substantial volume
    with late-delivery rates near the dataset average. They are useful
    candidates for operational sampling because even a modest
    improvement could affect many records.
-   Differences across most categories are not enormous. Do not claim a
    specific product category *causes* delays unless further evidence
    identifies a mechanism.

**Recommended next analysis:** cross-tab the highest-volume categories
with shipping mode and region. A category may appear problematic because
it is more frequently shipped through a mode or region with a high
baseline rate.

------------------------------------------------------------------------

## 8. Customer-segment findings

  ------------------------------------------------------------------------
  Customer           Records   Late records       Canceled       Late rate
  segment                                          records       excluding
                                                             cancellations
  ----------- -------------- -------------- -------------- ---------------
  Consumer            93,503         51,248          4,084          57.31%

  Corporate           54,789         29,982          2,261          57.08%

  Home Office         32,226         17,747          1,409          57.59%
  ------------------------------------------------------------------------

The segment rates are close to one another. Customer segment alone is
therefore not a strong differentiator for delivery improvement based on
these results. Avoid presenting this as evidence that one customer type
causes late delivery.

------------------------------------------------------------------------

## 9. Preliminary sales and profitability results

The existing SQL uses `Sales` as the sales measure and maps
`Order_Profit_Per_Order` to `order_items.profit`.

  Measure                                               Value
  ------------------------------------------- ---------------
  Sum of `Sales`                                36,784,407.26
  Sum of `Order_Profit_Per_Order`                3,966,811.72
  Preliminary ratio: profit sum ÷ sales sum            10.78%
  Sum of `Order_Item_Quantity`                        384,078

### Important qualification

Treat these as **preliminary source-column aggregates**, not audited
financial statements. The dataset includes several related fields
(`Sales`, `Sales_per_customer`, `Order_Item_Total`,
`Order_Profit_Per_Order`, and `Order_Item_Profit_Ratio`). Before making
a financial claim, document the business definition and intended grain
of each measure and verify that the SQL aggregation does not
double-count order-level values.

Your table-splitting script inserts `Order_Profit_Per_Order` into
`order_items.profit`. That mapping may be usable for line-level analysis
if the source field is indeed defined at the order-item grain, but its
name is ambiguous. Confirm the source definition before treating
category/customer profit rankings as final. Also, do not sum profit
ratios; calculate a weighted margin from summed profit and summed sales
when those two fields are valid and at the same grain.

### Delivery status and financial totals

  Delivery status       Records       Sales sum   Profit sum (provisional)
  ------------------- --------- --------------- --------------------------
  Advance shipping       41,591    8,517,680.14                 935,134.03
  Late delivery          98,977   20,126,395.27               2,140,051.68
  Shipping canceled       7,754    1,570,305.36                 160,482.34
  Shipping on time       32,196    6,570,026.50                 731,143.67

These totals are descriptive associations only. They do not establish
that late delivery caused a change in profit. Product mix, shipping
mode, discounts, and other variables may differ across status groups.

------------------------------------------------------------------------

## 10. Improvement scenarios (not forecasts)

The current non-canceled baseline is 172,764 records, with 98,977
late-labeled records and a 57.29% late rate.

  -----------------------------------------------------------------------
  Hypothetical                      Target rate             Approx. fewer
  scenario                                           late-labeled records
                                                             vs. baseline
  ------------------- ------------------------- -------------------------
  Reduce the rate by                     52.29%                     8,638
  5 percentage points                           

  Reduce the rate by                     47.29%                    17,276
  10 percentage                                 
  points                                        
  -----------------------------------------------------------------------

**Formula:** number of non-canceled records × percentage-point
reduction.

These are illustrative targets assuming the same record volume and
denominator. They are not predictions, promises, or a calculation of
financial savings. A reduction in late records should not be translated
into rupees without a defensible cost-per-delay or service-impact
estimate.

------------------------------------------------------------------------

## 11. Prioritized business recommendations

### Priority 1 --- Audit the delivery-status definitions and data grain

**Evidence:** First Class shows a 100% late rate after cancellations are
excluded, while Standard Class contains many records marked Advance
shipping. The dataset also has four different delivery-status labels.

**Action:** - Confirm the definition of each `Delivery_Status` label. -
Compare the status label with actual and scheduled shipping days at the
order-item level. - Check whether `Late_delivery_risk` is a
prediction/risk flag rather than an observed outcome. - Report
order-item counts separately from distinct-order counts.

**Success metric:** status consistency rate; number of unexplained
status-duration mismatches; verified late rate under an agreed
definition.

### Priority 2 --- Investigate First Class and Second Class

**Evidence:** First Class has 26,513 late records and a 100.00%
non-canceled rate; Second Class has 26,987 late records and a 79.83%
non-canceled rate.

**Action:** inspect scheduled commitments, carrier/service-level
definitions, dispatch timestamps, and a sample of orders from both
modes. First establish that status labels are valid before assigning
operational blame.

**Success metric:** verified late-delivery rate and
actual-minus-scheduled days by mode.

### Priority 3 --- Address high-volume delays in Standard Class

**Evidence:** Standard Class has 41,023 late records, the largest
absolute count among the shipping modes.

**Action:** sample late-labeled Standard Class records by region, month,
and product category; look for repeatable patterns rather than assuming
the mode itself is the cause.

**Success metric:** late-record count and rate, reported together with
volume and cancellation rate.

### Priority 4 --- Prioritize regional investigation by both rate and volume

**Evidence:** Central Africa has the highest observed rate, while
Western Europe has a high rate and much larger volume; Central America
has the largest regional volume.

**Action:** investigate Central Africa as a high-rate segment and
Western Europe/Central America as high-impact volume segments. Review
carrier, dispatch, and scheduling information if those fields become
available.

**Success metric:** late rate and late count for each targeted region,
using the same denominator before and after the intervention.

### Priority 5 --- Use category-level findings to guide sampling, not blame products

**Evidence:** Accessories has a high observed rate among categories with
at least 1,000 records, while Cleats and Fishing have large volumes.

**Action:** cross-tab category × region × shipping mode and inspect the
largest affected segments. Prioritize combinations with both meaningful
volume and a higher-than-baseline rate.

**Success metric:** verified late rate and count for the selected
combinations, with sample sizes shown.

------------------------------------------------------------------------

## 12. Limitations

1.  **Observational dataset:** grouped patterns do not establish causal
    relationships.
2.  **Record grain:** many records belong to the same order, so
    order-item rates are not automatically customer/order-level rates.
3.  **Status semantics:** the First Class and Standard Class patterns
    require validation against the source's label definitions.
4.  **Financial semantics:** the source fields used for sales and profit
    should be documented and checked for correct grain before publishing
    definitive financial conclusions.
5.  **Missing customer details:** 8 last names and 3 ZIP codes are
    missing in the cleaned export.
6.  **No direct warehouse/weather/carrier evidence:** the current file
    does not establish these as root causes.
7.  **Improvement scenarios:** the 5- and 10-percentage-point examples
    are hypothetical, not forecasts or guaranteed savings.
8.  **No predictive model:** this phase is descriptive and
    decision-oriented; a genuine prediction model would require a
    separate design, target definition, validation split, and
    performance evaluation.

------------------------------------------------------------------------

## 13. Final conclusion

The most defensible Phase 5 outcome is not simply that a region or
shipping mode is "bad." It is that the dataset labels show a high
overall late-record share, unusually high rates for First Class and
Second Class, and a large absolute number of late records in Standard
Class. Regional and category-level patterns help identify where to
investigate next, but their causes are not established by these fields
alone.

The recommended sequence is:

1.  Correct and document the cleaning/export issues.
2.  Validate delivery-status semantics and distinguish order-item counts
    from order counts.
3.  Investigate First Class and Second Class while accounting for
    Standard Class's large late-record volume.
4.  Prioritize regions and category/mode combinations by both rate and
    volume.
5.  Track improvement using consistent, validated KPIs.
6.  Publish the final project with the data definitions and limitations
    included.

This report consolidates the completed EDA/SQL work and adds
interpretation, data-quality checks, decision priorities, and
improvement scenarios without pretending that a predictive model or
causal investigation has already been performed.
