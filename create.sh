#!/bin/bash

# Check if the Course name is provided as an argument
if [ $# -eq 0 ]; then
  echo "Please provide a Course name as an argument."
  exit 1
fi

# Extract the Course name from the argument
COURSE_NAME=$1

# Convert the course name to lowercase for the file names
COURSE_NAME_LOWER=$(echo $COURSE_NAME | tr '[:upper:]' '[:lower:]')

# Generate the directory paths
VIEW_DIR="lib/view"
VIEW_MODEL_DIR="lib/view_models"
TEST_DIR="test/view_model"

# Create the directories if they don't exist
mkdir -p "$VIEW_DIR"
mkdir -p "$VIEW_MODEL_DIR"
mkdir -p "$TEST_DIR"

# Generate the file paths with proper suffixes
VIEW_FILE="${VIEW_DIR}/${COURSE_NAME_LOWER}_view.dart"
VIEW_MODEL_FILE="${VIEW_MODEL_DIR}/${COURSE_NAME_LOWER}_model.dart"
TEST_FILE="${TEST_DIR}/${COURSE_NAME_LOWER}_view_model_test.dart"

# Create the files and add the import statements and class declarations
echo "import 'package:flutter/material.dart';" > "$VIEW_FILE"
echo "import 'package:ii_console/view_models/${COURSE_NAME_LOWER}_model.dart';" >> "$VIEW_FILE"
echo "import 'package:stacked/stacked.dart';" >> "$VIEW_FILE"
echo "" >> "$VIEW_FILE"
echo "class ${COURSE_NAME}View extends StatelessWidget {" >> "$VIEW_FILE"
echo "  @override" >> "$VIEW_FILE"
echo "  Widget build(BuildContext context) {" >> "$VIEW_FILE"
echo "    return ViewModelBuilder<${COURSE_NAME}ViewModel>.reactive(" >> "$VIEW_FILE"
echo "      viewModelBuilder: ()=> ${COURSE_NAME}ViewModel()..init()," >> "$VIEW_FILE"
echo "      builder: (context, model, child) {" >> "$VIEW_FILE"
echo "        return Scaffold(" >> "$VIEW_FILE"
echo "          body: Center(child: Text('${COURSE_NAME}View'))," >> "$VIEW_FILE"
echo "        );" >> "$VIEW_FILE"
echo "      },);" >> "$VIEW_FILE"
echo "  }" >> "$VIEW_FILE"
echo "}" >> "$VIEW_FILE"

echo "import 'package:stacked/stacked.dart';" > "$VIEW_MODEL_FILE"
echo "" >> "$VIEW_MODEL_FILE"
echo "class ${COURSE_NAME}ViewModel extends BaseViewModel {" >> "$VIEW_MODEL_FILE"
echo "  init(){}" >> "$VIEW_MODEL_FILE"
echo "}" >> "$VIEW_MODEL_FILE"

echo "import 'package:flutter_test/flutter_test.dart';" > "$TEST_FILE"
echo "import '../../lib/view_models/${COURSE_NAME_LOWER}_model.dart';" >> "$TEST_FILE"
echo "" >> "$TEST_FILE"
echo "main() {" >> "$TEST_FILE"
echo "  var cat = ${COURSE_NAME}ViewModel();" >> "$TEST_FILE"
echo "" >> "$TEST_FILE"
echo "  setUp(() {" >> "$TEST_FILE"
echo "    cat = ${COURSE_NAME}ViewModel();" >> "$TEST_FILE"
echo "  });" >> "$TEST_FILE"
echo "" >> "$TEST_FILE"
echo "  group('${COURSE_NAME}ViewModel can', () {" >> "$TEST_FILE"
echo "    test('initialize', () {" >> "$TEST_FILE"
echo "      cat.init();" >> "$TEST_FILE"
echo "    });" >> "$TEST_FILE"
echo "  });" >> "$TEST_FILE"
echo "}" >> "$TEST_FILE"

# Display success message
echo "Course files generated successfully."
