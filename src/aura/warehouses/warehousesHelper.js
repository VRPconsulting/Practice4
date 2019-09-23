/**
 * Created by vvalitsky on 9/20/2019.
 */
({
    getRecords : function(component){
        var action = component.get('c.getWarehousesName');
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                console.log(response.getReturnValue());
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
                console.log('SUCCESS');
                console.log('result---- ' + result.getReturnValue());
                var custs = [];
                var conts = result.getReturnValue();
                console.log('conts---- ' + conts);
                for ( var key in conts ) {
                custs.push({value:conts[key], key:key});
                }

                console.log('custs' + custs);
                component.set("v.devices", custs);
            });
         $A.enqueueAction(action);
        },
        assignDeviceHelper : function(component, selectedDeviceParam, selectedWarehouseParam){
             var action = component.get('c.assignDeviceOnWarehouse');
             action.setParams({selectedDeviceParameter : selectedDeviceParam, selectedWarehouseParameter : selectedWarehouseParam});
             console.log('selectedDeviceParam///////////' + selectedDeviceParam);
             console.log('selectedWarehouseParam+++++++++' + selectedWarehouseParam);
             action.setCallback(this, function(result){
                 console.log('state: ' + state);
             if(state === "SUCCESS"){
                 console.log(response.getReturnValue());
                 component.set('v.resultAssign', response.getReturnValue());
                 } else if (state === "ERROR") {
                     var errors = response.getError();
                     console.error(errors);
                 }
             });
             $A.enqueueAction(action);
        },
})