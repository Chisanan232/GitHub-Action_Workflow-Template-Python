### 🎉🎊 **New feature**
<hr>

1. Improve the CI part about parsing and generating version info in reusable workflow.
    * as is:
        * previous release version value: only ``vx``, i.e., ``v6``.
    * to be:
        * latest release version value: ``vx`` or ``vx.x``, i.e., ``v6`` or ``v6.2``.

### 🛠⚙️ **Breaking Change**
<hr>

1. Fix the CI issue about it cannot upload test coverage reports into Action Artifact because they all are hidden files.
    * The reusable workflows which would be effected:
        * _rw_run_test.yaml_
        * _rw_poetry_run_test.yaml_
        * _rw_organize_test_cov_reports.yaml_
