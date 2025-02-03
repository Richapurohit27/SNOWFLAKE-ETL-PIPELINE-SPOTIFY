Here’s the revised content with the requested changes:

---

# **Spotify ETL Pipeline with Snowflake and AWS Integration**

This repository demonstrates a fully automated **data engineering pipeline** that extracts, processes, and analyzes **Spotify's Best of 2024 songs in India**, leveraging **Snowflake for scalable data processing**. This project illustrates how modern cloud-native tools enable **seamless ETL workflows** and facilitate **advanced analytics**.

## **Project Overview**

This project **automates data extraction, transformation, and analytics** for **Spotify's Indian music data**. It **extracts real-time** music data from the **Spotify API**, processes and transforms it, and prepares it for **analytics** using **Snowflake** and **AWS services**. The pipeline enables insights into **trending songs and artists in India**.

## **Pipeline Architecture**

### **1. Data Extraction**
- Extracts **Spotify's Best of 2024 Songs in India** using the **Spotify API**.
- Converts data into **structured formats** using **Pandas**.
- Deploys extraction logic on **AWS Lambda** for **automation** and **scalability**.

### **2. Data Storage**
- Uses **AWS S3** to store extracted data:
  - **Raw Data**: Stored in separate folders for **processing and processed** data.
  - **Transformed Data**: Organized into structured tables (**songs, artists, albums**).

### **3. Data Transformation**
- Implements a **Spotify Transformation Lambda Function**:
  - Triggered upon new uploads to the **to-process** folder.
  - Transforms **raw data into relational tables** for analytics.
  - Moves **processed data** to the appropriate **S3 folder**.

### **4. Data Ingestion into Snowflake**
- Uses **Snowflake Stages** to access transformed data from **S3**.
- Loads data into **Snowflake tables** (**albums, artists, songs**).
- Implements **Snowpipe with AWS SQS** for **real-time auto-ingestion**:
  - SQS notifications trigger Snowpipe upon **new file uploads**.
  - Data is automatically loaded into **Snowflake tables**.

## **Technologies and Tools Used**
- **Spotify API**: Data source for **Spotify's Best of 2024 Songs in India**.
- **Python & Pandas**: For **data extraction and transformation**.
- **AWS Lambda**: Serverless functions for **automated workflows**.
- **AWS S3**: Storage for **raw and processed data**.
- **Snowflake**: Cloud **data warehousing** for **scalable data processing**.
- **Snowpipe & AWS SQS**: **Real-time data ingestion** from **S3 to Snowflake**.

## **Project Features**
✅ **Automated ETL Pipeline**: Fully **event-driven** and **serverless**.  
✅ **Scalable Design**: Uses **AWS Lambda** and **Snowflake** for **cost-efficient scaling**.  
✅ **Structured Data Management**: Organized **S3 storage** for easy processing.  
✅ **Real-Time Data Ingestion**: Snowpipe ensures **immediate processing**.  
✅ **Advanced Analytics**: SQL-based queries via **Snowflake** for **insights**.  

This project **demonstrates an end-to-end cloud-based data pipeline** that **seamlessly integrates Snowflake and AWS services** to analyze **Spotify's Indian music trends**. 🚀  
