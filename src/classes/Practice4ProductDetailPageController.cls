/**
 * Created by vvalitsky on 9/10/2019.
 */

public with sharing class Practice4ProductDetailPageController {
    public Id productId{get; set;}
    public List<Product_Table__c> carList { get; set; }

    public Practice4ProductDetailPageController(){
        productId = ApexPages.currentPage().getParameters().get('Id');
        carList = [
                SELECT Id, Name, Image_Url__c, Product_Description__c, Unit_Price__c, Units_Available__c
                FROM Product_Table__c WHERE Id =: productId
        ];
    }

    public List<Product_Table__c> getSelectedProductDetail(){
        return carList;
    }

    public PageReference toShopping(){
        PageReference cancelReference = new PageReference('/apex/Practice4MainPage');
        cancelReference.setRedirect(true);
        return cancelReference;
    }

    public PageReference toOrderPage(){
        Id orderId = System.currentPageReference().getParameters().get('id');
        PageReference orderPage = new PageReference('/apex/Practice4OrderPage?id=' + orderId);
        return orderPage;
    }


}