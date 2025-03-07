# **tidypollute** <img src="man/figures/logo.png" align="right" width="120"/>

🚀 **An R package for working with EPA AirData flat files and AQS API!** 🚀

Developer: [Dr. Nelson Roque](https://www.linkedin.com/in/nelsonroque/) | ORCID: https://orcid.org/0000-0003-1184-202X

[Source: https://github.com/nelsonroque/tidypollute](https://github.com/nelsonroque/tidypollute)

---

## **Overview**

**tidypollute** is a lightweight R package designed to make working with environmental data **easy, tidy, and efficient**. Whether you're a researcher, policymaker, or just an environmental data enthusiast, this package helps you import, clean, and analyze large-scale air pollution datasets with minimal hassle.

Learn more, by reading this package's [Documentation](https://nelsonroque.github.io/tidypollute/index.html).

---

🔥 **Why use tidypollute?**  
✔️ **Tidy**: Designed with the `tidyverse` in mind for seamless integration. 

![tidypollute_code](./man/figures/code-screenshot.png)

✔️ **Fast**: Optimized dplyr functions for handling big air quality datasets.  
✔️ **Flexible**: Supports both flat files and (soon!) real-time API queries.

---

### **📌 Current Features**
  ✅ **Read and process EPA AirData flat files**  
  ✅ **Read EPA AirData metadata**  
  ✅ **Extract data from the [Atmotube Cloud API](https://app.swaggerhub.com/apis-docs/Atmotube/cloud_api)**  
  ✅ **Tidy up and filter air pollution data**  
  
  

---

### **🛣️🛠 Roadmap: What's Next?**
  - **Quick, and simple visualizations from tidy data**  
  
  - **Integration with real-time API endpoinst (EPA AirData, Atmocube, Purple Air, Plume Flow)**
  
  - Add **codebooks** for various datasets
  
  - Generate **DOCX/PDF reports** from air quality data  
  
  - Merge air quality data with **Census demographics**
  
  - Interactive mapping integration with **mapview**

---

## **🚀 Getting Started**

### **Installation**

If hosted on GitHub, install with:

```r
devtools::install_github("nelsonroque/tidypollute")
```

Once on CRAN (coming soon!), install with:

```r
install.packages("tidypollute")
```
#### **Load the package**

```r
library(tidypollute)
```

---

## **💡 Contributions Welcome!**

📌 Have ideas? Found a bug? Want to improve the package?  [Open an issue!](https://github.com/nelsonroque/tidypollute/issues).

📜 **[Code of Conduct](https://docs.github.com/en/site-policy/github-terms/github-community-code-of-conduct) - Please be respectful and follow community guidelines.**

---

# Acknowledgements
The development of `tidypollute` was made possible with support from NIA (`P01-AG003949`) and Dr. Roque's PSU Start-up funds. 
Thank you [Dr. Charles B Hall](https://einsteinmed.edu/faculty/6913/charles-hall), [Dr. Dean Hosgood](https://einsteinmed.edu/faculty/13282/h-hosgood), and Hailey Andrews, for your support and manuscript reads.
Thank you [Dr. Alexis Santos-Lozada](https://hhd.psu.edu/contact/alexis-santos-santos-lozada) and [Dr. Johnny Felt](https://healthyaging.psu.edu/people/jzf434) for function name brainstorming.
Thank you, Hailey Andrews, for helping brainstorm the name of this package.
Thank you, Karishma Christmas, for your documentation support.

---

🌎 **More Resources:**  
📌 [EPA AQS API Docs](https://aqs.epa.gov/aqsweb/documents/data_api.html) 

📌 [EPA Daily Air Quality Reports](https://www.epa.gov/outdoor-air-quality-data/air-data-daily-air-quality-tracker-pdf-report) 

📌 [EPA AQI Colors](https://www.airnow.gov/aqi/aqi-basics/)

📌 [EPA Air Quality Webcams](https://www.airnow.gov/resources/web-cams/)

📌 [Census Reference Files](https://www.census.gov/geographies/reference-files.html)

📌 [Census GEOIDs](https://www.census.gov/programs-surveys/geography/guidance/geo-identifiers.html)

---

Ready to make sense of air quality data the **tidy way**? 🌱 Let's go! 🚀

---

Anyone want to help with the logo? :)
https://www.canva.com/design/DAGfIpmrLEA/Z0-kZNH66JDBZgp0PIlfMw/edit
