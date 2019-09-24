/**
 * Created by vvalitsky on 9/20/2019.
 */
({
    getRecords : function(component){
        var action = component.get('c.getWarehousesName');
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                component.set('v.warehousesNameList', response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(action);
        },

        displayDeviceByWarehouse : function(component, selectedWarehouseParam){
            var action = component.get('c.devicesByWarehouse');
            action.setParams({selectedWarehouse : selectedWarehouseParam});
            action.setCallback(this, function(result){
                var custs = [];
                var conts = result.getReturnValue();
                for ( var key in conts ) {
                custs.push({value:conts[key], key:key});
                }
                component.set("v.devices", custs);
            });
         $A.enqueueAction(action);
        },

        assignDeviceHelper : function(component, selectedDeviceParam, selectedWarehouseParam){
             var action = component.get('c.assignDeviceOnWarehouse');
             action.setParams({'selectedDeviceParameter' : selectedDeviceParam,
             'selectedWarehouseParameter' : selectedWarehouseParam.valueOf()});
             action.setCallback(this, function(result){
             if(state === "SUCCESS"){
                 component.set('v.resultAssign', response.getReturnValue());
                 } else if (state === "ERROR") {
                     var errors = response.getError();
                     console.error(errors);
                 }
             });
             $A.enqueueAction(action);
        },
})