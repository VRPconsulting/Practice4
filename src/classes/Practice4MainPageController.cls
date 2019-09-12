/**
 * Created by vvalitsky on 9/10/2019.
 */

public with sharing class Practice4MainPageController {
    public List<Product_Table__c> productsList { get; set; }
    public Practice4MainPageController() {
        productsList = [
                SELECT Id, Name, Image_Url__c, Product_Description__c, Unit_Price__c, Units_Available__c
                FROM Product_Table__c
        ];
    }

    public List<Product_Table__c> getProducts(){
        return productsList;
    }

    public PageReference toDetailPage(){
        Id id = System.currentPageReference().getParameters().get('id');
        PageReference page = new PageReference('/apex/Practice4ProductDetailPage?id=' + id);
        return page;
    }

}