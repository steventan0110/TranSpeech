module load anaconda
conda activate /scratch4/pkoehn1/wtan12/conda_env/diff
source /scratch4/pkoehn1/wtan12/pycharm/TranSpeech/scripts/diffs2s/global.sh

lang="es"
src_data_dir=$cvss_dir/$lang-en/en
tgt_data_dir=$cvss_dir/$lang-en/$lang

# test hifi-GAN on the ground-truth English units and Spanish/French units


########## TEST on ENGLISH waveform generation ############################
if false; then
  VOCODER_CKPT=$public_ckpt_dir/hifigan_en/hifigan.ckpt
  VOCODER_CFG=$public_ckpt_dir/hifigan_en/config.json
  echo "using vocoder: $VOCODER_CKPT"

  echo "test on en-fr's en portion, with REDUCED unit"
  hyp=$src_data_dir/test.quant.tsv
  output_dir=$exp_dir/vocoder_gen/fr2en/reduce_unit/
  mkdir -p $output_dir
  PYTHONPATH=$project_root python $project_root/examples/speech_to_speech/generate_waveform_from_code.py \
    --in-code-file $hyp --limit 10 \
    --reduce --dur-prediction \
    --vocoder $VOCODER_CKPT --vocoder-cfg $VOCODER_CFG \
    --results-path ${output_dir}


  echo "test on en-fr's en portion, with ORIGNINAL unit"
  output_dir=$exp_dir/vocoder_gen/fr2en/orig_unit/
  mkdir -p $output_dir
  PYTHONPATH=$project_root python $project_root/examples/speech_to_speech/generate_waveform_from_code.py \
    --in-code-file $hyp --limit 10 \
    --vocoder $VOCODER_CKPT --vocoder-cfg $VOCODER_CFG \
    --results-path ${output_dir}
fi

########## TEST on Spanish waveform generation ############################
if true; then
  VOCODER_CKPT=$public_ckpt_dir/hifigan_es/hifigan.ckpt
  VOCODER_CFG=$public_ckpt_dir/hifigan_es/config.json
  echo "using vocoder: $VOCODER_CKPT"

  echo "test on en-fr's en portion, with REDUCED unit"
  hyp=${tgt_data_dir}/test.quant.tsv
  output_dir=$exp_dir/vocoder_gen/en2${lang}/reduce_unit/
  mkdir -p $output_dir
  PYTHONPATH=$project_root python $project_root/examples/speech_to_speech/generate_waveform_from_code.py \
    --in-code-file $hyp --limit 10 \
    --reduce --dur-prediction \
    --vocoder $VOCODER_CKPT --vocoder-cfg $VOCODER_CFG \
    --results-path ${output_dir}


  echo "test on en-fr's en portion, with ORIGNINAL unit"
  output_dir=$exp_dir/vocoder_gen/en2${lang}/orig_unit/
  mkdir -p $output_dir
  PYTHONPATH=$project_root python $project_root/examples/speech_to_speech/generate_waveform_from_code.py \
    --in-code-file $hyp --limit 10 \
    --vocoder $VOCODER_CKPT --vocoder-cfg $VOCODER_CFG \
    --results-path ${output_dir}
fi

