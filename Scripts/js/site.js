/**
 * Kriya ID - Client Script Helpers & Header Touch Dropdown Interactions
 */

function confirmAction(message) {
    return confirm(message || 'Are you sure you want to proceed?');
}

function updateQuantity(btn, delta) {
    var group = btn.closest('.input-group');
    if (!group) return;
    var input = group.querySelector('input[type="number"], input[type="text"]');
    if (!input) return;
    var current = parseInt(input.value) || 1;
    var updated = current + delta;
    if (updated < 1) updated = 1;
    input.value = updated;
}

// Sub-Categories Direct Touch/Hover Positioning & Toggling
document.addEventListener('DOMContentLoaded', function () {
    var dropdownItems = document.querySelectorAll('.luma-nav-item.luma-dropdown');

    dropdownItems.forEach(function (item) {
        var link = item.querySelector('.luma-nav-link');
        var chevron = item.querySelector('.luma-chevron');
        var menu = item.querySelector('.luma-dropdown-menu');
        if (!link || !menu) return;

        // Touch event: opens subcategories directly beneath where touched
        link.addEventListener('touchstart', function (e) {
            if (!item.classList.contains('is-open')) {
                e.preventDefault();
                dropdownItems.forEach(function (other) {
                    if (other !== item) other.classList.remove('is-open');
                });
                item.classList.add('is-open');
            }
        }, { passive: false });

        // Chevron arrow click toggles dropdown pinned state
        if (chevron) {
            chevron.addEventListener('click', function (e) {
                e.preventDefault();
                e.stopPropagation();
                var isOpen = item.classList.contains('is-open');
                dropdownItems.forEach(function (other) {
                    other.classList.remove('is-open');
                });
                if (!isOpen) {
                    item.classList.add('is-open');
                }
            });
        }
    });

    // Close open dropdowns when touching or clicking outside
    document.addEventListener('click', function (e) {
        if (!e.target.closest('.luma-dropdown')) {
            dropdownItems.forEach(function (item) {
                item.classList.remove('is-open');
            });
        }
    });

    document.addEventListener('touchstart', function (e) {
        if (!e.target.closest('.luma-dropdown')) {
            dropdownItems.forEach(function (item) {
                item.classList.remove('is-open');
            });
        }
    }, { passive: true });
});
