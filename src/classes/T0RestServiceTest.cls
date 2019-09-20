/**
 * Created by vvalitsky on 9/19/2019.
 */

@IsTest
public class T0RestServiceTest {
    @IsTest
    static void testGetWarehouses() {
        RestRequest request = new RestRequest();
        request.requestURI = 'https://valitsky-dev-ed.lightning.force.com/services/apexrest/Warehouse/';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf
                ('[{"WarehouseName":"Warehouse16","Devices":[{"DeviceName":"Iphone3","DeviceCount":20},' +
                        '{"DeviceName":"Iphone2","DeviceCount":10}]}]');
        RestContext.request = request;
        List<DeviceInWarehouse__c> resultList = T0RestService.getWarehouses();
        System.assertEquals(resultList[0].Name, 'Warehouse16_Iphone3_0');
    }

    @IsTest
    static void testGetWarehousesDublicate() {
        Device__c newDevice1 = new Device__c(Name = 'Iphone4');
        Device__c newDevice2 = new Device__c(Name = 'Iphone5');
        insert newDevice1;
        insert newDevice2;
        Warehouse__c newWarehouse = new Warehouse__c(Name = 'Warehouse13');
        insert newWarehouse;
        RestRequest request = new RestRequest();
        request.requestURI = 'https://valitsky-dev-ed.lightning.force.com/services/apexrest/Warehouse/';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf
                ('[{"WarehouseName":"Warehouse13","Devices":[{"DeviceName":"Iphone4","DeviceCount":20},' +
                        '{"DeviceName":"Iphone5","DeviceCount":30}]}]');
        RestContext.request = request;
        List<DeviceInWarehouse__c> resultList = T0RestService.getWarehouses();
        System.assertEquals(resultList[0].Name, 'Warehouse13_Iphone4_0');
    }

}