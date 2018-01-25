# Sumo Logic VSTS extension

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