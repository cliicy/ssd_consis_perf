pct_perf_csv=$1

consis_header="pattern,bs,jobs*qd,fob/ss,rw,Acess mode,pct,val"
pct_list=(99.9% 100%)

## fob 128k
status=fob
bw_bs_list=(128k)
match_info=1job_256qd
## re-arrange the consis.csv to meet the sequence of Baidu's performance table
for bs in ${bw_bs_list[@]};do
ret_iops_file=`dirname ${pct_perf_csv}`/${bs}_${match_info}_128qd_$status.csv
echo $consis_header > ${ret_iops_file}

## write perf-consistency
for pct in ${pct_list[@]};do
action=write
grep $status ${pct_perf_csv} | grep ${bs} | grep $match_info | grep ${action} | grep ${pct} >> ${ret_iops_file}
done

match_info=1job_128qd
## read perf-consistency
for pct in ${pct_list[@]};do
action=read
grep $status ${pct_perf_csv} | grep ${bs} | grep $match_info | grep ${action} | grep ${pct} >> ${ret_iops_file}
done

## mix perf-consistency
match_info=1job_256qd
action_list=(,r, ,w,)
type_list=(mix)
for type in ${type_list[@]};do
for action in ${action_list[@]};do
for pct in ${pct_list[@]};do
grep $status ${pct_perf_csv} | grep ${bs} | grep $match_info | grep $type |  grep ${action} | grep ${pct} >> ${ret_iops_file}
done
done
done

done

## fob 8kB and 4kB
bs_list=(8kB 4kB)
match_info=4job_QD64
## re-arrange the consis.csv to meet the sequence of Baidu's performance table
for bs in ${bs_list[@]};do
ret_iops_file=`dirname ${pct_perf_csv}`/${bs}_${match_info}_$status.csv
echo $consis_header > ${ret_iops_file}

## read perf-consistency
for pct in ${pct_list[@]};do
action=read
grep $status ${pct_perf_csv} | grep ${bs} | grep $match_info | grep ${action} | grep ${pct} | grep -v mix >> ${ret_iops_file}
done


## mix perf-consistency
action_list=(,r, ,w,)
type_list=(mix)
for type in ${type_list[@]};do
for action in ${action_list[@]};do
for pct in ${pct_list[@]};do
grep $status ${pct_perf_csv} | grep ${bs} | grep $match_info | grep $type |  grep ${action} | grep random,${pct} >> ${ret_iops_file}
done
done
done

## write perf-consistency
for pct in ${pct_list[@]};do
action=write
grep $status ${pct_perf_csv} | grep ${bs} | grep $match_info | grep ${action} | grep ${pct} >> ${ret_iops_file}
done

done

## ss 128k
status=ss
bw_bs_list=(128k)
match_info=1job_256qd
## re-arrange the consis.csv to meet the sequence of Baidu's performance table
for bs in ${bw_bs_list[@]};do
ret_iops_file=`dirname ${pct_perf_csv}`/${bs}_${match_info}_128qd_$status.csv
echo $consis_header > ${ret_iops_file}

## write perf-consistency
for pct in ${pct_list[@]};do
action=write
grep $status ${pct_perf_csv} | grep ${bs} | grep $match_info | grep ${action} | grep ${pct} >> ${ret_iops_file}
done

match_info=1job_128qd
## read perf-consistency
for pct in ${pct_list[@]};do
action=read
grep $status ${pct_perf_csv} | grep ${bs} | grep $match_info | grep ${action} | grep ${pct} >> ${ret_iops_file}
done

done

## ss 8kB and 4kB
bs_list=(8kB 4kB)
match_info=4job_QD64
## re-arrange the consis.csv to meet the sequence of Baidu's performance table
for bs in ${bs_list[@]};do
ret_iops_file=`dirname ${pct_perf_csv}`/${bs}_${match_info}_$status.csv
echo $consis_header > ${ret_iops_file}

## read perf-consistency
for pct in ${pct_list[@]};do
action=read
grep $status ${pct_perf_csv} | grep ${bs} | grep $match_info | grep ${action} | grep ${pct} | grep -v mix >> ${ret_iops_file}
done

## write perf-consistency
for pct in ${pct_list[@]};do
action=write
grep $status ${pct_perf_csv} | grep ${bs} | grep $match_info | grep ${action} | grep ${pct} | grep -v mix >> ${ret_iops_file}
done

## mix perf-consistency
action_list=(,w, ,r,)
type_list=(mix)
for type in ${type_list[@]};do
for action in ${action_list[@]};do
for pct in ${pct_list[@]};do
grep $status ${pct_perf_csv} | grep ${bs} | grep $match_info | grep $type |  grep ${action} | grep ${pct} >> ${ret_iops_file}
done
done
done

if [[  "$bs" == "4kB" ]];then
#echo "debug bs=4kB ========================="
match_info=70-30_4job_QD8
## mix perf-consistency
action_list=(,w, ,r,)
type_list=(mix)
for type in ${type_list[@]};do
for action in ${action_list[@]};do
for pct in ${pct_list[@]};do
grep $status ${pct_perf_csv} | grep ${bs} | grep $match_info | grep $type |  grep ${action} | grep ${pct} >> ${ret_iops_file}
done
done
done

## read perf-consistency
match_info=RD_4job_QD8
## mix perf-consistency
for pct in ${pct_list[@]};do
action=read
grep $status ${pct_perf_csv} | grep ${bs} | grep $match_info | grep ${action} | grep ${pct} >> ${ret_iops_file}
done

match_info=30-70_4job_QD8
## mix perf-consistency
action_list=(,w, ,r,)
type_list=(mix)
for type in ${type_list[@]};do
for action in ${action_list[@]};do
for pct in ${pct_list[@]};do
grep $status ${pct_perf_csv} | grep ${bs} | grep $match_info | grep $type |  grep ${action} | grep ${pct} >> ${ret_iops_file}
done
done
done

match_info=17-83_4job_QD8
## mix perf-consistency
action_list=(,w, ,r,)
type_list=(mix)
for type in ${type_list[@]};do
for action in ${action_list[@]};do
for pct in ${pct_list[@]};do
grep $status ${pct_perf_csv} | grep ${bs} | grep $match_info | grep $type |  grep ${action} | grep ${pct} >> ${ret_iops_file}
done
done
done

## write perf-consistency
match_info=WR_4job_QD8
for pct in ${pct_list[@]};do
action=write
grep $status ${pct_perf_csv} | grep ${bs} | grep $match_info | grep ${action} | grep ${pct} >> ${ret_iops_file}
done

fi	
done
