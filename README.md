# Student Message Board - Group 38

## Code Organization

The code is organized into three folders: **backend**, **frontend** and **database**.

### backend
This folder contains the Javascript files used to integrate the frontend of the application with the PostgreSQL database server. There are two files of interest:

1. **index.js**: This file is used to set up the routes, as well as their type of requests from the API to the database tier.

2. **queries.js**: This file contains the database queries for each route specified in **index.js**. It takes inputs from HTTP request bodies and parameters, and outputs database query results as JSON rows.

### frontend

The Dart code in this folder seems to be a lot heavier, however only a few files and subdirectories are important:

1. **pubspec.yaml**: This is a YAML (_Yet Another Markup Language_) file, which contains all the imported packages used in the Dart code in the **lib** folder.
2. **lib**: This is the subdirectory containing the code for the frontend of the application. There are many subdirectories inside **lib**. 
   1. **pages**: This subdirectory contains Dart source files for each page of the application. 
   2. **views**: This subdirectory contains various widgets and themes that are imported into Dart files in the **pages** subdirectory. 
   3. **models**: This subdirectory contains the definition and attributes of the various models used in this application.
   4. **services**: This subdirectory contains the middleware of the application. In particular, it contains all the API calls made from the frontend to the backend URLs.

    The **main.dart** file in this directory contains the **main** function which runs the application.

## Setup

There are two stages to setting up the application to run, given that the database is already created and populated.

### backend

In a terminal window, type the following from the root directory:

```
$ cd backend
$ npm i
$ npm run server
```

This will start the Node.js server to handle database requests.

### frontend

1. In Chrome/Chromium based browsers, install the [Dart Debug Extension](https://chrome.google.com/webstore/detail/dart-debug-extension/eljbmlghnomdjgdjmbdekegdkbabckhm).
2. In VS Code, install the [Flutter extension](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter). 
3. Open **frontend/lib/main.dart** in VS Code and run in debug mode on a webserver. This will render the web application on the browser.
4. Click the Dart Debug icon when asked, to complete the rendering and view the application.
