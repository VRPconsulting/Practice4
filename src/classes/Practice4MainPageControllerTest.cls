/**
 * Created by vvalitsky on 9/12/2019.
 */

@IsTest
private class Practice4MainPageControllerTest {

    @testSetup
    static void setup() {
        Product_Table__c newProduct = new Product_Table__c(Name = 'TeslaZ',
                Unit_Price__c = 20000,
                Units_Available__c = 10
        );
        insert newProduct;
    }

    @IsTest
    static void getProductsTest() {
        Practice4MainPageController controller = new Practice4MainPageController();
        List<Product_Table__c> productTablesList = controller.getProducts();
        System.debug('productTablesList' + productTablesList);
        System.assertEquals(productTablesList.size(), 1);
    }

    @IsTest
    static void toDetailPageTest() {
        Test.startTest();
        Practice4MainPageController pageController = new Practice4MainPageController();
        PageReference pageReference = Page.Practice4MainPage;
        pageReference.getParameters().put('Id', String.valueOf(pageController.getProducts()[0].Id));
        Test.setCurrentPage(pageReference);
        pageReference = pageController.toDetailPage();
        PageReference pageDetailReference = Page.Practice4ProductDetailPage;
        Test.stopTest();
        String page1 = (pageDetailReference.getUrl()+ '?id=' + pageController.getProducts()[0].Id).toUpperCase();
        String page2 = pageReference.getUrl().toUpperCase();
        System.assertEquals(page1, page2);
    }

}