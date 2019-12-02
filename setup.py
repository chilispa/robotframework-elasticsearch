import pathlib
from setuptools import setup
from RobotFrameworkElasticSearchLibrary import __version__

# The directory containing this file
HERE = pathlib.Path(__file__).parent

# The text of the README file
README = (HERE / "README.md").read_text()

INSTALL_REQUIRES = [
    'robotframework;python_version=="3.1.2"',
    'elasticsearch;python_version=="6.4.0"'
]

# This call to setup() does all the work
setup(
    name="RobotFrameworkElasticSearchLibrary",
    version=__version__,
    description="Robot Framework ElasticSearch library.",
    long_description=README,
    long_description_content_type="text/markdown",
    url="https://github.com/gianpaolocaprara/robotframework-elasticsearch",
    download_url = f'https://github.com/gianpaolocaprara/robotframework-elasticsearch/archive/{__version__}.tar.gz',
    author="Gianpaolo Caprara",
    author_email="gianpaolo.caprara@gmail.com",
    license="MIT",
    keywords = ['ROBOTFRAMEWORK', 'ELASTICSEARCH'],
    classifiers=[
        "License :: OSI Approved :: MIT License",
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.6",
        "Programming Language :: Python :: 3.7",
    ],
    packages=["RobotFrameworkElasticSearchLibrary"],
    include_package_data=True,
    install_requires=INSTALL_REQUIRES,
)