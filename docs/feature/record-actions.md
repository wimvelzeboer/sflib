# Record Actions

The record actions feature allows you to offer a list of actions to users on a record.

A record action is an action that can be performed on a record, by invoking a screen-flow. Listed actions are filtered based on a configured set of criteria.

The actions are displayed in a list or tiles view. It can contain an action menu at the top right corner, when there are items to show (eg. history is enabled or the current user is an record action manager).

![List View](./docs/feature/record-action_list-view.png "List View")

![tiles](./docs/feature/record-action_tile-view.png "Tiles View")


## Configurational options
Record actions can be configured to in the `Record Actions Setup` App.

![Record Actions Setup](./docs/feature/record-action_setup.png "Record Actions Setup")

This app holds the record actions, offered by the SFLib Record Action feature and the record action settings.
Tabs:
 - Record Actions,<br/>Where actions can be configured 
 - Record Action Settings<br/>To manage Record Action settings

 
![Record Actions Setup Detail](./docs/feature/record-action_setup-detail.png "Record Actions Setup Detail")<br/>
_Actions Detail page of the 'Record Actions Setup' Lightning App._

![Record Actions Setup Settings](./docs/feature/record-action_setup-settings.png "Record Actions Setup Settings")<br/>
_Configurable settings can be managed under the settings tab_

### Record Actions
Showing actions based on a formula with conditions like
    - `1 AND 2`
    - 1: `Case.Status = 'New'`
    - 2: `Case.Priority = 'High'`

### Settings
- Enable history Log<br/> This stores all the actions that have been performed on a record.
- Enable Record Action History<br/> This stores the history of the actions that have been performed on a record.
- Enable Record Action<br/> This enables the Record Action feature.

## Database Schema
```mermaid
erDiagram
    sflib_RecordAction__c {
        string Id PK
        string Name
        string Description__c
        string FlowName__c
        string Icon__c
        string Status__c
        string SObjectType__c
        string Formula__c
        decimal Order__c
    }
    
    sflib_RecordActionCondition__c {
        string Id PK
        string RecordAction__c FK
        decimal Number__c
        string Formula__c
        string SObjectType__c
    }

    sflib_RecordActionHistory__c {
        string Id PK
        string RecordId__c
        string RecordAction__c FK
        string CreatedDate__c
        string CreatedBy__c
        string Status__c
        string message__c
    }

    sflib_RecordAction__c ||--o{ sflib_RecordActionCondition__c : ActionId__c
    sflib_RecordAction__c ||--o{ sflib_RecordActionHistory__c : ActionId__c
```
| Table                            | Description                    |
|----------------------------------|--------------------------------|
| `sflib_RecordAction__c`          | The record actions             |
| `sflib_RecordActionCondition__c` | The conditions for the actions |
| `sflib_RecordActionHistory__c`   | The history of the actions     |

| Field                              | Values                                        |
|------------------------------------|-----------------------------------------------|
| `Action__c.Formula__c`             | `1 OR 2 AND 3`                                |
| `Action__c.Status`                 | `Draft`, `Active`, `Disabled`                 |
| `ActionCondition__c.Operator`      | `Equals`, `Not Equals`, `Contains`            |
| `ActionCondition__c.ObjectName__c` | `Case`, `Account`, `Contact`, `User`          |
| `ActionHistory__c.Status`          | `Started`, `Completed`, `Cancelled`, `Failed` |



## LWC Components

### Record Action 
`c-sflib-record-actions`

A list of actions that meet the configured criteria.

__For Use In__

Lightning Experience Components, Lightning Pages, Standaline Lightning App

#### Attributes
| Attribute   | Description                                                                             | Type   | Default          | Required |
|-------------|-----------------------------------------------------------------------------------------|--------|------------------|----------|
| `record-id` | The record Id for which to show the actions                                             | String |                  | Yes      |
| `title`     | The title of the component                                                              | String | `Actions`        |
| `variant`   | The variant type of how the component displays.<br/>Valid values are `list` and `tiles` | Enum   | `list`           |
| `icon-name` | The name of the icon to display                                                         | String | `custom:custom9` | 

#### Methods
The component has no methods.

### Example
```html
<template>
    <c-sflib-record-actions
         record-id={recordId}
         variant="tiles"
    ></c-sflib-record-actions>
</template>
```

![tiles](./docs/feature/record-action_tile-view.png "Tiles View")


## Permissions
There are two permission sets for the Record Actions feature.
- Record Action User `sflib_RecordActionUSer`
- Record Action Administrator `sflib_RecordActionAdmin`

The user permissions set enables the following actions:
- 'execute' Record actions and list action history
- `View` on `sflib_RecordAction__c`
- `View` on `sflib_RecordActionCondition__c`
- `View` on `sflib_RecordActionHistory__c`

Administrators have access to the 'Record Actions Setup' App 
where they are able to perform the following actions:
- `CRUD` on `sflib_RecordAction__c` and `sflib_RecordActionCondition__c`
- `Edit` on `sflib_RecordActionHistory__c`
- `Edit` on settings (using the Settings Tab) 

## Dependencies
This extension package is dependent on the following packages:
- [fflib-apex-mocks](https://github.com/apex-enterprise-patterns/fflib-apex-mocks)
- [fflib-apex-common](https://github.com/apex-enterprise-patterns/fflib-apex-common)
- [fflib-apex-extensions](https://github.com/wimvelzeboer/fflib-apex-extensions)
- System.FormulaEval, used to evaluate the conditions in `Formula__c`

## Limitations
- Only supports screen flows.