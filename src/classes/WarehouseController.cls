/**
 * Created by vvalitsky on 9/16/2019.
 */

global with sharing class WarehouseController {

    @AuraEnabled
    public static List<String> getWarehousesName() {
        List<Warehouse__c> warehousesList = [SELECT Name FROM Warehouse__c];
        List<String> warehousesNameList = new List<String>();
        if (!warehousesList.isEmpty()) {
            for (Warehouse__c w : warehousesList) {
                warehousesNameList.add(w.Name);
            }
        }
        return warehousesNameList;
    }

    @AuraEnabled
    public static Map<String, String > devicesByWarehouse(String selectedWarehouse) {
        Map<String, String > devicesMap = new Map<String, String >();
        List<Warehouse__c> warehousesList = [
                SELECT Id, Name
                FROM Warehouse__c
                WHERE Name = :selectedWarehouse
        ];
        Id warehouseId = warehousesList[0].Id;
        List<DeviceInWarehouse__c> deviceInWarehousesList = [
                SELECT Name,Count__c, Device__c, Warehouse__c
                FROM DeviceInWarehouse__c
                WHERE Warehouse__c = :warehouseId
        ];
        if (!deviceInWarehousesList.isEmpty()) {
            for (DeviceInWarehouse__c diw : deviceInWarehousesList) {
                devicesMap.put(changeIdForName(diw.Device__c), String.valueOf(diw.Count__c));
            }
        }
        return devicesMap;
    }

    public static String changeIdForName(Id id) {
        String name = [SELECT Name FROM Device__c WHERE Id = :id LIMIT 1].Name;
        return name;
    }

    public static Id changeDeviceNameForId(String name) {
        Id deviceId = [SELECT Id, Name FROM Device__c WHERE Name = :name LIMIT 1].Id;
        return deviceId;
    }

    public static Id changeWarehouseNameForId(String warehouseName) {
        Id warehouseId = [SELECT Id, Name FROM Warehouse__c WHERE Name = :warehouseName LIMIT 1].Id;
        return warehouseId;
    }

    @AuraEnabled
    public static String assignDeviceOnWarehouse(String selectedDeviceParameter, List<String> selectedWarehouseParameter) {
        String result;
        Id deviceId = changeDeviceNameForId(selectedDeviceParameter);
        String nameForId = String.valueOf(selectedWarehouseParameter[0]);
        Id warehouseId = changeWarehouseNameForId(nameForId);
        DeviceInWarehouse__c deviceInWarehouses = [
                SELECT Name,Count__c, Device__c, Warehouse__c
                FROM DeviceInWarehouse__c
                WHERE Device__c = :deviceId
                LIMIT 1
        ];
        String indexOfWarehouseName = deviceInWarehouses.Name.substringAfterLast('_');
        deviceInWarehouses.Name = nameForId + '_' + selectedDeviceParameter + '_' + indexOfWarehouseName;
        deviceInWarehouses.Warehouse__c = warehouseId;
        if (deviceInWarehouses != null) {
            try {
                upsert deviceInWarehouses;
                result = 'Upsert is SUCCESS';
            } catch (DmlException de) {
                result = 'Upsert is Faild';
            }
        }
        return result;
    }

}