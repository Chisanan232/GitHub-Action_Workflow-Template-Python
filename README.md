# GitHub Action - Workflow template for Python library

[![github-action reusable workflows test](https://github.com/Chisanan232/GitHub-Action-Template-Python/actions/workflows/test-reusable-workflows.yaml/badge.svg)](https://github.com/Chisanan232/GitHub-Action-Template-Python/actions/workflows/test-reusable-workflows.yaml)
[![Release](https://img.shields.io/github/release/Chisanan232/GitHub-Action-Template-Python.svg?label=Release&logo=github)](https://github.com/Chisanan232/GitHub-Action-Template-Python/releases)
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

* [_prepare_test_items.yaml_](#prepare_test_itemsyaml)
* [_run_test_items_via_pytest.yaml_](#run_test_items_via_pytestyaml)
* [_organize_and_generate_testing_coverage_reports.yaml_](#organize_and_generate_testing_coverage_reportsyaml)
* [_upload_test_report_to_codecov.yaml_](#upload_test_report_to_codecovyaml)
* [_upload_code_report_to_codacy.yaml_](#upload_code_report_to_codacyyaml)


#### _prepare_test_items.yaml_

* Description: Prepare the test items.
* Options:

| option name | option is optional or required | function content                                     |
|-------------|--------------------------------|------------------------------------------------------|
| shell_path  | Required                       | The path shell script for getting the testing items. |
| shell_arg   | Required                       | Input arguments of the shell script.                 |

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

| option name             | option is optional or required       | function content                                                                           |
|-------------------------|--------------------------------------|--------------------------------------------------------------------------------------------|
| test_type               | Required                             | The testing type. In generally, it only has 2 options: _unit-test_ and _integration-test_. |
| all_test_items_paths    | Required                             | The target paths of test items under test.                                                 |
| setup_http_server       | Optional, Default value is _false_   | If it's true, it would set up and run HTTP server for testing.                             |
| http_server_host        | Optional, Default value is _0.0.0.0_ | The host IPv4 address of HTTP server.                                                      |
| http_server_port        | Optional, Default value is _12345_   | The port number of HTTP server.                                                            |
| http_server_app_module  | Optional, Default value is _app_     | The module path of HTTP server.                                                            |
| http_server_enter_point | Optional, Default value is _app_     | The object about the web application.                                                      |

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
      setup_http_server: true
      http_server_host: 0.0.0.0
      http_server_port: 30303
      http_server_app_module: test._http_server.app
      http_server_enter_point: app
```

Please take a look of option _all_test_items_paths_. You could find that it get the input result of 
previous workflow _prepare-testing-items_unit-test_ via below way:

    ${{needs.prepare-testing-items_unit-test.outputs.all_test_items}}

Character part _needs.prepare-testing-items_unit-test_ means it want to get something context info 
from needed workflow _prepare-testing-items_unit-test_, and the context it wants to get is _outputs_. 
And be more essentially, what outputs it want to use? It's _all_test_items_. Do you discover this keyword 
is provided by previous workflow? That is all testing items.

<hr>

#### _organize_and_generate_testing_coverage_reports.yaml_

* Description: Organize all the testing coverage reports which be generated in different runtime OS with Python version. (it would save reports by _actions/upload-artifact@v3_).
* Options:

| option name                 | option is optional or required | function content                                                                                                                                                              |
|-----------------------------|--------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| test_type                   | Required                       | The testing type. In generally, it only has 2 options: _unit-test_ and _integration-test_.                                                                                    |

* Output: 

No, but it would save the testing coverage reports (coverage_<test_type>.xml) to provide after-process to organize and record.

* How to use it?

```yaml
  unit-test_codecov:
#    name: Organize and generate the testing report and upload it to Codecov
    needs: run_unit-test
    uses: Chisanan232/GitHub-Action-Template-Python/.github/workflows/organize_and_generate_testing_coverage_reports.yaml@master
    with:
      test_type: unit-test
```

It would upload the organized report via _actions/upload-artifact@v3_. And it doesn't support customize options of _actions/upload-artifact@v3_ currently.

<hr>

#### _upload_test_report_to_codecov.yaml_

* Description: Upload the testing coverage reports to Codecov.
* Options:

It has 2 different types option could use:

_General option_:

| option name   | option is optional or required | function content                                                                           |
|---------------|--------------------------------|--------------------------------------------------------------------------------------------|
| download_path | Required                       | The path to download testing coverage reports via _actions/download-artifact@v3_.          |
| test_type     | Required                       | The testing type. In generally, it only has 2 options: _unit-test_ and _integration-test_. |
| codecov_flags | Required                       | The flags of the testing coverage report for Codecov.                                      |
| codecov_name  | Required                       | The name of the testing coverage report for Codecov.                                       |

_Secret option_:

| option name   | option is optional or required | function content                                                |
|---------------|--------------------------------|-----------------------------------------------------------------|
| codecov_token | Required                       | The API token for uploading testing coverage report to Codecov. |

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

| option name   | option is optional or required | function content                                                                           |
|---------------|--------------------------------|--------------------------------------------------------------------------------------------|
| download_path | Optional                       | The path to download testing coverage reports via _actions/download-artifact@v3_.          |
| test_type     | Required                       | The testing type. In generally, it only has 2 options: _unit-test_ and _integration-test_. |

_Secret option_:

| option name  | option is optional or required | function content                                               |
|--------------|--------------------------------|----------------------------------------------------------------|
| codacy_token | Required                       | The API token for uploading testing coverage report to Codacy. |

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
      test_type: all-test
```

* The badges would be generated after this workflow done:

[![Codacy Badge](https://app.codacy.com/project/badge/Grade/e8bfcd5830ba4232b45aca7c2d3e6310)](https://www.codacy.com/gh/Chisanan232/GitHub-Action-Template-Python/dashboard?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=Chisanan232/GitHub-Action-Template-Python&amp;utm_campaign=Badge_Grade)
[![Codacy Badge](https://app.codacy.com/project/badge/Coverage/e8bfcd5830ba4232b45aca7c2d3e6310)](https://www.codacy.com/gh/Chisanan232/GitHub-Action-Template-Python/dashboard?utm_source=github.com&utm_medium=referral&utm_content=Chisanan232/GitHub-Action-Template-Python&utm_campaign=Badge_Coverage)

<hr>
