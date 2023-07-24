1、追加的元素，要添加到class的事件
$("#ele").live("click", function() {
    //...
});
现在要写成
$("#ele").on("click", function() {
    //...
});
动态生成的元素要使用 live，要写成
$(document).on("click", "#ele", function() {
    //...
});

2、shift+f5：重新加载js和css