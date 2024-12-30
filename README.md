# Kolibri Bulk CSV Generator

## Overview
This repository provides a Bash script (`content/script.sh`) to automate the creation of a `.csv` file for Kolibri channels. It simplifies the initial setup process of the [CSV Workflow](https://github.com/learningequality/sample-channels/tree/master/channels/csv_channel) by automatically populating the required `Content.csv` file based on the structure of a local channel folder.

The script eliminates the need to manually create the `Content.csv` file when preparing content for bulk uploads in Kolibri, a platform by [Learning Equality](https://learningequality.org/).

## Features
- Automates the generation of the `Channel.csv` and `Content.csv` files for Kolibri channels.
- Scans a local folder structure to extract metadata for resources.
- Supports the CSV Workflow for bulk uploading content on Kolibri Studio.

## Prerequisites
- You have a local folder containing your content organized in the desired channel structure, as described in the official [CSV Workflow repository](https://github.com/learningequality/sample-channels/tree/master/channels/csv_channel).
- [Ricecooker](https://github.com/learningequality/ricecooker) is installed.
- Bash is installed on your system.

