// app/assets/javascripts/calendar.js
document.addEventListener("DOMContentLoaded", function () {
  // カレンダーの日付セルにホバー効果を追加
  const calendarCells = document.querySelectorAll(".calendar-cell.reserved");

  calendarCells.forEach(function (cell) {
    cell.addEventListener("mouseenter", function () {
      this.style.transform = "scale(1.02)";
      this.style.transition = "transform 0.2s ease";
    });

    cell.addEventListener("mouseleave", function () {
      this.style.transform = "scale(1)";
    });
  });
});
