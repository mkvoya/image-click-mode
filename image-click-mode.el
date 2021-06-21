;;; image-click-mode.el --- Show clicked image in 'image-mode -*- lexical-binding: t -*-
;; Author: Mingkai Dong <mk@dong.mk>

;;; Commentary:

;; Clicking an image will trigger a new buffer showing the clicked image in
;; 'image-mode. Clicking again will kill the 'image-mode buffer, returning
;; to the original buffer.

;;; Code:

(require 'image-mode)

(defvar image-click-mode-map (make-sparse-keymap)
  "Keymap while 'image-click-mode is active.")

;;;###autoload
(define-minor-mode image-click-mode
  "A minor mode that enables temporary 'image-mode for the clicked image."
  :global nil
  :lighter " ICM"
  :keymap image-click-mode-map)

(defun icm/image-clicked ()
  "Click on the image."
  (interactive)
  (if (eq major-mode 'image-mode)
      (kill-current-buffer)
    (let ((clicked-image (nth 7 (nth 1 last-input-event)))) ; FIXME: remove the hard code
      (when clicked-image
        (let ((buffer (generate-new-buffer "*ImageClicked*")) ; Generate a new buffer
              (image-path (image-property clicked-image :file))) ; Property access
          (switch-to-buffer buffer)
          ;; (print clicked-image)
          (insert-file-contents image-path)
          (image-mode)
          ;; (image-transform-fit-to-width)
          (image-click-mode))))))

(define-key image-click-mode-map [mouse-1] #'icm/image-clicked)

(provide 'image-click-mode)

;;; image-click-mode.el ends here
