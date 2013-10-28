$('[data-toggle=tooltip]').tooltip()

$(document).ready(function() {
    $(document).on('click', '.dropdown-menu', function (e) {
        $(this).hasClass('keep-open') && e.stopPropagation(); // This replace if conditional.
    }); 

    // Hide or show several versions
    $('#options-menu button').addClass('active');
    $('#options-menu button').click(function (e) {
        var version = $('#' + $(this).attr('id').split('-')[2]).parent();
            $(this).toggleClass('active');
        if ($(this).hasClass('active')) {
            $(version).show();
        }
        else {
            $(version).hide();
        }
            var colLength = 12 / $('#options-menu').find('button.active').length;
        $('#content > div').removeClass().addClass('col-lg-' + colLength);
        e.stopPropagation();
    });

    // Hide or show verse numbers
    $('#check_verse_num').click(function() {
    $('.verse_num').toggle(this.checked);
    });
});

