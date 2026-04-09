# Record Actions

A record action is an action that can be performed on a record, by invoking a screenflow. Listed actions are filtered based on a configured set of criteria.


## Dependencies
This extension package is dependent on the following packages:
- [fflib-apex-mocks](https://github.com/apex-enterprise-patterns/fflib-apex-mocks)
- [fflib-apex-common](https://github.com/apex-enterprise-patterns/fflib-apex-common)
- [fflib-apex-extensions](https://github.com/wimvelzeboer/fflib-apex-extensions)
- [Nebula Logger](https://github.com/jongpie/NebulaLogger)

## UI components
- Record Action List
- Action Center Tile

### Record Action
A list of actions that meet the configured criteria.

#### Attributes
| Attribute   | Description                                                                              |
|-------------|------------------------------------------------------------------------------------------|
| `icon-name` | The name of the icon to display                                                          |
| `record-id` | The record Id for which to show the actions                                              |
| `title`     | The title of the list                                                                    |
| `variant`   | The variant type of how the component displays.<br/>Valid values include `list`, `tiles` |

#### Slots
| Slot   | Description                          |
|--------|--------------------------------------|
| header | The header above the list of actions |
| footer | The footer of the list               |

#### Examples
```html
<template>
        <sflib-record-action
                title="Case Record Actions" 
                icon-name="custom:custom102"
                record-id={recordId}
                variant="tiles">
            <div slot="header">
                <p>Please select any of the following actions</p>
            </div>
            <div slot="footer">
                <p>
                    Can't find the action you are looking for?
                    Then please contact your System Administrator
                </p>
            </div>
        </sflib-record-action>
    </div>
</template>
```


## Configurational options
Record actions can be configured to in the `Record Actions Setup` App.

- Showing actions based on a formula with conditions like
  - `1 AND 2`
  - 1: `Case.Status = 'New'`
  - 2: `Case.Priority = 'High'`
- Ordering listed actions 
- Maintaining a history log
  - using ActionHistory__c records
  - using the record's feed
- Recording the start and completion of actions


- A title
- A description
- An icon
- A "Start Action" button

The call-to-action button starts a screen flow.

## Database Schema
```mermaid
erDiagram
    Action__c {
        string Id PK
        string Name
        string Description__c
        string ScreenFlow__c
        string Icon__c
        string Status__c
        string SObjectType__c
        string Formula__c
        decimal Order__c
    }
    
    ActionCondition__c {
        string Id PK
        string ActionId__c FK
        decimal Number__c
        string FieldName__c
        string Operator__c
        string Value__c
    }

    ActionHistory__c {
        string Id PK
        string ActionId__c FK
        string CreatedDate__c
        string CreatedBy__c
        string Status__c
    }

    Action__c ||--o{ ActionCondition__c : ActionId__c
    Action__c ||--o{ ActionHistory__c : ActionId__c
```

| Field                              | Values                               |
|------------------------------------|--------------------------------------|
| `Action__c.Formula__c`             | `1 OR 2 AND 3`                       |
| `Action__c.Status`                 | `Draft`, `Active`, `Disabled`        |
| `ActionCondition__c.Operator`      | `Equals`, `Not Equals`, `Contains`   |
| `ActionCondition__c.ObjectName__c` | `Case`, `Account`, `Contact`, `User` |
| `ActionHistory__c.Status`          | `Started`, `Completed`, `Failed`     |

## LWC Components

### Action Center Tile
- Avonni Card
    - Icon
    - Title
    - Body
        - Description
        - 'Start Action' Button

### Action Center
A list of tiles ordered by `Order__c` that meet the conditions in `Formula__c` and `ActionCondition__c`.


## Limitations
- Only supports screen flows.