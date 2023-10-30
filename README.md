
# Employee Pair Finder

![GitHub License](https://img.shields.io/github/license/scroll-star/Stoyan-Kostov-employees)

## Assignment

The goal of this assignment is to create an application that identifies the pair of employees who have worked together on common projects for the longest period of time. This application should take as input a CSV file containing employee project data and provide the following features:

- Load input data from a CSV file.
- Allow users to select the CSV file from their file system.
- Display common projects of employee pairs in a data grid with columns: Employee ID #1, Employee ID #2, Project ID, and Days worked together.
- Handle various date formats.
- Calculate the pair of employees who have worked together for the longest period on a common project.

## Input Data

The input data is provided in a CSV file with the following format:

```
EmpID, ProjectID, DateFrom, DateTo
```

Sample data:

```
143, 12, 2013-11-01, 2014-01-05
218, 10, 2012-05-16, NULL
143, 10, 2009-01-01, 2011-04-27
```

## Solution
The solution is provided as a iOS Swift program that accomplishes the task as described. It includes a class Presenter that handles the processing of the CSV file and finding the pair of employees who worked together the longest. The solution also includes helper functions to handle date formats and date calculations.

## Getting Started
To get started with the project, follow these steps:

1. Clone the repository: git clone https://github.com/scroll-star/Stoyan-Kostov-employees.git
2. Open the project in Xcode 15.

## How to Use
To use the application:

1. Run the program using iPhone 15 Pro simulator.
2. Use the user interface to select a CSV file with the employee project data.
3. After selecting the file, the program will display the pair of employees who worked together the longest on a common project.

## Author
Stoyan Kostov
GitHub: https://github.com/scroll-star

Feel free to reach out if you have any questions or need further assistance.

## License
This project is licensed under the MIT License. See the LICENSE file for details.
