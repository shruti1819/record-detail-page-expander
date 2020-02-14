({
	doInit : function(component, event, helper) {
        component.set("v.recordId", component.get("v.recordId"));
        helper.doInit(component, event, helper);
    },
    editRecord : function(component, event, helper) {
        helper.editRecord(component, event, helper);
    },
    myAction : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast"); 
        toastEvent.setParams({ 
            "message": "Your record is updated successfully !", 
            "type": "success" 
        }); 
        toastEvent.fire();
    }
})