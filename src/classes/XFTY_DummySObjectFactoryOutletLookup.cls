@IsTest
public class XFTY_DummySObjectFactoryOutletLookup {
	private static final Map<SObjectType, Type> OUTLET_TYPE_BY_SOBJECT_TYPE
			= new Map<SObjectType, Type>{
					Account.SObjectType => TEST_DummyAccountFactoryOutlet.class,
					Account_Channel__c.SObjectType => TEST_DummyAccountChannelFactoryOutlet.class,
					Acc_Channel_and_Item_Group_Connection__c.SObjectType => TEST_DummyAccountChannelItemGroupConn.class,
					Account_and_Item_Group_Connection__c.SObjectType => TEST_DummyAccountItmGrpCxnFactoryOutlet.class,
					Adyen_Payment_Line__c.SObjectType => TEST_DummyAdyenLineFactoryOutlet.class,
					Adyen_Payment_Transaction__c.SObjectType => TEST_DummyAdyenTransactionFactoryOutlet.class,
					Agent__c.SObjectType => TEST_DummyAgentFactoryOutlet.class,
					Apparels_sizes_order__c.SObjectType => TEST_DummyApparelsSizesOrderSettingFty.class,
					ATP__c.SObjectType => TEST_DummyAtpFactoryOutlet.class,
					B24_Integration_Model__c.SObjectType => TEST_DummyB24IntModelFactoryOutlet.class,
					Ascent2FF__Sales_Order_Posting_Profile__c.SObjectType => TEST_DummySOPostingProfileFactoryOutlet.class,
					Case.SObjectType => TEST_DummyCaseFactoryOutlet.class,
					Contact.SObjectType => TEST_DummyContactFactoryOutlet.class,
					ContentDocument.SObjectType => TEST_DummyContentDocumentFactoryOutlet.class,
					ContentDocumentLink.SObjectType => TEST_DummyContentDocumentLinkFtyOutlet.class,
					ContentVersion.SObjectType => TEST_DummyContentVersionFactoryOutlet.class,
					Collection__c.SObjectType => TEST_DummyCollectionFactoryOutlet.class,
					Collection_item__c.SObjectType => TEST_DummyCollectionItemFactoryOutlet.class,
					Collections_order__c.SObjectType => TEST_DummyCollectionsOrderFactoryOutlet.class,
					c2g__codaAccountingCurrency__c.SObjectType => TEST_DummyCodaAcctCurrencyFactoryOutlet.class,
					c2g__codaBankAccount__c.SObjectType => TEST_DummyCodaBankAccountFactoryOutlet.class,
					c2g__codaCompany__c.SObjectType => TEST_DummyCodaCompanyFactoryOutlet.class,
					c2g__codaExchangeRate__c.SObjectType => TEST_DummyCodeExchangeRateFactoryOutlet.class,
					c2g__codaGeneralLedgerAccount__c.SObjectType => TEST_DummyCodaGenLedgerAcctFactoryOutlet.class,
					c2g__codaInvoice__c.SObjectType => TEST_DummyCodaInvoiceFactoryOutlet.class,
					c2g__codaInvoiceLineItem__c.SObjectType => TEST_DummyCodaInvoiceLIFactoryOutlet.class,
					c2g__codaPayment__c.SObjectType => TEST_DummyCodaPaymentFactoryOutlet.class,
					c2g__codaPaymentAccountLineItem__c.SObjectType => TEST_DummyCodaPaymenAccountLineFtyOut.class,
					c2g__codaPaymentLineItem__c.SObjectType => TEST_DummyCodaPaymentLineItemFtyOutlet.class,
					c2g__codaPeriod__c.SObjectType => TEST_DummyCodaPeriodFactoryOutlet.class,
					c2g__codaPurchaseCreditNote__c.SObjectType => TEST_DummyCodaPurchaseNoteFactoryOutlet.class,
					c2g__codaPurchaseInvoice__c.SObjectType => TEST_DummyCodaPurchaseInvoiceFtyOutlet.class,
					c2g__codaTaxCode__c.SObjectType => TEST_DummyTaxCodeFactoryOutlet.class,
					c2g__codaUserCompany__c.SObjectType => TEST_DummyCodaUserCompanyFactoryOutlet.class,
					c2g__codaYear__c.SObjectType => TEST_DummyCodaYearFactoryOutlet.class,
					Despatch_Advice_Property__c.SObjectType => TEST_DummyDespatchAdvPropFactoryOutlet.class,
					Fabric__c.SObjectType => TEST_DummyFabricFactoryOutlet.class,
					Features_enable_disable_settings__c.SObjectType => TEST_DummyFeaturesSettingsFactoryOutlet.class,
					Group.SObjectType => TEST_DummyGroupFactoryOutlet.class,
					GroupMember.SObjectType => TEST_DummyGroupMemberFactoryOutlet.class,
					Inbound_Shipment__c.SObjectType => TEST_DummyInboundShipmentFactoryOutlet.class,
					Log__c.SObjectType => TEST_DummyLogFactoryOutlet.class,
					OM_Collection_settings__c.SObjectType => TEST_DummyOmCollectionSettingsFtyOutlet.class,
					On_Payment_Terms__c.SObjectType => TEST_DummyOnPaymentTermsFactoryOutlet.class,
					PBSI__Account_Group__c.SObjectType => TEST_DummyPbsiAccountGroupOutlet.class,
					PBSI__Admin__c.SObjectType => TEST_DummyPbsiAdminFactoryOutlet.class,
					PBSI__BOM_Depletion_Line__c.SObjectType => TEST_DummyBOMDepletionLineFactoryOutlet.class,
					PBSI__Item_Version__c.SObjectType => TEST_DummyPbsiItemVersionFactoryOutlet.class,
					PBSI__Lot__c.SObjectType => TEST_DummyPbsiLotFactoryOutlet.class,
					PBSI__Property__c.SObjectType => TEST_DummyPropertyFactoryOutlet.class,
					PBSI__PBSI_Inventory__c.SObjectType => TEST_DummyPbsiInventoryFactoryOutlet.class,
					PBSI__PBSI_Item__c.SObjectType => TEST_DummyPbsiItemFactoryOutlet.class,
					PBSI__PBSI_Item_Group__c.SObjectType => TEST_DummyPbsiItemGroupFactoryOutlet.class,
					PBSI__PBSI_Location__c.SObjectType => TEST_DummyPbsiLocationFactoryOutlet.class,
					PBSI__PBSI_Purchase_Order__c.SObjectType => TEST_DummyPbsiPurchaseOrderFactoryOutlet.class,
					PBSI__PBSI_Purchase_Order_Line__c.SObjectType => TEST_DummyPbsiPurchaseOrderLineFtyOutlet.class,
					PBSI__PBSI_Sales_Order__c.SObjectType => TEST_DummyPbsiSalesOrderFactoryOutlet.class,
					PBSI__PBSI_Sales_Order_Line__c.SObjectType => TEST_DummyPbsiSalesOrderLIFactoryOutlet.class,
					PBSI__Property__c.SObjectType => TEST_DummyPbsiPropertyFactoryOutlet.class,
					PBSI__RMA_Lines__c.SObjectType => TEST_DummyPbsiRmaLinesFactoryOutlet.class,
					PBSI__Trade_Agreement__c.SObjectType => TEST_DummyPbsiTradeAgrmtFactoryOutlet.class,
					PBSI__Transfer_Order__c.SObjectType => TEST_DummyTransferOrderFactoryOutlet.class,
					PBSI__Transfer_Order_Line__c.SObjectType => TEST_DummyTransferOrderLineFactoryOutlet.class,
					PBSI__Unit__c.SObjectType => TEST_DummyPbsiUnitFactoryOutlet.class,
					Product2.SObjectType => TEST_DummyProductFactoryOutlet.class,
					pw_ccpro__CountryObject__c.SObjectType => TEST_DummyCcProCountryFactoryOutlet.class,
					// QueueSobject => Can NOT be created because SFDC gets confused about QueueSobject.SObjectType
					RMA_Stage__c.SObjectType => TEST_DummyRmaStageFactoryOutlet.class,
					Sizes__c.SObjectType => TEST_DummySizesFactoryOutlet.class,
					Style_Year__c.SObjectType => TEST_DummyStyleYearFactoryOutlet.class,
					Teaser_Version__c.SObjectType => TEST_DummyTeaserVersionFactoryOutlet.class,
					Tracking__c.SObjectType => TEST_DummyTrackingFactoryOutlet.class,
					User.SObjectType => TEST_DummyUserFactoryOutlet.class
			};

	private static final Map<SObjectType, XFTY_DummyQueueSobjectFactoryOutletIntf> OUTLET_INSTANCE_BY_SOBJECT_TYPE
			= new Map<SObjectType, XFTY_DummyQueueSobjectFactoryOutletIntf>();

	public static XFTY_DummyQueueSobjectFactoryOutletIntf get(SObjectType sObjectType) {
		if (!OUTLET_INSTANCE_BY_SOBJECT_TYPE.containsKey(sObjectType)) {
			if (!(OUTLET_TYPE_BY_SOBJECT_TYPE.containsKey(sObjectType))) {
				new LookupException('No factory outlet found for : ' + sObjectType);
			}
			OUTLET_INSTANCE_BY_SOBJECT_TYPE.put(
					sObjectType,
					(XFTY_DummyQueueSobjectFactoryOutletIntf) (OUTLET_TYPE_BY_SOBJECT_TYPE.get(sObjectType)).newInstance()
			);
		}
		return OUTLET_INSTANCE_BY_SOBJECT_TYPE.get(sObjectType);
	}

	// --------------------------------------------------------------------------

	public class LookupException extends Exception {
	}
}