while true; do objs=$(git count-objects |perl -pe's/^(\d+).*/$1/'); if [ $objs -gt 30000 ]; then echo $objs $(ls objects/pack/pack-*.pack |wc -l) $(du -sh .); git pack-refs --all; git repack -l -A -d; fi; echo $(git count-objects |perl -pe's/^(\d+).*/$1/') $(ls objects/pack/pack-*.pack |wc -l) $(du -sh .); sleep 10; done