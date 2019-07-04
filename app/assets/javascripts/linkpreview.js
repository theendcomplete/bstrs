$(document).ready(function () {
    $("#url-submit").on('click', function () {
        var link = $("#url");
        setTimeout(function () {
            var text = $(link).val();
            // send url to service for parsing
            $.ajax('/linkpreview', {
                type: 'POST',
                dataType: 'json',
                data: {url: text},
                success: function (data, textStatus, jqXHR) {
                    $("#item_title").val(data['title']);
                },
                error: function () {
                    alert("error");
                }
            });
        }, 100);
    });
});