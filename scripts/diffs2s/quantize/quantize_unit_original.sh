module load anaconda
conda activate /scratch4/pkoehn1/wtan12/conda_env/diff
source /scratch4/pkoehn1/wtan12/pycharm/TranSpeech/scripts/diffs2s/global.sh

N_CLUSTERS=1000
TYPE=hubert
CKPT_PATH=$mhubert_ckpt
LAYER=11
KM_MODEL_PATH=$mhubert_quantizer_ckpt
# learn clustering (we directly use a pre-trained cluster model)
#python examples/textless_nlp/gslm/speech2unit/clustering/cluster_kmeans.py \
#    --num_clusters $N_CLUSTERS \
#    --feature_type $TYPE \
#    --checkpoint_path $CKPT_PATH \
#    --layer $LAYER \
#    --manifest_path $MANIFEST \
#    --out_kmeans_model_path $KM_MODEL_PATH


# quantize (inference) with learned clustering on the translated english audio
if false; then
for split in "test" "train" "dev"; do
  for lang in "fr" "es"; do
  data_dir=$cvss_dir/$lang-en/en/$split
  manifest_file=$exp_dir/cvss/$lang-en/$split.en.tsv

  if [ ! -e $manifest_file ]; then
  python $project_root/research/utils/get_manifest.py \
    $data_dir --dest $manifest_file --ext "wav"
  fi
  echo "finished creating manifest file: $manifest_file"

  OUT_QUANTIZED_FILE=$cvss_dir/$lang-en/en/$split.quant.tsv
  if [ ! -e $OUT_QUANTIZED_FILE ]; then
  PYTHONPATH=$project_root python $project_root/examples/textless_nlp/gslm/speech2unit/clustering/quantize_with_kmeans.py \
      --feature_type $TYPE \
      --kmeans_model_path $KM_MODEL_PATH \
      --acoustic_model_path $CKPT_PATH \
      --layer $LAYER \
      --manifest_path $manifest_file \
      --out_quantized_file_path $OUT_QUANTIZED_FILE \
      --extension ".wav"
  fi
  echo "finished quantizing $split $lang with $KM_MODEL_PATH and $CKPT_PATH at layer $LAYER"
done
done
fi

# perform quantization for the original audio
if true; then
for split in "test" "train" "dev"; do
for lang in "es" "fr"; do
  data_dir=$cvss_dir/$lang-en/$lang/$split
  manifest_file=$exp_dir/cvss/$lang-en/$split.$lang.tsv

  if [ ! -e $manifest_file ]; then
  python $project_root/research/utils/get_manifest.py \
    $data_dir --dest $manifest_file --ext "mp3"
  fi
  echo "finished creating manifest file: $manifest_file"

  OUT_QUANTIZED_FILE=$cvss_dir/$lang-en/$lang/$split.quant.tsv
  if [ ! -e $OUT_QUANTIZED_FILE ]; then
  PYTHONPATH=$project_root python $project_root/examples/textless_nlp/gslm/speech2unit/clustering/quantize_with_kmeans.py \
      --feature_type $TYPE \
      --kmeans_model_path $KM_MODEL_PATH \
      --acoustic_model_path $CKPT_PATH \
      --layer $LAYER \
      --manifest_path $manifest_file \
      --out_quantized_file_path $OUT_QUANTIZED_FILE \
      --extension ".mp3"
  fi
  echo "finished quantizing $split $lang with $KM_MODEL_PATH and $CKPT_PATH at layer $LAYER"
done
done
fi



# train hifi-gan on the quantized features