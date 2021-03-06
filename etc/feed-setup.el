;;; feed-setup.el --- customize my web feeds

(require 'elfeed)
(require 'youtube-dl-mode)

(setq-default elfeed-search-filter "-junk @1-week-ago +unread")

;; youtube-dl config

(setq youtube-dl-directory "/media/wellons")

(defun elfeed-show-youtube-dl ()
  "Download the current entry with youtube-dl."
  (interactive)
  (pop-to-buffer (youtube-dl-download (elfeed-entry-link elfeed-show-entry))))

(defun elfeed-search-youtube-dl ()
  "Download the current entry with youtube-dl."
  (interactive)
  (let ((entries (elfeed-search-selected)))
    (dolist (entry entries)
      (if (null (youtube-dl-download (elfeed-entry-link entry)))
          (message "Entry is not a YouTube link!")
        (message "Downloading %s" (elfeed-entry-title entry)))
      (elfeed-untag entry 'unread)
      (elfeed-search-update-entry entry)
      (unless (use-region-p) (forward-line)))))

(define-key elfeed-show-mode-map "d" 'elfeed-show-youtube-dl)
(define-key elfeed-search-mode-map "d" 'elfeed-search-youtube-dl)

;; Special filters

(add-hook 'elfeed-new-entry-hook
          (elfeed-make-tagger :before "3 days ago"
                              :remove 'unread))

(add-hook 'elfeed-new-entry-hook
          (elfeed-make-tagger :feed-url "HuskyStarcraft"
                              :entry-title '(not "bronze league")
                              :add 'junk
                              :remove 'unread))

(add-hook 'elfeed-new-entry-hook
          (elfeed-make-tagger :feed-url "github\\.com"
                              :entry-title "\\(drinkup\\|githubber\\)"
                              :add 'junk
                              :remove 'unread))

(add-hook 'elfeed-new-entry-hook
          (elfeed-make-tagger :feed-url "\\(JimKB\\|tubeytoons\\)"
                              :entry-link '(not "\/r\/comics\/")
                              :add 'junk
                              :remove 'unread))

;; The actual feeds listing

(defvar youtube-feed-format
  "http://gdata.youtube.com/feeds/base/users/%s/uploads?max-results=50")

(defun elfeed--expand (listing)
  "Expand feed URLs depending on their tags."
  (cl-destructuring-bind (url . tags) listing
    (cond
     ((member 'youtube tags) (cons (format youtube-feed-format url) tags))
     (listing))))

(defmacro elfeed-config (&rest feeds)
  "Minimizes feed listing indentation without being weird about it."
  (declare (indent 0))
  `(setf elfeed-feeds (mapcar #'elfeed--expand ',feeds)))

(elfeed-config
  ("http://www.50ply.com/atom.xml" blog dev)
  ("http://blog.cryptographyengineering.com/feeds/posts/default" blog)
  ("http://abstrusegoose.com/feed.xml" comic)
  ("http://accidental-art.tumblr.com/rss" image math)
  ("http://english.bouletcorp.com/feed/" comic)
  ("http://curiousprogrammer.wordpress.com/feed/" blog dev)
  ("http://feeds.feedburner.com/amazingsuperpowers" comic)
  ("http://amitp.blogspot.com/feeds/posts/default" blog dev)
  ("http://austingwalters.com/feed/" blog)
  ("http://www.anticscomic.com/?feed=rss2" comic)
  ("http://feeds.feedburner.com/blogspot/TPQSS" blog dev)
  ("http://www.rsspect.com/rss/asw.xml" comic)
  ("http://feeds.feedburner.com/babynamewizard" blog data)
  ("http://beardfluff.com/feed/" comic)
  ("http://www.bergerandwyse.com/blog/atom.xml" comic)
  ("http://bit-player.org/feed" blog math)
  ("http://feeds.feedburner.com/bitquabit" blog dev)
  ("http://blakeembrey.com/feed.xml" blog dev)
  ("http://simblob.blogspot.com/feeds/posts/default" blog dev)
  ("http://blogofholding.com/?feed=rss2" blog gaming)
  ("http://blog.coinbase.com/rss" product bitcoin)
  ("http://www.commitstrip.com/en/feed/" comic dev)
  ("http://www.rsspect.com/rss/deathbulge.xml" comic)
  ("http://feeds.feedburner.com/Buttersafe" comic)
  ("http://feeds.feedburner.com/CatVersusHuman" comic)
  ("http://chainsawsuit.com/feed/" comic)
  ("http://feeds.feedburner.com/channelATE" comic)
  ("http://feeds.feedburner.com/codeincomplete" blog dev)
  ("http://completelyseriouscomics.com/?feed=rss2" comic)
  ("http://feeds.feedburner.com/DamnCoolPics" image)
  ("http://deep-dark-fears.tumblr.com/rss" comic)
  ("http://echosa.github.io/atom.xml" blog dev)
  ("http://www.devrand.org/feeds/posts/default" blog dev)
  ("http://random.terminally-incoherent.com/rss" image)
  ("http://dorophone.blogspot.com/feeds/posts/default" blog dev)
  ("http://crawl.develz.org/wordpress/feed" blog gaming product)
  ("http://dvdp.tumblr.com/rss" image)
  ("https://www.digitalocean.com/blog/feed" blog product)
  ("http://bay12games.com/dwarves/dev_now.rss" blog gaming product)
  ("http://www.soa-world.de/echelon/feed" blog dev)
  ("http://emacsredux.com/atom.xml" blog dev emacs)
  ("http://www.ericsink.com/rss.xml" blog dev)
  ("http://feeds.feedburner.com/Explosm" comic)
  ("http://www.extrafabulouscomics.com/1/feed" comic)
  ("http://www.exocomics.com/feed" comic)
  ("http://feeds.feedburner.com/Pidjin" comic)
  ("http://www.happyjar.com/feed/" comic)
  ("http://inkwellideas.com/feed/" blog gaming)
  ("http://feeds.feedburner.com/InvisibleBread" comic)
  ("http://blog.ioactive.com/feeds/posts/default" blog security)
  ("http://irreal.org/blog/?feed=rss2" blog emacs)
  ("http://feeds.feedburner.com/JoelKirchartz" blog)
  ("http://normalboots.com/author/jontronshow/feed/" video)
  ("http://jorgetavares.com/feed/" blog dev)
  ("http://www.leadpaintcomics.com/feed/" comic)
  ("http://feeds.feedburner.com/lefthandedtoons/awesome" comic)
  ("http://gottwurfelt.wordpress.com/feed/" blog math)
  ("http://feeds.feedburner.com/LoadingArtist" comic)
  ("http://loldwell.com/?feed=rss2" comic)
  ("http://www.lunarbaboon.com/comics/rss.xml" comic)
  ("http://maneggs.com/feed/" comic)
  ("http://www.masteringemacs.org/feed/" blog emacs)
  ("http://www.ma3comic.com/comic.rss" comic)
  ("http://mathgifs.blogspot.com/feeds/posts/default" blog math)
  ("http://www.mazelog.com/rss" math puzzle)
  ("http://www.mercworks.net/feed/" comic)
  ("http://mrdiv.tumblr.com/rss" image)
  ("http://www.mrlovenstein.com/rss.xml" comic)
  ("http://mycardboardlife.com/feed" comic)
  ("http://nedroid.com/feed/" comic)
  ("http://nklein.com/feed/" blog dev)
  ("http://www.npccomic.com/feed/" comic)
  ("http://nullprogram.com/feed/" blog dev myself)
  ("http://www.optipess.com/feed/" comic)
  ("http://pandyland.net/feed/" comic)
  ("http://www.rsspect.com/rss/pfsc.xml" comic)
  ("http://possiblywrong.wordpress.com/feed/" blog math puzzle)
  ("http://feeds.wnyc.org/radiolab" audio)
  ("http://raganwald.com/atom.xml" blog dev)
  ("https://richardwiseman.wordpress.com/feed/" blog puzzle)
  ("http://feeds.feedburner.com/rolang" blog gaming)
  ("http://www.safelyendangered.com/feed/" comic)
  ("http://www.schneier.com/blog/atom.xml" blog security)
  ("http://sea-of-memes.com/rss.xml" blog dev)
  ("http://seemikedraw.com.au/feed" comic)
  ("http://www.smbc-comics.com/rss.php" comic)
  ("http://feeds.feedburner.com/spaceavalanche1" comic)
  ("http://stevelosh.com/feed/" blog dev)
  ("http://storyboardcomics.blogspot.com/feeds/posts/default" comic)
  ("http://www.terminally-incoherent.com/blog/feed/" blog)
  ("http://bradcolbow.com/feed/" comic)
  ("http://thecodelesscode.com/rss" dev story)
  ("http://sachachua.com/blog/feed/" dev blog)
  ("https://github.com/blog.atom" blog dev product)
  ("http://feeds.feedburner.com/thetechnium" blog)
  ("http://blog.plover.com/index.atom" blog dev)
  ("http://use-the-index-luke.com/blog/feed" blog dev databases)
  ("http://notch.tumblr.com/rss" blog gaming)
  ("http://batsov.com/atom.xml" blog emacs)
  ("http://towerdive.com/feed/" blog)
  ("http://www.shamusyoung.com/twentysidedtale/?feed=rss2" blog gaming)
  ("http://jeremykaye.tumblr.com/rss" comic)
  ("http://blog.vivekhaldar.com/rss" blog)
  ("http://what-if.xkcd.com/feed.atom" blog)
  ("http://whattheemacsd.com/atom.xml" emacs)
  ("http://www.whompcomic.com/feed/" comic)
  ("http://wordsmith.org/awad/rss1.xml" word)
  ("http://blag.xkcd.com/feed/" blog)
  ("http://xkcd.com/atom.xml" comic)
  ("http://www.reddit.com/domain/nullprogram.com.rss" reddit myself)
  ("http://www.reddit.com/r/dailyprogrammer/.rss" subreddit)
  ("http://www.reddit.com/r/OOTSFeed/.rss" subreddit comic)
  ("http://www.reddit.com/user/tubeytoons/submitted.rss" comic)
  ("http://www.reddit.com/user/JimKB/submitted.rss" comic)
  ("BattleBunny1979" youtube)
  ("BlueXephos" youtube)
  ("Campster" youtube)
  ("DonkeyPuncher1976" youtube)
  ("djflula" youtube)
  ("GetDaved" youtube)
  ("GhazPlays" youtube)
  ("HuntrBlackLuna" youtube)
  ("HuskyStarcraft" youtube)
  ("JonTronShow" youtube)
  ("MatthiasWandel" youtube)
  ("Mestherion" youtube)
  ("PlumpHelmetPunk" youtube)
  ("Scruit" youtube)
  ("Vihart" youtube)
  ("ZombieOrpheusEnt" youtube)
  ("ZoochosisCom" youtube)
  ("davidr64yt" youtube)
  ("eEconomics" youtube)
  ("emacsrocks" youtube)
  ("friendznet" youtube)
  ("jefmajor" youtube)
  ("kmgpsu" youtube)
  ("phreakindee" youtube)
  ("praxgirl" youtube)
  ("quill18" youtube)
  ("skiptherules" youtube)
  ("szyzyg" youtube)
  ("TheUberHunter" youtube)
  ("zzandr1o" youtube))

(provide 'feed-setup)

;;; feed-setup.el ends here
