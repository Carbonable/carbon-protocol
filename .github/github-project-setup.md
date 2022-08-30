# Github Project Setup

## Github labels
### Install

Install with [npm](https://www.npmjs.com/):

    npm install --global @azu/github-label-setup

### Usage

This tool works without any configuration.

    Usage
      $ github-label-setup --token xxx --labels carbonable_labels.json


**WARNING**: *token* => Personal GitHub Access Token. Create one called "Labeler" [here](https://github.com/settings/tokens) with the following permissions: `repo` and `admin:org`.

    Options

      -h, --help                  [Boolean] output usage information
      -l, --labels <path>         [Path:String] the path to look for the label configuration in. Default: labels.json
      --token <token>             [String] a GitHub access token (also settable with a GITHUB_ACCESS_TOKEN environment variable)
      -d, --dry-run               [Boolean] calculate the required label changes but do not apply them
      -A, --allow-added-labels    [Boolean] allow additional labels in the repo, and don't delete them

## Github Issue Template

[Configuring issue templates for your repository](https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/configuring-issue-templates-for-your-repository)


### Configuration

The config files for all issue Template of this project are store in `.github/ISSUE_TEMPLATE/` directory. 
