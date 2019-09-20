/**
 * Created by vvalitsky on 9/16/2019.
 */

global with sharing class WarehouseController {

    global class DeviceWrapper {
        @AuraEnabled
        public String warehouseName;

        public String deviceName;

        public Decimal count;
        global DeviceWrapper(String name, Decimal count) {
            this.deviceName = name;
            this.count = count;
        }

    }

    @AuraEnabled
    public static List<String> getWarehousesName() {
        List<Warehouse__c> warehousesList = [SELECT Name FROM Warehouse__c];
        List<String> warehousesNameList = new List<String>();
        if (!warehousesList.isEmpty()) {
            for (Warehouse__c w : warehousesList) {
                warehousesNameList.add(w.Name);
            }
        }
        System.debug('warehousesNameList>>>' + warehousesNameList);
        return warehousesNameList;
    }

    @AuraEnabled
    public static Map<String, String >  devicesByWarehouse(String selectedWarehouse) {
        System.debug('selectedWarehouse:>>>>>>>>>>>>>>> ' + selectedWarehouse);
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
            for (DeviceInWarehouse__c diw : deviceInWarehousesList){
                devicesMap.put(changeIdForName(diw.Device__c), String.valueOf(diw.Count__c));
            }
        }
        System.debug('devicesMap: ' + devicesMap);
        return devicesMap;
    }

    public static String changeIdForName(Id id){
        String name = [SELECT Name FROM Device__c WHERE Id = :id LIMIT 1].Name;
        return name;
    }

    public static Id changeNameForId(String name){
        Id deviceId = [SELECT Id, Name FROM Device__c WHERE Name = :name LIMIT 1].Id;
        System.debug('deviceId>>' + deviceId);
        return deviceId;
    }

    @AuraEnabled
    public static String  getDevicesByWarehouse111(String selectedDeviceP, String selectedWarehouseP) {
        String result;
        Id deviceId = changeNameForId(selectedDeviceP);
        Id warehouseId = changeNameForId(selectedWarehouseP);
        System.debug('deviceId>' + deviceId);
        System.debug('warehouseId>' + warehouseId);
        DeviceInWarehouse__c deviceInWarehouses = [
                SELECT Name,Count__c, Device__c, Warehouse__c
                FROM DeviceInWarehouse__c
                WHERE Device__c = :deviceId
                LIMIT 1
        ];
        String indexOfWarehouseName = deviceInWarehouses.Name.substringAfterLast('_');
        deviceInWarehouses.Name = selectedWarehouseP + '_' + selectedDeviceP + '_' + indexOfWarehouseName;
        deviceInWarehouses.Warehouse__c = warehouseId;
        System.debug('deviceInWarehouses>>>>>' + deviceInWarehouses);

        if (deviceInWarehouses != null) {
            try {
                upsert deviceInWarehouses;
                result = 'Upsert is SUCCESS';
            } catch (DmlException de) {
                result = 'Upsert is Faild';
                System.debug('Exception. Fail insert of Devices: ' + de.getMessage());
            }
        }
        return result;
    }

}