#!/usr/bin/env python3
import argparse
import glob
import os
import soundfile
import shutil

def get_parser():
    parser = argparse.ArgumentParser()
    parser.add_argument("--data-dir", type=str, default=None)
    return parser

def main(args):
    data_dir = args.data_dir

    # obtain all relevant en audio files
    for lang in ["es", "fr"]:
        non_exist = 0
        all_files = set()
        for split in ["train", "dev", "test"]:
            output_dir = f"{data_dir}/{lang}-en/{lang}/{split}"
            os.makedirs(output_dir, exist_ok=True)
            file = f"{data_dir}/{lang}-en/en/{split}.tsv"
            with open(file, "r") as f:
                for line in f:
                    audio_file = line.split("\t")[0]
                    audio_file = audio_file.strip()
                    all_files.add(audio_file)
                    audio_path = f"{data_dir}/{lang}-en/{lang}/clips/{audio_file}"
                    if not os.path.exists(audio_path):
                        raise RuntimeError(f"File {audio_path} does not exist")
                    # cp into new file
                    file_to_save = f"{output_dir}/{audio_file}"
                    shutil.copyfile(audio_path, file_to_save)
        break

if __name__ == "__main__":
    parser = get_parser()
    args = parser.parse_args()
    main(args)
