iolog_folder=$1
pushd $iolog_folder

iocsv_folder=io_csv
perf_consis_dir=$iocsv_folder/perf_consistency
iops_perf_consis_dir=$iocsv_folder/perf_consistency/iops
throughput_perf_consis_dir=$iocsv_folder/perf_consistency/throughput
sorted_files_dir=$iocsv_folder/sorted_iofiles

if [[ ! -d $iocsv_folder ]]; then
mkdir -p $perf_consis_dir
mkdir -p $iops_perf_consis_dir
mkdir -p $throughput_perf_consis_dir
mkdir -p $sorted_files_dir
fi

pct_lowest_flag=(99.9% 100%)

pct99_9_pos=1000
header="avg_r/s,min_r/s,99.9%_lowest_r/s,avg_w/s,min_w/s,99%_lowest_w/s,avg_rMB/s,min_rMB/s,99%_lowest_rMB/s,avg_wMB/s,min_wMB/s,99.9_lowest_wMB/s,fob?ss"
consis_header="pattern,bs,jobs*qd,fob/ss,rw,Acess mode,pct,val"

cli_info_log=`find ./ -name *id_info_nvmecli.log`

if [[ -e $cli_info_log  ]]; then
SN_info=`grep -E '^sn' $cli_info_log | cut -d : -f2 | sed -r 's/\s+//g'`
fi

if [[ -z $SN_info  ]]; then
SN_info=CSD3000
fi

pct_perf_csv=$perf_consis_dir/${SN_info}_perf_consistency.csv
echo $consis_header > $pct_perf_csv

iolog_list=`ls iostat*.log | grep -v precondition`
for io_f in ${iolog_list}
do
#echo ori_file is: $io_f

io_f1=${io_f#*iostat_}
io_csv=${io_f1%.log*}
#echo io_csv_file is: $io_csv
#echo -e "\n"

iostat_header=`grep nvme -B 1 $io_f | head -n 1`

echo $iostat_header | awk '{print $2}' | grep -q  rrqm/s
if [[ "$?" == "0" ]]; then
#  echo "debug should ignore the colum 2:  rrqm/s, then also need check wrqm/s below"
  echo $iostat_header | awk '{print $3}' | grep -q  wrqm/s
  if [[ "$?" == "0" ]]; then
#    echo "debug should also ignore the colum 3: wrqm/s"
    echo $iostat_header | awk '{print $1,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14}' | sed -r 's/\s+/,/g' > ${iocsv_folder}/${io_csv}.csv
    grep nvme $io_f | awk '{print $1,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14}' | sed -r 's/\s+/,/g' >> ${iocsv_folder}/${io_csv}.csv
  fi
else
  echo $iostat_header | sed -r 's/\s+/,/g' > ${iocsv_folder}/${io_csv}.csv
  grep nvme $io_f | sed -r 's/\s+/,/g'>> ${iocsv_folder}/${io_csv}.csv
fi

sed -i '2,61 d' ${iocsv_folder}/${io_csv}.csv

if [[ "${io_csv}" =~ "_ss" ]]; then
type=ss
elif [[  "${io_csv}" =~ "_fob" ]]; then
type=fob
fi

if [[ "${io_csv}" =~ "128k" ]]; then
	access_mode=seq
#	echo "debug seq read/write  =================== ${io_csv}"
        echo $header > ${throughput_perf_consis_dir}/${io_csv}_consis.csv
	if [[ "${io_csv}" =~ "write" ]]; then
		sorted_file=${iocsv_folder}/${io_csv}_sorted_seqwrite.csv
		out_v=`grep nvme ${iocsv_folder}/${io_csv}.csv |  awk -F, '{sum += $5} END {printf "NR=%d,Average=%3.3f\n",NR,sum/NR}'`
                sort -n -k 5 -t , ${iocsv_folder}/${io_csv}.csv > ${sorted_file}
                avg_v=`echo $out_v | cut -d , -f2 | cut -d = -f2 | sed 's/\s+//g'`
                length_v=`echo $out_v | cut -d , -f1 | cut -d = -f2 | sed 's/\s+//g'`
		pct99_9lowest_pos=`awk 'BEGIN{printf "%.0f\n",'$length_v'/'$pct99_9_pos'}'`
		v_99_9lowest=`grep nvme ${sorted_file} | sed -n ${pct99_9lowest_pos}p | cut -d , -f5`
		min_wMB=`grep nvme ${sorted_file} | head -n 1 | cut -d , -f 5`
#		echo "debug ============avg_wMB/s=$avg_v,min_wMB/s=$min_wMB ,99.9%lowest_pos=$pct99_9lowest_pos,v_99.9lowest=$v_99_9lowest,NR=$length_v,type=$type"
		echo ",,,,,,,,,$avg_v,$min_wMB,$v_99_9lowest,$type" >> ${throughput_perf_consis_dir}/${io_csv}_consis.csv

                pct99_9_consisy_v=`awk 'BEGIN{printf "%.4f%%\n",'100*$v_99_9lowest'/'$avg_v'}'`
		echo "${io_csv},128k,${io_csv#*128k_},$type,w,${access_mode},${pct_lowest_flag[0]},$pct99_9_consisy_v"  >> ${pct_perf_csv}
                pct100_consisy_v=`awk 'BEGIN{printf "%.4f%%\n",'100*$min_wMB'/'$avg_v'}'`
		echo "${io_csv},128k,${io_csv#*128k_},$type,w,${access_mode},${pct_lowest_flag[1]},$pct100_consisy_v"  >> ${pct_perf_csv}
	elif [[ "${io_csv}" =~ "read" ]]; then
		sorted_file=${iocsv_folder}/${io_csv}_sorted_seqread.csv
		out_v=`grep nvme ${iocsv_folder}/${io_csv}.csv |  awk -F, '{sum += $4} END {printf "NR=%d,Average=%3.3f\n",NR,sum/NR}'`
                sort -n -k 4 -t , ${iocsv_folder}/${io_csv}.csv > ${sorted_file}
                avg_v=`echo $out_v | cut -d , -f2 | cut -d = -f2 | sed 's/\s+//g'`
                length_v=`echo $out_v | cut -d , -f1 | cut -d = -f2 | sed 's/\s+//g'`
		pct99_9lowest_pos=`awk 'BEGIN{printf "%.0f\n",'$length_v'/'$pct99_9_pos'}'`
		v_99_9lowest=`grep nvme ${sorted_file} | sed -n ${pct99_9lowest_pos}p | cut -d , -f4`
		min_wMB=`grep nvme ${sorted_file} | head -n 1 | cut -d , -f 4`
#		echo "debug ============avg_wMB/s=$avg_v,min_wMB/s=$min_wMB ,99.9%lowest_pos=$pct99_9lowest_pos,v_99.9lowest=$v_99_9lowest,NR=$length_v,type=$type"
		echo ",,,,,,$avg_v,$min_wMB,$v_99_9lowest,,,,$type" >> ${throughput_perf_consis_dir}/${io_csv}_consis.csv

                pct99_9_consisy_v=`awk 'BEGIN{printf "%.4f%%\n",'100*$v_99_9lowest'/'$avg_v'}'`
		echo "${io_csv},128k,${io_csv#*128k_},$type,r,${access_mode},${pct_lowest_flag[0]},$pct99_9_consisy_v"  >> ${pct_perf_csv}
                pct100_consisy_v=`awk 'BEGIN{printf "%.4f%%\n",'100*$min_wMB'/'$avg_v'}'`
		echo "${io_csv},128k,${io_csv#*128k_},$type,r,${access_mode},${pct_lowest_flag[1]},$pct100_consisy_v"  >> ${pct_perf_csv}
	elif [[ "${io_csv}" =~ "mix" ]]; then
		sorted_read_file=${iocsv_folder}/${io_csv}_sorted_mix_seqread.csv
		out_v_read=`grep nvme ${iocsv_folder}/${io_csv}.csv |  awk -F, '{sum += $4} END {printf "NR=%d,Average=%3.3f\n",NR,sum/NR}'`
                sort -n -k 4 -t , ${iocsv_folder}/${io_csv}.csv > ${sorted_read_file}
                avg_v_read=`echo $out_v_read | cut -d , -f2 | cut -d = -f2 | sed 's/\s+//g'`
                length_v=`echo $out_v_read | cut -d , -f1 | cut -d = -f2 | sed 's/\s+//g'`
		pct99_9lowest_pos=`awk 'BEGIN{printf "%.0f\n",'$length_v'/'$pct99_9_pos'}'`
		v_read_99_9lowest=`grep nvme ${sorted_read_file} | sed -n ${pct99_9lowest_pos}p | cut -d , -f4`
		min_read_wMB=`grep nvme ${sorted_read_file} | head -n 1 | cut -d , -f 4`

                pct99_9_consisy_v=`awk 'BEGIN{printf "%.4f%%\n",'100*$v_read_99_9lowest'/'$avg_v_read'}'`
		echo "${io_csv},128k,${io_csv#*128k_}_mix,$type,r,${access_mode},${pct_lowest_flag[0]},$pct99_9_consisy_v"  >> ${pct_perf_csv}
                pct100_consisy_v=`awk 'BEGIN{printf "%.4f%%\n",'100*$min_read_wMB'/'$avg_v_read'}'`
		echo "${io_csv},128k,${io_csv#*128k_}_mix,$type,r,${access_mode},${pct_lowest_flag[1]},$pct100_consisy_v"  >> ${pct_perf_csv}

		sorted_write_file=${iocsv_folder}/${io_csv}_sorted_mix_seqwrite.csv
		out_v_write=`grep nvme ${iocsv_folder}/${io_csv}.csv |  awk -F, '{sum += $5} END {printf "NR=%d,Average=%3.3f\n",NR,sum/NR}'`
                sort -n -k 5 -t , ${iocsv_folder}/${io_csv}.csv > ${sorted_write_file}
                avg_v_write=`echo $out_v_write | cut -d , -f2 | cut -d = -f2 | sed 's/\s+//g'`
                length_v=`echo $out_v_write | cut -d , -f1 | cut -d = -f2 | sed 's/\s+//g'`
		pct99_9lowest_pos=`awk 'BEGIN{printf "%.0f\n",'$length_v'/'$pct99_9_pos'}'`
		v_write_99_9lowest=`grep nvme ${sorted_write_file} | sed -n ${pct99_9lowest_pos}p | cut -d , -f5`
		min_write_wMB=`grep nvme ${sorted_write_file} | head -n 1 | cut -d , -f 5`
		echo ",,,,,,$avg_v_read,$min_read_wMB,$v_read_99_9lowest,$avg_v_write,$min_write_wMB,$v_write_99_9lowest,$type" >> ${throughput_perf_consis_dir}/${io_csv}_consis.csv

                pct99_9_consisy_v=`awk 'BEGIN{printf "%.4f%%\n",'100*$v_write_99_9lowest'/'$avg_v_write'}'`
		echo "${io_csv},128k,${io_csv#*128k_}_mix,$type,w,${access_mode},${pct_lowest_flag[0]},$pct99_9_consisy_v"  >> ${pct_perf_csv}
                pct100_consisy_v=`awk 'BEGIN{printf "%.4f%%\n",'100*$min_write_wMB'/'$avg_v_write'}'`
		echo "${io_csv},128k,${io_csv#*128k_}_mix,$type,w,${access_mode},${pct_lowest_flag[1]},$pct100_consisy_v"  >> ${pct_perf_csv}
	
	fi
elif [[ "${io_csv}" =~ "8k" ]] || [[ "${io_csv}" =~ "4k" ]]; then
	access_mode=random
#	echo "debug random read/write =================== ${io_csv}"
        echo $header > ${iops_perf_consis_dir}/${io_csv}_consis.csv
	#kb_job_qd_info=`echo ${io_csv} | sed -r -e 's/.*([0-9]kB).*([0-9]+job_QD[0-9]+).*/\1,\2/g' | sed -r 's/kB/k/g'`
	kb_job_qd_info=`echo ${io_csv} | sed -r -e 's/.*([0-9]kB).*([0-9]+job_QD[0-9]+).*/\1,\2/g'`
        if [[ "${kb_job_qd_info}" =~ "," ]]; then
	  : 
	else
	   kb_job_qd_info=`echo ${io_csv} | sed -r -e 's/.*_([0-9]k).*([0-9]+job_[0-9]+qd).*/\1,\2/g'`
	fi
	if [[ "${io_csv}" =~ "write" ]]; then
		sorted_file=${iocsv_folder}/${io_csv}_sorted_randwrite.csv
		out_v=`grep nvme ${iocsv_folder}/${io_csv}.csv |  awk -F, '{sum += $3} END {printf "NR=%d,Average=%3.3f\n",NR,sum/NR}'`
                sort -n -k 3 -t , ${iocsv_folder}/${io_csv}.csv > ${sorted_file}
                avg_v=`echo $out_v | cut -d , -f2 | cut -d = -f2 | sed 's/\s+//g'`
                length_v=`echo $out_v | cut -d , -f1 | cut -d = -f2 | sed 's/\s+//g'`
		pct99_9lowest_pos=`awk 'BEGIN{printf "%.0f\n",'$length_v'/'$pct99_9_pos'}'`
		v_99_9lowest=`grep nvme ${sorted_file} | sed -n ${pct99_9lowest_pos}p | cut -d , -f3`
		min_wIOPS=`grep nvme ${sorted_file} | head -n 1 | cut -d , -f 3`
		echo ",,,$avg_v,$min_wIOPS,$v_99_9lowest,,,,,,,$type" >> ${iops_perf_consis_dir}/${io_csv}_consis.csv

                pct99_9_consisy_v=`awk 'BEGIN{printf "%.4f%%\n",'100*$v_99_9lowest'/'$avg_v'}'`
		echo "${io_csv},${kb_job_qd_info},$type,w,${access_mode},${pct_lowest_flag[0]},$pct99_9_consisy_v"  >> ${pct_perf_csv}
                pct100_consisy_v=`awk 'BEGIN{printf "%.4f%%\n",'100*$min_wIOPS'/'$avg_v'}'`
		echo "${io_csv},${kb_job_qd_info},$type,w,${access_mode},${pct_lowest_flag[1]},$pct100_consisy_v"  >> ${pct_perf_csv}
	elif [[ "${io_csv}" =~ "read" ]]; then
		sorted_file=${iocsv_folder}/${io_csv}_sorted_randread.csv
		out_v=`grep nvme ${iocsv_folder}/${io_csv}.csv |  awk -F, '{sum += $2} END {printf "NR=%d,Average=%3.3f\n",NR,sum/NR}'`
                sort -n -k 2 -t , ${iocsv_folder}/${io_csv}.csv > ${sorted_file}
                avg_v=`echo $out_v | cut -d , -f2 | cut -d = -f2 | sed 's/\s+//g'`
                length_v=`echo $out_v | cut -d , -f1 | cut -d = -f2 | sed 's/\s+//g'`
		pct99_9lowest_pos=`awk 'BEGIN{printf "%.0f\n",'$length_v'/'$pct99_9_pos'}'`
		v_99_9lowest=`grep nvme ${sorted_file} | sed -n ${pct99_9lowest_pos}p | cut -d , -f2`
		min_rIOPS=`grep nvme ${sorted_file} | head -n 1 | cut -d , -f 2`
		echo "$avg_v,$min_rIOPS,$v_99_9lowest,,,,,,,,,,$type" >> ${iops_perf_consis_dir}/${io_csv}_consis.csv

                pct99_9_consisy_v=`awk 'BEGIN{printf "%.4f%%\n",'100*$v_99_9lowest'/'$avg_v'}'`
		echo "${io_csv},${kb_job_qd_info},$type,r,${access_mode},${pct_lowest_flag[0]},$pct99_9_consisy_v"  >> ${pct_perf_csv}
                pct100_consisy_v=`awk 'BEGIN{printf "%.4f%%\n",'100*$min_rIOPS'/'$avg_v'}'`
		echo "${io_csv},${kb_job_qd_info},$type,r,${access_mode},${pct_lowest_flag[1]},$pct100_consisy_v"  >> ${pct_perf_csv}
	elif [[ "${io_csv}" =~ "mix" ]]; then
	        #kb_job_qd_info=`echo ${io_csv} | sed -r -e 's/.*([0-9]kB).*([0-9]+job_QD[0-9]+).*/\1,\2_mix/g'`
		sorted_read_file=${iocsv_folder}/${io_csv}_sorted_mix_randread.csv
		out_v_read=`grep nvme ${iocsv_folder}/${io_csv}.csv |  awk -F, '{sum += $2} END {printf "NR=%d,Average=%3.3f\n",NR,sum/NR}'`
                sort -n -k 2 -t , ${iocsv_folder}/${io_csv}.csv > ${sorted_read_file}
                avg_v_read=`echo $out_v_read | cut -d , -f2 | cut -d = -f2 | sed 's/\s+//g'`
                length_v=`echo $out_v_read | cut -d , -f1 | cut -d = -f2 | sed 's/\s+//g'`
		pct99_9lowest_pos=`awk 'BEGIN{printf "%.0f\n",'$length_v'/'$pct99_9_pos'}'`
		v_read_99_9lowest=`grep nvme ${sorted_read_file} | sed -n ${pct99_9lowest_pos}p | cut -d , -f2`
		min_read_IOPS=`grep nvme ${sorted_read_file} | head -n 1 | cut -d , -f 2`

		sorted_write_file=${iocsv_folder}/${io_csv}_sorted_mix_randwrite.csv
		out_v_write=`grep nvme ${iocsv_folder}/${io_csv}.csv |  awk -F, '{sum += $3} END {printf "NR=%d,Average=%3.3f\n",NR,sum/NR}'`
                sort -n -k 3 -t , ${iocsv_folder}/${io_csv}.csv > ${sorted_write_file}
                avg_v_write=`echo $out_v_write | cut -d , -f2 | cut -d = -f2 | sed 's/\s+//g'`
                length_v=`echo $out_v_write | cut -d , -f1 | cut -d = -f2 | sed 's/\s+//g'`
		pct99_9lowest_pos=`awk 'BEGIN{printf "%.0f\n",'$length_v'/'$pct99_9_pos'}'`
		v_write_99_9lowest=`grep nvme ${sorted_write_file} | sed -n ${pct99_9lowest_pos}p | cut -d , -f3`
		min_write_IOPS=`grep nvme ${sorted_write_file} | head -n 1 | cut -d , -f 3`
		echo "$avg_v_read,$min_read_IOPS,$v_read_99_9lowest,$avg_v_write,$min_write_IOPS,$v_write_99_9lowest,,,,,,,$type" >> ${iops_perf_consis_dir}/${io_csv}_consis.csv

                pct99_9_consisy_v=`awk 'BEGIN{printf "%.4f%%\n",'100*$v_read_99_9lowest'/'$avg_v_read'}'`
		echo "${io_csv},${kb_job_qd_info}_mix,$type,r,${access_mode},${pct_lowest_flag[0]},$pct99_9_consisy_v"  >> ${pct_perf_csv}
                pct100_consisy_v=`awk 'BEGIN{printf "%.4f%%\n",'100*$min_read_IOPS'/'$avg_v_read'}'`
		echo "${io_csv},${kb_job_qd_info}_mix,$type,r,${access_mode},${pct_lowest_flag[1]},$pct100_consisy_v"  >> ${pct_perf_csv}

                pct99_9_consisy_v=`awk 'BEGIN{printf "%.4f%%\n",'100*$v_write_99_9lowest'/'$avg_v_write'}'`
		echo "${io_csv},${kb_job_qd_info}_mix,$type,w,${access_mode},${pct_lowest_flag[0]},$pct99_9_consisy_v"  >> ${pct_perf_csv}
                pct100_consisy_v=`awk 'BEGIN{printf "%.4f%%\n",'100*$min_write_IOPS'/'$avg_v_write'}'`
		echo "${io_csv},${kb_job_qd_info}_mix,$type,w,${access_mode},${pct_lowest_flag[1]},$pct100_consisy_v"  >> ${pct_perf_csv}
	fi
else
	echo "do nothing"
fi
mv ${iocsv_folder}/*sorted*.csv ${sorted_files_dir}
done
popd

summary_data_dir=`pwd`/`dirname ${iolog_folder}${pct_perf_csv}`
## arrange the sequence of 99.9% lowest and 100% lowest perf following the baidu's performance table
#echo "debug pct_perf_csv  ===================  ${iolog_folder}/${pct_perf_csv}"
sh perf_99_9_100_csv.sh ${iolog_folder}/${pct_perf_csv}


## arrange the sequence of folder \test_data\fio_data_fob.csv and fio_data_ss.csv following the baidu's performance table
#echo "debug iolog_folder  =================== ${iolog_folder} ====================== `pwd`/`dirname ${iolog_folder}${pct_perf_csv}`"
sh sort_fio_data_csv.sh ${iolog_folder} ${summary_data_dir}

## make the baidu_poc_table csv file
## parameter1 = ./U3219141/3.84T_U3219141_ret_111.188/20221109_201251_0_10800/io_csv/perf_consistency/
python baidu_fob_ss_excel.py ${summary_data_dir}

