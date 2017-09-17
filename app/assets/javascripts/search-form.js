document.addEventListener("DOMContentLoaded", function() {
  document.querySelector(".search-trigger").addEventListener("click", function() {
    document.querySelector(".search").classList.add("search--expanded");
  });

  document.querySelector(".search-hide-icon").addEventListener("click", function() {
    document.querySelector(".search").classList.remove("search--expanded");
  });
});
