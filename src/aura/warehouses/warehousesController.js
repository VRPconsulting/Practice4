/**
 * Created by vvalitsky on 9/18/2019.
 */
({
    doInit: function(component, event, helper) {
            helper.getRecords(component);
        },

    changedWarehouse: function(component, event, helper) {
            console.log('222222');
            var selectedWar = component.find('selectedWarehouseId').get('v.value');
//            var selectedWar = component.get('v.value');
            console.log('selectedWar>>>' + selectedWar);
            component.set('v.selectWar', selectedWar);

             },

    displayDevice: function(component, event, helper) {
        console.log('111111');
        var selectedWarehouse = event.getSource().get('v.value');
        console.log('selectedWarehouse>>>' + selectedWarehouse);
        helper.displayDeviceByWarehouse(component, selectedWarehouse);

         },


    assignDevice: function(component, event, helper) {
            var selectedDeviceParameter = event.getSource().get('v.value');
            var selectedWarehouseParameter = component.get('v.selectWar');
            console.log('selectedDeviceParameter>>>' + selectedDeviceParameter);
            console.log('selectedWarehouseParameter>>>' + selectedWarehouseParameter);
            helper.assignDeviceHelper(component, selectedDeviceParameter, selectedWarehouseParameter);

     },

})