/**
 * Created by vvalitsky on 9/23/2019.
 */

@IsTest
private class WarehouseControllerTest {

    @testSetup
    static void setup() {
        Warehouse__c newWarehouse1 = new Warehouse__c(Name = 'WarehouseX');
        Warehouse__c newWarehouse2 = new Warehouse__c(Name = 'WarehouseY');
        insert newWarehouse1;
        insert newWarehouse2;
        Device__c newDevice1 = new Device__c(Name = 'NoteBook');
        Device__c newDevice2 = new Device__c(Name = 'PC');
        insert newDevice1;
        insert newDevice2;
        DeviceInWarehouse__c deviceInWarehouse1 = new DeviceInWarehouse__c(
                Name = 'WarehouseX_NoteBook_0',
                Count__c = 10,
                Warehouse__c = newWarehouse1.Id,
                Device__c = newDevice1.Id
        );
        DeviceInWarehouse__c deviceInWarehouse2 = new DeviceInWarehouse__c(
                Name = 'WarehouseX_PC_0',
                Count__c = 20,
                Warehouse__c = newWarehouse1.Id,
                Device__c = newDevice2.Id
        );
        insert deviceInWarehouse1;
        insert deviceInWarehouse2;
    }

    @IsTest
    static void testGetWarehousesName() {
        List<String> warehousesNameList = WarehouseController.getWarehousesName();
        System.assertEquals(warehousesNameList[0], 'WarehouseX');
    }

    @IsTest
    static void testDevicesByWarehouse() {
        Map<String, String > devicesByWarehouseMap = WarehouseController.devicesByWarehouse('WarehouseX');
        List<String> deviceNameList = new List<String>();
        for (String key : devicesByWarehouseMap.keySet()){
            deviceNameList.add(key);
        }
        System.assertEquals(deviceNameList.size(), 2);
        System.assertEquals(deviceNameList[0], 'NoteBook');
    }

}