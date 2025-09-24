(set-frame-font "Berkeley Nerd Font 10")


;; Default Font
(set-face-attribute
 'default nil
 :family "Berkeley Nerd Font"
 ;; Height = point size x 10 = 12 x 10 = 120
 :height 110
 :weight 'regular)

;; Fixed Font
(set-face-attribute
 'fixed-pitch nil
 :family "Berkeley Nerd Font"
 :height 110
 :weight 'regular)

;; Variable Font
(set-face-attribute
 'variable-pitch nil
 :family "Berkeley Nerd Font"
 :height 110
 :weight 'regular)

;; Modeline
(set-face-attribute 'mode-line nil :family "Berkeley Nerd Font 9" :weight 'bold)
(set-face-attribute 'mode-line-inactive nil :family "Berkeley Nerd Font 9" :weight 'bold)

;; Minibuffer
(set-face-attribute 'minibuffer-prompt nil :family "Berkeley Nerd Font 9" :weight 'regular)

(provide 'ef-fonts)
