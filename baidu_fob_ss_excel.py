#!/usr/bin/env python
# -*- coding:utf-8 -*-

import os
import pandas as pd
import sys

if __name__ == '__main__':
    if len(sys.argv) <= 1:
        print("Please input the test iostat data folder")
        exit(0)

    test_data_dir=sys.argv[1]
    work_dir=os.path.dirname(sys.argv[0])
    baidu_poc_table=os.path.join(work_dir,"template_perf_lat.csv")
    print ("test data foler is:",test_data_dir,"\n" "perf_lat file is:", baidu_poc_table)  
    df = pd.read_csv(baidu_poc_table)
    #print(df)
        
    ## create a new csv file following the sequence of template_perf_lat.csv
    ssd_consis_csv="_perf_consistency.csv"
    full_csv_val_list=[]
    vfile_list=os.listdir(test_data_dir)
    for vfile in vfile_list:
        if vfile.__contains__(ssd_consis_csv):
            ssd_sn=vfile.split('_')[0]

    ## fob
    fio_data_csv="fio_data_fob_sorted.csv"
    for vfile in vfile_list:
        if vfile.__contains__(fio_data_csv):
            v128k_seq_fob_bw = pd.read_csv(os.path.join(test_data_dir,vfile))
            col_list=[0,1,2,3]
            for id in col_list:
                full_csv_val_list.append(v128k_seq_fob_bw["Bandwidth(MB/s)"][id])
            kiops_random_fob_8k_4k = pd.read_csv(os.path.join(test_data_dir,vfile))
            col_list=[4,5,6,7,8,9,10,11]
            for id in col_list:
                full_csv_val_list.append(kiops_random_fob_8k_4k["IOPS"][id]/1000)
    ## ss
    fio_data_csv="fio_data_ss_sorted_throughput_iops.csv"
    for vfile in vfile_list:
        if vfile.__contains__(fio_data_csv):
            v128k_seq_ss_bw = pd.read_csv(os.path.join(test_data_dir,vfile))
            col_list=[0,1]
            for id in col_list:
                full_csv_val_list.append(v128k_seq_ss_bw["Bandwidth(MB/s)"][id])
                  
            kiops_random_ss_8k_4k = pd.read_csv(os.path.join(test_data_dir,vfile))
            col_list=[2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17]
            for id in col_list:
                full_csv_val_list.append(kiops_random_ss_8k_4k["IOPS"][id]/1000)
    

    ## fob - 128k BW consistency
    fio_data_csv="1job_256qd_128qd_fob.csv"
    for vfile in vfile_list:
        if vfile.__contains__(fio_data_csv):
            v128k_seq_fob_bw_consis = pd.read_csv(os.path.join(test_data_dir,vfile))
            col_list=[0,1,2,3,4,5,6,7]
            for id in col_list:
                full_csv_val_list.append(v128k_seq_fob_bw_consis["val"][id])

    ## fob - 8k IOPS consistency read
    fio_data_csv="8kB_4job_QD64_fob.csv"
    for vfile in vfile_list:
        if vfile.__contains__(fio_data_csv):
            v8k_random_fob_iops_consis = pd.read_csv(os.path.join(test_data_dir,vfile))
            col_list=[0,1]
            for id in col_list:
                full_csv_val_list.append(v8k_random_fob_iops_consis["val"][id])

    ## fob - 4k IOPS consistency
    fio_data_csv="4kB_4job_QD64_fob.csv"
    for vfile in vfile_list:
        if vfile.__contains__(fio_data_csv):
            v4k_random_fob_iops_consis = pd.read_csv(os.path.join(test_data_dir,vfile))
            col_list=[0,1]
            for id in col_list:
                full_csv_val_list.append(v4k_random_fob_iops_consis["val"][id])

    ## fob - 8k IOPS consistency mix-rw73 -read write 
    col_list=[2,3,4,5]
    for id in col_list:
        full_csv_val_list.append(v8k_random_fob_iops_consis["val"][id])

    ## fob - 4k IOPS consistency mix
    col_list=[2,3,4,5]
    for id in col_list:
        full_csv_val_list.append(v4k_random_fob_iops_consis["val"][id])

    ## ss - 128k BW consistency
    fio_data_csv="128k_1job_256qd_128qd_ss.csv"
    for vfile in vfile_list:
        if vfile.__contains__(fio_data_csv):
            v128k_seq_ss_bw_consis = pd.read_csv(os.path.join(test_data_dir,vfile))
            col_list=[0,1,2,3]
            for id in col_list:
                full_csv_val_list.append(v128k_seq_ss_bw_consis["val"][id])

    ## ss - 8k IOPS consistency
    fio_data_csv="8kB_4job_QD64_ss.csv"
    for vfile in vfile_list:
        if vfile.__contains__(fio_data_csv):
            v8k_random_ss_iops_consis = pd.read_csv(os.path.join(test_data_dir,vfile))
            col_list=[0,1]
            for id in col_list:
                full_csv_val_list.append(v8k_random_ss_iops_consis["val"][id])

    ## fob - 8k IOPS consistency write #56 57
    col_list=[6,7]
    for id in col_list:
        full_csv_val_list.append(v8k_random_fob_iops_consis["val"][id])

    ## ss - 8k IOPS consistency: write rw7/3_write rw7/3_read
    fio_data_csv="8kB_4job_QD64_ss.csv"
    col_list=[2,3,4,5,6,7]
    for id in col_list:
        full_csv_val_list.append(v8k_random_ss_iops_consis["val"][id])

    ## ss - 4k IOPS consistency: read
    fio_data_csv="4kB_4job_QD64_ss.csv"
    for vfile in vfile_list:
        if vfile.__contains__(fio_data_csv):
            v4k_random_ss_iops_consis = pd.read_csv(os.path.join(test_data_dir,vfile))
            col_list=[0,1]
            for id in col_list:
                full_csv_val_list.append(v4k_random_ss_iops_consis["val"][id])

    ## fob - 4k IOPS consistency write
    col_list=[6,7]
    for id in col_list:
        full_csv_val_list.append(v4k_random_fob_iops_consis["val"][id])

    ## ss - 4k IOPS consistency: write and mix
    col_list=[2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23]
    for id in col_list:
        full_csv_val_list.append(v4k_random_ss_iops_consis["val"][id])


     ## ss - latency and qos  fio_data_ss_sorted_latency_qos.csv
    fio_data_csv="fio_data_ss_sorted_latency_qos.csv"
    for vfile in vfile_list:
        if vfile.__contains__(fio_data_csv):
            v8k_4k_random_ss_qos_latency = pd.read_csv(os.path.join(test_data_dir,vfile))
            # 8k latency
            col_list=[0,2,4,5,9,11,13,14]
            for id in col_list:
                full_csv_val_list.append(v8k_4k_random_ss_qos_latency["Mean_lat(us)"][id])
            ## 8k latency 99%
            col_list=[0,2,4,5]
            for id in col_list:
                full_csv_val_list.append(v8k_4k_random_ss_qos_latency["Qos(us) 99%"][id])

            ## 8k qos 1job*128qd
            col_list=[6,7]
            for id in col_list:
                full_csv_val_list.append(v8k_4k_random_ss_qos_latency["Qos(us) 99%"][id])

            # 4k latency
            col_list=[9,11,13,14]
            for id in col_list:
                full_csv_val_list.append(v8k_4k_random_ss_qos_latency["Qos(us) 99%"][id])
            ## 4k qos 99%
            col_list=[10,12,17,18,20,21,22,23,24,25]
            for id in col_list:
                full_csv_val_list.append(v8k_4k_random_ss_qos_latency["Qos(us) 99%"][id])

            ###### 99_9
            ## 8k  latency Qos(us) 99_9% random 1job*1qd 
            col_list=[0,2]
            for id in col_list:
                full_csv_val_list.append(v8k_4k_random_ss_qos_latency["Qos(us) 99_9%"][id])
            
            ## 8k latency  Qos(us) 99_9% sequential 1job*1qd 
            col_list=[4,5]
            for id in col_list:
                full_csv_val_list.append(v8k_4k_random_ss_qos_latency["Qos(us) 99_9%"][id])

            ## 8k  Qos(us) 99_9% random 1job*128qd
            col_list=[1,3]
            for id in col_list:
                full_csv_val_list.append(v8k_4k_random_ss_qos_latency["Qos(us) 99_9%"][id])

            # 4k latency Qos(us) 99_9%
            col_list=[9,11,13,14]
            for id in col_list:
                full_csv_val_list.append(v8k_4k_random_ss_qos_latency["Qos(us) 99_9%"][id])

            ## 4k Qos(us) 99_9%
            col_list=[10,12]
            for id in col_list:
                full_csv_val_list.append(v8k_4k_random_ss_qos_latency["Qos(us) 99_9%"][id])

            # 4k Qos(us) 99_9
            col_list=[17,18,20,21,22,23,24,25]
            for id in col_list:
                full_csv_val_list.append(v8k_4k_random_ss_qos_latency["Qos(us) 99_9%"][id])

            ######  Qos(us) 99_99
            # 8k latency Qos(us) 99_99
            col_list=[0,2,4,5]
            for id in col_list:
                full_csv_val_list.append(v8k_4k_random_ss_qos_latency["Qos(us) 99_99%"][id])

            # 8k Qos(us) 99_99
            col_list=[1,3]
            for id in col_list:
                full_csv_val_list.append(v8k_4k_random_ss_qos_latency["Qos(us) 99_99%"][id])

            # 4k latency Qos(us) 99_99
            col_list=[9,11,13,14]
            for id in col_list:
                full_csv_val_list.append(v8k_4k_random_ss_qos_latency["Qos(us) 99_99%"][id])

            ## 4k Qos(us) 99_99
            col_list=[10,12]
            for id in col_list:
                full_csv_val_list.append(v8k_4k_random_ss_qos_latency["Qos(us) 99_99%"][id])

            # 4k Qos(us) 99_99 4job_8qd
            col_list=[17,18,20,21,22,23,24,25]
            for id in col_list:
                full_csv_val_list.append(v8k_4k_random_ss_qos_latency["Qos(us) 99_99%"][id])

            ######  Qos(us) 99_999
            # 8k latency Qos(us) 99_999
            col_list=[0,2,4,5]
            for id in col_list:
                full_csv_val_list.append(v8k_4k_random_ss_qos_latency["Qos(us) 99_999%"][id])

            # 8k Qos(us) 99_999
            col_list=[1,3]
            for id in col_list:
                full_csv_val_list.append(v8k_4k_random_ss_qos_latency["Qos(us) 99_999%"][id])

            # 4k latency Qos(us) 99_999
            col_list=[9,11,13,14]
            for id in col_list:
                full_csv_val_list.append(v8k_4k_random_ss_qos_latency["Qos(us) 99_999%"][id])

            ## 4k Qos(us) 99_999
            col_list=[10,12]
            for id in col_list:
                full_csv_val_list.append(v8k_4k_random_ss_qos_latency["Qos(us) 99_999%"][id])

            # 4k Qos(us) 99_999 4job_8qd
            col_list=[17,18,20,21,22,23,24,25]
            for id in col_list:
                full_csv_val_list.append(v8k_4k_random_ss_qos_latency["Qos(us) 99_999%"][id])

            ######  Qos(us) 99_9999

            # 8k latency Qos(us) 99_9999
            col_list=[0,2,4,5]
            for id in col_list:
                full_csv_val_list.append(v8k_4k_random_ss_qos_latency["Qos(us) 99_9999%"][id])

            # 8k Qos(us) 99_9999
            col_list=[1,3]
            for id in col_list:
                full_csv_val_list.append(v8k_4k_random_ss_qos_latency["Qos(us) 99_9999%"][id])

            # 4k latency Qos(us) 99_9999
            col_list=[9,11,13,14]
            for id in col_list:
                full_csv_val_list.append(v8k_4k_random_ss_qos_latency["Qos(us) 99_9999%"][id])

            ## 4k Qos(us) 99_9999
            col_list=[10,12]
            for id in col_list:
                full_csv_val_list.append(v8k_4k_random_ss_qos_latency["Qos(us) 99_9999%"][id])

            # 4k Qos(us) 99_9999 4job_8qd
            col_list=[17,18,20,21,22,23,24,25]
            for id in col_list:
                full_csv_val_list.append(v8k_4k_random_ss_qos_latency["Qos(us) 99_9999%"][id])


    print(full_csv_val_list)

    poc_ret_csv="ret_CSD_"+ssd_sn+".csv"
    test_value_csv=os.path.join(test_data_dir,poc_ret_csv)
 
    summary_data=os.path.join(test_data_dir,"baidu_poc_full.csv")

    vHeader="CSD_"+ssd_sn
    DATA = {
    vHeader: full_csv_val_list
    }

save = pd.DataFrame(DATA)
save.to_csv(test_value_csv,sep=',',index=False)

full_csv_list=[baidu_poc_table,test_value_csv]
two_excels=[pd.read_csv(fname) for fname in full_csv_list]
full_df=pd.concat(two_excels)
full_df.to_csv(summary_data)

