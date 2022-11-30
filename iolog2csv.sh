iolog_folder=$1
pushd $iolog_folder

iocsv_folder=io_csv
if [[ ! -d $iocsv_folder ]]; then
mkdir $iocsv_folder
fi

iolog_list=`ls iostat*.log | grep -v precondition`
for io_f in ${iolog_list}
do
#echo ori_file is: $io_f
io_f1=${io_f#*iostat_}
io_csv=${io_f1%.log*}
#echo io_csv_file is: $io_csv
#echo -e "\n"
grep nvme -B 1 $io_f | head -n 1 | sed -r 's/\s+/,/g'> ${iocsv_folder}/${io_csv}.csv
grep nvme $io_f | sed -r 's/\s+/,/g'>> ${iocsv_folder}/${io_csv}.csv
sed -i '2,61 d' ${iocsv_folder}/${io_csv}.csv
done

popd
