### 🎉🎊 **New feature**
<hr>

1. Improve the reusable workflow and extract some common logic as new reusable workflows.
    * _rw_run_test.yaml_: Extract the logic about matrix values part.
    * _rw_run_test_with_multi_py_versions.yaml_: Use matrix to run test with multiple Python versions with different runtime OS.
    * _rw_poetry_run_test.yaml_: Extract the logic about matrix values part. (Same with _rw_run_test.yaml_ but use **Poetry**)
    * _rw_poetry_run_test_with_multi_py_versions.yaml_: Use matrix to run test with multiple Python versions with different runtime OS. (Same with _rw_run_test_with_multi_py_versions.yaml_ but use **Poetry**)

### 🛠⚙️ **Breaking Change**
<hr>

1. Reusable workflows would ONLY run one Python version with one specific runtime OS.
    * The reusable workflows which would be effected:
        * _rw_run_test.yaml_
        * _rw_poetry_run_test.yaml_

### 🤖⚙️🔧 **Improvement**
<hr>

1. Upgrade the actions in workflow.
   * ``actions/checkout``
   * ``actions/setup-python``

2. Fix the issue about warning message it should upgrade _pip_.
   * Detail error message: ``[notice] A new release of pip is available: 23.0.1 -> 24.0 [notice] To update, run: python3.10 -m pip install --upgrade pip``.

3. Let shell script about combining test coverage reports could be more flexible.
   * Remove the limitation of the test type must be ``unit-test``, ``integration-test`` or ``system-test``.
