/* ==========================================================================
   Szechuan Royale — nav.js
   Progressive-enhancement mobile hamburger toggle (D-06). Vanilla JS, no
   framework, no build. The nav works with JS disabled: this script only ADDS
   the collapse/expand affordance on top of a fully-usable no-JS baseline.
   ========================================================================== */
(function () {
  "use strict";

  var toggle = document.getElementById("nav-toggle");
  var menu = document.getElementById("nav-menu");

  // Guard: if the expected elements are absent, do nothing (no errors).
  if (!toggle || !menu) {
    return;
  }

  // Signal to CSS that JS is active. Only now does the mobile nav collapse
  // behind the toggle; without this class the links stay visible (no-JS safe).
  document.body.classList.add("js-nav");

  function openMenu() {
    menu.classList.add("is-open");
    toggle.setAttribute("aria-expanded", "true");
  }

  function closeMenu() {
    menu.classList.remove("is-open");
    toggle.setAttribute("aria-expanded", "false");
  }

  function toggleMenu() {
    if (toggle.getAttribute("aria-expanded") === "true") {
      closeMenu();
    } else {
      openMenu();
    }
  }

  // The toggle is a real <button>, so Enter/Space activate "click" natively —
  // no extra keydown handling needed for the button itself.
  toggle.addEventListener("click", toggleMenu);

  // Close on link select so navigation (and same-page anchors) leave a tidy state.
  menu.addEventListener("click", function (event) {
    var target = event.target;
    if (target && target.closest && target.closest("a")) {
      closeMenu();
    }
  });

  // Convenience: Escape closes the open menu and returns focus to the toggle.
  document.addEventListener("keydown", function (event) {
    if (event.key === "Escape" && toggle.getAttribute("aria-expanded") === "true") {
      closeMenu();
      toggle.focus();
    }
  });
})();
