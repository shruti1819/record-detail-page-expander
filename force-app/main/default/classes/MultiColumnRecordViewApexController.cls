/**
 * This class is invoked from the Aura component named MultiColumnRecordView
 * Server call is made through this class to get the details of the specific object
 **/
public class MultiColumnRecordViewApexController {
 	/**
     * This method makes a server call to get all the field set information required to be displayed on the UI
     * It also gets the Object Icon specified at the object level in the org
     **/
    @AuraEnabled(cacheable = true)
    public static MultiColumnRecordViewApexController.FinalWrapperClass getFieldSetMember(String strFieldSetName, Integer numColumns, ID recordId) {
		String sObjName = recordId.getSObjectType().getDescribe().getName();
        String objLabel = String.valueOf(sObjName).replace('__c','').replace('_',' ');
        String objIcon = getIconUrl(String.valueOf(sObjName));

        List<FieldSetMemberWrapperClass> wrapperList = new List<FieldSetMemberWrapperClass>();
        Schema.SObjectType sObj = Schema.getGlobalDescribe().get(sObjName);
        if(!String.isEmpty(strFieldSetName)) {
         	for(Schema.FieldSetMember fieldMember : sObj.getDescribe().fieldSets.getMap().get(strFieldSetName).getFields()) {
                FieldSetMemberWrapperClass wrapper = new FieldSetMemberWrapperClass();
                wrapper.isRequired = fieldMember.getRequired();
                wrapper.fieldType = String.valueOf(fieldMember.getType());
                wrapper.fieldLabel = fieldMember.getLabel();
                wrapper.fieldAPIName = fieldMember.getFieldPath();
                if( String.valueOf(fieldMember.getType()) == 'PICKLIST' || 
                    String.valueOf(fieldMember.getType()) == 'MULTIPICKLIST') {
                        wrapper.pickListValues = sObj.getDescribe().fields.getMap().get(fieldMember.getFieldPath())
                                                               .getDescribe().getPicklistValues();
                }
                wrapperList.add(wrapper);
            }   
        }
        
        if(Math.mod(wrapperList.size(), numColumns) != 0) {
            Integer intNumFields = 1;
            do {
                FieldSetMemberWrapperClass wrapper = new FieldSetMemberWrapperClass();
                wrapper.fieldLabel = '.';
                wrapper.fieldAPIName = 'Blank_Field'+intNumFields+'__c';
                intNumFields++;
                wrapperList.add(wrapper);
            } while(Math.mod(wrapperList.size(), numColumns) != 0);
        }
        
        FinalWrapperClass objFinalWrapperClass = new FinalWrapperClass();
        objFinalWrapperClass.fieldSetWrapperClass = JSON.serialize(wrapperList);
        objFinalWrapperClass.sObjectName = sObjName;
        objFinalWrapperClass.objectLabel = objLabel;
        objFinalWrapperClass.objectIcon = objIcon;
        return objFinalWrapperClass; 
    }

    public static String getIconUrl(String objAPIName) {
    	String iconUrl;
    	List<Schema.DescribeTabSetResult> tabSetDesc = Schema.describeTabs();    	
		for(Schema.DescribeTabSetResult tsr : tabSetDesc) {
			List<Schema.DescribeTabResult> tabs = tsr.getTabs();		
			for(Schema.DescribeTabResult tr : tabs) {
				if(tr.getSobjectName() == objAPIName) {
					List<Schema.DescribeIconResult> icons = tr.getIcons();					
					for(Schema.DescribeIconResult ir : icons) {	 
						if(ir.getContentType() == 'image/svg+xml') {
							iconUrl = ir.getUrl();
							break;
						}
					}		           
				}			
			}			
		}
		
		if (iconUrl != null && iconUrl.contains('custom')) {
			Integer s = iconUrl.indexOf('/custom/') + '/custom/'.length();
			Integer e = iconUrl.length() - 4;
			iconUrl = 'custom:' + iconUrl.substring(s, e);
		}
		
		if (iconUrl != null && iconUrl.contains('standard')) {
			Integer s = iconUrl.indexOf('/standard/') + '/standard/'.length();
			Integer e = iconUrl.length() - 4;
			iconUrl = 'standard:' + iconUrl.substring(s, e);		
		}
		return iconUrl;	
	}

    public class FieldSetMemberWrapperClass {
        @AuraEnabled
        public Boolean isRequired 						 { get; set; }
        @AuraEnabled
        public String fieldType 						 { get; set; }
        @AuraEnabled
        public String fieldLabel 						 { get; set; }
        @AuraEnabled
        public String fieldAPIName 					     { get; set; }
        @AuraEnabled 
        public List<Schema.PicklistEntry> pickListValues { get; set; }
    }
    
    public class FinalWrapperClass {
        @AuraEnabled
        public String sObjectName 						 { get; set; } 
        @AuraEnabled
        public String objectLabel 						 { get; set; }
        @AuraEnabled
        public String objectIcon 						 { get; set; }
        @AuraEnabled
        public String fieldSetWrapperClass 		 		 { get; set; } 
    }
}