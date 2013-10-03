$('[data-toggle=tooltip]').tooltip()

$(document).ready(function() {
    $(document).on('click', '.dropdown-menu', function (e) {
        $(this).hasClass('keep-open') && e.stopPropagation(); // This replace if conditional.
    }); 
});