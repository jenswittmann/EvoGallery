<script type="text/javascript" charset="utf-8">
$(document).ready(function(){
    $.execAction = function(obj, params) {
		var overlay = $(obj).overlay({
			api: 'true',
			target: '#operation-popup',
			oneInstance: true,
			closeOnEsc: false,
			closeOnClick: false,
			onBeforeLoad: function() {
				$("#operation-popup div.status").text('[+lang.please_wait+]');
				$("#operation-popup div.progress").hide();
				$("#operation-popup div.close").hide();
			},
			onLoad: function() {
				$.startOperation = function(ids) {
					if (ids!=null && ids.length) {
						var i = 0;
						$.showProgress = function() {
							var progressText = '[+lang.operation_progress+]'.replace('{current}',i).replace('{total}',ids.length);
							$("#operation-popup div.progress").text(progressText).css('display','block');
						}
						$.showProgress();
						$("#operation-popup div.progress").css('display','block');
						$("#operation-popup div.status").ajaxError( function () {
							$(this).text('[+lang.operation_error+]');
							$("#operation-popup div.progress").hide();
							$("#operation-popup div.close").show();
						});

						$.postAction = function(){
							$.post("[+base_path+]action.php", 
								{[+params+], 'action': params['action'], 'mode': 'id', 'action_ids': ids},
								$.operation_callback
							);
						}
						$.operation_callback = function (data,status){
								$("#operation-popup div.progress").hide();
								$("#operation-popup div.status").text('[+lang.operation_complete+]');
								$("#operation-popup div.close").show();
						}
						$.postAction();
					} else {
						$("#operation-popup div.status").text('[+lang.operation_complete+]');
						$("#operation-popup div.close").css('display','block');
					}
				}
				if (params['mode']!='id') {
					$.get("[+base_path+]action.php",
							{[+params+], 'action': 'getids', 'mode': params['mode'], 'action_ids': params['action_ids']},
							function(response, textStatus){
								if (response['result']=='ok')
									$.startOperation(response['ids']);
								else
									alert(response['msg']);
							}, 'json'
					);		
				} else {
					$.startOperation(params['action_ids']);
				}
			}, //onLoad	
			onClose: function() {
				$("#operation-popup div.status").unbind('ajaxError');
			}
		});
		overlay.load();
	}
   
    $('#cmdAllDel').click(function(){
		if(confirm('[+lang.delete_all_confirm+]')){
			$.execAction(this, {'action': 'deleteall', 'mode': 'all'});
		}
        return false;
    });

    $('#cmdAllRegenerate').click(function(){
		if(confirm('[+lang.regenerate_all_confirm+]')){
			$.execAction(this, {'action': 'regenerateall', 'mode': 'all'});
		}
        return false;
    });

	if (!$('#subdocs').length)
		$('#galcontrols').hide();
	if (!$('#dropzone').length)
		$('#doccontrols').hide();

});

$(window).bind('load', function() {
	/*並び替え等のボタン表示*/
	if ($("#uploadList li").length) {
		$("#selectallcontrols").show();
		$("#sortcontrols").show();
	}
});

</script>
