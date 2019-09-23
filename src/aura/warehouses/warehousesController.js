/**
 * Created by vvalitsky on 9/18/2019.
 */
({
    doInit: function(component, event, helper) {
            helper.getRecords(component);
        },
    changedWarehouse: function(component, event, helper) {
            console.log('222222');
            var selected = Array.prototype.filter.call(component.find("selectedWarehouseId").getElement().options,
                    function(option) {
                        return option.selected;
                    }
                ).map(
                    function(option) {
                        return option.value;
                    }
                );
            console.log('selected>>>****' + selected);
            component.set('v.selectWar', selected);
             },
    displayDevice: function(component, event, helper) {
        console.log('111111');
        var selectedWarehouse = event.getSource().get('v.value');
        console.log('selectedWarehouse>>>' + selectedWarehouse);
        helper.displayDeviceByWarehouse(component, selectedWarehouse);
         },
    assignDevice: function(component, event, helper) {
        console.log('33333');
            var selectedDeviceParameter = event.getSource().get('v.value');
            var selectedWarehouseParameter = component.get('v.selectWar');
            console.log('selectedDeviceParameter>>>' + selectedDeviceParameter);
            console.log('selectedWarehouseParameter>>>' + selectedWarehouseParameter);
            helper.assignDeviceHelper(component, selectedDeviceParameter, selectedWarehouseParameter);
     },
})