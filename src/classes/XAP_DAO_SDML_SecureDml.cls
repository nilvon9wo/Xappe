global class XAP_DAO_SDML_SecureDml {
    private XAP_DAO_SDML_WithSharingAccessCtrl withSharingAccessCtrl;
    private XAP_DAO_SDML_WithoutSharingAccessCtrl withoutSharingAccessCtrl;
    private XAP_DAO_SDML_InheritSharingAccessCtrl inheritSharingAccessCtrl;
    private XAP_DAO_SDML_SharingModeEnum sharingMode = XAP_DAO_SDML_SharingModeEnum.WITH;

    global XAP_DAO_SDML_SecureDml(
            XAP_DAO_SDML_SharingModeEnum sharingMode,
            XAP_DAO_SDML_OperationModeEnum operationMode,
            XAP_DAO_SDML_OperationModeEnum arrayOperationMode
    ) {
        this.withSharingAccessCtrl = new XAP_DAO_SDML_WithSharingAccessCtrl();
        this.withoutSharingAccessCtrl = new XAP_DAO_SDML_WithoutSharingAccessCtrl();
        this.inheritSharingAccessCtrl = new XAP_DAO_SDML_InheritSharingAccessCtrl();
        setSharingMode(sharingMode);
        setOperationMode(operationMode);
        setArrayOperationMode(arrayOperationMode);
    }

    global XAP_DAO_SDML_SecureDml(XAP_DAO_SDML_SharingModeEnum sharingMode, XAP_DAO_SDML_OperationModeEnum operationMode) {
        this(sharingMode, operationMode, XAP_DAO_SDML_OperationModeEnum.ALL_OR_NONE);
    }

    global XAP_DAO_SDML_SecureDml() {
        this(
                XAP_DAO_SDML_SharingModeEnum.WITH,
                XAP_DAO_SDML_OperationModeEnum.ALL_OR_NONE,
                XAP_DAO_SDML_OperationModeEnum.ALL_OR_NONE
        );
    }

    private XAP_DAO_SDML_AccessCtrlIntf getAccessCtrl() {
        if (sharingMode == XAP_DAO_SDML_SharingModeEnum.WITH) {
            return withSharingAccessCtrl;
        }
        else if (sharingMode == XAP_DAO_SDML_SharingModeEnum.WITHOUT) {
            return withoutSharingAccessCtrl;
        }
        else {
            return inheritSharingAccessCtrl;
        }
    }

    global void setSharingMode(XAP_DAO_SDML_SharingModeEnum sharingMode) {
        if (sharingMode == null) {
            throw new XAP_DAO_SDML_AccessCtrlDmlException('SharingMode must not be null');
        }

        if (
                sharingMode == XAP_DAO_SDML_SharingModeEnum.WITH
                        || sharingMode == XAP_DAO_SDML_SharingModeEnum.WITHOUT
                        || sharingMode == XAP_DAO_SDML_SharingModeEnum.INHERIT
                ) {
            this.sharingMode = sharingMode;
        }
        else {
            throw new XAP_DAO_SDML_AccessCtrlDmlException('Invalid value for SharingMode');
        }
    }

    global void setOperationMode(XAP_DAO_SDML_OperationModeEnum omode) {
        withSharingAccessCtrl.setOperationMode(omode);
        withoutSharingAccessCtrl.setOperationMode(omode);
        inheritSharingAccessCtrl.setOperationMode(omode);
    }

    global void setArrayOperationMode(XAP_DAO_SDML_OperationModeEnum oarrmode) {
        withSharingAccessCtrl.setArrayOperationMode(oarrmode);
        withoutSharingAccessCtrl.setArrayOperationMode(oarrmode);
        inheritSharingAccessCtrl.setArrayOperationMode(oarrmode);
    }

    global SObject insertAsUser(SObject someObj, List<String> fieldsToSet) {
        return getAccessCtrl().insertAsUser(someObj, fieldsToSet);
    }

    global SObject insertAsUser(SObject someObj, List<Schema.SObjectField> fieldsToSet) {
        return getAccessCtrl().insertAsUser(someObj, fieldsToSet);
    }

    global SFDCAccessControlResults.InsertResults insertAsUser(SObject [] someObjs, List<String> fieldsToSet) {
        return getAccessCtrl().insertAsUser(someObjs, fieldsToSet);
    }

    global SFDCAccessControlResults.InsertResults insertAsUser(SObject [] someObjs, List<Schema.SObjectField> fieldsToSet) {
        return getAccessCtrl().insertAsUser(someObjs, fieldsToSet);
    }

    global SObject updateAsUser(SObject someObj, List<String> fieldsToUpdate) {
        return getAccessCtrl().updateAsUser(someObj, fieldsToUpdate);
    }

    global SObject updateAsUser(SObject someObj, List<Schema.SObjectField> fieldsToUpdate) {
        return getAccessCtrl().updateAsUser(someObj, fieldsToUpdate);
    }

    global SFDCAccessControlResults.UpdateResults updateAsUser(Map<Id, SObject> objMap, List<String> fieldsToUpdate) {
        return getAccessCtrl().updateAsUser(objMap, fieldsToUpdate);
    }
    global SFDCAccessControlResults.UpdateResults updateAsUser(Map<Id, SObject> objMap, List<Schema.SObjectField> fieldsToUpdate) {
        return getAccessCtrl().updateAsUser(objMap, fieldsToUpdate);
    }

    global void deleteAsUser(SObject someObj) {
        getAccessCtrl().deleteAsUser(someObj);
    }

    global SFDCAccessControlResults.DeleteResults deleteAsUser(SObject [] someObjs) {
        return getAccessCtrl().deleteAsUser(someObjs);
    }

    global List<Schema.SObjectField> getViewableFields(SObject someObj) {
        return getAccessCtrl().getViewableFields(someObj.getSObjectType());
    }

    global List<Schema.SObjectField> getViewableFields(SObjectType someType) {
        return getAccessCtrl().getViewableFields(someType);
    }

    global List<Schema.SObjectField> getUpdateableFields(SObject someObj) {
        return getAccessCtrl().getUpdateableFields(someObj.getSObjectType());
    }

    global List<Schema.SObjectField> getUpdateableFields(SObjectType someType) {
        return getAccessCtrl().getUpdateableFields(someType);
    }

    global List<Schema.SObjectField> getCreatableFields(SObject someObj) {
        return getAccessCtrl().getCreatableFields(someObj.getSObjectType());
    }

    global List<Schema.SObjectField> getCreatableFields(SObjectType someType) {
        return getAccessCtrl().getCreatableFields(someType);
    }

    global Boolean isAuthorizedToView(Schema.SObjectType someType, List<Schema.SObjectField> fields) {
        return getAccessCtrl().isAuthorizedToView(someType, fields);
    }

    global Boolean isAuthorizedToView(Schema.SObjectType someType, List<String> fields) {
        return getAccessCtrl().isAuthorizedToView(someType, fields);
    }

    global Boolean isAuthorizedToCreate(Schema.SObjectType someType, List<Schema.SObjectField> fields) {
        return getAccessCtrl().isAuthorizedToCreate(someType, fields);
    }

    global Boolean isAuthorizedToCreate(Schema.SObjectType someType, List<String> fields) {
        return getAccessCtrl().isAuthorizedToCreate(someType, fields);
    }

    global Boolean isAuthorizedToUpdate(Schema.SObjectType someType, List<Schema.SObjectField> fields) {
        return getAccessCtrl().isAuthorizedToUpdate(someType, fields);
    }

    global Boolean isAuthorizedToUpdate(Schema.SObjectType someType, List<String> fields) {
        return getAccessCtrl().isAuthorizedToUpdate(someType, fields);
    }

    global Boolean isAuthorizedToDelete(Schema.SObjectType someType) {
        return getAccessCtrl().isAuthorizedToDelete(someType);
    }

    private abstract class XAP_DAO_SDML_AccessControllerInternalAbs implements XAP_DAO_SDML_AccessCtrlIntf {

        private XAP_DAO_SDML_OperationModeEnum omode; // the current operation mode of this instance.
        private Boolean arrayAllOrNoneParam; // the current array operation mode param of this instance. (as provided to the database methods second argument)

        private abstract void dbInsert(SObject obj);
        private abstract Database.SaveResult[] dbInsert(SObject [] objs);
        private abstract void dbUpdate(SObject obj);
        private abstract Database.SaveResult[] dbUpdate(SObject [] objs);
        private abstract void dbDelete(SObject obj);
        private abstract Database.DeleteResult[] dbDelete(SObject [] objs);

        private void setOperationMode(XAP_DAO_SDML_OperationModeEnum omode) {
            if (omode == null) {
                throw new XAP_DAO_SDML_AccessCtrlDmlException('OperationMode must not be null');
            }

            if (omode == XAP_DAO_SDML_OperationModeEnum.ALL_OR_NONE || omode == XAP_DAO_SDML_OperationModeEnum.BEST_EFFORT) {
                this.omode = omode;
            }
            else {
                throw new XAP_DAO_SDML_AccessCtrlDmlException('Invalid value for OperationMode');
            }
        }

        private void setArrayOperationMode(XAP_DAO_SDML_OperationModeEnum oarrmode) {
            if (oarrmode == null) {
                throw new XAP_DAO_SDML_AccessCtrlDmlException('OperationMode must not be null');
            }

            if (oarrmode == XAP_DAO_SDML_OperationModeEnum.ALL_OR_NONE) {
                this.arrayAllOrNoneParam = true;
            }
            else if (oarrmode == XAP_DAO_SDML_OperationModeEnum.BEST_EFFORT) {
                this.arrayAllOrNoneParam = false;
            }
            else {
                throw new XAP_DAO_SDML_AccessCtrlDmlException('Invalid value for OperationMode');
            }
        }

        public Map<String, Schema.SObjectField> getFieldMap(SObjectType someType) {
            return SFDCPlugins.SFDC_DescribeInfoCache.fieldMapFor(someType);
        }

        public Set<String> fieldsToStringSet(List<Schema.SObjectField> fields) {
            Set<String> fieldNames = new Set<String>{};
            for (Schema.SObjectField f : fields) {
                fieldNames.add(f.getDescribe().getName().toLowerCase());
            }
            return fieldNames;
        }

        public List<Schema.SObjectField> getViewableFields(Map<String, Schema.SObjectField> fieldsMap) {
            List<Schema.SObjectField> fields = new List<Schema.SObjectField>{};
            for (String key : fieldsMap.keySet()) {
                if (fieldsMap.get(key).getDescribe().isAccessible()) {
                    fields.add(fieldsMap.get(key));
                }
            }
            return fields;
        }

        public List<Schema.SObjectField> getViewableFields(SObjectType someType) {
            Map<String, Schema.SObjectField> fieldsMap = getFieldMap(someType);
            return getViewableFields(fieldsMap);
        }

        public Boolean isAuthorizedToView(Schema.SObjectType someType, List<Schema.SObjectField> fields) {
            if (!someType.getDescribe().isAccessible()) {
                return false;
            }

            for (Schema.SObjectField f : fields) {
                if (!f.getDescribe().isAccessible()) {
                    return false;
                }
            }
            return true;
        }

        public Boolean isAuthorizedToView(Schema.SObjectType someType, List<String> fieldNames) {
            Schema.DescribeSObjectResult objDesc = someType.getDescribe();
            if (!objDesc.isAccessible()) {
                return false;
            }
            Map<String, Schema.SObjectField> fMap = SFDCPlugins.SFDC_DescribeInfoCache.fieldMapFor(someType);
            for (String f : fieldNames) {
                Schema.SObjectField sObjectFld = fMap.get(f);
                if (sObjectFld == null) {
                    throw new SFDCAccessControlException('Field not found',
                            SFDCAccessControlException.ExceptionType.FIELD_NOT_FOUND,
                            SFDCAccessControlException.ExceptionReason.GENERIC,
                            objDesc.getName(),
                            f);
                }
                if (!sObjectFld.getDescribe().isAccessible()) {
                    return false;
                }
            }
            return true;
        }

        public Boolean isAuthorizedToUpdate(Schema.SObjectType someType, List<Schema.SObjectField> fields) {
            if (!someType.getDescribe().isUpdateable()) {
                return false;
            }

            for (Schema.SObjectField f : fields) {
                if (!f.getDescribe().isUpdateable()) {
                    return false;
                }
            }
            return true;
        }

        public Boolean isAuthorizedToUpdate(Schema.SObjectType someType, List<String> fieldNames) {
            Schema.DescribeSObjectResult objDesc = someType.getDescribe();
            if (!objDesc.isUpdateable()) {
                return false;
            }
            Map<String, Schema.SObjectField> fMap = SFDCPlugins.SFDC_DescribeInfoCache.fieldMapFor(someType);
            for (String f : fieldNames) {
                Schema.SObjectField sObjectFld = fMap.get(f);
                if (sObjectFld == null) {
                    throw new SFDCAccessControlException('Field not found',
                            SFDCAccessControlException.ExceptionType.FIELD_NOT_FOUND,
                            SFDCAccessControlException.ExceptionReason.GENERIC,
                            objDesc.getName(),
                            f);
                }
                if (!sObjectFld.getDescribe().isUpdateable()) {
                    return false;
                }
            }
            return true;
        }

        public List<Schema.SObjectField> getUpdateableFields(Map<String, Schema.SObjectField> fieldsMap) {
            List<Schema.SObjectField> fields = new List<Schema.SObjectField>{};
            for (String key : fieldsMap.keySet()) {
                if (fieldsMap.get(key).getDescribe().isUpdateable()) {
                    fields.add(fieldsMap.get(key));
                }
            }
            return fields;
        }

        public List<Schema.SObjectField> getUpdateableFields(SObjectType someType) {
            Map<String, Schema.SObjectField> fieldsMap = getFieldMap(someType);
            return getUpdateableFields(fieldsMap);
        }

        public List<Schema.SObjectField> getCreatableFields(Map<String, Schema.SObjectField> fieldsMap) {
            List<Schema.SObjectField> fields = new List<Schema.SObjectField>{};
            for (String key : fieldsMap.keySet()) {
                if (fieldsMap.get(key).getDescribe().isCreateable()) {
                    fields.add(fieldsMap.get(key));
                }
            }
            return fields;
        }

        public List<Schema.SObjectField> getCreatableFields(SObjectType someType) {
            Map<String, Schema.SObjectField> fieldsMap = getFieldMap(someType);
            return getCreatableFields(fieldsMap);
        }

        public Boolean isAuthorizedToCreate(Schema.SObjectType someType, List<String> fieldNames) {
            Schema.DescribeSObjectResult objDesc = someType.getDescribe();
            if (!objDesc.isCreateable()) {
                return false;
            }
            Map<String, Schema.SObjectField> fMap = SFDCPlugins.SFDC_DescribeInfoCache.fieldMapFor(someType);
            for (String f : fieldNames) {
                Schema.SObjectField sObjectFld = fMap.get(f);
                if (sObjectFld == null) {
                    throw new SFDCAccessControlException('Field not found',
                            SFDCAccessControlException.ExceptionType.FIELD_NOT_FOUND,
                            SFDCAccessControlException.ExceptionReason.GENERIC,
                            objDesc.getName(),
                            f);
                }
                if (!sObjectFld.getDescribe().isCreateable()) {
                    return false;
                }
            }
            return true;
        }

        public Boolean isAuthorizedToCreate(Schema.SObjectType someType, List<Schema.SObjectField> fields) {
            if (!someType.getDescribe().isCreateable()) {
                return false;
            }

            for (Schema.SObjectField f : fields) {
                if (!f.getDescribe().isCreateable()) {
                    return false;
                }
            }
            return true;
        }

        public SObject insertAsUser(SObject devObj, List<String> fieldsToSet) {
            if (devObj == null || fieldsToSet == null || fieldsToSet.size() == 0) {
                throw new XAP_DAO_SDML_AccessCtrlDmlException('null or empty parameter');
            }

            Schema.DescribeSObjectResult d = devObj.getSObjectType().getDescribe();
            if (d.isCreateable() == false) {
                throw new SFDCAccessControlException('Access Violation',
                        SFDCAccessControlException.ExceptionType.OBJECT_ACCESS_VIOLATION,
                        SFDCAccessControlException.ExceptionReason.NO_CREATE,
                        d.getName(),
                        null);
            }

            Map<String, Schema.SObjectField> fieldMap = SFDCPlugins.SFDC_DescribeInfoCache.fieldMapFor(devObj.getSObjectType()); // potentially saves a fields call below
            Set<String> creatableFields = fieldsToStringSet(getCreatableFields(fieldMap));

            SObject cleanObj = devObj.getSObjectType().newSObject();

            for (String fieldName : fieldsToSet) {
                fieldName = fieldName.toLowerCase();
                if (creatableFields == null || creatableFields.contains(fieldName) == false) {
                    if (omode == XAP_DAO_SDML_OperationModeEnum.ALL_OR_NONE) {
                        throw new SFDCAccessControlException('Access Violation',
                                SFDCAccessControlException.ExceptionType.FIELD_ACCESS_VIOLATION,
                                SFDCAccessControlException.ExceptionReason.NO_CREATE,
                                d.getName(),
                                fieldName);
                    }
                }
                else {
                    cleanObj.put(fieldName, devObj.get(fieldName));
                }
            }

            try {
                dbInsert(cleanObj);
            }
            catch (Exception e) {
                throw new XAP_DAO_SDML_AccessCtrlDmlException('Failed to insert object');
            }
            return cleanObj;
        }

        public SObject insertAsUser(SObject devObj, List<Schema.SObjectField> fieldsToSet) {
            if (devObj == null || fieldsToSet == null || fieldsToSet.size() == 0) {
                throw new XAP_DAO_SDML_AccessCtrlDmlException('null or empty parameter');
            }

            Schema.DescribeSObjectResult d = devObj.getSObjectType().getDescribe();
            if (d.isCreateable() == false) {
                throw new SFDCAccessControlException('Access Violation',
                        SFDCAccessControlException.ExceptionType.OBJECT_ACCESS_VIOLATION,
                        SFDCAccessControlException.ExceptionReason.NO_CREATE,
                        d.getName(),
                        null);
            }

            SObject cleanObj = devObj.getSObjectType().newSObject();

            for (Schema.SObjectField field : fieldsToSet) {
                if (field.getDescribe().isCreateable() == false) {
                    if (omode == XAP_DAO_SDML_OperationModeEnum.ALL_OR_NONE) {
                        throw new SFDCAccessControlException('Access Violation',
                                SFDCAccessControlException.ExceptionType.FIELD_ACCESS_VIOLATION,
                                SFDCAccessControlException.ExceptionReason.NO_CREATE,
                                d.getName(),
                                field.getDescribe().getName());
                    }
                }
                else {
                    cleanObj.put(field, devObj.get(field));
                }
            }

            try {
                dbInsert(cleanObj);
            }
            catch (Exception e) {
                throw new XAP_DAO_SDML_AccessCtrlDmlException('Failed to insert object');
            }
            return cleanObj;
        }

        public SFDCAccessControlResults.InsertResults insertAsUser(SObject [] devObjs, List<String> fieldsToSet) {
            if (devObjs == null || devObjs.size() == 0 || fieldsToSet == null || fieldsToSet.size() == 0) {
                throw new XAP_DAO_SDML_AccessCtrlDmlException('null or empty parameter');
            }

            Schema.DescribeSObjectResult d = devObjs.getSObjectType().getDescribe();
            if (d.isCreateable() == false) {
                throw new SFDCAccessControlException('Access Violation',
                        SFDCAccessControlException.ExceptionType.OBJECT_ACCESS_VIOLATION,
                        SFDCAccessControlException.ExceptionReason.NO_CREATE,
                        d.getName(),
                        null);
            }
            Map<String, Schema.SObjectField> fieldMap = SFDCPlugins.SFDC_DescribeInfoCache.fieldMapFor(devObjs.getSObjectType());
            Set<String> creatableFields = fieldsToStringSet(getCreatableFields(fieldMap));

            SObject [] cleanObjs = devObjs.clone();
            cleanObjs.clear();

            for (SObject devObj : devObjs) {
                SObject cleanObj = devObj.getSObjectType().newSObject();

                for (String fieldName : fieldsToSet) {
                    fieldName = fieldName.toLowerCase();
                    if (creatableFields == null || creatableFields.contains(fieldName) == false) {
                        if (omode == XAP_DAO_SDML_OperationModeEnum.ALL_OR_NONE) {
                            throw new SFDCAccessControlException('Access Violation',
                                    SFDCAccessControlException.ExceptionType.FIELD_ACCESS_VIOLATION,
                                    SFDCAccessControlException.ExceptionReason.NO_CREATE,
                                    d.getName(),
                                    fieldName);
                        }
                    }
                    else {
                        cleanObj.put(fieldName, devObj.get(fieldName));
                    }
                }

                cleanObjs.add(cleanObj);
            }

            Database.SaveResult [] results = null;
            try {
                results = dbInsert(cleanObjs);
            }
            catch (Exception e) {
                throw new XAP_DAO_SDML_AccessCtrlDmlException('Failed to insert objects');
            }

            return new SFDCAccessControlResults.InsertResults(cleanObjs, results);
        }

        public SFDCAccessControlResults.InsertResults insertAsUser(SObject [] devObjs, List<Schema.SObjectField> fieldsToSet) {
            if (devObjs == null || devObjs.size() == 0 || fieldsToSet == null || fieldsToSet.size() == 0) {
                throw new XAP_DAO_SDML_AccessCtrlDmlException('null or empty parameter');
            }

            Schema.DescribeSObjectResult d = devObjs.getSObjectType().getDescribe();
            if (d.isCreateable() == false) {
                throw new SFDCAccessControlException('Access Violation',
                        SFDCAccessControlException.ExceptionType.OBJECT_ACCESS_VIOLATION,
                        SFDCAccessControlException.ExceptionReason.NO_CREATE,
                        d.getName(),
                        null);
            }

            SObject [] cleanObjs = devObjs.clone();
            cleanObjs.clear();

            for (SObject devObj : devObjs) {
                SObject cleanObj = devObj.getSObjectType().newSObject();

                for (Schema.SObjectField field : fieldsToSet) {
                    if (field.getDescribe().isCreateable() == false) {
                        if (omode == XAP_DAO_SDML_OperationModeEnum.ALL_OR_NONE) {
                            throw new SFDCAccessControlException('Access Violation',
                                    SFDCAccessControlException.ExceptionType.FIELD_ACCESS_VIOLATION,
                                    SFDCAccessControlException.ExceptionReason.NO_CREATE,
                                    d.getName(),
                                    field.getDescribe().getName());
                        }
                    }
                    else {
                        cleanObj.put(field, devObj.get(field));
                    }
                }

                cleanObjs.add(cleanObj);
            }

            Database.SaveResult [] results = null;
            try {
                results = dbInsert(cleanObjs);
            }
            catch (Exception e) {
                throw new XAP_DAO_SDML_AccessCtrlDmlException('Failed to insert objects');
            }

            return new SFDCAccessControlResults.InsertResults(cleanObjs, results);
        }

        public SObject updateAsUser(SObject devObj, List<String> fieldsToUpdate) {
            if (devObj == null || fieldsToUpdate == null || fieldsToUpdate.size() == 0) {
                throw new XAP_DAO_SDML_AccessCtrlDmlException('null or empty parameter');
            }

            Schema.DescribeSObjectResult d = devObj.getSObjectType().getDescribe();
            if (d.isUpdateable() == false) {
                throw new SFDCAccessControlException('Access Violation',
                        SFDCAccessControlException.ExceptionType.OBJECT_ACCESS_VIOLATION,
                        SFDCAccessControlException.ExceptionReason.NO_UPDATE,
                        d.getName(),
                        null);
            }

            Map<String, Schema.SObjectField> fieldsMap = SFDCPlugins.SFDC_DescribeInfoCache.fieldMapFor(devObj.getSObjectType());

            SObject cleanObj = getObject(devObj);
            if (cleanObj == null) {
                throw new SFDCAccessControlException('Record does not exist or not shared with current user',
                        SFDCAccessControlException.ExceptionType.NO_RECORD_FOUND,
                        SFDCAccessControlException.ExceptionReason.GENERIC,
                        d.getName(),
                        null);
            }

            Set<String> updateableFields = fieldsToStringSet(getUpdateableFields(fieldsMap));

            for (String fieldName : fieldsToUpdate) {
                fieldName = fieldName.toLowerCase();
                if (updateableFields == null || updateableFields.contains(fieldName) == false) {
                    if (omode == XAP_DAO_SDML_OperationModeEnum.ALL_OR_NONE) {
                        throw new SFDCAccessControlException('Access Violation',
                                SFDCAccessControlException.ExceptionType.FIELD_ACCESS_VIOLATION,
                                SFDCAccessControlException.ExceptionReason.NO_UPDATE,
                                d.getName(),
                                fieldName);
                    }
                }
                else {
                    cleanObj.put(fieldName, devObj.get(fieldName));
                }
            }

            try {
                dbUpdate(cleanObj);
            }
            catch (Exception e) {
                throw new XAP_DAO_SDML_AccessCtrlDmlException('Failed to update object');
            }
            return cleanObj;
        }

        public SObject updateAsUser(SObject devObj, List<Schema.SObjectField> fieldsToUpdate) {
            if (devObj == null || fieldsToUpdate == null || fieldsToUpdate.size() == 0) {
                throw new XAP_DAO_SDML_AccessCtrlDmlException('null or empty parameter');
            }

            Schema.DescribeSObjectResult d = devObj.getSObjectType().getDescribe();
            if (d.isUpdateable() == false) {
                throw new SFDCAccessControlException('Access Violation',
                        SFDCAccessControlException.ExceptionType.OBJECT_ACCESS_VIOLATION,
                        SFDCAccessControlException.ExceptionReason.NO_UPDATE,
                        d.getName(),
                        null);
            }

            SObject cleanObj = getObject(devObj);
            if (cleanObj == null) {
                throw new SFDCAccessControlException('Record does not exist or not shared with current user',
                        SFDCAccessControlException.ExceptionType.NO_RECORD_FOUND,
                        SFDCAccessControlException.ExceptionReason.GENERIC,
                        d.getName(),
                        null);
            }

            for (Schema.SObjectField field : fieldsToUpdate) {
                if (field.getDescribe().isUpdateable() == false) {
                    if (omode == XAP_DAO_SDML_OperationModeEnum.ALL_OR_NONE) {
                        throw new SFDCAccessControlException('Access Violation',
                                SFDCAccessControlException.ExceptionType.FIELD_ACCESS_VIOLATION,
                                SFDCAccessControlException.ExceptionReason.NO_UPDATE,
                                d.getName(),
                                field.getDescribe().getName());
                    }
                }
                else {
                    cleanObj.put(field, devObj.get(field));
                }
            }

            try {
                dbUpdate(cleanObj);
            }
            catch (Exception e) {
                throw new XAP_DAO_SDML_AccessCtrlDmlException('Failed to update object');
            }
            return cleanObj;
        }

        public SFDCAccessControlResults.UpdateResults updateAsUser(Map<Id, SObject> devMap, List<String> fieldsToUpdate) {
            if (devMap == null || devMap.size() == 0 || fieldsToUpdate == null || fieldsToUpdate.size() == 0) {
                throw new XAP_DAO_SDML_AccessCtrlDmlException('null or empty parameter');
            }

            Schema.DescribeSObjectResult d = devMap.getSObjectType().getDescribe();
            if (d.isUpdateable() == false) {
                throw new SFDCAccessControlException('Access Violation',
                        SFDCAccessControlException.ExceptionType.OBJECT_ACCESS_VIOLATION,
                        SFDCAccessControlException.ExceptionReason.NO_UPDATE,
                        d.getName(),
                        null);
            }

            Map<String, Schema.SObjectField> fieldsMap = SFDCPlugins.SFDC_DescribeInfoCache.fieldMapFor(devMap.getSObjectType());

            SObject [] cleanObjs = getObjects(devMap.values());
            if (cleanObjs == null || cleanObjs.size() != devMap.size()) {
                throw new SFDCAccessControlException('At least some record do not exist or are not shared with current user',
                        SFDCAccessControlException.ExceptionType.NO_RECORD_FOUND,
                        SFDCAccessControlException.ExceptionReason.GENERIC,
                        d.getName(),
                        null);
            }

            Set<String> updateableFields = fieldsToStringSet(getUpdateableFields(fieldsMap));

            for (SObject cleanObj : cleanObjs) {
                if (devMap.containsKey(cleanObj.Id) == false) {
                    throw new SFDCAccessControlException('At least some record do not exist or are not shared with current user',
                            SFDCAccessControlException.ExceptionType.NO_RECORD_FOUND,
                            SFDCAccessControlException.ExceptionReason.GENERIC,
                            d.getName(),
                            null);
                }

                SObject devObj = devMap.get(cleanObj.Id);

                for (String fieldName : fieldsToUpdate) {
                    fieldName = fieldName.toLowerCase();
                    if (updateableFields == null || updateableFields.contains(fieldName) == false) {
                        if (omode == XAP_DAO_SDML_OperationModeEnum.ALL_OR_NONE) {
                            throw new SFDCAccessControlException('Access Violation',
                                    SFDCAccessControlException.ExceptionType.FIELD_ACCESS_VIOLATION,
                                    SFDCAccessControlException.ExceptionReason.NO_UPDATE,
                                    d.getName(),
                                    fieldName);
                        }
                    }
                    else {
                        cleanObj.put(fieldName, devObj.get(fieldName));
                    }
                }
            }

            Database.SaveResult [] results = null;
            try {
                results = dbUpdate(cleanObjs);
            }
            catch (Exception e) {
                throw new XAP_DAO_SDML_AccessCtrlDmlException('Failed to update objects');
            }

            return new SFDCAccessControlResults.UpdateResults(cleanObjs, results);
        }

        public SFDCAccessControlResults.UpdateResults updateAsUser(Map<Id, SObject> devMap, List<Schema.SObjectField> fieldsToUpdate) {
            if (devMap == null || devMap.size() == 0 || fieldsToUpdate == null || fieldsToUpdate.size() == 0) {
                throw new XAP_DAO_SDML_AccessCtrlDmlException('null or empty parameter');
            }

            Schema.DescribeSObjectResult d = devMap.getSObjectType().getDescribe();
            if (d.isUpdateable() == false) {
                throw new SFDCAccessControlException('Access Violation',
                        SFDCAccessControlException.ExceptionType.OBJECT_ACCESS_VIOLATION,
                        SFDCAccessControlException.ExceptionReason.NO_UPDATE,
                        d.getName(),
                        null);
            }

            SObject [] cleanObjs = getObjects(devMap.values());
            if (cleanObjs == null || cleanObjs.size() != devMap.size()) {
                throw new SFDCAccessControlException('At least some record do not exist or are not shared with current user',
                        SFDCAccessControlException.ExceptionType.NO_RECORD_FOUND,
                        SFDCAccessControlException.ExceptionReason.GENERIC,
                        d.getName(),
                        null);
            }

            for (SObject cleanObj : cleanObjs) {
                if (devMap.containsKey(cleanObj.Id) == false) {
                    throw new SFDCAccessControlException('At least some record do not exist or are not shared with current user',
                            SFDCAccessControlException.ExceptionType.NO_RECORD_FOUND,
                            SFDCAccessControlException.ExceptionReason.GENERIC,
                            d.getName(),
                            null);
                }

                SObject devObj = devMap.get(cleanObj.Id);

                for (Schema.SObjectField field : fieldsToUpdate) {
                    if (field.getDescribe().isUpdateable() == false) {
                        if (omode == XAP_DAO_SDML_OperationModeEnum.ALL_OR_NONE) {
                            throw new SFDCAccessControlException('Access Violation',
                                    SFDCAccessControlException.ExceptionType.FIELD_ACCESS_VIOLATION,
                                    SFDCAccessControlException.ExceptionReason.NO_UPDATE,
                                    d.getName(),
                                    field.getDescribe().getName());
                        }
                    }
                    else {
                        cleanObj.put(field, devObj.get(field));
                    }
                }
            }

            Database.SaveResult [] results = null;
            try {
                results = dbUpdate(cleanObjs);
            }
            catch (Exception e) {
                throw new XAP_DAO_SDML_AccessCtrlDmlException('Failed to update objects');
            }

            return new SFDCAccessControlResults.UpdateResults(cleanObjs, results);
        }

        public void deleteAsUser(SObject devObj) {
            if (devObj == null) {
                throw new XAP_DAO_SDML_AccessCtrlDmlException('null parameter');
            }

            Schema.DescribeSObjectResult d = devObj.getSObjectType().getDescribe();
            if (d.isDeletable() == false) {
                throw new SFDCAccessControlException('Access Violation',
                        SFDCAccessControlException.ExceptionType.OBJECT_ACCESS_VIOLATION,
                        SFDCAccessControlException.ExceptionReason.NO_DELETE,
                        d.getName(),
                        null);
            }

            try {
                dbDelete(devObj);
            }
            catch (Exception e) {
                throw new XAP_DAO_SDML_AccessCtrlDmlException('Failed to delete object');
            }
        }

        public SFDCAccessControlResults.DeleteResults deleteAsUser(SObject [] devObjs) {
            if (devObjs == null || devObjs.size() == 0) {
                throw new XAP_DAO_SDML_AccessCtrlDmlException('null parameter');
            }

            Schema.DescribeSObjectResult d = devObjs.getSObjectType().getDescribe();
            if (d.isDeletable() == false) {
                throw new SFDCAccessControlException('Access Violation',
                        SFDCAccessControlException.ExceptionType.OBJECT_ACCESS_VIOLATION,
                        SFDCAccessControlException.ExceptionReason.NO_DELETE,
                        d.getName(),
                        null);
            }

            Database.DeleteResult [] results = null;
            try {
                results = dbDelete(devObjs);
            }
            catch (Exception e) {
                throw new XAP_DAO_SDML_AccessCtrlDmlException('Failed to delete objects');
            }

            return new SFDCAccessControlResults.DeleteResults(results);
        }

        public Boolean isAuthorizedToDelete(Schema.SObjectType someType) {
            return someType.getDescribe().isDeletable();
        }

        private SObject getObject(SObject obj) {

            String Soql = 'SELECT Id FROM ' + obj.getSObjectType().getDescribe().getName() + ' WHERE Id=\'' + String.escapeSingleQuotes(obj.Id) + '\'';

            List<SObject> res;

            try {
                res = dbQuery(Soql);
            }
            catch (Exception e) {
                throw new XAP_DAO_SDML_AccessCtrlDmlException('Failed to query object');
            }

            if (res.isEmpty() == True) {
                return null;
            }
            else {
                return res.get(0);
            }
        }

        private SObject [] getObjects(SObject [] objArray) {

            String Soql = 'SELECT Id FROM ' + objArray.getSObjectType().getDescribe().getName() + ' WHERE ';
            Boolean emptyIds = true;

            for (SObject obj : objArray) {
                if (emptyIds == false) {
                    Soql += ' or ';
                }
                else {
                    emptyIds = false;
                }

                Soql += 'ID=\'' + String.escapeSingleQuotes(obj.Id) + '\'';
            }

            List<SObject> res;

            try {
                res = dbQuery(Soql);
            }
            catch (Exception e) {
                throw new XAP_DAO_SDML_AccessCtrlDmlException('Failed to query object');
            }

            return res;
        }
    }
}