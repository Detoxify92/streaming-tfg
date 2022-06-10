#!/bin/bash
[ -f $5 ] && rm $5
printf "n,var" >> $5
for (( i = 1; i <= $2; i++ )); do
   printf ",i%s" $i >> $5
done
printf "\n" >> $5
runs=$(echo $1 | awk -F, '{ print NF }')
sed -i "/URL_DATA/ s~>.*<~>$3<~" $4
for (( i = 1; i <= $runs; i++ )); do
   numThreads=$(echo $1 | awk -F, -v "i=$i" '{ print $i }')
   sed -i "/num_threads/ s/>[0-9]*</>$numThreads</" $4
   echo "Numero threads: $numThreads"
   cpu_i="" && ram_i=""
   for (( j = 1; j <= $2; j++ )); do
      echo "Iteracion: $j"
      k=0 && cpu_k=0 && ram_k=0
      ./bin/jmeter -n -t $4 -l log.jtl &
      jmeter_id=$!
      while kill -0 "$jmeter_id" >/dev/null 2>&1; do
          usage=$(minikube kubectl -- top nodes | grep minikube)
          cpu_k=$(printf "%s + %s\n" $cpu_k $(echo $usage | 
             awk '{print substr($2, 1, length($2)-1)}') | bc)
          ram_k=$(printf "%s + %s\n" $ram_k $(echo $usage | 
             awk '{print substr($4, 1, length($4)-2)}') | bc)
          let "k+=1"
          sleep 0.1
      done
      cpu_i="$cpu_i$(($cpu_k / $k)),"
      ram_i="$ram_i$(($ram_k / $k)),"
   done
   echo "$numThreads,cpu,${cpu_i::-1}" >> $5
   echo "$numThreads,ram,${ram_i::-1}" >> $5
done
echo "Prueba finalizada. Resultados guardados en: $5"
