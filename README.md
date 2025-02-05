# **tidypollute** <img src="man/figures/logo.png" align="right" width="120"/>

🚀 **An R package for working with EPA AirData flat files and AQS API!** 🚀  

## **Overview**  
**tidypollute** is a lightweight R package designed to make working with EPA air quality data **easy, tidy, and efficient**. Whether you're a researcher, policymaker, or just an environmental data enthusiast, this package helps you import, clean, and analyze large-scale air pollution datasets with minimal hassle.  

🔥 **Why use tidypollute?**  
✔️ **Tidy**: Designed with the `tidyverse` in mind for seamless integration.  
✔️ **Fast**: Optimized dplyr functions for handling big air quality datasets.  
✔️ **Flexible**: Supports both flat files and (soon!) real-time API queries.  

---

## **📌 Features (Current & Planned)**  
✅ **Read and process EPA AirData flat files**  
✅ **Tidy up and filter air pollution data**  
✅ **Quick and simple visualizations**  
🛠️ **(Coming soon!) Integration with real-time API endpoints**  

---

## **🚀 Getting Started**  

### **Installation**  
If hosted on GitHub, install with:  
```r
devtools::install_github("nelsonroque/tidypollute")
```

### **Load the package**  
```r
library(tidypollute)
```

---

## **💡 Contributions Welcome!**  
Have ideas? Found a bug? Want to improve the package?  
📢 **Join in!** Open an issue or submit a pull request—we’d love your help!  

---

## **🔎 Reference: Understanding GEOIDs**  

When working with Census data, GEOIDs are key identifiers for geographic areas. Here's a quick guide:  

| **Area Type**                                  | **GEOID Structure**                     | **Digits** | **Example**                                          | **GEOID Example**    |
|-----------------------------------------------|----------------------------------------|------------|------------------------------------------------------|----------------------|
| **State**                                     | STATE                                  | 2          | Texas                                               | 48                   |
| **County**                                    | STATE+COUNTY                           | 5 (2+3)    | Harris County, TX                                   | 48201                |
| **County Subdivision**                        | STATE+COUNTY+COUSUB                    | 10 (2+3+5) | Pasadena CCD, Harris County, TX                    | 4820192975           |
| **Place (City, Town, etc.)**                  | STATE+PLACE                            | 7 (2+5)    | Houston, TX                                        | 4835000              |
| **Census Tract**                              | STATE+COUNTY+TRACT                     | 11 (2+3+6) | Census Tract 2231, Harris County, TX               | 48201223100          |
| **Block Group**                               | STATE+COUNTY+TRACT+BLOCK GROUP         | 12 (2+3+6+1) | Block Group 1, Census Tract 2231, Harris County, TX | 482012231001        |
| **Block**                                     | STATE+COUNTY+TRACT+BLOCK               | 15 (2+3+6+4) | Block 1050, Census Tract 2231, Harris County, TX   | 482012231001050      |
| **Congressional District**                    | STATE+CD                               | 4 (2+2)    | Connecticut District 2                              | 0902                 |
| **State Legislative District (Upper Chamber)**| STATE+SLDU                             | 5 (2+3)    | Connecticut State Senate District 33               | 09033                |
| **State Legislative District (Lower Chamber)**| STATE+SLDL                             | 5 (2+3)    | Connecticut State House District 147               | 09147                |
| **ZCTA (ZIP Code Tabulation Area)**           | ZCTA                                   | 5          | Suitland, MD ZCTA                                  | 20746                |

---

## **🛣️ Roadmap: What's Next?**  
🚀 **Planned Features & Improvements:**  
🔹 Add **codebook** for EPA data exports  
🔹 Query the **EPA AQS API** (users provide their own token)  
🔹 Generate **DOCX/PDF reports** from air quality data  
🔹 Merge air quality data with **Census demographics**  
🔹 Interactive mapping integration with **mapview**  

🌎 **More Resources:**  
📌 [EPA AQS API Docs](https://aqs.epa.gov/aqsweb/documents/data_api.html)  
📌 [EPA Daily Air Quality Reports](https://www.epa.gov/outdoor-air-quality-data/air-data-daily-air-quality-tracker-pdf-report)  
📌 [Census Reference Files](https://www.census.gov/geographies/reference-files.html)  

---

Ready to make sense of air quality data the **tidy way**? 🌱 Let's go! 🚀
