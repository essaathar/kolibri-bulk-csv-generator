# Kolibri Bulk CSV Generator

## Overview
This repository provides a Bash script (`content/script.sh`) to automate the creation of a `.csv` file for Kolibri channels. It simplifies the initial setup process of the [CSV Workflow](https://github.com/learningequality/sample-channels/tree/master/channels/csv_channel) by automatically populating the required `Content.csv` file based on the structure of a local channel folder.

The script eliminates the need to manually create the `Content.csv` file when preparing content for bulk uploads in Kolibri, a platform by [Learning Equality](https://learningequality.org/).

## Features
- Automates the generation of the `Channel.csv` and `Content.csv` files for Kolibri channels.
- Uploads the channel on Kolibri Studio.

## Prerequisites
- Python version `3.10>=`
- `ricecooker`
- `ffmpeg`

## Assumptions (TODO)
- `.env` file present inside `content` folder, which has the Kolibri API Token.
