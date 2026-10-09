bunsen-utilities
================

Une collection de petits scripts offrant diverses fonctionnalités
utiles aux utilisateurs de BunsenLinux et aux administrateurs système.

beepmein:               Script de réveil basé sur "at".

bl-imgbb-upload:        Effectue des captures d'écran et les envoie sur Imgbb.
bl-imgur-upload:        Effectue des captures d'écran et les envoie sur Imgur.
bl-image-upload:        Utilitaire générique de BunsenLabs pour l'envoi d'images.

bl-conkyedit:           Recherche et modifie les fichiers de configuration de Conky.
bl-conky-manager:       Gestionnaire Conky basé sur Yad.
bl-conkymove:           Facilite le déplacement des fenêtres Conky.
bl-conky-session:       Gère plusieurs sessions Conky.

bl-kb:                  Lit les raccourcis clavier d'Openbox et les écrit dans un fichier texte.
bl-xbk:                 Analyse les configurations de xbindkeys et écrit les raccourcis dans le même fichier texte que bl-kb.
bl-lock:                Verrouille l'écran (nécessite bunsen-exit).
bl-setlocale:           Script basé sur Yad permettant de choisir les paramètres régionaux.

bl-pkg-versions:        Affiche les versions des paquets BunsenLabs dans le dépôt APT et sur GitHub.
bl-notify-broadcast:    Envoie des notifications aux utilisateurs depuis des processus exécutés en tant que root.
bl-urxlx:               Convertit les couleurs Xresources en RGB pour la configuration de lxterminal.
bl-xinerama-prop:       Récupère les propriétés Xinerama dans un script shell.
bl-reload-gtk23:        Informe les applications GTK2/3 des changements de configuration, notamment des thèmes.

xml2xconf:              Convertit les entrées des fichiers XML de configuration xfce4 (xfconf) en commandes xfconf-query.

REMARQUE : tint2 ne fait plus partie du bureau BunsenLabs par défaut,
mais ces utilitaires sont toujours fournis avec ce paquet :

bl-tint2edit:           Recherche et modifie les fichiers de configuration de tint2.
bl-tint2-manager:       Gestionnaire tint2 basé sur Yad.
bl-tint2-restart:       Redémarre tous les processus tint2 en cours d'exécution.
bl-tint2-session:       Gère plusieurs sessions tint2.
