import json
import xml.etree.ElementTree as ET

# Load the Unreal test report JSON
with open('index.json', 'r', encoding='utf-8-sig') as json_file:
    data = json.load(json_file)

# Create the root element for the JUnit XML report
testsuites = ET.Element('testsuites')

# Create a testsuite element
testsuite = ET.SubElement(testsuites, 'testsuite', {
    'name': 'Unreal Automation Tests',
    'tests': str(len(data['tests'])),
    'failures': str(sum(1 for t in data['tests'] if t['state'] != 'Success')),
    'errors': "0",  # Unreal JSON doesn't seem to differentiate between failures and errors
    'skipped': "0",  # We assume no skipped tests since there's no indication in the JSON
    'time': str(data['totalDuration'])
})

# Iterate over each test and create a corresponding testcase in the XML
for test in data['tests']:
    testcase = ET.SubElement(testsuite, 'testcase', {
        'classname': test['fullTestPath'],  # Full test path used as classname
        'name': test['testDisplayName'],  # Test display name used as the test name
        'time': str(test['duration'])  # Duration of the test
    })

    # If the test has warnings or errors, mark it as a warning/failure in JUnit format
    if test['warnings'] > 0 or test['errors'] > 0:
        failure = ET.SubElement(testcase, 'failure', {
            'message': 'Test had warnings or errors',
        })
        # You can add more details about the warnings/errors here if needed
        for entry in test['entries']:
            if entry['event']['type'] == 'Warning':
                failure.text = entry['event']['message']  # Adding the warning message to the failure node
    
    # If the test was not successful, add a failure tag
    if test['state'] != 'Success':
        failure = ET.SubElement(testcase, 'failure', {
            'message': 'Test failed',
        })
        failure.text = 'Test state: ' + test['state']

# Convert the XML tree to a string and save it to a file
tree = ET.ElementTree(testsuites)
tree.write('junit-report.xml', encoding='utf-8', xml_declaration=True)

print("JUnit XML report generated as junit-report.xml!")
