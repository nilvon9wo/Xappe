public class A00_Application {
    public class UnitOfWorkFactory {
        private List<SObjectType> m_objectTypes;
        private fflib_ISObjectUnitOfWork m_mockUow;

        public UnitOfWorkFactory(List<SObjectType> objectTypes) {
            m_objectTypes = objectTypes.clone();
        }

        public fflib_ISObjectUnitOfWork newInstance() {
            // Mock?
            if (m_mockUow != null)
                return m_mockUow;
            return new fflib_SObjectUnitOfWork(m_objectTypes);
        }

        public fflib_ISObjectUnitOfWork newInstance(fflib_SObjectUnitOfWork.IDML dml) {
            // Mock?
            if (m_mockUow != null)
                return m_mockUow;
            return new fflib_SObjectUnitOfWork(m_objectTypes, dml);
        }

        public fflib_ISObjectUnitOfWork newInstance(List<SObjectType> objectTypes) {
            // Mock?
            if (m_mockUow != null)
                return m_mockUow;
            return new fflib_SObjectUnitOfWork(objectTypes);
        }

        public fflib_ISObjectUnitOfWork newInstance(List<SObjectType> objectTypes, fflib_SObjectUnitOfWork.IDML dml) {
            // Mock?
            if (m_mockUow != null)
                return m_mockUow;
            return new fflib_SObjectUnitOfWork(objectTypes, dml);
        }


        @TestVisible
        private void setMock(fflib_ISObjectUnitOfWork mockUow) {
            m_mockUow = mockUow;
        }
    }

    public class ServiceFactory {
        private Map<Type, Type> m_serviceInterfaceTypeByServiceImplType;

        private Map<Type, Object> m_serviceInterfaceTypeByMockService;

        public ServiceFactory(Map<Type, Type> serviceInterfaceTypeByServiceImplType) {
            m_serviceInterfaceTypeByServiceImplType = serviceInterfaceTypeByServiceImplType;
            m_serviceInterfaceTypeByMockService = new Map<Type, Object>();
        }

        public Object newInstance(Type serviceInterfaceType) {
            // Mock implementation?
            if (m_serviceInterfaceTypeByMockService.containsKey(serviceInterfaceType))
                return m_serviceInterfaceTypeByMockService.get(serviceInterfaceType);

            // Create an instance of the type impleneting the given interface
            Type serviceImpl = m_serviceInterfaceTypeByServiceImplType.get(serviceInterfaceType);
            if (serviceImpl == null)
                throw new DeveloperException('No implementation registered for service interface ' + serviceInterfaceType.getName());
            return serviceImpl.newInstance();
        }

        @TestVisible
        private void setMock(Type serviceInterfaceType, Object serviceImpl) {
            m_serviceInterfaceTypeByMockService.put(serviceInterfaceType, serviceImpl);
        }
    }

    public class SelectorFactory {
        private Map<SObjectType, Type> m_sObjectBySelectorType;
        private Map<SObjectType, XAP_DAO_SOQL_SObjectSelectorIntf> m_sObjectByMockSelector;

        public SelectorFactory(Map<SObjectType, Type> sObjectBySelectorType) {
            m_sObjectBySelectorType = sObjectBySelectorType;
            m_sObjectByMockSelector = new Map<SObjectType, XAP_DAO_SOQL_SObjectSelectorIntf>();
        }

        public XAP_DAO_SOQL_SObjectSelectorIntf newInstance(SObjectType sObjectType) {
            // Mock implementation?
            if (m_sObjectByMockSelector.containsKey(sObjectType))
                return m_sObjectByMockSelector.get(sObjectType);

            // Determine Apex class for Selector class
            Type selectorClass = m_sObjectBySelectorType.get(sObjectType);
            if (selectorClass == null)
                throw new DeveloperException('Selector class not found for SObjectType ' + sObjectType);

            // Construct Selector class and query by Id for the records
            return (XAP_DAO_SOQL_SObjectSelectorIntf) selectorClass.newInstance();
        }

        public List<SObject> selectById(Set<Id> recordIds) {
            // No point creating an empty Domain class, nor can we determine the SObjectType anyway
            if (recordIds == null || recordIds.size() == 0)
                throw new DeveloperException('Invalid record Id\'s set');

            // Determine SObjectType
            SObjectType domainSObjectType = new List<Id>(recordIds)[0].getSObjectType();
            for (Id recordId : recordIds)
                if (recordId.getSobjectType() != domainSObjectType)
                    throw new DeveloperException('Unable to determine SObjectType, Set contains Id\'s from different SObject types');

            // Construct Selector class and query by Id for the records
            return newInstance(domainSObjectType).selectById(recordIds);
        }

        public List<SObject> selectByRelationship(List<SObject> relatedRecords, SObjectField relationshipField) {
            Set<Id> relatedIds = new Set<Id>();
            for (SObject relatedRecord : relatedRecords) {
                Id relatedId = (Id) relatedRecord.get(relationshipField);
                if (relatedId != null)
                    relatedIds.add(relatedId);
            }
            return selectById(relatedIds);
        }

        @TestVisible
        private void setMock(XAP_DAO_SOQL_SObjectSelectorIntf selectorInstance) {
            m_sObjectByMockSelector.put(selectorInstance.getSObjectType(), selectorInstance);
        }
    }

    public class DomainFactory {
        private A00_Application.SelectorFactory m_selectorFactory;

        private Map<SObjectType, Type> m_sObjectByDomainConstructorType;

        private Map<SObjectType, fflib_ISObjectDomain> m_sObjectByMockDomain;

        public DomainFactory(A00_Application.SelectorFactory selectorFactory,
                Map<SObjectType, Type> sObjectByDomainConstructorType) {
            m_selectorFactory = selectorFactory;
            m_sObjectByDomainConstructorType = sObjectByDomainConstructorType;
            m_sObjectByMockDomain = new Map<SObjectType, fflib_ISObjectDomain>();
        }

        public fflib_ISObjectDomain newInstance(Set<Id> recordIds) {
            return newInstance(m_selectorFactory.selectById(recordIds));

        }

        public fflib_ISObjectDomain newInstance(List<SObject> records) {
            SObjectType domainSObjectType = records.getSObjectType();
            if (domainSObjectType == null)
                throw new DeveloperException('Unable to determine SObjectType');

            // Mock implementation?
            if (m_sObjectByMockDomain.containsKey(domainSObjectType))
                return m_sObjectByMockDomain.get(domainSObjectType);

            // Determine SObjectType and Apex classes for Domain class
            Type domainConstructorClass = m_sObjectByDomainConstructorType.get(domainSObjectType);
            if (domainConstructorClass == null)
                throw new DeveloperException('Domain constructor class not found for SObjectType ' + domainSObjectType);

            // Construct Domain class passing in the queried records
            A00_SObjectDomain.IConstructable domainConstructor =
                    (A00_SObjectDomain.IConstructable) domainConstructorClass.newInstance();
            return (fflib_ISObjectDomain) domainConstructor.construct(records);
        }

        public fflib_ISObjectDomain newInstance(List<SObject> records, SObjectType domainSObjectType) {
            if (domainSObjectType == null)
                throw new DeveloperException('Must specify sObjectType');

            // Mock implementation?
            if (m_sObjectByMockDomain.containsKey(domainSObjectType))
                return m_sObjectByMockDomain.get(domainSObjectType);

            // Determine SObjectType and Apex classes for Domain class
            Type domainConstructorClass = m_sObjectByDomainConstructorType.get(domainSObjectType);
            if (domainConstructorClass == null)
                throw new DeveloperException('Domain constructor class not found for SObjectType ' + domainSObjectType);

            // Construct Domain class passing in the queried records
            A00_SObjectDomain.IConstructable2 domainConstructor =
                    (A00_SObjectDomain.IConstructable2) domainConstructorClass.newInstance();
            return (fflib_ISObjectDomain) domainConstructor.construct(records, domainSObjectType);
        }

        @TestVisible
        private void setMock(fflib_ISObjectDomain mockDomain) {
            m_sObjectByMockDomain.put(mockDomain.sObjectType(), mockDomain);
        }
    }

    public class ApplicationException extends Exception {
    }

    public class DeveloperException extends Exception {
    }
}