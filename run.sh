#!/bin/bash

function prepare_wp_folder {     
    cd wordpress_shared
    wget_list=("https://downloads.wordpress.org/theme/tecblogger.1.0.2.zip" \
                 "https://downloads.wordpress.org/theme/hemingway.1.56.zip" \
                 "https://downloads.wordpress.org/theme/keepwriting.1.03.zip" \
                 "https://downloads.wordpress.org/theme/just-write.1.1.zip")

    for index in ${!wget_list[*]}
    do
        wget ${wget_list[$index]}
        zip_name=$(basename ${wget_list[$index]})
        unzip $zip_name -d .
        rm $zip_name

        # This construction replaces all occurrences of ';' (the initial // means global replace) 
        # in the string IN with ' ' (a single space), then interprets the space-delimited string 
        # as an array (that's what the surrounding parentheses do).
        arr=(${zip_name//./ })

        if [[ -d "../custom_styles/${arr[0]}" ]] ; then
          cp ../custom_styles/${arr[0]}/* ${arr[0]}/
        fi
        docker exec wp_wordpress mv /shared/${arr[0]} wp-content/themes/ 
    done

}

function mysql_restore_bkp {
    docker exec wp_mariadb sh /mysql_bkp/mysql_restore_bkp.sh $1
}

function mysql_do_bkp {
    docker exec wp_mariadb sh /mysql_bkp/mysql_do_bkp.sh
}

key="$1"

case $key in
    install)
    prepare_wp_folder
    mysql_restore_bkp $(basename $2)
    ;;
    save)
    mysql_do_bkp
    ;;
    *)
            # unknown option
    ;;
esac

