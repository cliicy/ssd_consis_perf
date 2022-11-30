steps:
1) pushd /f/2022_POC/CSD_3000/poc_data/baidu/fob_ss/QS1.1_QS1.2
2) sh consis_io2csv.sh ./U3219141/3.84T_U3219141_ret_111.188/20221109_201251_0_10800/

192.168.109.137 root/SCALEFLUX_2021

http://192.168.111.63/myrtle-builds/release/rc_4.3.3/vU.3.3@af281b_19535/


sudo nvme fw-download /dev/nvme0n1 --xfer=0x20000 --fw= xxx
sudo nvme fw-activate /dev/nvme0n1 --slot=1 --action=3


https://netorg243736.sharepoint.com/:f:/s/chinas/EpFh6E_vgkxLkqXUMxqhxjABtAn8OE0hLtY63N2BRYG-UA?e=unI4oq

 like 1

CSD3000 3840G-Gen3-Pivo-perf

CSD3000 3840G-Gen3-Pivo-Consis

UAR信息：

[root@localhost 8T]# grep fio sfxperf-test.sh | grep -v "#sudo fio"  |grep -v precondition
  fiotausworthe64=" --random_generator=tausworthe64 "
  fiotausworthe64=""
sudo fio $fiotausworthe64 --percentile_list=10:20:30:40:50:60:70:80:90:99:99.9:99.99:99.999:99.9999:99.99999:99.999999:99.9999999 --thread=1 --ioengine=libaio --direct=1 --norandommap --randrepeat=0 --log_avg_msec=1000 --write_lat_log=4kB_random_write_1job_QD1 --group_reporting --buffer_compress_percentage=$comp_ratio --buffer_compress_chunk=4k --filename=/dev/$d --name=4kB_random_write_1job_QD1 --rw=randwrite --bs=4k --numjobs=1 --iodepth=1 --ramp_time=$ramp_time --time_based --runtime=$runtime --minimal >>fio_data.log
sudo fio $fiotausworthe64 --percentile_list=10:20:30:40:50:60:70:80:90:99:99.9:99.99:99.999:99.9999:99.99999:99.999999:99.9999999 --thread=1 --ioengine=libaio --direct=1 --norandommap --randrepeat=0 --log_avg_msec=1000 --write_lat_log=4kB_random_write_1job_QD1 --group_reporting --buffer_compress_percentage=$comp_ratio --buffer_compress_chunk=4k --filename=/dev/$d --name=4kB_random_write_1job_QD1 --rw=randwrite --bs=4k --numjobs=1 --iodepth=1 --ramp_time=$ramp_time --time_based --runtime=$runtime --minimal >>fio_data.log
sudo fio $fiotausworthe64 --percentile_list=10:20:30:40:50:60:70:80:90:99:99.9:99.99:99.999:99.9999:99.99999:99.999999:99.9999999 --thread=1 --ioengine=libaio --direct=1 --norandommap --randrepeat=0 --log_avg_msec=1000 --write_lat_log=4kB_random_write_1job_QD1 --group_reporting --buffer_compress_percentage=$comp_ratio --buffer_compress_chunk=4k --filename=/dev/$d --name=4kB_random_write_1job_QD1 --rw=randwrite --bs=4k --numjobs=1 --iodepth=1 --ramp_time=$ramp_time --time_based --runtime=$runtime --minimal >>fio_data.log




99.9% & 100% lowest consistency （单位：%）

https://netorg243736.sharepoint.com/:f:/s/chinas/Elq99FZQQ01OsZ3E4uy-I9QBFNQjugxjKmbpOgmsgCqW3Q?e=zcNNKm Summary_cr1to1_2to1




用这个升级方式，这个升级完成，直接就生效了，都不需要reboot

[root@localhost fw]# sfx-status 1



SFX card: /dev/nvme1n1
PCIe Vendor ID:                    0xcc53
PCIe Subsystem Vendor ID:          0xcc53
Manufacturer:                      ScaleFlux
Model:                             CSD-3310
Serial Number:                     UD2214C0114M
OPN:                               CSDU5SPC38M1

[root@localhost fw]# sfx-status 2

SFX card: /dev/nvme2n1
PCIe Vendor ID:                    0xcc53
PCIe Subsystem Vendor ID:          0xcc53
Manufacturer:                      ScaleFlux
Model:                             CSD-3310
Serial Number:                     UD2226D0010H
OPN:                               CSDU5SPC76M1

sudo fio --ramp_time=0 --name=4kB_random_WR_4job_QD128 --filename=/dev/nvme0n1p1 --ioengine=libaio --direct=1 --thread=1 --numjobs=4 --iodepth=128 --rw=randwrite --bs=4k --loops=2 --size=100% --group_reporting

 sudo fio --name=Precondition --filename=/dev/nvme0n1 --ioengine=libaio --direct=1 --thread=1 --numjobs=4 --iodepth=128 --rw=randwrite --bs=4k --size=100% --norandommap=1 --randrepeat=0 --group_reporting --loops=2
 
 

sudo fio --name=Precondition --filename=/dev/nvme0n1 --ioengine=libaio --direct=1 --thread=1 --numjobs=1 --iodepth=128 --rw=randwrite --bs=4k --size=100% --norandommap=1 --randrepeat=0 --group_reporting

sudo fio --name=Precondition --filename=/dev/nvme0n1 --ioengine=libaio --direct=1 --thread=1 --numjobs=1 --iodepth=128 --rw=randwrite --bs=4k --size=100% --norandommap=1 --randrepeat=0 --group_reporting

sudo fio --name=Precondition --filename=/dev/nvme0n1 --ioengine=libaio --direct=1 --thread=1 --numjobs=1 --iodepth=128 --rw=randwrite --bs=4k --runtime=8h --time_based=1 --size=100% --norandommap=1 --randrepeat=0 --group_reporting

random_generator=tausworthe64

25 -15 

eur  2025
