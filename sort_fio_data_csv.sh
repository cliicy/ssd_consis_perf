data_dir=$1
total_ret_dir=$2

pushd $data_dir
#csv_list=(fio_data_fob.csv fio_data_ss.csv)
## fob Throughput and IOPS
csvf=fio_data_fob.csv
fio_data_csv=`find ./ -name *${csvf}  |grep test_data`

if [[ -e ${fio_data_csv}  ]]; then
sorted_csvf=${fio_data_csv%%.csv*}_sorted.csv
sorted_csv_dir=`dirname ${sorted_csvf}`
head -n 5 ${fio_data_csv} > ${sorted_csvf}
##action_list=(WR RD mix-70-30,read, mix-70-30,write,)
bs_list=(8kB 4kB)
for bs in ${bs_list[@]};do
grep -E ^${bs} ${fio_data_csv} >> ${sorted_csvf}
done
mv ${sorted_csv_dir}/*sorted*.csv $2
fi

## ss Throughput and IOPS
csvf=fio_data_ss.csv
fio_data_csv=`find ./ -name *${csvf}  |grep test_data`

if [[ -e ${fio_data_csv}  ]]; then
sorted_csvf=${fio_data_csv%%.csv*}_sorted_throughput_iops.csv
sorted_csv_dir=`dirname ${sorted_csvf}`
head -n 1 ${fio_data_csv} > ${sorted_csvf}
match_info=(RD,1,128 WR,1,256)
for match in ${match_info[@]};do
grep -E ^128kB ${fio_data_csv} | grep ${match} >> ${sorted_csvf}
done
bs_list=(8kB)
match_info=(RD,4,64 WR,4,64)
for bs in ${bs_list[@]};do
for match in ${match_info[@]};do
grep -E ^${bs} ${fio_data_csv} | grep ${match} >> ${sorted_csvf}
done

mix_match_info=(mix-70-30,read,4,64 mix-70-30,write,4,64)
for mix_match in ${mix_match_info[@]};do
grep -E ^${bs} ${fio_data_csv} | grep ${mix_match} >> ${sorted_csvf}
done
done

bs_list=(4kB)
match_info=(RD,4,64 RD,4,8 WR,4,64 WR,4,8 mix-70-30,read,4.64 mix-70-30,write,4,64 mix-70-30,read,4,8 mix-70-30,write,4,8 mix-30-70,read,4,8 mix-30-70,write,4,8 mix-17-83,read,4,8 mix-17-83,write,4,8)
for bs in ${bs_list[@]};do
for match in ${match_info[@]};do
grep -E ^${bs} ${fio_data_csv} | grep ${match} >> ${sorted_csvf}
done
done


## latency and qos
sorted_csvf=${fio_data_csv%%.csv*}_sorted_latency_qos.csv
head -n 1 ${fio_data_csv} > ${sorted_csvf}
bs_list=(8kB 4kB)
match_info=(Random,RD,1,1 Random,WR,1,1 Sequential,RD,1,1 Sequential,WR,1,1 Random,RD,1,128 Random,WR,1,128 mix-70-30,read,4,8 mix-70-30,write RD,4,8 WR,4,8 mix-30-70,read,4,8 mix-30-70,write,4,8 mix-17-83,read,4,8 mix-17-83,write,4,8)
for bs in ${bs_list[@]};do
for match in ${match_info[@]};do
grep -E ^${bs} ${fio_data_csv} | grep ${match} >> ${sorted_csvf}
done
done
mv ${sorted_csv_dir}/*sorted*.csv $2
fi

