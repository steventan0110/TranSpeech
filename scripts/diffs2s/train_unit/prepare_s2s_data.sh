module load anaconda
conda activate /scratch4/pkoehn1/wtan12/conda_env/diff
source /scratch4/pkoehn1/wtan12/pycharm/TranSpeech/scripts/diffs2s/global.sh


# prorcess en -> other direction
for lang in "es" "fr"; do
for split in "test" "train" "dev"; do
  src_data_dir=$cvss_dir/$lang-en/en
  tgt_data_dir=$cvss_dir/$lang-en/$lang
  VOCODER_CKPT=$public_ckpt_dir/hifigan_${lang}/hifigan.ckpt
  VOCODER_CFG=$public_ckpt_dir/hifigan_${lang}/config.json

  src_quant_file=$src_data_dir/$split.quant.tsv
  tgt_quant_file=$tgt_data_dir/$split.quant.tsv

  src_audio_dir=$src_data_dir/$split
  tgt_audio_dir=$tgt_data_dir/$split



########### EN -> Other Direction, with Reduced Unit ############################
output_dir=$cvss_dir/$lang-en/en2${lang}/reduce_unit/
mkdir -p $output_dir
if [ ! -e $output_dir/$split.tsv ]; then
PYTHONPATH=$project_root python $project_root/examples/speech_to_speech/preprocessing/prep_s2ut_data.py \
  --source-dir $src_audio_dir --ext "wav" \
  --target-file $tgt_quant_file --data-split $split \
  --output-root $output_dir --reduce-unit \
  --vocoder-checkpoint $VOCODER_CKPT --vocoder-cfg $VOCODER_CFG
fi
echo "Finished processing $split en-$lang with reduced unit"



############# Other -> En Direction, with Reduced Unit ############################
other_en_output_dir=$cvss_dir/$lang-en/${lang}2en/reduce_unit/
mkdir -p $other_en_output_dir
if [ ! -e $other_en_output_dir/$split.tsv ]; then
PYTHONPATH=$project_root python $project_root/examples/speech_to_speech/preprocessing/prep_s2ut_data.py \
  --source-dir $tgt_audio_dir --ext "mp3" \
  --target-file $src_quant_file --data-split $split \
  --output-root $other_en_output_dir --reduce-unit \
  --vocoder-checkpoint $VOCODER_CKPT --vocoder-cfg $VOCODER_CFG
fi
echo "Finished processing $split $lang-en with reduced unit"


### Additionally, we also prepared the non-reduced version
output_dir=$cvss_dir/$lang-en/en2${lang}/orig_unit/
mkdir -p $output_dir
if [ ! -e $output_dir/$split.tsv ]; then
PYTHONPATH=$project_root python $project_root/examples/speech_to_speech/preprocessing/prep_s2ut_data.py \
  --source-dir $src_audio_dir --ext "wav" \
  --target-file $tgt_quant_file --data-split $split \
  --output-root $output_dir \
  --vocoder-checkpoint $VOCODER_CKPT --vocoder-cfg $VOCODER_CFG
fi
echo "Finished processing $split en-$lang with original unit"

other_en_output_dir=$cvss_dir/$lang-en/${lang}2en/orig_unit/
mkdir -p $other_en_output_dir
if [ ! -e $other_en_output_dir/$split.tsv ]; then
PYTHONPATH=$project_root python $project_root/examples/speech_to_speech/preprocessing/prep_s2ut_data.py \
  --source-dir $tgt_audio_dir --ext "mp3" \
  --target-file $src_quant_file --data-split $split \
  --output-root $other_en_output_dir \
  --vocoder-checkpoint $VOCODER_CKPT --vocoder-cfg $VOCODER_CFG
fi
echo "Finished processing $split $lang-en with original unit"

exit
done
exit
done


# then for other -> en direction (not running experiments for now)