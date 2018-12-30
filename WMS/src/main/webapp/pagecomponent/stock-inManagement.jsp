<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script>
    // 出入库记录查询参数
    search_type = 'searchAll'
    supplierName = "";

    $(function(){
        //supplierSelectorInit();
        optionAction();
        storageListInit();
        searchAction();

    })


    // 下拉框选择
    function optionAction() {
        $(".dropOption").click(function() {
            var type = $(this).text();
            $("#search_input").val("");
            if (type == "所有") {
                $("#search_input").attr("readOnly", "true");
                search_type_supplier = "searchAll";
            } else if (type == "公司名称") {
                $("#search_input").removeAttr("readOnly");
                search_type_supplier = "searchByName";
            } else {
                $("#search_input").removeAttr("readOnly");
            }

            $("#search_type").text(type);
            $("#search_input").attr("placeholder", type);
        })
    }


    // 表格初始化
    function storageListInit() {
        $('#stockRecords').bootstrapTable(
            {
                columns: [
                    {
                        field: 'supplierName',
                        title: '供应商名称'
                    },
                    {
                        field: 'goodID',
                        title: '材料名称'
                    },
                    {
                        field: 'number',
                        title: '数量'
                        //visible : false
                    },
                    {
                        field: 'time',
                        title: '日期'
                    },
                    {
                        field: 'personInCharge',
                        title: '经手人'
                    },
                    ],
                url: 'stockRecordManage/searchInRecord',
                onLoadError: function (status) {
                    handleAjaxError(status);
                },
                method: 'GET',
                queryParams: queryParams,
                sidePagination: "server",
                dataType: 'json',
                pagination: true,
                pageNumber: 1,
                pageSize: 5,
                pageList: [5, 10, 25, 50, 100],
                clickToSelect: true
            }
        )
    }

    // 表格刷新
    function tableRefresh() {
        $('#stockRecords').bootstrapTable('refresh', {
            query : {}
        });
    }

    // 分页查询参数
    function queryParams(params) {
        var temp = {
            limit : params.limit,
            offset : params.offset,
            searchType : search_type,
            supplierName : $('#search_input').val(),
        }
        return temp;
    }

    // 查询操作
    function searchAction(){
        $('#search_button').click(function(){
            supplierName = $('#search_input').val();
            search_type = $('#search_type').val();
            tableRefresh();
        })
    }
</script>

<div class="panel panel-default">
	<ol class="breadcrumb">
		<li>租入详情</li>
	</ol>
	<div class="panel-body">
		<div class="row">
			<div class="col-md-1 col-sm-2">
				<div class="btn-group">
					<button class="btn btn-default dropdown-toggle"
							data-toggle="dropdown">
						<span id="search_type">所有</span> <span class="caret"></span>
					</button>
					<ul class="dropdown-menu" role="menu">
						<li><a href="javascript:void(0)" class="dropOption">公司名称</a></li>
						<li><a href="javascript:void(0)" class="dropOption">所有</a></li>
					</ul>
				</div>
			</div>
			<div class="col-md-9 col-sm-9">
				<div>
					<div class="col-md-3 col-sm-4">
						<input id="search_input" type="text" class="form-control" value="所有"
							   placeholder="所有" readonly>
					</div>
					<div class="col-md-2 col-sm-3">
						<button id="search_button" class="btn btn-success">
							<span class="glyphicon glyphicon-search"></span> <span>查询</span>
						</button>
					</div>
				</div>
			</div>
		</div>
		<div class="row" style="margin-top:20px">
			<div class="col-md-12">
				<table id="stockRecords" class="table table-striped"></table>
			</div>
		</div>
	</div>
</div>