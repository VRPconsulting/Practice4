/**
 * Created by vvalitsky on 9/12/2019.
 */

@IsTest
private class Practice4OrderPageControllerTest {

    @testSetup
    static void setup() {
        Product_Table__c newProduct2 = new Product_Table__c(Name = 'TeslaRR',
                Unit_Price__c = 20000,
                Units_Available__c = 10
        );
        insert newProduct2;
    }

    @ISTest static  void calculateTotalAmountTest() {
        Product_Table__c product = [SELECT Name, Product_Description__c, Units_Available__c, Unit_Price__c, Image_Url__c
        FROM Product_Table__c LIMIT 1];
        Practice4OrderPageController controllerAmount = new Practice4OrderPageController();
        controllerAmount.productById = product;
        controllerAmount.unitCount = 1;
        Test.startTest();
        controllerAmount.calculateTotalAmount();
        Double totalAmount = controllerAmount.totalAmount;
        Test.stopTest();
        system.assertEquals(20000, totalAmount);
    }

    @ISTest static  void buyTest() {
        List<Contact> newContacts = [SELECT id, Name FROM Contact WHERE Email = 'ter@mail.ru'];
        Product_Table__c productT = [SELECT Name, Product_Description__c, Units_Available__c, Unit_Price__c, Image_Url__c
        FROM Product_Table__c LIMIT 1];
        Practice4OrderPageController controller = new Practice4OrderPageController();
        controller.productId = productT.Id;
        controller.findContactList = newContacts;
//        controller.productById = productT;
        controller.unitCount = 5;
        controller.contactFirstName = 'testForTest';
        controller.contactLastName = 'LastNameForTest';
        controller.contactEmail = 'test@test.test';
        Test.startTest();
        controller.buy();
        Test.stopTest();
        system.assert( controller.newContact != null);
    }

    @IsTest
    static void toShoppingTest() {
        Test.startTest();
        Practice4ProductDetailPageController pageController = new Practice4ProductDetailPageController();
        PageReference pageReference = Page.Practice4OrderPage;
        Test.setCurrentPage(pageReference);
        pageReference = pageController.toShopping();
        PageReference pageMainReference = Page.Practice4MainPage;
        Test.stopTest();
        String page1 = pageMainReference.getUrl().toUpperCase();
        String page2 = pageReference.getUrl().toUpperCase();
        System.assertEquals(page1, page2);
    }

}