~~~~
header-includes:
    - \usepackage[most]{tcolorbox}
    - \definecolor{light-yellow}{rgb}{1, 0.95, 0.7}
    - \newtcolorbox{myquote}{colback=light-yellow,grow to right by=-10mm,grow to left by=-10mm, boxrule=0pt,boxsep=0pt,breakable}
    - \newcommand{\todo}[1]{\begin{myquote} \textbf{TODO:} \emph{#1} \end{myquote}}
~~~~


# "Liefer- und Abholdienste" - COVID-19 City Lab Project


&nbsp;

### 1. Context

&nbsp;

In the wake of the ongoing COVID-19 crisis, it quickly became clear that restaurants and other businesses in Berlin would need to seek out new ways of reaching their customers in order to survive financially. As a result, many started offering delivery and pick-up services for the first time. But then these businesses faced a new challenge: getting the word out to potential customers – new and existing – that they remained open for business.

&nbsp;

To help support the local economy, the Berlin Senate Department for Economics, Energy and Public Enterprises – working with the Chamber of Commerce and Industry of Berlin (IHK Berlin), the Association of Hotels and Restaurants in Berlin (DEHOGA Berlin), the Berlin-Brandenburg Trade Assocation (Handelsverband Berlin-Brandenburg), the CityLAB Berlin and the Open Data Service Point (ODIS) – published an open dataset containing businesses in Berlin that are currently offering pickup and/or delivery options for their goods. It encompasses the address, geographic coordinates, type of goods and services, contact information and opening hours of each business. 

&nbsp;

### 2. Collecting the Data

&nbsp;

Data was collected by ODIS using a Typeform online survey shared with businesses through various networks, such as the Chamber of Commerce’s newsletter and the CityLAB’s Twitter account, among others. Responses were automatically saved in an online Google Spreadsheet. Each business' contact information, opening times and description were stored in a single row.

&nbsp;

As of of April 29th, 2020, 1,120 responses (each representing a single business) had been collected. Most of these submissions were made during the first and the second week of April, following the publicization of this initiative in the German media and through emails from the Chamber of Commerce and Industry of Berlin to its members (with the peaks below representing the timing of those two e-mails).

&nbsp;

**Figure 1: Number of Daily Submissions**

![](graph1.png)
&nbsp;


Most of the survey questionnaire was open-ended, with respondents being free to enter their answers in text boxes, rather than by selecting from a set of predefined options. On the one hand, this allowed for more flexibility in the data collection process and increased the user-friendliness of the survey (it also enabled the survey to be quickly created, since there was no need for custom coding). On the other hand, however, this format created the need for subsequent data cleaning before the data could be published and reused by a wider audience. 

&nbsp;

Our workflow for this project was the following. The data generating process was conducted using Typeform, which automatically saved businesses' responses in a Google Spreadsheet. This dataset was then exported as a .csv file and cleaned using R, an open-source programming language. Some additional variables, such as geographic coordinates and unique user IDs, were also generated during this step. Finally, a clean .csv file was exported from R and uploaded in a new Google Spreadsheet for a final, manual check-up.

&nbsp;

**Figure 2: Project Workflow**

![](graph2.png)

&nbsp;


### 3. Cleaning and Analyzing the Data


&nbsp;

Our main coding efforts concentrated on three elements: (1) standardizing opening times, (2) standardizing addresses and converting them into geographic coordinates and (3) generating unique IDs. 


&nbsp;

#### 	3.1 Standardizing Opening Times


&nbsp;

Our first challenge consisted in uniformizing businesses' opening times. In the Typeform survey, respondents were requested to fill out their opening hours for each day of the week using the following format: "XX:XX-XX:XX". However, many entries did not fit this requested format, typically because (1) opening times were entered using an alternative notation (ex.: "12 bis 18 Uhr", "12-18", "12.00 bis 18.00 Uhr", etc.) or because (2) opening times for the entire week were encompassed in the question which inquired for Monday's opening hours. We thus needed to write code that would automatically recognize and – when possible – correct these discrepancies. 

&nbsp;

&nbsp;

\todo{something}



&nbsp;

&nbsp;

