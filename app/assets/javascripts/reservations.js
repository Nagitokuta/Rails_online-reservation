// app/assets/javascripts/reservations.js
document.addEventListener("DOMContentLoaded", function () {
  // 予約ボタンのクリックイベントを監視
  document.addEventListener("click", function (event) {
    if (event.target.classList.contains("reservation-btn")) {
      event.preventDefault();

      const button = event.target;
      const form = button.closest("form");
      const className = button.dataset.yogaClassName;
      const classTime = button.dataset.yogaClassTime;
      const instructor = button.dataset.yogaClassInstructor;

      showReservationDialog(className, classTime, instructor, function () {
        form.submit();
      });
    }
  });
});

function showReservationDialog(className, classTime, instructor, onConfirm) {
  // 既存のダイアログがあれば削除
  const existingDialog = document.getElementById("reservation-dialog");
  if (existingDialog) {
    existingDialog.remove();
  }

  // ダイアログのHTML作成
  const dialogHTML = `
    <div id="reservation-dialog" class="modal fade show" style="display: block; background-color: rgba(0,0,0,0.5);">
      <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">クラス予約確認</h5>
          </div>
          <div class="modal-body">
            <div class="mb-3">
              <strong>クラス名：</strong>${className}
            </div>
            <div class="mb-3">
              <strong>日時：</strong>${classTime}
            </div>
            <div class="mb-3">
              <strong>講師：</strong>${instructor}
            </div>
            <p class="text-muted">このクラスを予約しますか？</p>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" id="cancel-reservation">キャンセル</button>
            <button type="button" class="btn btn-primary" id="confirm-reservation">予約確定</button>
          </div>
        </div>
      </div>
    </div>
  `;

  // ダイアログをページに追加
  document.body.insertAdjacentHTML("beforeend", dialogHTML);

  // イベントリスナーを設定
  document
    .getElementById("cancel-reservation")
    .addEventListener("click", function () {
      document.getElementById("reservation-dialog").remove();
    });

  document
    .getElementById("confirm-reservation")
    .addEventListener("click", function () {
      document.getElementById("reservation-dialog").remove();
      onConfirm();
    });
}
