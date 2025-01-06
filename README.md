# JMeter Performance Test Project

This project is a performance test suite using JMeter to test the search functionality of the N11 website.

## Project Structure

```
jmeter-load-test/
├── src/
│   └── test/
│       ├── jmeter/
│       │   └── n11_search_test.jmx    # Main test plan
│       └── resources/
│           └── search_keywords.csv     # Test data
├── generate-report.sh                  # Report generation script
├── pom.xml                            # Maven configuration
└── README.md
```

## Requirements

- Java 8 or higher
- Maven 3.6 or higher
- JMeter 5.5

## Installation

```bash
# Clone the project
git clone [repo-url]
cd jmeter-load-test

# Install dependencies
mvn clean install
```

## Running Tests

```bash
# Execute tests
mvn clean verify

# Generate report
./generate-report.sh
```

## Test Features

- **Thread Group**: 5 users with 5 seconds ramp-up period
- **Search Test**: Performs searches using keywords from CSV file
- **Assertion**: HTTP 200 response code validation
- **Reporting**: 
  - HTML Dashboard
  - Aggregate Report
  - Summary Report
  - Console Status Logger

## Reports

Test results can be found at the following locations:
- HTML Dashboard: `target/jmeter/reports/n11_search_test/index.html`
- Aggregate Report: `target/jmeter/results/aggregate-report.csv`
- Summary Report: `summary-report.jtl`

## Notes

- Test data is read from `search_keywords.csv` file
- Response code validation for each search request
- Detailed metrics and graphs available in HTML report
