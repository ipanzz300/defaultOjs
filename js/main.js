/**
 * @file plugins/themes/default/js/main.js
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2000-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief Handle JavaScript functionality unique to this theme.
 */
(function($) {

	// Initialize dropdown navigation menus on large screens
	// See bootstrap dropdowns: https://getbootstrap.com/docs/4.0/components/dropdowns/
	if (typeof $.fn.dropdown !== 'undefined') {
		var $nav = $('#navigationPrimary, #navigationUser'),
		$submenus = $('ul', $nav);
		
		function toggleDropdowns() {
			if (window.innerWidth > 992) {
				// Desktop: Kill all JS intervention. Let CSS Hover rule.
				$submenus.each(function() {
					$(this).removeClass('dropdown-menu').removeAttr('aria-labelledby').css('display', '');
					var $parent = $(this).siblings('a');
					$parent.removeAttr('data-toggle').removeAttr('aria-haspopup').removeAttr('aria-expanded').removeAttr('id');
					if ($parent.attr('data-original-href')) {
						$parent.attr('href', $parent.attr('data-original-href'));
					}
				});
				$('[data-toggle="dropdown"]').dropdown('dispose');
			} else {
				// Mobile: Enable Bootstrap Click
				$submenus.each(function(i) {
					var id = 'pkpDropdown' + i;
					$(this).addClass('dropdown-menu').attr('aria-labelledby', id).css('display', '');
					var $parent = $(this).siblings('a');
					if (!$parent.attr('data-original-href')) {
						$parent.attr('data-original-href', $parent.attr('href'));
					}
					$parent.attr('data-toggle', 'dropdown').attr('aria-haspopup', true).attr('aria-expanded', false).attr('id', id).attr('href', '#');
				});
				$('[data-toggle="dropdown"]').dropdown();
			}
		}
		window.onresize = toggleDropdowns;
		$(document).ready(toggleDropdowns);
	}

	// Toggle nav menu on small screens
	// Custom Mobile Navigation Logic
	$(document).ready(function() {
		// Toggle when button clicked
		$(document).on('click', '.custom_nav_toggle', function(e) {
			e.preventDefault();
			e.stopPropagation();
			console.log('Custom Hamburger clicked!');
			
			var $menu = $('.custom_nav_menu');
			var $btn = $(this);
			
			$menu.toggleClass('custom_nav_menu--isOpen'); // Toggle visibility class
			$btn.toggleClass('custom_nav_toggle--active'); // Transform icon
		});

		// Close menu when clicking link inside
		$(document).on('click', '.custom_nav_menu a', function() {
			$('.custom_nav_menu').removeClass('custom_nav_menu--isOpen');
			$('.custom_nav_toggle').removeClass('custom_nav_toggle--active');
		});

		// Close if clicking outside
		$(document).on('click', function(e) {
			if (!$(e.target).closest('.custom-main-navbar').length) {
				$('.custom_nav_menu').removeClass('custom_nav_menu--isOpen');
				$('.custom_nav_toggle').removeClass('custom_nav_toggle--active');
			}
		});
	});

	// Modify the Chart.js display options used by UsageStats plugin
	document.addEventListener('usageStatsChartOptions.pkp', function(e) {
		e.chartOptions.elements.line.backgroundColor = 'rgba(0, 122, 178, 0.6)';
		e.chartOptions.elements.rectangle.backgroundColor = 'rgba(0, 122, 178, 0.6)';
	});

	// Toggle display of consent checkboxes in site-wide registration
	var $contextOptinGroup = $('#contextOptinGroup');
	if ($contextOptinGroup.length) {
		var $roles = $contextOptinGroup.find('.roles :checkbox');
		$roles.change(function() {
			var $thisRoles = $(this).closest('.roles');
			if ($thisRoles.find(':checked').length) {
				$thisRoles.siblings('.context_privacy').addClass('context_privacy_visible');
			} else {
				$thisRoles.siblings('.context_privacy').removeClass('context_privacy_visible');
			}
		});
	}

	// Show or hide the reviewer interests field on the registration form
	// when a user has opted to register as a reviewer.
	function reviewerInterestsToggle() {
		var is_checked = false;
		$('#reviewerOptinGroup').find('input').each(function() {
			if ($(this).is(':checked')) {
				is_checked = true;
				return false;
			}
		});
		if (is_checked) {
			$('#reviewerInterests').addClass('is_visible');
		} else {
			$('#reviewerInterests').removeClass('is_visible');
		}
	}

	reviewerInterestsToggle();
	$('#reviewerOptinGroup input').on('click', reviewerInterestsToggle);

})(jQuery);
