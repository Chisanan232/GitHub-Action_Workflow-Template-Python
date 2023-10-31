### 🎉🎊 New feature
<hr>

1. Add new reusable workflows.
    * _rw_poetry_run_test.yaml_: Running tests by PyTest through **_Poetry_**.
    * _rw_sonarqube_scan.yaml_: Trigger SonarQube to scan project.

2. Improve the shell script about getting all tests.
    * _rw_get_tests.yaml_: It could scan and get all test paths automatically without manually configure test directory path.

3. Add GitHub dependencies bot for managing GitHub Action dependencies automatically.

### 🛠⚙️ **Breaking Change**
<hr>

1. Rename all reusable workflows to be more clear and simple and rule the naming.
    * If it's reusable workflow, it should be named start with ``rw_``.
    * If it's CI process for testing, it should be named start with ``test_``.
    * Below are the renaming of all reusable workflows:
        * _prepare_test_items.yaml_ -> _rw_get_tests.yaml_
        * _run_test_items_via_pytest.yaml_ -> _rw_run_test.yaml_
        * _poetry_run_test_via_pytest.yaml_ -> _rw_poetry_run_test.yaml_
        * _organize_and_generate_test_cov_reports.yaml_ -> _rw_organize_test_cov_reports.yaml_
        * _upload_test_cov_report.yaml_ -> _rw_upload_test_cov_report.yaml_
        * _sonarqube_scan.yaml_ -> _rw_sonarqube_scan.yaml_
        * _pre-building_test.yaml_ -> _rw_pre-building_test.yaml_
        * _build_git-tag_and_create_github-release.yaml_ -> _rw_build_git-tag_and_create_github-release.yaml_
        * _push_pkg_to_pypi.yaml_ -> _rw_push_pypi.yaml_

2. Modify the git event listening condition of testing CI process which would only be run at some key point git event.

### 🛠🐛 **Bug Fix**
<hr>

1. Fix issue of generating incorrect git tag from software version info.

### 🧪🧬 **Refactor**
<hr>

1. Refactor the shell script for building git tag and GitHub release info.
