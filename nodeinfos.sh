#!/bin/bash
#

#Fonction nodeinfos
function nodeinfos() {
    #ici je recupere la liste des users par noeud : 1 noeud suivi de la liste des users
    # je ne le mets pas dans le awk qui suit car je suis gene par les guillemets, donc je le passe le resultat en parametre du awk avec -v
    result=$(squeue -o "%R %u" --noheader | grep -vE "\(Priority\)|\(Resources\)" | sort -u | awk '{users[$1] = users[$1] " " $2} END {for (node in users) print node, users[node]}')
    # ici je liste les ressources totale et libre de chaque noeud avec les features, l'etat en couleur, et les users qui tournent sur le noeud
    # et a la fin j'affiche les totaux
    sinfo -o '%10N %15C %.10m %.10e %12t %26f' -N | \
    gawk -v OFS='\t' -v  result="$result" '
        BEGIN {
            total_n_cpu = 0;
            total_free_cpu = 0;
            total_mem = 0;
            total_free_mem = 0;
        }
        function get_color(state) {
            # Define colors for different states
            color = (state ~ /down|drain|drng/) ? "\033[1;31m" :   # Red for down and drain
                    (state ~ /alloc/) ? "\033[0;33m" :      # Orange for allocated
                    (state ~ /idle/) ? "\033[1;32m" :            # Green for idle
                    "\033[1;30m";                               # Default to black for other states
            return color;
        }
        function reset_color() {
            return "\033[0m";  # Reset color to default
        }
        function get_users(node) {
            users_list = ""
            split(result, result_array, "\n")
            for (i in result_array) {
                if (result_array[i] ~ node) {
                    users_list = substr(result_array[i], length(node)+1)
                }
             }
             gsub(/^ +| +$/, "", users_list)  # Supprimer les espaces en début et fin
             return users_list
        }
        {
            if (NR == 1) {
                n_cpu = "CPU";
                free_cpu = "FREE_CPU";
                printf ("%-10s %7s %8s %10s %11s %-12s %-26s %-15s\n", "NODELIST", "CPU", "FREE_CPU", "MEMORY", "FREE_MEMORY", "STATE", "AVAIL_FEATURES", "USERS")
                print ("---------- ------- -------- ---------- ----------- ------------ -------------------------- -----------------")
            } else {
                split($2, cpu, "/");                n_cpu = cpu[4];
                free_cpu = cpu[2];
                node = $1
                total_n_cpu += n_cpu;
                total_free_cpu += free_cpu;
                total_mem += $3;
                total_free_mem += $4;
                color = get_color($5);
                users_list=get_users(node)
                printf ("%-10s %7d %8d %10d %11d %s%-12s%s %-26s %-15s\n", node, n_cpu, free_cpu, $3, $4, color, $5, reset_color(), $6, users_list)
            }
        }
        END {
            print ("---------- ------- -------- ---------- ----------- ------------ -------------------------- -----------------");
            printf ("%-10s %7d %8d %10d %11d %-12s %-25s %-15s\n", "TOTAL", total_n_cpu, total_free_cpu, total_mem, total_free_mem, "NB NODES=" NR-1, "", "")
        }';

}

nodeinfos
