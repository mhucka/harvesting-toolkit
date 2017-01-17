# Harvesting Toolkit

This package includes a general purpose toolkit for archiving open data. Data harvesters should start by reading this document, which outlines the steps for constructing a proper data archive of the highest possible integrity.

## 1. Checkout URL (Google Sheet)
The archiving event will pass around a link to a shared Spreadsheet documenting a list of urls for classification. Often this list is the work-product of another group tasked with seeding a webcrawler. This list is the starting & ending point for your archiving efforts. Many people will be working from this shared worksheet, so it's important to "checkout" & "checkin" urls as you're working.

Each row of the spreadsheet should contain at least the following fields. The names may be different, and there may be many more view:

| url                                         | id                                   | who's working on this url? |
| ------------------------------------------- | ------------------------------------ | -------------------------- |
| http://www.eia.gov/electricity/data/eia412/ | DAFD2E80-965F-4989-8A77-843DE716D899 | @me                        |

The url is the link to examine, the id is a connonical id we'll use to connect the url with the data in question, and the "who is working on this url?" is the field for checking out. In this example the user @me has indicated as working on the url. A finished copy of this example is included in this repository.

To checkout a url, add your name (or even better, slack username) to the row you're going to work on so that others don't duplicate your work.

## 2. Classify Source Type & archivability
Before doing anything, take a minute to understand what you're looking at. It's usually best to have a quick check of the url to confirm that this data in fact not crawlable. Often as part of the harvesting team, you'll be the first person with a higher level of technical knowledge to review the url in question.

#### Check for false-positives (content that is in fact crawlable).
Generally, any url that returns standard HTML, links to more [HTML mimetype pages][https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types], and contains little-to-no non-html content, it's crawlable. "View source" from your browser of choice will help see what the crawler itself is seeing. If in fact the data can be crawled, make a note as such in the Google sheet, remove your name from the "checkout" column, notify the seeding / crawling team & they will make sure the link is crawled, and move on to another url.

#### Some things to think about while reviewing a url
* Does this page use javascript to render it's content? Crawlers generally cannot parse dynamically-generated content.
* Does this url contain links to non-html content? (For example, zip files, pdfs, excel files, etc...)
* Is this url some sort of interface for a large database or service? (For example, an interactive map, api gateway, etc.)
* Does this url contain instructions for connecting to a server, database, or other special source of data?

### Check the terms of service!!!
Before you go any further, it is *always* worth confirming that the data in question is in fact open for archiving. If the terms of service explicitly prohibit archiving, *make a note of it*. Generally archive-a-thons are purposely only aimed at publically available data, but it is easy to follow a link away from a publically-available source onto a site that has different terms of service.

**Data acquired outside terms of service is not usable**

If there is harvestable data, the next set up a directory (step three), and then choose the appropriate strategy for archiving!

## 3. Generate Html, json & Directory

Before starting it's best to get a directory going for the data you're going to archive. You will be in charge of creating & collecting this structure for each link that's deemed uncrawlable. Using the example from step 1, the structure of the archive will look like so:

	DAFD2E80-965F-4989-8A77-843DE716D899
		├── DAFD2E80-965F-4989-8A77-843DE716D899.html
		├── DAFD2E80-965F-4989-8A77-843DE716D899.json
		├── /tools
		└── /data

Each row in the above is:

	A directory named by the spreadsheet id
		├── a .html "web archive" file of the url for future reference, named with the id
		├── a .json metadata file that contains relevant metadata, named with the id
		├── a /tools directory to include any scripts, notes & files used to acquire the data
		└── a /data directory that contains the data in question


The goal is to pass this finalized folder off for "bagging", as described elsewhere. We repeatedly use the ID so that we can programmatically work through this data later. It is important that the ID be copied *exactly*, with no leading or trailing spaces, and honoring case-sensitivity.

#### [id].html file
The first thing you'll want to create is a html copy of the page in question. The html file gives the archive a snapshot of the page at the time of archiving which we can use to monitor for changing data in the future, and corrobrate the provenance of the archive itself. We can also use the .html in conjunction with the scripts you'll include in the tools directory to replicate the archive in the future. To generate the html file, navigate to your new folder in a terminal window & run the following command:
	
	wget -O DAFD2E80-965F-4989-8A77-843DE716D899.html  http://www.eia.gov/electricity/data/eia412/

You'll replace ```DAFD2E80-965F-4989-8A77-843DE716D899.html``` with the id + .html, and the url with the one you're looking at.

#### [id].json file
The json file is one you'll create by hand to create a machine readable record of the archive. This file contains vital data, including the url that was archived, and date of archiving. the [id.json readme][/docs/id-json.md] goes into much more detail.

### 4a. Identify Data Links & WGET loop with sleep
If you encounter a page that links to lots of data (for example a "downloads" page), this approach may well work. It's important to know Only use this approach when you encounter *data*, for example pdf's, .zip archives, .csv datasets, etc.

The tricky part of this approach is generating a list of urls to download from the page. If you're skilled with using scripts in combination with html-parsers (for example python's wonderful [beautiful-soup package][https://www.crummy.com/software/BeautifulSoup/bs4/doc/#quick-start]), go for it. Otherwise, we've included the [jquery-url-extraction guide][/tools/jquery-url-extraction], which has the advantage of working within a browser & can operate on a page that has been modified by javascript.

The example uses this approach, leveraging the jquery-url extraction method to generate a list of urls to feed the wget loop.

### 4b. FTP download
have a look download_ftp_tree.py, there's example usage & stuff in the file.

### 4c. API scrape / Custom Solution
if you encounter an api, chances are you'll have to build some sort of custom solution, or investigate a social angle, for example: asking someone with greater access for a database dump.

### 5. Write [id].json metadata, add /tools
From there you'll want to fill out the metadata.json, copy any scripts & tools you used into the /tools directory. It may seem strange to copy code multiple times, but this can help later to reconstruct the archiving process for further refinment later on.

It's worth using some judgement here. If a "script" you used includes an entire copy of JAVA, or some suite beyond a simple script, it may be better to document your process in a file & leave that in the tools directory instead.

### 6. Package data
Next you'll ship this packet of data on for "bagging", a process outlined in another document. The method of delivery will be different depending on where you're working. If you're at an archiving event, be sure to ask the organizers what to do with finished data.

#### Leave the data unmodified
During the process you may feel inclined to clean things up, add structure to the data, etc. Avoid temptation. Your finished archive will be hashed so we can compare it later for changes, and it's important that we archive original, unmodified content.

### 7. Mark as Archived (Google Sheet)
Finally, mark your url as archived. Then, stand up, do a happy dance, and move on to the next url!

### Tips
* If you encounter a Search bar, try entering "*" to check to see if that returns "all results".
