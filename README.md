# GitHub Action - Workflow template for Python library

[![github-action reusable workflows test](https://github.com/Chisanan232/GitHub-Action-Template-Python/actions/workflows/test-reusable-workflows.yaml/badge.svg)](https://github.com/Chisanan232/GitHub-Action-Template-Python/actions/workflows/test-reusable-workflows.yaml)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg?logo=apache)](https://opensource.org/licenses/Apache-2.0)


This is a GitHub Action workflow template for **_Python library_** project.

[Overview](#overview) | [Workflow template usages](#workflow-template-usages)
<hr>

## Overview

In development of Python library, it configures the mostly same CI/CD processes again and again. That's the reason why I consider and implement 
this project. This project has some workflow templates for reusing in GitHub Action CI/CD processes so that it could reach some benefits:
* Be more clear what thing to do in a job.
* Be more clear and simpler of entire CI/CD work flow.
* Be easier to read and configure at configurations of GitHub Action work flow.
* It has greatly improved the GitHub Action configuration to be more reusable in multiple different projects (git repositories).


## Workflow template usages

The usage of each workflow template.

* [_prepare_test_items.yaml_](#_prepare_test_itemsyaml_)
* [_run_test_items_via_pytest.yaml_](#_run_test_items_via_pytestyaml_)
* [_organize_all_testing_coverage_reports_with_different_os_and_py_version.yaml_](#_organize_all_testing_coverage_reports_with_different_os_and_py_versionyaml_)
* [_organize_all_testing_reports_with_different_test_type.yaml_](#_organize_all_testing_reports_with_different_test_typeyaml_)
* [_upload_test_report_to_codecov.yaml_](#_upload_test_report_to_codecovyaml_)
* [_upload_code_report_to_codacy.yaml_](#_upload_code_report_to_codacyyaml_)


#### _prepare_test_items.yaml_

* Description: Prepare the test items.
* Options:

| option name | function content                                     |
|-------------|------------------------------------------------------|
| shell_path  | The path shell script for getting the testing items. |
| shell_arg   | Input arguments of the shell script.                 |

* Output: 
  * all_test_items: All the test items it would run.

* How to use it?

Before use this workflow, it should prepare a shell script for getting the testing items.

```yaml
  prepare-testing-items_unit-test:
#    name: Prepare all unit test items
    uses: Chisanan232/GitHub-Action-Template-Python/.github/workflows/prepare_test_items.yaml@master
    with:
      shell_path: scripts/ci/get-unit-test-paths.sh
      shell_arg: unix
```

And we could get this workflow output result via keyword _all_test_items_.

<hr>

#### _run_test_items_via_pytest.yaml_

* Description: Run testing by specific type with all test items via PyTest and generate its testing coverage report (it would save reports by _actions/upload-artifact@v3_).
* Options:

| option name          | function content                                                                           |
|----------------------|--------------------------------------------------------------------------------------------|
| test_type            | The testing type. In generally, it only has 2 options: _unit-test_ and _integration-test_. |
| all_test_items_paths | The target paths of test items under test.                                                 |

* Output: 

No, but it would save the testing coverage reports to provide after-process to organize and record.

* How to use it?

```yaml
  run_unit-test:
#    name: Run all unit test items
    needs: prepare-testing-items_unit-test
    uses: Chisanan232/GitHub-Action-Template-Python/.github/workflows/run_test_items_via_pytest.yaml@master
    with:
      test_type: unit-test
      all_test_items_paths: ${{needs.prepare-testing-items_unit-test.outputs.all_test_items}}
```

Please take a look of option _all_test_items_paths_. You could find that it get the input result of 
previous workflow _prepare-testing-items_unit-test_ via below way:

    ${{needs.prepare-testing-items_unit-test.outputs.all_test_items}}

Character part _needs.prepare-testing-items_unit-test_ means it want to get something context info 
from needed workflow _prepare-testing-items_unit-test_, and the context it wants to get is _outputs_. 
And be more essentially, what outputs it want to use? It's _all_test_items_. Do you discover this keyword 
is provided by previous workflow? That is all testing items.

<hr>

#### _organize_all_testing_coverage_reports_with_different_os_and_py_version.yaml_

* Description: Organize all the testing coverage reports. (it would save reports by _actions/upload-artifact@v3_).
* Options:

| option name                 | function content                                                                                                                                                              |
|-----------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| test_type                   | The testing type. In generally, it only has 2 options: _unit-test_ and _integration-test_.                                                                                    |
| generate_xml_report_finally | Something, it only has 1 test type currently. So it could let this option to be 'true' than it would generate XML report finally to let uploading process to use it directly. |

* Output: 

No, but it would save the testing coverage reports (coverage.xml) to provide after-process to organize and record.

* How to use it?

```yaml
  unit-test_codecov:
#    name: Organize and generate the testing report and upload it to Codecov
    needs: run_unit-test
    uses: Chisanan232/GitHub-Action-Template-Python/.github/workflows/organize_all_testing_coverage_reports_with_different_os_and_py_version.yaml@master
    with:
      test_type: unit-test
      generate_xml_report_finally: true
```

It would upload the organized report via _actions/upload-artifact@v3_. And it doesn't support customize options of _actions/upload-artifact@v3_ currently.

<hr>

#### _organize_all_testing_reports_with_different_test_type.yaml_

* Description: Organize all the testing coverage reports. (it would save reports by _actions/upload-artifact@v3_).
* Options:

It has no input parameter.

* Output: 

No, but it would save the testing coverage reports (coverage.xml) to provide after-process to organize and record.

* How to use it?

```yaml
  organize_all-test_codecov_and_generate_report:
#    name: Organize and generate the testing report and upload it to Codecov
    needs: [unit-test_codecov, integration-test_codecov]
    uses: Chisanan232/GitHub-Action-Template-Python/.github/workflows/organize_all_testing_reports_with_different_test_type.yaml@master
```

This workflow is very close with another workflow _organize_all_testing_coverage_reports_with_different_os_and_py_version.yaml_. 
But they're different. In a software test, it may have one or more test types it would run to check the software quality. 
So let us consider below 2 scenarios: 

First scenario, it has only one test. So the CI workflow would be like below:

    get test items -> run test -> organize and generate testing report

Second one, it has 2 tests: _Unit test_ and _Integration test_: 

    get unit test items -> run unit test -> organize unit test report ------------------------
                                                                                             |-> organize and generate final test report
    get integration test items -> run integration test -> organize integration test report ---

So it should organize testing coverage reports twice, first time is organizing report with one specific test type, 
another one time is organizing these 2 test types reports.
Hence, the different is: 
* _organize_all_testing_coverage_reports_with_different_os_and_py_version.yaml_ is the first process to organize testing coverage reports. 
  And it could set option _generate_xml_report_finally_ as _true_ to let the CI workflow be more clear and simpler if it has only one test type.
* _organize_all_testing_reports_with_different_test_type.yaml_ is the second organizing process if it has 2 more test types in CI workflow.

<hr>

#### _upload_test_report_to_codecov.yaml_

* Description: Upload the testing coverage reports to Codecov.
* Options:

It has 2 different types option could use:

_General option_:

| option name   | function content                                                                  |
|---------------|-----------------------------------------------------------------------------------|
| download_path | The path to download testing coverage reports via _actions/download-artifact@v3_. |
| codecov_flags | The flags of the testing coverage report for Codecov.                             |
| codecov_name  | The name of the testing coverage report for Codecov.                              |

_Secret option_:

| option name   | function content                                                |
|---------------|-----------------------------------------------------------------|
| codecov_token | The API token for uploading testing coverage report to Codecov. |

* Output: 

Nothing.

* How to use it?

Before run this workflow, please make sure testing coverage report is ready.

```yaml
  codecov_finish:
#    name: Organize and generate the testing report and upload it to Codecov
    needs: [unit-test_codecov]
    uses: Chisanan232/GitHub-Action-Template-Python/.github/workflows/upload_test_report_to_codecov.yaml@master
    secrets:
      codecov_token: ${{ secrets.CODECOV_TOKEN }}
    with:
      download_path: ./
      codecov_flags: unittests
      codecov_name: smoothcrawler-cluster_github-actions_test # optional
```

* The badges would be generated after this workflow done:

[![codecov](https://codecov.io/gh/Chisanan232/GitHub-Action-Template-Python/branch/master/graph/badge.svg?token=wbPgJ4wxOl)](https://codecov.io/gh/Chisanan232/GitHub-Action-Template-Python)

<hr>

#### _upload_code_report_to_codacy.yaml_

* Description: Upload the testing coverage reports to Codacy.
* Options:

It has 2 different types option could use:

_General option_:

| option name   | function content                                                                  |
|---------------|-----------------------------------------------------------------------------------|
| download_path | The path to download testing coverage reports via _actions/download-artifact@v3_. |

_Secret option_:

| option name  | function content                                               |
|--------------|----------------------------------------------------------------|
| codacy_token | The API token for uploading testing coverage report to Codacy. |

* Output: 

Nothing.

* How to use it?

Before run this workflow, please make sure testing coverage report is ready.

```yaml
  codacy_finish:
#    name: Upload test report to Codacy to analyse and record code quality
    needs: [unit-test_codecov]
    uses: Chisanan232/GitHub-Action-Template-Python/.github/workflows/upload_code_report_to_codacy.yaml@master
    secrets:
      codacy_token: ${{ secrets.CODACY_PROJECT_TOKEN }}
    with:
      download_path: ./
```

* The badges would be generated after this workflow done:

[![Codacy Badge](https://app.codacy.com/project/badge/Grade/e8bfcd5830ba4232b45aca7c2d3e6310)](https://www.codacy.com/gh/Chisanan232/GitHub-Action-Template-Python/dashboard?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=Chisanan232/GitHub-Action-Template-Python&amp;utm_campaign=Badge_Grade)
[![Codacy Badge](https://app.codacy.com/project/badge/Coverage/e8bfcd5830ba4232b45aca7c2d3e6310)](https://www.codacy.com/gh/Chisanan232/GitHub-Action-Template-Python/dashboard?utm_source=github.com&utm_medium=referral&utm_content=Chisanan232/GitHub-Action-Template-Python&utm_campaign=Badge_Coverage)

<hr>
