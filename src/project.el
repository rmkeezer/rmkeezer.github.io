(require 'ox-publish)


(let ((proj-base (file-name-directory load-file-name)))
  (setq org-publish-project-alist
    `(("rmkeezer.github.io"
        :base-directory ,(concat proj-base ".")
        :recursive t
        :publishing-directory ,(concat proj-base  "../")
        :html-head-extra "<link rel=\"stylesheet\" type=\"text/css\" href=\"/src/rmkeezer.css\"> <link href=\"https://fonts.googleapis.com/css?family=Open+Sans\" rel=\"stylesheet\">"
        :title nil
        :with-headline-numbers nil
        :toc 3
        :publishing-function org-twbs-publish-to-html))))

(setq org-twbs-postamble 't)
(setq org-twbs-postamble-format
  '(("en" "
<div>
<p class=\"author\">Author: %a</p>
<p class=\"date\">Updated: %C</p>
<p class=\"creator\">%c</p>
</div>")))


(require 'request)
(defun gh-stars (repo-string)
  (if (string= "-" repo-string)
    "-"
    (progn (require 'request)
      (defvar result nil)
      (request (concat  "https://api.github.com/repos/" repo-string "/stargazers?per_page=1")
        :parser 'json-read
        :sync t
        :success
        (cl-function
          (lambda (&key response &allow-other-keys)
            (setq result response))))
      result)))

(defun parse-gh-str (url-string)
  "Parses a github url and returns a nice representation like: jgkamat/alda-mode"
  (let* ((var (split-string url-string "/"))
          (len (length var)))
    (when (string= (elt (last var) 0) "")
      (setq len (- len 1)))
    (concat (elt var (- len 2)) "/" (elt var (- len 1)))))

(defun parse-org-link (org-link)
  "takes in an org link and returns a string link"
  (symbol-name (elt (elt org-link 0) 0)))

(defun org-link-to-str (link)
  "Turns org links to jgkamat/alda-mode format"
  (let ((str-link (parse-org-link link)))
    (if (string-match "github" str-link)
      (parse-gh-str str-link)
      "-")))
