/**
 * Created by vvalitsky on 9/18/2019.
 */
({
    doInit: function(component, event, helper) {
            helper.getRecords(component);
    },

    changedWarehouse: function(component, event, helper) {
            var selected = Array.prototype.filter.call(component.find("selectedWarehouseId").getElement().options,
                    function(option) {
                        return option.selected;
                    }
                ).map(
                    function(option) {
                        return option.value;
                    }
                );
            component.set('v.selectWar', selected.valueOf());
    },

    displayDevice: function(component, event, helper) {
        var selectedWarehouse = event.getSource().get('v.value');
        helper.displayDeviceByWarehouse(component, selectedWarehouse);
    },

    assignDevice: function(component, event, helper) {
            var selectedDeviceParameter = event.getSource().get('v.value');
            var selectedWarehouseParameter = component.get('v.selectWar');
            helper.assignDeviceHelper(component, selectedDeviceParameter, selectedWarehouseParameter);
    },
})