ftc() { set ${*,,} ; set ${*^} ; echo -n "$1 " ; shift 1 ; \
        for f in ${*} ; do \
            case $f in  A|An|And|As|At|But|By|For|In|Nor|Of|On|Or|So|The|To|Up|Yet) \
                    echo -n "${f,,} " ;; \
                 *) echo -n "$f " ;; \
            esac ; \
        done ; echo ; }
ftc "EdUCatiOn BY THE RiveR"