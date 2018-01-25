# Sumo Logic VSTS extension
[![MIT license](https://img.shields.io/badge/License-MIT-blue.svg)](https://lbesson.mit-license.org/)
[<img src="https://teamvibrato.visualstudio.com/_apis/public/build/definitions/1e6c4405-efc3-4c52-b745-7488dce1bf20/14/badge"/>](https://teamvibrato.visualstudio.com/SumoLogic%20VSTS%20extension/_build/index?definitionId=14)
[![Badge for version for VSTS extension vibrato.sumologic-tools](https://vsmarketplacebadge.apphb.com/version/vibrato.sumologic-tools.svg)](https://marketplace.visualstudio.com/items?itemName=vibrato.sumologic-tools)

This extension contains build tasks that interact with the Sumo Logic API.

## Getting started

If you plan to package this extension for use in your own environment, get:

1. [Node.js](https://nodejs.org)
2. [Team Foundation command line interface](https://github.com/Microsoft/tfs-cli) (`npm install -g tfx-cli`)

Run `tfx extension create --manifest-globs vss-extension.json` to compile a VSIX file that can be installed into your VSTS/TFS account.

## Creating new build tasks

1. Create a subfolder with a `task.json` and `icon.png`
```
├── new-task
│   ├── icon.png
│   └── task.json
```
2. Make a reference to `new-task` in `vss-extension.json`

More details on developing build tasks [here](https://docs.microsoft.com/en-us/vsts/extend/develop/add-build-task).

## Contributing
Refer to CONTRIBUTING.md