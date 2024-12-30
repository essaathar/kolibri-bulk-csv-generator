CSV Workflow
============

Alternative approach for specifying the metadata for content nodes uploaded using
the ricecooker library (bulk upload of files with metadata prepared in Spreadsheet).
  - source content files loaded from the local file system
  - channel structure from the filesystem hierarchy
  - metadata from two manually curated/edited CSV files:
      - Channel metadata provided in `Chaannel.csv`
      - Content node metadata provided in `Content.csv`


Inputs:
  - Channel files are organized into a directory hierarchy on the local filesystem
  - Supported formats are `document`(PDF), `audio` (mp3), `video` (mp4), and `html5` (zip),
     but not exercises (see `csv_exercises` sample channel for that).
  - Channel metadata provided in `Chaannel.csv`
  - Files metadata provided in `Content.csv`



Use case
--------
  - Good interface for both developers and content experts.
  - Developers must populate a directory structure containing different content nodes
    and ensure the appropriate metadata is in `Channel.csv` and `Content.csv`.
  - Content experts can author, edit, and Q/A titles, descriptions, and other
    metadata without the need for support from developers.



Metadata details
----------------

### Files
All content files and thumnails must be organized as nested folders on the file system:

    content/
    ├── Channel.csv
    ├── Content.csv
    └── sample-csv-channel-root
        ├── channel_thumbnail.jpg
        └── contentnodes
            ├── audio
            │   └── Whale_sounds.mp3
            ├── document
            │   └── commonlit_the-supreme-court-s-ruling-in-brown-vs-board-of-education_student.pdf
            ├── html5
            │   ├── html5_react.jpg
            │   ├── html5_react.zip
            │   ├── html5_vuejs.jpg
            │   ├── html5_vuejs.zip
            │   ├── html5_wget_scraped.jpg
            │   └── html5_wget_scraped.zip
            └── video
                └── Wave_particle_duality.mp4


### Channel metadata
Channel metadata must be provided the file `Channel.csv` which should live next
to the channel root folder. The channel metadata fields are:
  - `Title`: The name of the channel as it will shown to users.
  - `Description`: Channel description used by curators when looking through channels.
  - `Domain`: The domain of the organization providing the content, e.g. `learningequality.org`
  - `Source ID`: A unique machine-readable identifier for this channel within domain, e.g., `eduvideos`
  - `Language`: A two-letter or three-letter code used by Kolibri for language
     representation: [see full list here](https://github.com/learningequality/le-utils/blob/master/le_utils/resources/languagelookup.json).
  - `Thumbnail`: path to a thumbnail file for the channel (will be displayed when browsing channels, optional)

### Content metadata
For each file in the directory structure, an appropriate metadata entry must be
provided in the file `Content.csv`:
  - `Path *`: File or directory path relative to the root of the zip file for
    for which this line in the CSV applied.
  - `Title *`: The title of the folder or content node that will be shown to users.
  - `Source ID`: The unique identifier used on source website or DB (optional)
    Set this to the primary key for the content item if the content comes from a
    database, or a unique path segment or slug if we content comes from a website.
  - `Description`: Content item and folder descriptions to be displayed to users.
  - `Author`: The author of the content (optional)
  - `Language`: A two-letter or three-letter code used by Kolibri for language
     representation: [see full list here](https://github.com/learningequality/le-utils/blob/master/le_utils/resources/languagelookup.json).
  - `License ID *`: This column indicates the license type and is required for all
    content items (files). License ID must one of the following: `CC BY`, `CC BY-SA`,
    `CC BY-ND`, `CC BY-NC`, `CC BY-NC-SA`, `CC BY-NC-ND`, `All Rights Reserved`,
    `Public Domain`, or `Special Permissions`.
    If the `Special Permissions` key is used, the details of the license information
    must be provided in the column `License Description`, else the column `License Description`
    can be left blank.
  - `Copyright Holder`: specifies the copyright holder for content items.
    This field is required for all licenses except `Public Domain`.
  - `Thumbnail`: path to thumbnail image for the content item or folder (optional)



Install
-------

    virtualenv -p python3  venv
    source venv/bin/activate
    pip install -r requirements.txt


Usage
-----

    ./linecook.py --token=<STUDIO_API_TOKEN> --channeldir='./content/sample-csv-channel-root'

If you get an error when running the linecook script (in the end), you might
have to change the channel source id in `Channel.csv`, or ask the LE team to
make you an editor for the channel with this source id.

This above commands will create or update the channel on Kolibri Studio. As part
of the upload process, the file `chefdata/trees/ricecooker_json_tree.json` which
shows the exact data and metadata that was uploaded to Kolibri Studio. You can use
this file to debug all kinds of problems: missing descriptions, bad formats, etc.

# kolibri-bulk-csv-generator
