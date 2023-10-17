# How to use the triage class

* The triage class is designed to be the **only** class that knows about the trigger context and acts upon it.

* The trigger should be a one-liner that sends its context to the triage class, for example:
    ```
    trigger Widgets on Widget__c (before insert, after insert, before update, after update, before delete, after delete, after undelete) {

        (new WidgetTriage(Trigger.oldMap, Trigger.new)).handle(Trigger.operationType);
    }
    ```
* Triage classes should extend `SObjectTriage` and override any of the proctected `on()` methods as necessary, for example:
    ```
    public with sharing class WidgetTriage extends SObjectTriage {

        // Constructor
        public WidgetTriage(Map<Id,Widget__c> oldMap, List<Widget__c> newList) {
            super(oldMap, newList);
        }

        // Override on() methods to list what actions should be performed
        // Encapsulate each action in a separate method
        protected override void onBeforeInsert() {
            populateUniqueIdentifier();
        }

        protected override void onAfterInsert() {
            sendNewActiveWidgetAlert();
            notifyExternalSystemsOfActiveStatusChange();
        }

        protected override void onAfterUpdate() {
            notifyExternalSystemsOfActiveStatusChange();
        }

        // Actions
        private void populateUniqueIdentifier() {
            for (Widget__c thisWidget : newList) {
                thisWidget.UniqueIdentifier__c = UniqueValueGenerator.newValue();
            }
        }

        private void sendActiveNewWidgetAlert() {
            List<Widget__c> activeWidgets = new List<Widget__c>();
            for (Widget__c thisWidget : newList) {
                if (thisWidget.IsActive__c) {
                    activeWidgets.add(thisWidget)
                }
            }
            WidgetAlertService.alert(activeWidgets);
        }

        private void notifyExternalSystemsOfActiveStatusChange() {
            List<Widget__c> relevantWidgets = new List<Widget__c>();
            for (Widget__c thisWidget : newList) {
                Widget__c previousValues = oldMap.get(thisWidget.Id);
                if (thisWidget.IsActive__c != previousValues.IsActive__c) {
                    relevantWidgets.add(thisWidget)
                }
            }
            NotificationService.notifyActiveStatusChange(relevantWidgets);
        }
    }
    ```