from os.path import dirname
from setuptools import setup

import os

try:
    # for pip >= 10
    from pip._internal.req import parse_requirements
except ImportError:
    # for pip <= 9.0.3
    from pip.req import parse_requirements


def load_requirements(fname):
    reqs = parse_requirements(fname, session="test")
    return [str(ir.req) for ir in reqs]


version_file = os.path.join(dirname(os.path.abspath(__file__)), 'src', 'RobotFrameworkElasticSearchLibrary', 'version.py')

with open(version_file) as file:
    code = compile(file.read(), version_file, 'exec')
    exec(code)

# The directory containing this file
with open(os.path.join(os.path.dirname(__file__), "README.md")) as r_file:
    readme = r_file.read()

# This call to setup() does all the work
setup(
    name="RobotFrameworkElasticSearchLibrary",
    version=__version__,
    description="Robot Framework ElasticSearch library.",
    long_description=readme,
    long_description_content_type="text/markdown",
    url="https://github.com/gianpaolocaprara/robotframework-elasticsearch",
    author="Gianpaolo Caprara",
    author_email="gianpaolo.caprara@gmail.com",
    license="MIT",
    keywords=['ROBOTFRAMEWORK', 'ELASTICSEARCH'],
    classifiers=[
        "License :: OSI Approved :: MIT License",
        "Programming Language :: Python :: 3.6",
        "Programming Language :: Python :: 3.7",
        "Programming Language :: Python :: 3.8",
    ],
    packages=["RobotFrameworkElasticSearchLibrary"],
    package_data={'RobotFrameworkElasticSearchLibrary': ['tests/*.txt']},
    package_dir={'': 'src'},
    include_package_data=True,
    install_requires=load_requirements("requirements/install.txt"),
)
