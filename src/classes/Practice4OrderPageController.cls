/**
 * Created by vvalitsky on 9/10/2019.
 */

public with sharing class Practice4OrderPageController {

    public List<Contact> findContactList { get; set; }
    public Contact newContact { get; set; }
    public Order_Table__c newOrder { get; set; }
    public Id productId { get; set; }
    public Contact contact { get; set; }
    public String contactFirstName { get; set; }
    public String contactLastName { get; set; }
    public String contactEmail { get; set; }
    public Integer unitCount { get; set; }
    public Double totalAmount { get; set; }
    public Product_Table__c productById { get; set; }

    public Practice4OrderPageController() {
        productId = ApexPages.currentPage().getParameters().get('id');
        productById = [
                SELECT Id, Name, Unit_Price__c, Units_Available__c
                FROM Product_Table__c
                WHERE Id = :productId
                LIMIT 1
        ];
    }

    public Product_Table__c getSelectedProduct() {
        return productById;
    }

    public void calculateTotalAmount() {
        totalAmount = productById.Unit_Price__c * unitCount;
    }

    public PageReference toShopping() {
        PageReference cancelReference = new PageReference('/apex/Practice4MainPage');
        cancelReference.setRedirect(true);
        return cancelReference;
    }

    public void buy() {
        if (contactLastName == null || contactEmail == null || unitCount == null || unitCount == 0) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,
                    'Field Last Name and Email are required. Unit Count must have been more then 0. ' +
                            'Please enter value.'));
        }

        findContactList = [SELECT FirstName, LastName, Email FROM Contact WHERE Email = :contactEmail];
        if (!findContactList.isEmpty()) {
            newContact = new Contact(FirstName = findContactList[0].FirstName,
                    LastName = findContactList[0].LastName,
                    Email = findContactList[0].Email);
            try {
                update newContact;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'Contact upsert successfully.'));
            } catch (DmlException de) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,
                        'Contact don\'t upsert. Exception' + de.getMessage()));
            }
            createOrder(newContact);
        } else {
            newContact = new Contact(FirstName = contactFirstName,
                    LastName = contactLastName,
                    Email = contactEmail);
            try {
                insert newContact;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'Contact upsert successfully.'));
            } catch (DmlException de) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,
                        'Contact don\'t upsert. Exception' + de.getMessage()));
            }
            createOrder(newContact);
        }
    }

    public void createOrder(Contact con) {
        if (unitCount <= productById.Units_Available__c && unitCount > 0) {
            newOrder = new Order_Table__c(Contact__c = newContact.Id,
                    Product__c = productById.Id,
                    Units__c = unitCount,
                    Order_Amount__c = totalAmount);
            try {
                insert newOrder;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'Order insert successfully.'));
            } catch (DmlException de) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,
                        'Order don\'t insert. Exception' + de.getMessage()));
            }
            productById.Units_Available__c -= unitCount;
            try {
                upsert productById;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'Product upsert successfully.'));
            } catch (DmlException de) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,
                        'Product don\'t upsert. Exception' + de.getMessage()));
            }
        } else {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,
                    'Unit count more then we have on warehouse. Reduce Unit Count or wait new apply.'));
        }
    }

}