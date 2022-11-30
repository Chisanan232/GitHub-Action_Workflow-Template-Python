import setuptools
import os


here = os.path.abspath(os.path.dirname(__file__))


about = {}
with open(os.path.join(here, "test_gh_workflow", "__pkg_info__.py"), "r", encoding="utf-8") as f:
    exec(f.read(), about)


with open("README.md", "r") as fh:
    readme = fh.read()


setuptools.setup(
    name="Test GitHub Action workflow",
    version=about["__version__"],
    author="Bryant Liu",
    license="Apache License 2.0",
    description="This is a testing package of GitHub Action reusable workflow",
    long_description=readme,
    long_description_content_type="text/markdown",
    packages=setuptools.find_packages(exclude=("test",)),
    package_dir={"test_gh_workflow": "test_gh_workflow"},
    zip_safe=False,
    classifiers=[
        "Development Status :: 3 - Alpha",
        "Intended Audience :: Developers",
        "Topic :: Software Development :: Libraries :: Python Modules",
        "License :: OSI Approved :: Apache Software License",
        "Operating System :: OS Independent",
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.6",
        "Programming Language :: Python :: 3.7",
        "Programming Language :: Python :: 3.8",
        "Programming Language :: Python :: 3.9",
        "Programming Language :: Python :: 3.10",
        "Programming Language :: Python :: 3.11",
    ],
    python_requires='>=3.6',
    project_urls={
        "Source": "https://github.com/Chisanan232/GitHub-Action_Reusable_Workflows-Python",
    },
)
