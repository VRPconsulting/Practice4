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

    @IsTest
    static void buyTest() {
        Product_Table__c product = [SELECT Id, Name FROM Product_Table__c WHERE Name='TeslaRR' LIMIT 1];
        Practice4OrderPageController controller = new Practice4OrderPageController();
        controller.productById = product;
        controller.contactfFirstName = 'Adam';
        controller.contactLastName = 'Troy';
        controller.contactEmail = 'at@gmail.com';
        controller.unitCount = 1;
        controller.totalAmount = 20000;
        controller.productId = product.Id;

        Test.startTest();
        controller.buy();
        Test.stopTest();
        List<Contact> createdContactList = [SELECT Id, Name FROM Contact WHERE Email = 'at@gmail.com'];
        System.debug('product>>>>>' + product);
        System.assertEquals(1, createdContactList.size());
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