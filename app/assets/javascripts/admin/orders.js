
var SelectedExport = {};

SelectedExport.submit = function() {
  $('#action_type').val('export');
  $('#batch_form').submit();
};

SelectedExport.pdf = function(event) {
  $('#export_data_type').val('pdf');
  SelectedExport.submit();
};

SelectedExport.csv = function(event) {
  $('#export_data_type').val('csv');
  SelectedExport.submit();
};


var SelectedStatus = {};

SelectedStatus.submit = function() {
  $('#action_type').val('state');
  $('#batch_form').submit();
};

Se
var SelectedExport = {};

SelectedExport.submit = function() {
  $('#action_type').val('export');
  $('#batch_form').submit();
};

SelectedExport.pdf = function(event) {
  $('#export_data_type').val('pdf');
  SelectedExport.submit();
};

SelectedExport.csv = function(event) {
  $('#export_data_type').val('csv');
  SelectedExport.submit();
};


var SelectedStatus = {};

SelectedStatus.submit = function() {
  $('#action_type').val('state');
  $('#batch_form').submit();
};

SelectedStatus.change_status = function(state) {
  $('#new_state').val(state);
  SelectedStatus.submit();
};


var ReadyToShipExport = {};
ReadyToShipExport.current_modal_id = '';
ReadyToShipExport.export_prepare_url = '';

ReadyToShipExport._show_modal = function(modal_id, orders_count) {
  $('.modal_stock_count').html(orders_count);
  $(modal_id).modal('show');
}

ReadyToShipExport._prepare = function(weight_type) {
  var orders_export = {};
  orders_export.weight_type = weight_type;

  $.ajax({
    type: 'POST',
    url: ReadyToShipExport.export_prepare_url,
    data: orders_export,
    dataType: 'json',
    success: function(response) {
      ReadyToShipExport._show_modal(ReadyToShipExport.current_modal_id, response.exported_orders);
    }
  });
}

ReadyToShipExport.low = function(event) {
  ReadyToShipExport.current_modal_id = '#orderLowExportModal';
  ReadyToShipExport._prepare('low');
}

ReadyToShipExport.high = function(event) {
  ReadyToShipExport.current_modal_id = '#orderHighExportModal';
  ReadyToShipExport._prepare('high');
}

ReadyToShipExport.finish = function(weight_type) {
  $('.form_weight_type').val(weight_type);
  $('#expor_finish_form').submit();
}
