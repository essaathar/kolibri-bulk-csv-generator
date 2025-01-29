# Kolibri Bulk CSV Generator

## Overview
This repository provides a Bash script (`content/script.sh`) to automate the creation of the `Content.csv` file which is used in the [CSV Workflow](https://github.com/learningequality/sample-channels/tree/master/channels/csv_channel) to upload the channel on Kolibri Studio (a product of [Learning Equality](https://learningequality.org/)). It simplifies the initial setup process of the CSV Workflow by automatically populating the required `Content.csv` file based on the structure of a local channel folder.

The script eliminates the need to manually create the `Content.csv` file when preparing content for bulk uploads in Kolibri.

## Features
- Automates the generation of the `Content.csv` files for Kolibri channels.
- Uploads the channel on Kolibri Studio.

## Assumptions (TODO)
- Have Python 3.10 or greater.
- `.env` file present inside `content` folder, in which the `API_TOKEN` is the **Kolibri API Token**, taken from [Account Settings](https://studio.learningequality.org/en/settings/#/account) on Kolibri Studio.
