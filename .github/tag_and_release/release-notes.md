### 🎉🎊🍾 New feature
<hr>

1. Add new reusable workflows.
    * _pre-building_test.yaml_: Running pre-testing by simple way with running _setup.py_ script.
    * _push_pkg_to_pypi.yaml_: Compile Python source code and push the Python package to PyPI.

### 🛠⚙️🔩 **Breaking Change**
<hr>

1. Modify the workflows detail about testing coverage report processing.
    * All report types, e.g., .coverage format data file or XML format report, would be handled and generated in workflow _organize_and_generate_test_cov_reports.yaml_.
    * It only processes uploading testing reports in workflow _upload_test_cov_report.yaml_.

### 🛠🐛💣 **Bug Fix**
<hr>

1. Fix issue of setup processing would fail with Python version 3.6 in runtime OS Ubuntu 22.04.
    * Modify to test code with Python 3.6 version in Ubuntu 20.04.

[//]: # (### 🔬🧪🧬 **Refactor**)
[//]: # (<hr>)

[//]: # ()
[//]: # (1. Upgrade the GitHub Action syntax usage about set-output commands.)

[//]: # ()
[//]: # (    * Change to use environment variable _GITHUB_OUTPUT_.)

[//]: # (    * Refer: https://github.blog/changelog/2022-10-11-github-actions-deprecating-save-state-and-set-output-commands/)

[//]: # ()
[//]: # (2. Upgrade the actions which depends on Node.JS version 12 to newer version.)

[//]: # ()
[//]: # (    * Upgrade _actions/checkout_ to version 3.)

[//]: # (    * Upgrade _actions/setup-python_ to version 4.)

[//]: # (    * Refer: https://github.blog/changelog/2022-09-22-github-actions-all-actions-will-begin-running-on-node16-instead-of-node12/)
