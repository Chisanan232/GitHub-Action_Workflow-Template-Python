[//]: # (### 🎉🎊🍾 New feature)

[//]: # (<hr>)

[//]: # ()
[//]: # (1. Add new options about set up and run a sample HTTP server for testing if it needs in some testing scenario &#40;_run_test_items_via_pytest.yaml_&#41;.)

[//]: # ()
### 🛠⚙️🔩 **Breaking Change**
<hr>

1. Clear the under testing environments or settings to reduce resource.

    1-1. Deprecate and remove some runtime OS versions.

    * Deprecated settings: _ubuntu-18.04_, _ubuntu-20.04_, _ubuntu-22.04_, _macos-10.15_, _macos-11_, _macos-12_
    * New settings: _ubuntu-latest_, _macos-latest_

    1-2. Add more Python version for testing

    * New version: _Python 3.11_

[//]: # (### ⚒⚒💣 **Bug Fix** )

[//]: # (<hr>)

[//]: # ()
[//]: # (1. Fix the issue about uploading test coverage report cannot work at all.)

### 🔬🧪🧬 **Refactor**
<hr>

1. Upgrade the GitHub Action syntax usage about set-output commands.

    * Change to use environment variable _GITHUB_OUTPUT_.
    * Refer: https://github.blog/changelog/2022-10-11-github-actions-deprecating-save-state-and-set-output-commands/

2. Upgrade the actions which depends on Node.JS version 12 to newer version.

    * Upgrade _actions/checkout_ to version 3.
    * Upgrade _actions/setup-python_ to version 4.
    * Refer: https://github.blog/changelog/2022-09-22-github-actions-all-actions-will-begin-running-on-node16-instead-of-node12/
