#!/bin/bash

# Since I use three clusters, need to do some manual routing here
use_stanford=false
using_clsp=false
using_rockfish=false

if [ -e "/export/c07/wtan12/pycharm/TranSpeech" ]; then
    using_clsp=true
else
    using_rockfish=true
fi

if [ -e "/nlp/scr/chenyuz/TranSpeech" ]; then
  use_stanford=true
  using_clsp=false
  using_rockfish=false
fi

echo "using_clsp: $using_clsp"
echo "using_rockfish: $using_rockfish"
echo "use_stanford: $use_stanford"

project_name="TranSpeech"
project_abbrev="TranSpeech"

if $use_stanford; then
    project_root="/nlp/scr/chenyuz/$project_name"
    fairseq_root="/nlp/scr/chenyuz/exp/fairseq"
    analysis_dir=$project_root/analysis

    exp_dir="/scr-ssd/chenyuz/$project_abbrev"
    data_dir="/scr-ssd/chenyuz/$project_abbrev"
    librispeech_100_dir=/scr-ssd/chenyuz/LibriSpeech/train-clean-100/
    librispeech_360_dir=/scr-ssd/chenyuz/LibriSpeech/train-clean-360/
    # only use 360hr version here
    libritts_dir=/scr-ssd/chenyuz/LibriTTS/
    mustc_dir=/scr-ssd/chenyuz/mustc/
    hf_cache_dir=$exp_dir/hf_cache/
    hubert_ckpt=""
    hubert_quantizer="" # optional for now as we don't use quantized token to prompt llama2
    hubert_repr_dir=$exp_dir/hubert_repr
    clap_repr_dir=$exp_dir/clap_repr
    llama2_ckpt=""
else
    # setup for rockfish
    project_root="/scratch4/pkoehn1/wtan12/pycharm/$project_name"
    analysis_dir=$project_root/analysis
    hf_cache_dir=/data/pkoehn1/wtan12/exp/huggingface
    exp_dir=/data/pkoehn1/wtan12/$project_abbrev
    data_dir=/data/pkoehn1/wtan12/$project_abbrev
    cvss_dir=/data/pkoehn1/wtan12/CVSS/
    public_ckpt_dir=/data/pkoehn1/wtan12/exp/
    mhubert_ckpt=/data/pkoehn1/wtan12/exp/mhubert_base_vp_en_es_fr_it3.pt
    mhubert_quantizer_ckpt=/data/pkoehn1/wtan12/exp/mhubert_base_vp_en_es_fr_it3_L11_km1000.bin

    # not used for now
    hubert_repr_dir=$exp_dir/hubert_repr
    clap_repr_dir=$exp_dir/clap_repr
fi