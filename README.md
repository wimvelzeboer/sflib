# A Library of reusable Salesforce components

A library of reusable components for the [Salesforce](https://www.salesforce.com) platform.

**Dependencies:**<br/>
This extension package is dependent on the following packages:
- [fflib-apex-mocks](https://github.com/apex-enterprise-patterns/fflib-apex-mocks)
- [fflib-apex-common](https://github.com/apex-enterprise-patterns/fflib-apex-common)
- [fflib-apex-extensions](https://github.com/wimvelzeboer/fflib-apex-extensions)

## Installation

The package is available as an Unlocked Managed Package (2GP) with package ID `0HoJ8000000KyjkKAC`.

Either clone the repository and import the package manually, use the [Package Installation URL](https://login.salesforce.com/packaging/installPackage.apexp?p0=04t000000000000000)
or execute the following SFDX CLI command in your terminal:
```bash
sf package install --package 04t000000000000000 --wait=10 --target-org $YOUR_ORG_ALIAS
```
_Replace `$YOUR_ORG_ALIAS` with the alias of your target org_

## Package version log

| Package version | Package ID         | Description                    |
|-----------------|--------------------|--------------------------------|
