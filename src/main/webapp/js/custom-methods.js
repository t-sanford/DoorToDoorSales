document.addEventListener('DOMContentLoaded', () => {
    let formToggler = document.getElementById('formToggler');
    formToggler.addEventListener('change', switchForms);
});

function switchForms(event) {
    let value = event.currentTarget.value;
    if(value == 'house') {
        document.getElementById('addHouseForms').style.display = "";
        document.getElementById('addSalesmanForm').style.display = "none";
        document.getElementById('addProductForm').style.display = "none";
    }
    if(value == 'salesman') {
        document.getElementById('addHouseForms').style.display = "none";
        document.getElementById('addSalesmanForm').style.display = "";
        document.getElementById('addProductForm').style.display = "none";
    }
    if(value == 'product') {
        document.getElementById('addHouseForms').style.display = "none";
        document.getElementById('addSalesmanForm').style.display = "none";
        document.getElementById('addProductForm').style.display = "";
    }
}

$(document).ready(function($) {
    $(".table-row").click(function() {
        window.document.location = $(this).data("href");
    });
});
