/**
 * Created by vvalitsky on 9/18/2019.
 */

@RestResource(urlMapping='/Warehouse/*')
global with sharing class T0RestService {

    global class WarehouseWrapper {
        public String warehouseName;
        public List<DeviceWrapper> devices;
    }

    global class DeviceWrapper {
        public String DeviceName;
        public Decimal DeviceCount;
    }

    @HttpPost
    global static List<DeviceInWarehouse__c> getWarehouses() {

        RestRequest request = RestContext.request;
        List<WarehouseWrapper> warehouseWrappersList = (List<WarehouseWrapper>)
                System.JSON.deserialize(request.requestbody.tostring(), List<WarehouseWrapper>.class);
        List<Warehouse__c> newWarehousesList = new List<Warehouse__c>();
        List<Device__c> newDevicesList = new List<Device__c>();
        List<DeviceInWarehouse__c> deviceInWarehousescesList = new List<DeviceInWarehouse__c>();
        List<String> warehousesNameList = new List<String>();
        List<String> deviceNamesList = new List<String>();
        Map<String, List<DeviceWrapper>> deviceByWarehouseMap = new Map<String, List<DeviceWrapper>>();
        List<DeviceInWarehouse__c> newDeviceInWarehousescesList = new List<DeviceInWarehouse__c>();

        for (WarehouseWrapper wrapper : warehouseWrappersList) {
            warehousesNameList.add(wrapper.warehouseName);
            for (DeviceWrapper deviceWrapper : wrapper.devices) {
                deviceNamesList.add(deviceWrapper.DeviceName);
            }
            deviceByWarehouseMap.put(wrapper.warehouseName, wrapper.devices);
        }
        List<Warehouse__c> warehousesList = [SELECT Id, Name FROM Warehouse__c WHERE Name IN :warehousesNameList];
        List<String> warehouseOrgNameList = new List<String>();
        for (Warehouse__c w : warehousesList) {
            warehouseOrgNameList.add(w.Name);
        }
        if (!warehouseOrgNameList.isEmpty()) {
            for (String warehouseName : warehousesNameList) {
                if (!warehouseOrgNameList.contains(warehouseName)) {
                    newWarehousesList.add(new Warehouse__c(Name = warehouseName));
                }
            }
        } else {
            for (String warehouseName : warehousesNameList) {
                newWarehousesList.add(new Warehouse__c(Name = warehouseName));
            }
        }
        if (!newWarehousesList.isEmpty()) {
            try {
                insert newWarehousesList;
            } catch (DmlException de) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,
                        'Exception. Fail insert of Warehouses:: ' + de.getMessage()));
            }
        }
        List<Device__c> devicesList = [SELECT Id, Name FROM Device__c WHERE Name IN :deviceNamesList];
        List<String> devicesOrgNameList = new List<String>();
        for (Device__c d : devicesList) {
            devicesOrgNameList.add(d.Name);
        }
        if (!devicesOrgNameList.isEmpty()) {
            for (String deviceName : deviceNamesList) {
                if (!devicesOrgNameList.contains(deviceName)) {
                    newDevicesList.add(new Device__c(Name = deviceName));
                }
            }
        } else {
            for (String deviceName : deviceNamesList) {
                newDevicesList.add(new Device__c(Name = deviceName));
            }
        }
        if (!newDevicesList.isEmpty()) {
            try {
                insert newDevicesList;
            } catch (DmlException de) {
                System.debug('Exception. Fail insert of Devices: ' + de.getMessage());
            }
        }
        List<Warehouse__c> newWarehousesOrgList = [SELECT Id, Name FROM Warehouse__c WHERE Name IN :warehousesNameList];
        List<Device__c> newDevicesOrgList = [SELECT Id, Name FROM Device__c WHERE Name IN :deviceNamesList];
        Map<String, Id> newWarehouseMap = new Map<String, Id>();
        Map<String, Id> newDeviceMap = new Map<String, Id>();
        if (!newWarehousesOrgList.isEmpty()) {
            for (Warehouse__c w : newWarehousesOrgList) {
                newWarehouseMap.put(w.Name, w.Id);
            }
        }
        if (!newDevicesOrgList.isEmpty()) {
            for (Device__c d : newDevicesOrgList) {
                newDeviceMap.put(d.Name, d.Id);
            }
        }
        if (!deviceByWarehouseMap.isEmpty()) {
            Integer i = 0;
            for (String key : deviceByWarehouseMap.keySet()) {
                List<DeviceWrapper> tempDeviceWrappersList = deviceByWarehouseMap.get(key);
                for (DeviceWrapper dw : tempDeviceWrappersList) {
                    String tempDeviceName = dw.DeviceName;
                    Decimal tempCount = (Decimal) dw.DeviceCount;
                    String newDeviceInWarehouseName = key + '_' + tempDeviceName + '_' + i;
                    DeviceInWarehouse__c newDeviceInWarehouse = new DeviceInWarehouse__c(
                            Name = newDeviceInWarehouseName,
                            Count__c = tempCount
                    );
                    deviceInWarehousescesList.add(newDeviceInWarehouse);
                    i++;
                }
                newDeviceInWarehousescesList = assignIdOnDeviceInWarehouse(deviceInWarehousescesList, newWarehouseMap,
                        newDeviceMap);
            }
            if (!newDeviceInWarehousescesList.isEmpty()) {
                try {
                    upsert newDeviceInWarehousescesList;
                } catch (DmlException de) {
                    System.debug('Fail upsert of Device in Warehousesces: ' + de.getMessage());
                }
            }
        }
        return newDeviceInWarehousescesList;
    }

    public static List<DeviceInWarehouse__c> assignIdOnDeviceInWarehouse(List<DeviceInWarehouse__c> DIWList,
            Map<String, Id> warehouseMap, Map<String, Id> devMap) {
        if (!DIWList.isEmpty()) {
            for (DeviceInWarehouse__c diw : DIWList) {
                for (String key : warehouseMap.keySet()) {
                    if (trimWareName(diw.Name) == key) {
                        diw.Warehouse__c = warehouseMap.get(key);
                    }
                }
            }
            for (DeviceInWarehouse__c diw : DIWList) {
                for (String key : devMap.keySet()) {
                    if ((trimDeviceName(diw.Name) == key)) {
                        diw.Device__c = devMap.get(key);
                    }
                }
            }
        }
        return DIWList;
    }

    public static String trimWareName(String str) {
        String newString = str.substringBefore('_');
        return newString;
    }

    public static String trimDeviceName(String str) {
        String newString = str.substringBetween('_');
        return newString;
    }

}