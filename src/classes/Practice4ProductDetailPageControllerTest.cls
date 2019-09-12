/**
 * Created by vvalitsky on 9/12/2019.
 */

@IsTest
private class Practice4ProductDetailPageControllerTest {

    @testSetup
    static void setup() {
        Product_Table__c newProduct1 = new Product_Table__c(Name = 'TeslaZZ',
                Unit_Price__c = 20000,
                Units_Available__c = 10
        );
        insert newProduct1;
        Id productId = newProduct1.Id;
    }

    @IsTest
    static void getSelectedProductDetailTest() {
        Product_Table__c product = [SELECT Id, Name FROM Product_Table__c WHERE Name = 'TeslaZZ' LIMIT 1];
        Test.startTest();
        Practice4ProductDetailPageController controller = new Practice4ProductDetailPageController();
        controller.productId = product.Id;
        List<Product_Table__c> productTablesList = controller.getSelectedProductDetail();
        Test.stopTest();
        System.debug('product>>>>>' + product);
        System.assertEquals(1, productTablesList.size());
    }

    @IsTest
    static void toOrderPageTest() {
        Product_Table__c product = [SELECT Id, Name FROM Product_Table__c WHERE Name = 'TeslaZZ' LIMIT 1];
        Test.startTest();
        Practice4ProductDetailPageController pageController = new Practice4ProductDetailPageController();
        PageReference pageReference = Page.Practice4ProductDetailPage;
        pageReference.getParameters().put('Id', String.valueOf(product.Id));
        Test.setCurrentPage(pageReference);
        pageReference = pageController.toOrderPage();
        PageReference pageOrderReference = Page.Practice4OrderPage;
        Test.stopTest();
        String page1 = (pageOrderReference.getUrl() + '?id=' + String.valueOf(product.Id)).toUpperCase();
        String page2 = pageReference.getUrl().toUpperCase();
        System.assertEquals(page1, page2);
    }

    @IsTest
    static void toShoppingTest() {
        Test.startTest();
        Practice4ProductDetailPageController pageController = new Practice4ProductDetailPageController();
        PageReference pageReference = Page.Practice4ProductDetailPage;
        Test.setCurrentPage(pageReference);
        pageReference = pageController.toShopping();
        PageReference pageMainReference = Page.Practice4MainPage;
        Test.stopTest();
        String page1 = pageMainReference.getUrl().toUpperCase();
        String page2 = pageReference.getUrl().toUpperCase();
        System.assertEquals(page1, page2);
    }

}