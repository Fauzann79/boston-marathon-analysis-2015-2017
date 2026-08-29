# Marathon Performance Analysis

Welcome to the **Marathon Performance Analysis** repository!

This project is an end-to-end data analytics project that analyzes marathon race data to understand **runner performance, participation trends, demographic patterns, pacing strategies, country-level performance, and returning runner progression**.

The project transforms marathon race data into analytical insights through data preparation, metric development, exploratory analysis, and interactive visualization using **Power BI**.

Rather than focusing only on overall finishing time, this analysis examines marathon performance from multiple perspectives to understand **who participates, how runners perform, how they pace themselves, and how their performance changes over time**.

---

## 🚀 Project Requirements

### Objective

The main objective of this project is to analyze marathon race data and identify meaningful patterns in participant characteristics and race performance.

The analysis focuses on several dimensions:

* Participation
* Finishing performance
* Gender
* Age group
* Country
* Race strategy
* Pacing behavior
* Split-time progression
* Returning runner performance
* Elite runner distribution

The final result is an interactive Power BI dashboard that allows the analysis to be explored across different dimensions.

---

## ❓ Analytical Questions

The analysis was designed around several key questions.

### Participation

* How many runners participated in the marathon?
* How did participation change across race years?
* Is marathon participation increasing, decreasing, or relatively stable?

### Runner Performance

* What is the average marathon finishing time?
* What is the median finishing time?
* How are finishing times distributed?
* How does performance differ across different demographic groups?

### Demographic Performance

* How does runner performance vary across age groups?
* How does performance differ between male and female runners?
* What patterns can be observed between age and race performance?

### Geographic Performance

* Which countries have the lowest average finishing times?
* How different are average finishing times between countries?
* Which countries appear most strongly represented among high-performing runners?

### Race Strategy

* What pacing strategies are most common?
* How frequently do runners record positive and negative splits?
* How does average finishing time differ between split strategies?

### Returning Runners

* How many participants return to compete in subsequent races?
* Do returning runners improve or worsen their performance?
* What is the average change in finishing time?
* Which age groups have the highest concentration of elite runners?

---

# 📊 Dataset

The dataset contains marathon race results covering multiple race years and includes information related to runner characteristics and race performance.

The dashboard analyzes approximately **80K participants** across the **2015–2017** race period.

### Dataset Overview

| Attribute               | Description                    |
| ----------------------- | ------------------------------ |
| Records                 | Approximately 80K participants |
| Race Period             | 2015–2017                      |
| Unit of Analysis        | Individual runner              |
| Main Performance Metric | Official Finish Time           |
| Analysis Tool           | Power BI                       |

The primary performance variable used in the analysis is `official_time_menit`, representing official marathon finishing time in minutes.

The dataset also contains variables used to analyze demographic characteristics, race splits, and returning runner performance.

---

# 🧹 Data Preparation

Before performing the analysis, the dataset needs to be structured so that the variables can be consistently analyzed and visualized.

The preparation process focused on ensuring that race-time and categorical variables could be used correctly within the analytical model.

The analysis uses variables related to:

* Race year
* Gender
* Age group
* Country
* Official finishing time
* Marathon split times
* Returning runner status
* Runner performance changes

Race-time information is represented in minutes to make calculations such as average finishing time and performance differences easier to interpret.

---

# 📐 Analytical Approach

The analysis follows an exploratory data analysis approach.

The overall analytical process can be represented as:

```text
Marathon Race Data
        ↓
Data Understanding
        ↓
Data Preparation
        ↓
Metric Development
        ↓
Exploratory Data Analysis
        ↓
Performance Analysis
        ↓
Pacing Analysis
        ↓
Returning Runner Analysis
        ↓
Visualization
        ↓
Insights & Recommendations
```

The analysis is divided into several major analytical areas rather than treating each dashboard page as a separate analysis.

---

# 📌 Key Performance Indicators

Several metrics were developed to provide an overall understanding of marathon performance.

| KPI                             |      Value |
| ------------------------------- | ---------: |
| Total Participants              |        80K |
| Average Finish Time             | 233.17 min |
| Median Finish Time              | 226.50 min |
| Positive Split                  |     95.63% |
| Negative Split                  |      4.37% |
| Total Returning Runners         |        10K |
| Average Returning Runner Change |  11.90 min |
| Performance Improved            |     26.80% |
| Performance Worsened            |     73.20% |

These KPIs provide the foundation for the deeper analysis performed throughout the project.

---

# 📈 Participation Analysis

One of the first areas of analysis is understanding participation across race years.

### Participation by Year

| Year | Participants |
| ---- | -----------: |
| 2015 |          27K |
| 2016 |          27K |
| 2017 |          26K |

The number of participants remained relatively stable across the three analyzed years.

Participation was approximately **27K in 2015**, **27K in 2016**, and **26K in 2017**.

This indicates that the marathon maintained a relatively consistent participant base during the analyzed period.

### Visualization

![Participation Trend](images/participationbyyear.png)

---

# ⏱️ Finishing Time Analysis

Finishing time is one of the primary measures used to evaluate runner performance.

The analysis uses both the **average** and **median** finishing time to provide a more complete understanding of the distribution.

### Overall Performance

| Metric              |      Value |
| ------------------- | ---------: |
| Average Finish Time | 233.17 min |
| Median Finish Time  | 226.50 min |

The average finishing time is higher than the median finishing time.

This difference indicates that the distribution of finishing times is affected by participants with relatively longer finishing times.

### Finish Time Distribution

![Finish Time Distribution](images/finishtimedis.png)

The distribution visualization provides additional context by showing how finishing times are spread across participants rather than relying only on a single average value.

---

# 📅 Performance Trend Across Race Years

Finishing performance was also compared across different race years.

The dashboard shows approximately:

| Year | Average Finish Time |
| ---- | ------------------: |
| 2015 |           226.4 min |
| 2016 |           235.1 min |
| 2017 |            ~239 min |

The analysis indicates that average finishing time increased across the analyzed race years.

This suggests that the participant population recorded longer average finishing times in the later years of the dataset.

However, the analysis does not establish the cause of this change. Additional information such as weather, course conditions, participant composition, or race difficulty would be required to explain why the average finishing time changed.

---

# 👥 Demographic Analysis

Runner performance was analyzed across demographic characteristics, particularly **age group and gender**.

### Age Group

Age groups provide an additional perspective for understanding differences in runner performance.

The analysis allows performance patterns to be compared between different age categories.

### Gender

The dashboard also compares performance between male and female participants.

### Age & Gender Visualization

![Demographic Performance](images/demographic-performance.png)

The demographic analysis provides a more detailed understanding of how marathon performance varies across participant groups.

Importantly, differences observed between groups should be interpreted as **descriptive patterns within the dataset**, rather than causal relationships.

---

# 🌎 Country Performance Analysis

Country-level analysis was performed to identify differences in average finishing time.

### Fastest Countries by Average Finish Time

| Country | Average Finish Time |
| ------- | ------------------: |
| KEN     |             142 min |
| ETH     |             147 min |
| PAN     |             203 min |
| PER     |             207 min |
| CRC     |             208 min |
| COL     |             209 min |
| CHI     |             209 min |
| GUA     |             211 min |

The dataset shows substantial differences in average finishing times between the countries displayed.

Kenya and Ethiopia have the lowest average finishing times among the highlighted countries.

### Elite Runner Performance

The dashboard also highlights average finishing performance for Kenya and Ethiopia:

| Country  | Average Finish Time |
| -------- | ------------------: |
| Kenya    |          142.32 min |
| Ethiopia |          146.59 min |

![Country Performance](images/country-performance.png)

These results should be interpreted carefully.

They describe the runners represented in this particular dataset and should **not** be interpreted as a general statement that runners from one country are inherently faster than runners from another country.

Differences in participant selection, race participation, athlete composition, and dataset coverage can influence these results.

---

# 🏃 Race Strategy & Pacing Analysis

Marathon performance is not determined only by the final finishing time.

The way a runner distributes their effort throughout the race can provide additional information about performance.

For this reason, split-time data was analyzed across multiple race checkpoints.

### Race Checkpoints

The analysis includes:

* K5
* K10
* K15
* K20
* Half Marathon
* K25
* K30
* K35
* K40

### Pacing Progression

![Pacing Analysis](images/pacing-analysis.png)

The split-time analysis allows runner performance to be observed throughout different stages of the marathon.

The dashboard shows cumulative race times increasing from approximately **25 minutes at K5** to approximately **220 minutes at K40**.

This provides a view of how performance develops throughout the race instead of relying only on the final finishing time.

---

# 🔄 Split Strategy Analysis

The runners are categorized based on their pacing strategy:

* Positive Split
* Negative Split
* Even Split

### Distribution of Split Strategies

| Strategy       | Percentage |
| -------------- | ---------: |
| Positive Split |     95.63% |
| Negative Split |      4.37% |

The dataset is heavily dominated by positive splits.

Approximately **95.63%** of runners recorded a positive split, while **4.37%** recorded a negative split.

### Average Finish Time by Strategy

| Split Strategy | Average Finish Time |
| -------------- | ------------------: |
| Positive Split |             234 min |
| Negative Split |             215 min |
| Even Split     |             203 min |

The dashboard shows differences in average finishing time between the three pacing strategies.

The even-split group has the lowest average finishing time among the displayed categories, followed by negative split and positive split.

These results show an association between pacing strategy and finishing performance within the dataset, but they should not be interpreted as proof that a particular strategy directly causes faster finishing times.

---

# 🔁 Returning Runner Analysis

Another important part of the project is analyzing runners who participated in multiple races.

Instead of looking only at the total population, returning runners allow performance to be compared across race participation.

### Returning Runner Metrics

| Metric                  |     Value |
| ----------------------- | --------: |
| Total Returning Runners |       10K |
| Average Change in Time  | 11.90 min |
| Performance Improved    |    26.80% |
| Performance Worsened    |    73.20% |

![Returning Runner Analysis](images/returning-runner-analysis.png)

The analysis shows that:

* **73.20%** of returning runners experienced worsened performance.
* **26.80%** experienced improved performance.

This indicates that returning to participate in another marathon did not necessarily correspond with improved finishing performance within the analyzed data.

The average change in finishing time was **11.90 minutes**.

---

# 🏅 Elite Runner Density by Age

The analysis also examines the distribution of elite runners across age groups.

| Age Group | Elite Runner Density |
| --------: | -------------------: |
|        10 |                9.05% |
|        20 |               14.33% |
|        30 |               12.02% |
|        40 |                4.63% |
|        50 |                1.24% |
|        60 |                0.07% |

The highest density shown in the dashboard occurs in the **20-year age group at 14.33%**, followed by the 30-year and 10-year groups.

This analysis provides another perspective on the relationship between age group and elite runner representation within the dataset.

---

# 🔎 Key Findings

The analysis identified several important findings.

### 1. Participation Was Relatively Stable

Participation remained within the range of approximately **26K–27K runners per year** between 2015 and 2017.

### 2. Average Finish Time Increased Across Race Years

Average finishing time increased from approximately **226.4 minutes in 2015** to approximately **235.1 minutes in 2016** and around **239 minutes in 2017**.

### 3. Average and Median Finish Time Are Different

The average finishing time was **233.17 minutes**, compared with a median of **226.50 minutes**.

This indicates that slower finishing times influence the overall average.

### 4. Positive Splits Are Dominant

Positive splits account for **95.63%** of the analyzed runners, making them overwhelmingly more common than negative splits.

### 5. Pacing Strategy Is Associated With Different Average Finishing Times

The dashboard shows:

* Positive Split: 234 minutes
* Negative Split: 215 minutes
* Even Split: 203 minutes

This demonstrates a noticeable difference in average finishing time across pacing strategies.

### 6. Country-Level Performance Differs

The dataset shows significant differences in average finishing time across countries, with Kenya and Ethiopia having the lowest average finishing times among the highlighted countries.

### 7. Returning Runner Performance Mostly Worsened

Among approximately **10K returning runners**, **73.20% experienced worsened performance**, while **26.80% improved**.

### 8. Elite Runner Density Is Concentrated in Younger Age Groups

The highest displayed elite runner density occurs in the **20-year age group at 14.33%**.

---

# 💡 Analytical Insights

The findings provide several broader insights into marathon performance.

### Pacing Is a Major Performance Dimension

The dominance of positive splits suggests that maintaining performance throughout the entire marathon is difficult for the majority of runners represented in the dataset.

The difference in average finishing times between pacing strategies also suggests that race strategy is an important dimension for understanding performance.

### Finishing Time Should Not Be Viewed in Isolation

A single finishing-time metric does not explain why one runner performs differently from another.

Age, gender, country, race year, pacing behavior, and previous participation provide additional context.

### Returning Does Not Automatically Mean Improving

The returning-runner analysis demonstrates that repeated participation does not necessarily result in faster finishing times.

Most returning runners in the dataset experienced slower finishing times compared with their previous performance.

### Dataset Context Matters

Country-level and demographic comparisons should be interpreted within the context of the dataset.

Observed differences may be influenced by the composition of participants, sample sizes, race conditions, and other factors that are not available in the dataset.

---

# 🎯 Recommendations

Based on the findings, several recommendations can be proposed.

### 1. Improve Race Pacing

The high proportion of positive splits suggests that runners may benefit from better pacing strategies, particularly by avoiding excessive effort during the early stages of the race.

### 2. Focus on Late-Race Endurance

Because positive splits dominate the dataset, training programs could place greater emphasis on maintaining pace during the second half of the marathon.

### 3. Monitor Individual Performance

Returning runners can be tracked across races to identify whether their performance is improving or deteriorating over time.

### 4. Use Runner Segmentation

Performance analysis can be segmented by:

* Age group
* Gender
* Country
* Race year
* Previous performance
* Pacing strategy

This can provide more specific insights than analyzing the entire participant population as one group.

### 5. Combine Performance Metrics

Future analysis should combine finishing time with split progression, demographic characteristics, and previous performance to create a more comprehensive runner-performance model.

---

# 📊 Dashboard

The final analysis was developed using **Microsoft Power BI**.

### Performance Overview

![Performance Overview](images/page-1-performance-overview.png)

### Demographic & Performance Analysis

![Demographic Performance](images/page-2-demographic-performance.png)

### Race Strategy & Pace Analysis

![Race Strategy](images/page-3-race-strategy.png)

### Additional Findings

![Additional Findings](images/page-4-additional-findings.png)

The dashboard combines all analytical areas into an interactive reporting environment where users can explore marathon performance from multiple perspectives.

---

# 🛠️ Tools & Technologies

* **Power BI** — Dashboard development and data visualization
* **Power Query** — Data transformation and preparation
* **DAX** — KPI and analytical measure development
* **SQL** — Data analysis and querying
* **GitHub** — Documentation and version control

---

# 🔄 Project Workflow

```text
Raw Marathon Data
        ↓
Data Understanding
        ↓
Data Preparation
        ↓
Data Transformation
        ↓
Metric Development
        ↓
Exploratory Data Analysis
        ↓
Performance Analysis
        ↓
Demographic Analysis
        ↓
Pacing & Race Strategy Analysis
        ↓
Returning Runner Analysis
        ↓
Power BI Visualization
        ↓
Insights
        ↓
Recommendations
```

---

# 📁 Project Structure

```text
Marathon-Performance-Analysis/
│
├── README.md
├── marathon.csv
├── analysis.sql
├── marathon.pbix
│
└── images/
    ├── page-1-performance-overview.png
    ├── page-2-demographic-performance.png
    ├── page-3-race-strategy.png
    └── page-4-additional-findings.png
```

---

# 🛡️ License

This project is licensed under the **MIT License**. You are free to use, modify, and share this project with proper attribution.

---

# 🌟 About Me

Hi there! I'm **Fauzan**, an aspiring **Data Analyst & Data Engineer** passionate about data, technology, and continuous learning.

I'm currently developing my skills in **SQL, Data Analytics, Data Engineering, Data Warehousing, and Data Visualization** by working on practical projects and building my portfolio.

My goal is to transform raw data into meaningful insights and build reliable data solutions that can support better decision-making.

> **Think Deeply. Act Wisely.**

