({
    doInit : function(component, event, helper) {
		//Server call to fetch the Object details
        var action = component.get('c.getFieldSetMember');
        action.setParams({ strFieldSetName : component.get("v.fieldsetName") ,
                           numColumns : component.get("v.numOfColumns") ,
                           recordId : component.get("v.recordId") });
                           
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var serverResult = response.getReturnValue();
                var parsed = JSON.parse(serverResult.fieldSetWrapperClass);
                var fieldSetList = component.get('v.fieldsList');
                for(var i = 0; i < parsed.length ; i++) {
                    fieldSetList.push(parsed[i].fieldAPIName);
                }    
                component.set('v.renderRecordForm', true);
                component.set('v.sObjectName',serverResult.sObjectName);
                component.set('v.fieldsList',fieldSetList);
                component.set('v.cardTitle',serverResult.objectLabel);
                component.set('v.iconUrl',serverResult.objectIcon);
            }
            else if(state === "ERROR") {
                var errors = response.getError();
                if(errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } 
                else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    }, 
    editRecord : function(component, event, helper) {
        //Creating a new component dynamically for editing the record
        $A.createComponent("c:RecordEditModal", {  recordId : event.getSource().get('v.value'),
                                                   numOfColumns : component.get('v.numOfColumns'),
                                                   sObjectName : component.get('v.sObjectName'),
                                                   fieldsList : component.get('v.fieldsList') },
                           function(content, status, errorMessage) {
                                if(status === "SUCCESS") {
                                    component.find('overlayLib').showCustomModal({
                                        header: "Edit "+component.get('v.cardTitle'),
                                        body: content, 
                                        showCloseButton: true,
                                        cssClass: "mymodal slds-modal_medium",
                                    })
                                }
                                else if(status === "ERROR") {
                                	console.log("Error: " + errorMessage);
                                }
                                else if(status === "INCOMPLETE") {
                                    console.log("No response from server or client is offline.");
                                }                               
                           });    
	}

})