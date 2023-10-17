public virtual class SObjectTriage {

    protected final Map<Id,SObject> oldMap;
    protected final List<SObject> newList;

    protected SObjectTriage(Map<Id,SObject> oldMap, List<SObject> newList) {
        this.oldMap = oldMap;
        this.newList = newList;
    }

    public void handle(TriggerOperation operation) {
        switch on operation {
            when BEFORE_INSERT  { onBeforeInsert();  }
            when BEFORE_UPDATE  { onBeforeUpdate();  }
            when BEFORE_DELETE  { onBeforeDelete();  }
            when AFTER_INSERT   { onAfterInsert();   }
            when AFTER_UPDATE   { onAfterUpdate();   }
            when AFTER_DELETE   { onAfterDelete();   }
            when AFTER_UNDELETE { onAfterUndelete(); }
        }
    }
}